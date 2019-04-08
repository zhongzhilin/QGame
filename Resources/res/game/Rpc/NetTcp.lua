
local tcp     = require "util.sockettcp"
local msgpack = require "msgpack"
local datetime = require "datetime"
require 'zlib'


local NetTcp = {
    mconn = nil,
    mhost = "",
    mport = 0,
    menc  = nil,
    
    mconf = {
        tick_time = 0.02,    -- tcp 收包轮询时间 单位：秒
        reconnect_time = 1,  -- tcp 重连时间 单位：秒
        fail_time = 6,       -- tcp 连接超时时间 单位:秒 
    },
    
    mevent_handler = {},   
    mhandler = {
        handler_connected = function(conn) assert(false) end,
        handler_closed = function(conn) assert(false) end,
        handler_close = function(conn) assert(false) end,
        handler_failed = function(conn) assert(false) end,
        handler_msg = function(conn) assert(false) end,
    },
    
    mconnected = false,
    mrecvbuf = "",
    mhead_recv = nil,
    mmsg_queue = {},
    
    mstat_failedn = 0,
    mstat_sendn = 0,
    mstat_recvn = 0,
    mstat_alltime = 0,
    mstat_maxt = 0,
    mstat_mint = 0,
    mstat_closed = 0,
}

function NetTcp.new()
    local instance = {}
    instance = setmetatable(instance, {__index = NetTcp })
    ------------------------------------
    for k,v in pairs(NetTcp) do
        local vt = type(v)
        if vt ~= "function" then
            if vt == "table" then
                instance[k] = clone(v)
            else
                instance[k] = v
            end
        end
    end
    ------------------------------------
    return instance
end

function NetTcp:Init(conf, addr, hdl)
    if conf ~= nil then
        self.mconf = conf
    end
    
    if hdl ~= nil then
        self.mhandler = hdl
    end
    
    self.mconnected = false
    assert(self.mhandler.handler_connected)
    assert(self.mhandler.handler_closed)
    assert(self.mhandler.handler_failed)
    assert(self.mhandler.handler_msg)
    
    self.mhost = addr.host
    self.mport = addr.port
    
    self.mevent_handler[tcp.EVENT_DATA] = self._on_data
    self.mevent_handler[tcp.EVENT_CLOSE] = self._on_close
    self.mevent_handler[tcp.EVENT_CLOSED] = self._on_closed
    self.mevent_handler[tcp.EVENT_CONNECTED] = self._on_connected
    self.mevent_handler[tcp.EVENT_CONNECT_FAILURE] = self._on_failed
end

function NetTcp:Connect()
    
    if self.mconn == nil then
        
        local on_tcp_event = function(ev, dt)
               log.debug("on net tcp event: %s", ev)
           -- if ev ~= "data" then
           --     log.debug("on net tcp event: %s", ev)
           -- end 
            local func = self.mevent_handler[ev]
            if func ~= nil then
                func(self, dt)
            else
                assert(false, "invalid tcp event:" .. ev)
            end     
        end
    
        self.mconn = tcp.new(self.mhost , self.mport, on_tcp_event, false)
        self.mconn:setReconnTime(self.mconf.reconnect_time)
        self.mconn:setTickTime(self.mconf.tick_time)
        self.mconn:setConnFailTime(self.mconf.fail_time)
        self.mconn:connect()

    else
        self.mconn:connect()
    end    
end

-- rpc = { 
--     sesid = ses, 
--     typ = "rpc", 
--     req = {
--         mod = mod,
--         method = method,
--         params = args,
--     }, 
--     msg = msg, 
--     cb = {
--         func = netrspcb
--     }, 
--     rsp = {m={}, h={}}, st = RPC_STATE.RPC_INIT, tm = datetime.utc() 
-- }
function NetTcp:Send(msg, sesid, msgtype, isRepeat)
    if self:IsConnected() == false then
        return
    end
    
    local csmsg = { 
        head = {
            Sign1 = 0xee,                       --uint32 包头标志 0xeeeeffff 定值
            Sign2 = 0xee,                       --uint32 包头标志 0xeeeeffff 定值
            Sign3 = 0xff,                       --uint32 包头标志 0xeeeeffff 定值
            Sign4 = 0xff,                       --uint32 包头标志 0xeeeeffff 定值
            Type = WPBCONST[msgtype],           --uint32  消息类型 wcodepb中定义
            LinkNum = 0,                        --uint32 连接编号  固定值网关使用
            Len = 0,                            --uint32 整个消息包的最终实际长度（包括包头）
            Crypt = 1,                          --uint32  加密类型
            OriginLen = 0,                      --uint32 消息体原始长度，不包括消息包头
        }, 
        pkg = msg,
        msgtype = msgtype,
        seq = sesid,
    }
    local databuf = msgpack.pkg_pack(csmsg, self:_get_enc(), isRepeat)
    if databuf == nil then
        log.error("NetTcp:Send failed to pack csmsg")
        return
    end
        
    local startTime = datetime.clock()
    local rt = self.mconn:send(databuf)
    log.trace("#############NetTcp:Send,msgtype=%s,sesid=%s,rt=%s",msgtype,sesid,rt)
    local endTime = datetime.clock()
    log.info("+++ send:%s, %s, total %s", sesid, endTime, endTime - startTime)
    if rt == nil then
    elseif rt == "timeout" then
    elseif rt == "closed" then
    else
        return true
    end
    return false
end

function NetTcp:Recv()
    self.mconn:recv()
end

function NetTcp:SetEnc(enc)
    self.menc = enc
end

function NetTcp:Debug()
    log.debug("tcp conn:%s,%s h:%s:%s", self.mconn, self.mconnected, self.mhost, self.mport)
    if self.mconn then
        self.mconn:Debug()
    end
end

function NetTcp:checkConnect()
    return self.mconn:checkConnect()  
end

function NetTcp:IsConnected()
    return self.mconn ~= nil and self.mconnected == true
end

function NetTcp:Close()
    if self.mconn then
        self.mconn:close()
    end
    
    self.mconn = nil
    self.mmsg_queue = {}
    self.mrecvbuf = ""
    self.mhead_recv = nil
    self.mconnected = false
    
    self.mhost = ""
    self.mport = 0
end

function NetTcp:_get_enc()
    return self.menc
end

-- 解析包体 对别人开放的
function NetTcp:packBodyForOuter(binaryText,i_unpackStruct)
    local csmsg = {}
    csmsg.head = {Crypt=3,Type=4097}
    csmsg.unpackStruct = i_unpackStruct
    csmsg.pkg={}
    local databuf = binaryText
    csmsg.pkg.param = string.hex2bin( databuf )
    
    local iret, i_csmsg = msgpack.unpack_body(csmsg, self:_get_enc())
    if iret ~= WCODE.OK then
        log.error("NETLOG msg unpack failed:%d", iret)
        if iret == WCODE.ERR_PKG_UNPACK_PBDEC_ERR then
        end
    end
    dump(i_csmsg)
    if i_csmsg then 
        return i_csmsg.pkg.param
    end
end

local error_unpackpb_times = 0
function NetTcp:_on_data(dt)
    local startTime = datetime.clock()
    -- log.debug("on socket data recv, len:%d", #dt.data)   
    self.mrecvbuf = self.mrecvbuf .. dt.data
    
    while true do
        local recvlen = #self.mrecvbuf
        if recvlen <= msgpack.HQPAC_BINHD_LEN then
            --继续收
            -- log.debug("continue read 1:%s", recvlen)
            break
        end

        if self.mhead_recv == nil then

            -- log.debug("_on_data:%s,len:%s",string.hex(self.mrecvbuf),#self.mrecvbuf)
            local ret, hdpkg, hdlen = msgpack.unpack_head(self.mrecvbuf)
            if ret ~= WCODE.OK then
                -- 收到错误的包数据 重置
                self.mrecvbuf = ""
                self.mhead_recv = nil
                -- log.debug("error read 1")
                break
            end

            self.mhead_recv = hdpkg 
            if hdlen == 0 then
                -- 继续收
                -- log.debug("continue read 2")
                break
            end        
        end
        
        local pkglen = self.mhead_recv.head.Len
        if pkglen > recvlen then
            -- 包未收完 继续收
            break
        end    
            
        -- 收完包头收包体
        local databuf = self.mrecvbuf
        local csmsg = self.mhead_recv
        log.debug("len:%s",#databuf)
        csmsg.pkg.param = string.sub(databuf, msgpack.HQPAC_BINHD_LEN+1, pkglen)
        
        self.mrecvbuf = string.sub(databuf, pkglen+1)
        self.mhead_recv = nil
        local iret, csmsg = msgpack.unpack_body(csmsg, self:_get_enc())
        if iret ~= WCODE.OK then
            log.error("NETLOG msg unpack failed:%d", iret)
            if iret == WCODE.ERR_PKG_UNPACK_PBDEC_ERR then
                error_unpackpb_times = error_unpackpb_times + 1
                if error_unpackpb_times > 1 then
                    -- 大于一次-》认为服务器异常导致的解包失败
                    -- global.tipsMgr:showQuitConfirmPanel(false,"UIMaintancePanel")
                    global.tipsMgr:showQuitConfirmPanelNoClientNet()
                else
                    -- 服务器已经关闭 --临时处理
                    global.netRpc:errorConnectShow()
                end

            end
        else
            error_unpackpb_times = 0
            table.insert(self.mmsg_queue, csmsg)
            -- log.debug("new msg recv")
            -- local varstr = vardump(csmsg)
            -- log.debug("%s",varstr)
        end
    end    
    local endTime = datetime.clock()
    -- log.info("+++ recv time %s, total %s", endTime, endTime - startTime)
    
    -- 直接处理收到的消息
    self:_msg_loop()
end

function NetTcp:_on_connected()
    self.mrecvbuf = ""
    self.mhead_recv = nil
    self.mstat_failedn = 0
    self.mconnected = true
    
    local st, result = pcall(self.mhandler.handler_connected, self)
    if not st then 
        log.error("tcp connected event call failed:%s", result)
    end
end

function NetTcp:_on_closed()
    self.mconnected = false
    
    local st, result = pcall(self.mhandler.handler_closed, self)
    if not st then 
        log.error("tcp closed event call failed:%s", result)
    end     
end

function NetTcp:_on_close()
    self.mconnected = false
    
    local st, result = pcall(self.mhandler.handler_close, self)
    if not st then 
        log.error("tcp close event call failed:%s", result)
    end  
end

function NetTcp:_on_failed()
    self.mconnected = false
    
    local st, result = pcall(self.mhandler.handler_failed, self)
    if not st then 
        log.error("tcp failed event call failed:%s", result)
    end     
end

function NetTcp:_msg_loop()
    for _, csmsg in pairs(self.mmsg_queue) do
        local st, result = pcall(self.mhandler.handler_msg, self, csmsg)
        if not st then 
            local msgtype = csmsg.msgtype or "INVALID"
            log.info("tcp rsp call:%s failed:%s", msgtype, result)
        end
    end
    
    self.mmsg_queue = {}
end

return NetTcp



local msgpack = require "msgpack"
local crypto  = require "hqgame"
local pbpack  = require "pbpack"
local json    = require "json"
local mpack   = cmsgpack
local datetime = require "datetime"
local NetTcp   = require "game.Rpc.NetTcp"
local zlib     = require "zlib"

local gevent = gevent

local RPC_STATE = {
    RPC_INIT      = 1,
    RPC_WAIT      = 2,
    RPC_DONE      = 3,
    RPC_TIMEOUT   = 4,
}

local SES_MIN_LOGIC  = 0
local SES_MAX_LOGIC  = 99999999
local SES_MIN_SYSTEM = 100000000

local showTimes = 0
local sesids = {}
local showConnect = function(noModal,sesid)
    -- if noModal and noModal ~= 1 then
    --     return
    -- end
    sesid = sesid or -1
    showTimes = showTimes+1
    sesids[sesid] = true
    print("--------------》showTimes=="..showTimes)
    if showTimes>0 then
        local panel = global.panelMgr:openPanel("ConnectingPanel")
        if noModal and noModal == 1 then
            -- 取消点击屏蔽和转圈特效
            panel:closeNetForbid()
        elseif noModal and noModal == 2 then
            -- 取消点击屏蔽和按钮屏蔽
            panel:closeNetForbid()
        end
    end
--  log.debug(debug.traceback())
end

local hideConnect = function(noCount,sesid)
    sesid = sesid or -1
    if noCount then
        sesids = {}
        global.panelMgr:closePanel("ConnectingPanel")
    else
        if not sesids[sesid] then
            return
        end
        sesids[sesid] = nil
        showTimes = showTimes-1

        print("--------------》hideConnect=="..showTimes)
        if showTimes<=0 then
            showTimes = 0
            sesids = {}
            global.panelMgr:closePanel("ConnectingPanel")
        end
    end
--    log.debug(debug.traceback())
end

local function showAlert(title, content, btn, altFun)
    -- local data = {
    --         title = title, 
    --         content = content, 
    --     }
    -- local createData = function(index)
    --     return {
    --         name = btn[index],
    --         handler = function() altFun({ buttonIndex = index }) end,
    --     }
    -- end
    -- if #btn == 1 then
    --     data.pvpnotify = createData(1)
    -- elseif #btn == 2 then
    --     data.confirm = createData(1)
    --     data.cancel = createData(2)
    -- end        
    
    -- hideConnect()
    -- global.panelMgr:openPanel("UISystemMessagePanel"):setData(data)

    -- global.tipsMgr:showWarningText(content)
    if altFun then altFun({ buttonIndex = 1 }) end
end

--
local NetRpc = {
    mnet = nil,
    menc = nil,
    maccid = 0,
    mlogin = false,     -- 是否已经登陆
    minited = false,    -- 是否已经初始化
    mcan_relogin = false, -- 是否可以重连了
    mneed_relogin = false, --是否需要重新连接
    mkicked = false,
    mlast_returned = true,
    mzone = { host = "", port = 0, net = "tcp" },
    mplat = { chanid = 0, openid = "", openkey = "", hqtoken = "", tmexpire = 0 },

    mses_logic = SES_MIN_LOGIC,     
    mses_system = SES_MIN_SYSTEM,   
    
    mqueue = {},    --收包map
    mqueue_baker = {},
    mtimer_rpc = nil,
    mtimer_hbt = nil,
    mtimer_uibt= nil, --游戏中每一秒触发定时器
    mtimer_curr_fps = 0,
    
    mtick_rpc = 0.1,
    mtick_hbt = 120,
    mtimeout = 20, -- 秒
    mtimeout_fps = 100, -- 单位帧10/0.1
    
    mrqqueue = {}, -- 上个包未返回期间的包缓存
    mrqcache = {}, -- 重连期间的包缓存
    mnosendcache = {}, -- 客户端没有发出去的包缓存
    
    merr_checksum = {},
    merr_nums = 0,
    is_reconnecting = false,

    mses_recon_map = {},

    -- m_reconnectDelayTimes = 0 --后台切回来之后重连期间发生转圈的次数
    -- m_reconnectSt = 0 --持续时间
}

local lastNetState = 0
function NetRpc:Init()  
    if self.minited == true then
        return 
    end
    
    msgpack.init()  
    
    self:SetEnc(msgpack.get_bddef_enc())

    self:Start()

    self.minited = true
end

function NetRpc:resetModelState()
    hideConnect(true)
    showTimes = 0
end

function NetRpc:Start()
    self.mses_logic = SES_MIN_LOGIC
    self.mses_system = SES_MIN_SYSTEM
    self.mses_recon_map = {}
    if self.mtimer_rpc then
        gscheduler.unscheduleGlobal(self.mtimer_rpc)
    end
    self.mtimer_curr_fps = 0
    self.mtimer_rpc = gscheduler.scheduleGlobal(function() self:_handle_loop() end, self.mtick_rpc)
end

function NetRpc:KickOut()
    self.mkicked = true
    self:Close()
end

function NetRpc:GetHost()
    return self.mzone.host
end

function NetRpc:SendRQCache()
    local temp = self.mrqcache
    -- log.error("------>NetRpc:SendRQCache() self.mrqcache=%s",vardump(self.mrqcache))
    self.mrqcache = {}
    for _, rpc in ipairs(temp or {}) do
        -- log.trace("SendRQCache self.mrqcache send cache %s", vardump(rpc))
        if rpc.req.mtype and rpc.req.mtype == "HeartBeatReq" then
            --心跳不需要补发
        else
            self:_send_req(rpc)
        end
    end
end

function NetRpc:ClearRQCache()
    local temp = self.mrqcache
    -- log.error("------>NetRpc:ClearRQCache() self.mrqcache=%s",vardump(self.mrqcache))
    self.mrqcache = {}

    -- log.debug("===========> ClearRQCache %s", vardump(temp))

    for _, rpc in ipairs(temp) do
        -- log.debug("ClearRQCache callBack ERR_RPC_TIMEOUT %s, %s.%s", rpc.sesid, rpc.msg.mod, rpc.msg.method)
        rpc.st = RPC_STATE.RPC_INIT
        local st, reserr = pcall(rpc.cb.func, {retcode = WCODE.ERR_RPC_TIMEOUT})
        if st == false then
            log.debug("rpc timeout exec failed: %s", reserr or "")
        end
    end
end

function NetRpc:HasRQCache()
    return #self.mrqcache > 0
end

function NetRpc:DialGameSvr(auth, zonecfg, okcall, isRelogin)
    self.mplat = auth or self.mplat
    self.maccid = self.mplat.accid or self.maccid
    self.mzone = zonecfg or self.mzone

    local isClientNet,netState = self:checkClientNetAvailable()
    lastNetState = netState
    
    if self.mnet ~= nil then
        log.debug("!ERROR! DialGameSvr need close connect first.")
        self:Close()
        self:DialGameSvr(auth, zonecfg, okcall,isRelogin)
        return
    end
    
    local handler = {        
        handler_connected = function(mnet) 
            if mnet == self.mnet then
                log.debug("game connection ok")
                self:Login(okcall,isRelogin)
            else
                mnet:Close()
                if okcall then 
                    okcall(true)
                else
                    self:errorConnectShow()
                end
            end
        end,
        
        handler_closed = function(mnet)
            if mnet == self.mnet then
                log.debug("game connection closed")
                self:Close()
            end
        end,
        
        handler_failed = function(mnet)
            if mnet == self.mnet then
                log.debug("game connection failed")
                self:Close()
                hideConnect(true)
                if not self:HasRQCache() then
                else
                    self:ClearRQCache()
                end

                self:errorConnectShow()
                if okcall then okcall() end
            end
        end,
        
        handler_msg = function(mnet, csmsg)
            if mnet == self.mnet then
                log.trace("game connection recved msg")
                self:_proc_msg(csmsg)
            else
                mnet:Close()
                self:errorConnectShow()
            end
        end
    }
    log.debug("DialGameSvr: %s:%s", self.mzone.host, self.mzone.port)
    
    self.mnet = NetTcp.new()
    self.mnet:Init(self.mtcp_conf, self.mzone, handler)
    self.mnet:Connect()
end

function NetRpc:checkClientNetWithError()
    -- 在登陆界面时
    local isClientNet,netState = self:checkClientNetAvailable()
    if not isClientNet then
        global.tipsMgr:showQuitConfirmPanelNoClientNet()
    end
    return isClientNet
end
-- 网络连接问题
function NetRpc:errorConnectShow(isReconnect)
    -- 登录进入
    if global.scMgr:isLoginScene() then
        global.tipsMgr:showQuitConfirmPanelNoClientNet()
    else
        local isClientNet,netState = self:checkClientNetAvailable()
        if not isClientNet then
            -- 客户端网络不通畅
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        else
            -- 服务器gameserver关掉了，防止递归
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        end
    end

end

function NetRpc:Login(okcall,isRelogin)
    
    self:SetEnc(msgpack.get_bddef_enc())

    local cli_pub, cli_pri = crypto.ecdhKey()
    local new_enc = {}
    
    local on_shakeok = function(code, msg, head)
        
        log.debug("crypto connection ok!!!!!!")
            
        if self.mlogin == false then
            self.mlogin = true
        end
        -- 触发心跳
        local call = function() 
            if self.mtimer_hbt ~= nil then
                gscheduler.unscheduleGlobal(self.mtimer_hbt)
                self.mtimer_hbt = nil
            end
            self.mtimer_hbt = gscheduler.scheduleGlobal(function()
                self:_heart_beat()
            end, self.mtick_hbt)
            
            self:_heart_beat()

            -- 用于与心跳同步的ui触发定时器
            if self.mtimer_uibt ~= nil then
                gscheduler.unscheduleGlobal(self.mtimer_uibt)
                self.mtimer_uibt = nil
            end
            self.mtimer_uibt = gscheduler.scheduleGlobal(function()
                self:_heart_beatUI()
            end, 1)
            self:_heart_beatUI()
                
            self:SendRQCache()
            if not self.mcan_relogin then
                self.mcan_relogin = true
            end
            if okcall then okcall(true) end
        end

        -- if not noNeedLogin then
            local loginProc = require "game.Login.LoginProc"
            loginProc.startLogin(call,isRelogin)
        -- else
        --     --ip地址变化需要重新登陆
        --     local callBB = function(ret, msg)        
        --         if ret.retcode == WCODE.OK then
        --         elseif ret.retcode == 2 then
        --         end
        --     end 
        --     global.loginApi:loginGame(callBB)
        -- end
        -- gevent:call(global.gameEvent.EV_ON_LOGIN_SERVER_DONE,call)
    end
    on_shakeok()
end

function NetRpc:NewMsg(msgtype)
    return msgpack.newmsg(msgtype)
end

function NetRpc:SetEnc(enc)
    self.menc = enc
    if self.mnet then
        self.mnet:SetEnc(enc)
    end
end

function NetRpc:Secret()
    return self.menc.key
end

function NetRpc:Close()
    print("------->NetRpc:Close()")
    if self.mnet == nil then
        return
    end
    self.mnet:Close()
    self.mnet = nil

    if self.mtimer_hbt ~= nil then
        gscheduler.unscheduleGlobal(self.mtimer_hbt)
        self.mtimer_hbt = nil
    end

    if self.mtimer_uibt ~= nil then
        gscheduler.unscheduleGlobal(self.mtimer_uibt)
        self.mtimer_uibt = nil
    end
    
    -- self.mses_logic = SES_MIN_LOGIC
    -- self.mses_system = SES_MIN_SYSTEM
    -- self.mqueue = {}
    -- self.maccid = 0
    self:ClearAll()
    self.mlogin = false
    self.mlast_returned = true
end

function NetRpc:ClearAll()
    -- body
    self.mqueue_baker = {}
    local rqData = {}
    for sesid,v in pairs(self.mqueue) do
        if v.st ~= RPC_STATE.RPC_INIT and v.st ~= RPC_STATE.RPC_WAIT and not self.mnosendcache[i] then
            self.mqueue_baker[sesid] = clone(v)
        else
            --没有发出去的包不备份
            table.insert(rqData,clone(v))
        end
    end
    self:putMrqcache(rqData)

    self.mqueue = {}
    self:putMrqcache(clone(self.mrqqueue))
    self.mrqqueue = {}
    self.mnosendcache = {}

    self.mtimer_curr_fps = 0
    -- log.trace("----->netRpc:ClearAll-->self.mqueue_baker=%s",vardump(self.mqueue_baker))
end

function NetRpc:putMrqcache(data)
    local i_data = data or {}
    for i,v in pairs(i_data) do
        table.insert(self.mrqcache,v)
    end
    -- log.trace("----->netRpc:putMrqcache-->data=%s,self.mrqcache=%s",vardump(i_data),vardump(self.mrqcache))
end

function NetRpc:exitClean()
    -- body
    self:Close()
    self.mcan_relogin = false
    self.mkicked = true

    if self.mtimer_rpc then
        gscheduler.unscheduleGlobal(self.mtimer_rpc)
    end
    self.mqueue = {}
    self.mqueue_baker = {}
    self.mrqqueue = {}
    self.mnosendcache = {}
end
---
-- @param url
-- @param action
-- @param callback
-- @param params {header, cookie, data={dtype, ...}}
-- @return

function NetRpc:HttpCall(url, action, callback, params)
    -- TODO session 认证 加密
    local enc = { typ = crypto.ENCRYPT_QTEA, key = msgpack.get_bddef_enc().key }

    callback = callback or function() end

    local postdata = nil
    
    local function onRequestFinished(event)
        if event.name == "inprogress" then
            return
        end
        
        local ok = (event.name == "completed")
        local request = event.request
        
        if not ok then
            -- 请求失败，显示错误代码和错误消息
            log.debug("httpcall not complete:%s, %s", request:getErrorCode(), request:getErrorMessage())
            callback(WCODE.ERR_RPC_HTTP_REQ_NOT_COMPLETE, nil, request)
            return
        end
        
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            log.debug("httpcall error status:%s", code)
            callback(WCODE.ERR_RPC_HTTP_REQ_INV_STATUS, nil, request)
            return
        end
        
        -- 请求成功
        local response = request:getResponseData()
        log.debug("==========> response %s", response)
        if params.data.dtype == "pb" then
            local ret, csmsg = msgpack.pkg_unpack(response, enc)
            if ret == WCODE.OK then
                if csmsg.head.rescode ~= nil and csmsg.head.rescode ~= 0 then
                    ret = csmsg.head.rescode
                end
                callback(ret, csmsg, request)
            else
                callback(ret, nil, request)
            end
        elseif params.data.dtype == "json" then
            log.debug("response %s", response)
            local csmsg = json.decode(response)
            callback(csmsg.ret, csmsg, request)
        else
            --TODO
            log.debug("not support type %s", params.data.dtype)
        end
    end
    
    local method = "POST"
    local request = gnetwork.createHTTPRequest(onRequestFinished, url, method)
    
    if method == "POST" then
        if params.data.dtype == "pb" then
            request:addRequestHeader("Content-Type:application/octet-stream")
            local pbmsg = params.data.msg
            log.debug("=================> HttpCall %s msg %s", url, vardump(pbmsg))
            local csmsg = { head = { session = 0, httpctrl = action, pkgtype = pbmsg.msgtype__ }, pkg = pbmsg } 
            postdata = msgpack.pkg_pack(csmsg, enc)
            if postdata == nil then
                log.error("httpcall failed to pack csmsg")
                return
            end 
            --log.debug("net http debug:%s,%s", #postdata, string.hex(postdata))
            request:setPOSTData(postdata, #postdata)
        elseif params.data.dtype == "json" then
            request:addRequestHeader("Content-Type:application/text")
            local req = { ctrl = action, session = { huin = "", hskey = "" }, body = params.data.msg } 
            log.debug("req %s", vardump(req))
            postdata = json.encode(req)
            log.debug("postdata %s", postdata)
            request:setPOSTData(postdata, #postdata)
        else
            -- TODO
            log.debug("not support now")
        end
    end
    
    request:setTimeout(self.mtimeout)
    request:start()
end

function NetRpc:OnNeedLoginError()
    self:Close()
    CCHgame:UnScheduleAll()
    self.mtimer_rpc = nil
    local config = global.luaCfg:get_message_by(1090)
    showAlert(config.title, config.content, { global.luaCfg:get_local_string(10818) }, function()
        -- body
        global.funcGame.RestartGame()
    end)
end

function NetRpc:CallSilentAndNoRetry(mod, method, response, args)
    if global.LOCAL then
        return
    end
    local responseWrap = nil
    local sessionId = self:_next_ses_logic()
    local sendReq = function()
        self:_call(sessionId, true, mod, method, responseWrap(response), args)
    end
    responseWrap = function(response)
        return function(code, rspmsg)
            -- if code.retcode == WCODE.ERR_LOGIN_NEED_LOGIN then
            --     self:OnNeedLoginError()
            -- else
                response(code, rspmsg)
            -- end
        end
    end
    
    sendReq()
end

function NetRpc:CallSilent(mod, method, response, args)
    if global.LOCAL then
        return
    end
    local responseWrap = nil
    local sessionId = self:_next_ses_logic()
    local sendReq = function()
        self:_call(sessionId, true, mod, method, responseWrap(response), args)
    end
    responseWrap = function(response)
        return function(code, rspmsg)
            -- if code.retcode == WCODE.ERR_RPC_TIMEOUT then
            --     log.debug("CallSilent on ERR_RPC_TIMEOUT retry!")
            --     sendReq()
            -- elseif code.retcode == WCODE.ERR_LOGIN_NEED_LOGIN then
            --     self:OnNeedLoginError()
            -- else
                response(code, rspmsg)
            -- end
        end
    end
    
    sendReq()
end

function NetRpc:Call(mod, method, response, args, noModal)
    if global.LOCAL then
        return
    end
    local sesid = self:_next_ses_logic()
    local responseWrap = function(response)
        return function(code, rspmsg)
            hideConnect(nil,sesid)
            -- if code.retcode == WCODE.ERR_LOGIN_NEED_LOGIN then
            --     self:OnNeedLoginError()
            -- else
                response(code, rspmsg)
            -- end
        end
    end
    
    showConnect(noModal,sesid)
    self:_call(sesid, false, mod, method, responseWrap(response), args)
end

function NetRpc:SysCall(mod, method, response, args)
    local ses = self:_next_ses_system()
    log.trace("===========> SysCall [%s] %s.%s", ses, mod, method)
    self:_call(ses, true, mod, method, response, args)
end

function NetRpc:SysRequest(msg, response)
    local ses = self:_next_ses_system()
    -- log.trace("===========> SysRequest [%s] %s", ses, vardump(msg))
    self:_request(ses, msg, response)
end

function NetRpc:ses_logic()
    return self.mses_logic
end

function NetRpc:_next_ses_logic()
    self.mses_logic = self.mses_logic + 1
    if self.mses_logic >= SES_MAX_LOGIC then
        self.mses_logic = SES_MIN_LOGIC + 1
    end
    return self.mses_logic
end

function NetRpc:ses_system()
    return self.mses_system
end

function NetRpc:_next_ses_system()
    self.mses_system = self.mses_system + 1
    return self.mses_system
end

function NetRpc:IsConnected()
    return self.mnet ~= nil and self.mnet:IsConnected() == true
end

function NetRpc:noRelogin()
    return not self.mcan_relogin
end

function NetRpc:IsLogin()
    return self:IsConnected() and self.mlogin
end

function NetRpc:Debug()
    log.debug("ses:%u,acc:%u,login:%s,net:%s", self.mses_logic, self.maccid, self.mlogin, self.mnet)
    if self.mnet then
        self.mnet:Debug()
    end
end

function NetRpc:_set_ses_queue(sesid, rpc)
    self.mqueue[sesid] = rpc
    -- log.trace("net rpc _set_ses_queue:sesid=%s,rpc:%s",sesid,vardump(self.mqueue))
    local setnil = 0
    if rpc == nil then
        setnil = 1
    end
    -- log.debug("---------------------sess:%s,%s, %s,%s", sesid, setnil, vardump(table.keys(self.mqueue)))
end

function NetRpc:_rpc_tick() 
    local toRemove = {}
    for sesid, rpc in pairs(self.mqueue) do
        -- log.trace("============> _rpc_tick handle ses[%s] %s", sesid, vardump(rpc))
        if rpc.st == RPC_STATE.RPC_INIT then
            -- 发送
            self:_send_req(rpc)
        elseif rpc.st == RPC_STATE.RPC_DONE then
            table.insert(toRemove, sesid)
        elseif rpc.st ~= RPC_STATE.RPC_WAIT then
            log.info("invalid rpc status:%u,%u", sesid, rpc.st)
            table.insert(toRemove, sesid)
        end        
    end

    for i,v in ipairs(toRemove) do
        local rpc = self.mqueue[v]
        if not rpc then 
            log.error("#####rpc---->no response --->>sessionid =%s",v)
        else
            log.trace("#####rpc---->get rpc--->>sessionid =%s",v)
        end
        if rpc and rpc.st == RPC_STATE.RPC_DONE then
            local mrsph = rpc.rsp.th
            if  mrsph and mrsph.lRet ~= WCODE.OK then
                log.trace("############netRpc:_rpc_tick---->mrsph.lRet =%s",mrsph.lRet)
                if mrsph.lRet >= -999998 and mrsph.lRet <= -999900 then
                    global.ClientStatusData:Errorhandle(mrsph.lRet)
                else
                    --MError 错误处理
                    local mrspm = rpc.rsp.mt
                    st, res = pcall(rpc.cb.func, {retcode = mrsph.lRet or WCODE.ERR, head = mrsph},mrspm)
                    if st == false then
                        log.debug("rpc error call exec failed:%u,%s.%s, err:%s", sesid, rpc.req.mod, rpc.req.method, res or "")
                    end
                end

            -- 完成
            else
                if rpc.typ == "rpc" then
                    local m = rpc.rsp.mt -- BodyResp
                    local result_args = {}
                    local st, res 
                    
                    local reply_args = {}
                    
                    -- 先处理附带的事件
                    -- self:_proc_notify(m)

                    local code = {retcode = mrsph.lRet}            

                    local tstart = datetime.clock()
                    st, res = pcall(rpc.cb.func, code, m)
                    local tend = datetime.clock()
                    log.trace("<<<<<<rpc[%s]:%s.%s, time:%s", rpc.sesid, rpc.req.mod or rpc.req.mtype, rpc.req.method or "", tend - tstart)

                    if st == false then
                        log.debug("rpc call back exec failed:%s, %s.%s, err:%s", rpc.sesid, rpc.req.mod, rpc.req.method, res or "")
                    else
                        --log.debug("<<<< rpc[%u] call back:%s.%s, result:%s", sesid, rpc.req.mod, rpc.req.method, vardump(reply_args)
                    end
                
                    -- 处理附带的包体之后事件
                    -- self:_proc_notify(m, true)
                else 
                    -- request mode
                    local st, res = pcall(rpc.cb.func, {retcode = WCODE.OK}, rpc.rsp.mt)
                    if st == false then
                        log.debug("req call back exec failed:%u,%s, err:%s", sesid, rpc.req.mtype, res or "")
                    else 
                        --log.debug("req call back exec ok:%u,%s", sesid, rpc.req.mtype)
                    end
                end
            end
        end
        self:_set_ses_queue(v, nil)
    end

    local timeoutRpcs = {}
    local utc = datetime.utc()
    local temp = self.mrqqueue
    self.mrqqueue = {}
    for _, rpc in ipairs(temp) do
        -- log.trace("==============> mrqqueue rpc[%s] %s.%s, self.mtimer_curr_fps=%s is timeout data %s", rpc.sesid, rpc.msg.mod, rpc.msg.method, self.mtimer_curr_fps, vardump(rpc))
        if rpc.tm + self.mtimeout_fps <= self.mtimer_curr_fps then
            rpc.st = RPC_STATE.RPC_TIMEOUT
            timeoutRpcs[rpc.sesid] = rpc
            -- log.trace("==============> mrqqueue rpc[%s] %s.%s is timeout data %s", rpc.sesid, rpc.msg.mod, rpc.msg.method, vardump(rpc))
        else
            table.insert(self.mrqqueue, rpc)
        end   
    end

    temp = self.mqueue
    self.mqueue = {}
    for sesid, rpc in pairs(temp) do
        -- log.trace("==============> mqueue rpc[%s] %s.%s, self.mtimer_curr_fps=%s is timeout data %s", rpc.sesid, rpc.msg.mod, rpc.msg.method, self.mtimer_curr_fps, vardump(rpc))
        if rpc.st ~= RPC_STATE.RPC_DONE and rpc.tm + self.mtimeout_fps <= self.mtimer_curr_fps then -- 等待响应
            rpc.st = RPC_STATE.RPC_TIMEOUT
            timeoutRpcs[sesid] = rpc
        else
            self:_set_ses_queue(sesid, rpc)           
        end
    end
    
    for sesid, rpc in pairs(timeoutRpcs) do 
        log.debug("rpc timeout:%u", sesid)
        local st, reserr = pcall(rpc.cb.func, {retcode = WCODE.ERR_RPC_TIMEOUT})
        if st == false then
            log.debug("rpc timeout exec failed:%s", reserr or "")
        end
    end
end

function NetRpc:_proc_notify(csmsg, isAfterNotify)
    -- 在登陆场景是不接受服务器下发消息的
    if not self:IsLogin() then return end

    local ntf = csmsg.pkg.param.tagNotify or {}
    local tagHead = csmsg.pkg.param.tagHead or {}
    if tagHead.lRet >= -999998 and tagHead.lRet <= -999900 then
        --处理服务器异常维护等
        global.ClientStatusData:Errorhandle(tagHead.lRet)
        return
    end
    -- if isAfterNotify then
    --     ntf = mrpcret.notify_after or {}
    -- end
    for k,v in pairs(ntf) do
        local eventid = k or "INVALID___"
        
        local LogicNtf = require "game.Rpc.LogicNotify"
        local func = LogicNtf[eventid]
        local args= v
        if func ~= nil then
            log.debug("%s.%s:%s,eventid=%s", LogicNtf, func, vardump(args),eventid)
            local st, err = pcall(func, LogicNtf, args)
            if st ==  false then
                log.debug("rpc ntf call failed:%s,%s", eventid, err)
            end
        else
            log.debug("rpc ntf call not found:%s", eventid)
        end
    end
end

function NetRpc:_request(ses, msg, response) 
    local rpc = { sesid = ses, typ = "req", req = {}, msg = msg, cb = { func = response },
                    rsp = {mt = {}, th = {}, h = {}}, st = RPC_STATE.RPC_INIT, tm = self.mtimer_curr_fps }
    rpc.req.mtype = msg.msgtype__            
    
    log.trace("rpc request:%u,%d", ses, rpc.req.mtype)  
    self:_send_req(rpc)
end

function NetRpc:_call(ses, isSilent, mod, method, response, args)    
    args = args or {}
    local rpc = nil

    local onTimeOut = function(event)
        --socket连接着，发送出去请求未收到返回数据，或者返回超时
        log.error("--> NetRpc:_call---》onTimeOut-->self.mnosendcache=%s,rpc.sesid=%s",vardump(self.mnosendcache),rpc.sesid)
        -- self:errorConnectShow(rpc)
        if self.mnosendcache[rpc.sesid] then
            --对于客户端没有发出去的包，重连是补发
            if global.scMgr:isLoginScene() then
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            else
                local t_rpc = clone(rpc)
                print("---------------》")
                dump(t_rpc)
                self:reconnectSocket(function(isok)
                    -- body
                    dump(t_rpc)
                    if isok then
                        self:_send_req(t_rpc)
                    else
                        global.tipsMgr:showQuitConfirmPanelNoClientNet()
                    end
                end,nil,WCODE.ERR_RPC_CLIENT_NO_SEND)
            end
            log.debug("try request:%d %s.%s showConnect", rpc.sesid, rpc.req.mod, rpc.req.method)
        else
            --客户端发出去的包，但是返回没拿到，暂时跳过处理
            -- print("####-->"..self.mtimer_curr_fps)
            log.debug("try request:%d %s.%s showConnect,rpc=%s", rpc.sesid, rpc.req.mod, rpc.req.method,vardump(rpc))
            
            global.tipsMgr:showQuitConfirmPanel()
        end
    end
    local netrspcb = function(code, rspmsg)
        if not isSilent then
            if code.retcode == WCODE.ERR_RPC_TIMEOUT then
                log.debug("<<<< rpc[%s] time out!", ses)
                if self.mses_recon_map[ses] then
                    local config = global.luaCfg:get_message_by(1091)
                    onTimeOut()
                    -- showAlert(config.title, config.content, { global.luaCfg:get_local_string(10862), global.luaCfg:get_local_string(10861) }, onTimeOut)
                else
                    self.mses_recon_map[ses] = 1
                    onTimeOut({ buttonIndex = 1 })
                end
            else
                if code.retcode ~= WCODE.OK and not cc.IsMobilePhone() then
                    -- local errorData = global.luaCfg:get_message_by(code.retcode)
                    -- local data = {
                    --     title = "ERROR",
                    --     content = string.format("这个只有再电脑端才会有提示：no error code %s", code.retcode),
                    -- }
                    -- data = errorData or data
                    -- global.panelMgr:openPanel("UISystemMessagePanel"):setData(data)  
                end
                rspmsg = rspmsg or {}
                -- hideConnect()
                response(code, rspmsg)
            end
        else
            rspmsg = rspmsg or {}
            response(code, rspmsg)
        end
    end
    
   
    local msg = {}    
    msg.mod     = mod           
    msg.method  = method   
      
    rpc = { 
        sesid = ses, 
        typ = "rpc", 
        req = {
            mod = mod,
            method = method,
            params = args,
            mtype = args.msgtype__,
        }, 
        msg = msg, 
        cb = {
            func = netrspcb
        }, 
        rsp = {mt = {}, th = {}, h = {}}, st = RPC_STATE.RPC_INIT, tm = self.mtimer_curr_fps
    }
        
    -- 数据格式校验
    local pbarg = args
    if pbarg ~= nil and type(pbarg) == "table" and pbarg.msgtype__ ~= nil then
        if type(pbarg.msgtype__) ~= "string" then
            log.error("invalid rpc pb arg:%s.%s, %s", mod, method, pbarg.msgtype__ or "INVALID")
            return
        end
        local ptype = pbarg.msgtype__
        pbarg.msgtype__ = nil
        pbarg.enctype__ = nil
        if pbpack.check(ptype) then
            local bin_data = pbpack.pack(pbarg, ptype)
            if bin_data == nil then
                log.error("rpc pb arg pack failed:%s.%s, %s", mod, method, ptype)
                return
            end
        else
            log.warn("rpc pb arg pack warning no pbtype:%s.%s, %s", mod, method, ptype)
        end
    end

    msg.param_type = ""
    msg.param = args

    -- for debug
    -- log.debug(">>>> rpc[%u] call:%s.%s, rpc:%s", ses, mod, method, vardump(rpc))
    
    self:_send_req(rpc)
end

function NetRpc:_send_req(r)

    if self.mkicked == true then
        return
    end

    if self:IsConnected() then
        if (not self:IsLogin() and r.sesid > SES_MIN_SYSTEM) then
            table.insert(self.mrqqueue, 1, r)
            -- log.debug("not IsLogin send system request rpc[%d] put in mrqqueue self.mlast_returned %s", r.sesid, self.mlast_returned)
            if self.mlast_returned then
                self:_send_msg()
            end
        elseif self:IsLogin() then
            -- print(debug.traceback())
            -- log.debug("has IsLogin send request rpc[%d] put in mrqqueue self.mlast_returned %s,r=%s", r.sesid, self.mlast_returned,vardump(r))
            table.insert(self.mrqqueue, r)
            if self.mlast_returned then
                self:_send_msg()
            end
        else
            table.insert(self.mrqcache, r)
            log.debug("not IsLogin don't send request rpc[%d]", r.sesid)
        end
    else
        table.insert(self.mrqcache, r)
        if self.mnet == nil then
            log.debug("not connected redial")
            self:DialGameSvr()
        end
        log.debug("not connected don't send request rpc[%d]", r.sesid)
    end
end

local noLogin_fps = 0
local check_memory_fps = 0
function NetRpc:_handle_loop()
    if not self.mneed_relogin and self:IsLogin() then
        -- 正常网络
        noLogin_fps = 0
        self.mtimer_curr_fps = self.mtimer_curr_fps+1
    else
        -- print("######self.mneed_relogin===")
        -- print(self.mneed_relogin) 
        -- print(noLogin_fps)
        if self.mcan_relogin and self.mneed_relogin then
            -- 满足重连需求，并需要重连
            noLogin_fps = noLogin_fps + 1
            -- print(noLogin_fps)
            if noLogin_fps > 30 and not self.is_reconnecting then
                noLogin_fps = 0
                local isClientNet,netState = self:checkClientNetAvailable()
                -- print(isClientNet)
                if not isClientNet then
                    --检测客户端网络
                    self.mneed_relogin = false
                    self.mneed_relogin_call = nil

                    global.tipsMgr:showQuitConfirmPanelNoClientNet()
                    -- global.tipsMgr:showWarning(global.luaCfg:get_local_string(10497,WDEFINE.NET.RESTART_DELAY))
                    -- gscheduler.performWithDelayGlobal(function()
                    --     global.funcGame.RestartGame()
                    -- end, WDEFINE.NET.RESTART_DELAY)
                else
                    local okcall = function(isok)
                        -- body
                        if isok then
                        else
                            global.tipsMgr:showQuitConfirmPanelNoClientNet()
                        end
                    end
                    self:reconnectSocket(okcall)
                end
            elseif noLogin_fps > 150 and self.is_reconnecting then
                -- 150是给定超时判断
                -- 预防某种网路导致逻辑bug
                -- self.is_reconnecting = false
                self.is_reconnecting = global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end
        else
            if self.mneed_relogin and not self.mcan_relogin then
                --网络状态变化时在loading界面，需要重启客户端
                global.funcGame.RestartGame(true)
                self.mneed_relogin = false
                -- global.scMgr:replaceScene(global.scMgr:SceneName()
            elseif self.mcan_relogin then
                -- 网络状态变化时，可以重连，但是没有重连，补连接
                -- 服务器断开
                if not self:IsLogin() and not self.mneed_relogin then
                    self.mneed_relogin = true
                end
            end
        end
    end
    if global.isStartLoading then
        
        if check_memory_fps > 30 then
            check_memory_fps = 0
            local outMem = global.funcGame:isOutofMemMB(WDEFINE.FREE_ANDROID_RES_LIMIT_MEM_LV2)
            if outMem then
                gevent_on_memory_warning()
            end
        else
            check_memory_fps = check_memory_fps + 1
        end
    end
    
    self:_send_msg()
    self:_recv_msg()
end

function NetRpc:_send_msg()
    if self.mlast_returned == true and #self.mrqqueue > 0 and self:IsConnected() then
        local r = self.mrqqueue[1]
        r.st = RPC_STATE.RPC_WAIT
        -- dump(r,"----->")
        self:_set_ses_queue(r.sesid, r)
        -- log.trace("----->NetRpc:_send_msg()  self.mqueue=%s",vardump(self.mqueue))
        local success = self.mnet:Send(r.msg, r.sesid,  r.req.mtype, isRepeat)
        if not success then
            self.mnosendcache[r.sesid] = true
        else
            self.mnosendcache[r.sesid] = nil
        end
        table.remove(self.mrqqueue, 1)
        self.mlast_returned = true
        -- log.trace("send request:%u \n mrqqueue %s", r.sesid, vardump(self.mrqqueue))
    end
end

function NetRpc:_recv_msg()
    if self:IsConnected() then
        self.mnet:Recv()
    end
    self:_rpc_tick()
end

function NetRpc:_proc_msg(csmsg)
    local msgtype = csmsg.ptype or "INVALID"
    local session = csmsg.pkg.param.tagHead.lSeq or 0
    if session == nil then
        log.debug("rpc recv invalid msgtype:%s", msgtype)
        return
    end
    -- log.debug("rpc recv csmsg:%s", vardump(csmsg))
    
    local sesid = session  
    
    -- 推送事件直接处理
    -- if sesid == 0 then
        if csmsg.isNotify then
            self:_proc_notify(csmsg)
            return
        end
    -- end
    
    local rpc = self.mqueue[sesid]
    if rpc == nil then
        if self.mqueue_baker[sesid] then
            rpc = clone(self.mqueue_baker[sesid])
            self.mqueue[sesid] = rpc
            self.mqueue_baker[sesid] = nil
        else
            log.debug("rpc csmsg session not found:%u, %s", sesid, msgtype)
            return
        end
    end
    
    if rpc.st ~= RPC_STATE.RPC_WAIT then
        log.debug("rpc invalid status:%u,%d,%s,%s,%s,%s", sesid, rpc.st, rpc.typ, rpc.req.mod or rpc.req.mtype, rpc.req.submod or "", rpc.req.method or "")
        return
    end

    --message MSGResp 解出结构体内无用字段，暴露body内直接数据
    -- {
    --     required HeadResp       tagHead = 1;
    --     optional BodyResp       tagBody = 2;
    -- }
    local t_ptype = string.sub(csmsg.pbtype,1,#csmsg.pbtype-4)
    local t_ptype = "tag" .. t_ptype
    print("##########"..t_ptype)
    csmsg.pkg.param.tagBody = csmsg.pkg.param.tagBody or {}
    local mt = csmsg.pkg.param.tagBody[t_ptype]
    local th = csmsg.pkg.param.tagHead
    if not mt then
        log.error("no msg for response")
    end
    rpc.rsp = { mt = mt, th = th, h = csmsg.head}
    rpc.st = RPC_STATE.RPC_DONE
    log.trace("============> recved sesid %s", sesid)
    self.mlast_returned = true
end

function NetRpc:_heart_beat()  
    local m = self:NewMsg("HeartBeatReq")
    local on_req_hbt_cb = function(code, msg)
        if code.retcode == WCODE.ERR_RPC_TIMEOUT then 
            log.debug("HeartBeatReq timeout")
        end
    end
    self:SysRequest(m, on_req_hbt_cb)  
    if global.badNetTimes > 0 then
        global.commonApi:sendGameBadNetTimes(global.badNetDt.."#"..global.badNetTimes)
    end
end

--用于游戏中每秒触发定时器
local mcheck_endt= 0
local isGuidingFirst = nil 
function NetRpc:_heart_beatUI()

    local isEnterScene = global.scMgr:isWorldScene() or global.scMgr:isMainScene()
    if not isEnterScene then
        return 
    end

    if global.g_worldview and global.g_worldview.isStory then
        return
    end

    --exp1. 联盟加入tips检测
    local gsTime = global.luaCfg:get_config_by(1).uniontips*60
    local curTime = os.time()

    isGuidingFirst = global.guideMgr:isPlayingFirst() 
    if not isGuidingFirst then -- 引导结束后开始记时
        mcheck_endt = curTime
        global.guideMgr:setIsPlayingFirst(true)
    end
    
    if curTime - mcheck_endt >= gsTime and (not global.guideMgr:isPlaying()) then
        gevent:call(global.gameEvent.EV_ON_UNIONHINT)
        mcheck_endt = curTime
    end

    -- 小时礼包整点刷新
    global.rechargeData:checkIntegralRefersh()

    -- 活动状态检测
    global.ActivityData:CheckActivityState()

    -- 检测成就弹窗
    global.achieveData:checkPanel()

    -- 聊天置顶联盟消息
    global.chatData:checkChatRecruitMsg()

    --礼包解锁
    global.advertisementData:checkGiftTimeLock()

    --联盟经验之泉 红点 
    global.unionData:checkSpringRedPoint()

    -- 内外城finish, tip检测
    global.finishData:checkFinish()


    -- 神兽cd检测
    global.petData:checkPetCd()

    -- 联盟礼包是否失效
    global.chatData:checkUnionGiftLog()

    if global.g_worldview and not tolua.isnull(global.g_worldview.worldPanel) then
        global.g_worldview.worldPanel:getAttackQueue():flushRealTableView()
    end
    
    if global.tools:isAndroid() then
        -- global.funcGame:calculateAveFps()
    end
    --回掉方法
    for _ ,v in pairs(self.heartCall or {} ) do 
        v()
    end 
end

function NetRpc:checkRealNetByPing(url, port) 
    local socket = require "socket"
    --local host = socket.dns.toip(url)
    local connection = socket.tcp()
    connection:settimeout(5)    
    local result = connection:connect(url, port)
    connection:close()
    result = result or 0
    return result ~= 0
end

local function _net_test(url, port) 
    local socket = require "socket"
    --local host = socket.dns.toip(url)
    local connection = socket.tcp()
    connection:settimeout(5)    
    local result = connection:connect(url, port)
    connection:close() 
    return string.format("url:%s port:%d result:%s\n", url, port, result or 0)
end

function NetRpc:NetTestReport()
    local report = {}
    local socket = require "socket"  

    table.insert(report, "THIS IS NET TEST REPORT \n")

    if gdevice.platform ~= "windows" then
        table.insert(report, string.format("NET wifi:%s  net:%s  status:%s\n",
            gnetwork.isLocalWiFiAvailable(), gnetwork.isInternetConnectionAvailable(), gnetwork.getInternetConnectionStatus()))
    end
    table.insert(report, string.format("ses:%u,acc:%d,login:%s\n", self.mses_logic, self.maccid, self.mlogin and "true" or "false"))

    table.insert(report, _net_test("www.baidu.com", 80))
    table.insert(report, _net_test("www.baidu.com", 443))
    table.insert(report, _net_test("www.qq.com", 80))
    table.insert(report, _net_test("www.taobao.com", 80))
    -- table.insert(report, _net_test("www.google.com", 80))
    -- table.insert(report, _net_test("www.google.com", 443))
    -- table.insert(report, _net_test("115.159.1.158", 22))
    -- table.insert(report, _net_test("115.159.1.158", 8881))
    -- table.insert(report, _net_test("115.159.1.158", 8081))
    -- table.insert(report, _net_test("115.159.1.158", 8080))
    -- table.insert(report, _net_test("115.159.1.158", 80))

    -- table.insert(report, _net_test("101.251.106.239", 22))
    -- table.insert(report, _net_test("101.251.106.239", 8881))
    -- table.insert(report, _net_test("101.251.106.239", 8081))
    -- table.insert(report, _net_test("101.251.106.239", 8080))
    -- table.insert(report, _net_test("101.251.106.239", 80))

    local str = table.concat(report)

    if _DEBUG then
        GLFShowLuaError(str)
    end
end  

function NetRpc:Oss(id, ...)
    local args = {...}
    self:OssLog(id, table.concat(args, "|"))
end

function NetRpc:OssLog(id, logtxt)
    local ver_num = GLFGetAppVer()

    local checksum = ""
    if id == WPBCONST.ENOSS_CLILUAERR then
        checksum = crypto.md5(logtxt, false)
        local bfind = false
        for k,v in pairs(self.merr_checksum) do
            if v == checksum then
                logtxt = ""
                bfind = true
            end
        end
        if bfind == false then
            if #self.merr_checksum >= 10 then
                table.remove(self.merr_checksum, 1)
            end
            table.insert(self.merr_checksum, checksum)
        else 
            -- 发过的就不发了
            return        
        end

        --log.debug("log:%d, %s", self.merr_nums, vardump(self.merr_checksum))
        self.merr_nums = self.merr_nums + 1
        if self.merr_nums >= 5 then
            -- 再多就不发了
            return
        end
    end
    
    local msgpack = require "msgpack"
    local pbmsg = msgpack.newmsg("MHPlatOss")
    pbmsg.chanid = GLFGetChanID()
    pbmsg.zoneid = GLFGetZoneId()
    pbmsg.version = ver_num

    pbmsg.udid = ""
    pbmsg.openid = ""
    pbmsg.accid = self.maccid

    if self.maccid == 0 then
        pbmsg.openid = self.mplat.openid
        -- if pbmsg.openid == "" then
        --     pbmsg.udid = gdevice.getOpenUDID()
        -- end
    end

    pbmsg.logid = id
    pbmsg.checksum = checksum
    pbmsg.logtxt = logtxt

    self:HttpCallPlat("PlatCtrl.Oss", nil, {data = {dtype="pb", msg=pbmsg} })
end

function NetRpc:HttpCallPlat(action, callback, params)
    local appcfg = require "app_cfg"
    local plat_svr_url = appcfg.get_plat_url()


    local callBackWrap = function(ret, msg, httpreq)
        -- body

        if callback then
            callback(ret, msg, httpreq)
        end

        appcfg.on_plat_res(ret == WCODE.OK)
    end

    self:HttpCall(plat_svr_url, action, callBackWrap, params)
end

-- 检查服务器gateway是否开启
function NetRpc:reconnectSocket(i_okcall,noDetails,packState)
    if global.guideMgr:isPlaying() then
        global.tipsMgr:showQuitConfirmPanelNoClientNet()
        return
    end
    if self.is_reconnecting or self.mkicked == true then return end
    showTimes = 0
    self:Close()
    self.is_reconnecting = true
    local function okcall(isok)
        if i_okcall then i_okcall(isok) end
        self.is_reconnecting = false
        if self.mneed_relogin then
            self.mneed_relogin = false
            if self.mneed_relogin_call then
                self.mneed_relogin_call(isok)
                self.mneed_relogin_call = nil
            end
        end
    end
    local isRelogin = packState or 1
    if global.scMgr:isLoginScene() then
        self:DialGameSvr(self.mplat,self.mzone,okcall,isRelogin)
    else
        self:DialGameSvr(self.mplat,self.mzone,okcall,isRelogin)
    end
end

function NetRpc:checkNetRpc(serverId, callBack)
    local auth = global.loginData:getLoginAuth()
    local serData = global.ServerData:getServerDataBy(serverId)
    if not serData then 
        if callBack then callBack(true) end
        return 
    end
    local spstrs = string.split(serData.ip, ":")    
    local addr = spstrs[1]
    local port = toint(spstrs[2])

    local mconn = nil
    local tcp = require "util.sockettcp"
    local on_tcp_event = function(ev, dt)
        log.debug("on net tcp event: %s", ev)
        if ev == tcp.EVENT_CONNECT_FAILURE then
            if callBack then callBack(false) end
        elseif ev == tcp.EVENT_CONNECTED then
            if callBack then callBack(true) end
            if mconn then mconn:close() end
        elseif ev == tcp.EVENT_DATA then
            if callBack then callBack(true) end
            if mconn then mconn:close() end
        else
            if callBack then callBack(false) end
        end
        hideConnect()
    end
    mconn = tcp.new(addr , port, on_tcp_event, false)
    mconn:setConnFailTime(5)
    mconn:connect()
    showConnect()
end

--后台切换回来做的检测
function NetRpc:checkConnect(okcall)
    local isClientNet,netState = self:checkClientNetAvailable()
    print("------->netState="..netState)
    print("------->lastNetState="..lastNetState)
    print(isClientNet)
    self:resetReconnectTimes()
    if not isClientNet then
        --检测客户端网络
        self.mneed_relogin = true
        self.mneed_relogin_call = okcall
    else
        -- self:reconnectSocket(okcall)

        if not self:IsLogin() then 
            lastNetState = netState
            return 
        else
            if global.tools:isIos() and netState and netState == 2 and netState ~= lastNetState then
                lastNetState = netState
                -- 针对ios wifi切换为3g网络时特殊处理
                self:reconnectSocket(okcall)
                return
            end
        end

        if self.mnet and self.mnet:checkConnect() then
            global.loginApi:getLoginDetail(function(ret, msg)
                --登陆直通车 获取主城信息
                if ret.retcode == WCODE.OK then
                    -- global.guideMgr:init()
                    global.dataMgr:init(msg)
                    if okcall then okcall() end
                end
            end)
        else
            self:reconnectSocket(okcall)
        end
        -- if okcall then okcall() end
    end

    -- lastNetState = netState
end

function NetRpc:addReconnectTimes()
    -- print("fdawfdsdfsdaf")
    -- print(self.m_reconnectDelayTimes)
    if not self.m_reconnectDelayTimes then return end
    self.m_reconnectDelayTimes = self.m_reconnectDelayTimes + 1
    local now = os.time()
    if not self.m_reconnectSt then return end
    local dt = now-self.m_reconnectSt
    -- if dt > 11 then
    --     if self.m_reconnectDelayTimes > 5 and dt <= 30 then
    --         global.tipsMgr:showQuitConfirmPanelNoClientNet()
    --     else
    --         self:resetReconnectTimes()
    --         self.m_reconnectDelayTimes = nil
    --     end
    -- end
end
function NetRpc:resetReconnectTimes()
    self.m_reconnectDelayTimes = 0
    self.m_reconnectSt = os.time()
end

-- 检查客户端网络是否正常
function NetRpc:checkClientNetAvailable()
    local state = gnetwork.getInternetConnectionStatus()
    if global.tools:isWindows() then
        return true,1
    end
    return (state ~= 0),state
end


function NetRpc:packBodyForOuter(binaryText,i_unpackStruct)
    if not self.mnet then return end
    return self.mnet:packBodyForOuter(binaryText,i_unpackStruct)
end

function NetRpc:addHeartCall(call , key)
    self.heartCall =self.heartCall or {}
    if key then 
      self.heartCall[key] =call
    else 
        table.insert(self.heartCall , call)
    end 
end 

function NetRpc:delHeartCall(key)

    if  self.heartCall and key then 
        self.heartCall[key] = nil
    end 
end 



global.netRpc = NetRpc


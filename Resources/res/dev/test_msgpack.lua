
local hqnetlib = require "hqnetlib"
local msgpack  = require "msgpack"
local crypto   = require "hqgame"
local datetime = require "datetime"

local _T = { tstart = 0 }

function _T:time_start()
    self.tstart = datetime.clock()
end

function _T:time_end(times)
    local tend = datetime.clock()
    local t = tend - self.tstart
    local qps = 9999999999
    if t > 0 then
        qps = times/t
    end
    log.debug("TIME STAT, start:%s, end:%s, qps:%d/s", self.tstart, tend, qps)
end

function _T:run()
    local cfg = { pbcfg = {pbfile = "bin/cmd.pb", pkg = "Cmd."}, max_cli = 1024*5, max_svr = 1024*16}
   msgpack.init(cfg)
   
   --self:test_recv()
   
   --self:test_none()
   self:test_run(crypto.ENCRYPT_NONE, 5000, false)
   self:test_run(crypto.ENCRYPT_XOR, 5000, false)
   self:test_run(crypto.ENCRYPT_XXTEA, 5000, false)
   self:test_run(crypto.ENCRYPT_QTEA, 5000, false)
--   self:test_run(crypto.ENCRYPT_NONE, 1, true)
--   self:test_run(crypto.ENCRYPT_XOR, 1, true)
--   self:test_run(crypto.ENCRYPT_XXTEA, 1, true)
--   self:test_run(crypto.ENCRYPT_QTEA, 1, true)
end

function _T:test_show(bprint)
    bprint = bprint or false
    
    local jmsg = {a=1234,b="str12345", c= {1,2,3,4,5}}
    local test = msgpack.pack(jmsg, nil, msgpack.EN_BODY_JSON)
    local rmsg = msgpack.unpack(test)
    local strvar = vardump(rmsg)
    print(strvar)
    
    local pbmsg = msgpack.newmsg("MLogin")
    pbmsg.channel = 123
    pbmsg.platform = 456
    pbmsg.version = 1111
    pbmsg.uuid = "ddddddddddddddddddddddddddXX5555"
    
    local jsmsg = msgpack.newjsmsg("JTest")
    jsmsg.aa="ddddd"
    jsmsg.bb=123.56
    jsmsg.cc = {x=123, y={12,34,56,78}}
    
    local csmsg = {msgs = {pbmsg, jsmsg}}
    strvar = vardump(csmsg)
    print(strvar)
    test = msgpack.pack(csmsg)
    rmsg = msgpack.unpack(test)
    strvar = vardump(rmsg)
    print(strvar)
    
    local pbmsg = msgpack.newmsg("MTest")
    pbmsg.tint = 123456789
    pbmsg.tstr = "123456789bacdefg"
    pbmsg.trep = {}
    pbmsg.trep[1] = "str1111"
    pbmsg.trep[2] = "str2222"
    pbmsg.trep[3] = "str3333"
    pbmsg.tint3 = -99999999
    pbmsg.tst = {systemHardware = "Huawei XX", network = "4G", density = 0.23456}
    pbmsg.tst.sysid = 1
    pbmsg.tst.version = "ClientVersion.1.0.0.1"
    pbmsg.tst.systemSoftware = "Android 4.2.2"
    pbmsg.tst.deviceID = "UUIDXXXX-XXX-DDDDD"
    pbmsg.rst2 = {gold = 123}
    pbmsg.rst3 = {}
    pbmsg.rst3[1] = {gold = 123}
    pbmsg.rst3[2] = {gold = 123}
    
    local csmsg = {msgs = {pbmsg}}
    local msgbuf = msgpack.pack(csmsg)
    log.debug("---%s", string.hex(msgbuf))
    
    local unmsg = msgpack.unpack(msgbuf)
    local strvar = vardump(unmsg)
    log.debug("uuuu---:%s", strvar)
    
end

function _T:test_recv()
    log.debug("-----------------------------------------------------")
    local pbmsg = msgpack.newmsg("MTest")
    pbmsg.tint = 123456789
    pbmsg.tstr = "123456789bacdefg"
    pbmsg.trep = {}
    pbmsg.trep[1] = "str1111"
    pbmsg.trep[2] = "str2222"
    pbmsg.trep[3] = "str3333"
    pbmsg.tint3 = -99999999
    pbmsg.tst = {systemHardware = "Huawei XX", network = "4G", density = 0.23456}
    pbmsg.tst.sysid = 1
    pbmsg.tst.version = "ClientVersion.1.0.0.1"
    pbmsg.tst.systemSoftware = "Android 4.2.2"
    pbmsg.tst.deviceID = "UUIDXXXX-XXX-DDDDD"
    pbmsg.rst2 = {gold = 123}
    pbmsg.rst3 = {}
    pbmsg.rst3[1] = {gold = 123}
    pbmsg.rst3[2] = {gold = 123}
    
    local enc = {
        typ = crypto.ENCRYPT_XXTEA,  
        key = "111111111111111111111111111111111111",
    }
    
    local msglen = 0
    self:time_start()  
    local allbuf = ""
    for i = 1, 100 do
        pbmsg.enctype__ = "pb"
        pbmsg.msgtype__ = "MTest"
        local csmsg = { head = {session = 0, pkgtype = pbmsg.msgtype__ }, pkg = pbmsg} 
        local msgbuf = msgpack.pkg_pack(csmsg, enc)
        if msgbuf == nil then 
            log.debug("=========pack failed")
            return
        end
        allbuf = allbuf .. msgbuf
    end
    
    local netcp = require "game.Rpc.NetTcp"
    netcp:SetEnc(enc)
    
    local ilen = 30 
    local alllen = #allbuf
    local pos = 0
    while pos < alllen do
        pos = pos + 1
        local pend = pos + ilen
        if pend > alllen then pend = alllen end
        local sdata = string.sub(allbuf, pos, pend)
        --netcp:_on_data({data=sdata})
        log.debug("--------------:%s, %s", pos, ilen)
        pos = pend
        ilen = ilen + 30
    end
    
    log.debug("-------msg len:%d", msglen)   
end

function _T:test_msg(msgin, enc, bprint)
    bprint = bprint or false 
    
    local csmsg = { head = {session = 0, pkgtype = msgin.msgtype__ }, pkg = msgin} 
    if bprint == true then
        local strvar = vardump(csmsg)
        log.debug("input---:%s", strvar)
    end
    local msgbuf = msgpack.pkg_pack(csmsg, enc)
    if bprint == true then
        log.debug("---enc len:%d :%s", #msgbuf, string.hex(msgbuf))
    end
    local ret, hdpkg, hdlen = msgpack.unpack_head(msgbuf)
    if ret ~= 0 then
        log.debug("dec head failed:%s", ret)
        return 0
    end
    hdpkg.Data = string.sub(msgbuf, msgpack.HQPAC_BINHD_LEN+1, hdpkg.Len)
    local iret, unmsg = msgpack.unpack_body(hdpkg, enc)
    
    if bprint == true then
        local strvar = vardump(unmsg)
        log.debug("dec---:%s", strvar)
    end
    
    if msgin.tstr ~= unmsg.pkg.tstr then
        log.debug("msg test failed")
        return 0
    else
        return #msgbuf
    end
end

function _T:test_run(etype, times, bprint)
    log.debug("-----------------------------------------------------")
    log.debug("run msg encode and decode test, type:%d, times:%d", etype, times)
    local pbmsg = msgpack.newmsg("MTest")
    pbmsg.tint = 123456789
    pbmsg.tstr = "123456789bacdefg"
    pbmsg.trep = {}
    pbmsg.trep[1] = "str1111"
    pbmsg.trep[2] = "str2222"
    pbmsg.trep[3] = "str3333"
    pbmsg.tint3 = -99999999
    pbmsg.tst = {systemHardware = "Huawei XX", network = "4G", density = 0.23456}
    pbmsg.tst.sysid = 1
    pbmsg.tst.version = "ClientVersion.1.0.0.1"
    pbmsg.tst.systemSoftware = "Android 4.2.2"
    pbmsg.tst.deviceID = "UUIDXXXX-XXX-DDDDD"
    pbmsg.rst2 = {gold = 123}
    pbmsg.rst3 = {}
    pbmsg.rst3[1] = {gold = 123}
    pbmsg.rst3[2] = {gold = 123}
    
    local enc = {
        typ = etype,  
        key = "111111111111111111111111111111111111",
    }
    
    local msglen = 0
    self:time_start()  
    for i = 1, times do
        pbmsg.enctype__ = "pb"
        pbmsg.msgtype__ = "MTest"
        msglen = self:test_msg(pbmsg, enc, bprint)
    end
    self:time_end(times)
    log.debug("-------msg len:%d", msglen)
    
end

return _T 



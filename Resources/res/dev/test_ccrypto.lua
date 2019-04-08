
local hqnetlib = require "hqnetlib"
local ccrypto  = require "ccrypto"
local crypto  = require "hqgame"
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

function _T:randstr(size)
    local char_list = {}
    for i = 1, size do
        table.insert(char_list, string.char(math.random(0, 255)))
    end
    return table.concat(char_list)
end

function _T:run()
    local toenc = "123456789012345678901234567890"
    local str1 = crypto.encrypt(2, toenc, "22222222222222222222222222222222")
    log.debug("==:%s", string.hex(str1))
    toenc = "123456789012345678901234567890"
    local str2 = crypto.encrypt(3, toenc, "22222222222222222222222222222222")
    log.debug("==:%s", string.hex(str2)) 
    toenc = "123456789012345678901234567890"
    local str3 = crypto.encrypt(4, toenc, "22222222222222222222222222222222")
    log.debug("==:%s", string.hex(str3))
    local str4 = crypto.decrypt(4, str3, "22222222222222222222222222222222")
    log.debug("=====:%s", str4)
    if true then
        return
    end

    local n = 200000
    self:test_xor(n, 127, 20)
    self:test_xor(n, 255, 20)
    self:test_xor(n, 1023, 20)
    
    local n = 10000
    self:test_xxtea(n, 127, 20)
    self:test_xxtea(n, 255, 20)
    self:test_xxtea(n, 1023, 20)
    
    self:test_qtea(n, 127, 20)
    self:test_qtea(n, 255, 20)
    self:test_qtea(n, 1023, 20)
    
    local n = 2000
    self:test_ecdh(n)
--    self:test_sslecdh(10000)
end

function _T:test_xor(times, input_len, key_len)
    local sinput = self:randstr(input_len)
    local key = self:randstr(key_len)
    log.debug("xor test, times:%d, inputlen:%d, keylen:%d", times, input_len, key_len)
    
    self:time_start()
    for i = 1, times do
        ccrypto.encXor(sinput, key)
        ccrypto.decXor(sinput, key)
    end
    self:time_end(times)
end

function _T:test_xxtea(times, input_len, key_len)
    local sinput = self:randstr(input_len)
    local key = self:randstr(key_len)
    log.debug("xxtea test, times:%d, inputlen:%d, keylen:%d", times, input_len, key_len)
    
    local enc, dec
    self:time_start()
    for i = 1, times do
        enc = ccrypto.encXxtea(sinput, key)
        dec = ccrypto.decXxtea(enc, key)
    end
    self:time_end(times)   
    if dec ~= sinput then
        log.debug("xxtea dec failed.")
    end
end

function _T:test_qtea(times, input_len, key_len)
    local sinput = self:randstr(input_len)
    local key = self:randstr(key_len)
    log.debug("qtea test, times:%d, inputlen:%d, keylen:%d", times, input_len, key_len)
    
    local enc, dec
    self:time_start()
    for i = 1, times do
        enc = ccrypto.encQtea(sinput, key)
        dec = ccrypto.decQtea(enc, key)
    end
    self:time_end(times)   
    if dec ~= sinput then
        log.debug("qtea dec failed.")
    end
end

function _T:test_ecdh(times)
    log.debug("ecdh test, times:%d", times)
    
    self:time_start()
    for i = 1, times do
        local pub, pr = ccrypto.ecdhKey()
        local sec = ccrypto.ecdhSecret(pub, pr)
        --log.debug(string.hex(pub))
        --log.debug(string.hex(pr))
        --log.debug(string.hex(sec))
        if #sec ~= 32 then
            log.debug("---------------:%s", #sec)
        end
    end
    self:time_end(times)   
end

function _T:test_sslecdh(times)
    log.debug("sslecdh test, times:%d", times)
    
    self:time_start()
    for i = 1, times do
        local svr_obj, svr_pub = ccrypto.ecdhSslKey()
        local cli_obj, cli_pub = ccrypto.ecdhSslKey()
--        print(string.hex(svr_pub))
--        print(string.hex(cli_pub))
        
        local svr_sec = ccrypto.ecdhSslSecret(svr_obj, cli_pub)
        local cli_sec = ccrypto.ecdhSslSecret(cli_obj, svr_pub)
        
        ccrypto.ecdhSslFree(svr_obj)
        ccrypto.ecdhSslFree(cli_obj)

--        print(string.hex(svr_sec))
--        print(string.hex(cli_sec))
    end
    self:time_end(times)  
end

return _T 



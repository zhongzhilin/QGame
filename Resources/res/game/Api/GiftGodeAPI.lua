--
-- Author: Your Name
-- Date: 2017-03-09 11:01:16
--
--
-- Author: Your Name
-- Date: 2017-03-07 21:51:53
--
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- 根据BUff by id 
function _M:ExChangeGiftCode(szCode, callback)
    
    local pbmsg = msgpack.newmsg("ExchangePrizeReq")
    pbmsg.szCode = szCode

    local rsp_call = function(ret,msg)
            callback(msg,ret)
    end

    gameReq.CallRpc("GiftCode","ExChangeGiftCode",rsp_call,pbmsg)
end

global.giftCodeAPI = _M

--endregio
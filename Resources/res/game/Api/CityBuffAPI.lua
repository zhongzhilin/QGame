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
function _M:getcityBUfferById(tgEffect, callback)
    
    local pbmsg = msgpack.newmsg("EffectQueueReq")
    pbmsg.tgEffect = tgEffect

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("citybuff","getcityBUfferById",rsp_call,pbmsg)
end

global.CityBufferAPi = _M

--endregio
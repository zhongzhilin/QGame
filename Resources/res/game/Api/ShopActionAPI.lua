--
-- Author: Your Name
-- Date: 2017-03-14 11:24:51
--
 

local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- 根据购买商品
function _M:sedBuyShopReq(lID,lCount , callback)
    local pbmsg = msgpack.newmsg("ShopingActionReq")
    pbmsg.lID = lID
    pbmsg.lCount = lCount

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then 

            callback(ret,msg)

            global.ShopData:RequestlimiteShopData(function()
                 gevent:call(global.gameEvent.EV_ON_REFRESH_STORE)
            end)
        end 
    end
    gameReq.CallRpc("ShopActionAPI","sedBuyShopReq",rsp_call,pbmsg)
end


-- 获取top
function _M:getTopReq(lType,lId , callback)
    local pbmsg = msgpack.newmsg("GetShopingInfoReq")
    pbmsg.lType = lType
    pbmsg.lId = lId
    local rsp_call = function(msg,ret)
        callback(msg,ret)
    end
    gameReq.CallRpc("ShopActionAPI","getTopReq",rsp_call,pbmsg)
end


global.ShopActionAPI = _M

--endregio
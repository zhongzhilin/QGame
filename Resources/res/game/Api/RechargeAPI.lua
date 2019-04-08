--
-- Author: yyt
-- Date: 2017-03-23
--

local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

-- 根据购买商品
function _M:getRechargeList(callback)
    local pbmsg = msgpack.newmsg("GetRechargeReq")
   
    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("buy","getRechargeList",rsp_call,pbmsg)
end

-- 获取广告
function _M:getAdvertList(lType, callback)
    local pbmsg = msgpack.newmsg("GetAdvertListReq")
    pbmsg.lType = lType
   
    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("buy","getAdvertList",rsp_call,pbmsg)
end

-- 领取月卡
function _M:getMonthReward(callback, lType, lParam)
    local pbmsg = msgpack.newmsg("GetCardsRewardReq")
    pbmsg.lType = lType
    pbmsg.lParam = lParam
   
    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("buy","getMonthReward",rsp_call,pbmsg)
end


function _M:sendRecordRecharge(callback, lType, lGiftID)
    local pbmsg = msgpack.newmsg("RecordRechargeReq")
    pbmsg.lType = lType
    pbmsg.lGiftID = lGiftID
   
    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("buy","sendRecordRecharge",rsp_call,pbmsg)
end

function _M:checkRecharge(callback, lID)
    local pbmsg = msgpack.newmsg("CheckRechargeReq")
    pbmsg.lID = lID
   
    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            global.tipsMgr:showWarning("giftRecharged")
            if global.sdkBridge.pay_checkDropOrder then
                global.sdkBridge:pay_checkDropOrder()
            end
        end
    end
    gameReq.CallRpc("buy","CheckRecharge",rsp_call,pbmsg,false)
end

global.rechargeApi = _M

--endregio
--
-- Author: Your Name
-- Date: 2017-04-25 10:54:53

local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- 获活动列表
function _M:ActivityListReq(lActId , callback , motai)
    local pbmsg = msgpack.newmsg("GetActivityListReq")
    pbmsg.lActId = lActId
     local rsp_call = function(msg,ret)
     	if callback then 
            callback(msg,ret)
        end 
    end
    gameReq.CallRpc("ActivityListReq","ActivityListReq",rsp_call,pbmsg ,motai)
end


function _M:ActivityRankReq(lActId , lStartRank,lShowCount,callback)
    local pbmsg = msgpack.newmsg("GetActivityRankReq")
    pbmsg.lActId = lActId
    pbmsg.lStartRank = lStartRank
    pbmsg.lShowCount = lShowCount

     local rsp_call = function(msg,ret)
     	if callback then 
            callback(msg,ret)
        end 
    end
    gameReq.CallRpc("GetActivityRankReq","GetActivityRankReq",rsp_call,pbmsg)
end

function _M:SevenActivityReq(callback)
    local pbmsg = msgpack.newmsg("GetActSevenListReq")

     local rsp_call = function(ret,msg)
        if callback then 
            global.ActivityData.sevenDayData = msg 
            global.ActivityData:setSevenDayNotifyRedCount(nil) --不用通知的小红点，用拉去的小红点//
            callback(msg)
        end 
    end
    gameReq.CallRpc("SevenActivityReq","SevenActivityReq",rsp_call,pbmsg)
end

function _M:SevenActivityRecevieReq(taskid, callback)
    
    local pbmsg = msgpack.newmsg("RecevieRewardReq")
    pbmsg.lType = 3 
    pbmsg.lParam = taskid

     local rsp_call = function(ret,msg)

        if callback then 
            callback(msg)
        end 
    end
    gameReq.CallRpc("SevenActivityRecevieReq","SevenActivityRecevieReq",rsp_call,pbmsg)
end


function _M:SevenDayRechargeRewardReq(day, callback)
    
    local pbmsg = msgpack.newmsg("RecevieRewardReq")
    pbmsg.lType = 4 
    pbmsg.lParam = day

     local rsp_call = function(ret,msg)

        global.rechargeData:setSevenDayRechargeState(2)

        if callback then 
            callback(msg)
        end 
    end
    gameReq.CallRpc("SevenActivityRecevieReq","SevenActivityRecevieReq",rsp_call,pbmsg)
end



--请求神殿 
function _M:requestTempleMapId(callback)
    
    local pbmsg = msgpack.newmsg("GetLegendMiracleMapIdReq")
    
     local rsp_call = function(ret,msg)

        if callback then 
            callback(ret,msg)
        end 
    end
    gameReq.CallRpc("requestTempleMapId","requestTempleMapId",rsp_call,pbmsg)
end

--大转盘--》1:每日转盘 2:英雄谕令转盘 3：半转盘 4：英雄谕令转盘十连抽
-- lType:消费类型-》1：魔晶消耗 2：军工消耗
function _M:getSpinLottery(callback,lID,lType)
    
    local pbmsg = msgpack.newmsg("SpinLotteryReq")
    pbmsg.lID = lID
    pbmsg.lType = lType
    
     local rsp_call = function(ret,msg)

        if callback then 
            callback(ret,msg)
        end 
    end
    gameReq.CallRpc("getSpinLottery","getSpinLottery",rsp_call,pbmsg)
end


-- required string     lUserName       = 1;//用户名
-- required int32      lItemID     = 2;//道具ID
-- optional string     szParam     = 3;//扩展参数
function _M:getTurnTableLog(callback  , lType)
    
    local pbmsg = msgpack.newmsg("GetTurnTableLogReq")

    pbmsg.lType = lType
    
     local rsp_call = function(ret,msg)

        if callback then 
            callback(ret,msg)
        end 
    end
    gameReq.CallRpc("tagTurnTableLog","tagTurnTableLog",rsp_call,pbmsg)
end

-- 七日奖励改成手动领取形式
function _M:getActivityReward(callback, lActId, lSection, lszparam)
    -- body
    local pbmsg = msgpack.newmsg("ActReceiveRewardReq")
    pbmsg.lActId = lActId
    pbmsg.lSection = lSection
    pbmsg.lszparam = lszparam

    global.ActivityData:updateActRed(lActId)
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end 
    end
    gameReq.CallRpc("activity","getActivityReward",rsp_call,pbmsg)
end

global.ActivityAPI = _M

--endregio
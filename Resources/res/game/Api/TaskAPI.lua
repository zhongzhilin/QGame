--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"
local luaCfg = global.luaCfg

local _M = {}

function _M:taskGetGift(lID,callBack,lType)
    local pbmsg = msgpack.newmsg("TaskFinishReq")
    pbmsg.lID = lID
    pbmsg.lType = lType

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then

            if lType == 1 then --删除弹窗成就 cache 数据
                global.achieveData:deleteCacheID(lID)
            end 

            callBack(msg)
        end
    end

    gameReq.CallRpc("task", "task_getgift", rsp_call, pbmsg)
end

function _M:getReward(lType, lParam ,callBack)
    local pbmsg = msgpack.newmsg("RecevieRewardReq")
    pbmsg.lType = lType
    pbmsg.lParam = lParam

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("task", "getReward", rsp_call, pbmsg)
end

function _M:getRewardBag(lType, callBack, lParam)
    local pbmsg = msgpack.newmsg("OnlinePackReq")
    pbmsg.lType = lType
    pbmsg.lParam = lParam

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("reward", "getRewardBag", rsp_call, pbmsg)
end

function _M:getRegisterDaily( callBack )
    local pbmsg = msgpack.newmsg("GetSignRewardReq")
    
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("reward", "GetSignRewardReq", rsp_call, pbmsg)
end

-- 拉取成就任务列表
function _M:getAchieveTaskList( callBack )
    local pbmsg = msgpack.newmsg("GetAchieveTaskListReq")
    
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("task", "getAchieveTaskList", rsp_call, pbmsg, false)
end

function _M:checkTask( callBack )
    
    local pbmsg = msgpack.newmsg("GetTaskListReq")
    
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("task", "GetTaskListReq", rsp_call, pbmsg, false)
end

global.taskApi = _M

--endregion

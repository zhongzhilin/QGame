--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

-- 研究科技
function _M:techScience(lType, lTechID, callback)
    
    local pbmsg = msgpack.newmsg("TechActionReq")
    pbmsg.lType = lType
    pbmsg.lTechID = lTechID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            if lType == 0 then
                -- 驻防英雄建筑信息更新
                global.heroData:refershBuildGarrison() 
            end
            global.userData:updateLordEquipBuff() -- 压缩干粮士兵粮耗减少
        end
    end

    gameReq.CallRpc("tech","techScience",rsp_call,pbmsg)
end

-- 每日占卜
function _M:divineList(lType, callback, localId)
    
    local pbmsg = msgpack.newmsg("DivineListReq")
    pbmsg.lType = lType
    pbmsg.localId = localId

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("divine","divineList",rsp_call,pbmsg)
end

-- 请求启迪目标是否满足
function _M:conditSucc(lConditionID, callback)
    
    local pbmsg = msgpack.newmsg("ConditionSuccReq")
    pbmsg.lConditionID = lConditionID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("tech","conditSucc",rsp_call,pbmsg)
end

global.techApi = _M

--endregio
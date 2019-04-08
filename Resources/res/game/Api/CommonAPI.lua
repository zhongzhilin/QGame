--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"
local luaCfg = global.luaCfg

local _M = {}

function _M:heroAction(heroId,actionType,par1,par2,par3,callBack)
    local pbmsg = msgpack.newmsg("HeroActionReq")
    pbmsg.lID = heroId--英雄ID
    pbmsg.lType = actionType --操作类别 1 挽留  2 说服
    pbmsg.lParam = par1 --使用参数 说服类别  1 闲聊  2 小酌  3 宴请  4 赠送物品
    pbmsg.lParam2 = par2 --物品id
    pbmsg.lParam3 = par3 --数量

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("hero", "HeroActionReq", rsp_call, pbmsg)
end

function _M:setFPSStep(sceneId,param,isWait)

    local pbmsg = msgpack.newmsg("SignFPSStateReq")
    pbmsg.lFPS = math.floor(CCHgame:getFps())
    pbmsg.lSceneID = sceneId
    pbmsg.lParam = param

    gameReq.CallRpc("back", "SignFPSStateReq", function()
  
        print("set gudie step with no connect")
    end, pbmsg,not isWait)

end

function _M:getComCount( id,callBack )
    
    local pbmsg = msgpack.newmsg("GetComCountReq")
    pbmsg.lID = id

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("common", "GetComCountReq", rsp_call, pbmsg)
end

function _M:setGuideStepWithNoConnect()

    print(">> set guide step with no connect")

    local pbmsg = msgpack.newmsg("SetGuideStepReq")
    pbmsg.lStep = global.guideMgr:getCurBaseStep()
    global.guideMgr:moveBaseStep()
    pbmsg.lGuideType = 2

    gameReq.CallRpc("hero", "SetGuideStepReq", function()
  
        print("set gudie step with no connect")
    end, pbmsg,true)
end

function _M:setGuideStep(stepId,callback)
    local pbmsg = msgpack.newmsg("SetGuideStepReq")
    pbmsg.lStep = stepId
    pbmsg.lGuideType = global.guideMgr:getCurGuideType()

    local guideType = global.guideMgr:getCurGuideType()

    local rsp_call = function(ret, msg)

        if ret.retcode == WCODE.OK then
            
            print(guideType,"guideType",stepId,"stepId")
            if guideType == 1 then            


                global.userData:insertGudieTag(stepId)
            else

                global.userData:setGuideStep(stepId)
            end
            
            callback(msg)
        end
    end 

    gameReq.CallRpc("hero", "SetGuideStepReq", rsp_call, pbmsg)
end

-- 个人数据总览
function _M:getAllMsgInfo(callback)
    -- body
    local pbmsg = msgpack.newmsg("FightOverviewReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(self:changePetBuff(msg))        
        end
    end
    gameReq.CallRpc("common", "getAllMsgInfo", rsp_call, pbmsg)
end


-- 神兽技能buff转化
function _M:changePetBuff(msg)
    -- body
    for i,v in ipairs(msg.tagBuffTotal or {}) do
        for k,vv in ipairs(v.tagBuffFrom or {}) do
            if vv.lFrom == 14 then
                local petPer = global.luaCfg:get_pet_activation_by(1).skillExpand
                v.tagBuffFrom[k].lValue = v.tagBuffFrom[k].lValue/petPer
            end
        end
    end
    return msg
end

-- debug 协议
function _M:debugCommSet(callback, lType, lKey, lCount, szParams)
    -- body
    local pbmsg = msgpack.newmsg("GMCommSetReq")
    pbmsg.lType = lType
    pbmsg.lKey  = lKey
    pbmsg.lCount   = lCount
    pbmsg.szParams = szParams

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)        
        end
    end
    gameReq.CallRpc("common", "GMCommSetReq", rsp_call, pbmsg)
end


function _M:getPKList(lType  , call )

    local pbmsg = msgpack.newmsg("GetGeneralPKListReq")
    pbmsg.lType = lType

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("getPKList", "getPKList", rsp_call, pbmsg)
end

function _M:PKRequest(lType , lParam ,  hero_arr , call)

    local pbmsg = msgpack.newmsg("GeneralPKActionReq")
    pbmsg.lType = lType or 1 
    pbmsg.lParam = lParam or global.userData:getUserId()
    pbmsg.lGeneral = hero_arr

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)

                if lType and lType == 1 and msg and msg.tagRecord then
                    global.EasyDev:tDArenaEnter(tostring(msg.tagRecord.lAtkRank or ""))
                    if msg.tagRecord.lResult == 1 then
                        global.EasyDev:tDArenaWin(tostring(msg.tagRecord.lAtkRank or ""), tostring("0"))
                    else
                        global.EasyDev:tDArenaLost(tostring(msg.tagRecord.lAtkRank or ""), tostring("0"))
                    end
                end

            end 
        end
    end

    gameReq.CallRpc("GeneralPKActionReq", "GeneralPKActionReq", rsp_call, pbmsg)
end


function _M:getPKRecordList(lPage , call)

    local pbmsg = msgpack.newmsg("GetPKRecordListReq")
    pbmsg.lMin = lPage 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("getPKRecordList", "getPKRecordList", rsp_call, pbmsg)
end

function _M:getPKRankInfo(lUserID , call)

    local pbmsg = msgpack.newmsg("GetPubGPKInfoReq")
    pbmsg.lUserID = lUserID 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("GetPubGPKInfoReq", "GetPubGPKInfoReq", rsp_call, pbmsg)
end


function _M:buildPKGroup(lType ,lGeneral,  call)

    local pbmsg = msgpack.newmsg("SetGeneralGroupReq")
    pbmsg.lType = lType or 1 
    pbmsg.lGeneral = lGeneral 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("buildPKGroup", "buildPKGroup", rsp_call, pbmsg)
end


function _M:inviteApi(lType ,lTaskID, lInviteCode , call)--1 拉取列表 2 领取奖励 3 绑定code

    local pbmsg = msgpack.newmsg("InviteCodeTaskReq")
    pbmsg.lType = lType or 1 
    pbmsg.lTaskID = lTaskID 
    pbmsg.lInviteCode = lInviteCode 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("InviteCodeTaskReq", "InviteCodeTaskReq", rsp_call, pbmsg)
end


function _M:sendGameFps(i_fps)
    if global.tools:isWindows() or not global.guideMgr:isPlaying() then
        return
    end

    local pbmsg = msgpack.newmsg("GameCommonReq")
    pbmsg.szParam = i_fps
    pbmsg.lType = 3
    local rsp_call = function(msg,ret)
    end
    gameReq.CallRpcSilentAndNoRetry("sendGameFps","sendGameFps",rsp_call,pbmsg)
end 

function _M:sendGameBadNetTimes(i_badNetTimes)
    if global.tools:isWindows() then
        return
    end
    
    local pbmsg = msgpack.newmsg("GameCommonReq")
    pbmsg.szParam = i_badNetTimes
    pbmsg.lType = 4
    local rsp_call = function(msg,ret)
        global.badNetDt = 0
        global.badNetTimes = 0
    end
    gameReq.CallRpcSilentAndNoRetry("sendGameBadNetTimes","sendGameBadNetTimes",rsp_call,pbmsg)
end 

function _M:sendMemWarningTimes()
    if global.tools:isWindows() then
        return
    end
    
    local pbmsg = msgpack.newmsg("GameCommonReq")
    if global.tools:isIos() then
        pbmsg.szParam = 0
    else
        pbmsg.szParam = 1
    end
    pbmsg.lType = 5
    local rsp_call = function(msg,ret)
    end
    gameReq.CallRpcSilentAndNoRetry("sendMemWarningTimes","sendMemWarningTimes",rsp_call,pbmsg)
end 

-- global.commonApi:sendChangeSceneDt()
function _M:sendChangeSceneDt(dt)
    if global.tools:isWindows() or not global.guideMgr:isPlaying() then
        return
    end
    
    local pbmsg = msgpack.newmsg("GameCommonReq")
    -- 0#dt:loading时间 1#dt:内城切外城时间，2#dt 外城切内城时间
    pbmsg.szParam = dt
    pbmsg.lType = 6
    local rsp_call = function(msg,ret)
        global.badNetDt = 0
        global.badNetTimes = 0
    end
    gameReq.CallRpcSilentAndNoRetry("sendChangeSceneDt","sendChangeSceneDt",rsp_call,pbmsg)
end 


function _M:answerQuestion(call, lID, tgAnswer, szparam)

    local pbmsg = msgpack.newmsg("AnswerQuestionReq")
    pbmsg.lID = lID 
    pbmsg.tgAnswer = tgAnswer 
    pbmsg.szparam = szparam 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if call then 
                call(msg)
            end 
        end
    end

    gameReq.CallRpc("AnswerQuestionReq", "AnswerQuestionReq", rsp_call, pbmsg)

end

global.commonApi = _M

--endregion

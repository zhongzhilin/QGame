---@classdef LogicRequest
local LogicRequest = { mLastSycnTimeReturned = true }
local global = global
local gevent = gevent
local netRpc = global.netRpc
local gameEvent = global.gameEvent

local msgpack = require "msgpack"

local WCODE = WCODE

--@mod : 一般情况为 "data"
--@method ：对应协议模块名
-- 白名单内的协议全部不检测网络
local whiteList = {
    "ClickPointReport",
    "GameCommonReq",
    "SendClientidReq",
    "GetUserRankReq",
    "AllyMemberlistReq",
    "ReplyApplyReq",
    "GetAllyMiracleReq",
    "GetRandUserReq",
    "GetAllyWarInfoReq",
    "AllyRelationListReq",
    "AllyLeaveMsgReq",
    "AllyWarRecordReq",
    "AllyMsgListReq",
    "AllyActListReq",
    "GetUserRankListReq",
    "GetAllyTaskListReq",
    "ExitAllyReq",
    "GetAchieveTaskListReq",
    "GetAllyRightReq",
    "GetAllyShopReq",
    "EffectQueueReq",
    "EquipStrongReq",
    "GetShopingInfoReq",
    "GetRedCountReq",
    "SaleItemReq",
    "GetHeroInfoReq",
    "ConditionSuccReq",
    "SendClientidReq",
    "GetPushInfoReq",
    "UpdateProfileReq",
    "GateInfoReq",
    "GetSalaryInfoReq",
    "AllyVillageListReq",
    "RecordRechargeReq",
    "ClickReportReq",
    "SignFPSStateReq",
    "QueryLeastObjReq",
    "GetAvatarSkinReq",
    "GetUserFriendReq",
    "GetHeroBuildGarrisonReq",
    "GetFiredLogReq",
    "QueryMiracleHistoryReq",
    "GetAllyBuildHelpReq",
    "ResourceDropReq",
    "WorldCityDefReq",
    "ExitWorldReq",
    "GetFiredLogReq",
    "GetFiredLogReq",
    "GetFiredLogReq",

    "CTGetRecordListReq",
    "CTGetMsgInfoReq",
    "CTGetSpecialInfoReq", 
    "CTCloseWindowReq",
    "CTFightShareListReq", 
    "CTRemoveListReq",
    "CTGetUnReadReq", 
    "CTGetMailBeforeReq",  
}
-- noModal = true ：无模态 false 有模态
--         = 1     ：无点击屏蔽，有按钮屏蔽，无转圈
--         = 2     :无点击屏蔽，无按钮屏蔽，无转圈
function LogicRequest.CallRpc(mod, method, callBack, args, noModal)
    local callBackWrapper = function(code, rspmsg)
        local tag = "SUCCESS"
        if code.retcode ~= WCODE.OK then
            tag = "ERROR"
            
            -- 如果是仓库已经满了，则做特殊处理
            if code.retcode == 55 then                
                global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=11083, target=7})
            elseif code.retcode == 499 then  
                if global.g_worldview then
                    local reslv = global.g_worldview.const:convertCityId2ResLevel(global.userData:getWorldCityID()) 
                    local cityLv = global.luaCfg:get_map_unlock_by(reslv).KeyLv
                    local errorData = global.luaCfg:get_errorcode_by(tostring(code.retcode))    
                    global.tipsMgr:showWarningText(string.format(errorData.text, cityLv))
                end
            else
                local errorData = global.luaCfg:get_errorcode_by(tostring(code.retcode))
                if errorData then
                    if code.head and code.head.lParam then
                        global.tipsMgr:showWarningText(string.format(errorData.text,global.funcGame.formatTimeToHMS(code.head.lParam)))                    
                    else
                        global.tipsMgr:showWarningText(errorData.text)
                    end
                end
            end            
        end
        log.trace("!%s! rpc.call(%s, %s) code %s, %s", tag, mod, method, vardump(code), vardump(rspmsg))
        callBack(code, rspmsg)

        if global.guideMgr then
            global.guideMgr:checkWaitNetMethod(method)
        end 
    end 

    if global.guideMgr then
        global.guideMgr:setWaitNetMethod(method)
    end    

    -- noModal = (noModal==nil) and 1 or noModal
    noModal = noModal and 2 or noModal
    if args.msgtype__ and table.hasval(whiteList,args.msgtype__) then
        noModal = 2
    end
	log.debug("CallRpc: mod %s, method %s, args %s", mod, method, vardump(args))
    netRpc:Call(mod, method, callBackWrapper, args, noModal)
end

function LogicRequest.CallRpcSilent(mod, method, callBack, args)
    local callBackWrapper = function(code, rspmsg)
        local tag = "SUCCESS"
        if code.retcode ~= WCODE.OK then
            tag = "ERROR"
        end
        -- log.trace("!%s! rpc.call(%s, %s) code %s, %s", tag, mod, method, vardump(code), vardump(rspmsg))
        callBack(code, rspmsg)
    end 
    netRpc:CallSilent(mod, method, callBackWrapper, args)
end

function LogicRequest.CallRpcSilentAndNoRetry(mod, method, callBack, args)
    local callBackWrapper = function(code, rspmsg)
        local tag = "SUCCESS"
        if code.retcode ~= WCODE.OK then
            tag = "ERROR"
        end
        -- log.trace("!%s! rpc.call(%s, %s) code %s, %s", tag, mod, method, vardump(code), vardump(rspmsg))
        callBack(code, rspmsg)
    end 
    netRpc:CallSilentAndNoRetry(mod, method, callBackWrapper, args)
end

-- gmcmd 
--------------------------------------------------------------------
function LogicRequest.GmCmd(cmd, arg1, ...)
    
    local params = ...
    
    log.debug("params %s", vardump(params))
    
    local function rsp_gmcmd(res, ...)
        local returnMsg = ...
        log.debug("gmcmd response:%d, msg %s", res, vardump(returnMsg))
    end
    
    if type(arg1) == "function" then
        netRpc:Call("gmcmd", cmd, arg1, ...)
    else
        netRpc:Call("gmcmd", cmd, rsp_gmcmd, arg1, ...)
    end
end


-- 同步服务器时间
function LogicRequest:SyncTime()
    if global.netRpc:IsConnected() and self.mLastSycnTimeReturned == true then
        CallRpcSilentAndNoRetry("data", "syt", function(ret, msg)
            self.mLastSycnTimeReturned = true
            if ret == HQCODE.OK then
                gevent:call(gameEvent.EV_ON_SYNC_SVR_TIME, msg.tm)
            end
        end)
        self.mLastSycnTimeReturned = false
    end
end 

-- profile
---------------------------------------------------
function LogicRequest:SyncProfile()
    local dataMgr = global.dataMgr
    local userData = global.userData
    local function rsp_sync_profile(res, profile)
        if res ~= HQCODE.OK then
            log.debug("sync profile failed: %d", res)
        else
            -- profile { svr_time = xxx, props = {} }
            local diffTime = dataMgr:getServerTime() - profile.svr_time
            log.debug("cs diff time:%s", diffTime)

            userData:syncProp(profile.props)
            
            gevent:call(global.gameEvent.EV_ON_USERDATA_REFRESH)
        end
    end
    
    CallRpcSilentAndNoRetry("data", "sync_profile", rsp_sync_profile)
end

function LogicRequest:SyncData()
    
    local function rsp_sync_data(res, profile)
        if res ~= HQCODE.OK then
            log.debug("sync data failed: %d", res)
        else
            log.debug("sync data %s", vardump(profile))
            self:OnSyncEnd(res, profile)
        end

        self:resetFlag()
        global.buildingAPI:clearFlag()
        global.activityAPI:clearFlag()
    end
    
    CallRpcSilentAndNoRetry("data", "sync", rsp_sync_data)
end

function LogicRequest:OnSyncEnd(res, profile)

    -- syncRet { svr_time = xxx, prop = {}, cd_info = {} }
    
    if profile.prop then                
        userData:syncProp(profile.prop)
    end

    if profile.cd_info then
        uCDData:setData(profile.cd_info)
    end

    if profile.build then
        global.buildingData:setData(profile.build)
    end

    if profile.guild then
        guildData:SetUserGuild(profile.guild)
    end

    if profile.daily_beated then
        global.pvpData:setPvpDailyBeatedTimes(profile.daily_beated)
    end

    if profile.recharge_gift_flag then
        global.miscData:setActRechargeisON(profile.recharge_gift_flag or 0)
    end

    gevent:call(gameEvent.EV_ON_USERDATA_REFRESH)
end

global.gameReq = LogicRequest

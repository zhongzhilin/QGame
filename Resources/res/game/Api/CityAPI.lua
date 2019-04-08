--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"
local luaCfg = global.luaCfg

local _M = {}

-- 只有在世界上训练士兵完成通知能够使用
function _M:updateBuildingsBySoldiers(soldiers)
    local cityData = global.cityData
    local tipsMgr = global.tipsMgr
    local ids = {}
    for i,v in ipairs(soldiers) do
        local id,data = cityData:getBuildingIdBySoldierId(v.lID)
        if id then
            table.insert(ids,id)
        end
    end
    self:updateBuildingsByIds(callBack, ids)
end

-- 获取对应id的建筑的信息
function _M:updateBuildingsByIds(callBack, ids)
    local pbmsg = msgpack.newmsg("GetBuildsInfoReq")
    pbmsg.lIDs = ids

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.cityData:updateBuildings(msg.tgBuilds)
            if callBack then callBack() end
            gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)
        end
    end
    gameReq.CallRpc("city", "GetBuildsInfo", rsp_call, pbmsg)
end

function _M:buildUpgrade(id, callBack, lType, noModal)
    local pbmsg = msgpack.newmsg("BuildUpgradeReq")
    pbmsg.lBuildID = id
    pbmsg.lType = lType or 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if id == 4 then
                --校场增加人口数量
                local lvId = id*1000+msg.tgBuild.lGrade
                local popuData = luaCfg:get_buildings_lvup_by(lvId)
                -- global.userData:setMaxPopulation(popuData.severPara1)
            end
            if id == 1 and msg.tgBuild and msg.tgBuild.lGrade == 10 then
                -- 主城到达十级上报数据
                CCHgame:AdLevelAchieved(msg.tgBuild.lGrade,0)
            end
            if id == 1 and msg.tgBuild and msg.tgBuild.lGrade > 1 then
                -- 主城解锁新功能
                local unLockData = global.luaCfg:get_city_lvup_by(msg.tgBuild.lGrade)
                if unLockData.maxNum > 0 then
                    global.panelMgr:openPanel("UIUnLockFunPanel"):setData(unLockData, msg.tgBuild.lGrade)
                end
            end
            callBack(msg)

            -- 数据刷新处理
            global.dailyTaskData:refershLockState(id)
            global.headData:refUseStateByBuildId(id)
            global.refershData:setRefershCount(id, msg.tgBuild.lGrade)

            if id == 15 and msg.tgBuild and msg.tgBuild.lGrade == 1 then
                gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
            end
            gevent:call(global.gameEvent.EV_ON_UPGRADE_CITY, id)
            gevent:call(global.gameEvent.EV_ON_UI_BUILD_RED_FLUSH)
        end
    end

    global.commonApi:sendGameFps("1#"..CCHgame:getFps())
    gevent:call(gsound.EV_ON_PLAYSOUND,"city_complete")
    gameReq.CallRpc("city", "build_upgrade", rsp_call, pbmsg, noModal)
end

--消除队列cd  lType=0清除免费cd，=1 解锁队列
function _M:clearQueue(lID, lType,callBack, lBuildID, lToolID, lCount, errorCall)
    local pbmsg = msgpack.newmsg("ClearQueueReq")
    pbmsg.lID = lID
    pbmsg.lType = lType or 0
    pbmsg.lBuildID = lBuildID
    pbmsg.lToolID = lToolID 
    pbmsg.lCount = lCount

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        else
            if errorCall then
                errorCall()
            end
        end
    end

    gsound.stopEffect("ui_item")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_cd")
    
    global.commonApi:sendGameFps("2#"..CCHgame:getFps())
    gameReq.CallRpc("city", "clear_queue", rsp_call, pbmsg)
end

--收获
function _M:buildHarvest(lBuildID, callBack, errorCall, lQID, soldierId)
    local pbmsg = msgpack.newmsg("BDHarvestReq")
    pbmsg.lBuildID = lBuildID
    pbmsg.lQID = lQID
    local listId = lBuildID .. (soldierId or "") -- 士兵训练队列

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then

            global.finishData:removeSpecList(listId)

            callBack(msg)
            global.heroData:refershBuildGarrison() -- 驻防英雄建筑信息更新
            gevent:call(global.gameEvent.EV_ON_SOLDIER_HARVEST)
        else
            if errorCall then errorCall(ret,msg) end
            if errorCall and ret.retcode == 50 then
                global.finishData:removeSpecList(listId) -- 资源满队列
            end
        end
    end
    gameReq.CallRpc("city", "bd_harvest", rsp_call, pbmsg,true)
end

--训练士兵
function _M:trainSoldier(lBuildID, lArmID, lCount, callBack, lType)
    local pbmsg = msgpack.newmsg("BDTrainReq")
    pbmsg.lBuildID = lBuildID
    pbmsg.lArmID = lArmID
    pbmsg.lCount = lCount
    pbmsg.lType = lType or 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
            global.heroData:refershBuildGarrison() -- 驻防英雄建筑信息更新
        end
    end
    gameReq.CallRpc("city", "bd_train_soldier", rsp_call, pbmsg)
end


--城墙设备建造
function _M:buildDevice(lBuildID, lArmID, lCount, callBack)
    local pbmsg = msgpack.newmsg("BDTrainReq")
    pbmsg.lBuildID = lBuildID
    pbmsg.lArmID = lArmID
    pbmsg.lCount = lCount

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    rsp_call()
    -- gameReq.CallRpc("city", "bd_train_soldier", rsp_call, pbmsg)
end

-- 新建部队
function _M:troopManager(lType, tgTroop, callBack)
    local pbmsg = msgpack.newmsg("TroopActionReq")
    pbmsg.lType = lType
    pbmsg.tgTroop = tgTroop

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("city", "new_troop", rsp_call, pbmsg)
end

-----------------------------------伤兵营----------------------------------------
--0 单个治疗,1免费治疗 ，2魔金全部治疗,3单个招募使用金币，4单个招募使用魔金，5全体招募金币，6全体招募魔金
function _M:healSoldier(callBack, lType, lSID, lCount)
    local pbmsg = msgpack.newmsg("HealSoldierReq")
    pbmsg.lType = lType
    pbmsg.lSID = lSID
    pbmsg.lCount = lCount

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("city", "heal_soldier", rsp_call, pbmsg)
end

-----------------------------------GM----------------------------------------
--　建筑全开
function _M:buildAllOpen(callBack)
    local pbmsg = msgpack.newmsg("GMBuildAllReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then

            callBack(msg)
        end
    end
    gameReq.CallRpc("gm", "bd_city_allOpen", rsp_call, pbmsg)
end

function _M:troopGarrison(id,state,callBack)
    
    local pbmsg = msgpack.newmsg("TroopGarrisonReq")

    pbmsg.lTroopid = id
    pbmsg.lStatus = state

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then

            callBack(msg)
        end
    end
    
    gameReq.CallRpc("troop", "TroopGarrisonReq", rsp_call, pbmsg)
end

-- 资源全满
function _M:resourceAll(callBack)
    local pbmsg = msgpack.newmsg("GMResReadyReq")   

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end
    gameReq.CallRpc("gm", "res_resourse_allAdd", rsp_call, pbmsg)
end

-- 全资源增加
function _M:resourceUp(callBack)
    local pbmsg = msgpack.newmsg("GMResAddReq")   

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end
    gameReq.CallRpc("gm", "resourse_up", rsp_call, pbmsg)
end

-- 增加士兵
function _M:soldierUp(callBack)
    local pbmsg = msgpack.newmsg("GMSoldierAddReq")   

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end
    gameReq.CallRpc("gm", "soldier_up", rsp_call, pbmsg)
end

-- 更改整点通知时间
function _M:gmSetSTimeReq(callBack,lReset)
    local pbmsg = msgpack.newmsg("GMSetSTimeReq")
    pbmsg.lReset = lReset

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end
    gameReq.CallRpc("gm", "soldier_up", rsp_call, pbmsg)
end


-- 修改城堡简介
function _M:modifyCitySimpleIntroduction(lCityId,lProfile,callBack)
    local pbmsg = msgpack.newmsg("UpdateProfileReq")
    pbmsg.lCityId = lCityId
    pbmsg.lProfile = lProfile
    dump(pbmsg,"pbmsg")
    local rsp_call = function(ret, msg)
    dump(ret,"ret")
    dump(msg,"msg")
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("UpdateProfileReq", "UpdateProfileReq", rsp_call, pbmsg)
end



-- 返还兵源
function _M:returnSoldierSource(lSid , lCount, callBack)
    local pbmsg = msgpack.newmsg("WoundDismissReq")
    pbmsg.lSid = lSid
    pbmsg.lCount = lCount
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("returnSoldierSource", "returnSoldierSource", rsp_call, pbmsg)
end


-- 获取任命列表
function _M:getGarrisonList(callBack)
    local pbmsg = msgpack.newmsg("GetBuildGarrisonReq")
 
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("garrison", "GetBuildGarrisonReq", rsp_call, pbmsg)
end

function _M:getHeroGarrisonList(callBack, lBuild, lPos)
    local pbmsg = msgpack.newmsg("GetHeroBuildGarrisonReq")
    pbmsg.lBuild = lBuild
    pbmsg.lPos = lPos
 
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("garrison", "GetHeroBuildGarrisonReq", rsp_call, pbmsg)
end

-- 英雄任命
function _M:setGarrison(callBack, lBuild, lGeneral, lPos)
    local pbmsg = msgpack.newmsg("SetBuildGarrisonReq")
    pbmsg.lBuild = lBuild
    pbmsg.lGeneral = lGeneral
    pbmsg.lPos = lPos
 
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("garrison", "SetBuildGarrisonReq", rsp_call, pbmsg)
end


global.cityApi = _M

--endregion

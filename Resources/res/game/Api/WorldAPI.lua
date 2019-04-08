--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

function _M:enterWorld(callBack)
    local pbmsg = msgpack.newmsg("UserEnterWorldReq")    

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "world_enter", rsp_call, pbmsg)
end

function _M:querySituation(callback)
    
    local pbmsg = msgpack.newmsg("TroopSituationAllReq")    

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "TroopSituationAllReq", rsp_call, pbmsg)
end

function _M:queryLandsCanBeChoose(callback)
    
    local pbmsg = msgpack.newmsg("ValidAreaMapReq")    

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "ValidAreaMapReq", rsp_call, pbmsg)
end


function _M:miracleStarUp(cityID,callback)
    
    local pbmsg = msgpack.newmsg("MiracleUpgradeReq")    
    pbmsg.lElementID = cityID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "MiracleUpgradeReq", rsp_call, pbmsg)
end

function _M:getCitySituation(cityId,callback,noModal)
    
    local pbmsg = msgpack.newmsg("TroopInComingReq")
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "TroopInComingReq", rsp_call, pbmsg, noModal) 
end

function _M:queryLeastObj(objType,callback,errorCall,level,isModal)
   
    local pbmsg = msgpack.newmsg("QueryLeastObjReq")
    pbmsg.lQueryType = objType
    pbmsg.lLevel = level
    pbmsg.lForce = 1

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        else
            errorCall(msg)
        end
    end

    gameReq.CallRpc("world", "QueryLeastObjReq", rsp_call, pbmsg, isModal)  
end

function _M:searchWorldObj(objType,level,index,kind,callback,nofindcallback)
   
    local pbmsg = msgpack.newmsg("QueryLeastObjReq")
    pbmsg.lQueryType = objType
    pbmsg.lLevel = level
    pbmsg.lIndex = index
    pbmsg.lKind = kind
    pbmsg.lForce = 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        else
            nofindcallback(msg)
        end
    end

    gameReq.CallRpc("world", "QueryLeastObjReq", rsp_call, pbmsg, noModal)  
end

--GMMiracleOccupyReq
function _M:miracleOccupyReq(cityId,callback)
    
    local pbmsg = msgpack.newmsg("GMMiracleOccupyReq")
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GMMiracleOccupyReq", rsp_call, pbmsg) 
end

function _M:passTroop(lTransferID,lMapAreaID,lTroopID,callback,lType)
    
    local pbmsg = msgpack.newmsg("MapTransferReq")
    pbmsg.lTransferID = lTransferID
    pbmsg.lMapAreaID = lMapAreaID
    pbmsg.lTroopID = lTroopID
    pbmsg.lType = lType or 1

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "MapTransferReq", rsp_call, pbmsg) 
end

function _M:createMapUser(cityName,areaId,callback)
    
    local pbmsg = msgpack.newmsg("CreateMapCityReq")
    pbmsg.szCityName = cityName
    pbmsg.lAreaID = areaId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "CreateMapCityReq", rsp_call, pbmsg) 
end

function _M:queryMiracleOwner(callback, lLandID, lPage)
    
    local pbmsg = msgpack.newmsg("QueryMiracleHistoryReq")
    pbmsg.lLandID = lLandID
    pbmsg.lPage = lPage

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "QueryMiracleHistoryReq", rsp_call, pbmsg)   
end

function _M:LegendMiracleOccupyInfo(landID,callback)
    
    local pbmsg = msgpack.newmsg("LegendMiracleOccupyInfoReq")
    pbmsg.lLandID = landID

    local rsp_call = function(ret, msg)

        dump(ret,">>>math.sin")

        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "LegendMiracleOccupyInfoReq", rsp_call, pbmsg)   
end

function _M:openTipsCloseTips(cityId,isOn,callback)
    
    local pbmsg = msgpack.newmsg("CityStickerOnOffReq")
    pbmsg.lMapID = cityId
    pbmsg.lOn = isOn

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "CityStickerOnOffReq", rsp_call, pbmsg) 
end

function _M:queryTips(cityId,num,skipNum,callback)
    
    local pbmsg = msgpack.newmsg("QueryMapStickerReq")
    pbmsg.lMapID = cityId
    pbmsg.lNum = num
    pbmsg.lSkipNum = skipNum

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "QueryMapStickerReq", rsp_call, pbmsg) 
end

function _M:addTips(cityId,contnet,colorIndex,callback)
    
    local pbmsg = msgpack.newmsg("WriteStickerReq")
    pbmsg.lMapID = cityId
    pbmsg.szContent = contnet
    pbmsg.lColor = colorIndex

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "WriteStickerReq", rsp_call, pbmsg) 
end

function _M:deleteTips(lMapID,lStickerID,callback)
    
    local pbmsg = msgpack.newmsg("DelStickerReq")
    pbmsg.lMapID = lMapID
    pbmsg.lStickerID = lStickerID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "DelStickerReq", rsp_call, pbmsg) 
end


function _M:giveupOcc( cityId,callback )    

    local pbmsg = msgpack.newmsg("GiveUpOccupyReq")
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GiveUpOccupyReq", rsp_call, pbmsg)
end

function _M:exitWorld(callBack)
    
    local pbmsg = msgpack.newmsg("ExitWorldReq")    

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
        end
    end

    callBack(msg)

    gameReq.CallRpc("world", "ExitWorldReq", rsp_call, pbmsg,true)
end

function _M:removeProtection(callback)

    local pbmsg = msgpack.newmsg("RemoveProtectionReq")        

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "RemoveProtectionReq", rsp_call, pbmsg)
end

function _M:checkOccupy( city , callback )
    
    local cityType = 0


    if city.isWildRes then
        cityType = 2

        if city:isMiracle() then
            
            callback({lStatus = 0})
            
            return
        end
    elseif city:isEmpty() then

        cityType = 0

        if city.isMagic and city:isMagic() then

            cityType = 3
        end
    else

        cityType = 1

        if city.isMagic and city:isMagic() then

            cityType = 3
        end
    end

    local pbmsg = msgpack.newmsg("CheckOccupyStateReq")        
    pbmsg.lType = cityType

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "CheckOccupyStateReq", rsp_call, pbmsg)
end

function _M:getCityPos( cityId , callBack )
    
    local pbmsg = msgpack.newmsg("WorldCityPosReq")    
    pbmsg.lCityId = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "WorldCityPosReq", rsp_call, pbmsg)
end

function _M:getTroopData( userId,troopId,callBack )
    
    local pbmsg = msgpack.newmsg("WorldTroopDataReq")    
    local lArgs = {}
    table.insert(lArgs,userId)
    table.insert(lArgs,troopId)
    pbmsg.lArgs = lArgs

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "WorldTroopDataReq", rsp_call, pbmsg) 
end

function _M:getTroopsData( args,callBack )
    
    local pbmsg = msgpack.newmsg("WorldTroopDataReq")        
    pbmsg.lArgs = args

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "WorldTroopDataReq", rsp_call, pbmsg) 
end

function _M:getCityData(cityId,callBack)
    
    local pbmsg = msgpack.newmsg("WorldCityDataReq")    
    pbmsg.lCityId = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "WorldCityDataReq", rsp_call, pbmsg,false) 
end

function _M:flushWorld(ids,dataArea,callBack)
    local pbmsg = msgpack.newmsg("UserFlushWorldReq")    
    pbmsg.lAreaID = ids
    pbmsg.lDataAreaID = dataArea

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "UserFlushWorldReq", rsp_call, pbmsg,true)
end

function _M:callFight(userId,callBack)
    
    local pbmsg = msgpack.newmsg("WorldCallFightReq")    
    pbmsg.lUserId = userId

    print(userId,".....................<<<<")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_battle")
            callBack(msg)
        elseif ret.retcode == 486 then
            global.tipsMgr:showWarning("dip_2nd")
        end
    end

    gameReq.CallRpc("world", "WorldCallFightReq", rsp_call, pbmsg)    
end

function _M:moveCity(cityId,callBack)

    local pbmsg = msgpack.newmsg("UserMoveCityReq")        
    pbmsg.lCityUniqueId = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            gevent:call(gsound.EV_ON_PLAYSOUND,"world_movecity")
            callBack(msg)
        else
            
            if global.scMgr:isWorldScene() then

                global.g_worldview.mapPanel:closeChoose()
            end            
        end
    end

    gameReq.CallRpc("world", "UserMoveCityReq", rsp_call, pbmsg)
end

function _M:attackCity(cityId,aimId,attackType,troopId,lForce,callBack)

    local pbmsg = msgpack.newmsg("UserWorldAttactReq")        

    pbmsg.lStartUniqueId = cityId
    pbmsg.lEndUniqueId = aimId
    pbmsg.lAttackType = attackType
    pbmsg.lTroopId = troopId
    pbmsg.lForce = lForce

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            if global.guideMgr:isPlaying() then
                gevent:call(gsound.EV_ON_PLAYSOUND,"world_action")
            end
            
            callBack(msg)
        else

            if ret.retcode == 100001 then
                --带参数
                if global.scMgr:isWorldScene() then
                    local boss = global.g_worldview.mapPanel:getWildObjById(aimId)
                    if boss then
                        local gateData = global.luaCfg:get_gateboss_by(boss.data.lBind or 1) 
                        global.tipsMgr:showWarning("Uniontask09",gateData.StarsScale)
                    end
                end
            elseif ret.retcode == 100002 then
                --带参数
                if global.scMgr:isWorldScene() then
                    local boss = global.g_worldview.mapPanel:getWildObjById(aimId)
                    if boss then
                        local gateData = global.luaCfg:get_gateboss_by(boss.data.lBind or 1)
                        local troopData = global.troopData:getTroopById(troopId)
                        local heroData =  global.heroData:getHeroDataById(troopData.lHeroID[1])
                        local power = heroData.serverData.lPower
                        if power < gateData.heroPower  then
                            global.tipsMgr:showWarning("heroPowerNotEnough")            -- 英雄战力不足
                        else 
                            global.tipsMgr:showWarning("limitBoss03",gateData.herotype) -- 携带英雄类型不对
                        end
                    end
                end 
            elseif ret.retcode == 100003 then
                global.tipsMgr:showWarning("troopMaxGateBoss") -- 已达到部队上限
            end

        end
    end

    gameReq.CallRpc("world", "UserWorldAttactReq", rsp_call, pbmsg)
end

function _M:gmBattle(callback)
    
    local pbmsg = msgpack.newmsg("GMCityLastFightRsq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            dump(msg)
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "gmBattle", rsp_call, pbmsg)
end

function _M:pathTime(start,endd,troopId,attackType,lForce,callBack)
    
    local pbmsg = msgpack.newmsg("PathTimeReq")        

    pbmsg.lStartID = start
    pbmsg.lEndID = endd
    pbmsg.lTroopID = troopId
    pbmsg.lAttackType = attackType
    pbmsg.lForce = lForce

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callBack(msg)
        else
            if ret.retcode == 100001 then
                --带参数
                if global.scMgr:isWorldScene() then
                    local boss = global.g_worldview.mapPanel:getWildObjById(endd)
                    if boss then
                        global.tipsMgr:showWarning("Uniontask09",boss:getDesignDataScale())
                    end
                end
            end
        end
    end

    gameReq.CallRpc("world", "PathTimeReq", rsp_call, pbmsg)
end

function _M:callBackTroop(id,isReturn,callBack)
    
    local pbmsg = msgpack.newmsg("TroopRecallReq")

    pbmsg.lTroopid = id
    pbmsg.lReturn = isReturn

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            if global.guideMgr:isPlaying() then
                gevent:call(gsound.EV_ON_PLAYSOUND,"world_action")
            end

            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "TroopRecallReq", rsp_call, pbmsg)
end

function _M:recallAllTroop(cityId,callBack)
    
    local pbmsg = msgpack.newmsg("RecallAllTroopReq")

    pbmsg.lElementID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "RecallAllTroopReq", rsp_call, pbmsg)
end

function _M:getBossInfo(monsterId,callBack)
    
    local pbmsg = msgpack.newmsg("GetBossInfoReq")

    pbmsg.lMonsterId = monsterId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "GetBossInfoReq", rsp_call, pbmsg)
end

function _M:ResourceDrop(cityId,callBack)
    
    local pbmsg = msgpack.newmsg("ResourceDropReq")

    pbmsg.lElementID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then            
            callBack(msg)
        end
    end

    gameReq.CallRpc("world", "ResourceDropReq", rsp_call, pbmsg)
end

-- 战斗详情
-- lmapid： 城堡id
function _M:infoBattle(callback, lmapid)
    
    local pbmsg = msgpack.newmsg("MapFightInfoReq")
    pbmsg.lmapid = lmapid

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("world", "infoBattle", rsp_call, pbmsg)
end

-- 开启城防值通知
function _M:worldCityDef(callback, lFlag, lCityID, errorCall)
    
    local pbmsg = msgpack.newmsg("WorldCityDefReq")
    pbmsg.lFlag = lFlag
    pbmsg.lCityID = lCityID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            if errorCall then errorCall() end
        end
    end
    gameReq.CallRpc("world", "worldCityDef", rsp_call, pbmsg, true)
end

-- 获取世界奇迹点
function _M:mapMiracle(callback)
    
    local pbmsg = msgpack.newmsg("MapMiracleReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("world", "MapMiracle", rsp_call, pbmsg)
end

function _M:rebuildCity(callback)
    
    local pbmsg = msgpack.newmsg("CityRebuildReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            global.panelMgr:closePanel("FireFinish")
        end
    end
    gameReq.CallRpc("world", "CityRebuildReq", rsp_call, pbmsg)
end

function _M:getCityDetail( id , callback )
    
    local pbmsg = msgpack.newmsg("CityDetailReq")
    pbmsg.lCityID = id

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "CityDetailReq", rsp_call, pbmsg)
end

--遣返 遣回
function _M:callStayBack(cityId,troopId,callback)
    
    local pbmsg = msgpack.newmsg("ReinforceReturnReq")
    pbmsg.lCityID = cityId
    pbmsg.lTroopID = troopId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("world", "callStayBack", rsp_call, pbmsg)
end

-- 搜藏
--required int32      lID = 1;
--required int32      lType = 2;//1新增或修改、2删除
--required int32      lkind = 3;//0中立，1友方，2敌方
function _M:setBookMark(lID,lCityID,lType, lkind, lMapID, lPosX, lPosY, szTitle, callback)
    
    local pbmsg = msgpack.newmsg("SetBookMarkReq")
    pbmsg.lID = lID
    pbmsg.lCityID = lCityID
    pbmsg.lType = lType
    pbmsg.lkind = lkind
    pbmsg.lMapID = lMapID
    pbmsg.lPosX = lPosX
    pbmsg.lPosY = lPosY
    pbmsg.szTitle = szTitle

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("world", "setBookMark", rsp_call, pbmsg)
end

function _M:getBookMark(callback)
    
    local pbmsg = msgpack.newmsg("GetBookMarkListReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("world", "getBookMark", rsp_call, pbmsg, false)
end

function _M:getOffical(callback)
    local pbmsg = msgpack.newmsg("OfficialActionReq")
    pbmsg.lType = 1
    pbmsg.lMapArea = 0 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then        
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "OfficialActionReq", rsp_call, pbmsg)
end

function _M:setOffical(landId,offId,userId,callback)
    local pbmsg = msgpack.newmsg("OfficialActionReq")
    pbmsg.lType = 2
    pbmsg.lMapArea = landId
    pbmsg.lOfficialID = offId
    pbmsg.lUserID = userId 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then        
            callback(msg)
        elseif ret.retcode == 602 then
            -- print(msg.lCoolTime,'awdawdawddwa')
            global.tipsMgr:showWarning('nextOfficial',global.funcGame.formatTimeToHMS(msg.lCoolTime))
        end
    end
    
    gameReq.CallRpc("world", "OfficialActionReq", rsp_call, pbmsg)
end

function _M:dropOffical(landId,offId,callback)
    local pbmsg = msgpack.newmsg("OfficialActionReq")
    pbmsg.lType = 3
    pbmsg.lMapArea = landId
    pbmsg.lOfficialID = offId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then        
            callback(msg)
        end
    end
    
    gameReq.CallRpc("world", "OfficialActionReq", rsp_call, pbmsg)
end

---- 设置警戒
function _M:setAlert(lStatus, callback)
    
    local pbmsg = msgpack.newmsg("CityAlertReq")
    pbmsg.lStatus = lStatus

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          -- 设置成功
          callback(msg)
        end
    end

    gameReq.CallRpc("world", "setAlert", rsp_call, pbmsg)
end

---- 燒城
function _M:fireWall(lFlag, lCityID ,callback, errorCall)
    
    local pbmsg = msgpack.newmsg("WorldCityDefReq")
    pbmsg.lFlag = lFlag
    pbmsg.lCityID = lCityID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          -- 设置成功
          callback(msg)
        else
            if errorCall then errorCall() end
        end
    end

    gsound.stopEffect("city_click")
    -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_fire")
    gameReq.CallRpc("world", "fireWall", rsp_call, pbmsg, true)
end

function _M:getMagicTownInfo(cityId,callback)
    
    local pbmsg = msgpack.newmsg("WorldMiracleReq")    
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "WorldMiracleReq", rsp_call, pbmsg,false)
end


function _M:getUnioInfo(callback)
       
    local pbmsg = msgpack.newmsg("AllyMemberPosReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "getUnioInfo", rsp_call, pbmsg) 
end

function _M:getSuperFightInfo(callback)
       
    local pbmsg = msgpack.newmsg("GetMapSuperFightReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GetMapSuperFightReq", rsp_call, pbmsg) 
end

function _M:freeToMove(ttype,callback,errorCall)
    
    local pbmsg = msgpack.newmsg("FreeMoveCityReq")    
    pbmsg.lType = ttype

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        else

            if errorCall then errorCall() end
        end
    end

    gameReq.CallRpc("world", "FreeMoveCityReq", rsp_call, pbmsg)

end

function _M:getMagicTownInfoAfterOwn(cityId,callback)
    
    local pbmsg = msgpack.newmsg("WorldMiracleOccupyReq")    
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "WorldMiracleOccupyReq", rsp_call, pbmsg,false)
end

function _M:getOccupyBook(callback)
    
    local pbmsg = msgpack.newmsg("GetOccupyBookMarkReq")    

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GetOccupyBookMarkReq", rsp_call, pbmsg, false)
end

function _M:getMonsterTownInfo(cityId,callback)
    
    local pbmsg = msgpack.newmsg("MonsterTownInfoReq")    
    pbmsg.lMapID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callback(msg)
        end
    end

    gameReq.CallRpc("world", "getMonsterTownInf", rsp_call, pbmsg, false)
end

function _M:queryPath(startId,endId,callback)
    
    local pbmsg = msgpack.newmsg("GuideFindPathReq")
    pbmsg.lStart = startId
    pbmsg.lend = endId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callback(msg)
        end
    end

    gameReq.CallRpc("world", "GuideFindPathReq", rsp_call, pbmsg)
end

function _M:startGuideBeat(callback)
    
    local pbmsg = msgpack.newmsg("GuideStartFightReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GuideStartFightReq", rsp_call, pbmsg)
end

---- 请求小村庄所有驻防部队信息
function _M:villageTroop(lCityID, callback)
    
    local pbmsg = msgpack.newmsg("ReinforceQueryReq")
    pbmsg.lCityID = lCityID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callback(msg)
        end
    end

    gameReq.CallRpc("world", "villageTroop", rsp_call, pbmsg)
end

function _M:checkRobCount(cityId,callback)
    
    local pbmsg = msgpack.newmsg("GetRobUserReq")
    pbmsg.lCityID = cityId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
            callback(msg)
        end
    end

    gameReq.CallRpc("world", "GetRobUserResp", rsp_call, pbmsg)
end

function _M:stopFindPath(lTroopID,callBack)
    
    local pbmsg = msgpack.newmsg("StopFindPathReq")
    pbmsg.lTroopID = lTroopID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callBack(msg)
        end
    end

    gameReq.CallRpc("world", "StopFindPathReq", rsp_call, pbmsg)
end


function _M:revolt(troopId,callBack)
    
    local pbmsg = msgpack.newmsg("TroopUprisingReq")
    pbmsg.lTroopID = troopId

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callBack(msg)
        end
    end
    
    gameReq.CallRpc("world", "TroopUprisingReq", rsp_call, pbmsg)
end

function _M:decodeLandId(cityId)

    if cityId == 0 then return 0,'-' end
    
    local i = math.floor(cityId / 10000000)
    cityId = cityId % 10000000
    local j = math.floor(cityId / 10000)
    
    local map_region = global.luaCfg:map_region()
    for id,v in ipairs(map_region) do

        if i >= v.minX and i <= v.maxX and j >= v.minY and j <= v.maxY then

            return id,v.name
        end
    end    
end

_M.attackEffectList = {} --0 没有出现  1 出现  2 忽略
_M.attackCityList = {}
function _M:dealAttackEffectCommon(data)

    local userId = global.userData:getUserId()

    local id = data.lTroopID
    local reason = data.lReason 
    local isBeAttack = (data.lParty == 0)--not global.g_worldview.attackMgr:checkIsAttack(data)
    if data.lPurpose == 4 then return end    

    if isBeAttack then

        if reason == 1 then
            
            if self.attackEffectList[id] then
                self.attackEffectList[id] = nil            
            end 

            if self.attackCityList[id] then
                self.attackCityList[id] = nil           
            end            
        else            

            if self.attackEffectList[id] and self.attackEffectList[id].state == 2 then

            else
        
                self.attackEffectList[id] = {state = 1,troopState = data.lStatus}                
            end            

            if data.lPurpose == 1 and data.lStatus == 11 and data.lDst == global.userData:getWorldCityID() then                
                self.attackCityList[id] = true
            end
        end
    else

        if reason == 1 then

            self.attackEffectList[id] = nil
        end        
    end

    local isShow = false
    for k,v in pairs(self.attackEffectList) do

        if v.state == 1 then
            
            isShow = true
            break
        end
    end

    global.userData:setIsBeAttackCity(false)
    for k,v in pairs(self.attackCityList) do
        global.userData:setIsBeAttackCity(true)
        break
    end

    if not isShow then
        global.panelMgr:closePanel("UIAttackEffect")
    else
        global.panelMgr:openPanel("UIAttackEffect")
    end
end

function _M:ignoreAttackEffect()
   
    for k,v in pairs(self.attackEffectList) do

        -- print("id >>> 2",k)
        self.attackEffectList[k] = {state = 2,troopState = v.troopState}
    end

    global.panelMgr:closePanel("UIAttackEffect")
end

function _M:GMRobotFight(startId,endId,targetId,attackType,callback)

    local pbmsg = msgpack.newmsg("GMRobotBehaviorReq")
    pbmsg.tagRobot = {

        [1] = {

            szStartRobot = startId,
            szEndRobot = endId,
            lAttackType = attackType,
            lTargetID = targetId,
        }        
    }

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callback(msg)
        end
    end
    
    gameReq.CallRpc("world", "GMRobotBehaviorReq", rsp_call, pbmsg)
end

function _M:dealAttackEffect(noModal)
    
    self:getCitySituation(0, function(data)        

        for _,v in ipairs(data) do
        
            self:dealAttackEffectCommon(v)
        end
    end, noModal)
end

--检测是否处于新手保护
function _M:checkMainCityNewProtect(callBack)
    
    local mainCityId = global.userData:getWorldCityID()
    self:getCityData(mainCityId,function(msg)

        if global.scMgr:isWorldScene() then

            local worldPanel = global.g_worldview.worldPanel
            worldPanel._mainCityProtectEndTime = msg.lCitys.lProtectArrived
            worldPanel._isMainCityProtect = msg.lCitys.lProtect ~= 0
        end

        if msg.lCitys.lProtect == 1 then

            callBack(true)
        else

            callBack(false)
        end
    end)  
end


function _M:checkMainCityProtect(callBack)
    
    local mainCityId = global.userData:getWorldCityID()
    self:getCityData(mainCityId,function(msg)

        if not msg.lCitys then 
            return 
        end 

        if global.scMgr:isWorldScene() then

            local worldPanel = global.g_worldview.worldPanel
            worldPanel._mainCityProtectEndTime = msg.lCitys.lProtectArrived
            worldPanel._isMainCityProtect = msg.lCitys.lProtect ~= 0
        end

        if msg.lCitys.lProtect ~= 0 then

            callBack(true,msg.lCitys.lProtect)
        else

            callBack(false,msg.lCitys.lProtect)
        end
    end)  
end

-- 刷boss
function _M:bossRefersh(lGateID, callBack)
   
    local pbmsg = msgpack.newmsg("GateBossFlushReq")
    pbmsg.lGateID = lGateID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            
          callBack(msg)
        end
    end
    
    gameReq.CallRpc("boss", "bossRefersh", rsp_call, pbmsg)

end

--拉取烧城记录
function _M:getFireRecode(lUserID, callBack)
    -- body
    local pbmsg = msgpack.newmsg("GetFiredLogReq")
    pbmsg.lUserID = lUserID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
          callBack(msg)
        end
    end
    
    gameReq.CallRpc("wall", "getFireRecode", rsp_call, pbmsg)
end

--拉取烧城记录
function _M:getFireRecode(lUserID, callBack)
    -- body
    local pbmsg = msgpack.newmsg("GetFiredLogReq")
    pbmsg.lUserID = lUserID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
          callBack(msg)
        end
    end
    
    gameReq.CallRpc("wall", "getFireRecode", rsp_call, pbmsg)
end

-- required int32      lType = 1;//1.邀请  2.邮件点击迁城
-- optional int32      lElementID = 2;//邀请目标点
-- optional int32      lInviter = 3;//被邀请的人
function _M:sendInviteMoveCity(callBack,lType,lElementID,lInviter)
    -- body
    local pbmsg = msgpack.newmsg("InviteMoveCityReq")
    pbmsg.lType = lType
    pbmsg.lElementID = lElementID
    pbmsg.lInviter = lInviter

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    
    gameReq.CallRpc("wall", "InviteMoveCity", rsp_call, pbmsg)
end

global.worldApi = _M

--endregion

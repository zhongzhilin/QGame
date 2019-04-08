local _M = {}

local datetime = require("datetime")

local define = global.define
local luaCfg = global.luaCfg
local gameEvent = global.gameEvent
local crypto  = require "hqgame"

--time 扩展文件同级目录:FunctionsForTime.lua

--定位到建筑根据建筑类型用建造模式
function _M.gpsCityBuilding(buildingType,isAnimate,gps0vercall,topLevel)
    if not tolua.isnull(global.g_cityView) then
        local buildingNode = global.g_cityView:getTouchMgr():getBuildingNodeByType(buildingType,topLevel)
        if not buildingNode then return end
        local buildingData = buildingNode:getData()
        global.g_cityView:getCamera():setBuildModel(cc.p(buildingData.posX,buildingData.posY),isAnimate,gps0vercall)
        return buildingNode
    else
        assert(_CPP_RELEASE==1,"定位场景不正确，请进去主城以后再调用定位程序！（是否是建筑全开的触发引导导致的？请提前关闭引导！）")
    end
end

--定位到建筑根据建筑id 用正常模式
function _M.gpsCityBuildingById(buildingId,isAnimate,gps0vercall)
    if not tolua.isnull(global.g_cityView) and buildingId then
        local touchMgr = global.g_cityView:getTouchMgr()
        local buildingNode = nil
        if touchMgr then 
            buildingNode = touchMgr:getBuildingNodeBy(buildingId)
        end
        if not buildingNode then return end
        local buildingData = buildingNode:getData()
        if isAnimate then
            isAnimate = WDEFINE.SCROLL_SLOW_DT
        end
        global.g_cityView:getCamera():resetNormalScale(cc.p(buildingData.posX,buildingData.posY),isAnimate)
        return buildingNode
    else
        assert(_CPP_RELEASE==1,"定位场景不正确，请进去主城以后再调用定位程序！（是否是建筑全开的触发引导导致的？请提前关闭引导！）")
    end
end

function _M.forceGpsCityBuilding(buildingType ,gps0vercall)
    if tolua.isnull(global.g_cityView) then return end
    local buildingNode = global.g_cityView:getTouchMgr():getBuildingNodeByType2(buildingType)
    if not buildingNode then return end
    print(buildingNode ,">>>>>>>>>>>$$")
    local buildingData = buildingNode:getData()
    global.g_cityView:getCamera():resetNormalScale(cc.p(buildingData.posX,buildingData.posY),WDEFINE.SCROLL_SLOW_DT,gps0vercall)
end 

function _M:checkLowMemToShowPromt(cancelFunc)
    if (cc.UserDefault:getInstance():getBoolForKey("isLowQuality", false) == false or 
        cc.UserDefault:getInstance():getBoolForKey("setting_performance_env_effect", true) == true) then

        local panel = global.panelMgr:openPanel("UIPromptPanel")                

        panel:setData("phone_picture",function()
            
            cc.UserDefault:getInstance():setBoolForKey("isLowQuality",true)
            cc.UserDefault:getInstance():setBoolForKey("setting_performance_env_effect",false)      
            cc.Director:getInstance():resume()              
            global.funcGame.RestartGame()
        end)

        panel:setModalEnable(false)
        panel:setPanelonExitCallFun(cancelFunc)
    else

        cancelFunc()
    end
end


-- 检测内存是否低于期望值
function _M:isOutofMem(mem)
    
    if global.tools:isAndroid() then
        local lMemory       = gluaj.callGooglePayStaticMethod("get_memory",{},"()Ljava/lang/String;")
        lMemory        = math.floor(tonumber(string.sub(lMemory,0,-3)))

        print("check l memtory after " .. lMemory)

        return lMemory < mem
    else

        local totalmem = CCNative:getTotalMemorySize()
        if totalmem and tonumber(totalmem) < 800 then
            return true
        end
        return false
    end    
end

function _M:isOutofMemMB(mem)
    
    if global.tools:isAndroid() then
        local lMemory       = gluaj.callGooglePayStaticMethod("get_memory",{},"()Ljava/lang/String;")
        lMemory        = tonumber(string.sub(lMemory,0,-3))
        return lMemory < mem
    else
        return false
    end    
end

function _M:getUseMemMB()
    
    if global.tools:isAndroid() then
        local lMemory       = gluaj.callGooglePayStaticMethod("get_memory",{},"()Ljava/lang/String;")
        lMemory        = tonumber(string.sub(lMemory,0,-3))
        return lMemory
    else
        local lMemory = CCNative:getAvailableMemorySize()
        lMemory = math.floor(lMemory)
        return lMemory
    end    
end


function _M.openCityPanelById(buildingId)

    local leisure = luaCfg:leisureList()
    local getPanelName = function ()
        for _,v in pairs(leisure) do
            if v.position == buildingId then
                return v.targetName
            end
        end
        return ""
    end

    local isOpen = (buildingId ==28 or buildingId ==25 or buildingId ==22 or buildingId ==17 or buildingId ==19 or buildingId ==33)
    if isOpen then           
        global.panelMgr:openPanel(getPanelName())
    elseif buildingId == 27 then
        global.panelMgr:openPanel("UIRegisterPanel"):setData(global.dailyTaskData:getTagSignInfo())
    elseif buildingId == 23 or buildingId == 13 then
        local panelStr = getPanelName()
        local buildingData = global.cityData:getBuildingById(buildingId)
        global.panelMgr:openPanel(panelStr):setData(buildingData)
    end
end

function _M:getCurrentFPS()
    
    return 1 / cc.Director:getInstance():getDeltaTime()
end

function _M:checkTarget(targetId)
    
    local data = luaCfg:get_target_condition_by(targetId)

    if data.objectType == 1 then

        local res = global.cityData:getTopLevelBuild(data.objectId)

        if res == nil then return false end
        return res.serverData.lGrade >= data.condition
    elseif data.objectType == 2 then

        return global.userData:getLevel() >= data.condition
    elseif data.objectType == 3 then

        return global.userData:getPower() >= data.condition
    elseif data.objectType == 4 then

        return not global.unionData:isMineUnion(0)
    elseif data.objectType == 9 then

        if data.condition == 1 then
            return global.scMgr:isWorldScene()
        elseif data.condition == 2 then
            return global.scMgr:isMainScene()
        end        
    elseif data.objectType == 10 then

        return global.panelMgr:getTopPanelName() == data.type
    elseif data.objectType == 11 then

        local curMainTask = global.taskData:getMainTask()        
        return curMainTask.id == data.objectId
    elseif data.objectType == 13 then

        if data.objectId == 0 then
            return global.userData:getWorldCityID() == 0
        else
            return global.userData:getWorldCityID() ~= 0
        end        
    elseif data.objectType == 12 then

        local soldierNum = global.troopData:getCitySoldierNum()
        return soldierNum > data.objectId
    elseif data.objectType == 14 then

        local heroDatas = global.heroData:getGotHeroData()

        for _,v in ipairs(heroDatas) do

            if v.lID == data.objectId then

                return true               
            end
        end

        return false 
    elseif data.objectType == 15 then

        local isCanHarTar = global.cityData:getHaveBuildTrainFinish(data.condition)
        return isCanHarTar
    elseif data.objectType == 16 then
        
        local mineTroopNum = global.troopData:getMineTroopNum()
        if mineTroopNum >= data.condition then
            return true
        else
            return false
        end
    elseif data.objectType == 18 then
        
        return global.panelMgr:isPanelOpened(data.type)
    elseif data.objectType == 19 then

        return global.guideMgr:getStepArg() ~= 0
    elseif data.objectType == 20 then

    elseif data.objectType == 21 then

    elseif data.objectType == 22 then

        return global.heroData:isAnyHeroInKnow()
    elseif data.objectType == 24 then

        return global.userData:isEventGuideDone(data.objectId)
    elseif data.objectType == 26 then
        
        local mineTroopNum = global.troopData:getMineTroopNumForGuide()
        return mineTroopNum >= 1 and global.userData:inNewProtect()
    elseif data.objectType == 27 then
        return global.normalItemData:getItemByItemType(data.condition)
    elseif data.objectType == 28 then
        return global.heroData:isHeroActive(data.condition)
    elseif data.objectType == 11 then

        local curTask = global.taskData:getNormalTasks()        
        for _,v in ipairs(curTask) do
            if v.id == data.objectId then
                return true
            end
        end        
        return false
    elseif data.objectType == 30 then
        
        local chooseHeroId = data.condition
        if chooseHeroId == 0 then
            if global.panelMgr:getPanel('UIHeroPanel').chooseHeroData then 
                chooseHeroId = global.panelMgr:getPanel('UIHeroPanel').chooseHeroData.heroId
            end 
        end        
        return not global.troopData:isHeroInAttack(chooseHeroId)
    elseif data.objectType == 31 then
        return global.panelMgr:getPanel('UIHeroPanel').isCanSuitFirst
    elseif data.objectType == 32 then
        return true-- global.userData:canFirstPay()
    elseif data.objectType == 35 then
        return global.normalItemData:getItemById(data.objectId).count >= data.condition
    elseif data.objectType == 36 then
        local chooseHeroId = data.condition
        if chooseHeroId == 0 then
            if global.panelMgr:getPanel('UIHeroPanel').chooseHeroData then 
                chooseHeroId = global.panelMgr:getPanel('UIHeroPanel').chooseHeroData.heroId
            end 
        end        

        return global.troopData:isHeroInCity(chooseHeroId)
    elseif data.objectType == 37 then

        return global.userData:getUserName() == (global.userData:getUserId() .. '')

    elseif data.objectType == 39 then
        
        local curFinishId = global.bossData:getCurUnlockBoss(1)
        return curFinishId > data.condition

    elseif data.objectType == 40 then
        local hero = global.heroData:getHeroDataById(data.objectId)
        if(hero and hero.serverData and hero.serverData.lStar == data.condition ) then 
            return true
        end 
        return false 
    elseif data.objectType == 41 then

        local mineTroopNum = global.troopData:getMineTroopNumForGuide2()
        return mineTroopNum >= 1 and global.userData:inNewProtect()

    elseif data.objectType == 42 then
        
        return global.troopData:isEmptyTroop()
    end

end

function _M:queryMaxCityOccupyCount()
    local curUnionLv = global.unionData:getInUnionCityLv()  
    for k,v in pairs(luaCfg:union_build_effect()) do
        if v.effecttype == 25 and v.LV == curUnionLv then
            return v.typelevel            
        end
    end

    return 0
end

function _M:getTopOffical(offType)
    local luaCfg = global.luaCfg
    local offData = luaCfg:official_post()
    for _,v in pairs(offData) do
        if offType == v.type then
            return v
        end
    end
    return nil
end

function _M:cleanMoveCD(callback)

    if global.propData:checkDiamondEnough(global.luaCfg:get_config_by(1).moveCityCost) then
        global.itemApi:diamondUse(function(msg)
            -- global.tipsMgr:showWarning('MovedToCity04')
            if callback then
                callback()
            end
        end,13)
    else
        global.tipsMgr:showWarning('MovedToCity05')
    end    
end

-- 全局高级迁城逻辑
function _M:highMoveCity(callback)

    local moveCityCall = callback 

    if global.cityData:getMainCityLevel() < 2 then

        global.tipsMgr:showWarning('NewGuide01')
        return true
    end

    local checkMoveCityCall = function()
        self:highMoveCity(callback)
    end
    if global.userData:checkCD(27,"MovedToCity02",checkMoveCityCall) then

        return true
    else

        global.worldApi:checkMainCityProtect(function(isProtect,protectType)
    
            local tmpCall = function()
                
                if isProtect then

                    if protectType == 1 then

                        local panel = global.panelMgr:openPanel("UIPromptPanel")        
                        panel:setData("MovedToCity01", function()
                                
                            global.worldApi:removeProtection(moveCityCall)
                        end)
                    else

                        local panel = global.panelMgr:openPanel("UIPromptPanel")        
                        panel:setData("MovedToCity03", function()
                                
                            global.worldApi:removeProtection(moveCityCall)
                        end,global.luaCfg:get_config_by(1).protectCD / 60)
                    end                        
                else

                    local panel = global.panelMgr:openPanel("UIPromptPanel")        
                    panel:setData("MovedToCity01", moveCityCall)
                end
            end

            if global.troopData:isEveryTroopIsInsideCity() then

                tmpCall()
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")        
                panel:setData("CityMoveTroopsNo", function()
                        
                    tmpCall()
                end)
            end
        end)
    end
end

-- 全局高级迁城逻辑(特殊处理版)
function _M:highMoveCitySpecial(callback)

    local moveCityCall = callback 

    if global.cityData:getMainCityLevel() < 2 then

        global.tipsMgr:showWarning('NewGuide01')
        return true
    end

    local checkMoveCityCall = function()
        self:highMoveCity(callback)
    end
    if global.userData:checkCD(27,"MovedToCity02",checkMoveCityCall) then

        return true
    else

        moveCityCall()
    end
end

-- 检测类型1官职是类型2官职的上级（1）还是本级（2）下级（3）还是无任何关系（4）
function _M:checkOfficalType(off1,off2)
    if off2 == -1 or off1 == -1 then
        return 4
    end

    if off2 == off1 then
        return 2
    end

    local luaCfg = global.luaCfg
    local off1Data = luaCfg:get_official_post_by(off1)
    local off2Data = luaCfg:get_official_post_by(off2)
    if off2Data.senior == off1Data.type then
        return 1
    end
    if off1Data.senior == off2Data.type then
        return 3
    end

    return 4
end

local alreadyContionMd5 = crypto.md5('contion', false)
local preContionMd5 = ''

-- 检测是否有英雄可以招募，callback为有招募英雄时的回调
function _M:checkAnyHeroCanBeContion(callback, isIgnore)
    local data = global.heroData:getAllCanContionHero()

    local targetIds = {}
    local normalHeroData = {}
    for i,v in ipairs(data or {}) do
        if not v.serverData then
            table.insert(targetIds,v.condition)
            table.insert(normalHeroData,v)
        end        
    end

    local canContionHeroId = 'contion'
    global.techApi:conditSucc(targetIds, function (msg)        
        if not msg.tgInfo then
            return
        end
        for i,v in ipairs(msg.tgInfo) do            
            if v.lCur >= v.lMax then
                canContionHeroId = canContionHeroId .. ',' .. normalHeroData[i].heroId
            end
        end      

        local md5 = crypto.md5(canContionHeroId, false)
        if isIgnore then
            if md5 ~= crypto.md5('contion', false) then
                callback(true)
            else
                callback(false)
            end
        else
            preContionMd5 = md5
            if alreadyContionMd5 ~= md5 and md5 ~= crypto.md5('contion', false) then
                callback(true)
            else
                callback(false)
            end
        end
    end)

end

-- 点击的时候，清楚这一次的时间
function _M:cleanContionTag()
    alreadyContionMd5 = preContionMd5
end

local isPlayedUnionAd = false

-- 检测是否需要弹出联盟广告
function _M:checkIsNeedOpenUnionAd(unionData)
    
    -- if global.guideMgr:isPlaying() then return end

    if not isPlayedUnionAd and global.unionData:isMineUnion(0) and unionData and #unionData > 0 then

        local data = unionData[1]
        local isCanjoin = true 
        isCanjoin = isCanjoin and  data.lCount  < data.lMaxCount
        isCanjoin = isCanjoin and  global.userData:getPower() >= data.lMinPower
        isCanjoin = isCanjoin and  global.cityData:getMainCityLevel() >= data.lMinBuild
        if isCanjoin then 
            global.panelMgr:openPanel('UIUnionAdPanel'):setData(unionData[1])
        end
        -- isPlayedUnionAd = true
    end
end

function _M:dealHeroRect(root,data)
    global.heroData:setHeroIconBg(data.heroId, root.left, root.right)
end

function _M:initEquipLight(lightWidget,strongLv)
    
    local timeLine = global.resMgr:createTimeline("effect/equip_ad_lv")    
    lightWidget:stopAllActions()
    lightWidget:runAction(timeLine) 
    lightWidget:setVisible(true)

    if strongLv < 8 then
        lightWidget:setVisible(false)
        timeLine:gotoFrameAndPause(0)
    elseif strongLv < 10 then     
        timeLine:play('animation0',true)
    elseif strongLv < 12 then     
        timeLine:play('animation1',true)
    elseif strongLv < 15 then     
        timeLine:play('animation2',true)
    else
        timeLine:play('animation3',true)
    end
end

--获取下一个城池上限会发生变化的等级
function _M:getNextCityMaxChange()
    local curLv = global.userData:getLevel()
    local city_max = global.luaCfg:city_max()
    local curMax = city_max[curLv].max
    for _,v in ipairs(city_max) do
        if v.max > curMax then
            return v.lv,v.max   
        end
    end
end

--获取一个item的好噶度
function _M:getItemImpress(itemId)
    
    local itemData = luaCfg:get_item_by(itemId)
    local value = luaCfg:get_item_impression_by(itemData.itemType).value
    if value == -1 then
        return itemData.typePara3
    else
        return value            
    end
end

--定位到升级界面
function _M.gpsCityBuildingAndPopUpgradePanel(buildingType,isAnimate,topLevel)
    if tolua.isnull(global.g_cityView) then return end
    local buildingNode = global.g_cityView:getTouchMgr():getBuildingNodeByType(buildingType,topLevel)
    if isAnimate then
        isAnimate = WDEFINE.SCROLL_SLOW_DT
        global.uiMgr:addSceneModel(WDEFINE.SCROLL_SLOW_DT)
    end
    global.funcGame.gpsCityBuilding(buildingType,isAnimate,function()
        if not buildingNode then return end
        global.g_cityView:getOperateMgr():openLvupPanel(buildingNode:getData())
    end,topLevel)

    gsound.stopEffect("ui_build_transition_far")
    gsound.stopEffect("city_click")
end

function _M.gpsBuildAndUpdate(buildingType,topLevel)    
    if tolua.isnull(global.g_cityView) then return end
    if not buildingType then return end
    if  global.g_cityView:getTouchMgr():getBuildingNodeByType(buildingType,topLevel) then 
        global.guideMgr:setStepArg(global.g_cityView:getTouchMgr():getBuildingNodeByType(buildingType,topLevel):getId())  
        gevent:call(gameEvent.EV_ON_LOOP_GUIDE_UPDATE)
    end 
end

function _M.gpsBuildAndTrain(buildingType)
    if tolua.isnull(global.g_cityView) then return end
    if not buildingType then return end
    local touchMgr = global.g_cityView:getTouchMgr()
    local buildingNode = nil
    if touchMgr then 
        buildingNode = touchMgr:getBuildingNodeByType(buildingType)
    end
    if not buildingNode then return end
    global.guideMgr:setStepArg(buildingNode:getId())
    gevent:call(gameEvent.EV_ON_LOOP_GUIDE_TRAIN)
end

function _M.gpsBuildAndAddSpeed(buildingType)
    if tolua.isnull(global.g_cityView) then return end
    global.guideMgr:setStepArg(global.g_cityView:getTouchMgr():getBuildingNodeByType(buildingType):getId())
    gevent:call(gameEvent.EV_ON_LOOP_GUIDE_ADD_RES_SPEED)
end

function _M:gpsBuildAndSelect(buildingId)
    -- body
    global.guideMgr:setStepArg(buildingId)
    gevent:call(gameEvent.EV_ON_LOOP_GUIDE_OPEN_BUILD)
end

function _M.gpsTrainPanelByBuildingType(buildingType)
    if tolua.isnull(global.g_cityView) then return end
    local build = global.g_cityView.touchMgr:getBuildingNodeByType(buildingType)
    if build then
        global.panelMgr:openPanel("TrainPanel"):setData(build.data)
    else

        global.tipsMgr:showWarning("trainNoBuild")
    end 
end

function _M:gotoBossPanel()
    local checkTrigger = function ()

        local trigger = luaCfg:get_buildings_pos_by(28)
        if global.cityData:checkTrigger(trigger.triggerId[1]) then
            return true
        else
            local triggerData = luaCfg:get_triggers_id_by(trigger.triggerId[1])
            local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
            local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition, trigger.buildsName)
            global.tipsMgr:showWarning(str)
            return false
        end
    end
    if not checkTrigger() then
        return
    end
    global.panelMgr:openPanel("UIBossPanel")
end

local quickTaskData = nil
function _M.handleQuickTask(gpsType,buildType,targetLevel)
    

    print(gpsType,buildType,targetLevel , "gpsType,buildType,targetLevel")

    local uiMgr = global.uiMgr

    -- -1意味着是一个修正方法，调用自prompt10
    if gpsType == -1 then
        if quickTaskData == nil then
            return
        else
            gpsType = quickTaskData.gpsType
            buildType = quickTaskData.buildType
            targetLevel = quickTaskData.targetLevel
        end
    end


    -- global.funcGame:gpsLeastObj(0)

    if global.scMgr:isWorldScene() then
        
        quickTaskData = {
            gpsType = gpsType,
            buildType = buildType,
            targetLevel = targetLevel,
        }

        -- gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)

        if gpsType == 1 then
               
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)
        elseif gpsType == 2 then
               
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)
        elseif gpsType == 3 then

            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)
        elseif gpsType == 4 then
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)
        elseif gpsType == 5 then            
          
            -- global.scMgr:gotoWorldSceneWithAnimation()       
        elseif gpsType == 6 then            
            _M:gotoBossPanel()
        elseif gpsType == 7 then            
          
            global.funcGame:gpsLeastObj(5)
        elseif gpsType == 8 then            
          
            global.funcGame:gpsLeastObj(5,buildType)
        elseif gpsType == 9 then            
          
            global.funcGame:gpsLeastObj(2)
        elseif gpsType == 10 then            
          
            global.funcGame:gpsLeastObj(2,buildType)
        elseif gpsType == 11 then            
          
            global.funcGame:gpsLeastObj(0)
        elseif gpsType == 12 then 

            if not global.chatData:isJoinUnion() then
                global.tipsMgr:showWarning("ChatUnionNo")
                return
            end
            global.chatData:setCurLType(3)
            global.chatData:setCurChatPage(3)
            global.panelMgr:openPanel("UIChatPanel")

        elseif gpsType == 13 then

            global.chatData:setCurLType(2)
            global.chatData:setCurChatPage(2)
            global.panelMgr:openPanel("UIChatPanel")
        elseif gpsType == 14 then      
            global.funcGame.openCityPanelById(buildType) 
        elseif gpsType == 15 then
            global.panelMgr:openPanel("UIResPanel"):setData()   
        elseif gpsType == 16 then
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE)
        end
    else
        if gpsType == 1 then
            global.funcGame.gpsBuildAndUpdate(buildType,targetLevel)
        elseif gpsType == 2 then
            uiMgr:addSceneModel(0.5)
            global.funcGame.gpsBuildListPanel(buildType,true)
        elseif gpsType == 3 then
            global.funcGame.gpsBuildAndTrain(buildType)
        elseif gpsType == 4 then
            global.funcGame.gpsCityBuildingById(buildType, true)   
        elseif gpsType == 5 and global.scMgr:isMainScene() then            
          
            global.scMgr:gotoWorldSceneWithAnimation()     
        elseif gpsType == 6 then            
            global.funcGame.openCityPanelById(buildType) 
        elseif gpsType == 7 and global.scMgr:isMainScene() then            
          
            global.funcGame:gpsLeastObj(5)
        elseif gpsType == 8 and global.scMgr:isMainScene() then            
          
            global.funcGame:gpsLeastObj(5,buildType)
        elseif gpsType == 9 and global.scMgr:isMainScene() then            
          
            global.funcGame:gpsLeastObj(2)
        elseif gpsType == 10 and global.scMgr:isMainScene() then            
          
            global.funcGame:gpsLeastObj(2,buildType)
        elseif gpsType == 11 and global.scMgr:isMainScene() then            
          
            global.funcGame:gpsLeastObj(0)
        elseif gpsType == 12 and global.scMgr:isMainScene() then 

            if not global.chatData:isJoinUnion() then
                global.tipsMgr:showWarning("ChatUnionNo")
                return
            end
            global.chatData:setCurLType(3)
            global.chatData:setCurChatPage(3)
            global.panelMgr:openPanel("UIChatPanel")

        elseif gpsType == 13 and global.scMgr:isMainScene() then

            global.chatData:setCurLType(2)
            global.chatData:setCurChatPage(2)
            global.panelMgr:openPanel("UIChatPanel")
        elseif gpsType == 14 and global.scMgr:isMainScene() then
            global.funcGame.openCityPanelById(buildType) 
        elseif gpsType == 15 and global.scMgr:isMainScene() then
            global.panelMgr:openPanel("UIResPanel"):setData()   
        elseif gpsType == 16 then
            global.funcGame.gpsBuildAndAddSpeed(buildType)
        end
    end    
end

function _M:checkBelong(data)
    
    if not data.lBelongsType or data.lBelongsType == 0 then return true end
    if data.lBelongsType == 1 or data.lBelongsType == 3 or data.lBelongsType == 6 then return global.userData:getUserId() == data.lBelongsID end
    if data.lBelongsType == 2 then return global.unionData:isMineUnion(data.lBelongsID) end
    return true
end

--定位到建造列表面板
function _M.gpsBuildListPanel(buildingType)
    if not global.guideMgr:isPlaying() then
        global.guideMgr.isInScript = true
        global.guideMgr.getHandler():autoGuide({panelName = "UICityPanel",tableViewName = "buildlistTableview",isSpecial = true,dataCatch = {id = buildingType}, 
            touchOverCall=function ()
                global.guideMgr.isInScript = false
        end})
    end
    if tolua.isnull(global.g_cityView) then return end
    global.g_cityView:showBuildListPanel()
end

--定位到建造面板
function _M.gpsBuildPanel(buildingType)
    if tolua.isnull(global.g_cityView) then return end
    local data = global.cityData:getBuildByType(buildingType)

    global.g_cityView:getOperateMgr():openBuildPanel(data,true)
end

function _M:gpsWorldCityWithOpen(cityId,cityType)
    if global.scMgr:isWorldScene() then
        global.funcGame:gpsWorldCity(cityId,cityType,true,function()

            local names = {[0] = "worldcity",[1] = "wildres",[2] = "monsterObj"}
            local widgetName = names[cityType] .. cityId
            global.guideMgr:setStepArg({widgetName = widgetName,cityId = cityId,cityType = cityType})
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH_OPEN_PANEL)
        end)
    else
        if global.cityData:getMainCityLevel() < 2 then
            global.tipsMgr:showWarning('NewGuide01')
            return true
        end

        local worldConst = require("game.UI.world.utils.WorldConst")
        local pos = worldConst:convertCityId2Pix(cityId,cityType > 0 and 1 or 0)
        global.funcGame:gpsWorldPos(cc.p(pos.x,pos.y),function()
                
            -- 如果还没有loaddone的话，做一下这个事情，有可能loaddone的callback会比这个还要快。。。
            if global.g_worldview.worldPanel.loadDoneCallBack then
                global.uiMgr:addSceneModel(nil,10001)
            else
                print(">>> yes this is a specical")
            end    
        end,function()
            
            local nameKey = {[0] = "worldcity",[1] = "wildres",[2] = "monsterObj"}
            global.uiMgr:removeSceneModal(10001)
            
            local widgetName = nameKey[cityType] .. cityId
            global.guideMgr:setStepArg({widgetName = widgetName,cityId = cityId,cityType = cityType})
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH_OPEN_PANEL)                
        end)
    end
end

function _M:gpsLeastObj(targetType,targetLevel)
   
    if global.scMgr:isWorldScene() then

        global.worldApi:queryLeastObj(targetType,function(msg)
                       
            local cityTypes = {[0] = 0,[2] = 1,[5] = 2}
            local cityType = cityTypes[targetType]
            global.funcGame:gpsWorldCity(msg.lMapID,cityType,true,function()

                local names = {[0] = "worldcityName",[1] = "wildres",[2] = "monsterObj"}
                local widgetName = names[cityType] .. msg.lMapID 
                global.guideMgr:setStepArg(widgetName)
                gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)
            end)
        end,function(msg)
            
        end,targetLevel,false) 
    else
        if global.cityData:getMainCityLevel() < 2 then

            global.tipsMgr:showWarning('NewGuide01')
            return true
        end

        global.worldApi:queryLeastObj(targetType,function(msg)
                       
            global.funcGame:gpsWorldPos(cc.p(msg.lPosx,msg.lPosy),function()
                
                -- 如果还没有loaddone的话，做一下这个事情，有可能loaddone的callback会比这个还要快。。。
                if global.g_worldview.worldPanel.loadDoneCallBack then
                    global.uiMgr:addSceneModel(nil,10001)
                else
                    print(">>> yes this is a specical")
                end    
            end,function()
                
                local nameKey = {
                    [0] = "worldcityName",
                    [2] = "wildres",
                    [5] = "monsterObj",
                }

                global.uiMgr:removeSceneModal(10001)
                
                global.guideMgr:setStepArg(nameKey[targetType] .. msg.lMapID)
                gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)                
            end)
        end,function(msg)
            
            global.scMgr:gotoWorldSceneWithAnimation()
        end,targetLevel)   
    end    
end

--魔晶消cd数量转换
function _M.getDiamondCount( restSecond )
    
    local  ret = 0
    local  last = 0

    local diamondTime = luaCfg:crystal_time()
    for i=1,#diamondTime do

        if diamondTime[i].min*60 > restSecond then
    
            ret = ret + ((restSecond-last*60) / (diamondTime[i].scale / 100))
            if ret <= 1 then ret = 1 end
            return math.floor(ret)
        else
            ret = ret + ((diamondTime[i].min - last)*60 / (diamondTime[i].scale / 100))
        end
        last = diamondTime[i].min 
    end
    if ret <= 1 then ret = 1 end
    return math.floor(ret)
end

function _M.formatString(value, params)
    if params == nil or #params == 0 then
        return value
    end

    return string.format(value, unpack(params))
end

local pauseTime = -1
local paused = false

function _M.OnPause()
    paused = true
    pauseTime = datetime.now().secs
end

function _M.OnResume()
    if not paused then
        return
    end
    local curTime = datetime.now().secs
    if pauseTime == -1 then
        pauseTime = curTime
    end
    local delta = curTime - pauseTime
    pauseTime = curTime
    paused = false
    log.debug("delta %s", delta)

    _M.ChecBuyGoodsEnd()

    if delta >= HQCONST.DELAY_TIME then
        _M.RestartGame()
    else
        global.netRpc:Close()
        gevent:call(global.gameEvent.EV_ON_RESUME_GAME)
    end
end


function _M.allExit()

    -- if global.panelMgr ~= nil then
    --     global.panelMgr:destroyAllPanel()            
    -- end

    -- if global.dataMgr then
    --     global.dataMgr:clear()
    -- end

    -- if global.netRpc then
    --     global.netRpc:exitClean()
    -- end

    -- gscheduler.unscheduleAll()
    -- local director = cc.Director:getInstance()
    -- director:getActionManager():removeAllActions()

    -- -- gsound.stopAllEffect()
    -- gaudio.reset()
    -- cc.Director:getInstance():endToLua()

    if global.tools:isAndroid() then
        gluaj.callUtilsStaticMethod("KillProessRunning",{"org.goose.knightscreed"},"(Ljava/lang/String;)V")
    end
    os.exit()
end

function _M.startApp()
    CCHgame:startApp()
end

function _M.RestartGame(noTrans)
    print("_M.RestartGame(noTrans) ----1")

    global.m_firstEnter = nil
    
    if global.g_worldview and global.g_worldview.worldCityMgr then

        global.g_worldview.worldCityMgr:cleanNoParentAreas()
    end    
    print("_M.RestartGame(noTrans) ----2")

    if global.dataMgr then
        global.dataMgr:clear()
    end
    print("_M.RestartGame(noTrans) ----3")
    gscheduler.unscheduleAll()
    print("_M.RestartGame(noTrans) ----4")
    if global.panelMgr ~= nil then
       global.panelMgr:destroyAllPanel()            
    end
    print("_M.RestartGame(noTrans) ----5")
    local director = cc.Director:getInstance()
    director:getActionManager():removeAllActions()
    local scene = gdisplay.newScene()
    scene:InitBg()
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
    scene:addChild(layer)
    -- local logoCfg = require("logo_cfg")
    -- for i,v in ipairs(logoCfg.logo) do
    --     local sprite = cc.Sprite:create(v.img)
    --     scene:addChild(sprite)
    --     local sceneSize = scene:getContentSize()
    --     sprite:setPosition(sceneSize.width / 2, sceneSize.height / 2)
    -- end

    director:replaceScene(scene)


    if global.netRpc then
        global.netRpc:exitClean()
    end
    gaudio.reset()

    CCHgame:RestartGame()

end

function _M.printReqMsg( ... )
    
end

function _M:translateDst(dst,dstType,targetid)

    if not dst then return "" end
    if tonumber(dst) == nil then return dst end

    local info = {
        [0] = {tb = "world_type",key = "name"},        
        [2] = {tb = "wild_res",key = "name"},
        [5] = {tb = "wild_monster",key = "name"},
        [6] = {tb = "world_type",key = "name"},
        [9] = {tb = "world_type",key = "name"},
        [10] = {tb = "world_type",key = "name"},
        [12] = {tb = "wild_res",key = "name"},
        [13] = {tb = "worldboss",key = "name"},
        [14] = {tb = "wild_res",key = "name"},
    }      

    if dstType then
        if dstType == 6 then
            targetid = targetid or tonumber(dst)
            local sname = luaCfg:get_all_miracle_name_by(targetid)
            if sname then
                return sname.name
            end
        end
    
        local i = info[dstType]
        if i then  

            local temp = luaCfg["get_" .. i.tb .. "_by"](luaCfg,tonumber(dst))
            if not temp then
                temp = luaCfg:get_all_miracle_name_by(tonumber(dst))
            end
            temp = temp or {}
            return temp[i.key] or "" -- luaCfg["get_" .. i.tb .. "_by"](luaCfg,tonumber(dst))[i.key] 
        else
            return dst
        end
    else

        return dst
    end
end

function _M:gpsWorldTroop(troopId,userId)
    
    print(">>>>>>>>.function _M:gpsWorldTroop(troopId)")

    if global.cityData:getMainCityLevel() < 2 then

        global.tipsMgr:showWarning('NewGuide01')
        return true
    end

    local call = function()
        
        global.g_worldview.worldPanel:chooseSoldier(troopId,userId)
    end
    
    if global.scMgr:isMainScene() then

        global.scMgr:gotoWorldSceneWithAnimation(function()
        
            -- print(">>>>>>>>>>>>>>>>>>global.scMgr:gotoWorldSceneWithAnimation(function()")
            local worldPanel = global.scMgr.curScene  
            worldPanel:setEnterCallBack(call)
        end)        
    else

        global.panelMgr:closePanelShowWorld()
        call()        
    end
end

function _M:gpsWorldPos(pos, finishCall,loaddoneCall)
    
    print(">>>>>>>>.function _M:gpsWorldTroop(troopId)")

    global.userData:setMainCityPos(pos)

    local call = function()

        if global.g_worldview.worldPanel.m_scrollView then  -- protect     
            global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(pos.x * -1,pos.y * -1))      
        end  

        if finishCall then
            finishCall()
        end
    end
    
    if global.scMgr:isMainScene() then

        global.scMgr:gotoWorldSceneWithAnimation(function()
        
            print(">>>>>>>>>>>>>>>>>>global.scMgr:gotoWorldSceneWithAawdwadnimation(function()")
            local worldPanel = global.scMgr.curScene  
            worldPanel:setEnterCallBack(call)
            worldPanel:setLoadDoneCallBack(loaddoneCall)
            worldPanel:setIsGPS()
        end)        
    else

        global.panelMgr:closePanelShowWorld()
        call()        
    end
end

function _M:gpsWorldCity(cityId,isWild,isNeedHideUI,callback)


    if global.cityData:getMainCityLevel() < 2 then

        global.tipsMgr:showWarning('NewGuide01')
        return true
    end

    local call = function()
        
        if callback then callback() end
        if global.g_worldview.worldPanel then 
            global.g_worldview.worldPanel:chooseCityById(cityId,isWild,isNeedHideUI)
        end
    end
    
    if global.scMgr:isMainScene() then

        global.worldApi:getCityPos(cityId,function(msg)
            
            global.userData:setMainCityPos(cc.p(msg.lPosx,msg.lPosy))

            global.scMgr:gotoWorldSceneWithAnimation(function()
        
                -- print(">>>>>>>>>>>>>>>>>>global.scMgr:gotoWorldSceneWithAnimation(function()")
                local worldPanel = global.scMgr.curScene  
                worldPanel:setEnterCallBack(call)
                worldPanel:setIsGPS()
            end)
        end)            
    else
        global.panelMgr:closePanelShowWorld()
        call()        
    end
end

-- 艺术字 isArtFont
function _M:initBigNumber(target , format , patch_call, isArtFont)


    if target.restText then  --防止多次重写出现问题
        target:restText()
        target.restText = nil 
    end 

    local setString = target.setString
    local getString = target.getString
    local formatType = format

    target.restText = function (text) 
        text.setString = setString          
        text.getString = getString          
    end 

    target.setString = function(text,label)     
        text._originalLabel = label
        text._showText  = global.funcGame:formatBigNumber(label , formatType, isArtFont)
        if patch_call then 
            patch_call(text , setString)
        else 
            setString(text, text._showText)
        end 
    end

    target.getString = function(text)
        return text._originalLabel or ""
    end

end


function _M:_formatBigNumber(num,formatType, isArtFont) --  

    local str = ""
    if formatType and formatType == 1 then 
        local format= function(num , t)  
            local t , t2=  math.modf(num / t )
            if t2 ==0 then t2= 0.01 end 
            t = tostring(t)
            t2 = tostring(t2)
            if isArtFont then
                return t.."<"..string.sub(t2,3 ,3)
            end
            return t.."."..string.sub(t2,3 ,3)
        end 
        num = tonumber(num)
        local floorV = tostring(num)
        local len = #floorV
        if num < 1000 then 
            str = num
        elseif num <= 999.9 * 1000 then --999999 --小于一百万 999999 
            str =  format(floorV , 1000).."K"
            if isArtFont then
                str =  format(floorV , 1000)..";"
            end
        elseif num <= 999.999999 * 1000000 then --小于 9990000000  小于 10 yi
            str =  format(floorV , 1000000).."M"
            if isArtFont then
                str =  format(floorV , 1000000).."="
            end
        elseif num >= 1000000000 then --大于 10 亿
            str =  format(floorV , 1000000000).."T"
            -- if isArtFont then
            --     str =  format(floorV , 1000000000)..">"
            -- end
        end 

    elseif formatType and formatType ==2 then 

        local format = function (modify) return self:_formatBigNumber(modify or num , 1) end 
        local str_  =  tostring(num)
        local type_  = 0 
        if string.find(str_ , "/") == 1  then
            local num = tonumber(string.sub(str,2, string.len(str)))
            str =  "/"..format(num)
        elseif string.find(str_ , "/") then 
            local  arr = global.tools:strSplit(str_ , "/")
            for _ ,v in pairs(arr) do 
                local num  = tonumber(v)
                str = str.."/"..format(num)
            end 
        else
            str = format()
        end 

    else  
        local floorV = tostring(num)
        local len = #floorV
        for i = 1,len do
            str = string.sub(floorV,len-i+1,len-i+1)..str
            if i%3 == 0 and i < len then
                if gap then
                    str = gap..str
                else
                    str = ","..str
                end
            end
        end
    end 
    return str
end

function _M:formatBigNumber(number , formatType, isArtFont)
    
    local preNumber = nil
    if type(number) == 'string' then        
        preNumber = number
        number = number:match("%d+")
        if number == nil then
            return preNumber
        else            
            local res = preNumber:gsub(number,self:_formatBigNumber(number , formatType, isArtFont))             
            return res
        end
    elseif type(number) == 'number' then
        return self:_formatBigNumber(number ,formatType, isArtFont)
    end 
end

function _M:showPathTimePanel(data)


    global.panelMgr:getPanel("UISeeking"):setDelayClose(function()        

        local cutTime = data.lRoadTime
        local luaCfg = global.luaCfg

        local hour = math.floor(cutTime / 3600) 
        cutTime = cutTime  % 3600
        local min = math.floor(cutTime / 60)
        cutTime = cutTime % 60
        local sec = math.floor(cutTime)

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("TroopsBtn", function()
            
            self:startAttack()
        end)

        local cityName = nil 
        if  global.troopData:getTargetData() then -- protect 
            cityName =  global.troopData:getTargetData().targetCityName --global.g_worldview.worldPanel.chooseCityName
        end 
        local troopName = "" 
        if cityName==nil then cityName = "-" end
        if troopName=="" then troopName = luaCfg:get_local_string(10140) end
        panel.text:setString(string.format(luaCfg:get_local_string(10020), troopName, global.troopData:getTargetStr(),cityName,hour,min,sec, global.troopData:getOrderStr()))
    
        gevent:call(global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN)
    end)
end

function _M:startAttack()    

    local targetData = global.troopData:getTargetData() or {}
    global.worldApi:attackCity(global.userData:getWorldCityID(),targetData.targetCityId,targetData.attackMode,targetData.outId,targetData.forceType,function(msg)
        
        global.panelMgr:closePanel("UITroopPanel")
        global.panelMgr:closePanelShowWorld()         
        
        if global.scMgr:isWorldScene() then


            if not global.guideMgr:isPlaying() then
                global.g_worldview.worldPanel:chooseSoldier(targetData.outId,global.userData:getUserId())
            else
               global.g_worldview.mapPanel:closeChoose() 
            end
            -- 
        end        
    end)
end

function _M.printRspMsg(title, result, args)
    require("common.const.wcode")
    local codeName = ""

    log.debug("[RspMsg]%s ==> %s", title, codeName)
    log.debug("[RspMsg]=====[args]=====\n==> %s", vardump(args))
end

--语音回调
--录音结束

function _M.onLoginListern()
    -- yvcc.YVTool:getInstance():setRecord(20, true);
end

function _M.onStopRecordListern(time, filepath)
    --yvcc.YVTool::getInstance()->speechVoice(r->strfilepath, "", true);
    gevent:call(global.gameEvent.EV_ON_CHAT_VOICE_STOP_RECORD, time, filepath)
end

--语音识别结束
function _M.onFinishSpeechListern(text, url)
    gevent:call(global.gameEvent.EV_ON_CHAT_VOICE_FINISH_SPEECH, text, url)
end

function _M.onFinishPlayListern()
    gevent:call(global.gameEvent.EV_ON_CHAT_VOICE_FINISH_PLAY)
end

function _M.onRecordVoiceListern(volume)
    
end

local preTime = 0
function _M:printContentTime(tag)
    
    local contentTime = global.dataMgr:getServerTime()
    log.debug("contentTime %s cutTime %s %s",global.dataMgr:getServerTime(),contentTime - preTime,tag)
    preTime = contentTime
end

-- 空闲从大地图切换到内城并打开界面
function _M:leiMainAndOpenPanel(data)

    if data.ltype == 1 then
        local buildData = global.cityData:getBuildingById(data.position) 
        global.panelMgr:openPanel(data.targetName):setData(buildData)
    elseif data.ltype == 2 then
        -- 史诗英雄
        if data.id == 4 then
            global.panelMgr:openPanel(data.targetName):setMode3()
        else
            global.panelMgr:openPanel(data.targetName):setData(data.parm)
        end
    elseif data.ltype == 3 then
        global.panelMgr:openPanel(data.targetName):setData()
    elseif data.ltype == -1 then

        -- 定位到占领野地
        if not global.scMgr:isWorldScene() then
            if not data.parm.lPosX then
                -- global.scMgr:gotoWorldSceneWithAnimation()
                global.funcGame:gpsRandWildRes(2)

            else
                self:gpsWorldPos(cc.p(data.parm.lPosX, data.parm.lPosY), function ()
                    global.g_worldview.worldPanel:chooseCityById(data.parm.lResID, 1)
                end)
            end             
        else
            if not data.parm.lPosX then
                -- self:returnMainCity()
                global.funcGame:gpsRandWildRes(2)
            else
                global.g_worldview.worldPanel:chooseCityById(data.parm.lResID, 1)
            end
        end
    else
        global.panelMgr:openPanel(data.targetName)
    end
end

--  定位到自己城池周围任意野地/野怪
function _M:gpsRandWildRes(targetType)
    
    -- body
    if global.cityData:getMainCityLevel() < 2 then
        global.tipsMgr:showWarning('NewGuide01')
        return true
    end

    global.worldApi:queryLeastObj(targetType,function(msg)
                   
        global.funcGame:gpsWorldCity(msg.lMapID, false, true,function()

            local names = {[0] = "worldcityName",[2] = "wildresName",[5] = "monsterObj"}
            local widgetName = names[targetType] .. msg.lMapID 
            global.guideMgr:setStepArg(widgetName)
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)
        end)

    end,function(msg)
        global.scMgr:gotoWorldSceneWithAnimation()
    end)  

end

-- 总览定位打开界面
function _M:pandectFunCall(data, infoData, panelName)
    -- body

    if not infoData then return end
    local lFrom = data.lFrom
    local lType = infoData.data_type

    local closePanelInfo = function ()
        global.panelMgr:closePanel("UIPandectInfoPanel")
        global.panelMgr:closePanel("UIPandectPanel")
    end
    
    if lFrom == 0 then
        if lType == 27 or lType == 3086 then
            closePanelInfo()
            self:gpsBuildAndSelect(tonumber(infoData.source0target))
        else
            global.panelMgr:openPanel(infoData.source0target):setData()
        end
    elseif lFrom == 1 then
        closePanelInfo()
        self:gpsBuildAndSelect(infoData.source1target)
    elseif lFrom == 2 then
        closePanelInfo()
        global.g_cityView:getOperateMgr():openHeroGarrison(global.cityData:getBuildingById(1))
    elseif lFrom == 7 then
        global.g_cityView:getOperateMgr():onCityPlus()
    elseif lFrom == 3 then 

        local scePanel = global.panelMgr:openPanel("UISciencePanel")
        gaudio.stopSound(scePanel:getSound())
        global.panelMgr:openPanel("UIScienceDPanel"):setData(infoData.source3target, false)
    elseif lFrom == 9 then

        closePanelInfo()
        gevent:call(global.gameEvent.EV_ON_CASTINFOGUIDE)
    elseif lFrom == 11 then
        closePanelInfo()
        local raceBuildingId = 16+1000*global.userData:getRace()
        self:gpsBuildAndSelect(raceBuildingId)
    elseif lFrom == 13 then
        
        closePanelInfo()
        if global.scMgr:isMainScene() then
            global.scMgr:gotoWorldSceneWithAnimation(function()
                local worldPanel = global.scMgr.curScene  
                worldPanel:setEnterCallBack(function ()
                    global.panelMgr:openPanel(panelName):setData()
                end)
            end)        
        else
            global.panelMgr:openPanel(panelName):setData()       
        end
    else
        global.panelMgr:openPanel(panelName)
    end

end

-- 如果在大地图, 定位到主城
function _M:returnMainCity()
    
    if global.panelMgr:isPanelExist("UIWorldPanel") then
        local panel = global.panelMgr:getPanel("UIWorldPanel")
        panel:cancelGpsSoldier()
        panel.m_scrollView:setOffset(panel.mainOffset)
        panel.m_scrollView:stopScrolling()
    end
end

-- 加载其他种族资源
function _M:preRoadAllRace(raceIds)

    -- local raceIds = {}
    -- local checkRaceId = function (id)
    --     for _,v in pairs(raceIds) do
    --         if v == id then
    --             return true
    --         end
    --     end
    --     return false
    -- end

    -- for _,v in pairs(data) do
    --     if v.tgWarrior then
    --         for _,v in pairs(v.tgWarrior) do
    --             local raceId = luaCfg:get_soldier_property_by(v.lID).race
    --             if not checkRaceId(raceId) then
    --                 table.insert(raceIds, raceId)
    --             end
    --         end
    --     end  
    -- end

    for _,id in ipairs(raceIds) do
        gdisplay.loadSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
    end

end

-- 移除其他种族资源
function _M:removeRoadRace(raceIds)
    if true then return end
    local raceId = global.userData:getRace()
    for _,id in pairs(raceIds) do
        if id ~= raceId and id ~= 0 then
            gdisplay.removeSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
        end
    end
end

-- 检测条件是否开启
function _M:checkBuildLv(buildId, conditLv)
    -- body
    if global.cityData:checkBuildLv(buildId, conditLv) then
        return true
    else
        local triggerBuilding = luaCfg:get_buildings_pos_by(buildId)
        local tipStr = luaCfg:get_local_string(10816)
        local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName, conditLv, tipStr)
        global.tipsMgr:showWarning(str)
        return false
    end
end


function _M:checkBuildAndBuildLV(i_buildingType) --检测建筑是否达到开放等级 and  是否建造

    local isbuding = nil 
    for _ ,v in pairs(global.cityData:getBuildings()) do 
       if v.buildingType == i_buildingType  and v.serverData.lStatus > WDEFINE.CITY.BUILD_STATE.BLANK then
             isbuding = true 
        end    
    end 
    if  isbuding  then
        local id = luaCfg:get_buildings_pos_by(i_buildingType).triggerId[1]
        if global.cityData:checkTrigger(id) then
             return true 
        else
                local triggerData = luaCfg:get_triggers_id_by(id)
                local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
                local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,luaCfg:get_buildings_pos_by(i_buildingType).buildsName)
                global.tipsMgr:showWarning(str)
        end
    else
         global.tipsMgr:showWarning(string.format(luaCfg:get_localization_by(10549).value, luaCfg:get_buildings_pos_by(i_buildingType).buildsName))
    end  

    return false 
end


local timeTag = {}
function _M:startRecordTime(key)
    local i_key = key or os.time()
    timeTag[key] = os.time()
end

function _M:endRecordTime(key)
    local tm =  os.time() - timeTag[key] - global.ClientStatusData:getBgDuration()
    timeTag[key]=

    print("fffffff--->"..tm)
    return tm
end


function _M:checkCondition(id) --

    local target = global.luaCfg:get_target_condition_by(id)
    if not target then return end 

    if target.object =="building" then 

        if target.type == "level" then 

            return global.cityData:checkBuildLv1(target.objectId, target.condition)
        end 

    elseif target.object =="time" then
         --todo 
        if target.type == "time" then 

            if global.dailyTaskData:getTimestamp().lBornTime then 
                return global.dataMgr:getServerTime() > (global.dailyTaskData:getTimestamp().lBornTime  + target.condition)
            end 
        end 
    end 

end 

function _M:getSoldierLvup(level , id ,key)

    -- print(level ,id , key ,"-----------")

    local property =global.luaCfg:get_soldier_property_by(id)

    if not level then 

        return property[key]
    end 
    local isfull,curclass,nextClass = global.soldierData:getSoldierClassBy(level)
        
    local  lvupData =global.luaCfg:get_soldier_lvup_by(curclass  + 1 )


    if lvupData then 

        return math.ceil(property[key]*(lvupData.upPro+100)/100)
    else 

        return property[key]
    end 
end 

local isCancelFps = false
local isCancelWorldFps = false
function _M:setLowFpsPhone(cancelFunc,isRestart)
    if self:isNeedCheckLowFps() then
        local canCheck = true
        if global.scMgr:isMainScene() and isCancelFps then
            return cancelFunc()
        end

        if global.scMgr:isWorldScene() and isCancelWorldFps then
            return cancelFunc()
        end

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setLocalZOrder(200)          

        panel:setData("phone_performance",function()
            
            cc.UserDefault:getInstance():setIntegerForKey("islowFpsPhone1",-1)
            if isRestart then
                global.funcGame:RestartGame()
            end
        end)
        panel:setCancelCall(function()
            -- body
            if global.scMgr:isMainScene() then
                isCancelFps = true
            elseif global.scMgr:isWorldScene() then
                isCancelWorldFps = true
            end
        end)

        panel:setModalEnable(false)
        panel:setPanelonExitCallFun(cancelFunc)
    else

        cancelFunc()
    end
end
local islowFpsPhone = (cc.UserDefault:getInstance():getIntegerForKey("islowFpsPhone1", 0))
-- -1:低性能 0,1：高性能，0:带表默认高性能，需要检测自动切换
function _M:isLowFpsPhone()
    return islowFpsPhone < 0
end

function _M:isNeedCheckLowFps()
    return islowFpsPhone == 0
end
global.funcGame = _M
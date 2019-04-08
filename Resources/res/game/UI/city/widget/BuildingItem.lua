--region BuildingItem.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local stateEvent = global.stateEvent
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local BuildingLvWidget = require("game.UI.city.widget.BuildingLvWidget")
local BuildingName = require("game.UI.city.widget.BuildingName")
--REQUIRE_CLASS_END

local BuildingItem  = class("BuildingItem", function() return gdisplay.newWidget() end )
local Train = require("game.UI.city.buildings.widget.Train")
local Persuade = require("game.UI.city.buildings.widget.Persuade")
local UIOverTimeNode = require("game.UI.activity.Node.UIOverTimeNode")


function BuildingItem:ctor()
    self:CreateUI()
end

function BuildingItem:CreateUI()
    local root = resMgr:createWidget("city/building")
    self:initUI(root)
end

function BuildingItem:initUI(root)
    self.root = root
    -- self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.building = self.root.building_export
    self.effect_node = self.root.effect_node_export
    self.building_select = self.root.building_select_export
    self.info_node = BuildingLvWidget.new()
    uiMgr:configNestClass(self.info_node, self.root.info_node)
    self.name_node = BuildingName.new()
    uiMgr:configNestClass(self.name_node, self.root.name_node)

--EXPORT_NODE_END

    self.fsm = global.stateMachine.new()
    self.m_clickCall = nil

    self.root:retain()
    self.m_isAdded = false
    self.name = self.name_node.name

    self.name_node:setLocalZOrder(100)
end

function BuildingItem:initStateMachine(initial_state)
    self.fsm:setupState({
        initial = initial_state,
        events = {
            {name = stateEvent.BUILDING.EVENT.BLANK, from = "none", to = stateEvent.BUILDING.STATE.BLANK},
            {name = stateEvent.BUILDING.EVENT.UNOPEN, from = "none", to = stateEvent.BUILDING.STATE.UNOPEN},
            {name = stateEvent.BUILDING.EVENT.OPERATE, from = {stateEvent.BUILDING.STATE.BLANK,stateEvent.BUILDING.STATE.UNOPEN}, to = stateEvent.BUILDING.STATE.OPERATE},
        },
        callbacks = {
            ["onenter"..stateEvent.BUILDING.STATE.BLANK] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."弹出建造面板 暂时不做")
                end
            end,
            ["onenter"..stateEvent.BUILDING.STATE.UNOPEN] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."弹出警告框")
                    if global.cityData:checkTrigger(self.data.triggerId[1]) then
                        if self.data.serverData and self.data.serverData.lStatus == 2 then
                        else
                            self.data.serverData = {}
                            self.data.serverData.lBuildID = self.data.id
                            self.data.serverData.lGID = self.data.buildingType
                            self.data.serverData.lGrade = self.data.level
                            self.data.serverData.lStatus = 2
                            self.data.serverData.lPosX = self.data.posX
                            self.data.serverData.lPosY = self.data.posY
                            gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)
                            if self.m_clickCall then self.m_clickCall() end
                        end
                    else
                        if self.data.id == 31 then
                            local data = luaCfg:get_target_condition_by(300)
                            local curFinishId = global.bossData:getCurUnlockBoss(1)
                            if curFinishId <= data.condition then
                                return global.tipsMgr:showWarning("unlockPetBuild")
                            end
                        end
                        local triggerData = luaCfg:get_triggers_id_by(self.data.triggerId[1])
                        local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
                        local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,self.data.buildsName)
                        global.tipsMgr:showWarning(str)
                    end
                end
            end,
            ["onenter"..stateEvent.BUILDING.STATE.OPERATE] = function(event)
                self.m_clickCall = function() 
                    print(event.name.."弹出功能按钮")
                    self:showOperatePanel()
                    self:checkbtString()
                    -- 针对资源建筑的加速按钮上显示数字处理   
                    if self.checkHarvestBtnUpdate then self:checkHarvestBtnUpdate() end
                    if self.updateAccelerateTime then self:updateAccelerateTime() end

                    self:openBuild()
                end
            end,
        }
    })
end

------------------------------ 点击建筑 -------------------------
function BuildingItem:openBuild()


    if self.data.id == 26 then

        self:setSelected(false)
        self:openNewTroop()

    elseif self.data.id == 28 then

        self:setSelected(false)
        if not self:checkTrigger() then
            return
        end
        global.panelMgr:openPanel("UIBossPanel")
        
    elseif self.data.id == 29 then

        self:setSelected(false)
        if not self:checkTrigger() then
            return
        end
        global.panelMgr:openPanel("UIRankPanel")

    elseif self.data.id == 30 then

        -- if not self.clickFaq and (not global.tools:isIos()) then 
        --     return 
        -- end
        -- self.clickFaq = false
        self:setSelected(false)
        global.sdkBridge:hs_showFAQs()

    elseif self.data.id == 31 then

        self:setSelected(false)
        local data = luaCfg:get_target_condition_by(300)
        local curFinishId = global.bossData:getCurUnlockBoss(1)
        if curFinishId <= data.condition then
            return global.tipsMgr:showWarning("unlockPetBuild")
        end

        local curFightPet = global.petData:getGodAnimalByFighting()
        if curFightPet then
            global.panelMgr:openPanel("UIPetInfoPanel"):setData(curFightPet)
        else 
            global.panelMgr:openPanel("UIPetPanel")
        end

    elseif self.data.id == 24 then 

        self:setSelected(false)
        global.panelMgr:openPanel("UIActivityPanel"):setData(2)          

    elseif self.data.id == 33 then 

        self:setSelected(false)
        global.panelMgr:openPanel("UIPKPanel")       

    elseif self.data.id == 32 then

        self:setSelected(false)
        global.panelMgr:openPanel("UIHeroExpPanel")
          
    end


end

function BuildingItem:checkTrigger()

    if global.cityData:checkTrigger(self.data.triggerId[1]) then
        return true
    else
        local triggerData = luaCfg:get_triggers_id_by(self.data.triggerId[1])
        local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
        local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,self.data.buildsName)
        global.tipsMgr:showWarning(str)
        return false
    end

end

  -- 点击旗帜打开新建部队
function BuildingItem:openNewTroop()

    if global.cityData:getMainCityLevel() < 2 then
        global.tipsMgr:showWarning('seek01',2)
        return
    end

    global.troopData:setTargetData(-1,0,global.userData:getWorldCityID(),0)
    global.troopData:setPageMode(1)
    global.panelMgr:openPanel("UITroopPanel")
    self:setSelected(false)
end

------------------------------ 点击建筑 -------------------------
function BuildingItem:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FINISH, function()
        if self.data.buildingType == 17 and self.playAnimation then
            self:playAnimation()
        end
    end)

    self.clickFaq = true
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        self.clickFaq = true
    end)
    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        self.clickFaq = true
    end)

    self:addEventListener(global.gameEvent.EV_ON_CITYSCROLLSCALECHANGE, function ()
        self:setIsUpdateCity(true)
    end)


    global.netRpc:addHeartCall(function () 
        self:checkbtString()
    end , "checkbtString"..self.data.id)

    self:schedule(function () 
        if self.m_isUpdateCity then
             self:checkName()
            self:setIsUpdateCity(false)
        end
    end , 0.1)

    self:setIsUpdateCity(true)
end

function BuildingItem:checkbtString() --魔晶直接 加速--

    if self:isSelected() then 

        if  self.data.buildingType == 17   then  -- 科技 

            local curQueue = global.techData:getQueue()
            
            if curQueue and curQueue[1] then 

                local time = curQueue[1].rest
                if time then 
                    self:setBtnString(42 , nil ,global.funcGame.getDiamondCount(time))
                end 
            end 

        end  

    end

    self:adjustTipsPs()
end


function BuildingItem:adjustTipsPs()

    --- 检测按钮位置
    if self.data.buildingType == 27 then --祭坛


        local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        local normal_posY = data.normal_posY or 0 

        if self.monthCardTips and self.m_dailyNode then 

            if self.monthCardTips:isVisible() and self.m_dailyNode:isVisible() then 

                self.monthCardTips:setPosition(cc.p(55, 155))
                self.m_dailyNode:setPosition(cc.p(-41, 155))

            elseif self.monthCardTips:isVisible() then 

                self.monthCardTips:setPosition(cc.p(10, 155))

            elseif self.m_dailyNode:isVisible() then 

                self.m_dailyNode:setPosition(cc.p(data.idleui_posX,data.idleui_posY))
            end 

        elseif self.monthCardTips then 

            self.monthCardTips:setPosition(cc.p(10, 155))

        elseif self.m_dailyNode then 
            
            self.m_dailyNode:setPosition(cc.p(data.idleui_posX,data.idleui_posY))
        end 


        if self.monthCardTips then 
            local posY = self.monthCardTips:getPositionY()
            self.monthCardTips:setPositionY(posY+normal_posY)
        end

        if self.m_dailyNode then 
            local posY = self.m_dailyNode:getPositionY()
            self.m_dailyNode:setPositionY(posY+normal_posY)
        end

    end 
end 


function BuildingItem:setBtnString(id , s1 ,s2)

    local m_operateNode = global.g_cityView:getOperateMgr()
    if not m_operateNode or tolua.isnull(m_operateNode) then return end
    local txt_node = m_operateNode:getBtnTxtNodeById(42)
    if txt_node then 
        local btn = txt_node:getParent()
        txt_node:setVisible(true)
        local label = txt_node.time
        local title = txt_node.txt
        title:setVisible(s1 ~=nil )
        label:setVisible(s2 ~=nil )
        title:setString(s1 or "")
        label:setString(s2 or "")
    end
end 



function BuildingItem:onExit()

    --print("$$$$$$$$$$$$$BuildingItem:onExit()")
    print("BuildingItem:onExit")

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.m_countDownTimerForIdelCheck then
        gscheduler.unscheduleGlobal(self.m_countDownTimerForIdelCheck)
        self.m_countDownTimerForIdelCheck = nil
    end

    if self.m_countDownTimerForUStudy then
        gscheduler.unscheduleGlobal(self.m_countDownTimerForUStudy)
        self.m_countDownTimerForUStudy = nil
    end

    if self.m_countDownTimerForBusyCheck then
        gscheduler.unscheduleGlobal(self.m_countDownTimerForBusyCheck)
        self.m_countDownTimerForBusyCheck = nil
    end

    if self.m_countDownTimerForPersuade then

        print("remove self.m_countDownTimerForPersuade")
        gscheduler.unscheduleGlobal(self.m_countDownTimerForPersuade)
        self.m_countDownTimerForPersuade = nil
    end    

    self:exitBusy()
    
    global.netRpc:delHeartCall("checkbtString"..self.data.id)
    global.netRpc:delHeartCall("isMemberHaveHelpCall")
    
end


function BuildingItem:sleep()    

    if self.m_sleepNodeOut then
        self.m_sleepNodeOut:setVisible(true)
        return
    end
    local csbName = "city/build_train_free"
    local node = resMgr:createCsbAction(csbName,"sleep",true)

    if not tolua.isnull(node) then --protect 
        self.root:addChild(node)
        -- 炼金池免费
        node.Sprite_1.Text_1:setString(self:getSleepText())
        local filename = self:getFrreSprite()
        if filename then 
            node.Sprite_1:setSpriteFrame(filename)
        end
        self:setFreeColor(node)
        local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        if data then

            node:setPosition(cc.p(data.idleui_posX,data.idleui_posY))
            self:adjustFreePs(node)
            self.m_sleepNodeOut = node
        end
    end 
end

function BuildingItem:setFreeColor(node)
    if   self.data.buildingType == 29 then
        node.Sprite_1.Text_1:setTextColor(cc.c3b(180,29,11))
    elseif self.data.buildingType == 24   then 
         node.Sprite_1.Text_1:setTextColor(cc.c3b(255,255,255))
    end 
end



function BuildingItem:getFrreSprite()
    local filename =  nil  
    if self.data.buildingType == 24  then

        filename = "activity_tips_bg.png"

    elseif self.data.buildingType == 29  then
        filename = "ui_surface_icon/rank_city_bg.png"

    elseif self.data.buildingType == 30  then

        filename = "ui_surface_icon/city_faq_tips.png"

    elseif self.data.buildingType == 26  then

        filename = "ui_surface_icon/square_tips1.png"

    elseif self.data.buildingType == 13  then

        filename = "ui_surface_icon/hosiptal_state_icon.png"

    end 
    return filename  
end

function BuildingItem:adjustFreePs(node)
    node:setScale(1)
    if self.data.buildingType == 24  then

        node:setPositionX(node:getPositionX()-7)
        global.tools:adjustNodeMiddle(node.Sprite_1.Text_1)
        node.Sprite_1.Text_1:setPositionY(node.Sprite_1.Text_1:getPositionY()-8)

    elseif self.data.buildingType == 29 then
        
        node:setPositionY(node:getPositionY()-40)
        global.tools:adjustNodeMiddle(node.Sprite_1.Text_1)

    elseif self.data.buildingType == 30 or self.data.buildingType == 26 then

        node:setScale(0.8)
        node:setPosition(cc.p(node:getPositionX() - 4, node:getPositionY() - 20))
        global.tools:adjustNodeMiddle(node.Sprite_1.Text_1)
        local offsetY = node.Sprite_1.Text_1:getPositionY()
        node.Sprite_1.Text_1:setPositionY(offsetY-3)

        if self.data.buildingType == 26 then
            node:setPosition(cc.p(node:getPositionX()+5, node:getPositionY()+30))
            node.Sprite_1.Text_1:setPositionY(offsetY)
        end

    elseif self.data.buildingType == 13 then

        node:setPosition(cc.p(node:getPositionX()-10, node:getPositionY()-80))

    end 
end 

-- 自定义空闲
function BuildingItem:getSleepText()
    
    local str = ""
    local localId = 0
    if self.data.buildingType == 23 or self.data.buildingType == 19 then
        localId = 10390
    elseif self.data.buildingType == 24 then -- 活动 

        local hava_activitying = global.ActivityData:getActivityStatus()

        if hava_activitying then 

            localId = 10714
        else 

            localId = 10662
        end 

    elseif self.data.buildingType == 29 then 
        localId = 10672
    elseif self.data.buildingType == 30  then
        localId = 10841
    elseif self.data.buildingType == 26  then
        localId = 10975
    else
        localId = 10391
    end

    if self.data.buildingType == 13  then
        str = ""
    else 
        str = global.luaCfg:get_local_string(localId)
    end

    return str
end

function BuildingItem:createHeroHead()
    
    local buildType = global.cityData:getBuildingType(self.data.buildingType)
    if    buildType == 25 then 
    
        if self.headItem == nil then
            self.headItem = require("game.UI.hero.UIHeroGarrisonWidget.UIGarrisonHead").new()    
            self.headItem:checkState(self.data.buildingType)
            self.headItem:setBuildType(self.data.buildingType)
            if buildType == 25 then 
                self.headItem:setPositionY(self.headItem:getPositionY() - 35)
            end
            self.root:addChild(self.headItem)
        end        
    end
end

function BuildingItem:setIsUpdateCity(y)
    self.m_isUpdateCity = y
end

function BuildingItem:checkName(isforce)

    if self:isSelected() and not isforce then return end 

    local isShow = self:canShowName()

    if self.name_node then 
        if isShow then 
            if not self.name_node.isshow  then 
                self.name_node:showName()
            end 
        else
            if  self.name_node.isshow then 
                self.name_node:hideName()
            end 
        end 
    else
        -- print(self.data.buildingType , "selfata.buildingType")
    end 
end 

function BuildingItem:canShowName()


    local isShow = not table.hasval({3,9,10,11}, self.data.buildingType)  
    isShow = isShow and  global.g_cityView.m_scrollView:getZoomScale() >= (global.g_cityView:getDefaultScale()+0.1)  

    local name = global.panelMgr:getTopPanelName()
    if  name == "UpgradePanel" or name == "BuildPanel" then 
        isShow = isShow and global.panelMgr:getTopPanel().data and self.data and  global.panelMgr:getTopPanel().data.id  ~= self.data.id 
    end 

    return isShow
end 

function BuildingItem:setData(data,noChangeTex)
    self.data = data
    -- if tolua.isnull(self.building) then return end
    --print("--#_###BuildingItem:setData(data,noChangeTex)")
    self.building:setName("citybuilditem" .. self.data.id)

    self:setPosition(cc.p(data.posX,data.posY))
    if not noChangeTex then
        self:setVisible(false)
        global.panelMgr:setTextureForAsync(self.building,data.name,true)
        global.panelMgr:setTextureForAsync(self.building_select,data.name,false,function()
            -- body
            if not tolua.isnull(self.building) then
                self.m_rect = self.building:getBoundingBox()
            end
            if not tolua.isnull(self) then
                self:setVisible(true)
            end
        end)
    end

    self.name:setString(data.buildsName)
    self.name_node:setPositionX(0 + (data.namePosX or 0))
    self.name_node:setPositionY(0 + (data.namePosY or 0))
    -- self:checkName()
    self:setIsUpdateCity(true)



    if data.level <= 0 then
        if self.info_node then
            self.info_node:removeFromParent()
            self.info_node = nil
        end 
    else
        self.info_node:setData(data)
    end

    --用来控制当前建筑弹出操作界面的界面状态
    self.m_btnState = 1

    self:initStateMachine(tostring(self.data.serverData.lStatus))

    --增加建筑表现特效
    local uiConf = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(data.buildingType))
    if uiConf and cc.UserDefault:getInstance():getBoolForKey("setting_close_building_effect",true) then
        if uiConf.effect ~= "" and not self.showEffect then
            if self.data.buildingType == 14 then
                --城墙巨人特殊处理
                if not self.m_wallEffect then
                    local showEffect = resMgr:createCsbAction(uiConf.effect,"animation0",true)
                    self:addChild(showEffect)
                    self.m_wallEffect = showEffect
                end
            else
                if not (cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone", false)) or self.data.buildingType == 26 or self.data.buildingType == 23 then
                    self.showEffect = resMgr:createCsbAction(uiConf.effect,"animation0",true)
                    self.effect_node:addChild(self.showEffect)
                end
            end
        end

        if uiConf.addEffect ~= "" and not self.addEffect then
            self.building:setVisible(false)
            self.addEffect = resMgr:createCsbAction(uiConf.addEffect,"animation0",true)
            self.effect_node:addChild(self.addEffect)
            if self.data.buildingType == 17 then
                self.addEffect:setScale(58.82/60)
            end
        end
    end

    self:setBuildState(data)

    -- 空闲
    self:checkIdle()
    -- 倒计时
    self:checkBusyIdle()
    
    self:createHeroHead()

    if self.data.buildingType == 22 then
        --大使馆-->联盟建筑正在研究
        self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_BUILD_DOING, function(event)
            if self.addUnionStudyCom then
                self:addUnionStudyCom()
            end
        end)
        self:addUnionStudyCom()
        -- 新好友消息
        self:addEventListener(global.gameEvent.EV_ON_FRIEND_UPDATE, function()
            if self.addFriendNew then
                self:addFriendNew()
            end
        end)
        -- 新个人外交
        self:addEventListener(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE, function()
            if self.addFriendNew then
                self:addFriendNew()
            end
        end)
        -- 军功每日福利
        self:addEventListener(global.gameEvent.EV_ON_EXPLOIT_GETREWARD, function()
            if self.addFriendNew then
                self:addFriendNew()
            end
        end)
        self:addFriendNew()

        global.netRpc:addHeartCall(function ()

            self:addUnionBuildHelp()

        end ,"isMemberHaveHelpCall" )

        self:addUnionBuildHelp()

    elseif self.data.buildingType == 27 then

        self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE, function()
            if self.addMonthCardFree then
                self:addMonthCardFree()
            end
        end)
        self:addMonthCardFree()

        self:adjustTipsPs()

    elseif self.data.buildingType == 15 then

        self:addHeroPersuadeCom()
        self:addEventListener(global.gameEvent.EV_ON_HERO_FREE, function()
            if self.addHeroFree then
                self:addHeroFree()
            end
        end)
        self:addHeroFree()
     end 
    return true
end


function BuildingItem:addMonthCardFree()

    local canGet =  global.rechargeData:isMonthGet()

    local setState = function (state) 

        if self.monthCardTips and not state then
            self.monthCardTips:removeFromParent()
            self.monthCardTips = nil
        elseif  state and not self.monthCardTips then 
            local node = require("game.UI.city.widget.UIFloatBtnWidget").new()
            node:setPosition(cc.p(0, 135))
            self.root:addChild(node)
            node:setData(nil, nil, nil , true)
            self.monthCardTips = node
            self.monthCardTips:setData(1,function()
                global.panelMgr:openPanel("UIMonthCardPanel"):setData()
            end)
            self.monthCardTips:setIcon("ui_surface_icon/libao_icon_01.png")
        end 

    end 
    setState(canGet)

end

function BuildingItem:addHeroFree()
    -- body
    global.funcGame:checkAnyHeroCanBeContion(function(isShow)

        if tolua.isnull(global.g_cityView) then return end
        if global.scMgr:isMainScene()  then 
            if self.m_HeroSleep then
                self.m_HeroSleep:removeFromParent()
                self.m_HeroSleep = nil
            end
            if isShow and not tolua.isnull(self.root) then
                local node = require("game.UI.friend.UIFriendNew").new() 
                node:setPosition(cc.p(55, 120))
                self.root:addChild(node)
                node:setData(nil, nil, true)
                self.m_HeroSleep = node
            end
        end
    end)

end

function BuildingItem:addHeroPersuadeCom()

    if not self.m_trainWidget then
        self.m_trainWidget = Persuade.new()
        self.m_trainWidget:setPositionX(-38)
        local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        if buildingUIData and buildingUIData.btnui_posY ~= 0 then
            self.m_trainWidget:setPositionY(140+buildingUIData.btnui_posY)
        else
            self.m_trainWidget:setPositionY(140)
        end

        self.root:addChild(self.m_trainWidget)        
    end
    
    self.m_trainWidget:setVisible(false)

    local countHandler = function()
        
        local persuadeData = global.heroData:getPersuadeData()
        
        if persuadeData then
            
            local curTime = global.dataMgr:getServerTime()
            local lastTime = persuadeData.lStartTime + persuadeData.lTotleTime - curTime

            if lastTime > 0 then

                local pen = lastTime / persuadeData.lTotleTime * 100
                local str = global.funcGame.formatTimeToHMS(lastTime)                
                self.m_trainWidget:updateInfo({percent = (100 - pen),time = str} , persuadeData)   
                self.m_trainWidget:setVisible(true)
            else
                self.m_trainWidget:setVisible(false)
                global.heroData:setPersuadeTime(0)
            end
        else

            self.m_trainWidget:setVisible(false)
        end
    end

    if self.m_countDownTimerForPersuade then

        gscheduler.unscheduleGlobal(self.m_countDownTimerForPersuade)
        self.m_countDownTimerForPersuade = nil
    end

    self.m_countDownTimerForPersuade = gscheduler.scheduleGlobal(function()
        countHandler()
    end, 1)

    countHandler()
end

--增加空闲--------------------------------------------------->>>>

-- 内城没有boss
function BuildingItem:BossFree()
    
    local curFightId = 0
    local fightBoss = global.bossData:getFightBoss()
    if fightBoss then curFightId = fightBoss.id end
    return curFightId == 0 
end

-- 占卜空闲
function BuildingItem:DivineFree()
    
    local lState = global.refershData:getDivState()
    return lState < 10000
end

-- 英雄空闲
function BuildingItem:HeroFree()

    return false --  global.heroData:isHeroFree()
end
-- 工资免费可领
function BuildingItem:GetFree()
    local freeTimes,_ = global.refershData:getSalaryFreeCount()
    if freeTimes > 0 then
        return true
    else
        return false
    end
end
--神秘商店拥有免费次数
function BuildingItem:HaveFree()
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipShopCount")
    local basefreenumber= global.MySteriousData:getFreeNumber()
    if (vipfreenumber+basefreenumber) >0 then 
        return true 
    end 
    return false 
end
-- 研究空闲
function BuildingItem:TechIdle()
    
    if not global.techData:isHaveTech() then
        return true
    else
        return false
    end
end

-- 避难所有痊愈伤兵
function BuildingItem:HpPrompt()

    local recruitData = global.soldierData:getAllHealedSoldierArr()
    if not recruitData or #recruitData <= 0 then
        return false
    else
        return true
    end
end

-- 排行榜
function BuildingItem:ShowRank()
    return false 
end 

-- 客服中心
function BuildingItem:ShowHelp()
    return false 
end 

-- 部队管理
function BuildingItem:troopIdle()
    return false 
end 

function BuildingItem:checkIdleHandler()

    if self.checkIdleCall then

        local res = self:checkIdleCall()
        
        if res then
            self:sleep()

            if self.data.buildingType == 32 then 
                self:checkIdleCall() --在检测方法中 做了一些 UI 操作
            end 
        else

            if self.m_sleepNodeOut then
                self.m_sleepNodeOut:setVisible(false)
                self.m_sleepNodeOut.timeLine:pause()
            end
        end
    end
end
function BuildingItem:checkIdle()
   
    local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    
    if data and data.idleTarget ~= "" then
   
        self.m_countDownTimerForIdelCheck = gscheduler.scheduleGlobal(handler(self,self.checkIdleHandler), 1)

        self.checkIdleCall = self[data.idleTarget]

        if self.checkIdleHandler then 
            self:checkIdleHandler()
        end 
    end
end

-- 每日任务未领取状态
function BuildingItem:setBuildState(data)

    if self.m_dailyNode then
        self.m_dailyNode:setVisible(false)
    end

    local unGetNum = global.dailyTaskData:unGetStateNum()

    local opLv = luaCfg:get_config_by(1).dailyTaskLv
    if data.buildingType == 27  and unGetNum > 0 and global.cityData:checkBuildLv(1, opLv) then

        if self.m_dailyNode then
            self.m_dailyNode:setVisible(true)
            return
        end
        
        local node = require("game.UI.dailyMission.UIDailyTaskIcon").new() 
        self.root:addChild(node)
        local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(data.buildingType))
        node:setPosition(cc.p(data.idleui_posX,data.idleui_posY))
        self.m_dailyNode = node  
    end

end
--增加空闲---------------------------------------------------<<<<<

--进行中---------------------------------------------------<<<<<

function BuildingItem:Teching()
    if global.techData:isHaveTech() then
        local data = global.techData:getQueueByTime()
        return data
    else
        return {}
    end
end


function BuildingItem:Activitying()
    local maxTime = 5 * 60 * 60

    local hava_activitying = global.ActivityData:getActivityStatus()

    if hava_activitying  then 

        return true 
    else 
        for _  ,v  in pairs(global.ActivityData.serverData) do 

            if v.lStatus == 0 then 

                if v.lBngTime - global.dataMgr:getServerTime() < maxTime then 

                    return true  
                end 
            end 
        end 
    end 

    return false 
end 

function BuildingItem:checkBusyIdle( )
     
    local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    
    if data and data.busyTarget and data.busyTarget ~= "" then
        
        if self.m_countDownTimerForBusyCheck then

            gscheduler.unscheduleGlobal(self.m_countDownTimerForBusyCheck)
            self.m_countDownTimerForBusyCheck = nil
        end
        self.m_countDownTimerForBusyCheck = gscheduler.scheduleGlobal(handler(self,self.checkBusyHandler), 1)

        self.checkBusyCall = self[data.busyTarget]

        self:checkBusyHandler()
    end
end

function BuildingItem:checkBusyHandler()

    if self.checkBusyCall then

        local data = self:checkBusyCall()
        
        if data and table.nums(data) > 0 then

            for _,v in pairs(data) do
                self:busy(v)
            end
        else
            self:exitBusy()
        end
    end
end

function BuildingItem:exitBusy()

    local data ={}

    for _ ,v in pairs( global.techData:getQueueByTime()) do 
        table.insert(data ,v )
    end 
    for _ ,v in pairs( global.techData:getDelTechQueue()) do 
        table.insert(data ,v )
    end 

    for _,v in pairs(data) do
                
        local i = v.lBindID or 0

        global.techData:delDelTechQueue(i)

        if self["m_countDownTimerForBusy"..i] then
            gscheduler.unscheduleGlobal(self["m_countDownTimerForBusy"..i])
            self["m_countDownTimerForBusy"..i] = nil
        end

        if self["m_busyWidget"..i] then
            self["m_busyWidget"..i]:removeFromParent()
            self["m_busyWidget"..i] = nil
        end
    end

end

function BuildingItem:checkMsg()

    if self.data.buildingType == 17 then  --科技直接 

        local data =global.techData:getDelTechQueue()

        for _,v in pairs(data) do
            
            local i = v.lBindID or 0

            if self["m_busyMsg"..i] then 

                self["m_busyMsg"..i].lRestTime = 0 


                global.techData:delDelTechQueue(i)
            end
        end
    end 
   
end 


function BuildingItem:busy(msg)
    if not msg then return end
    if not msg.lBindID then return end
    local i = msg.lBindID
    local countBusyHandler = function(dt)
        if self.addBusyWidget then
            self:addBusyWidget(self["m_busyMsg"..i])
        end
        local currTime = global.dataMgr:getServerTime()
        local m_restTime = 0

        if self.checkMsg then 
            self:checkMsg()
        end 
        self["m_busyMsg"..i].lRestTime = self["m_busyMsg"..i].lRestTime or 0
        if self["m_busyMsg"..i].lRestTime <= 0 then
            m_restTime = math.floor(self["m_busyMsg"..i].lRestTime)
        else
            m_restTime = math.floor(self["m_busyMsg"..i].lRestTime - (currTime-self["m_busyMsg"..i].lStartTime))
        end
        self["m_restTime"..i] = m_restTime

        if m_restTime <= 0 then

            if self["m_countDownTimerForBusy"..i] then
                gscheduler.unscheduleGlobal(self["m_countDownTimerForBusy"..i])
                self["m_countDownTimerForBusy"..i] = nil
            end
            if self["m_busyWidget"..i] then
                self["m_busyWidget"..i]:removeFromParent()
                self["m_busyWidget"..i] = nil
            end

            if self:isSelected() then
                global.g_cityView:getOperateMgr():removeOpeBtnWidget()
            end
            return
        end
        local data = {}
        data.time = global.funcGame.formatTimeToHMS(m_restTime)
        data.percent = (1 - m_restTime/self["m_totalTime"..i])*100
        self["m_busyWidget"..i]:updateInfo(data)

    end
    
    self["m_busyMsg"..i] = msg
    self["m_totalTime"..i] = msg.lTotleTime

    if self:CheckTime(msg) then 
        if not self["m_countDownTimerForBusy"..i] then
            self["m_countDownTimerForBusy"..i] = gscheduler.scheduleGlobal(function()
                -- body
                countBusyHandler(dt)
            end, 1)
            countBusyHandler(dt)
        end
    end 
end

function BuildingItem:CheckTime(msg)
    local m_restTime = 0 
    local i = msg.lBindID
    if self["m_busyMsg"..i] and self["m_busyMsg"..i].lRestTime and self["m_busyMsg"..i].lStartTime then
        local currTime = global.dataMgr:getServerTime()
        if self["m_busyMsg"..i].lRestTime <= 0 then
            m_restTime = math.floor(self["m_busyMsg"..i].lRestTime)
        else
            m_restTime = math.floor(self["m_busyMsg"..i].lRestTime - (currTime-self["m_busyMsg"..i].lStartTime))
        end
    end
    return m_restTime  > 0 
end 

function BuildingItem:addBusyWidget(msg)

    local i = msg.lBindID
    local posCall = function ()

        self["m_busyWidget"..i]:setPositionX(-45)
        local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        if buildingUIData and buildingUIData.btnui_posY ~= 0 then
            self["m_busyWidget"..i]:setPositionY(110+buildingUIData.btnui_posY+msg.index*70)
        else
            self["m_busyWidget"..i]:setPositionY(110+msg.index*70)
        end
    end

    if not self["m_busyWidget"..i] then
        self["m_busyWidget"..i] = Train.new()        
        self.root:addChild(self["m_busyWidget"..i])
        local iconStr = self:getIcon(msg)
        if self["m_busyWidget"..i].setData then 
            self["m_busyWidget"..i]:setData({icon=iconStr,scale= 0.3})
        end 
        posCall() 
    else
        posCall()
    end
end


function BuildingItem:getIcon(msg)
    
    local iconImg = ""

    -- 学院
    if self.data.buildingType == 17 then

        local tech = luaCfg:get_science_by(msg.lBindID)
        iconImg = tech.icon
    end

    return iconImg
end


-- 加速按钮点击回调
function BuildingItem:accelerate()
    
    local curQueue = global.techData:getQueue()
    local i = curQueue[1].lBindID

    local leftTimeAndTotalTime = function (data)
        if data then
            --使用道具消除cd回调方法
            global.techData:referQueue(data)
            self["m_busyMsg"..i].lRestTime = data.lRestTime or 0
            self["m_busyMsg"..i].lStartTime = data.lSysTime or 0
            self["m_restTime"..i] = data.lRestTime or 0
        end
        if i then 
             -- [protect]
            return  self["m_restTime"..i], self["m_totalTime"..i]
        end
    end

    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 科技加速
    panel:setData(leftTimeAndTotalTime, curQueue[1].lID, panel.TYPE_TECH_SPEED)

end

function BuildingItem:playAnimation()

    local cityView = global.g_cityView
    local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.serverData.lBuildID)
    local speed = 0.65
    cityNode:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        
        local trainEffect = resMgr:createCsbAction("effect/army_build_par","animation0",true)
        trainEffect:setPosition(cityNode:convertToWorldSpace(cc.p(0,0)))  
        trainEffect:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(gdisplay.width / 2,gdisplay.height - 50)),cc.RemoveSelf:create()))            
        uiMgr:configUITree(trainEffect)       
        trainEffect.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
        global.g_cityView:addChild(trainEffect, global.panelMgr.LAYER.LAYER_SYSTEM)

        end),cc.DelayTime:create(speed),cc.CallFunc:create(function()
                local upfire = resMgr:createCsbAction("effect/upgrade_effect_upfire","animation0",false,true)
                upfire:setPosition(cc.p(gdisplay.width / 2,gdisplay.height - 50))
                global.g_cityView:addChild(upfire, global.panelMgr.LAYER.LAYER_SYSTEM)
    end)))
end

--进行中---------------------------------------------------<<<<<


--增加好友新消息--------------------------------------------------->>>>>
    
function BuildingItem:addFriendNew()
    
    local addWidget = function (isHaveUnDeal, isDiplomatic, isExploit)
        if isHaveUnDeal then
            if self.m_friendNode and self.checkFriendPos then
                if self.m_friendNode then
                    self.m_friendNode:removeFromParent()
                    self.m_friendNode = nil
                end
            end
            local node = require("game.UI.friend.UIFriendNew").new() 
            self.root:addChild(node)
            node:setData(isDiplomatic, isExploit)
            self.m_friendNode = node             
        else
            if self.m_friendNode then
                self.m_friendNode:removeFromParent()
                self.m_friendNode = nil
            end
        end
        if self.checkFriendPos then 
            self:checkFriendPos()
        end
    end
    
    local checkFriendNew = function ()
        
        global.unionApi:getFriendList(function (msg)
            if tolua.isnull(self) then return end
            if not msg then-- protect
                return
            end 
            local isHaveUnDeal = false
            msg.tagFriendInfo = msg.tagFriendInfo or {}
            for _,v in pairs(msg.tagFriendInfo) do
                if v.lrequest == 2 then
                    isHaveUnDeal = true
                end
            end
            addWidget(isHaveUnDeal)
            
        end, 1)
    end

    local checkDiplomatic = function ()

        local exploitData = global.userData:getTagExploit()
        local appCount = global.unionData:getApproveCount()
        -- 军功开启等级
        if (exploitData.lDailyGold == 0) and global.userData:isOpenExploit() then
            addWidget(true, false, true)
        elseif appCount > 0 then
            addWidget(true, true)
        else
            checkFriendNew()
        end
    end

    checkDiplomatic()

end



local partx = 47

function BuildingItem:checkFriendPos() 

     if self.m_friendNode then

        local posY = 110

        if self.m_helpBtn  then -- 

            if self.unionBuildHelp then 

                self.m_helpBtn:setPosition(cc.p(-partx ,posY+150))

                self.unionBuildHelp:setPosition(cc.p(partx ,posY+150))
            else 
                self.m_helpBtn:setPosition(cc.p(9 ,posY+150))
            end 
        else 
            if self.unionBuildHelp and self.m_trainWidget then 

                self.unionBuildHelp:setPosition(cc.p(9,posY+150))

            elseif self.unionBuildHelp then --，没有联盟建设 帮助放在 self.m_friendNode 上面
                self.unionBuildHelp:setPosition(cc.p( 9 , posY+100))
            end 
        end 

        if self.m_trainWidget then           
            self.m_trainWidget:setPositionY(posY)  --
            posY = posY + 50
        end 


        self.m_friendNode:setPosition(cc.p(9, posY))
    else

        if self.m_helpBtn then -- 说明 self.m_trainWidget 存在

            if self.unionBuildHelp then 

                self.m_helpBtn:setPosition(cc.p(-partx , 200))

                self.unionBuildHelp:setPosition(cc.p(partx , 200))
            else 
                self.m_helpBtn:setPosition(cc.p(9 ,200))
            end   

        elseif self.m_trainWidget then 

            if self.unionBuildHelp then 

                self.unionBuildHelp:setPosition(cc.p(9 ,200))
            end 

        elseif  self.unionBuildHelp then 

            self.unionBuildHelp:setPosition(cc.p(9, 135))

        end 

    end


    local data = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType)) or {}
    local normal_posY = data.normal_posY or 0

    if self.unionBuildHelp then 
        local posY = self.unionBuildHelp:getPositionY()
        self.unionBuildHelp:setPositionY(posY+normal_posY)
    end

    if self.m_helpBtn then 
        local posY = self.m_helpBtn:getPositionY()
        self.m_helpBtn:setPositionY(posY+normal_posY)
    end

    if self.m_friendNode then 
        local posY = self.m_friendNode:getPositionY()
        self.m_friendNode:setPositionY(posY+normal_posY)
    end


end


--增加好友新消息--------------------------------------------------->>>>>


--增加联盟建筑研究--------------------------------------------------->>>>>

function BuildingItem:addUnionStudyCom()
    -- required int32      lID = 1;//唯一ID
    -- required int32      lLevel = 2;
    -- required int32      lState = 3;
    -- optional uint32     lEndTime    = 4;//结束时间点
    -- optional uint32     lTotleTime  = 5;//时间段
    local countHandler = function(dt,msg)
        -- body
        if self.addCountDownCom and self.addUnionStudyHelpCom then
            self:addCountDownCom()
            self:addUnionStudyHelpCom(msg)
        end
        local currTime = global.dataMgr:getServerTime()
        local lRestTime = msg.tgBuild.lEndTime-currTime
        local lTotleTime = msg.tgBuild.lTotleTime or 1
        if lRestTime < 0 then
            lRestTime = 0

            if self.m_countDownTimerForUStudy then
                gscheduler.unscheduleGlobal(self.m_countDownTimerForUStudy)
                self.m_countDownTimerForUStudy = nil
            end
            if self.m_trainWidget then
                self.m_trainWidget:removeFromParent()
                self.m_trainWidget = nil
            end
            return
        end
        local data = {}
        data.time = global.funcGame.formatTimeToHMS(lRestTime)
        data.percent = 100-lRestTime/msg.tgBuild.lTotleTime*100
        self.m_trainWidget:updateInfo(data)
    end
    self:checkUnionStudy(function(isDoing,msg)
        if tolua.isnull(self) then return end
        global.ClientStatusData:unionHelpMsg(msg)
        if isDoing then
            self.m_msg = msg
            if not self.m_countDownTimerForUStudy then
                self.m_countDownTimerForUStudy = gscheduler.scheduleGlobal(function()
                    -- body
                    countHandler(dt,self.m_msg)
                end, 1)
            end
            countHandler(dt,self.m_msg)
        else
            --没有处于研究状态删除对应控件
            if self.m_countDownTimerForUStudy then
                gscheduler.unscheduleGlobal(self.m_countDownTimerForUStudy)
                self.m_countDownTimerForUStudy = nil
            end
            if self.m_trainWidget then
                self.m_trainWidget:removeFromParent()
                self.m_trainWidget = nil
            end

            if self.m_helpBtn then
                self.m_helpBtn:removeFromParent()
                self.m_helpBtn = nil
            end
        end
        -- 刷新好友新消息位置
        if self.checkFriendPos then
            self:checkFriendPos()
        end
    end)
end
function BuildingItem:checkUnionStudy(call)
    if global.unionData:isMineUnion(0) then
        if call then call(false) end
        return
    end
    global.unionApi:getAllyBuildState(function(msg)
        -- 获取当前正在研究联盟建筑信息
        local isDoing = (msg.tgBuild and msg.tgBuild.lState == 1)
        if call then call(isDoing,msg) end
    end, global.userData:getlAllyID())
end
--增加联盟帮助功能
function BuildingItem:addUnionStudyHelpCom(i_msg)
    local currTime = global.dataMgr:getServerTime()
    local dt = i_msg.lHelpTime-currTime
    if (i_msg.lHelpTime == -1) or dt > 0 then
        if self.m_helpBtn then
            self.m_helpBtn:removeFromParent()
            self.m_helpBtn = nil
        end
    else
        if not self.m_helpBtn then
            self.m_helpBtn = require("game.UI.city.widget.UIFloatBtnWidget").new() 
            self.m_helpBtn:setData(1,function()
                -- body
                global.unionApi:startAllyBuild(function(msg)
                    if not self.m_helpBtn then return end
                    global.tipsMgr:showWarning("UnionBuild07",msg.lPay)
                    i_msg.lHelpTime = -1
                    self.m_helpBtn:removeFromParent()
                    self.m_helpBtn = nil
                    i_msg.tgBuild.lEndTime = msg.lEndTime
                end,i_msg.tgBuild.lID,1)
            end)
            self.m_helpBtn:setPosition(cc.p(9,200))
            self.m_helpBtn:setIcon("ui_surface_icon/union_help.png")
            self.root:addChild(self.m_helpBtn)    
        end
    end
end
--增加联盟建设倒计时
function BuildingItem:addCountDownCom()
    if not self.m_trainWidget then
        self.m_trainWidget = Train.new()
        self.m_trainWidget:setPositionX(-25)
        local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
        if buildingUIData and buildingUIData.btnui_posY ~= 0 then
            self.m_trainWidget:setPositionY(154+buildingUIData.btnui_posY)
        else
            self.m_trainWidget:setPositionY(154)
        end

        self.root:addChild(self.m_trainWidget)
        self.m_trainWidget:setData({icon=self.data.name,scale=0.135})
    end
end

--增加联盟建筑研究---------------------------------------------------<<<<<

function BuildingItem:setNextLvData(data)
    -- self.building:setSpriteFrame(data.new_name)
    -- self.building_select:setSpriteFrame(data.new_name)
    global.panelMgr:setTextureFor(self.building,data.new_name)
    global.panelMgr:setTextureFor(self.building_select,data.new_name)
end

function BuildingItem:resetData()
    local data = global.cityData:getBuildingById(self.data.id)
    self:setData(data,true)
end

function BuildingItem:onTouchBegan(touch, event)

    local pos = touch:getLocation()
    if self.checkResTouched and self:checkResTouched(pos) then
        if self.isCanHarvest then

            self:harvest()
            self.isCanHarvest = false

            -- 资源地点击一键全收
            gevent:call(global.gameEvent.EV_ON_TYPE_HARVEST, self.data.buildingType) 

            return true
        end            
    end
    return false
end

function BuildingItem:onTouchMoved(touch, event)

    local pos = touch:getLocation()
    if self.checkResTouched and self:checkResTouched(pos) then
        if self.isCanHarvest then

            self:harvest()
            self.isCanHarvest = false

            -- 资源地点击一键全收
            gevent:call(global.gameEvent.EV_ON_TYPE_HARVEST, self.data.buildingType) 
            
        end            
    end
end

function BuildingItem:onTouchEnded(touch, event)

    local pos = touch:getLocation()
    if self:checkTouched(pos) then
        print("选中了块："..self.data.id)
        local soundKey = "city_click_"..self.data.buildingType
        local g_cityView = global.g_cityView
        g_cityView:stopLastSoundEffect(soundKey)
        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)

        print(self:isSelected() ,"self:isSelected()=>>>>>")

        if not self:isSelected()  then 
            if self.m_clickCall then self.m_clickCall() end
        else 
            self:setSelected(false)
        end  

    else
        self:setSelected(false)
    end
    

end

function BuildingItem:onTouchCancel(touch, event)
end

function BuildingItem:showOperatePanel(state)    

    -- dump(self:getPosition(),'yes this pos')

    local removeCall = nil 
    if not self:canShowName() then 
        self.name_node:showName(true)
        removeCall = function (action) 
            if not self:canShowName() then 
                self.name_node:hideName( not action)
            end 
        end 
    end 

    self:setSelected(true)
    local g_cityView = global.g_cityView
    g_cityView:getOperateMgr():createOpeBtnWidget(self.data.buildingType,state or self:getBtnState(), removeCall , self.data)
    g_cityView:getOperateMgr():setData(self.data)
    g_cityView.curSelectBuildId = self.data.buildingType

    if self:getBtnState() == 'TRAIN' then 
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_TRAIN_SPEED) 
    end        
end

--超出屏幕外处理
function BuildingItem:outScreen()
    if not self.m_isAdded then return end
    self.m_isAdded = false
    if not self.root or tolua.isnull(self.root) then
        return
    else
        self.root:removeFromParent(false)
    end

end
-- if self.m_isAdded or not self.m_countDownTimer then then return end
local issynwallani = false
function BuildingItem:inScreen()
    if self.m_isAdded then return end
    self.m_isAdded = true
    self:addChild(self.root,-1)
    if self.showEffect and self.showEffect.m_csbName then
        if self.__cname == "Farm" then
            --针对资源建筑的动画进行特殊处理-》错帧播放
            self.effect_node:runAction(cc.Sequence:create(
                cc.DelayTime:create(self.data.id/300),
                cc.CallFunc:create(function()
                    if not tolua.isnull(self.showEffect.timeLine) then
                    else
                        self.showEffect.timeLine = resMgr:createTimeline(self.showEffect.m_csbName)
                        self.showEffect.timeLine:play(self.showEffect.m_actionStr, true)
                        self.showEffect:runAction(self.showEffect.timeLine)
                    end
                end)
            ))
        else
            if not tolua.isnull(self.showEffect.timeLine) then
            else
                self.showEffect.timeLine = resMgr:createTimeline(self.showEffect.m_csbName)
                self.showEffect.timeLine:play(self.showEffect.m_actionStr, true)
                self.showEffect:runAction(self.showEffect.timeLine)
            end
        end
    end
    if self.m_wallEffect and self.m_wallEffect.m_csbName and not issynwallani then
        issynwallani = true
        if self.data.buildingType == 14 then
            -- 同步城墙巨人动画
            local g_cityView = global.g_cityView
            if g_cityView.m_statue_pull_node then 
                if not tolua.isnull(g_cityView.m_statue_pull_node.timeLine) then
                    g_cityView.m_statue_pull_node:stopAction(g_cityView.m_statue_pull_node.timeLine)
                end
                g_cityView.m_statue_pull_node.timeLine = resMgr:createTimeline(g_cityView.m_statue_pull_node.m_csbName)
                g_cityView.m_statue_pull_node.timeLine:play(g_cityView.m_statue_pull_node.m_actionStr, true)
                g_cityView.m_statue_pull_node:runAction(g_cityView.m_statue_pull_node.timeLine)
            end 
            if not tolua.isnull(self.m_wallEffect.timeLine) then
                self.m_wallEffect:stopAction(self.m_wallEffect.timeLine)
            end
            self.m_wallEffect.timeLine = resMgr:createTimeline(self.m_wallEffect.m_csbName)
            self.m_wallEffect.timeLine:play(self.m_wallEffect.m_actionStr, true)
            self.m_wallEffect:runAction(self.m_wallEffect.timeLine)
        end
    end

    if self.addEffect and self.addEffect.m_csbName then
        if not tolua.isnull(self.addEffect.timeLine) then
        else
            self.addEffect.timeLine = resMgr:createTimeline(self.addEffect.m_csbName)
            self.addEffect.timeLine:play(self.addEffect.m_actionStr, true)
            self.addEffect:runAction(self.addEffect.timeLine)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

--状态机切换事件触发函数
function BuildingItem:doEvent(event_name)

    if self.fsm and self.fsm:canDoEvent(event_name) then
        self.fsm:doEvent(event_name)
    end
end

function BuildingItem:setSelected(isSelected)
    if not self.root then return end
    if not self.selectAction then
        self.selectAction = cc.CSLoader:createTimeline("city/building.csb")
        self.selectAction:play("select", true)
        self.root:runAction(self.selectAction)
    end
    self.m_selected = isSelected
    if self.m_selected then
        self.building_select:setVisible(self.m_selected)
    else
        self.building_select:setVisible(self.m_selected)
    end
end

function BuildingItem:isSelected()
    return self.m_selected
end

function BuildingItem:checkTouched(touchPos)
    local cityView = global.g_cityView
    local scrollPos = self:getParent():convertToNodeSpace(touchPos)
    -- local scrollPos = cityView:convertToSVSpace(touchPos)
    local isIn = self:checkRectContainsPoint(self:getTouchRect(), scrollPos)
    -- log.debug("#####posX=%s,posY=%s,name=%s,isIn=%s",self.data.posX,self.data.posY,self.data.buildsName,isIn)
    return isIn
end

function BuildingItem:getTouchRect()
    if self.data.id == 14 then
    --城墙
        return cc.rect(self.data.posX-100,self.data.posY-200,300,400)
    else
        self.m_rect = self.m_rect or cc.rect(0,0,200,200)
        local rect = cc.rect(self.m_rect.x,self.m_rect.y,self.m_rect.width,self.m_rect.height)
        local pos = cc.p(self.data.posX,self.data.posY)
        rect.x = pos.x+rect.x
        rect.y = pos.y+rect.y
        if self.data.id == 29 then
            rect.width = rect.width-30
        end
        return rect
    end
end

function BuildingItem:checkRectContainsPoint(i_rect,pos)
    local isIn = false
    if i_rect.x == nil then
        --i_rect 包含多个rect
        for i,rect in pairs(i_rect) do
            if cc.rectContainsPoint(rect, pos) then
                isIn= true
                break
            end
        end
    else
        isIn = cc.rectContainsPoint(i_rect, pos)
    end
    return isIn
end

function BuildingItem:getId()
    return self.data.id
end

function BuildingItem:getLv()
    return self.data.serverData.lGrade
end

function BuildingItem:getData()
    return self.data
end

function BuildingItem:getBuildingSprite()
    return self.building
end

function BuildingItem:getBtnState()

    local btnState = ""
    -- 研究
    if self.data.buildingType == 17 then

        local queue = global.techData:getQueue()
        if #queue == 1 then
            btnState = "TECH"
        elseif #queue == 2 then
            btnState = "TECH_2"
        else
            btnState = "SLEEP"
        end
    
    elseif self.data.buildingType == 24 then

        btnState = global.ActivityData:getBtnState1() 

    else 
        if self.fsm then
            btnState = self.fsm:getState()
        end
        if btnState ~= "2" then
            local queue = global.cityData:getTrainList(self.data.buildingType)
            local trainNum = global.cityData:getTrainingNum(queue)
            if trainNum > 1 then
                btnState = "TRAIN_2"
            elseif trainNum == 1 then
                btnState = "TRAIN"
            else
                btnState = "SLEEP"
            end
        end
    end

    return btnState
end


function BuildingItem:addUnionBuildHelp()--盟友请求建设帮助

    local removeIcon = function () 
        if self.unionBuildHelp then
            self.unionBuildHelp:removeFromParent()
            self.unionBuildHelp = nil
        end
    end 

    if self:isMemberHaveHelp() then 
        if not self.unionBuildHelp  then 
            self.unionBuildHelp = require("game.UI.city.widget.UIFloatBtnWidget").new() 
            self.unionBuildHelp:setPosition(cc.p(9,200))
            self.root:addChild(self.unionBuildHelp)
            self.unionBuildHelp:setData(1,function()
                removeIcon()
                global.unionData:setNumberBuildState(false)
                global.panelMgr:openPanel("UIUnionHelpPanel")
            end)
            self.unionBuildHelp:setIcon("ui_surface_icon/union_help_hammer.png")
        else
           
        end 
    else
        removeIcon()
    end 
    if self.checkFriendPos then
        self:checkFriendPos()
    end
end 


function BuildingItem:HeroExpActive()

    local flg = false  

    if not flg then 
        flg =  global.unionData:canReceiveHeroExp()
        if flg and self.m_sleepNodeOut then 
            self.m_sleepNodeOut.Sprite_1.Text_1:setTextColor(cc.c3b(165,42,42))
            self.m_sleepNodeOut.Sprite_1.Text_1:setScale(0.8)
            self.m_sleepNodeOut.Sprite_1.Text_1:setString(global.luaCfg:get_local_string(10488))
        end 
    end

    if not flg then 
        flg =not global.unionData:getMyMainExpHero()
        if flg and self.m_sleepNodeOut then 
            self.m_sleepNodeOut.Sprite_1.Text_1:setTextColor(cc.c3b(0,0,0))
            self.m_sleepNodeOut.Sprite_1.Text_1:setScale(1)
            self.m_sleepNodeOut.Sprite_1.Text_1:setString(global.luaCfg:get_local_string(10391))
        end
    end 

    if not flg then --泡澡中 

        local mainHero = global.unionData:getMyMainExpHero()

        local myspring = global.unionData:getMySpingData()

        if not  self.HeroExpNode   then 
            self.HeroExpNode= Persuade.new()
            self.HeroExpNode:setPositionX(-38)
            self.HeroExpNode:setPositionY(190)
            self.root:addChild(self.HeroExpNode)
        end 

        local persuadeData = {} 
        persuadeData.lTotleTime = myspring.lEndTime - myspring.lAddTime
        persuadeData.lBindID = mainHero.lHeroID
        local curTime = global.dataMgr:getServerTime()
        local lastTime = myspring.lAddTime + persuadeData.lTotleTime - curTime
        local pen = lastTime / persuadeData.lTotleTime * 100
        local str = global.funcGame.formatTimeToHMS(lastTime)          

        self.HeroExpNode:updateInfo({percent = (100 - pen),time = str} , persuadeData)
    end 

    if  self.HeroExpNode then 
        self.HeroExpNode:setVisible(not flg)
    end 

    return  flg
end 

function BuildingItem:isMemberHaveHelp()--盟友请求建设帮助

    if global.userData:getlAllyID() ~=0 then 

        return global.unionData:getNumberBuildState()
    end 

    return false 
end


return BuildingItem

--endregion

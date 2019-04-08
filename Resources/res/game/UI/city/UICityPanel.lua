--region UICityPanel.lua
--Author : wuwx
--Date   : 2016/07/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local panelMgr = global.panelMgr
local cityData = global.cityData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CityBuilder = require("game.UI.city.widget.CityBuilder")
local Bottom = require("game.UI.commonUI.widget.Bottom")
local UITaskJumpBoard = require("game.UI.mission.UITaskJumpBoard")
local Top = require("game.UI.commonUI.widget.Top")
local UINotice = require("game.UI.commonUI.widget.UINotice")
local UIUnionHint = require("game.UI.commonUI.UIUnionHint")
local UIGrowingIcon = require("game.UI.growing.UIGrowingIcon")
local UISeverDayEffectNode = require("game.UI.activity.sevendays.UISeverDayEffectNode")
--REQUIRE_CLASS_END

local UICityPanel  = class("UICityPanel", function() return gdisplay.newWidget() end )

local CityTouchMgr = require("game.UI.city.mgr.CityTouchMgr")
local CityCamera = require("game.UI.city.mgr.CityCamera")
local CityOperateMgr = require("game.UI.city.mgr.CityOperateMgr")
local CityWeatherMgr = require("game.UI.city.mgr.CityWeatherMgr")
local CitySoldierMgr = require("game.UI.city.mgr.CitySoldierMgr")
local BossMgr = require("game.UI.city.mgr.BossMgr")
local PetMgr = require("game.UI.city.mgr.PetMgr")

local CCSScrollView = require("game.UI.common.CCSScrollView")
local BuidingItem = require("game.UI.city.widget.BuildingItem")
local BuildListPanel = require("game.UI.city.widget.BuildListPanel")

local RainPosData = require("game.UI.city.RainPosData")

function UICityPanel:ctor()
    self:CreateUI()
end

function UICityPanel:CreateUI()
    local root = resMgr:createWidget("city/city")
    self:initUI(root)
end

function UICityPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/city")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.UI_ScrollView = self.root.Panel_1.UI_ScrollView_export
    self.panel_ui = self.root.panel_ui_export
    self.builder1 = self.root.panel_ui_export.builder1_export
    self.builder1 = CityBuilder.new()
    uiMgr:configNestClass(self.builder1, self.root.panel_ui_export.builder1_export)
    self.builder2 = self.root.panel_ui_export.builder2_export
    self.builder2 = CityBuilder.new()
    uiMgr:configNestClass(self.builder2, self.root.panel_ui_export.builder2_export)
    self.builder3 = self.root.panel_ui_export.builder3_export
    self.builder3 = CityBuilder.new()
    uiMgr:configNestClass(self.builder3, self.root.panel_ui_export.builder3_export)
    self.bot_ui = self.root.bot_ui_export
    self.bot_ui = Bottom.new()
    uiMgr:configNestClass(self.bot_ui, self.root.bot_ui_export)
    self.taskJumpBoard = UITaskJumpBoard.new()
    uiMgr:configNestClass(self.taskJumpBoard, self.root.taskJumpBoard)
    self.top_ui = self.root.top_ui_export
    self.top_ui = Top.new()
    uiMgr:configNestClass(self.top_ui, self.root.top_ui_export)
    self.FileNode_1 = UINotice.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.noUnionHint = self.root.noUnionHint_export
    self.noUnionHint = UIUnionHint.new()
    uiMgr:configNestClass(self.noUnionHint, self.root.noUnionHint_export)
    self.btn_lvup = self.root.btn_lvup_export
    self.conPic = self.root.btn_lvup_export.conPic_export
    self.conName = self.root.btn_lvup_export.conName_export
    self.conlv = self.root.btn_lvup_export.conlv_export
    self.growing = self.root.growing_export
    self.growing = UIGrowingIcon.new()
    uiMgr:configNestClass(self.growing, self.root.growing_export)
    self.seven_day_bt = self.root.seven_day_bt_export
    self.seven_day_effect = self.root.seven_day_bt_export.seven_day_effect_export
    self.seven_day_effect = UISeverDayEffectNode.new()
    uiMgr:configNestClass(self.seven_day_effect, self.root.seven_day_bt_export.seven_day_effect_export)

    uiMgr:addWidgetTouchHandler(self.btn_lvup, function(sender, eventType) self:unLockLvUpHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.seven_day_bt, function(sender, eventType) self:click_seven_day(sender, eventType) end)
--EXPORT_NODE_END
    global.g_cityView = self
    -- local label = cc.Label:createWithSystemFont("0",global.define.SYSTEM_FONT, size or 26)
    -- label:setPosition(gdisplay.cx,gdisplay.cy)
    -- self:addChild(label)
    -- self.textLabel = label
    -- self.FileNode_1:removeFromParent()

    -- self.top_ui.portrait_bg.Button_4:setCascadeOpacityEnabled(true)
    -- self.top_ui.portrait_bg.Button_4:getVirtualRenderer():setOpacity(100)

    -- self.top_ui.portrait_bg.Sprite_1:setOpacity(100)
    -- local tempState = cc.GLProgramState:getOrCreateWithGLProgramName(global.define.shaders.SHADER_NAME_POSITION_GRAYSCALE);
    -- self.top_ui.portrait_bg.Sprite_1:setGLProgramState(tempState)

    -- self.builder1:setVisible(false)
    -- self.builder2:setVisible(false)
    -- self.builder3:setVisible(false)
    -- self.top_ui:setVisible(false)
    -- self.bot_ui:setVisible(false)

    self.unlockX, self.unlockY = self.btn_lvup:getPosition()
    self.sevenX, self.sevenY = self.seven_day_bt:getPosition()
    self.growingX, self.growingY = self.growing:getPosition()

end

function UICityPanel:registerGuideWidgets()
    local guideData = global.guideData
    guideData:addTargetList(WDEFINE.GUIDE_TARGET_KEY.UI, "btn_build", self.bot_ui.btn_build)
    guideData:addTargetList(WDEFINE.GUIDE_TARGET_KEY.UI, "btn_task", self.taskJumpBoard.root.btn_task)
    guideData:addTargetList(WDEFINE.GUIDE_TARGET_KEY.UI, "builder1", self.builder1:getBtn())
    guideData:addTargetList(WDEFINE.GUIDE_TARGET_KEY.UI, "builder2", self.builder2:getBtn())
    guideData:addTargetList(WDEFINE.GUIDE_TARGET_KEY.UI, "builder3", self.builder3:getBtn())
end

function UICityPanel:getUIBtnBuild()
    return self.bot_ui.btn_build
end

local defaultScale = 1

function UICityPanel:onEnter()
    if global.sdkBridge.pay_checkDropOrder then
        global.sdkBridge:pay_checkDropOrder()
    end
    
    self.top_ui:setData()
    if global.userData:getCityState() == 3 then

        global.panelMgr:openPanel("FireFinish")
    end

    -- if global.heroData:isNeedShowWarning() then

    --     global.tipsMgr:showWarning("KnowTimeShort")
    -- end

    local cityBgData = luaCfg:get_config_by(1)
    local containerCsbName = cityBgData.cityBg
    self.m_scrollView = CCSScrollView.new()
    local containerNode = self.m_scrollView:initWithUIScrollView(self.UI_ScrollView,containerCsbName)   
    self.containerNode = containerNode
    self.containerCsbName = containerCsbName 

    local ids = {5}
    for i,v in ipairs(ids) do
        global.panelMgr:setTextureForAsync(self.containerNode.Node_1[string.format("s_city_%s_%s",v,v)],string.format("city/bg/s_city_1_0%s.jpg",v))
    end

    -- self:runAction()
    gdisplay.removeImage("icon/city/zhuzi.png")
    gdisplay.removeImage("icon/city/shenxiang.png")
    gdisplay.removeImage("icon/city/chibang.png")

    --初始化相机
    self:initManager()
    self.camera:resetCityCenter()
    self:createBuilderList()
    defaultScale = self.m_scrollView:getZoomScale()
    -- self:openCloud()

    local buildings = global.cityData:getBuildings()
    local sordBuildings = {}
    local ids = {24,16,5,6,29,20,18,7,33,2}

    for _idx,_ in ipairs(ids) do
        local v = {}
        if ids[_idx] == 16 then
            v = buildings[16+1000*global.userData:getRace()]
        else
            v = buildings[ids[_idx]]
        end
        if v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
        elseif v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.UNOPEN or v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
            local i_building = self:buildingCreate(v)

            if self:isBuildingInScreen(i_building) then
                i_building:inScreen()
            else
                i_building:outScreen()
            end
        end

    end
    self:getUIBtnBuild():setVisible(false)

    -- 联盟加入提示
    self:addEventListener(global.gameEvent.EV_ON_UNIONHINT,function (event, isHide)
        if self.checkUnionHint then
            self:checkUnionHint(isHide)
        end
    end)
    self:addEventListener(global.gameEvent.EV_ON_GUIDE_START, function()
        if self.noUnionHint then
            self.noUnionHint:hideHint()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_BUILDIERS_UPDATE, function ()  
        self:createBuilderList()
    end)

    -- 联盟红包
    self:checkUnionRedBag()
    self:addEventListener(global.gameEvent.EV_ON_UNION_REDBAG,function ()
        if self.checkUnionRedBag then
            self:checkUnionRedBag()
        end
    end)
    global.chatData:refershUnionGift()
    

 -- 判断城堡下一等级是否有解锁内容
    self:addEventListener(global.gameEvent.EV_ON_UPGRADE_CITY,function (event, cityId)
        if cityId == 1 then
            self:checkNextLvLock()
            self:adjustPs()
        end
    end)
    self:checkNextLvLock()
    -- 七日霸主之路按钮 
    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE,function()
        if self.UpdateSevenDayUI then 
            self:UpdateSevenDayUI()
            self:adjustPs()
        end 
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE,function()
        self:updateSevenDayRedPoint()
    end)

    self:UpdateSevenDayUI()
    self:updateSevenDayRedPoint()
    self:adjustPs()


    self:checkPetIcon()

    self:addEventListener(global.gameEvent.EV_ON_PET_UNLOCK, function ()
        if self.checkPetIcon then
            self:checkPetIcon()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_PET_REFERSH, function (event, friNum)
        if self.checkPetIcon then
            self:checkPetIcon(friNum)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.checkPetIcon then
            self:checkPetIcon()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.checkPetIcon then
            self:checkPetIcon()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_TYPE_HARVEST, function (event, buildingType)

        local delay = 0
        for i,i_building in ipairs(self.touchMgr.registerBuildings) do
            if i_building.data and i_building.data.buildingType == buildingType then  
                if i_building.isCanHarvest then
                    i_building.isCanHarvest = false
                    i_building:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function ()
                        -- body
                        i_building:harvest()
                    end)))
                    delay = delay + 0.02                    
                end
            end 
        end
    end)

end

function UICityPanel:checkPetIcon()

    local data = global.petData:getGodAnimalByFighting()

    if data and  data.serverData.lState == 2 then  --倒计时中 

        local node = self:getPetIcon()

        node:setData(data)

    elseif data and  data.serverData.lState == 3 then --点击 解锁中

        local node = self:getPetIcon()

        node:setData(data)

    else 
        self:hidePet()
    end  

end 

function UICityPanel:hidePet()
    if self.petIcon and not tolua.isnull(self.petIcon)  then 
        self.petIcon:setVisible(false)       
    end 
end 

function UICityPanel:getPetIcon()
    if not self.petIcon then 
        self.petIcon = require("game.UI.city.UIPetIcon").new()
        self:addChild(self.petIcon)
        self.petIcon:setPosition(cc.p(478.26 , gdisplay.height - 142.5))
     end 
     self.petIcon:setVisible(true)
    return self.petIcon    
end 


function UICityPanel:updateSevenDayRedPoint()

    if not tolua.isnull(self.seven_day_bt) then 

        self.seven_day_effect.red_point:setVisible(false)

        local day = {} 
        local nowDay = 1 
        if global.ActivityData.sevenDayData then 
            nowDay = global.ActivityData.sevenDayData.lDay
        end 
        for _ ,v in ipairs(global.luaCfg:seven_day()) do 
            if not (v.day > nowDay) then 
                table.insert(day ,v.day) 
            end 
        end 
        -- print(global.ActivityData:getSevenDayRedPointNumber(day) ,"Test ////")
        local  state  ,number =global.ActivityData:getSevenDayRedPointNumber(day)

        if global.ActivityData:getSevenDayNotifyRedCount() ~= nil  and number < global.ActivityData:getSevenDayNotifyRedCount() then 
            number = global.ActivityData:getSevenDayNotifyRedCount()
        end 

        state = true and number > 0 

        self.seven_day_effect.red_point:setVisible(state)
        self.seven_day_effect.red_point_text:setString(number)
        
    end 

end 

function UICityPanel:UpdateSevenDayUI()

    if global.scMgr:isWorldScene() then 
        self.seven_day_bt:setVisible(false)
        return 
    end 

    local activity_data = global.ActivityData:getActivityById(19001)

    self.seven_day_bt:setVisible(activity_data.serverdata ~= nil )

    self.seven_day_effect:Action(activity_data.serverdata ~= nil )

    self.seven_day_bt:setEnabled(activity_data.serverdata ~= nil)


    if  not activity_data.serverdata then return end 

    local time = activity_data.serverdata.lEndTime

    -- print(time , "tiime /？？？？》》》》》》》》》》》》》")

    if time and  time - global.dataMgr:getServerTime() < 0 then 

    else    
        self.seven_day_effect:setData({lEndTime = time})
    end
end 

function UICityPanel:checkNextLvLock()

    self.btn_lvup:setVisible(false)
    local curCityLv = global.cityData:getBuildingById(1).serverData.lGrade
    local indexLv = curCityLv + 1
    local lvData = luaCfg:city_lvup()
    for i=1,#lvData do
        if (i == indexLv) and (lvData[i].maxNum > 0) then

            self.btn_lvup:setVisible(global.scMgr:isWorldScene() == false)
            global.panelMgr:setTextureFor(self.conPic, lvData[i].icon1)
            self.conPic:setScale(lvData[i].cityScale1/100)
            self.conPic:setPositionY(60+lvData[i].cityPosY1)
            self.conName:setString(lvData[i].func1)
            self.conlv:setString(global.luaCfg:get_local_string(10781, indexLv))

            return lvData[i]
        end
        if i == indexLv then
            indexLv = indexLv + 1
        end
    end

    return false
end

function UICityPanel:adjustPs()

    local isIPD = gdisplay.height - 1065 <=0 

    local ipadPS = {
        cc.p(self.unlockX , self.unlockY),
        cc.p(self.unlockX + 120 , self.unlockY-5),
        cc.p(self.unlockX  + 120 , self.unlockY + 120),
    } 

    local normalPS = {
        cc.p(self.unlockX , self.unlockY),
        cc.p(self.sevenX , self.sevenY),
        cc.p(self.growingX , self.growingY),
    } 

    local tt = {} 

    if self.btn_lvup:isVisible() and self.seven_day_bt:isVisible() and self.growing:isVisible() then 

        tt = {self.btn_lvup  ,self.seven_day_bt , self.growing} 

    elseif self.seven_day_bt:isVisible() and self.btn_lvup:isVisible()   then 

        tt = {self.seven_day_bt , self.btn_lvup} 

    elseif self.seven_day_bt:isVisible() and self.growing:isVisible() then 

        tt = {self.seven_day_bt , self.growing} 

    elseif self.btn_lvup:isVisible() and self.growing:isVisible() then 

        tt = {self.btn_lvup , self.growing} 

    elseif self.btn_lvup:isVisible() then 
    
        tt = {self.btn_lvup} 

    elseif self.seven_day_bt:isVisible() then 

        tt = {self.seven_day_bt} 

    elseif self.growing:isVisible() then 

        tt = {self.growing} 
    end 
 
    if isIPD then 
        for index ,v in pairs(tt) do 
            v:setPosition(ipadPS[index])            
        end 
    else 
        for index ,v in pairs(tt) do 
            v:setPosition(normalPS[index])            
        end
    end

end 


function UICityPanel:getDefaultScale()

    return defaultScale
end 

function UICityPanel:checkUnionRedBag(isHide)

    local isBuildShow = self.buildListPanel and self.buildListPanel:isVisible()
    if isHide or isBuildShow then 
        if self.unionGift then 
            self.unionGift:hideHint()
        end 
        return 
    end -- 进入建造列表

    if not self.unionGift then 
        local UIRedBag = require("game.UI.commonUI.UIRedBag")
        self.unionGift =UIRedBag.new(true)
        self.unionGift:setPositionX(650)
        self.unionGift:setPositionY(370)
        self.root:addChild(self.unionGift)
    end 

    self.unionGift:setData()
end

function UICityPanel:checkUnionHint(isHide)

    if self.buildListPanel and self.buildListPanel:isVisible() then return end -- 进入建造列表
    local isNotJoin = not global.userData:checkJoinUnion()
    local isCityLV = global.cityData:getBuildingById(1).serverData.lGrade < 10
    local cdTime = global.unionData:getAllyCdTime()
    local limitConfig = global.luaCfg:get_config_by(1).union_cd_time
    local limit = global.dataMgr:getServerTime() - cdTime
    local isNoCding = (cdTime == 0) or (limit > limitConfig*60)
    if isNotJoin and isCityLV and isNoCding then
        self.noUnionHint:showHint()
    else
        self.noUnionHint:hideHint()
    end
    if isHide then
        self.noUnionHint:hideHint()
    end
end

function UICityPanel:openCloud(callback)

    local widget = global.scMgr:CurScene().cloud 
    if widget == nil or tolua.isnull(widget) then 
        -- 没有切云->loading进入内城
        self:loadDtNode()
        return 
    end

    local timelineAction = resMgr:createTimeline("world/yun_new")
    widget:runAction(timelineAction)
    timelineAction:play("animation1", false)        

    timelineAction:setLastFrameCallFunc(function()

        
        widget:removeFromParent()
        if self.loadDtNode then
            self:loadDtNode()
        end
        if callback then callback() end
        
    end)          
end

-- 提交错帧处理
function UICityPanel:loadDtNode()
    if tolua.isnull(self.m_scrollView) then return end
    self:createBg()
    self:createBuildings()

    if global.userData:getCityState() == 2 then

        self:createFireEffect()
    end  
    self:createRewardBag()  -- 宝箱
    self:addEventListener(global.gameEvent.EV_ON_UI_REWARDBAG_FLUSHSTATE,function ()
        self:createRewardBag()
    end)

    self:createRewardBagTime()
    global.netRpc:addHeartCall(function () 
        
        global.dailyTaskData:initFreeBagNum(global.dailyTaskData:getLastFreeMsg())

        self:createRewardBagTime()

    end ,"createRewardBagTime")

    self:createBuildListPanel()
    self:getUIBtnBuild():setVisible(not global.cityData:isBuildAllOver())

    local function createBuilding(eventType,id)
        --建造建筑
        local overCall = function()
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_CITY_BUILD, createBuilding)

    -- global.funcGame.gpsBuildListPanel()

    self:registerGuideWidgets()
    --开始引导
    gevent:call(global.gameEvent.EV_ON_GUIDE_START)

    global.worldApi:dealAttackEffect(false)
    
    if global.userData:getCityState() == 3 then

        global.panelMgr:openPanel("FireFinish")
    end

    -- if global.heroData:isNeedShowWarning() then

    --     global.tipsMgr:showWarning("KnowTimeShort")
    -- end
    -- local rotation = self.m_scrollView:getRotation3D()
    -- self.m_scrollView:setRotation3D(cc.vec3(rotation.x-10,rotation.y,rotation.z))

    self:checkScreen()

    global.scMgr:getMainSceneCall()
    global.scMgr:setMainSceneCall(nil)

    local m_firstIn =  global.m_firstIn

    global.delayCallFunc(function()
        if not tolua.isnull(self.bot_ui) then
            self.bot_ui:dailyRegister(m_firstIn)  
        end
    end,nil,0.5)  
   

    gevent:call(global.gameEvent.EV_ON_ENTER_MAIN_SCENE)
    global.uiMgr:removeSceneModal(98789)
    
    gevent:call(global.gameEvent.EV_ON_UI_BUILD_RED_FLUSH)

    global.scMgr:setChangeState(false)
end

function UICityPanel:onExit()
    --print("$$$$$$$$$$$$$UICityPanel:onExit()")
    if self.touchMgr then
        for i,i_building in ipairs(self.touchMgr.registerBuildings) do
            if i_building.root and not tolua.isnull(i_building.root) then
                i_building.root:cleanup()
                i_building.root:release()
            end
        end
        self.touchMgr:unregisterAllTouch()
    end

    if self.m_canVisibleRectEffectT then
        for i,i_building in ipairs(self.m_canVisibleRectEffectT) do
            i_building:cleanup()
            i_building:release()
        end
    end
    self:clearRainPoint()
    global.g_cityView = nil

    global.netRpc:delHeartCall("createRewardBagTime")
    -- CCUserDefault:sharedUserDefault():setIntegerForKey(CUR_USER_KEY)
    -- CCUserDefault:sharedUserDefault():setStringForKey(CUR_USER_KEY)
end

function UICityPanel:initManager()
    self.touchMgr = CityTouchMgr.new(self)
    self:getScrollViewLayer("touch"):addChild(self.touchMgr)

    self.camera = CityCamera.new()
    self:addChild(self.camera)

    self.operateMgr = CityOperateMgr.new()
    self:addChild(self.operateMgr)

    self.soldierMgr = CitySoldierMgr.new()
    self:addChild(self.soldierMgr)

    self.bossMgr = BossMgr.new()
    self:addChild(self.bossMgr)

    self.petMgr = PetMgr.new()
    self:addChild(self.petMgr)
end
local isNoCheckScreen = false
function UICityPanel:setNoCheckScreen(s)
    isNoCheckScreen = s
    if s then
        gscheduler.performWithDelayGlobalBindTarget(self,function ()
            isNoCheckScreen = false
        end,2)
    end
end

--公用的检测是否在屏幕内的api
function UICityPanel:checkScreen()
    if isNoCheckScreen then return end
    for i,i_building in ipairs(self.touchMgr.registerBuildings) do
        if self:isBuildingInScreen(i_building) then
            i_building:inScreen()
        else
            i_building:outScreen()
        end
    end

    if self.m_canVisibleRectEffectT then
        for i,i_effectNode in ipairs(self.m_canVisibleRectEffectT) do
            if self:isEffectInScreen(i_effectNode) then
                if i_effectNode.lua_parentName and not i_effectNode:getParent() then
                    local parent = self:getScrollViewLayer(i_effectNode.lua_parentName)
                    parent:addChild(i_effectNode)
                end
            else
                i_effectNode:removeFromParent(false)
            end
        end
    end
end
function UICityPanel:createBg()
    local ids = {1,3,4,2,6,7,8,9}
    for i,v in ipairs(ids) do
        if not tolua.isnull(self.containerNode) then
            global.panelMgr:setTextureForAsync(self.containerNode.Node_1[string.format("s_city_%s_%s",v,v)],string.format("city/bg/s_city_1_0%s.jpg",v),false)
        end
    end


    self.m_showBuildingScheduler = gscheduler.scheduleGlobal(function()
        -- self.textLabel:setString(self.m_scrollView:getZoomScale())
        if self.m_isUpdateCity then
            self:checkScreen()
            self:setIsUpdateCity(false)
        end
    end, 0.1)

    if not tolua.isnull(self.m_scrollView) then
        self.m_scrollView:setViewDidScroll(function()
            if self.sunshine then
                local pen = self.m_scrollView:getContentOffset().x / 2520 
                
                self.sunshine:setRotation(pen * 60 - 15)
            end

            self:setIsUpdateCity(true)
            self:setIsUpdateRain(true)
        end)
    end
    
    if not cc.UserDefault:getInstance():getBoolForKey("setting_performance_env_effect",true) or (cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone", false)) then
        return
    end
    --延迟一秒钟创建
    self.sunshine = resMgr:createCsbAction("city/citySunshine","animation0",true)
    self.sunshine:setPosition(gdisplay.width,gdisplay.height)
    self:addChild(self.sunshine)

    local actionT = {}
    self.m_canVisibleRectEffectT = {}
    local cityEffect = {
        {effect = "effect/city_leftdown_env",parent = "effect_down"},
        {effect = "effect/city_leftdown_env1",parent = "environment_effect"},
        {effect = "effect/city_leftdown_env2",parent = "environment_effect"},
        {effect = "effect/city_leftdown_env3",parent = "effect_down"},
        {effect = "effect/city_leftdown_congwu",parent = "environment_effect"},
        {effect = "effect/city_sea_01",parent = "effect_down"},
        {effect = "effect/city_sea_02",parent = "effect_down"},
        {effect = "effect/city_sea_03",parent = "effect_down"},
        {effect = "effect/city_sea_04",parent = "effect_down"},
        {effect = "effect/city_sea_05",parent = "effect_down"},
        {effect = "effect/city_sea_06",parent = "effect_down"},
        {effect = "effect/city_sea_07",parent = "effect_down"},
        {effect = "effect/city_sea_08",parent = "effect_down"},
        {effect = "effect/city_sea_09",parent = "effect_down"},
        {effect = "effect/city_rightdown_env",parent = "environment_effect"},
        {effect = "effect/city_rightdown_env1",parent = "environment_effect"},
        {effect = "effect/city_rightdown_env2",parent = "environment_effect"},
        {effect = "effect/city_rightdown_env3",parent = "environment_effect"},
        {effect = "effect/city_rightdown2_env",parent = "environment_effect"},
        {effect = "effect/city_animals",parent = "environment_effect",skip = true},
    }
    for i,v in pairs(cityEffect) do
        local weather = resMgr:createCsbAction(v.effect,"animation0",true)
        weather.m_itemData = v
        local parent = self:getScrollViewLayer(v.parent)
        if parent then
            parent:addChild(weather)
            if not v.skip then
                weather:retain()
                weather.lua_parentName = v.parent
                table.insert(self.m_canVisibleRectEffectT,weather)
            end
        end
    end

    local actionT = {}
    local cityEffect = {
        {effect = "effect/city_ld_env_hide",parent = "environment_effect"},
        {effect = "effect/city_rd_env_hide",parent = "effect_down"},
        {effect = "effect/city_rd2_env_hide",parent = "environment_effect"},
    }
    for i,v in pairs(cityEffect) do
        local weather = resMgr:createCsbAction(v.effect,"animation0",true)
        self:getScrollViewLayer(v.parent):addChild(weather)
    end

    self:setBirdEnvSounds(false)
    self:setIsUpdateRain(false)

    self.weatherMgr = CityWeatherMgr.new()
    self:addChild(self.weatherMgr)
end

function UICityPanel:createRain()
    local rain = resMgr:createCsbAction("effect/city_rainsnow","animation0",true)
    self.root:addChild(rain)

    local weather = resMgr:createCsbAction("effect/city_weather_rainwaver","animation0",true,nil,function(frame,node)
        -- 控制雷电音效的声音
        local str = frame:getEvent()
        local _, i_end = string.find(str, "playsound")
        if i_end then
            
            if not node or node:isVisible() then

                local eventName = string.sub(str, i_end+2)
                if not self.m_scrollView:isNodeVisible(self:getScrollViewLayer("sound_main03")) then
                    gsound.stopEffect(eventName)
                end
            end            
        end
    end)
    self:getScrollViewLayer("effect_down"):addChild(weather)
    self.m_city_weather_rainwaver = weather
    
    self.rain_par = rain.rain_par_export
    self.rain_effect = rain.rain_effect_export
    self.rain_effect:setVisible(false)
    self.rain_par:setVisible(false)
    self:createRainPoint()
end

function UICityPanel:createSnow()
    local rain = resMgr:createCsbAction("effect/city_snow","animation0",true)
    self.root:addChild(rain)
    self.snow_par = rain.snow_par_export
    self.snow_effect = rain.snow_effect_export
    self.snow_par:setVisible(false)
end

function UICityPanel:createRainPoint()
    --确保只初始化一次
    if self.m_rainSchedule then return end
    self.m_city_weather_rainwaver.weather:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
        -- body
        --延迟一帧
        self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main01"),"city_main_1")
        self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main02"),"city_main_2")
        self:updateRain()
    end)))

    self.m_rainScheduler = gscheduler.scheduleGlobal(function()
        if self.m_isUpdateRain then
            --移动并且晴天和正常天气时播放
            self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main01"),"city_main_1")
            self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main02"),"city_main_2")
        end
        -- body
        if not self.m_isUpdateRain or (self.m_city_weather_rainwaver and not self.m_city_weather_rainwaver:isVisible()) then
            return
        end
        self:updateRain()
        self:setIsUpdateRain(false)
    end, 0.8)
end

--获取环境附加音效点到屏幕中心点的位置
function UICityPanel:getDsNodeToBgCenter(node,key)
    local scrollScale = self.m_scrollView:getZoomScale()
    local nodePos = cc.p(node:getPosition())
    local scrollView2ScreenLDPos = self.m_scrollView:getContentOffset()
    local tx = scrollView2ScreenLDPos.x/scrollScale
    local ty = scrollView2ScreenLDPos.y/scrollScale

    --中心点坐标转为滚动容器坐标
    scrollView2ScreenCentrePos = cc.p(-tx+gdisplay.cx,-ty+gdisplay.cy)

    local ds = cc.pGetDistance(nodePos,scrollView2ScreenCentrePos)
    local soundData = luaCfg:get_sounds_by(key)
    if self.m_isOpenBirdSound then
        local vol = 0
        if ds<= 100 then
            vol = soundData.volume
        elseif  ds > 100 and ds <=1000 then
            vol = soundData.volume/(math.floor(ds/70))
        end
        gsound.setBgmVolume(vol,key)
    else
        gsound.setBgmVolume(0,key)
    end
end

--彻底清除
function UICityPanel:clearRainPoint()
    self:removeRain()
    if self.m_rainScheduler then
        gscheduler.unscheduleGlobal(self.m_rainScheduler)
        self.m_rainScheduler = nil
    end

    if self.m_showBuildingScheduler then
        gscheduler.unscheduleGlobal(self.m_showBuildingScheduler)
        self.m_showBuildingScheduler = nil
    end
end

function UICityPanel:setIsUpdateRain(y)
    self.m_isUpdateRain = y
end

function UICityPanel:setIsUpdateCity(y)
    self.m_isUpdateCity = y
end

function UICityPanel:setBirdEnvSounds(y)
    self.m_isOpenBirdSound = y
    self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main01"),"city_main_1")
    self:getDsNodeToBgCenter(self:getScrollViewLayer("sound_main02"),"city_main_2")
end

function UICityPanel:updateRain()
    if not self.m_rainT then
        self.m_rainT = {}

        for i = 1,15 do
            self:createRainAction()
        end
    end
    local screenItems = {}
    for i = 1,#RainPosData do
        local item = RainPosData[i]
        if self:checkInScreen(cc.p(item.sx,item.sy)) then
            table.insert(screenItems,item)
        end
    end
    local idx = 0
    local maxIdx = math.min(15,#screenItems)
    for i=1,maxIdx do
        local len = #screenItems
        local randIdx = math.random(len)
        local item = screenItems[randIdx]
        self.m_rainT[i]:setPosition(cc.p(item.sx,item.sy))
        self.m_rainT[i]:setScaleX(item.scaleX)
        self.m_rainT[i]:setScaleY(item.scaleY)
        table.remove(screenItems,randIdx)
    end
end

function UICityPanel:removeRain()
    if not self.m_rainT then return end
    for i = 1,#self.m_rainT do
        local item = self.m_rainT[i]

        if item and item:getParent() then
            item:removeFromParent()
        end
    end
    self.m_rainT = nil
end

function UICityPanel:createRainAction(noRemove)
    local randI = math.random(5)-1
    local rainP = resMgr:createCsbAction("effect/city_weather_rain_point","animation"..randI,true)
    self.m_city_weather_rainwaver.weather:addChild(rainP)
    table.insert(self.m_rainT,rainP)
    return rainP
end


function UICityPanel:checkInScreen(point)
    --scrollview屏幕左下角对应的contentoffset
    local scrollScale = self.m_scrollView:getZoomScale()
    local scrollView2ScreenLDPos = self.m_scrollView:getContentOffset()
    local tx = -scrollView2ScreenLDPos.x/scrollScale
    local ty = -scrollView2ScreenLDPos.y/scrollScale

    local pointToScreenPos = cc.p(point.x-tx,point.y-ty)
    local rect = cc.rect(0,0,gdisplay.width,gdisplay.height)
    return cc.rectContainsPoint(rect, pointToScreenPos)
end

--写入雨晕的点
function UICityPanel:writePointOfRainRecursive(widget,content)
    local childCount = widget:getChildrenCount()
    if childCount <= 0 then return content end
    local children = widget:getChildren()
    for k, child in ipairs(children) do
        local name = child:getName()
        if string.find(name, "Sprite_") then
            local pos = cc.p(child:getPosition())
            local parentPos = cc.p(child:getParent():getPosition())
            local worldPos = cc.p(parentPos.x+pos.x,parentPos.y+pos.y)
            local scaleX = child:getScaleX()
            local scaleY = child:getScaleY()
            local tempS = string.format("{x=%d,y=%d,scaleX=%2f,scaleY=%2f,sx=%d,sy=%d},",pos.x,pos.y,scaleX,scaleY,worldPos.x,worldPos.y)
            content = content.."\t"..tempS.."\n"
        end
        content = self:writePointOfRainRecursive(child,content)
    end
    return content
end

function UICityPanel:changeScene()
    
    -- for i = 1,3 do
    --     self["builder"..i]:runAction(cc.MoveBy:create(0.5,cc.p(-200,0)))
    -- end

    -- self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
    -- self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
    if not self.m_scrollView then return end

    local node = cc.Node:create()
    self.m_scrollView:addChild(node)

    node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() - 0.01)
    end),cc.DelayTime:create(1 / 60)),30))
end

function UICityPanel:createFireEffect()
    
    if self.fire == nil then

        self.fire = resMgr:createCsbAction("effect/fire_city", "animation0", true, false, nil, nil)    
        self.m_scrollView:getContainer():addChild(self.fire,998)    
    end    
end

function UICityPanel:removeFireEffect()
    
    if self.fire then

        self.fire:removeFromParent()
        self.fire = nil
    end
end

-- 宝箱奖励
function UICityPanel:createRewardBag()
    
    if self.rewardBag == nil then

        local chestPos = luaCfg:get_chest_pos_by(1)
        self.rewardBag = require("game.UI.chest.UIChestItem").new() 
        self.rewardBag:setData()
        self.m_scrollView:getContainer():addChild(self.rewardBag,998)    
        self.rewardBag:setPosition(cc.p(chestPos.posX, chestPos.posY))
    else
        -- 刷新状态
        self.rewardBag:setData()
    end    
 
end


-- 宝箱时间
function UICityPanel:createRewardBagTime()

    if self.rewardBagTime == nil then 
        local chestPos = luaCfg:get_chest_pos_by(1)
        self.rewardBagTime= require("game.UI.chest.UIChestTime").new() 
        self.rewardBagTime:setPosition(cc.p(chestPos.posX-5, chestPos.posY+80))
        self.m_scrollView:getContainer():addChild(self.rewardBagTime,999)   
    else 
        -- 刷新状态
        self.rewardBagTime:setData()
    end  
end



function UICityPanel:enterScene()

    -- for i = 1,3 do
    --     self["builder"..i]:runAction(cc.MoveBy:create(0,cc.p(-200,0)))
    --     self["builder"..i]:runAction(cc.MoveBy:create(0.5,cc.p(200,0)))
    -- end

    -- self.bot_ui:runAction(cc.MoveBy:create(0,cc.p(0,-200)))
    -- self.bot_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,200)))
    -- self.top_ui:runAction(cc.MoveBy:create(0,cc.p(0,200)))
    -- self.top_ui:runAction(cc.MoveBy:create(0.5,cc.p(0,-200)))
    if not self.m_scrollView then return end
    
    local node = cc.Node:create()
    self.m_scrollView:addChild(node)

    self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() - 0.3)
    node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        self.m_scrollView:setZoomScale(self.m_scrollView:getZoomScale() + 0.01)
    end),cc.DelayTime:create(1 / 60)),30))
end

-- 作者:
-- 0-代表空地+未建造
-- 1-代表建筑存在+未建造  未开放弹出
-- 2-代表建筑存在+已建造
function UICityPanel:createBuildings()
    local buildings = global.cityData:getBuildings()
    local sordBuildings = {}
    local ids = {}
    local noids = {24,16,5,6,29,20,18,7,33,2}
    local keys = {}
    for k, v in pairs(buildings) do
        if v.buildingType == 16 then
            k = 16
        end
        if table.hasval(noids, k) then
        else
            table.insert(ids,k)
        end
    end

    for _idx,_ in ipairs(ids) do
        local v = {}
        if ids[_idx] == 16 then
            v = buildings[16+1000*global.userData:getRace()]
        else
            v = buildings[ids[_idx]]
        end
        if v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
        elseif v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.UNOPEN or v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
            self:buildingCreate(v)
        end
    end

    -- --开启内城士兵行走
    local function onFrameEvent(frame,i_node)
        local str = frame:getEvent()
        local _, i_end = string.find(str, "corder")
        if i_end then
            local posz = string.sub(str, i_end+2)
            i_node:setLocalZOrder(posz)
        end
    end
    if not cc.UserDefault:getInstance():getBoolForKey("setting_performance_env_effect",true) or (cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone", false)) then
        --针对城墙巨人特殊处理
        local v = luaCfg:get_city_effect_by(11)
        if v.effect ~= 0 and (not v.buildingId or v.buildingId <= 0) or self:getTouchMgr():getBuildingNodeBy(v.buildingId) then
            local weather = resMgr:createCsbAction(v.effect,"animation0",true, nil, onFrameEvent)
            if v.posX ~= 0 then weather:setPositionX(v.posX) end
            if v.posY ~= 0 then weather:setPositionY(v.posY) end
            self.m_statue_pull_node = weather
            self:getScrollViewLayer(v.parent):addChild(weather)
        else
            return
        end
        return
    end
    local actionT = {}
    local cityEffect = luaCfg:city_effect()
    table.insert(actionT,cc.DelayTime:create(0.5))
    for i,v in pairs(cityEffect) do
        table.insert(actionT,cc.DelayTime:create(0))
        local itemAction = cc.CallFunc:create(function()
            if v.effect ~= 0 and (not v.buildingId or v.buildingId <= 0) then
                local weather = resMgr:createCsbAction(v.effect,"animation0",true, nil, onFrameEvent)
                if v.posX ~= 0 then weather:setPositionX(v.posX) end
                if v.posY ~= 0 then weather:setPositionY(v.posY) end
                self:getScrollViewLayer(v.parent):addChild(weather)
                if i == 11 then
                    self.m_statue_pull_node = weather
                end
            elseif self:getTouchMgr():getBuildingNodeBy(v.buildingId) then
                local weather = resMgr:createCsbAction(v.effect,"animation0",true, nil, onFrameEvent)
                if v.posX ~= 0 then weather:setPositionX(v.posX) end
                if v.posY ~= 0 then weather:setPositionY(v.posY) end
                self:getScrollViewLayer(v.parent):addChild(weather)
            end
        end)
        table.insert(actionT,itemAction)
    end
    self:runAction(cc.Sequence:create(actionT))
end

function UICityPanel:createBuildingById(id)
    local building = global.cityData:getBuildingById(id)

    local buildingItem = self:buildingCreate(building)
    return buildingItem
end

function UICityPanel:buildingCreate(data)
    local buildingItem = nil
    if data.buildingType == WDEFINE.CITY.BUILDING_TYPE.FARM then
        buildingItem = require("game.UI.city.buildings.Farm").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.LOGGING then
        buildingItem = require("game.UI.city.buildings.Farm").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.STONE then
        buildingItem = require("game.UI.city.buildings.Farm").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.GOLD then
        buildingItem = require("game.UI.city.buildings.Farm").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.CAMP then
        buildingItem = require("game.UI.city.buildings.Camp").new()
    elseif data.buildingType >= WDEFINE.CITY.BUILDING_TYPE.HORSE and data.buildingType <= WDEFINE.CITY.BUILDING_TYPE.TANK then
        buildingItem = require("game.UI.city.buildings.Camp").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.WALL then
        buildingItem = require("game.UI.city.buildings.Camp").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.SPY then
        buildingItem = require("game.UI.city.buildings.Camp").new()
    elseif data.buildingType == WDEFINE.CITY.BUILDING_TYPE.RACE then
        local buildingId = data.buildingType+1000*global.userData:getRace()
        if data.id == buildingId then
            buildingItem = BuidingItem.new()
        else
            return
        end
    else
        buildingItem = BuidingItem.new()
    end
    if buildingItem.__cname == "Farm" and cc.UserDefault:getInstance():getBoolForKey("debug_remove_all_res_building",false) then
        return
    end

    buildingItem:setData(data)
    self:getScrollViewLayer("buildings"):addChild(buildingItem,data.posZ)
    self.touchMgr:registerTouch(buildingItem)
    return buildingItem
end

function UICityPanel:createBuildListPanel()
    self.buildListPanel = BuildListPanel.new()
    self:addChild(self.buildListPanel)
    self.buildListPanel:setVisible(false)
end

function UICityPanel:createBuilderList()
    local queueData = cityData:getBuilders()
    for id,data in ipairs(queueData) do
        if data.unlockCost and #data.unlockCost <= 0 then
            self["builder"..id]:setOpened(true)
        else
            self["builder"..id]:setOpened(false)
        end
        self["builder"..id]:setData(data)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICityPanel:unLockLvUpHandler(sender, eventType)
    
    local curCityLv = global.cityData:getBuildingById(1).serverData.lGrade
    local nextLvData = self:checkNextLvLock()
    local unLockData = global.luaCfg:get_city_lvup_by(curCityLv)
    global.panelMgr:openPanel("UIUnLockFunPanel"):setData(unLockData, curCityLv, nextLvData)
end

function UICityPanel:click_seven_day(sender, eventType)

    local data = global.ActivityData:getActivityById(19001)

    if not data.serverdata then return end 
    
    global.ActivityData:gotoActivityPanelById(19001)
    
end

--CALLBACKS_FUNCS_END

function UICityPanel:showBuildListPanel()

    self:checkUnionRedBag(true)
    global.g_cityView:getOperateMgr():removeOpeBtnWidget(true)
    if self.buildListPanel:isVisible() then return end

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_build_open")

    self.buildListPanel:setVisible(true)
    -- self.buildListPanel:setTouchState(false)
    local nodeTimeLine = resMgr:createTimeline("city/build_ui")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        -- body
        -- self.buildListPanel:setTouchState(true)
        -- self.buildListPanel:setVisible(true)
        gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_ACTION_STEP)
        self.m_buildlistTimeline = nil
    end)
    self:runAction(nodeTimeLine)
    self.m_buildlistTimeline = nodeTimeLine

    self:setUIVisible(false)
    self.buildListPanel:onEnter()
   
end

function UICityPanel:hideBuildListPanel(isShowUI)
    
    if not self.buildListPanel or not self.buildListPanel:isVisible() then return end

    local isShowUI = (isShowUI == nil and true or false)
    if not isShowUI then
        --在list面板切到建造面板时不需要过度动画
        self.buildListPanel:setVisible(false)
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_build_colse")
    end
    self.buildListPanel:setTouchState(false)
    local nodeTimeLine = resMgr:createTimeline("city/build_ui")
    nodeTimeLine:play("animation1", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        -- body
        self.buildListPanel:setTouchState(true)
        self.buildListPanel:setVisible(false)
        self:setUIVisible(isShowUI)
        self:checkUnionRedBag()
    end)
    if self.m_buildlistTimeline then
        self:stopAction(self.m_buildlistTimeline)
    end
    self:runAction(nodeTimeLine)

end

function UICityPanel:setUIVisible(i_isVisible)
    self.panel_ui:setVisible(i_isVisible)
    self.top_ui:setVisible(i_isVisible)
    self.bot_ui:setVisible(i_isVisible)
    self.taskJumpBoard:setVisible(i_isVisible)
end

function UICityPanel:isUIVisible()
   return self.panel_ui:isVisible() and self.top_ui:isVisible() and self.bot_ui:isVisible()
end

function UICityPanel:getScrollView()
    return self.m_scrollView
end

--获取滚动容器内的对应层级节点
function UICityPanel:getScrollViewLayer(i_layerName)

    if tolua.isnull(self.m_scrollView) then return nil end
    if i_layerName and self.m_scrollView:getContainer()[i_layerName] then
        return self.m_scrollView:getContainer()[i_layerName]
    end
    return nil
end

function UICityPanel:getBuildListPanel()
    return self.buildListPanel
end

function UICityPanel:getCamera()
    return self.camera
end

function UICityPanel:getOperateMgr()
    return self.operateMgr
end

function UICityPanel:getTouchMgr()
    return self.touchMgr
end

function UICityPanel:getSoldierMgr()
    return self.soldierMgr
end

function UICityPanel:getBossMgr()
    return self.bossMgr
end

function UICityPanel:getPetMgr()
    return self.petMgr
end

function UICityPanel:stopLastSoundEffect(currsound)
    if self.m_lastSoundEffect then
        gsound.stopEffect(self.m_lastSoundEffect)
    end
    self.m_lastSoundEffect = currsound
end

function UICityPanel:getBuilderById(id)
    return self["builder"..id]
end

function UICityPanel:getFreeBuilder(id)
    local freeBuilder = nil
    if id then return self["builder"..id] end
    for i = 1,3 do
        if self["builder"..i]:checkIdle() then
            freeBuilder = self["builder"..i]
            break
        end
    end
    return freeBuilder
end

function UICityPanel:getPlusFreeBuilder(id)
    local freeBuilder = nil
    if id then return self["builder"..id] end
    for i = 1,3 do
        if self["builder"..i]:checkIdleAndFree() then
            freeBuilder = self["builder"..i]
            break
        end
    end
    return freeBuilder
end

function UICityPanel:checkThirdBuildLocked()
    local builder = self:getFreeBuilder()
    if not builder then
        return self.builder3:getOpened()
    else
        return true
    end 
end

-----------------------------------内城工具类--------------------------------------
--屏幕坐标转换为滚动容器坐标
function UICityPanel:convertToSVSpace(touchPos)
    local offsetPos = self.m_scrollView:getContentOffset()
    local scrollScale = self.m_scrollView:getZoomScale()
    local originX = -offsetPos.x
    local originY = -offsetPos.y
    local dstPos = cc.p(originX+touchPos.x,originY+touchPos.y)
    dstPos.x = dstPos.x/scrollScale
    dstPos.y = dstPos.y/scrollScale
    log.debug("#####offsetPos=%s,dstPos=%s,touchPos=%s",vardump(offsetPos),vardump(dstPos),vardump(touchPos))
    return dstPos
end

--获取建筑的屏幕坐标
function UICityPanel:isBuildingInScreen(building)
    local buildingRect = building:getTouchRect(true)

    local offsetPos = self.m_scrollView:getContentOffset()
    local scrollScale = self.m_scrollView:getZoomScale()
    local ret = CCHgame:isRectIntersectRect(buildingRect,offsetPos,scrollScale)
    return ret
end

function UICityPanel:isEffectInScreen(effectNode)
    local buildingRect = effectNode.rect:getBoundingBox()

    local offsetPos = self.m_scrollView:getContentOffset()
    local scrollScale = self.m_scrollView:getZoomScale()
    local ret = CCHgame:isRectIntersectRect(buildingRect,offsetPos,scrollScale)
    return ret
end


return UICityPanel

--endregion

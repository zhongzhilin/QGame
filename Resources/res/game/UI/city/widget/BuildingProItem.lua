--region BuildingProItem.lua
--Author : wuwx
--Date   : 2016/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = luaCfg.cityData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildingProItem  = class("BuildingProItem", function() return gdisplay.newWidget() end )

function BuildingProItem:ctor()
    self:CreateUI()
end

function BuildingProItem:CreateUI()
    local root = resMgr:createWidget("city/build_lvup_require")
    self:initUI(root)
end

function BuildingProItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_lvup_require")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.intro = self.root.Node_1.intro_export
    self.icon = self.root.Node_1.icon_export
    self.state = self.root.Node_1.state_export
    self.rest_time = self.root.Node_1.rest_time_export
    self.btn_operate = self.root.Node_1.btn_operate_export
    self.go = self.root.Node_1.btn_operate_export.go_export
    self.rgb_2 = self.root.Node_1.rgb_2_export
    self.rgb_1 = self.root.Node_1.rgb_1_export
    self.operate = self.root.Node_1.operate_export
    self.freeEffect = self.root.Node_1.operate_export.freeEffect_export
    self.effect_node = self.root.effect_node_export

    uiMgr:addWidgetTouchHandler(self.btn_operate, function(sender, eventType) self:onOperateHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.operate:setSwallowTouches(false)
    global.funcGame:initBigNumber(self.intro)
end

function BuildingProItem:onEnter()
    local nodeTimeLine = resMgr:createTimeline("city/build_lvup_require")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

--{icon = triggerData.iconName..".png",content = triggerStr, isEnough = isEnough }
function BuildingProItem:setData(data, isBuilder)

    self.btn_operate:setVisible(true)
    self.freeEffect:setVisible(false)
    self.effect_node:removeAllChildren()
    self.isFree = 0
    self.isBuilder = isBuilder
    
    if isBuilder then

        self.icon:setScale(0.6)
        self.icon:setSpriteFrame("ui_surface_icon/mainui_build_time.png")
        self.intro:setString(luaCfg:get_local_string(10481))
        self.rest_time:setVisible(true)
        self.state:setVisible(false)
        self.btn_operate:setVisible(true)
        self:checkTime()
    else

        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        
        self.data = data
        self.state:setVisible(true)
        self.rest_time:setVisible(false)
        self.icon:setScale(1)
        self.go:setString(luaCfg:get_local_string(10014))
    	if data.icon then
    		self.icon:setVisible(true)
    		self.icon:setSpriteFrame(data.icon)
    	else
    		self.icon:setVisible(false)
    	end
    	self.intro:setString(data.content or "")
    	if data.isEnough then
    		self.state:setSpriteFrame("ui_surface_icon/check_box_checked.png")
            self.btn_operate:setVisible(false)
            self.freeEffect:setVisible(false)
            self.intro:setTextColor(gdisplay.COLOR_TEXT_BROWN)
    	else
    		self.state:setSpriteFrame("ui_surface_icon/check_box.png")
            self.btn_operate:setVisible(true)
            self.intro:setTextColor(gdisplay.COLOR_RED)
    	end

        if data.isNoFirstNode then
            self.go:setString(luaCfg:get_local_string(10308))
        end

    end

end

function BuildingProItem:getData()
    return self.data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function BuildingProItem:checkTime()

    local queue = self:getShortQueue()

    if queue then 

        self.curQueue = queue.serverData
        self.queue = queue

        self.m_totalTime = self.curQueue.lTotleTime
        if self.m_countDownTimer then
        else
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        self:countDownHandler()
    end 
    
end

function BuildingProItem:getShortQueue()
    
    local queueData = global.cityData:getBuilders()
    local curShort = {}

    for id,data in ipairs(queueData) do
        if data.serverData.lRestTime and data.serverData.lRestTime > 0 then
           table.insert(curShort, data)
        end
    end

    table.sort(curShort, function(s1, s2) return s1.serverData.lStartTime + s1.serverData.lRestTime < s2.serverData.lStartTime + s2.serverData.lRestTime end )
    return curShort[1]

end

function BuildingProItem:countDownHandler(dt)

    if not self.curQueue then return end -- 容错处理。

    local curServerTime = global.dataMgr:getServerTime()
    if self.curQueue.lRestTime <= 0 then
        self.m_restTime = math.floor(self.curQueue.lRestTime)
    else
        self.m_restTime = math.floor(self.curQueue.lRestTime - (curServerTime-self.curQueue.lStartTime))
    end

    if self.m_restTime <= 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end

        local builder = global.g_cityView:getBuilderById(self.queue.queueId)
        builder:buildOver()

        gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH)
        return
        
    end
    self.rest_time:setString(global.funcGame.formatTimeToHMS(self.m_restTime))

    -- 检测是否可以免费 
    if self.m_restTime <= global.cityData:getFreeBuildTime() then
        self.go:setString(luaCfg:get_local_string(10390))
        self.isFree = 1
        if self.btn_operate:isVisible() then
            self.freeEffect:setVisible(true)
        end
    else
        self.go:setString(luaCfg:get_local_string(10028))
        self.isFree = 2
        
        if self.btn_operate:isVisible() then
            self.freeEffect:setVisible(true)
        end            
    end
end

function BuildingProItem:onExit()
    -- body
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function BuildingProItem:showFreeEffect()
    -- body
    gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH, true) -- 先刷新按钮
    self.btn_operate:setVisible(false)
    self.freeEffect:setVisible(false)
    self.effect_node:removeAllChildren()
    local node = resMgr:createCsbAction("effect/icon_free","animation0",false,true, nil, function ()
        gevent:call(global.gameEvent.EV_ON_UI_BUILD_FLUSH)   -- 免费动画播放结束后再刷新界面
    end)
    self.effect_node:addChild(node)
end

function BuildingProItem:onOperateHandler(sender, eventType)
    
    if not self.btn_operate:isVisible() then 
        return 
    end 

    if self.isBuilder then

        local builder = global.g_cityView:getBuilderById(self.queue.queueId)
        builder:stateCall(handler(self, self.showFreeEffect))
    else

        if self.data and self.data.isNoFirstNode then -- protect 

            local getPanel = global.panelMgr:openPanel("UIResGetPanel")
            getPanel:setData(global.resData:getResById(self.data.triggerData.itemId), true)
        else
            local funcGame = global.funcGame
            local panelMgr = global.panelMgr
            local cityView = global.g_cityView
            local cityCamera = cityView:getCamera()
            local panel = panelMgr:getPanel(panelMgr:getTopPanelName())
            cityCamera:setNoScaleModel(true)
            if panel.onCloseHandler then panel:onCloseHandler() end

            local buildedNum = 0
            local cityTouchMgr = cityView:getTouchMgr()
            for i,i_building in ipairs(cityTouchMgr.registerBuildings) do
                if self.data and i_building:getData().buildingType == self.data.triggerData.buildsId then
                    buildedNum = buildedNum + 1
                end
            end

            if buildedNum == 0 or  self.data.triggerData.triggerCondition == 1 then
                funcGame.gpsBuildPanel(self.data.triggerData.buildsId)
            else
                cityView:setNoCheckScreen(false)
                funcGame.gpsCityBuildingAndPopUpgradePanel(self.data.triggerData.buildsId,true)
            end
        end

    end
   
end
--CALLBACKS_FUNCS_END

return BuildingProItem

--endregion

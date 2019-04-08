--region UIGetChannelPanel.lua
--Author : yyt
--Date   : 2017/09/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGetChannelPanel  = class("UIGetChannelPanel", function() return gdisplay.newWidget() end )

function UIGetChannelPanel:ctor()
    self:CreateUI()
end

function UIGetChannelPanel:CreateUI()
    local root = resMgr:createWidget("common/common_buy_bg")
    self:initUI(root)
end

function UIGetChannelPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_buy_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.info = self.root.Node_export.info_export
    self.go = self.root.Node_export.go_btn.go_mlan_6_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.go_btn, function(sender, eventType) self:goHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- data = {titleId = 10851, target=1, param={}}
function UIGetChannelPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.onCloseHandler then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.onCloseHandler then
            self:onCloseHandler()
        end
    end)

end

function UIGetChannelPanel:setData(data)

    self.data = data
    if data.isnottitleId then
        self.info:setString(data.titleId)
    else
        self.info:setString(global.luaCfg:get_local_string(data.titleId))
    end

    self.Node:setScaleY(0)
    self.Node:setVisible(true)  
    self.Node:stopAllActions()
    self.Node:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.45,1,1)))

    -- 倒计时
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end  
    self.cutTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimerHandler), 5)

    global.tools:adjustNodePosForFather(self.go,  self.go.Image_1)

end

function UIGetChannelPanel:cutTimerHandler()

    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
    self:onCloseHandler()
end

function UIGetChannelPanel:onCloseHandler(sender, eventType)
    if not tolua.isnull(self.Node) then
        self.Node:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create(), cc.CallFunc:create(function ()
            global.panelMgr:closePanel("UIGetChannelPanel")
        end)))
    end
end

function UIGetChannelPanel:onExit()
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
end

function UIGetChannelPanel:goHandler(sender, eventType)

    if not self.data then return end
    global.panelMgr:closePanel("UIGetChannelPanel")

    if self.data.target == 1 then

        local getPanel = global.panelMgr:openPanel("UIResGetPanel")
        getPanel:setData(global.resData:getResById(self.data.param[1]), true)

    elseif self.data.target == 2 then

        local buildingData = global.cityData:getBuildingById(4)
        global.panelMgr:openPanel("UISoldierSourcePanel"):setData(buildingData)

    elseif self.data.target == 3 then

        global.panelMgr:openPanel("UIBuyShopPanel"):setShopID(11701)
    elseif self.data.target == 4 then

        global.UIRechargeListOffset = nil
        global.panelMgr:openPanel("UIActivityPackagePanel")
    elseif self.data.target == 5 then
        
        global.panelMgr:openPanel("UIMonthCardPanel"):setData()
    elseif self.data.target == 6 then
        
        if self.data.callback then
            self.data.callback()
        end
    elseif self.data.target == 7 then
        global.panelMgr:closePanelExecptDown()
        global.funcGame.handleQuickTask(1,18,30)
    end

end
--CALLBACKS_FUNCS_END

return UIGetChannelPanel

--endregion

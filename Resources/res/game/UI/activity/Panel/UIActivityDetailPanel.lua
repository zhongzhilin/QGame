--region UIActivityDetailPanel.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityDetailNode = require("game.UI.activity.FramNode.UIActivityDetailNode")
--REQUIRE_CLASS_END

local UIActivityDetailPanel  = class("UIActivityDetailPanel", function() return gdisplay.newWidget() end )

function UIActivityDetailPanel:ctor()
    self:CreateUI()
end

function UIActivityDetailPanel:CreateUI()
    local root = resMgr:createWidget("activity/activity_detail_node_panel")
    self:initUI(root)
end

function UIActivityDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_detail_node_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Node = UIActivityDetailNode.new()
    uiMgr:configNestClass(self.Node, self.root.Node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:Close_detail_panel(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIActivityDetailPanel:onEnter()
    
end 

function UIActivityDetailPanel:setData(data)
     self.Node:setData(data)
end 

function UIActivityDetailPanel:Close_detail_panel(sender, eventType)
    global.panelMgr:closePanelForBtn("UIActivityDetailPanel")  
end
--CALLBACKS_FUNCS_END

return UIActivityDetailPanel

--endregion

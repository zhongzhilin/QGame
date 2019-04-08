--region UIActivityRulePanel.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityRuleNode = require("game.UI.activity.Node.UIActivityRuleNode")
--REQUIRE_CLASS_END

local UIActivityRulePanel  = class("UIActivityRulePanel", function() return gdisplay.newWidget() end )

function UIActivityRulePanel:ctor()
    self:CreateUI()
end

function UIActivityRulePanel:CreateUI()
    local root = resMgr:createWidget("activity/point_rule_panel")
    self:initUI(root)
end

function UIActivityRulePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_rule_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = UIActivityRuleNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END
end

-- 
function UIActivityRulePanel:onEnter()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIActivityRulePanel:setData(data)
    self.data = data
    if not self.data then return end 
    self:updateUI()
end

function UIActivityRulePanel:updateUI()
    self.FileNode_1:setData(self.data)
end 


function UIActivityRulePanel:close_panel(sender, eventType)
    global.panelMgr:closePanel("UIActivityRulePanel")
end
--CALLBACKS_FUNCS_END

return UIActivityRulePanel

--endregion

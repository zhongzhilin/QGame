--region UISoldierRelation.lua
--Author : yyt
--Date   : 2017/09/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UISoldierRelation  = class("UISoldierRelation", function() return gdisplay.newWidget() end )

function UISoldierRelation:ctor()
    self:CreateUI()
end

function UISoldierRelation:CreateUI()
    local root = resMgr:createWidget("world/info/soldier_relation_info")
    self:initUI(root)
end

function UISoldierRelation:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/soldier_relation_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_bg, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
    self.close_node:setData(function()
        self:exit_call()
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISoldierRelation:exit_call(sender, eventType)
    global.panelMgr:closePanel("UISoldierRelation")
end
--CALLBACKS_FUNCS_END

return UISoldierRelation

--endregion

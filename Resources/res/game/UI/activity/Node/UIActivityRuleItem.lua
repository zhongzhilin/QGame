--region UIActivityRuleItem.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityRuleItem  = class("UIActivityRuleItem", function() return gdisplay.newWidget() end )

function UIActivityRuleItem:ctor()
    self:CreateUI()
end

function UIActivityRuleItem:CreateUI()
    local root = resMgr:createWidget("activity/point_rule_item")
    self:initUI(root)
end

function UIActivityRuleItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_rule_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.point_rule = self.root.point_rule.point_rule_export
    self.point = self.root.point_rule.point_export

--EXPORT_NODE_END
end

-- -print] -     28 = {
-- [LUA-print] -         "acitivity_id" = 14001
-- [LUA-print] -         "id"           = 1
-- [LUA-print] -         "point"        = 100
-- [LUA-print] -         "rule_name"    = "1级怪物"
-- [LUA-print] -     }
-- [LUA-print] -     29 = {
-- [LUA-print] -         "acitivity_id" = 14001
-- [LUA-print] -         "id"           = 19
-- [LUA-print] -         "point"        = 1900
-- [LUA-print] -         "rule_name"    = "19级怪物"
-- [LUA-print] -     }

function UIActivityRuleItem:setData(data)
    self.data = data 
    if not self.data then return end 
    self:updateUI()
end 

function UIActivityRuleItem:updateUI()
    self.point_rule:setString(  self.data.rule_name)
    self.point:setString(  self.data.point)
end 

function UIActivityRuleItem:onExit()

end 

 
function UIActivityRuleItem:onEnter()

end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIActivityRuleItem

--endregion

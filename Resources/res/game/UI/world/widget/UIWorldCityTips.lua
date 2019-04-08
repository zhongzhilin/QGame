--region UIWorldCityTips.lua
--Author : yyt
--Date   : 2018/11/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldCityTips  = class("UIWorldCityTips", function() return gdisplay.newWidget() end )

function UIWorldCityTips:ctor()
    self:CreateUI()
end

function UIWorldCityTips:CreateUI()
    local root = resMgr:createWidget("world/worldCity_tips")
    self:initUI(root)
end

function UIWorldCityTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/worldCity_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tips_node = self.root.tips_node_export
    self.tips_str = self.root.tips_node_export.tips_str_export

--EXPORT_NODE_END
	self.tips_node:setCascadeColorEnabled(false)
	uiMgr:initScrollText(self.tips_str)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldCityTips:setData(data)
	-- body
	self.tips_str:setString(data.str or "-")
	self.tips_node:setColor(data.color or cc.c3b(255,255,255))
end

--CALLBACKS_FUNCS_END

return UIWorldCityTips

--endregion

--region UIUpPowerItem.lua
--Author : yyt
--Date   : 2017/09/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUpPowerItem  = class("UIUpPowerItem", function() return gdisplay.newWidget() end )

function UIUpPowerItem:ctor()
   self:CreateUI()
end

function UIUpPowerItem:CreateUI()
    local root = resMgr:createWidget("city/build_lvup_tips_item")
    self:initUI(root)
end

function UIUpPowerItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_lvup_tips_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.Node_1.name_export
    self.value = self.root.Node_1.value_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUpPowerItem:setData(data)

	self.name:setString(data[1])
	self.value:setString(data[2])

end

--CALLBACKS_FUNCS_END

return UIUpPowerItem

--endregion

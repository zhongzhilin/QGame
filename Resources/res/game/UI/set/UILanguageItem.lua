--region UILanguageItem.lua
--Author : yyt
--Date   : 2017/03/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILanguageItem  = class("UILanguageItem", function() return gdisplay.newWidget() end )

function UILanguageItem:ctor()
    self:CreateUI()
end

function UILanguageItem:CreateUI()
    local root = resMgr:createWidget("settings/settings_language_node")
    self:initUI(root)
end

function UILanguageItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_language_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.language_text = self.root.language_text_export
    self.checked = self.root.checked_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILanguageItem:setData(data)

	self.language_text:setString(data.name)
	self.checked:setVisible(data.selectState == 1)
end

--CALLBACKS_FUNCS_END

return UILanguageItem

--endregion

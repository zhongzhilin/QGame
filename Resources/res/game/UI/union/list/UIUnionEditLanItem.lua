--region UIUnionEditLanItem.lua
--Author : wuwx
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionEditLanItem  = class("UIUnionEditLanItem", function() return gdisplay.newWidget() end )

function UIUnionEditLanItem:ctor()
    self:CreateUI()
end

function UIUnionEditLanItem:CreateUI()
    local root = resMgr:createWidget("union/union_language_list")
    self:initUI(root)
end

function UIUnionEditLanItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_language_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.node.bg_export
    self.text = self.root.node.text_export
    self.yes = self.root.node.yes_export

--EXPORT_NODE_END
end

function UIUnionEditLanItem:setData(data)
    self.data = data

    self.yes:setVisible(self.data.isSelected)
    self.bg:setVisible(self.data.id%2~=0)
    self.text:setString(self.data.name)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionEditLanItem

--endregion

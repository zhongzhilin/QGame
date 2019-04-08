--region UIDeveloperItem.lua
--Author : anlitop
--Date   : 2017/03/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDeveloperItem  = class("UIDeveloperItem", function() return gdisplay.newWidget() end )

function UIDeveloperItem:ctor()
    self:CreateUI()
end

function UIDeveloperItem:CreateUI()
    local root = resMgr:createWidget("settings/developeritem")
    self:initUI(root)
end

function UIDeveloperItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/developeritem")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.developer_item = self.root.developer_item_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIDeveloperItem

--endregion

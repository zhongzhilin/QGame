--region DownListItem.lua
--Author : yyt
--Date   : 2016/09/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local DownListItem  = class("DownListItem", function() return gdisplay.newWidget() end )

function DownListItem:ctor()
    
end

function DownListItem:CreateUI()
    local root = resMgr:createWidget("common/common_downlist_node")
    self:initUI(root)
end

function DownListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_downlist_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return DownListItem

--endregion

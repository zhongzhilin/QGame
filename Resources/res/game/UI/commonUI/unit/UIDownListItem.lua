--region UIDownListItem.lua
--Author : yyt
--Date   : 2016/09/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDownListItem  = class("UIDownListItem", function() return gdisplay.newWidget() end )

function UIDownListItem:ctor()
    self:CreateUI()
end

function UIDownListItem:CreateUI()
    local root = resMgr:createWidget("common/common_downlist_node")
    self:initUI(root)
end

function UIDownListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_downlist_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.item, function(sender, eventType) self:item_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDownListItem:setData( data )
	
end

function UIDownListItem:item_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIDownListItem

--endregion

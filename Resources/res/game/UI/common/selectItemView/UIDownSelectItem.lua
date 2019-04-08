--region UIDownSelectItem.lua
--Author : wuwx
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDownSelectItem  = class("UIDownSelectItem", function() return gdisplay.newWidget() end )

function UIDownSelectItem:ctor(csbPath)
    self:CreateUI(csbPath)
end

function UIDownSelectItem:CreateUI(csbPath)
    local root = resMgr:createWidget(csbPath)
    self:initUI(root,csbPath)
end

function UIDownSelectItem:initUI(root,csbPath)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, csbPath)
end

function UIDownSelectItem:setData(data)
    self.data = data
    -- self.icon:setSpriteFrame(data.flag)
end

return UIDownSelectItem

--endregion

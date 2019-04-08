--region UIHeroGarrisionDescItem.lua
--Author : untory
--Date   : 2017/04/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroGarrisionDescItem  = class("UIHeroGarrisionDescItem", function() return gdisplay.newWidget() end )

function UIHeroGarrisionDescItem:ctor()
    
    self:CreateUI()
end

function UIHeroGarrisionDescItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_garrison_text")
    self:initUI(root)
end

function UIHeroGarrisionDescItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_garrison_text")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.buff_add = self.root.buff_add_export
    self.buff = self.root.buff_export

--EXPORT_NODE_END
end

function UIHeroGarrisionDescItem:setData(data)
	
	self.buff_add:setString("+" .. data.num)
	self.buff:setString(data.desc)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIHeroGarrisionDescItem

--endregion

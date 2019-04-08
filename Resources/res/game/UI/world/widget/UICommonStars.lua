--region UICommonStars.lua
--Author : Untory
--Date   : 2018/02/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICommonStars  = class("UICommonStars", function() return gdisplay.newWidget() end )

function UICommonStars:ctor(isCreateUI)
    if isCreateUI then
    	self:CreateUI()
    end
end

function UICommonStars:CreateUI()
    local root = resMgr:createWidget("hero/miracle_stars")
    self:initUI(root)
end

function UICommonStars:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/miracle_stars")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.gray_bg = self.root.gray_bg_export
    self.loading_bar = self.root.loading_bar_export

--EXPORT_NODE_END
end

function UICommonStars:setData(stars,isHideBg)
	stars = stars or 1
	self.loading_bar:setPercent(stars / 10 * 100)
	self.gray_bg:setVisible(not isHideBg)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UICommonStars

--endregion

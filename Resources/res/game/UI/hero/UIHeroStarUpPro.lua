--region UIHeroStarUpPro.lua
--Author : Untory
--Date   : 2017/11/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local TextScrollControl = require("game.UI.common.UITextScrollControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroStarUpPro  = class("UIHeroStarUpPro", function() return gdisplay.newWidget() end )

function UIHeroStarUpPro:ctor()
    
end

function UIHeroStarUpPro:CreateUI()
    local root = resMgr:createWidget("hero/hero_star_up_pro")
    self:initUI(root)
end

function UIHeroStarUpPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_star_up_pro")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro = self.root.pro_export
    self.pro_num = self.root.pro_export.pro_num_export
    self.pro_next = self.root.pro_next_export
    self.pro_num_next = self.root.pro_next_export.pro_num_next_export

--EXPORT_NODE_END
end

function UIHeroStarUpPro:setData(name,num1,num2)
    
    self:setVisible(true)
    self.pro:setString(name)
    self.pro_num:setString(num1)
    self.pro_next:setString(name)
    self.pro_num_next:setString(num2)


    global.tools:adjustNodePosForFather(self.pro_num:getParent(),self.pro_num,20)
    global.tools:adjustNodePosForFather(self.pro_num_next:getParent(),self.pro_num_next,20)
    -- TextScrollControl.startScroll(self.pro_num_next,num2,1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIHeroStarUpPro

--endregion

--region UIHeroStarList.lua
--Author : Untory
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroStarList  = class("UIHeroStarList", function() return gdisplay.newWidget() end )

function UIHeroStarList:ctor()
    
end

function UIHeroStarList:CreateUI()
    local root = resMgr:createWidget("hero/hero_star_list")
    self:initUI(root)
end

function UIHeroStarList:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_star_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.xing1 = self.root.xing1_export
    self.xing2 = self.root.xing2_export
    self.xing3 = self.root.xing3_export
    self.xing4 = self.root.xing4_export
    self.xing5 = self.root.xing5_export
    self.xing6 = self.root.xing6_export

--EXPORT_NODE_END
end

function UIHeroStarList:setData(heroId,curStar)
    
    local hero_strengthen = luaCfg:get_hero_strengthen_by(heroId)

    if hero_strengthen then  

        local max = hero_strengthen.maxStep
        for i = 1,6 do
            local star = self['xing' .. i] 
            star:setVisible(i <= max)
            if curStar then 
                star:setSpriteFrame(i > curStar and 'hero_xingLVicon_hui.png' or 'hero_xingLVicon.png')
            end 
        end
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIHeroStarList

--endregion

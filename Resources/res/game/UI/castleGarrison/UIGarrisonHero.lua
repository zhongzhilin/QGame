--region UIGarrisonHero.lua
--Author : yyt
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonHero  = class("UIGarrisonHero", function() return gdisplay.newWidget() end )

function UIGarrisonHero:ctor()
    self:CreateUI()
end

function UIGarrisonHero:CreateUI()
    local root = resMgr:createWidget("castle_garrison/hero_list_node")
    self:initUI(root)
end

function UIGarrisonHero:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/hero_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_icon = self.root.Node_1.hero_icon_export
    self.hero_quality = self.root.Node_1.hero_quality_export
    self.hero_type = self.root.Node_1.hero_type_export
    self.hero_name = self.root.Node_1.hero_name_export
    self.hero_nameLv = self.root.Node_1.hero_nameLv_export
    self.recommend = self.root.Node_1.recommend_export
    self.garrison = self.root.Node_1.garrison_export
    self.right = self.root.Node_1.right_export
    self.left = self.root.Node_1.left_export
    self.select_bg = self.root.Node_1.select_bg_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonHero:setData(data)

    self.data = data
    self.select_bg:setVisible(data.isSelected == 1)
    local heroData = luaCfg:get_hero_property_by(data.lid)
    global.panelMgr:setTextureFor(self.hero_icon, heroData.nameIcon)
    self.hero_quality:setVisible(heroData.Strength == 3)
    self.garrison:setVisible(data.lstate == 2)
    self.recommend:setVisible(data.recommend == 1)
    self.hero_type:loadTexture(heroData.typeIcon, ccui.TextureResType.plistType)
    self.hero_name:setString(heroData.name)

    local lGrade = 0
    local heroSer = global.heroData:getHeroDataById(data.lid)
    if heroSer and heroSer.serverData then
        lGrade = heroSer.serverData.lGrade
    end
    self.hero_nameLv:setString(string.format(luaCfg:get_local_string(10019), lGrade))
    global.heroData:setHeroIconBg(data.lid, self.left, self.right)

end

--CALLBACKS_FUNCS_END

return UIGarrisonHero

--endregion

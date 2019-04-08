--region UIHeroGarrisonEffect.lua
--Author : anlitop
--Date   : 2017/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroGarrisonEffect  = class("UIHeroGarrisonEffect", function() return gdisplay.newWidget() end )

function UIHeroGarrisonEffect:ctor()
    
end

function UIHeroGarrisonEffect:CreateUI()
    local root = resMgr:createWidget("common/hero_garrison")
    self:initUI(root)
end

function UIHeroGarrisonEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/hero_garrison")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_icon = self.root.Sprite_1.layout.hero_icon_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UIHeroGarrisonEffect:onEnter()

   	self.root:stopAllActions()
    local nodeTimeLine =resMgr:createTimeline("common/hero_garrison")
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("sleep",true)

end 

function UIHeroGarrisonEffect:setData(data)

	self.data = data 

	local herodata = global.luaCfg:get_hero_property_by(self.data)

	if not herodata then return end

    global.panelMgr:setTextureFor(self.hero_icon,herodata.nameIcon)

end 

return UIHeroGarrisonEffect

--endregion

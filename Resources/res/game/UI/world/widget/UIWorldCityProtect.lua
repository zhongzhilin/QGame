--region UIWorldCityProtect.lua
--Author : yyt
--Date   : 2018/11/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldCityProtect  = class("UIWorldCityProtect", function() return gdisplay.newWidget() end )

function UIWorldCityProtect:ctor()
    self:CreateUI()
end

function UIWorldCityProtect:CreateUI()
    local root = resMgr:createWidget("effect/bigworld_zao")
    self:initUI(root)
end

function UIWorldCityProtect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/bigworld_zao")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg1 = self.root.bg1_export
    self.bg2 = self.root.bg2_export
    self.sp = self.root.sp_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldCityProtect:onEnter()

	self.root:stopAllActions()
	local nodeTimeLine = resMgr:createTimeline("effect/bigworld_zao")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)
end

function UIWorldCityProtect:setState1()

	self.sp:setColor(cc.c3b(255,150,69))
	self.bg1:setColor(cc.c3b(255,255,255))
	self.bg2:setColor(cc.c3b(255,255,255))
	self.bg1:setSpriteFrame("bigworld_zao_rad_00000.png")
	self.bg2:setSpriteFrame("bigworld_zao_rad_00000.png")

end

function UIWorldCityProtect:setState2()

	self.sp:setColor(cc.c3b(119,193,255))
	self.bg1:setColor(cc.c3b(102,187,255))
	self.bg2:setColor(cc.c3b(162,183,255))
	self.bg1:setSpriteFrame("bigworld_zao_00000.png")
	self.bg2:setSpriteFrame("bigworld_zao_00000.png")

end

--CALLBACKS_FUNCS_END

return UIWorldCityProtect

--endregion

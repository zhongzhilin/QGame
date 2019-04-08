--region UIWorldCityProtect1.lua
--Author : yyt
--Date   : 2018/11/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldCityProtect1  = class("UIWorldCityProtect1", function() return gdisplay.newWidget() end )

function UIWorldCityProtect1:ctor()
    self:CreateUI()
end

function UIWorldCityProtect1:CreateUI()
    local root = resMgr:createWidget("effect/bigworld_zao2")
    self:initUI(root)
end

function UIWorldCityProtect1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/bigworld_zao2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg1 = self.root.bg1_export
    self.bg2 = self.root.bg2_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldCityProtect1:setState1()
	-- body
	self.bg1:setColor(cc.c3b(255,35,35))
	self.bg2:setColor(cc.c3b(255,35,35))
end

function UIWorldCityProtect1:setState2()
	-- body
	self.bg1:setColor(cc.c3b(145,205,255))
	self.bg2:setColor(cc.c3b(145,205,255))
end

--CALLBACKS_FUNCS_END

return UIWorldCityProtect1

--endregion

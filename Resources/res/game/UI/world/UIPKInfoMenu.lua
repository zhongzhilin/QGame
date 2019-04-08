--region UIPKInfoMenu.lua
--Author : yyt
--Date   : 2017/04/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPKInfoMenu  = class("UIPKInfoMenu", function() return gdisplay.newWidget() end )

function UIPKInfoMenu:ctor()
    self:CreateUI()
end

function UIPKInfoMenu:CreateUI()
    local root = resMgr:createWidget("world/info/city_pk_menu1")
    self:initUI(root)
end

function UIPKInfoMenu:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/city_pk_menu1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.recruit_title.title_export
    self.scale = self.root.recruit_title.scale_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPKInfoMenu:setData(lType)
	
	if lType == 1 then
		self.title:setString(global.luaCfg:get_local_string(10562))
        self.title:setTextColor(cc.c3b(180,29,11))
	else
		self.title:setString(global.luaCfg:get_local_string(10563))
        self.title:setTextColor(cc.c3b(36,108,198))
	end

end

--CALLBACKS_FUNCS_END

return UIPKInfoMenu

--endregion

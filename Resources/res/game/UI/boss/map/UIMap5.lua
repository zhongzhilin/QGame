--region UIMap5.lua
--Author : yyt
--Date   : 2017/12/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMap5  = class("UIMap5", function() return gdisplay.newWidget() end )

function UIMap5:ctor()
    self:CreateUI()
end

function UIMap5:CreateUI()
    local root = resMgr:createWidget("boss/boss_list5")
    self:initUI(root)
end

function UIMap5:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_list5")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMap5

--endregion

--region UIMap1.lua
--Author : yyt
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMap1  = class("UIMap1", function() return gdisplay.newWidget() end )

function UIMap1:ctor()
    self:CreateUI()
end

function UIMap1:CreateUI()
    local root = resMgr:createWidget("boss/boss_list1")
    self:initUI(root)
end

function UIMap1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_list1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMap1

--endregion

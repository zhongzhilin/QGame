--region UICollectLine.lua
--Author : Untory
--Date   : 2017/12/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICollectLine  = class("UICollectLine", function() return gdisplay.newWidget() end )

function UICollectLine:ctor()
    
end

function UICollectLine:CreateUI()
    local root = resMgr:createWidget("animation/caiji_budui")
    self:initUI(root)
end

function UICollectLine:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "animation/caiji_budui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UICollectLine

--endregion

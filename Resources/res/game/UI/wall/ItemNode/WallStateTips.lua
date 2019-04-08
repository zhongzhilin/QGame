--region WallStateTips.lua
--Author : yyt
--Date   : 2016/10/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local WallStateTips  = class("WallStateTips", function() return gdisplay.newWidget() end )

function WallStateTips:ctor()
    
end

function WallStateTips:CreateUI()
    local root = resMgr:createWidget("wall/wall_textbox")
    self:initUI(root)
end

function WallStateTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_textbox")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.recover_time = self.root.Image_1.recover_time_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return WallStateTips

--endregion

--region DayItem.lua
--Author : anlitop
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local DayItem  = class("DayItem", function() return gdisplay.newWidget() end )

function DayItem:ctor()
    self:CreateUI()
end

function DayItem:CreateUI()
    local root = resMgr:createWidget("fund/recharge_daily_day")
    self:initUI(root)
end

function DayItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "fund/recharge_daily_day")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button = self.root.Button_export
    self.bg2 = self.root.Button_export.bg2_export
    self.bg1 = self.root.Button_export.bg1_export
    self.day = self.root.Button_export.day_export
    self.finish = self.root.Button_export.finish_export
    self.recharge = self.root.Button_export.recharge_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return DayItem

--endregion

--region UIActivityBossItem.lua
--Author : zzl
--Date   : 2017/12/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityBossItem  = class("UIActivityBossItem", function() return gdisplay.newWidget() end )

function UIActivityBossItem:ctor()
    
end

function UIActivityBossItem:CreateUI()
    local root = resMgr:createWidget("activity/activity_world_boss/activity_world_boss_lv")
    self:initUI(root)
end

function UIActivityBossItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_world_boss/activity_world_boss_lv")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.two = self.root.Button_1.two_export
    self.icon3 = self.root.Button_1.two_export.icon3_export
    self.two_number = self.root.Button_1.two_export.two_number_export
    self.noe = self.root.Button_1.noe_export
    self.icon2 = self.root.Button_1.noe_export.icon2_export
    self.icon3 = self.root.Button_1.noe_export.icon3_export
    self.one_number = self.root.Button_1.noe_export.one_number_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:on_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
    
function UIActivityBossItem:setData(data , call)
    self.two_number:setString(data)
    self.one_number:setString(data)

    self.call = call 
end 


function UIActivityBossItem:on_click(sender, eventType)
    
    if self.call then 
        self.call()
    end 
end
--CALLBACKS_FUNCS_END

return UIActivityBossItem

--endregion

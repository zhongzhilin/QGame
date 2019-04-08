--region TestDemoButtonsLayer.lua
--Author : song
--Date   : 2016/04/07
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local cast = tolua.cast

local TestDemoButtonsLayer  = class("TestDemoButtonsLayer", function() return gdisplay.newWidget() end )

function TestDemoButtonsLayer:ctor()
    self:CreateUI()
end

function TestDemoButtonsLayer:CreateUI()
    self.root = resMgr:createWidget("TestDemoButtons")
    self:addChild(self.root)

    uiMgr:configUITree(self.root)
    
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.equip_button_ = ccui.Helper:seekNodeByName(self.root, "equip_button_export")

    uiMgr:addWidgetTouchHandler(self.equip_button_, function(sender, eventType) self:onEquipButtonClickHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function TestDemoButtonsLayer:onEquipButtonClickHandler(sender, eventType)
    global.panelMgr:openPanel("UIProduceEquipPanel")
end
--CALLBACKS_FUNCS_END

return TestDemoButtonsLayer

--endregion



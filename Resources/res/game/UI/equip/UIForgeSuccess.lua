--region UIForgeSuccess.lua
--Author : yyt
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
--REQUIRE_CLASS_END

local UIForgeSuccess  = class("UIForgeSuccess", function() return gdisplay.newWidget() end )

function UIForgeSuccess:ctor()
    self:CreateUI()
end

function UIForgeSuccess:CreateUI()
    local root = resMgr:createWidget("equip/forge_success_node")
    self:initUI(root)
end

function UIForgeSuccess:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/forge_success_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.item_name = self.root.Node_export.bg_export.node1_export.item_name_export
    self.cityBuff = self.root.Node_export.bg_export.cityBuff_export
    self.baseIcon = self.root.Node_export.bg_export.baseIcon_export
    self.baseIcon = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon, self.root.Node_export.bg_export.baseIcon_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_2, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIForgeSuccess:onEnter()
    -- body
    
    self.root:stopAllActions()
    local nodeTimeLine1 = resMgr:createTimeline("citybuff/city_buff_effect")
    self.cityBuff:runAction(nodeTimeLine1)
    nodeTimeLine1:play("animation0",true)

    local nodeTimeLine = resMgr:createTimeline("equip/forge_success_node")
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",false)
   
end

function UIForgeSuccess:setData(data)
    -- body
    local equData = global.luaCfg:get_equipment_by(data)
    self.item_name:setString(equData.name)
    self.baseIcon:setData({icon=equData.icon, quality=equData.quality})
end

function UIForgeSuccess:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIForgeSuccess")
end

--CALLBACKS_FUNCS_END

return UIForgeSuccess

--endregion

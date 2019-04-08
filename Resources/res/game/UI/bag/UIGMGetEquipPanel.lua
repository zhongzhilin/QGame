--region UIGMGetEquipPanel.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIGMGetEquipPanel  = class("UIGMGetEquipPanel", function() return gdisplay.newWidget() end )

function UIGMGetEquipPanel:ctor()
    self:CreateUI()
end

function UIGMGetEquipPanel:CreateUI()
    local root = resMgr:createWidget("bag/bag_get_equip")
    self:initUI(root)
end

function UIGMGetEquipPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_get_equip")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.itemId = UIInputBox.new()
    uiMgr:configNestClass(self.itemId, self.root.Node_export.itemId)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4_0, function(sender, eventType) self:getItem_call(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGMGetEquipPanel:exit(sender, eventType)

    global.panelMgr:closePanelForBtn("UIGMGetEquipPanel")
end

function UIGMGetEquipPanel:getItem_call(sender, eventType)

    local idTag = tonumber(self.itemId:getString())

    local itemData = luaCfg:get_equipment_by(idTag)

     if not itemData then 

        itemData = luaCfg:get_lord_equip_by(idTag)
        
     end 

    if itemData == nil then


        global.tipsMgr:showWarningText("娌℃湁鎵惧埌瑁呭ID")
        
        return
    end

    global.itemApi:GMGetEquip(function()
       
       -- global.panelMgr:closePanel("UIGMGetEquipPanel")
    end,idTag)
end
--CALLBACKS_FUNCS_END

return UIGMGetEquipPanel

--endregion

--region UIForgeSelectItem.lua
--Author : yyt
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
--REQUIRE_CLASS_END

local UIForgeSelectItem  = class("UIForgeSelectItem", function() return gdisplay.newWidget() end )

function UIForgeSelectItem:ctor()
    self:CreateUI()
end

function UIForgeSelectItem:CreateUI()
    local root = resMgr:createWidget("equip/equip_forge_suit_node")
    self:initUI(root)
end

function UIForgeSelectItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_forge_suit_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.material_lack = self.root.Node_1.item_list_bg.material_lack_mlan_8_export
    self.material_full = self.root.Node_1.item_list_bg.material_full_mlan_8_export
    self.forge_btn = self.root.Node_1.item_list_bg.forge_btn_export
    self.attackNode = self.root.Node_1.attackNode_mlan_9_export
    self.attack = self.root.Node_1.attackNode_mlan_9_export.attack_export
    self.defenseNode = self.root.Node_1.defenseNode_mlan_9_export
    self.defense = self.root.Node_1.defenseNode_mlan_9_export.defense_export
    self.interiorNode = self.root.Node_1.interiorNode_mlan_9_export
    self.interior = self.root.Node_1.interiorNode_mlan_9_export.interior_export
    self.commanderNode = self.root.Node_1.commanderNode_mlan_9_export
    self.commander = self.root.Node_1.commanderNode_mlan_9_export.commander_export
    self.baseIcon = self.root.Node_1.baseIcon_export
    self.baseIcon = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon, self.root.Node_1.baseIcon_export)
    self.lord_pro1 = self.root.Node_1.lord_pro1_export
    self.pro1 = self.root.Node_1.lord_pro1_export.pro1_export
    self.lord_pro2 = self.root.Node_1.lord_pro2_export
    self.pro2 = self.root.Node_1.lord_pro2_export.pro2_export

    uiMgr:addWidgetTouchHandler(self.forge_btn, function(sender, eventType) self:forgeHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.forge_btn:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIForgeSelectItem:onEnter()
    -- body
    self:addEventListener(global.gameEvent.EV_ON_EQUIP_FORGIN_POINT, function ()  
        if self.checkPoint then
            self:checkPoint()   
        end   
    end)
end

function UIForgeSelectItem:setData(data)

    self.data = data -- 装备id
    local equipData = global.luaCfg:get_equipment_by(data) or global.luaCfg:get_lord_equip_by(data)

    self.lord_pro1:setVisible(false)
    self.lord_pro2:setVisible(false)
    self.attackNode:setVisible(true)
    self.defenseNode:setVisible(true)
    self.interiorNode:setVisible(true)
    self.commanderNode:setVisible(true)

    if equipData.itemType == 2000 then

        self.attackNode:setVisible(false)
        self.defenseNode:setVisible(false)
        self.interiorNode:setVisible(false)
        self.commanderNode:setVisible(false)
       
        for i=1,2 do
            self["lord_pro"..i]:setVisible(false)
            self["lord_pro"..i]:setPositionY(17-(i-1)*30)
            local proData = equipData.extraPro[i]
            if proData then
                self["lord_pro"..i]:setVisible(true)
                local dataType = luaCfg:get_data_type_by(proData[1])
                self["pro"..i]:setString("+".. proData[2] .. dataType.extra)  
                self["lord_pro"..i]:setString(dataType.paraName)
            end
        end
        if #equipData.extraPro == 1 then
            self.lord_pro1:setPositionY(2)
        end

    else
        self.attack:setString(equipData.attack)
        self.defense:setString(equipData.defense)
        self.interior:setString(equipData.interior)
        self.commander:setString(equipData.commander)
    end
    self.baseIcon:setData(equipData)
    self:checkPoint()

    global.tools:adjustNodePosForFather(self.attackNode, self.attack)
    global.tools:adjustNodePosForFather(self.defenseNode, self.defense)
    global.tools:adjustNodePosForFather(self.interiorNode, self.interior)
    global.tools:adjustNodePosForFather(self.commanderNode, self.commander)
    global.tools:adjustNodePosForFather(self.lord_pro1, self.pro1)
    global.tools:adjustNodePosForFather(self.lord_pro2, self.pro2)

end

function UIForgeSelectItem:checkPoint()
    local isCanForge = global.equipData:checkEquipCanForge(self.data)
    self.material_lack:setVisible(not isCanForge)
    self.material_full:setVisible(isCanForge)
end

function UIForgeSelectItem:forgeHandler(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIForgeSelectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        
        if sPanel.isPageMove then 
            return
        end

        global.panelMgr:openPanel("UIForgeInfoPanel"):setData(self.data)
    end
end
--CALLBACKS_FUNCS_END

return UIForgeSelectItem

--endregion

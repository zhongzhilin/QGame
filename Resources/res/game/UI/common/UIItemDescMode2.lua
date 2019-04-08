--region UIItemDescMode2.lua
--Author : anlitop
--Date   : 2017/03/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipInfo = require("game.UI.equip.UIEquipInfo")
--REQUIRE_CLASS_END

local UIItemDescMode2  = class("UIItemDescMode2", function() return gdisplay.newWidget() end )

function UIItemDescMode2:ctor()
   self:CreateUI()
end

function UIItemDescMode2:CreateUI()
    local root = resMgr:createWidget("common/common_item_desc_mode2")
    self:initUI(root)
end

function UIItemDescMode2:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_item_desc_mode2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.item_node = self.root.item_node_export
    self.itemName = self.root.item_node_export.itemName_export
    self.itemDes = self.root.item_node_export.itemDes_export
    self.itemIcon = self.root.item_node_export.itemIcon_export
    self.soldier = self.root.item_node_export.soldier_export
    self.portrait_node = self.root.item_node_export.soldier_export.portrait_node_export
    self.equip_node = self.root.equip_node_export
    self.equip_icon = self.root.equip_node_export.equip_icon_export
    self.suit_name = self.root.equip_node_export.suit_name_export
    self.lv_num = self.root.equip_node_export.lv_mlan_8.lv_num_export
    self.type = self.root.equip_node_export.type_mlan_8.type_export
    self.combat_num = self.root.equip_node_export.combat_mlan_8.combat_num_export
    self.equip_name = self.root.equip_node_export.equip_name_export
    self.equipinfo = UIEquipInfo.new()
    uiMgr:configNestClass(self.equipinfo, self.root.equipinfo)

--EXPORT_NODE_END


    --润稿处理  张亮
    global.tools:adjustNodePosForFather(self.combat_num:getParent(),self.combat_num)
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.lv_num:getParent(),self.lv_num)

end

function UIItemDescMode2:setData(data,position)


    self.data = data

    self.item_node:setPositionX(250)
    self.equip_node:setPositionX(250)
    self.equipinfo:setPositionX(13)
    self.equipinfo:setVisible(false)

    if data.vipTips then 
        self:vipInit()
    else 
        -- 士兵技能解锁
        if self.data.param then
            self:initSoldierSkill()
        else
            self:updateUI()
        end
    end
    --self:setPosition(cc.p(position))
end 

function UIItemDescMode2:vipInit()

    
    self.item_node:setPositionX(0)
    self.equip_node:setPositionX(0)
    self.equipinfo:setPositionX(-240)
    self.equip_node:setVisible(false)
    self.item_node:setVisible(false)

    local data = self.data.information
    self.itemName:setString(data.paraName)

    -- VIP7每日紫装礼包
    if data.per > 0 then

        self.item_node:setVisible(true)
        local itemData = luaCfg:get_item_by(data.resType)
        self.itemDes:setString(itemData.itemDes)
        self.itemName:setString(itemData.itemName)
        self.itemIcon.quit:setVisible(true)
        self.itemIcon.icon:setScale(2)
        global.panelMgr:setTextureFor(self.itemIcon.quit,string.format("icon/item/item_bg_0%d.png", 5))
        self.itemIcon.icon:setSpriteFrame(data.icon)

    else

        self.equipinfo:setVisible(true)
        local equipId = self.data.information.resType
        self.equipinfo:setData_longTipsModal(equipId)

        self.equip_node:setVisible(false)
        local equipData = luaCfg:get_equipment_by(data.resType)      
        self.itemDes:setString(equipData.des)
        self.combat_num:setString(equipData.baseCombat)
        self.type:setString(luaCfg:get_local_string(10377 + equipData.type))
        self.lv_num:setString(equipData.lv)

        self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(equipData.quality).rgb)))
        self.equip_name:setString(equipData.name)
        global.panelMgr:setTextureFor(self.equip_icon.quit, string.format("icon/item/item_bg_0%d.png",equipData.quality))
        global.panelMgr:setTextureFor(self.equip_icon.icon, equipData.icon)

        local kind = equipData.kind
        if kind == 0 then
            self.suit_name:setVisible(false)
        else
            self.suit_name:setVisible(true)
            if luaCfg:get_equipment_suit_by(kind) then 
                self.suit_name:setString(luaCfg:get_equipment_suit_by(kind).suitName)
            else 
                self.suit_name:setString("")
            end 
        end

    end

end

function UIItemDescMode2:initSoldierSkill()

    self.equip_node:setVisible(false)
    self.item_node:setVisible(true)
    self.itemName:setString(self.data.information.skillName)
    -- global.panelMgr:setTextureFor(self.itemIcon.quit,string.format("icon/item/item_bg_0%d.png",self.data.information.quality or 1))
    self.itemIcon.quit:setVisible(false)
    self.itemIcon.icon:setScale(2)
    global.panelMgr:setTextureFor(self.itemIcon.icon,self.data.information.icon)
    self.itemDes:setString(self.data.information.desTxt) 
end

function UIItemDescMode2:onExit()
    self.soldier:setVisible(false)
    self.itemIcon:setVisible(true)
end

function UIItemDescMode2:updateUI()
    
    if not self.data.information.baseCombat then
        self.item_node:setVisible(true)
        self.equip_node:setVisible(false)
        self.itemIcon.quit:setVisible(true)
        self.itemIcon.icon:setScale(1)
        self.itemName:setString(self.data.information.itemName)
        -- self.itemIcon.icon:setSpriteFrame(self.data.information.itemIcon)
        -- self.itemIcon.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.itemIcon.quit,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.itemIcon.icon,self.data.information.itemIcon)

        self.itemDes:setString(self.data.information.itemDes)        
        self.equipinfo:setVisible(false)
        self.board:setContentSize(cc.size(486,200))
    else

        local equipId = self.data.information.id
        self.equipinfo:setData_longTipsModal(equipId)
        self.equipinfo:setVisible(true)
        self.board:setContentSize(self.equipinfo.board:getContentSize())

        self.equip_node:setVisible(false)

        self.item_node:setVisible(false)
        
        self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(self.data.information.quality).rgb)))
        self.equip_name:setString(self.data.information.name)
        -- self.equip_icon.icon:setSpriteFrame(self.data.information.icon)
        -- self.equip_icon.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.equip_icon.quit,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))
        global.panelMgr:setTextureFor(self.equip_icon.icon,self.data.information.icon)
        self.combat_num:setString(self.data.information.baseCombat)
        self.type:setString(luaCfg:get_local_string(10377 + self.data.information.type))
        self.lv_num:setString(self.data.information.lv)

        local kind = self.data.information.kind

        if kind == 0 then
            self.suit_name:setVisible(false)
        else
            self.suit_name:setVisible(true)
            if luaCfg:get_equipment_suit_by(kind) then 
                self.suit_name:setString(luaCfg:get_equipment_suit_by(kind).suitName)
            else 
                self.suit_name:setString("")
            end 
        end
    end 

end

function UIItemDescMode2:getContentSize()
    return self.soldier_tips_node:getContentSize()
end 

function UIItemDescMode2:show()
    -- body
    self:setVisible(true)
    self:runAction(cc.FadeIn:create(0.2))
end


function UIItemDescMode2:hide()
    -- body
      self:setVisible(false)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
--CALLBACKS_FUNCS_END

return UIItemDescMode2

--endregion

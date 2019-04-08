--region UIEquipItem.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIEquipInfo = require("game.UI.equip.UIEquipInfo")
local heroData = global.heroData
local panelMgr = global.panelMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
--REQUIRE_CLASS_END

local UIEquipItem  = class("UIEquipItem", function() return gdisplay.newWidget() end )

function UIEquipItem:ctor()
    
    self:CreateUI()
end

function UIEquipItem:CreateUI()
    local root = resMgr:createWidget("equip/equipItem")
    self:initUI(root)
end

function UIEquipItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equipItem")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.baseIcon = self.root.baseIcon_export
    self.baseIcon = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon, self.root.baseIcon_export)
    self.item_tips = self.root.item_tips_export
    self.lv_num = self.root.item_tips_export.lv_num_mlan_1_export
    self.light = self.root.light_export
    self.lv = self.root.lv_export
    self.strog = self.root.strog_export
    self.kindType = self.root.kindType_export
    self.strength_icon_bg = self.root.strength_icon_bg_export
    self.hero_icon = self.root.strength_icon_bg_export.hero_icon_export

--EXPORT_NODE_END    
    self.kindType:setLocalZOrder(1)
    self.item_tips:setLocalZOrder(1)
    self.strength_icon_bg:setLocalZOrder(1)
    self.lv:setLocalZOrder(1)
    self.strog:setLocalZOrder(1)
    self.light:setLocalZOrder(self.baseIcon:getLocalZOrder()+1)
end

function UIEquipItem:setData(data)
    
    self.data = data    
    local equipData = luaCfg:get_equipment_by(data.lGID)

    if self.data.lHeroID ~= 0 then
        self.strength_icon_bg:setVisible(true)


        local head_data = nil
        local roldHeadData = luaCfg:rolehead()

        for _ ,v in pairs(roldHeadData) do 
            if v.triggerId == data.lHeroID then 
                head_data = v 
            end 
        end 

        if head_data then
            panelMgr:setTextureFor(self.hero_icon,head_data.path)
        end        
    else
        self.strength_icon_bg:setVisible(false)
    end

    if not equipData then 

        equipData = luaCfg:get_lord_equip_by(data.lGID)
    end 

    self.kindType:setVisible(false)
    if equipData and equipData.typeIcon and equipData.typeIcon > 0 then
        self.kindType:setVisible(true)
        self.kindType:loadTexture(luaCfg:get_type_icon_by(equipData.typeIcon).icon, ccui.TextureResType.plistType)
    end

    local _tmpData = self.data._tmpData

    self.lv:setVisible(_tmpData.isShowLv)    
    
    self.strog:setString(":" .. self.data.lStronglv)    
    self.strog:setVisible(self.data.lStronglv > 0)

    if _tmpData.isShowLv then

        self.lv:setString("Lv." .. data.confData.lv)

        if _tmpData.isInBagPanel then
            self.lv:setTextColor(cc.c3b(255,255,255))
        else
            self.lv:setTextColor(_tmpData.isCanSuit and cc.c3b(87,213,63) or cc.c3b(255,40,40))
        end
    end

    self.baseIcon:setData(equipData,not _tmpData.isCanSuit,self.data.lStronglv)
    self.item_tips:setVisible(data._tmpData.isNew)
end

function UIEquipItem:setFocus(isSelect,infoPanel)
    
    self.light:setVisible(isSelect)

    if isSelect then

        -- global.equipData:signEquipBeOpen(self.data.lID)
        self.item_tips:setVisible(false)
        self.data._tmpData.isNew = false

        self.root:setPositionY(infoPanel:getContentHeigth())    

        if infoPanel:getParent() then

            infoPanel:removeFromParent()   

        end 

        self:addChild(infoPanel)
        self.infoPanel = infoPanel
    else

        self.root:setPositionY(0)    

        if self.infoPanel then

            if not tolua.isnull(self.infoPanel) and self.infoPanel:getParent() == self then
                self.infoPanel:removeFromParent()    

                print("remove self")
            end

            print("clean one")
            
            self.infoPanel = nil
        end    
    end    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEquipItem

--endregion

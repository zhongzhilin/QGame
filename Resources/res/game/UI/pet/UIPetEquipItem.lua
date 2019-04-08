--region UIPetEquipItem.lua
--Author : yyt
--Date   : 2017/12/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetEquipItem  = class("UIPetEquipItem", function() return gdisplay.newWidget() end )

function UIPetEquipItem:ctor()
    self:CreateUI()
end

function UIPetEquipItem:CreateUI()
    local root = resMgr:createWidget("pet/pet_fifth_node")
    self:initUI(root)
end

function UIPetEquipItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_fifth_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.quit = self.root.Button_1_export.quit_export
    self.icon = self.root.Button_1_export.icon_export
    self.select = self.root.Button_1_export.bg.select_export
    self.addFri = self.root.Button_1_export.addFri_export
    self.kindType = self.root.Button_1_export.kindType_export
    self.strog = self.root.Button_1_export.strog_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:selectHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetEquipItem:setData(data)

    self.data = data
    self.confData = data.confData
    local equipData = luaCfg:get_equipment_by(self.confData.id)
    global.panelMgr:setTextureFor(self.icon, equipData.icon)
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",equipData.quality))
    self.select:setVisible(data.isSelected == 1)
    self.addFri:setString("+"..luaCfg:get_equipment_by(data.confData.id).petImpress)

    self.kindType:setVisible(false)
    if equipData and equipData.typeIcon and equipData.typeIcon > 0 then
        self.kindType:setVisible(true)
        self.kindType:loadTexture(luaCfg:get_type_icon_by(equipData.typeIcon).icon, ccui.TextureResType.plistType)
    end

    self.strog:setString(":" .. self.data.lStronglv)    
    self.strog:setVisible(self.data.lStronglv > 0)
end

function UIPetEquipItem:selectHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        global.petEqiPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if global.petEqiPanel.isPageMove then 
            return
        end
        
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
        local pData = global.petEqiPanel.data
        local nextConfig = global.petData:getPetConfig(pData.id, pData.serverData.lGrade+1)
        local nextFriend = nextConfig.exp  
        local curSelect, curFriendlyTotal = global.petEqiPanel:getCurSelectNum()
        if global.petEqiPanel.isEnoughFri and self.data.isSelected ~= 1 then
            return global.tipsMgr:showWarning("petEquipFeedPrompt2")
        end
        global.petEqiPanel:refershSelect(self.data.lID)
    end
end
--CALLBACKS_FUNCS_END

return UIPetEquipItem

--endregion

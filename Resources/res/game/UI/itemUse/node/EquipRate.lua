local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local EquipRate  = class("EquipRate", function() return gdisplay.newWidget() end )

function EquipRate:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function EquipRate:initUI(callFunc)
	self.panel.queueUnlock_node:setVisible(true)
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10429))
    self.panel.txt_Title:setString(luaCfg:get_local_string(10431))
    
end

function EquipRate:setItemData(data)

    local spaceStr = self.panel.spaceNum:getString()
    local itemCount = normalItemData:getItemById(data.itemId).count
    if itemCount <= 0 then
        self:troopSpeedUI(spaceStr, data.itemName)
        self.panel.need:setTextColor(gdisplay.COLOR_RED)
        self.panel.btnUse:setEnabled(false)
    else
        self.panel.btnUse:setEnabled(true)
        self.panel.slider:setVisible(false)
        self.panel.speedTime_node:setVisible(false)
        self.panel.mojing_node:setVisible(true)
        self.panel.btnUse:setEnabled(true)

        self.panel.need:setString(1)
        self.panel.need:setTextColor(cc.c3b(255, 185,34))
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), data.itemName) .. "?")
    end
   
end

function EquipRate:troopSpeedUI(spaceStr, itemName)
    self.panel.slider:setVisible(false)
    self.panel.speedTime_node:setVisible(false)
    
    self.panel.mojing_node:setVisible(true)
    self.panel.btnUse:setEnabled(true)

    self.panel.need:setString(1)
    self.panel.need:setTextColor(cc.c3b(255, 185,34))
    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), itemName) .. "?")
end

function EquipRate:sendGift()
    
   
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local itemId = item.data.itemId
    global.panelMgr:getPanel("UIEquipStrongPanel"):chooseRate(itemId)

    self.panel:exit()
    
end

return EquipRate

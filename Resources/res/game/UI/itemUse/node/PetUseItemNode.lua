--
-- Author: Your Name
-- Date: 2017-03-20 20:23:18
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local PetUseItemNode  = class("PetUseItemNode", function() return gdisplay.newWidget() end )

function PetUseItemNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function PetUseItemNode:initUI(callFunc)

    self.callFunc = callFunc
	self.panel.queueUnlock_node:setVisible(true)
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(11105))
end

function PetUseItemNode:setItemData(data)
	self.data = data
    local spaceStr = self.panel.spaceNum:getString()
    local itemCount = normalItemData:getItemById(data.itemId).count
    if itemCount <= 0 then
        self.panel.sliderControl:setMaxCount(0)
        self.panel:itemCountNotEnough(spaceStr, data.itemName)
    else
        self.panel.btnUse:setEnabled(true)
        self.panel.slider:setVisible(false)
        self.panel.speedTime_node:setVisible(true)
        self.panel.mojing_node:setVisible(false)
        self.panel.btnUse:setEnabled(true)

        self.panel.need:setString(1)
        self.panel.need:setTextColor(cc.c3b(255, 226, 165))
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), data.itemName) .. "?")
   
        self.panel.btnUse:setEnabled(true)
        local maxCount = itemCount
            self.panel.sliderControl:setMaxCount(itemCount)
        if maxCount == 1 then
            self.panel.sliderControl:reSetMaxCount(1)
        end
    end

    self.panel.slider:setVisible(true)
    local useCount = self.panel.sliderControl:getContentCount()
    self.panel.mojing_node:setVisible(false)
    self.panel.speedTime_node:setVisible(true)
    self.panel.speedUseText:setString(luaCfg:get_local_string(11106, tonumber(self.data.typePara1)*useCount))
    self.panel.speedTime:setString("")

end

function PetUseItemNode:upPetImpress()

    local itemId = self.data.itemId
    local useCount = self.panel.sliderControl:getContentCount()
    global.itemApi:itemUse(itemId, useCount, 0, self.panel.buildingId, function(msg)

        local data = global.luaCfg:get_item_by(msg.lID)
        local addImpress = tonumber(data.typePara1)*useCount
        global.tipsMgr:showWarning(luaCfg:get_local_string(11107, addImpress))
        global.panelMgr:closePanel("UISpeedPanel")
   end)
end
return PetUseItemNode

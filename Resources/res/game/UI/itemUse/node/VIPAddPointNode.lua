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

local VIPAddPointNode  = class("VIPAddPointNode", function() return gdisplay.newWidget() end )

function VIPAddPointNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function VIPAddPointNode:initUI(callFunc)

	self.panel.queueUnlock_node:setVisible(true)
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    if self.panel.lType == self.panel.TYP_VIPAddPoint then 
        self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_localization_by(10457).value)
        self.panel.txt_Title:setString(luaCfg:get_localization_by(10459).value)
    elseif self.panel.lType ==  self.panel.TYP_VIPActivation then
        self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_localization_by(10458).value)
        self.panel.txt_Title:setString(luaCfg:get_localization_by(10460).value)
    end 

end

function VIPAddPointNode:setItemData(data)
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
    local useCount = self.panel.sliderControl:getContentCount()
    if self.panel.lType == self.panel.TYP_VIPAddPoint then 
         self.panel.mojing_node:setVisible(false)
         self.panel.speedTime_node:setVisible(true)
         self.panel.speedUseText:setString(luaCfg:get_localization_by(10459).value..':'..tonumber(self.data.typePara1)*useCount)
        self.panel.speedTime:setString("")

    elseif self.panel.lType ==  self.panel.TYP_VIPActivation then
        self.panel.mojing_node:setVisible(false)
        self.panel.speedTime_node:setVisible(true)
        local useCount = self.panel.sliderControl:getContentCount()
        self.panel.speedUseText:setString(luaCfg:get_localization_by(10460).value..':'..funcGame.formatTimeToHMS(tonumber(self.data.typePara1)*useCount*60))
        self.panel.speedTime:setString("")
    end 

      self.panel.slider:setVisible(true)

end

function VIPAddPointNode:troopSpeedUI(spaceStr, itemName)
    self.panel.slider:setVisible(false)
    self.panel.speedTime_node:setVisible(true)
    
    self.panel.mojing_node:setVisible(false)
    self.panel.btnUse:setEnabled(true)

    self.panel.need:setString(1)
    self.panel.need:setTextColor(cc.c3b(255, 226, 165))
    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), itemName) .. "?")
end

function VIPAddPointNode:warningCall()
	self.panel.topModel:setVisible(false)
end 

function VIPAddPointNode:checkUsed(msg)

end 

function VIPAddPointNode:troopAccelerate()
    local useCount = self.panel.sliderControl:getContentCount()
    global.itemApi:itemUse(self.data.itemId, useCount, 0, self.panel.buildingId, function(msg)
    local data = global.luaCfg:get_item_by(msg.lID)
    global.tipsMgr:showWarning(data.useDes)
    global.panelMgr:closePanel("UISpeedPanel")
   end)
end
return VIPAddPointNode

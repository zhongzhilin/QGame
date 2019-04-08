--
-- Author: Your Name
-- Date: 2017-06-04 15:55:53
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local LordHPNode = class("LordHPNode", function() return gdisplay.newWidget() end )

function LordHPNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function LordHPNode:onEnter() 
    
    self.lockRestTime = 0
end

function LordHPNode:initUI(callFunc)

    self.unLockQueue = callFunc
    self.panel.queueUnlock_node:setVisible(true)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10696))
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    
end

function LordHPNode:setItemData(data)

    local spaceStr = self.panel.spaceNum:getString()
    if data.itemId == 6 then

        -- local spaceStr = self.panel.spaceNum:getString()
        -- local queueData = luaCfg:get_build_queue_by(3)
        -- for _,v in pairs(queueData.unlockCost) do
        --     if v[1] == 6 then
        --         self.panel.need:setString(v[2])
        --     end
        -- end
        -- self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10039), queueData.time))
        -- self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
    else

        local itemCount = normalItemData:getItemById(data.itemId).count
        if itemCount <= 0 then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
            self.panel.speedUseText:setString(string.format(luaCfg:get_local_string(10697),luaCfg:get_item_by(data.itemId).typePara1))
            self.panel.speedTime:setString("")
        else
            self.panel.btnUse:setEnabled(true)
            local maxCount = itemCount
            self.panel.sliderControl:setMaxCount(maxCount)
            if maxCount == 1 then
                self.panel.sliderControl:reSetMaxCount(1)
            end
            self.panel.speedUseText:setString(string.format(luaCfg:get_local_string(10697),luaCfg:get_item_by(data.itemId).typePara1))

            -- self.panel.speedUseText:setString(string.format(luaCfg:get_local_string(10339),luaCfg:get_item_impression_by(luaCfg:get_item_by(data.itemId).itemType).value))
            self.panel.speedTime:setString("")
        end
    end
end

function LordHPNode:sendGift()
    
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local number = tonumber(self.panel.cur:getString())
    local itemId = item.data.itemId

    global.itemApi:itemUse(itemId,number,0,self.panel.buildingId,function(msg)
        
        global.tipsMgr:showWarningText(string.format(luaCfg:get_local_string(10697),luaCfg:get_item_by(itemId).typePara1 * number))
        global.panelMgr:closePanel("UISpeedPanel")
    end)
end

return LordHPNode
    
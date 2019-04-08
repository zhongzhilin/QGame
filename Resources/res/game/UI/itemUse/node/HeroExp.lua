local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local HeroExp = class("HeroExp", function() return gdisplay.newWidget() end )

function HeroExp:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function HeroExp:onEnter() 
    
    self.lockRestTime = 0
end

function HeroExp:initUI(callFunc)

    self.unLockQueue = callFunc
    self.panel.queueUnlock_node:setVisible(true)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10988))
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    self.panel.speedUseText:setVisible(false)
    
end

function HeroExp:setItemData(data)

    self.panel.slider:setVisible(false)


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
            self.panel.btnUse:setEnabled(false)
            self:troopSpeedUI("ts"  , data.itemName)
        else
            self.panel.btnUse:setEnabled(true)
            self:troopSpeedUI("ts"  , data.itemName)
        end 
    end
end

function HeroExp:troopSpeedUI(spaceStr, itemName)

    self.panel.speedTime_node:setVisible(false)
    self.panel.mojing_node:setVisible(true)
    self.panel.need:setString(1)
    self.panel.need:setTextColor(cc.c3b(255, 226, 165))
    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), itemName) .. "?")

    self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
    
end

function HeroExp:start()
    
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local number = tonumber(self.panel.cur:getString())
    local itemId = item.data.itemId

    global.unionApi:heroSpring(function () 
        
         if global.chatData:isJoinUnion() then 
            global.unionData:sendSpringToChat(itemId)
        end  

        global.panelMgr:closePanel("UISpeedPanel")

    end ,1,self.panel.buildingId , nil , itemId)
    
end

return HeroExp
    
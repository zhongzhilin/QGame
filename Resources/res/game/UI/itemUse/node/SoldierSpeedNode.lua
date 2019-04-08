local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local SoldierSpeedNode  = class("SoldierSpeedNode", function() return gdisplay.newWidget() end )

function SoldierSpeedNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function SoldierSpeedNode:initUI(callFunc)

	self.panel.queueUnlock_node:setVisible(true)
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10134))
    self.panel.txt_Title:setString(luaCfg:get_local_string(10028))
    
end

function SoldierSpeedNode:setItemData(data)

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
        self.panel.need:setTextColor(cc.c3b(255, 226, 165))
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), data.itemName) .. "?")
    end
   
end

function SoldierSpeedNode:troopSpeedUI(spaceStr, itemName)
    self.panel.slider:setVisible(false)
    self.panel.speedTime_node:setVisible(false)
    
    self.panel.mojing_node:setVisible(true)
    self.panel.btnUse:setEnabled(true)

    self.panel.need:setString(1)
    self.panel.need:setTextColor(cc.c3b(255, 226, 165))
    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), itemName) .. "?")
end

function SoldierSpeedNode:troopAccelerate()

    -- if global.g_worldview.attackMgr:isTroopAleadySpeedUp(self.panel.buildingId) then

    --     global.tipsMgr:showWarning("228")        
    --     self.panel:exit()
    --     return
    -- end

    local panel = global.panelMgr:openPanel("UIPromptPanel")  
    panel:setPanelExitCallFun(function ()
        if not tolua.isnull(self.panel) then
            self.panel.topModel:setVisible(false)
        end
    end)      
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local itemId = item.data.itemId    
    local useCount = 1    

    panel:setData("TroopsSpeed", function()        

        global.itemApi:itemUse(itemId, useCount, 0, self.panel.buildingId, function(msg)

            local data = normalItemData:useItem(itemId, useCount)
            global.tipsMgr:showWarning("TroopsAddSpeed")
            gevent:call(gsound.EV_ON_PLAYSOUND,"world_action")
        end)

        --退出当前界面
        self.panel:exit()
    end)        
end

return SoldierSpeedNode
	
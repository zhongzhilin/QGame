--region UIWorldBossPanel.lua
--Author : Untory
--Date   : 2017/12/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UITableView = require("game.UI.common.UITableView")
local UIWorldBossItemCell = require("game.UI.world.widget.UIWorldBossItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIWorldBossPanel  = class("UIWorldBossPanel", function() return gdisplay.newWidget() end )

function UIWorldBossPanel:ctor()
    self:CreateUI()
end

function UIWorldBossPanel:CreateUI()
    local root = resMgr:createWidget("wild/world_boss_monster")
    self:initUI(root)
end

function UIWorldBossPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/world_boss_monster")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.board = self.root.Node_export.board_export
    self.Img = self.root.Node_export.Img_export
    self.details = self.root.Node_export.details_export
    self.Ranking = self.root.Node_export.Ranking_export
    self.lv = self.root.Node_export.lv_mlan_5.lv_export
    self.scale = self.root.Node_export.scale_mlan_9.scale_export
    self.state_title = self.root.Node_export.state_title_mlan_5_export
    self.state = self.root.Node_export.state_title_mlan_5_export.state_export
    self.count = self.root.Node_export.count_mlan_5.count_export
    self.strengthBuy = self.root.Node_export.count_mlan_5.strengthBuy_export
    self.attack = self.root.Node_export.attack_export
    self.nodes = self.root.Node_export.nodes_export
    self.name = self.root.Node_export.nodes_export.name_export
    self.close_node = self.root.Node_export.nodes_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.nodes_export.close_node_export)
    self.drop_title = self.root.Node_export.nodes_export.drop_title_export
    self.tb_size = self.root.Node_export.tb_size_export
    self.it_size = self.root.Node_export.it_size_export
    self.loadingbar_bg = self.root.Node_export.loadingbar_bg_export
    self.LoadingBar = self.root.Node_export.loadingbar_bg_export.LoadingBar_export
    self.info = self.root.Node_export.loadingbar_bg_export.info_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.details, function(sender, eventType) self:collect_click1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Ranking, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:addEnergy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:action_click(sender, eventType) end)
--EXPORT_NODE_END
    self.close_node:setData(function()
        self:onCloseHandler()
    end)
    
    self.tableView = UITableView.new()
        :setSize(self.tb_size:getContentSize())
        :setCellSize(self.it_size:getContentSize())
        :setCellTemplate(UIWorldBossItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.tb_size:addChild(self.tableView)
end

function UIWorldBossPanel:setData(data,surfaceData,designerData)

    local g_worldview = global.g_worldview    
    local meter = g_worldview.const:converPix2Location(cc.p(data.lPosX,data.lPosY))
    self.data = data    
    self.surfaceData = surfaceData
    self.tableView:setData({})    
    self.name:setString(string.format("%s(%s,%s)",surfaceData.name,meter.x,meter.y))
    self.scale:setString(designerData.scale)
    local bossData = luaCfg:get_worldboss_by(data.lBossId)
    self.isOpen = true

    global.panelMgr:setTextureFor(self.Img,surfaceData.bigmap)

    local dropItem = luaCfg:get_drop_by(bossData.drop).dropItem
    self.tableView:setData(dropItem)    
    
    self.strengthBuy:setEnabled(false)
    global.g_worldview.worldPanel.chooseCityId = data.lMonsterID
    global.worldApi:getBossInfo(data.lMonsterID,function(msg)        
        
        -- dump(msg,'.mmm')
        if self.isOpen then
            self:flushBossData(msg)
        end        
    end)


    global.tools:adjustNodePosForFather(self.scale:getParent() , self.scale)

end
function UIWorldBossPanel:startCheckTime(endTime)
    
    self.endTime = endTime

    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime()
    end, 1) 
    self:checkTime()
end
function UIWorldBossPanel:onExit()
    self.isOpen = false
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end
function UIWorldBossPanel:checkTime()
    local contentTime = self.endTime - global.dataMgr:getServerTime()
    if contentTime < 0 then
        contentTime = 0
        global.panelMgr:closePanel('UIWorldBossPanel')
        if self.scheduleListenerId then
            gscheduler.unscheduleGlobal(self.scheduleListenerId)
            self.scheduleListenerId = nil
        end
        return
    end
    local str = global.troopData:timeStringFormat(contentTime)
    self.state:setString(str)

    global.tools:adjustNodePosForFather(self.state:getParent() , self.state)

end

function UIWorldBossPanel:flushBossData(msg)

    local bossData = luaCfg:get_worldboss_by(msg.lBossId)
    self.lv:setString('Lv' .. bossData.lv)
    self.info:setString(msg.lCurHp .. '/' .. bossData.hp)
    self.LoadingBar:setPercent(msg.lCurHp / bossData.hp * 100)
    self.count:setString(msg.lAttackTime)
    self:startCheckTime(msg.lNextTime)
    self.msg = msg
    self.bossData = bossData
    self.attackCount = msg.lAttackTime
    self.buyCount = msg.lBuyCount + 1 
    if self.buyCount > #luaCfg:worldbosscount() then
        self.buyCount = #luaCfg:worldbosscount() 
    end

    if msg.lCurState == 0 then
        self.state_title:setString(luaCfg:get_local_string(11032))
        self.state:setTextColor(cc.c3b(180,29,11))
        self.count:setString(luaCfg:get_config_by(1).worldBossCount)
        self.strengthBuy:setEnabled(false)
    else
        self.state_title:setString(luaCfg:get_local_string(11031))
        self.state:setTextColor(cc.c3b(87,213,63))
        self.strengthBuy:setEnabled(true)
    end     

    global.tools:adjustNodePosForFather(self.count:getParent() , self.count)
    global.tools:adjustNodePosForFather(self.lv:getParent() , self.lv)
    global.tools:adjustNodePos(self.count , self.strengthBuy)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldBossPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn('UIWorldBossPanel')
end

function UIWorldBossPanel:infoCall(sender, eventType)
    local data = global.luaCfg:get_introduction_by(self.bossData.introduction)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIWorldBossPanel:collect_click(sender, eventType)
    if self.bossData then 
        global.ActivityData:openActivityRank(self.bossData.activity)
    end 
end

function UIWorldBossPanel:action_click(sender, eventType)

    self.msg = self.msg or {}
    
    if self.msg.lCurState == 0 then
        global.tipsMgr:showWarning('617')
        return
    end

    if self.attackCount == 0 then
        -- global.tipsMgr:showWarning('616')
        self:addEnergy_click()
        return
    end

    global.troopData:setTargetData(2, 0, self.data.lMonsterID, self.surfaceData.name or "")      
    global.panelMgr:openPanel("UITroopPanel")
end

function UIWorldBossPanel:addEnergy_click(sender, eventType)
    
    local cost = luaCfg:get_worldbosscount_by(self.buyCount).cost        

    local panel = global.panelMgr:openPanel("UIBossBuy")
    panel:setData(cost,function()
        global.itemApi:diamondUse(function (msg)
            self.attackCount = self.attackCount + 1
            self.count:setString(self.attackCount)

            self.buyCount = self.buyCount + 1 
            if self.buyCount > #luaCfg:worldbosscount() then
                self.buyCount = #luaCfg:worldbosscount() 
            end

        end, 14,self.data.lBossId)
    end)
    -- panel:setData("worldBoss01", function()

    --     global.itemApi:diamondUse(, 14,self.data.lBossId)
    -- end,cost)
end

function UIWorldBossPanel:collect_click1(sender, eventType)
    global.ActivityData:openActivityPanel(self.bossData.activity)
end
--CALLBACKS_FUNCS_END

return UIWorldBossPanel

--endregion

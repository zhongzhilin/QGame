--region UIBuyHeroPanel.lua
--Author : anlitop
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIBuyHeroPanel  = class("UIBuyHeroPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIBuyHeroItemCell = require("game.UI.hero.UIBuyHeroItemCell")

function UIBuyHeroPanel:ctor()
    self:CreateUI()
end

function UIBuyHeroPanel:CreateUI()
    local root = resMgr:createWidget("hero/buy_hero_panel")
    self:initUI(root)
end

function UIBuyHeroPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/buy_hero_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_node = self.root.title_node_export
    self.VIP = self.root.title_node_export.VIP_fnt_mlan_12_export
    self.FileNode_2 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.top_node = self.root.top_node_export
    self.buy_time = self.root.top_node_export.buy_time_export
    self.table_node = self.root.table_node_export

--EXPORT_NODE_END

    
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top_node)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIBuyHeroItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType)  
        global.panelMgr:closePanel("UIBuyHeroPanel")
    end)
    
    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL,"UIBuyHeroPanel")
    self.VIP:setString(global.luaCfg:get_recharge_list_by(index).texct)

    self.table_node:setLocalZOrder(self.FileNode_2:getLocalZOrder() + 10)

    print(self.FileNode_2:getLocalZOrder() ,"self.getLocalZOrder()")

    print(self.table_node:getLocalZOrder() ,"self.getLocalZOrder()")

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBuyHeroPanel:onEnter()

    self:setData()

    self:addEventListener(global.gameEvent.EV_ON_UI_HERO_FLUSH , function () 

        self:setData(true)
    end)


    local call = function () 
        local iscan  , time = global.heroData:isCanBuy()
        if math.floor(time) == 0 then 
            global.panelMgr:closePanel("UIBuyHeroPanel")
        else 
           self.buy_time:setString(global.vipBuffEffectData:getDayTime(time))      
        end 
    end 

    global.netRpc:delHeartCall(self)
    global.netRpc:addHeartCall( function () 
        call()
    end,self)
    call()
    
end 

function UIBuyHeroPanel:gps()

    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL , self.__cname)
    self.FileNode_2.tableView:jumpToCellByIdx(index -1 , true)    
end 


function UIBuyHeroPanel:onExit()

    global.netRpc:delHeartCall(self)

    self:cleanTimer()
end 

function UIBuyHeroPanel:cleanTimer()

   if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end 


function UIBuyHeroPanel:setData(old)

    self.disscountHero = global.heroData:getDisscountHero() or {} 

     self.tableView:setData({})

    if #self.disscountHero == 0 then 
        -- global.tipsMgr:showWarning("random hero is  nil")
        -- return 
    end 

    local data = {}

    for k,v in  pairs(self.disscountHero) do 
        table.insert(data , global.luaCfg:get_gift_by(v))
    end 

    for _ ,v in ipairs(global.luaCfg:gift()) do 

        if v.switch == 1 and v.type == 6 and v.random == 0 then 
            local flg = true  
            for _, vv in pairs(self.disscountHero) do 
                if  global.luaCfg:get_gift_by(vv).dropid == v.dropid then 
                    flg = false
                end 
            end 
            if flg then 
                table.insert(data , v)
            end  
        end 
    end 

    self.tableView:setData(data , old)

end

function UIBuyHeroPanel:setDisscountHero()

    for k,v in  pairs(self.disscountHero) do 
        if self["ps_"..k] and not self["UIBuyHeroItem_"..k] then 
            local UIBuyHeroItem = require("game.UI.hero.UIBuyHeroItem").new()
            UIBuyHeroItem:setData(global.luaCfg:get_gift_by(v))
            UIBuyHeroItem:setPosition(self["ps_"..k]:getPosition())
            UIBuyHeroItem:setLocalZOrder(self["ps_"..k]:getLocalZOrder()-10)
            UIBuyHeroItem.discount_node:setVisible(true)
            UIBuyHeroItem.discount_node:setVisible(true)
            self.root.Node_9:addChild(UIBuyHeroItem)
            self["UIBuyHeroItem_"..k] = UIBuyHeroItem
        else
            self["UIBuyHeroItem_"..k]:setData(global.luaCfg:get_gift_by(v))
        end  
    end

end 


function UIBuyHeroPanel:updateOverTime()

    local time =  -1 

    time = global.heroData:getDisscountHeroTime() - global.dataMgr:getServerTime()
    
    if time >=  0 then 

     for k,v  in  pairs(self.disscountHero) do 
        if self["UIBuyHeroItem_"..k] then 
        self["UIBuyHeroItem_"..k].time:setString(global.funcGame.formatTimeToHMS(time))
        end  
     end 
    else 
        self:cleanTimer()
    end 

end 




--CALLBACKS_FUNCS_END

return UIBuyHeroPanel

--endregion

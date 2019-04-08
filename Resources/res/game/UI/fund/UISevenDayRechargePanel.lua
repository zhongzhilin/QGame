--region UISevenDayRechargePanel.lua
--Author : anlitop
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UISevenDayRechargePanel  = class("UISevenDayRechargePanel", function() return gdisplay.newWidget() end )
local DayItem = require("game.UI.fund.DayItem")
local UITableView = require("game.UI.common.UITableView")
local UISevenDayRechargeItemCell = require("game.UI.fund.UISevenDayRechargeItemCell")

function UISevenDayRechargePanel:ctor()
    self:CreateUI()
end

function UISevenDayRechargePanel:CreateUI()
    local root = resMgr:createWidget("fund/recharge_daily_bj")
    self:initUI(root)
end

function UISevenDayRechargePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "fund/recharge_daily_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.title1 = self.root.title_export.title1_fnt_mlan_12_export
    self.top_node = self.root.top_node_export
    self.icon = self.root.top_node_export.icon_export
    self.tips = self.root.top_node_export.tips_export
    self.diamond_icon_sprite = self.root.top_node_export.diamond_icon_sprite_export
    self.gift_value_sprite = self.root.top_node_export.gift_value_sprite_export
    self.discount = self.root.top_node_export.discount_export
    self.diaCurNum = self.root.top_node_export.diaCurNum_export
    self.gift_name = self.root.top_node_export.bg.gift_name_mlan_14_export
    self.time = self.root.top_node_export.bg.time_export
    self.FileNode_1 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.receive_bt = self.root.bottom_bg.receive_bt_export
    self.togoReCharge = self.root.bottom_bg.togoReCharge_export
    self.tb_bottom = self.root.tb_bottom_export
    self.tb_add = self.root.tb_add_export
    self.tb_content = self.root.tb_content_export
    self.tb_item_content = self.root.tb_item_content_export
    self.day_node = self.root.day_node_export

    uiMgr:addWidgetTouchHandler(self.receive_bt, function(sender, eventType) self:receive(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.togoReCharge, function(sender, eventType) self:reCharge(sender, eventType) end)
--EXPORT_NODE_END
    
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType)  
        global.panelMgr:closePanel("UISevenDayRechargePanel")
    end)

    for i= 1 , 7 do 
        local day_node = DayItem.new()
        day_node.day:setString(string.format(global.luaCfg:get_local_string(10352), i))
        -- uiMgr:setRichText(day_node, "day", 50141 ,{num = i })
        self.day_node:addChild(day_node)
        day_node:setPositionX((i-1) * 100 )
        self["day_"..i] = day_node

        uiMgr:addWidgetTouchHandler(day_node.Button, function(sender, eventType)  
            -- if i > self.day then 
            if false then 
                global.tipsMgr:showWarning("Continuous_recharge01")
            else 
                self:switchDay(i)
            end 
        end)
    end 

    self.tableView = UITableView.new()
        :setSize(self.tb_content:getContentSize(), self.day_node ,self.tb_bottom)
        :setCellSize(self.tb_item_content:getContentSize())
        :setCellTemplate(UISevenDayRechargeItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL,"UISevenDayRechargePanel")
    self.title1:setString(global.luaCfg:get_recharge_list_by(index).texct)



end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISevenDayRechargePanel:receive(sender, eventType)
    
    if  self.day then 

        global.ActivityAPI:SevenDayRechargeRewardReq(self.day , function () 

            local item = global.luaCfg:get_drop_by(self.data.reward).dropItem

            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item)

        end)

    end 
end

function UISevenDayRechargePanel:reCharge(sender, eventType)

    global.panelMgr:closePanel("UISevenDayRechargePanel")
    
    global.tipsMgr:showWarning("ItemUseDiamond")

end


function UISevenDayRechargePanel:switchDay(day)


    local data = global.luaCfg:get_daily_day_by(day)

    if day == self.day then

        -- self.gift_name:setVisible(true)
        self.time:getParent():setVisible(true)

        local needPrice = data.mony -  self.nowRecharge 
        if needPrice < 0  then 
            needPrice = 0 
        end

        global.uiMgr:setRichText(self,"tips",50219,{key1 = self.nowRecharge  , key2 = needPrice}) 
    else
        self.time:getParent():setVisible(false)
        global.uiMgr:setRichText(self,"tips",50262,{key1 = day , key2 = data.mony})    
    end

    self.discount:setString(data.percent)
    self.diaCurNum:setString(data.mony)
    self.tableView:setData(global.luaCfg:get_drop_by(data.reward).dropItem)

    if day == self.day then 

        self.togoReCharge:setVisible(self.state == 0 )
        self.receive_bt:setVisible(self.state == 1 )

        self["day_"..day].finish:setVisible(self.state == 2)

    else 
        self.togoReCharge:setVisible(false )
        self.receive_bt:setVisible(false)

    end 

    for i =1 , 7 do 
        self["day_"..i].recharge:setVisible(i==day)
    end 


end 

function UISevenDayRechargePanel:onEnter()


    self:addEventListener(global.gameEvent.EV_ON_SEVENDAYRECHARGE , function ()  --  充值之后， 会拉取直通车
        self:setData()
    end) 

    self:setData()
end 


function UISevenDayRechargePanel:gps()
    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL , "UISevenDayRechargePanel")
    self.FileNode_1.tableView:jumpToCellByIdx(index -1 , true)
end 

-- message PaySignInfo
-- {
--     required int32      lPayCnt     = 1;    //连续-7日一轮完成任务
--     required int32      lState      = 2;    //付款领取状态0为领取，1可领取，2已经领取     
--     optional int32      lDailyPay       = 3;    //今日已付款
-- }

function UISevenDayRechargePanel:setData()

    local serverData =   global.rechargeData:getSevenDayRechargeData()

    dump(serverData ,"serverData//////////////////////")

    if not serverData then 

        return 
    end 

   self.day = serverData.lPayCnt

    self.nowRecharge = serverData.lDailyPay or 0 

    self.data =global.luaCfg:get_daily_day_by(self.day)

    self.needRecharge = self.data.mony -  self.nowRecharge 

    if  self.needRecharge < 0  then 
        
        self.needRecharge = 0 
    end 

    self.endTime = serverData.endTime 

    self.state = serverData.lState

    for i= 1 , 7 do 
        local button = self["day_"..i]
        button.bg1:setVisible(i <=  self.day)
        button.bg2:setVisible(i >  self.day)
        button.finish:setVisible(i < self.day)

        -- button.Button:setTouchEnabled(not ( i > self.day ))
    end

    -- self.diaCurNum:setString(self.data.mony)
    -- global.uiMgr:setRichText(self,"tips",50219,{key1 =nowRecharge  , key2 =self.needRecharge })
    
    self:switchDay(self.day)

    if not self.timer then 
        self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime), 1)
        self:updateOverTime()

        global.tools:adjustNodeMiddle(self.time ,self.gift_name)
    end


end

function UISevenDayRechargePanel:updateOverTime()


    local time =   self.endTime - global.dataMgr:getServerTime()
    
    if time >=  0 then 

        self.time:setString( global.funcGame.formatTimeToHMS(time))

    else 
        self.time:setString("00:00:00")
    end 


end 


function UISevenDayRechargePanel:cleanTimer()

    if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 

function UISevenDayRechargePanel:onExit()

    self:cleanTimer()

end 
--CALLBACKS_FUNCS_END

return UISevenDayRechargePanel

--endregion

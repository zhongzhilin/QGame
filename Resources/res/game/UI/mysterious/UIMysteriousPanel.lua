--region UIMysteriousPanel.lua
--Author : anlitop
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMysteriousPanel  = class("UIMysteriousPanel", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIMysteriousItemCell = require("game.UI.mysterious.UIMysteriousItemCell")


function UIMysteriousPanel:ctor()
    self:CreateUI()
end

function UIMysteriousPanel:CreateUI()
    local root = resMgr:createWidget("random_shop/random_shop_bg")
    self:initUI(root)
end

function UIMysteriousPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "random_shop/random_shop_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.btn_normal = self.root.bottom_bg.btn_normal_export
    self.node_gray1 = self.root.bottom_bg.btn_normal_export.node_gray1_export
    self.btn_normal_refresh_icon = self.root.bottom_bg.btn_normal_export.btn_normal_refresh_icon_export
    self.btn_normal_refresh_cost_text = self.root.bottom_bg.btn_normal_export.btn_normal_refresh_cost_text_export
    self.btn_free = self.root.bottom_bg.btn_free_export
    self.free_number_text = self.root.bottom_bg.btn_free_export.free_number_text_export
    self.head_wealth_node = self.root.head_wealth_node_export
    self.overtime_text = self.root.reset_mlan_8.overtime_text_export
    self.layout_content = self.root.layout_content_export
    self.item_top = self.root.item_top_export
    self.item_bottom = self.root.item_bottom_export
    self.item_add_node = self.root.item_add_node_export
    self.item_content = self.root.item_content_export
    self.tips_node = self.root.tips_node_export
    self.free_reset_text = self.root.free_reset_mlan_8.free_reset_text_export

    uiMgr:addWidgetTouchHandler(self.btn_normal, function(sender, eventType) self:onCostRrfresh(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_free, function(sender, eventType) self:onFreeRefresh(sender, eventType) end)
--EXPORT_NODE_END

    self.tips_node:setLocalZOrder(1)

-- 创建TableView
self.tableView = UITableView.new()
        :setSize(self.layout_content:getContentSize(), self.item_top, self.item_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIMysteriousItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(3)
self.item_add_node:addChild(self.tableView)

uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_panel(sender, eventType) end)

local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
self.ResSetControl = ResSetControl.new(self.head_wealth_node)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function  UIMysteriousPanel:onEnter()

    self.ResSetControl:setData()

    self.ResSetControl:playAnimation(self.head_wealth_node)

    local callBB = function()

        self:RequestData(0)
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,callBB)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 

        if self.data then

             self:setData(self.data)

        end
    end)

    self:RequestData(0)

end

function  UIMysteriousPanel:onExit()

    if self.timer then

       gscheduler.unscheduleGlobal(self.timer)
       
        self.timer = nil
    end
end  


function UIMysteriousPanel:setData()

    local msg =global.MySteriousData:getTagData()

    self.data =msg

    if not msg then return end 

    local currentRefreashNumber = nil -- 当前购买次数
    self.random_shop_data ={}  -- 商品数据
    self.remainingtime    =nil -- 剩余刷时间
    self.lEndTime = nil       -- 今日结束时间戳
    self.random_shop_money  =nil -- 购买消耗金币
    if msg and msg.tgSecret then 
        self.lEndTime = msg.lEndTime

        self.lResetTime = msg.lResetTime   -- 免费次数刷新时间。 

        currentRefreashNumber = msg.tgBuyCount.lSecretShopCount+1 --服务器下标0为开始值
        local allrandom_shop = global.luaCfg:random_shop_money()
        print( currentRefreashNumber, #allrandom_shop)
        if currentRefreashNumber > #allrandom_shop then 
            currentRefreashNumber =   #allrandom_shop
        end
        if currentRefreashNumber <  0 then 
            currentRefreashNumber =   0
        end
        for i =1 , #msg.tgSecret do 
            self.random_shop_data[i] = global.luaCfg:get_random_shop_by(msg.tgSecret[i].ID)
            
            if not self.random_shop_data[i]  then return end 

            self.random_shop_data[i].information=global.luaCfg:get_local_item_by(self.random_shop_data[i].itemId)
            self.random_shop_data[i].parentRef  =self 
            self.random_shop_data[i].position  = i 
            self.random_shop_data[i].tips_node =self.tips_node
            self.random_shop_data[i].lstate  = msg.tgSecret[i].lstate
        end

        if self.refreshItemPosition then 
            self.random_shop_data[self.refreshItemPosition].isrotate = true 
            self.refreshItemPosition = nil 
        end 

        if self.isRotateAll then 
            for _ , v in pairs(self.random_shop_data) do 
                v.isrotate = true 
            end 
            self.btn_free:setTouchEnabled(false)
            self.btn_normal:setTouchEnabled(false)
            self.root:runAction(cc.Sequence:create(cc.DelayTime:create(0.4) , cc.CallFunc:create(function () 
                self.btn_free:setTouchEnabled(true)
                self.btn_normal:setTouchEnabled(true)
            end )))
            self.isRotateAll = nil
        end 

        self.random_shop_money =global.luaCfg:get_random_shop_money_by(currentRefreashNumber)
        self.remainingtime     =self.lEndTime-global.dataMgr:getServerTime()
        self:updateUI()
    end 

end 

function UIMysteriousPanel:GetFreeRefreashNumber()
    local count =   0 
    for _ ,k  in pairs( global.luaCfg:random_shop_money() )do 
        if k.cost  == 0 then 
            count =count+1
        end  
    end 
    return count
end 

function UIMysteriousPanel:getFreeNumber()
    if self.random_shop_money.cost ~= 0 then 
        return 0 
    end 
    return self:GetFreeRefreashNumber()+1-self.random_shop_money.moneyID 
end 

function UIMysteriousPanel:updateUI()
    
    self.tableView:setData(self.random_shop_data)
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipShopCount")
    if self.random_shop_money.cost == 0 or vipfreenumber >0 then 
        self.btn_free:setVisible(true)
        self.btn_normal:setVisible(false)
        local str =string.format(global.luaCfg:get_local_string(10203),self:getFreeNumber()+vipfreenumber)
        self.free_number_text:setString(str)
    else
        self.btn_free:setVisible(false)
        self.btn_normal_refresh_cost_text:setString(self.random_shop_money.cost)
        self.btn_normal:setVisible(true)
        if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) >= self.random_shop_money.cost then  -- 已开启
            self.btn_normal_refresh_cost_text:setTextColor(gdisplay.COLOR_WHITE)
        else   
            self.btn_normal_refresh_cost_text:setTextColor(gdisplay.COLOR_RED)
        end  
    end 

    if not self.timer then 
         self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime),1)
    end 

    self:updateOverTime()

end 


function UIMysteriousPanel:freeNumberOverTime()
    if  self.lResetTime  then 
        local time = self.lResetTime - global.dataMgr:getServerTime() 
        if time < 0 then 
            self:RequestData(0) 
            return 
        end 
        self.free_reset_text:setString(global.funcGame.formatTimeToHMS(time))
    end 
end 


function UIMysteriousPanel:updateOverTime()

    if not self.lEndTime then return end -- 防止报错

     self.remainingtime = self.lEndTime-global.dataMgr:getServerTime()

     if  self.remainingtime <= 0 then 

         if self.timer then

            gscheduler.unscheduleGlobal(self.timer)

            self.timer = nil
        end

        self:RequestData(0) 

     end 

     self.overtime_text:setString(global.funcGame.formatTimeToHMS(self.remainingtime))
     
     self:freeNumberOverTime()
end 

function  UIMysteriousPanel:exit_panel(sender, eventType)

        global.panelMgr:closePanel("UIMysteriousPanel")

end

function UIMysteriousPanel:onCostRrfresh(sender, eventType)

    self:RequestData(2)

end

function UIMysteriousPanel:onFreeRefresh(sender, eventType)

    self:RequestData(2)
end

function UIMysteriousPanel:RequestData(Requesttype) -- 0  拉取列表 1 购买商品 2 刷新

    local can_request =true 

    if Requesttype ==2  then 

        if self.random_shop_money and  tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) < self.random_shop_money.cost then

                 global.panelMgr:openPanel("UIRechargePanel")

                 can_request =false
        end 
    end 
    if can_request then 

        local typeId = Requesttype 

        local itemId = 0 

        global.SecretShopAPI:mysteriousReq(typeId,itemId,function(ret,msg)

            if ret.retcode == 0 then

                if typeId ==2 then

                    self.isRotateAll =true

                    if  global.vipBuffEffectData:isUseVipFreeNumber("lVipShopCount") then 

                        global.vipBuffEffectData:useVipDiverseFreeNumber("lVipShopCount",1)

                    end 
                end 

                global.MySteriousData:setData(msg)

                if self.setData then-- protect 
                    self:setData()
                end 

            end  
        end)
    end 
end 
--CALLBACKS_FUNCS_END

return UIMysteriousPanel

--endregion

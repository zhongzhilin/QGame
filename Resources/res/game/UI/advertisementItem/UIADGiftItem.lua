--region UIADGiftItem.lua
--Author : anlitop
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIADGiftItem  = class("UIADGiftItem", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UICifItemCell =  require("game.UI.gift.UICifItemCell")
local TieDiY = 65 

function UIADGiftItem:ctor()
    self:CreateUI()
end

function UIADGiftItem:CreateUI()
    local root = resMgr:createWidget("advertisement/gift_main_ui_0")
    self:initUI(root)
end



function UIADGiftItem:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "advertisement/gift_main_ui_0")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.gift_bg = self.root.gift_bg_export
    self.btn_magic_discount = self.root.btn_magic_discount_export
    self.grayBgBuy = self.root.btn_magic_discount_export.grayBgBuy_export
    self.oldPrice = self.root.btn_magic_discount_export.oldPrice_export
    self.linePic = self.root.btn_magic_discount_export.oldPrice_export.linePic_export
    self.gift_discount_newprice_text = self.root.btn_magic_discount_export.gift_discount_newprice_text_export
    self.timer_node = self.root.timer_node_export
    self.time_text = self.root.timer_node_export.time_text_mlan_3_export
    self.gitf_overtime_text = self.root.timer_node_export.gitf_overtime_text_export
    self.limitation = self.root.timer_node_export.limitation_mlan_10_export
    self.diamondNode = self.root.diamondNode_export
    self.vipNode = self.root.diamondNode_export.vipNode_export
    self.vip = self.root.diamondNode_export.vipNode_export.vip_export
    self.diaNode = self.root.diamondNode_export.diaNode_export
    self.diaCurNum = self.root.diamondNode_export.diaNode_export.diaCurNum_export
    self.diamond_icon_sprite = self.root.diamondNode_export.diaNode_export.diamond_icon_sprite_export
    self.gift_top_node = self.root.gift_top_node_export
    self.gift_bottom_node = self.root.gift_bottom_node_export
    self.gift_content_node = self.root.gift_content_node_export
    self.gift_add_node = self.root.gift_add_node_export
    self.gift_item_content_node = self.root.gift_item_content_node_export
    self.close_noe = self.root.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.close_noe_export)
    self.union_gift_text = self.root.union_gift_text_mlan_38_export
    self.gift_name = self.root.gift_name_export
    self.discount = self.root.discount_bg.discount_export
    self.discountT = self.root.discount_bg.discountT_export
    self.first = self.root.first_export
    self.freeGift = self.root.freeGift_export
    self.grayBg = self.root.freeGift_export.grayBg_export
    self.diamondBtn = self.root.diamondBtn_export
    self.grayBgDia = self.root.diamondBtn_export.grayBgDia_export
    self.diamond = self.root.diamondBtn_export.diamond_export

    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:bt_gift_discount_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_2, function(sender, eventType) self:click_to_left(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:click_to_right(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.freeGift, function(sender, eventType) self:freeGiftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.diamondBtn, function(sender, eventType) self:diamondHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    --屏幕适配
   local y = self.btn_magic_discount:convertToWorldSpace((cc.p(0,0))).y 

   if y < TieDiY then 
        self.btn_magic_discount:setPositionY(self.btn_magic_discount:getPositionY() + TieDiY-y)
   end

    if (self.gift_bottom_node:getPositionY() - 40 )  <  self.btn_magic_discount:getPositionY()  then 

        self.gift_bottom_node:setPositionY( self.btn_magic_discount:getPositionY() + 40 )
    end 

    self.union_gift_text_mlan_export =  self.union_gift_text
    self.tableView = UITableView.new()
        :setSize(self.gift_content_node:getContentSize(), self.gift_top_node, self.gift_bottom_node)
        :setCellSize(self.gift_item_content_node:getContentSize()) 
        :setCellTemplate(UICifItemCell) 
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.gift_add_node:addChild(self.tableView)

    self.close_noe:setData(function ()
        self.dropData = nil 
    global.panelMgr:closePanel("UIADGiftItem")
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


--banner
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIADGiftItem:setData(data, call)


    dump(self.data ," >>>> UIADGiftItem:setData")

    self.data = data
    self.m_call = call
    if not self.data.resource or self.data.resource =="0" then 
    else 
        self.diamond_icon_sprite:setSpriteFrame(self.data.resource)
    end 

    local strId = data.isMagic and 11177 or 11176
    self.limitation:setString(luaCfg:get_local_string(strId))
    

    if data.isDaily then
        
        self.vipNode:setPositionX(0)
        self.diaNode:setVisible(true)
        local dropDia = luaCfg:get_drop_by(data.dropid or data.drop)
        if dropDia then
            local dropTemp = dropDia.dropItem[1]
            self.diaCurNum:setString(dropTemp[2])
        end

        self.root.discount_bg:setVisible(not data.isFreeGift)
        self.limitation:setVisible(not data.isFreeGift)
        self.diamondNode:setVisible(not data.isFreeGift and not data.isMagic)
        self.union_gift_text_mlan_export:setVisible(false)
        self.first:setVisible(false)
        global.colorUtils.turnGray(self.grayBgDia, not data.isCanBuy)
        global.colorUtils.turnGray(self.grayBgBuy, not data.isCanBuy)
        global.colorUtils.turnGray(self.grayBg, not data.isCanBuy)

        self.btn_magic_discount:setVisible(not data.isFreeGift)
        self.freeGift:setVisible(data.isFreeGift)
        self.diamondBtn:setVisible(data.isMagic)
        
        self.diamond:setString(data.period or 0)
        if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, data.period) then
            self.diamond:setTextColor(gdisplay.COLOR_RED)
        else
            self.diamond:setTextColor(cc.c3b(255, 255, 255))
        end

    else

        local posX = self.data.resource_num > 0 and 0 or -180
        self.vipNode:setPositionX(posX)
        self.diaNode:setVisible(self.data.resource_num > 0)
        if self.data.id == 35 then
            self.vipNode:setPositionX(0)
            self.diaNode:setVisible(true)
        end

        self.btn_magic_discount:setVisible(true)
        self.freeGift:setVisible(false)
        self.diamondBtn:setVisible(false)
        self.diamondNode:setVisible(true)
        self.root.discount_bg:setVisible(true)
        self.diaCurNum:setString(self.data.resource_num)
        self.limitation:setVisible(self.data.id ~= self.data.buy_next_gift)

        local errcode =  0 
        if data.type  ==global.EasyDev.AD_UNION_TYPE then 
            self.union_gift_text_mlan_export:setVisible(true )

            if data.id == 56 then 
                errcode = 10920
            else 
                errcode = 10919
            end 
        else 
            if data.id == 35 then 
                self.union_gift_text_mlan_export:setVisible(false )
            else 
                errcode = 10919
            end 
        end 
        self.union_gift_text_mlan_export:setString(global.luaCfg:get_translate_string(errcode))
        self.first:setVisible(global.advertisementData.firstRechargeId == self.data.id)

    end

    if not self.data.lEndTime then
        self.data.lEndTime = data.isMagic and global.funcGame.getIntegalTimeStamp() or global.dailyTaskData:getCurZeroTime()
    end 
    self.data.time = self.data.lEndTime - global.dataMgr:getServerTime()

    self:upateUI()

    if  self.data.time >= 0 then 
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()
    end 

    global.tools:adjustNodePos(self.time_text,self.gitf_overtime_text,-10)
    self.timer_node:setVisible(not self.data.hidetimer)
    
    local vipData = global.luaCfg:get_gift_by(self.data.id)
    if vipData then
       self.vip:setString(vipData.vip_point)
    end

end 

function UIADGiftItem:upateUI()

    -- dump(self.data)

    local dropData = global.luaCfg:get_drop_by(self.data.dropid or self.data.drop).dropItem  
    
    for _  ,v in pairs(dropData) do 
        v.panel = self.data.panel  
    end 
    
    self.dropData = dropData
    self.tableView:setData(dropData)
    if self.data.banner ~= ""  and  self.data.banner then 
        -- self.gift_bg:setSpriteFrame(self.data.banner)  
        global.panelMgr:setTextureFor(self.gift_bg,self.data.banner)
    end 
    self.gift_name:setString(self.data.name)

    if self.data.isDaily and (self.data.isFreeGift or self.data.isMagic) then 
        if self.data.isMagic then
            local magicConfig = luaCfg:get_magic_gift_by(self.data.id)
            self.discount:setString(math.floor(magicConfig.period / magicConfig.price * 10))
        end
    else 
        self.oldPrice:setString(self.data.unit..self.data.price)
        self.linePic:setContentSize(cc.size(self.oldPrice:getContentSize().width, self.linePic:getContentSize().height))
        self.gift_discount_newprice_text:setString(self.data.unit..self.data.cost)
        self.discount:setString(global.advertisementData:getGiftScale(self.data.id))
    end

    global.tools:adjustNodePos(self.discount,self.discountT)

end 


function UIADGiftItem:updateOverTimeUI()

    if not self.data then 
         --protect 
        return 
    end 

    self.data.time =self.data.lEndTime - global.dataMgr:getServerTime()
    -- local curr = global.dataMgr:getServerTime()
    -- local rest = math.floor(self.lEndTime - curr)
    if  self.data.time  < 0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
        -- return
         self.data.time  = 0 
    end 
    self.gitf_overtime_text:setString(global.funcGame.formatTimeToHMS( self.data.time ))

end         


function UIADGiftItem:bt_gift_discount_buy(sender, eventType)
    -- 暂时使用魔晶模拟充值

    -- if _CPP_RELEASE == 1 then

    --     global.tipsMgr:showWarning("testPrompt")
        
    -- else

    if not self.data then return end 

    local data = clone(self.data)
    local sPanel = global.panelMgr:getPanel("UIADGiftPanel")

    if self.data.isDaily then

        if not self.data.isCanBuy then
            local server = global.dailyTaskData:getCurZeroTime() - global.dataMgr:getServerTime()
            return global.tipsMgr:showWarning("nextDayCanGet", global.funcGame.formatTimeToHMS(server))
        end

        global.sdkBridge:app_sdk_pay(self.data.id,function()
            -- body

            local drop = luaCfg:get_drop_by(data.dropid)
            local dropData = drop.dropItem[1]
            local diaNum = dropData[2]
            local curBuyTimes = 0
            if data.serverData and data.serverData.lBuyCount  then
                curBuyTimes = data.serverData.lBuyCount
            end
            local limitData = luaCfg:get_drop_by(data.limit_reward)
            if limitData and (curBuyTimes < data.limit_time) then
                diaNum =  diaNum + limitData.dropItem[1][2]
            end
            global.panelMgr:openPanel("UIItemRewardPanel"):setData( {{dropData[1], diaNum}}, true )

            global.rechargeData:refershDailyRecharge(data.id)
            gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)

            if sPanel.callfunc then
                sPanel.callfunc()
            end

        end)


    else

        global.sdkBridge:app_sdk_pay(data.id,function()
            -- body
            if not data then return end 

            if data.id == global.advertisementData.firstRechargeId then 

                local item = global.luaCfg:get_drop_by(data.dropid).dropItem
                global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )
                global.userData:setFirstPay(false)

            else 

                local item = global.luaCfg:get_drop_by(data.dropid).dropItem
                global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true)

                global.advertisementData:delDataByPosition2(data)

            end 

            if sPanel.callfunc then
                sPanel.callfunc()
            end

        end)

    end


end

function UIADGiftItem:onExit( )
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end



function UIADGiftItem:clearTouches()
    self.tableView:clearTouches()
end 


function UIADGiftItem:click_to_left(sender, eventType)

end

function UIADGiftItem:click_to_right(sender, eventType)

end

function UIADGiftItem:freeGiftHandler(sender, eventType)
    
    if not self.data then return end 

    if not self.data.isCanBuy then
        local server = global.dailyTaskData:getCurZeroTime() - global.dataMgr:getServerTime()
        return global.tipsMgr:showWarning("nextDayCanGet", global.funcGame.formatTimeToHMS(server))
    end

    local data = clone(self.data)
    global.taskApi:getRewardBag(5, function(msg)
        global.userData:updatelDailyGiftCount(global.userData:getlDailyGiftCount()-1)
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(data.drop).dropItem)
    end)
end

function UIADGiftItem:diamondHandler(sender, eventType)

    if not self.data.isCanBuy then
        local server = global.funcGame.getIntegalTimeStamp()- global.dataMgr:getServerTime()
        return global.tipsMgr:showWarning("nextDayCanGet", global.funcGame.formatTimeToHMS(server))
    end

    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, self.data.period) then 
        global.panelMgr:closePanel("UIRechargePanelDaily")
        global.panelMgr:closePanel("UIADGiftPanel")
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    local data = clone(self.data)
    global.itemApi:diamondUse(function (msg)
        -- body
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(data.dropid).dropItem)
        global.rechargeData:refershDailyRecharge(data.id, true)
        gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)
    end, 19, nil, self.data.id)
end
--CALLBACKS_FUNCS_END

return UIADGiftItem

--endregion


--region UIAdvertisementItem.lua
--Author : anlitop
--Date   : 2017/03/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAdvertisementItem  = class("UIAdvertisementItem", function() return gdisplay.newWidget() end )

function UIAdvertisementItem:ctor()
    self:CreateUI()
end

function UIAdvertisementItem:CreateUI()
    local root = resMgr:createWidget("advertisement/ad_common")
    self:initUI(root)
end

function UIAdvertisementItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "advertisement/ad_common")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.invalid_sprite = self.root.invalid_sprite_export
    self.sold_out = self.root.invalid_sprite_export.sold_out_mlan_10_export
    self.timer_Node = self.root.invalid_sprite_export.timer_Node_export
    self.invalid_overtime_text = self.root.invalid_sprite_export.timer_Node_export.invalid_overtime_text_export
    self.Button = self.root.Button_export
    self.gift_bg_sprite = self.root.gift_bg_sprite_export
    self.diaNode = self.root.gift_bg_sprite_export.diaNode_export
    self.gift_icon_sprite = self.root.gift_bg_sprite_export.diaNode_export.gift_icon_sprite_export
    self.gift_num_text = self.root.gift_bg_sprite_export.diaNode_export.gift_num_text_export
    self.gift_name_sprite = self.root.gift_bg_sprite_export.timer_Node.gift_name_sprite_export
    self.time_node2 = self.root.gift_bg_sprite_export.timer_Node.time_node2_export
    self.gift_overtime_text = self.root.gift_bg_sprite_export.timer_Node.time_node2_export.gift_overtime_text_export
    self.gift_value_sprite = self.root.gift_bg_sprite_export.gift_value_sprite_export
    self.discountT = self.root.gift_bg_sprite_export.discountT_export
    self.discount = self.root.gift_bg_sprite_export.discount_export
    self.buy_gift = self.root.gift_bg_sprite_export.buy_gift_export
    self.gift_price_text = self.root.gift_bg_sprite_export.buy_gift_export.gift_price_text_export
    self.vipNode = self.root.gift_bg_sprite_export.vipNode_export
    self.vip = self.root.gift_bg_sprite_export.vipNode_export.vip_export

    uiMgr:addWidgetTouchHandler(self.Button, function(sender, eventType) self:clickHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.buy_gift, function(sender, eventType) self:onPay(sender, eventType) end)
--EXPORT_NODE_END

    self.Button:setSwallowTouches(false)
    
    self.Button:setZoomScale(0)

    self.buy_gift:setSwallowTouches(true)

   self.invalid_sprite_export = self.root.invalid_sprite_export

--[[
   self.invalid_overtime_text:setVisible(false)
   self.timer_Node:setVisible(false)--]]
   -- self.sold_out:setVisible(false)

end

function UIAdvertisementItem:setData(data,isvalid)
     
    if not data then return end 

    self:hideUI(isvalid)

    self.isvalid =isvalid

    self.data= data

    if isvalid then 
        if not self.timer2 then 
            self.timer2 = gscheduler.scheduleGlobal(handler(self,self.overtime), 1)
        end
        self:overtime()
        return 
    end 

    if data.lEndTime then 
        self.data.alltime =self.data.lEndTime - global.dataMgr:getServerTime()
    else
        self.data.alltime  = 360 
    end   

    self:updateUI()

    self.diaNode:setVisible(self.data.resource_num and self.data.resource_num > 0)
    self.vip:setString(global.luaCfg:get_gift_by(data.id).vip_point)
    if self.data.id == 35 then
        self.diaNode:setVisible(true)
    end
    local posX = self.diaNode:isVisible() and 300 or 120
    self.vipNode:setPositionX(posX)
    global.tools:adjustNodePos(self.discount,self.discountT)

end


function UIAdvertisementItem:overtime()

    if  self.data.lEndTime == nil or  self.data.lEndTime == false  then return end 

    self.data.alltime  = self.data.lEndTime - global.dataMgr:getServerTime()
    if self.data.alltime <=1 then 
        self.data.alltime =0
        self:closeTimer()
    end 
    self.invalid_overtime_text:setString(global.funcGame.formatTimeToHMS(self.data.alltime))
end

function UIAdvertisementItem:closeTimer()
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
    if self.timer2 then
        gscheduler.unscheduleGlobal(self.timer2)
        self.timer2 = nil
    end
end 


function UIAdvertisementItem:hideUI(bool)
    if not  bool then 
        self.invalid_sprite_export:setVisible(false)
        self.gift_bg_sprite:setVisible(true)
    else 
        self.invalid_sprite_export:setVisible(true)
        self.gift_bg_sprite:setVisible(false)
    end 
end



function UIAdvertisementItem:updateUI()

    if self.data.hidetimer then 

        self.time_node2:setVisible(false)
        
        -- self.gift_name_sprite:setPositionX(-10)

    end 

    if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
    end
    self.gift_name_sprite:setString(self.data.name)
    self.gift_num_text:setString(self.data.resource_num)
    -- self.gift_value_sprite:setVisible( self.data.type)
    if self.data.resource ~= "0" and  self.data.resource ~= "" then 
        self.gift_icon_sprite:setSpriteFrame(self.data.resource)
        self.gift_icon_sprite:setScale(0.7)
    else 

    end 
    -- self.gift_bg_sprite:setSpriteFrame(self.data.ad_banner)
    global.panelMgr:setTextureFor( self.gift_bg_sprite,self.data.ad_banner)
    self.gift_price_text:setString(self.data.unit..self.data.cost)
  --  self.ad_bg_sprite:setSpriteFrame(self.data.banner)
    if  self.data.alltime >= 0 then 
         if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()
    end 

    self.discount:setString(global.advertisementData:getGiftScale(self.data.id))
end


function UIAdvertisementItem:onExit()
  self:closeTimer()
end

function UIAdvertisementItem:updateOverTimeUI()
    if not self.data then self:onExit() return end 
    self.data.alltime  = self.data.lEndTime - global.dataMgr:getServerTime()
    if self.data.alltime <=1 then 
         self.data.alltime =0
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
    end 
    -- local dayTime =  self.vip_data.alltime - self.vip_data.alltime % (24*60*60) -- 余数
    -- local remnantTime = self.vip_data.alltime % (24*60*60)
    -- local day  = dayTime / (24*60*60)
    self.gift_overtime_text:setString(global.funcGame.formatTimeToHMS(self.data.alltime))
end         


-- function UIAdvertisementItem:updatePointUI(current_number)
--   for index ,v in pairs(self.gift_point_node:getChildren())do 
--         if v:getName() == 'Image_'..current_number then 
--             global.colorUtils.turnGray(v,false)
--         else
--             global.colorUtils.turnGray(v,true) 
--         end 
--     end 
-- end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

 
function UIAdvertisementItem:bt_buy_gift(sender, eventType)
    
    if _NO_RECHARGE then 
        return global.tipsMgr:showWarning("FuncNotFinish")
    end 

    if  self.isvalid then 
        global.tipsMgr:showWarning("gift_sold_out")
        return 
    end 
    -- local temp= {} 
    -- temp.dropid = self.data.dropid
    -- temp.oldprice = self.data.price
    -- temp.newprice = self.data.cost
    -- temp.alltime = self.data.dropid
    -- temp.curDiaNum = self.data.resource_num
    -- temp.icon = self.data.resource
    self.data.time=self.data.lEndTime - global.dataMgr:getServerTime()
    local panel = global.panelMgr:openPanel("UIADGiftPanel")
    panel:setData(self.data.id)
    panel:setCallBack(handler(self.data.panel, self.data.panel.refurbish))

    global.loginApi:clickPointReport(nil,20,self.data.id,nil)
end

function UIAdvertisementItem:clickHandler(sender, eventType)
   if  self.isvalid  then 
        if  eventType == 0 then 
            global.tipsMgr:showWarning("gift_sold_out") 
        end 
        return 
    end 

    if eventType == 2 or eventType == 3  then
        if self.data  and self.data.panel then 
            if global.UIAdSlideNodeisMove  == "NOTMOVE" then 
                self:bt_buy_gift()
            end
        end 

    end
end

function UIAdvertisementItem:onPay(sender, eventType)

    if not self.data then return end 

    local data = clone(self.data)

    global.sdkBridge:app_sdk_pay(self.data.id,function()

        if data.id == global.advertisementData.firstRechargeId then 
            local item = global.luaCfg:get_drop_by(data.dropid).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )
            global.userData:setFirstPay(false)
        else 

            local item = global.luaCfg:get_drop_by(data.dropid).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true)

            global.advertisementData:delDataByPosition2(data)
        end 

    end)
end
--CALLBACKS_FUNCS_END

return UIAdvertisementItem

--endregion

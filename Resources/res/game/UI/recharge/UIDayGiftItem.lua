--region UIDayGiftItem.lua
--Author : yyt
--Date   : 2018/11/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDayGiftItem  = class("UIDayGiftItem", function() return gdisplay.newWidget() end )

function UIDayGiftItem:ctor()
    self:CreateUI()
end

function UIDayGiftItem:CreateUI()
    local root = resMgr:createWidget("recharge/meirilibao_list")
    self:initUI(root)
end

function UIDayGiftItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/meirilibao_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.giftName = self.root.bg_export.giftName_export
    self.giftIcon = self.root.bg_export.giftIcon_export
    self.disNode = self.root.bg_export.disNode_export
    self.gift_value_sprite = self.root.bg_export.disNode_export.gift_value_sprite_export
    self.discountT = self.root.bg_export.disNode_export.discountT_export
    self.discount = self.root.bg_export.disNode_export.discount_export
    self.disCountNode = self.root.bg_export.disCountNode_export
    self.vip = self.root.bg_export.disCountNode_export.vip_export
    self.limit_text = self.root.bg_export.disCountNode_export.limit_text_export
    self.gift_icon_sprite = self.root.bg_export.disCountNode_export.gift_icon_sprite_export
    self.addIcon = self.root.bg_export.disCountNode_export.addIcon_export
    self.curDia = self.root.bg_export.disCountNode_export.curDia_export
    self.buyBtn = self.root.bg_export.buyBtn_export
    self.grayBgBuy = self.root.bg_export.buyBtn_export.grayBgBuy_export
    self.oldPrice = self.root.bg_export.buyBtn_export.oldPrice_export
    self.line = self.root.bg_export.buyBtn_export.oldPrice_export.line_export
    self.curPrice = self.root.bg_export.buyBtn_export.curPrice_export
    self.freeBtn = self.root.bg_export.freeBtn_export
    self.grayBg = self.root.bg_export.freeBtn_export.grayBg_export
    self.diamondBtn = self.root.bg_export.diamondBtn_export
    self.grayBgDia = self.root.bg_export.diamondBtn_export.grayBgDia_export
    self.diamond = self.root.bg_export.diamondBtn_export.diamond_export
    self.time_node = self.root.bg_export.time_node_export
    self.time = self.root.bg_export.time_node_export.time_export

    uiMgr:addWidgetTouchHandler(self.buyBtn, function(sender, eventType) self:buyHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.freeBtn, function(sender, eventType) self:freeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.diamondBtn, function(sender, eventType) self:diamondHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    self.bg:setSwallowTouches(false)
    self.bg:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDayGiftItem:oldPriceState(oldPrice)
    
    if oldPrice <= 0 then

        self.oldPrice:setVisible(false)
        self.line:setVisible(false)
        self.curPrice:setPositionX(105)
        self.curPrice:setAnchorPoint(cc.p(0.5, 0.5))
        self.buyBtn.arrowhead:setVisible(false)
    else
        self.oldPrice:setString(global.luaCfg:get_gift_by(self.data.id).unit..oldPrice)
        self.oldPrice:setVisible(true)
        self.line:setVisible(true)
        self.curPrice:setPositionX(122)
        self.curPrice:setAnchorPoint(cc.p(0, 0.5))
        self.buyBtn.arrowhead:setVisible(true)
    end

end

function UIDayGiftItem:setData(data)

    self.data = data

    self.disNode:setVisible(not data.isFreeGift)
    self.buyBtn:setVisible(not data.isFreeGift and not data.isMagic)
    self.freeBtn:setVisible(data.isFreeGift)
    self.diamondBtn:setVisible(data.isMagic)
    self.disCountNode:setVisible(false)
    global.colorUtils.turnGray(self.grayBg, not data.isCanBuy)
    global.colorUtils.turnGray(self.grayBgBuy, not data.isCanBuy)
    global.colorUtils.turnGray(self.grayBgDia, not data.isCanBuy)
    if not data.isFreeGift then
        if data.isMagic then
            local magicConfig = luaCfg:get_magic_gift_by(data.id)
            self.discount:setString(math.floor(magicConfig.period / magicConfig.price * 10))
        else
            self.discount:setString(global.advertisementData:getGiftScale(data.id))
        end
    end

    local curBuyTimes = 0
    if data.serverData and data.serverData.lBuyCount  then
        curBuyTimes = data.serverData.lBuyCount 
    end

    if not data.isFreeGift and not data.isMagic then

        self.disCountNode:setVisible(true)
        if data.serverData and data.serverData.lMoney  then
            self:oldPriceState(data.price)
            self.curPrice:setString(global.luaCfg:get_gift_by(data.id).unit..data.cost)
        else
            self:oldPriceState(data.price)
            self.curPrice:setString(global.luaCfg:get_gift_by(data.id).unit..data.cost)
        end
        self.line:setContentSize(cc.size(self.oldPrice:getContentSize().width , self.line:getContentSize().height))

        self.vip:setString(global.luaCfg:get_gift_by(data.id).vip_point)
    
        self.gift_icon_sprite:setVisible(true)
        self.addIcon:setVisible(true)
        self.curDia:setVisible(true)

        local giftSprite = {
            [163] = "meirilibao_bg_1.png",
            [164] = "meirilibao_bg_1.png",
            [165] = "meirilibao_bg_1.png",
        }
        local giftData = global.luaCfg:get_gift_by(data.id)
        self.bg:loadTextureNormal(giftSprite[data.id],  ccui.TextureResType.plistType)
        self.bg:loadTexturePressed(giftSprite[data.id], ccui.TextureResType.plistType) 
        self.giftName:setPositionY(136.5)

    else

        self.gift_icon_sprite:setVisible(false)
        self.addIcon:setVisible(false)
        self.curDia:setVisible(false)

        local bgStr = data.isMagic and "meirilibao_bg_2.png" or "meirilibao_bg_4.png"
        self.bg:loadTextureNormal(bgStr,  ccui.TextureResType.plistType)
        self.bg:loadTexturePressed(bgStr, ccui.TextureResType.plistType) 
        self.giftName:setPositionY(86)
        self.diamond:setString(data.period or 0)

        if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, data.period) then
            self.diamond:setTextColor(gdisplay.COLOR_RED)
        else
            self.diamond:setTextColor(cc.c3b(255, 255, 255))
        end

    end

    self.giftName:setString(data.name)
    global.panelMgr:setTextureFor(self.giftIcon, data.mini_icon)

    local dropDia = luaCfg:get_drop_by(data.dropid or data.drop)
    if dropDia then
        local dropTemp = dropDia.dropItem[1]
        self.curDia:setString(dropTemp[2])
    end

    global.tools:adjustNodePos(self.giftName,self.limit_text,5)
    global.tools:adjustNodePos(self.discount,self.discountT)

    self.time_node:setVisible(false)
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
    if not data.isCanBuy and data.isMagic then
        self.lEndTime = global.funcGame.getIntegalTimeStamp()
        self.restTime = self.lEndTime  - global.dataMgr:getServerTime()
        if self.restTime > 0 then 
            self.time_node:setVisible(true)
            if not self.timer then 
                self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
            end
            self:updateOverTimeUI()
        end 
    end

end

function UIDayGiftItem:onExit()
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end 

function UIDayGiftItem:updateOverTimeUI() 

    self.restTime =self.lEndTime - global.dataMgr:getServerTime()
    if self.restTime <= 0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
        self.restTime = 0 
    end 
    self.time:setString(global.funcGame.formatTimeToHMS(self.restTime))
end  

function UIDayGiftItem:buyHandler(sender, eventType)

    if not self.data.isCanBuy then
        local server = global.dailyTaskData:getCurZeroTime() - global.dataMgr:getServerTime()
        return global.tipsMgr:showWarning("nextDayCanGet", global.funcGame.formatTimeToHMS(server))
    end

    local data = clone(self.data)
    local sPanel = global.panelMgr:getPanel("UIRechargePanel")
    global.sdkBridge:app_sdk_pay(self.data.id,function()
        -- body
        if sPanel and sPanel.callfunc then
            sPanel.callfunc()
        end
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(data.dropid).dropItem)
        global.rechargeData:refershDailyRecharge(data.id)
        gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)
    end)


end

function UIDayGiftItem:freeHandler(sender, eventType)
    
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

function UIDayGiftItem:diamondHandler(sender, eventType)

    if not self.data.isCanBuy then
        local server = global.funcGame.getIntegalTimeStamp()- global.dataMgr:getServerTime()
        return global.tipsMgr:showWarning("nextDayCanGet", global.funcGame.formatTimeToHMS(server))
    end
    
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, self.data.period) then 
        global.panelMgr:closePanel("UIRechargePanelDaily")
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

return UIDayGiftItem

--endregion

--region UIRechargeItem.lua
--Author : yyt
--Date   : 2017/03/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local rechargeData = global.rechargeData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRechargeItem  = class("UIRechargeItem", function() return gdisplay.newWidget() end )

function UIRechargeItem:ctor()
    self:CreateUI()
end

function UIRechargeItem:CreateUI()
    local root = resMgr:createWidget("recharge/recharge_node")
    self:initUI(root)
end

function UIRechargeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/recharge_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.giftName = self.root.NodeT.giftName_export
    self.buyBtn = self.root.NodeT.buyBtn_export
    self.oldPrice = self.root.NodeT.buyBtn_export.oldPrice_export
    self.line = self.root.NodeT.buyBtn_export.oldPrice_export.line_export
    self.curPrice = self.root.NodeT.buyBtn_export.curPrice_export
    self.quite = self.root.NodeT.quite_export
    self.giftIcon = self.root.NodeT.quite_export.giftIcon_export
    self.limitNode = self.root.NodeT.limitNode_export
    self.limit_text = self.root.NodeT.limitNode_export.limit_text_export
    self.limit_pic = self.root.NodeT.limitNode_export.limit_pic_export
    self.extraText = self.root.NodeT.limitNode_export.extraText_mlan_4_export
    self.extraDia = self.root.NodeT.limitNode_export.extraDia_export
    self.curDia = self.root.curDia_export
    self.gift_icon_sprite = self.root.gift_icon_sprite_export
    self.vip = self.root.vip_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.buyBtn, function(sender, eventType) self:buyHandler(sender, eventType) end, true)
    self.buyBtn:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIRechargeItem:oldPriceState(oldPrice)
    
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

function UIRechargeItem:setData(data)

    self.data = data
    -- dump(data)
    local curBuyTimes = 0
    if data.serverData and data.serverData.lMoney  then
        self:oldPriceState(data.price)
        self.curPrice:setString(global.luaCfg:get_gift_by(data.id).unit..data.cost)
        curBuyTimes = data.serverData.lBuyCount 
    else
        self:oldPriceState(data.price)
        self.curPrice:setString(global.luaCfg:get_gift_by(data.id).unit..data.cost)
    end

    self.giftName:setString(data.name)
    self.line:setContentSize(cc.size(self.oldPrice:getContentSize().width , self.line:getContentSize().height))
    -- self.giftIcon:setSpriteFrame(data.ad_banner)
    global.panelMgr:setTextureFor(self.giftIcon,data.ad_banner)

    local dropDia = luaCfg:get_drop_by(data.dropid)
    if dropDia then
        local dropTemp = dropDia.dropItem[1]
        self.curDia:setString(dropTemp[2])
    end

    -- 限购礼包
    local limitData = luaCfg:get_drop_by(data.limit_reward)
    if limitData and (curBuyTimes < data.limit_time) then
        
        self.limitNode:setVisible(true)
        local dropData = limitData.dropItem[1]
        self.extraDia:setString(dropData[2])
        self.extraDia:setPositionX(self.extraText:getPositionX()+self.extraText:getContentSize().width+10)
        -- self.limit_text:setString(luaCfg:get_local_string(10463, (data.limit_time - curBuyTimes)))
        self.limit_text:setString(luaCfg:get_local_string(11170))
    else
        self.limitNode:setVisible(false)
    end

    self.vip:setString(global.luaCfg:get_gift_by(data.id).vip_point)

    global.tools:adjustNodePos(self.get_text,self.curDia,10)
    global.tools:adjustNodePos(self.extraText,self.extraDia,50)
    global.tools:adjustNodePos(self.giftName,self.limit_text,20)


end

function UIRechargeItem:buyHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIRechargePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end

        global.sdkBridge:app_sdk_pay(self.data.id,function()
            -- body
            if sPanel.callfunc then
                sPanel.callfunc()
            end

            -- 购买魔晶数
            local drop = luaCfg:get_drop_by(self.data.dropid)
            local dropData = drop.dropItem[1]
            local diaNum = dropData[2]
            local curBuyTimes = 0
            if self.data.serverData and self.data.serverData.lMoney  then
                curBuyTimes = self.data.serverData.lBuyCount
            end
            local limitData = luaCfg:get_drop_by(self.data.limit_reward)
            if limitData and (curBuyTimes < self.data.limit_time) then
                diaNum =  diaNum + limitData.dropItem[1][2]
            end
            global.panelMgr:openPanel("UIItemRewardPanel"):setData( {{dropData[1], diaNum}}, true )


            rechargeData:refershRecharge(self.data.id)
            self:setData(rechargeData:getChargeById(self.data.id))          

        end)


        -- if _CPP_RELEASE == 1 then
            
        --     global.tipsMgr:showWarning("testPrompt")

        -- else
        --     --暂时使用魔晶模拟充值
        --     global.itemApi:diamondUse(function (msg)
                

        --     end, 100, self.data.id)
        -- end

    end

end



--CALLBACKS_FUNCS_END

return UIRechargeItem

--endregion

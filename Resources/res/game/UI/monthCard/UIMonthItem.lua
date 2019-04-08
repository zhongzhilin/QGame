--region UIMonthItem.lua
--Author : yyt
--Date   : 2017/03/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local rechargeData = global.rechargeData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonthItem  = class("UIMonthItem", function() return gdisplay.newWidget() end )
local UIBagItem = require("game.UI.bag.UIBagItem")
local UIMonthListItem = require("game.UI.monthCard.UIMonthListItem")

function UIMonthItem:ctor()
    self:CreateUI()
end

function UIMonthItem:CreateUI()
    local root = resMgr:createWidget("month_card_ui/month_card_cell")
    self:initUI(root)
end

function UIMonthItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "month_card_ui/month_card_cell")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.node.bg_export
    self.topBg = self.root.node.topBg_export
    self.onceBg = self.root.node.onceBg_export
    self.card = self.root.node.card_export
    self.title = self.root.node.title_export
    self.discountBg = self.root.node.discountBg_export
    self.buyBtn = self.root.node.buyBtn_export
    self.price = self.root.node.buyBtn_export.price_export
    self.getBtn = self.root.node.getBtn_export
    self.getText = self.root.node.getBtn_export.getText_export
    self.discount = self.root.node.discount_export
    self.scrollView1 = self.root.node.scrollView1_export
    self.scrollView2 = self.root.node.scrollView2_export
    self.functionBg = self.root.node.functionBg_export
    self.functionText = self.root.node.functionBg_export.functionText_export
    self.timeNode = self.root.node.timeNode_export
    self.time = self.root.node.timeNode_export.time_export
    self.vip = self.root.node.vip_export

    uiMgr:addWidgetTouchHandler(self.buyBtn, function(sender, eventType) self:buyHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.getBtn, function(sender, eventType) self:getHander(sender, eventType) end, true)
--EXPORT_NODE_END
    self.buyBtn:setSwallowTouches(false)
    self.getBtn:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMonthItem:onEnter()
    -- self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE_SUCCESS, function ()
    --     self:setData(rechargeData:getMonthById(self.data.id))
    -- end)
end

local uiConfig = {
    [1] = {bg="month_new02.png", topBg="month_new04.png", onceBg="month_new10.png", card="month_new06.png", 
    discountBg="ui_surface_icon/hero_discount4.png", functionBg="month_new16.png",  textColor=cc.c3b(225, 208, 65), out=cc.c4b(124,67,8,255),},
    [2] = {bg="month_new03.png", topBg="month_new05.png", onceBg="month_new11.png", card="month_new07.png", 
    discountBg="ui_surface_icon/hero_discount6.png", functionBg="month_new17.png", textColor=cc.c3b(90, 221, 225), out=cc.c4b(6,51,113,255),},
}
function UIMonthItem:setData(data)
    
    -- 月卡周卡区分
    local idx = data.receive_time == 30 and 1 or 2
    self.data = data
    self.bg:setSpriteFrame(uiConfig[idx].bg)
    self.topBg:loadTexture(uiConfig[idx].topBg, ccui.TextureResType.plistType)
    self.onceBg:setSpriteFrame(uiConfig[idx].onceBg)
    self.card:setSpriteFrame(uiConfig[idx].card)
    self.title:setString(data.name) 
    self.title:setTextColor(uiConfig[idx].textColor)
    self.discountBg:setSpriteFrame(uiConfig[idx].discountBg)
    self.functionBg:setSpriteFrame(uiConfig[idx].functionBg)
    self.functionText:setString(data.describe)
    self.functionText:setTextColor(uiConfig[idx].textColor)
    self.functionText:enableOutline(uiConfig[idx].out,2)

    local monthData = global.rechargeData:getMonthById(data.id)
    self.monthData = monthData

    self.buyBtn:setVisible(monthData.serverData.lState == -1)
    self.getBtn:setVisible(monthData.serverData.lState > -1)
    self.timeNode:setVisible(monthData.serverData.lState >-1)
    self.timeNode:setString(global.luaCfg:get_local_string(10874))
    self.price:setString(monthData.unit .. monthData.cost)
    self.vip:setString(data.vip_point)

    local strId = monthData.serverData.lState == 1 and 10997 or 10488
    self.getText:setString(global.luaCfg:get_local_string(strId))

    local dropId = monthData.limit_reward
    self.scrollView1:removeAllChildren()
    for i, v in ipairs(global.luaCfg:get_drop_by(dropId).dropItem) do
        local item  = require("game.UI.activity.sevendays.UIItem").new()
        self.scrollView1:addChild(item)
        local data = {}
        data.scale = 0.6
        data.data = global.luaCfg:get_local_item_by(v[1])
        data.tips_panel = self
        data.number = v[2]
        item:setData(data)
        item:setPosition(cc.p((i-1)*75,0))
    end 
    self.scrollView1:setInnerContainerSize(cc.size(75*(#global.luaCfg:get_drop_by(dropId).dropItem), self.scrollView1:getContentSize().height))
    self.scrollView1:jumpToLeft()

    local scroContentH = self.scrollView2:getContentSize().height
    local dropId = monthData.dropid
    local scroH = 70*#(global.luaCfg:get_drop_by(dropId).dropItem)
    if scroH < scroContentH then
        scroH = scroContentH
    end
    self.scrollView2:setInnerContainerSize(cc.size(self.scrollView2:getContentSize().width, scroH))
    self.scrollView2:removeAllChildren()
    for i, v in ipairs(global.luaCfg:get_drop_by(dropId).dropItem) do

        local item  = UIMonthListItem.new()
        self.scrollView2:addChild(item)
        if idx == 1 then 
            item.blue:setVisible(false)
            item.yellow:setVisible(true)
        else 
            item.blue:setVisible(true)
            item.yellow:setVisible(false)
        end 
        item:setData(v)
        item:setPosition(cc.p(0, scroH-i*70))
    end 
    
    self.scrollView2:jumpToTop()

    local updateTime = function () 
        if monthData.serverData.lState > -1 and  monthData.serverData.lEnd  then 
            local time = monthData.serverData.lEnd - global.dataMgr:getServerTime()
            self.time:setString(global.vipBuffEffectData:getDayTime(time))
            global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
        end
    end
    updateTime()
    global.netRpc:delHeartCall(self)
    global.netRpc:addHeartCall(function() updateTime() end ,self)


end

function UIMonthItem:onExit()
    global.netRpc:delHeartCall(self)
end

function UIMonthItem:dealCall()

    local data = clone(self.monthData)
    local buyCall = function ()
        global.sdkBridge:app_sdk_pay(data.id,function()
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(data.limit_reward).dropItem or {} , true)
            rechargeData:refershMonthCard(data.id)
            global.tipsMgr:showWarning(global.luaCfg:get_local_string(10462, data.name))
        end)
    end

    local renewals = function () 
        global.sdkBridge:app_sdk_pay(data.id,function()
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(data.limit_reward).dropItem or {} , true)
            global.tipsMgr:showWarning(global.luaCfg:get_local_string(10462, data.name))
        end)
    end 

    local rewordCall = function () 
        global.rechargeApi:getMonthReward(function (msg)
            rechargeData:refershMonthCard(data.id)
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(self:changeItem(msg.tgItems), true)
        end, 1, data.id)
    end 

    if data.serverData.lState == -1 then --激活
        buyCall()
    elseif data.serverData.lState == 0  then -- 领取
        rewordCall()
    elseif data.serverData.lState == 1 then 

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("WEEK_CARD_RENEW_1", function()
            renewals()
        end)
    end

end 

function UIMonthItem:changeItem(tagItems)
    
    tagItems = tagItems or {}
    local data = {}
    for _,v in pairs(tagItems) do
        local tb = {}
        tb[1] = v.lID
        tb[2] = v.lCount
        table.insert(data, tb)
    end
    return data
end

function UIMonthItem:buyHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIMonthCardPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end
        self:dealCall()
    end

end

function UIMonthItem:getHander(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIMonthCardPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end
        self:dealCall()
    end

end
--CALLBACKS_FUNCS_END

return UIMonthItem

--endregion

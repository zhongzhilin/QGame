--region UIFirRechargePanel.lua
--Author : wuwx
--Date   : 2017/07/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFirRechargePanel  = class("UIFirRechargePanel", function() return gdisplay.newWidget() end )

function UIFirRechargePanel:ctor()
    self:CreateUI()
end

function UIFirRechargePanel:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/first_recharge_panel")
    self:initUI(root)
end

function UIFirRechargePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/first_recharge_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.ps_node = self.root.ps_node_export
    self.btn_magic_discount = self.root.btn_magic_discount_export
    self.num = self.root.btn_magic_discount_export.num_export
    self.discount = self.root.discount_bg.discount_export
    self.discountT = self.root.discount_bg.discountT_export
    self.text_rich = self.root.text_rich_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export
    self.vipNode = self.root.vipNode_export
    self.vip = self.root.vipNode_export.vip_export

    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:bt_gift_discount_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.top.Button_1, function(sender, eventType) self:btn_exit(sender, eventType) end)
--EXPORT_NODE_END

    local UITableView =  require("game.UI.common.UITableView")
    local UIFirRechargeCell = require("game.UI.activity.firRecharge.UIFirRechargeCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIFirRechargeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.accTipsNode = cc.Node:create()
    self.root:addChild(self.accTipsNode,10)

    self:adapt()
end

function UIFirRechargePanel:adapt()

    local sHeight =(gdisplay.height - 75 - self.ps_node:getPositionY())
    local defY = self.bg:getContentSize().height
    
    if sHeight < defY then 

    else
        -- local tt =sHeight  - defY
        local scale = sHeight /defY 
        self.bg:setScale(scale)
    end 

end 

function UIFirRechargePanel:onEnter()

    local nodeTimeLine = resMgr:createTimeline("activity/recharge_activity/first_recharge_panel")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)
end

function UIFirRechargePanel:onExit()
end

function UIFirRechargePanel:setData(data)
    self.data = global.luaCfg:get_gift_by(35)

    uiMgr:setRichText(self, "text_rich", 50098, {diamond=self.data.describe})
    self.discount:setString(global.advertisementData:getGiftScale(self.data.id))

    self.num:setString(self.data.unit..self.data.cost)

    local tData = global.luaCfg:get_drop_by(self.data.dropid)
    tData.dropItem[#tData.dropItem][4] = true
    self.tableView:setData(tData.dropItem)
    self.vip:setString(self.data.vip_point)
    global.tools:adjustNodePos(self.discount,self.discountT)
    
end

local UILongTipsControl = require("game.UI.common.UILongTipsControl")
function UIFirRechargePanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_item_by(itemId)})

    return m_TipsControl
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIFirRechargePanel:bt_gift_discount_buy(sender, eventType)
    global.sdkBridge:app_sdk_pay(self.data.id,function()
        global.panelMgr:closePanel("UIFirRechargePanel")

        local data = {}
        local tData = global.luaCfg:get_drop_by(self.data.dropid)
        for i,v in ipairs(tData.dropItem) do
            table.insert(data,{v[1],v[2]})
        end

        local exitCall= function() 
            local heroId = global.luaCfg:get_gift_by(35).limit_reward
            if heroId then 
                global.panelMgr:openPanel("UIGotHeroPanel"):setData(global.heroData:getHeroPropertyById(heroId))
            end 
        end 

        global.panelMgr:openPanel("UIItemRewardPanel"):setData( data, true ,exitCall)
        global.userData:setFirstPay(false)
    end)
end

function UIFirRechargePanel:btn_exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIFirRechargePanel")
end
--CALLBACKS_FUNCS_END

return UIFirRechargePanel

--endregion

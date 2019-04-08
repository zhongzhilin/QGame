--region UIUShopPanel.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local RmbWidget = require("game.UI.commonUI.widget.RmbWidget")
--REQUIRE_CLASS_END

local UIUShopPanel  = class("UIUShopPanel", function() return gdisplay.newWidget() end )
local UIUShopItemACell = require("game.UI.union.second.shop.UIUShopItemACell")
local UIUShopItemBCell = require("game.UI.union.second.shop.UIUShopItemBCell")

function UIUShopPanel:ctor()
    self:CreateUI()
end

function UIUShopPanel:CreateUI()
    local root = resMgr:createWidget("union/union_shop_bj")
    self:initUI(root)
end

function UIUShopPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_shop_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node_tableView = self.root.node_tableView_export
    self.union_shop_top = self.root.union_shop_top_export
    self.capital = self.root.union_shop_top_export.capital_mlan_5.capital_export
    self.boom = self.root.union_shop_top_export.boom_mlan_5.boom_export
    self.node_tab = self.root.node_tab_export
    self.reset1_info = self.root.btn_bj.reset1_info_mlan_8_export
    self.reset1 = self.root.btn_bj.reset1_info_mlan_8_export.reset1_export
    self.reset2_info = self.root.btn_bj.reset2_info_mlan_8_export
    self.reset2 = self.root.btn_bj.reset2_info_mlan_8_export.reset2_export
    self.itemLayout_1 = self.root.itemLayout_1_export
    self.itemLayout_2 = self.root.itemLayout_2_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.title = self.root.title_export
    self.FileNode_2 = RmbWidget.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.btn_bj.btn_record, function(sender, eventType) self:onOpenRecord(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UITableView = require("game.UI.common.UITableView")
    self.tableView1 = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout_1:getContentSize())
        :setCellTemplate(UIUShopItemACell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(2)
    self.node_tableView:addChild(self.tableView1)

    self.tableView2 = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout_2:getContentSize())
        :setCellTemplate(UIUShopItemBCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView2)

   self.tips_node = self.root.tips_node_export

    local TabControl = require("game.UI.common.UITabControl")
    self.tabControl = TabControl.new(self.node_tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))
end

function UIUShopPanel:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIUShopPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUShopPanel")
end

function UIUShopPanel:onEnter()
    self.tgGoods = {}
    self.lEndTime = -1

    self:setData()

    self.tabControl:setSelectedIdx(1)
    self:refresh()

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_SHOP, function(event)
        self:refresh(nil,true)
    end)
end

function UIUShopPanel:setData(index,noReset)

    self.reset1_info:setVisible(false)
    self.reset2_info:setVisible(false)
    if index == 1 then
        self.reset1_info:setVisible(true)
        self.root.btn_bj.btn_record:setVisible(true)
    else
        self.reset2_info:setVisible(true)
        self.root.btn_bj.btn_record:setVisible(false)
    end
    for _ ,v in pairs(self.tgGoods) do 
        v.tips_node = self.tips_node
    end 
    if index == 1 then
        self.tableView1:setData(self.tgGoods,noReset)
        self.tableView2:setData({},noReset)
    else
        self.tableView1:setData({},noReset)
        self.tableView2:setData(self.tgGoods,noReset)
    end

    self.capital:setString(global.userData:getlAllyStrong())
    self.boom:setString(string.format("%s/%s",global.unionData:getInUnionStrong(),global.unionData:getInUnionMaxStrong()))

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

--润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.capital:getParent(),self.capital)
    global.tools:adjustNodePosForFather(self.boom:getParent(),self.boom)
    global.tools:adjustNodePosForFather(self.reset2:getParent(),self.reset2)
    

end

local luaCfg = global.luaCfg
function UIUShopPanel:refresh(index,noReset)
    local index = index or self.tabControl:getSelectedIdx()
    global.unionApi:getAllyShop(function(msg)
        -- body
        self.tgGoods=msg.tgGoods or {}
        -- if not self.tgGoods then
        --     self.tgGoods = {}
        -- end
        -- table.assign(self.tgGoods,msg.tgGoods)
        self.lEndTime = msg.lEndTime or -1
        table.sort( self.tgGoods, function(a,b)
            -- body
            return luaCfg:get_union_shop_by(a.lID).array < luaCfg:get_union_shop_by(b.lID).array
        end )

        if self.setData then
            self:setData(index,noReset)
        end
        if global.panelMgr:isPanelOpened("UIUShopBuyPanel") then
            global.panelMgr:closePanel("UIUShopBuyPanel")
        end
    end,index)
end

function UIUShopPanel:onTabButtonChanged(index)

    self:refresh(index)
end

function UIUShopPanel:countDownHandler(dt)
    
    if not self.reset1 then return end
    self.lEndTime = self.lEndTime or 0
    if self.lEndTime <= 0 then
        self.reset1:setString("")
        self.reset2:setString("")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lEndTime - curr
    self.reset1:setString(global.funcGame.formatTimeToHMS(rest))
    self.reset2:setString(global.funcGame.formatTimeToHMS(rest))
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        global.tipsMgr:showWarning("Unionshop04")
        self:refresh()
    end
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUShopPanel:onOpenRecord(sender, eventType)
    global.panelMgr:openPanel("UIUShopRecordPanel")
end
--CALLBACKS_FUNCS_END

return UIUShopPanel

--endregion

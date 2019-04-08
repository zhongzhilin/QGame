--region UIUnionForeignPanel.lua
--Author : wuwx
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionForeignPanel  = class("UIUnionForeignPanel", function() return gdisplay.newWidget() end )

function UIUnionForeignPanel:ctor()
    self:CreateUI()
end

function UIUnionForeignPanel:CreateUI()
    local root = resMgr:createWidget("union/union_foreign_bg")
    self:initUI(root)
end

function UIUnionForeignPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_foreign_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.spReadState = self.root.btn_bj.establish.spReadState_export
    self.num = self.root.btn_bj.establish.spReadState_export.num_export
    self.node_tableView = self.root.node_tableView_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.no = self.root.no_mlan_15_export

    uiMgr:addWidgetTouchHandler(self.root.btn_bj.change, function(sender, eventType) self:newHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.establish, function(sender, eventType) self:openSpHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UITableView = require("game.UI.common.UITableView")
    local UIUnionForeignItemECell = require("game.UI.union.second.foreign.UIUnionForeignItemECell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionForeignItemECell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUnionForeignPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUnionForeignPanel")
end

function UIUnionForeignPanel:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)
end

function UIUnionForeignPanel:onEnter()
    self.tgFriends = {}
    self.tgEnemys = {}
    self.tgOther = {}
    self.all = {}

    self:setData()
    self:refresh()

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_FOREIGN_PANEL, function(event)
        self:refresh()
    end)
end

function UIUnionForeignPanel:setData()
    self.spReadState:setVisible(false)
    self.no:setVisible(true)

    if self.tgRelations then
        self.tableView:setData(self.tgRelations)
        self.no:setVisible(#self.tgRelations <= 0)
    end

    if self.tgPasRelations and #self.tgPasRelations > 0 then
        if global.unionData:isHadPower(23) then
            self.spReadState:setVisible(true)
        end
        self.num:setString(#self.tgPasRelations)

        global.unionData:setInUnionRed(4,#self.tgPasRelations)
    else
        global.unionData:setInUnionRed(4,0)
    end
end

function UIUnionForeignPanel:refresh()
    global.unionApi:getAllyRelationList(function(msg)
        -- body
        self.tgRelations = msg.tgRelations or {}
        self.tgPerRelations = msg.tgPerRelations or {}
        self.tgPasRelations = msg.tgPasRelations or {}

        for i,v in ipairs(self.tgPerRelations) do
            v.isMineUnion = true
        end
        for i,v in ipairs(self.tgPasRelations) do
            v.isMineUnion = false
        end
        self.apply = {}
        table.insertto(self.apply,self.tgPasRelations)
        table.insertto(self.apply,self.tgPerRelations)

        self:setData()

        if global.panelMgr:isPanelOpened("UIUnionForeignHandlePanel") then
            global.panelMgr:getPanel("UIUnionForeignHandlePanel"):setData()
        end
    end)
end

function UIUnionForeignPanel:getTgPerRelations()
    return self.apply,self.tgPasRelations
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionForeignPanel:newHandler(sender, eventType)
    if not global.unionData:isHadPower(23) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    local panel = global.panelMgr:openPanel("UIUnionPanel")
    panel:setInputMode(1)
    panel:setData()
end

function UIUnionForeignPanel:openSpHandler(sender, eventType)
    if not global.unionData:isHadPower(23) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    global.panelMgr:openPanel("UIUnionForeignHandlePanel"):setData(self.data)
end
--CALLBACKS_FUNCS_END

return UIUnionForeignPanel

--endregion

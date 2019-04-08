--region UIUWarRecordsPanel.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarRecordsPanel  = class("UIUWarRecordsPanel", function() return gdisplay.newWidget() end )

function UIUWarRecordsPanel:ctor()
    self:CreateUI()
end

function UIUWarRecordsPanel:CreateUI()
    local root = resMgr:createWidget("union/union_battle_record")
    self:initUI(root)
end

function UIUWarRecordsPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_record")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local UITableView = require("game.UI.common.UITableView")
    local UIUWarRecordCell = require("game.UI.union.second.war.UIUWarRecordCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUWarRecordCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUWarRecordsPanel:onEnter()
    self.tableView:setData({})
    self:refresh()
end

function UIUWarRecordsPanel:setData(data)
    self.tableView:setData(data)
end

function UIUWarRecordsPanel:refresh()
    local function callback(msg)
        self.data = msg.tgRecord or {}
        self:setData(self.data)
    end
    global.unionApi:getAllyWarRecord(callback)
end

function UIUWarRecordsPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUWarRecordsPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUWarRecordsPanel

--endregion

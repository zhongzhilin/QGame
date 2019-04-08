--region UIUnionForeignHandlePanel.lua
--Author : wuwx
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionForeignHandlePanel  = class("UIUnionForeignHandlePanel", function() return gdisplay.newWidget() end )

function UIUnionForeignHandlePanel:ctor()
    self:CreateUI()
end

function UIUnionForeignHandlePanel:CreateUI()
    local root = resMgr:createWidget("union/union_foreign_apply_bg")
    self:initUI(root)
end

function UIUnionForeignHandlePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_foreign_apply_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.boom = self.root.boom_mlan_15_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export
    self.no = self.root.no_mlan_15_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UITableView = require("game.UI.common.UITableView")
    local UIUnionForeignItemACell = require("game.UI.union.second.foreign.UIUnionForeignItemACell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionForeignItemACell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUnionForeignHandlePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUnionForeignHandlePanel")
end

function UIUnionForeignHandlePanel:setData()
    self.data,self.tgPasRelations = global.panelMgr:getPanel("UIUnionForeignPanel"):getTgPerRelations()

    self.boom:setString(global.luaCfg:get_local_string(10328,0))
    self.no:setVisible(true)
    if self.data then
        self.tableView:setData(self.data)
        self.no:setVisible(#self.data <= 0)
        self.boom:setString(global.luaCfg:get_local_string(10328,#self.tgPasRelations))
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionForeignHandlePanel

--endregion

--region UIUnionMgrPanel.lua
--Author : wuwx
--Date   : 2016/12/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionMgrPanel  = class("UIUnionMgrPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIUnionBtnCell = require("game.UI.union.list.UIUnionBtnCell")

function UIUnionMgrPanel:ctor()
    self:CreateUI()
end

function UIUnionMgrPanel:CreateUI()
    local root = resMgr:createWidget("union/union_manage")
    self:initUI(root)
end

function UIUnionMgrPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_manage")

-- do not edit code in this region!!!! 
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export

--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionBtnCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)
    self.node_tableView:addChild(self.tableView)

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

function UIUnionMgrPanel:onEnter()
    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_POWER, function(event)
        self:setData(true)
    end)
    self:setData()
end
function UIUnionMgrPanel:onExit()
end

function UIUnionMgrPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUnionMgrPanel")
end

function UIUnionMgrPanel:setData(noReset)
    local data = global.unionData:getMgrBtns(global.unionData:getInUnionMemlRole())
    self.tableView:setData(data,noReset)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionMgrPanel

--endregion

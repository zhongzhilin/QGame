--region UIOccupyPanel.lua
--Author : untory
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
local UITableView = require("game.UI.common.UITableView")
local UIOccupyItemCell = require("game.UI.world.occupyList.UIOccupyItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOccupyPanel  = class("UIOccupyPanel", function() return gdisplay.newWidget() end )

function UIOccupyPanel:ctor()
    self:CreateUI()
end

function UIOccupyPanel:CreateUI()
    local root = resMgr:createWidget("world/occupy_bj")
    self:initUI(root)
end

function UIOccupyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/occupy_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleNode = self.root.titleNode_export
    self.topNode = self.root.topNode_export
    self.tbsize = self.root.tbsize_export
    self.itsize = self.root.itsize_export
    self.no = self.root.no_mlan_18_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize(),self.topNode)
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIOccupyItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self:addChild(self.tableView)
end

function UIOccupyPanel:onEnter()
  
    self.no:setVisible(#global.occupyData:getList() == 0)

    self.tableView:setData(global.occupyData:getList())

    local callBB = function(event, isRefersh)

        self.no:setVisible(#global.occupyData:getList() == 0)
        self.tableView:setData(global.occupyData:getList())
    end
    
    self:addEventListener(gameEvent.EV_ON_UI_OCCUPY_FLUSH,callBB)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIOccupyPanel:exit_call()
    
    global.panelMgr:closePanelForBtn("UIOccupyPanel")
end

--CALLBACKS_FUNCS_END

return UIOccupyPanel

--endregion

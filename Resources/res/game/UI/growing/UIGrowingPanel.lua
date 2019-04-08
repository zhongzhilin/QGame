--region UIGrowingPanel.lua
--Author : zzl
--Date   : 2018/02/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGrowingPanel  = class("UIGrowingPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UILeisureCell = require("game.UI.growing.UIGrowingItemCell")
function UIGrowingPanel:ctor()
    self:CreateUI()
end

function UIGrowingPanel:CreateUI()
    local root = resMgr:createWidget("growing_up/growing_up_panel")
    self:initUI(root)
end

function UIGrowingPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "growing_up/growing_up_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.top = self.root.Node_export.top_export
    self.bottom = self.root.Node_export.bottom_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.table_node = self.root.Node_export.table_node_export
    self.noShow = self.root.Node_export.noShow_mlan_10_export
    self.power = self.root.Node_export.noShow_mlan_10_export.power_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Panel_2, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top, self.bottom)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UILeisureCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGrowingPanel:onEnter()

    local nodeTimeLine =resMgr:createTimeline("growing_up/growing_up_panel")
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)

    self:setData()
    local callBB = function()
        self.prePower = global.userData:getPower()
        self.power:setString(self.prePower) 

        global.tools:adjustNodePosForFather(self.power:getParent() , self.power)
    end
    callBB()
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,callBB)

end 

function UIGrowingPanel:onEixt()
    
end 

function UIGrowingPanel:setData()

    self.tableView:setData(global.luaCfg:combat_up())

end 

function UIGrowingPanel:exit(sender, eventType)

    global.panelMgr:closePanelForBtn("UIGrowingPanel")
    
end

--CALLBACKS_FUNCS_END

return UIGrowingPanel

--endregion

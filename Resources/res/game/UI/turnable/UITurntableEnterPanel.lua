--region UITurntableEnterPanel.lua
--Author : anlitop
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UITurntableEnterPanel  = class("UITurntableEnterPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UITurntableFirItemCell = require("game.UI.turnable.UITurntableFirItemCell")

function UITurntableEnterPanel:ctor()
    self:CreateUI()
end

function UITurntableEnterPanel:CreateUI()
    local root = resMgr:createWidget("turntable/truntable_bj")
    self:initUI(root)
end

function UITurntableEnterPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/truntable_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_node = self.root.title_node_export
    self.FileNode_2 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.table_node = self.root.table_node_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.FileNode_2)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UITurntableFirItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)


    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType)  
        global.panelMgr:closePanel("UITurntableEnterPanel")
    end)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITurntableEnterPanel:onEnter()

    self:setData()
end 

function UITurntableEnterPanel:setData()
    
    self.tableView:setData(global.luaCfg:turntable_list())

end 

function UITurntableEnterPanel:gps()
    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL , "UISevenDayRechargePanel")
    self.FileNode_1.tableView:jumpToCellByIdx(index -1 , true)
end 

--CALLBACKS_FUNCS_END

return UITurntableEnterPanel

--endregion

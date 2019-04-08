--region BuildInfo6.lua
--Author : yyt
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildInfo6  = class("BuildInfo6", function() return gdisplay.newWidget() end )
local InfoNodeCell = require("game.UI.city.detail.widget.InfoNodeCell")

function BuildInfo6:ctor()
    self:CreateUI()
end

function BuildInfo6:CreateUI()
    local root = resMgr:createWidget("city/building_info_6line")
    self:initUI(root)
end

function BuildInfo6:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building_info_6line")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name1 = self.root.name1_export
    self.name2 = self.root.name2_export
    self.name3 = self.root.name3_export
    self.name4 = self.root.name4_export
    self.node_tableView = self.root.node_tableView_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemLayout = self.root.itemLayout_export

--EXPORT_NODE_END
    local UITableView = require("game.UI.common.UITableView")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(InfoNodeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function BuildInfo6:setData( data )
    InfoNodeCell.nodeIdx = 6
    self.data = data
    self.name1:setString(data[1].typePara1)
    self.name2:setString(data[1].typePara2)
    self.name3:setString(data[1].typePara3)
    self.name4:setString(data[1].typePara4)
    self.tableView:setData(self.data)
end

--CALLBACKS_FUNCS_END

return BuildInfo6

--endregion

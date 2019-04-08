--region BuildInfo3.lua
--Author : yyt
--Date   : 2016/10/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildInfo3  = class("BuildInfo3", function() return gdisplay.newWidget() end )
local InfoNodeCell = require("game.UI.city.detail.widget.InfoNodeCell")

function BuildInfo3:ctor()
    self:CreateUI()
end

function BuildInfo3:CreateUI()
    local root = resMgr:createWidget("city/building_info_3line")
    self:initUI(root)
end

function BuildInfo3:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building_info_3line")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.name_export
    self.itemLayout = self.root.itemLayout_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.node_tableView = self.root.node_tableView_export

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

function BuildInfo3:setData( data )
    InfoNodeCell.nodeIdx = 3

    self.data = data
    self.name:setString(data[1].typePara1)
    self.tableView:setData(self.data)
end

--CALLBACKS_FUNCS_END

return BuildInfo3

--endregion

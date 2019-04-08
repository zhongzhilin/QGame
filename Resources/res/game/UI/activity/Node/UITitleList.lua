--region UITitleList.lua
--Author : zzl
--Date   : 2017/12/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITitleListItem = require("game.UI.activity.Node.UITitleListItem")
--REQUIRE_CLASS_END

local UITitleList  = class("UITitleList", function() return gdisplay.newWidget() end )
local UITitleListCell = require("game.UI.activity.cell.UITitleListCell")
local UITableView = require("game.UI.common.UITableView")
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
function UITitleList:ctor()
    
end

function UITitleList:CreateUI()
    local root = resMgr:createWidget("activity/activity_btns/title_list")
    self:initUI(root)
end

function UITitleList:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_btns/title_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tb_add_node = self.root.tb_add_node_export
    self.tb_item_content = self.root.tb_item_content_export
    self.tb_content = self.root.tb_content_export
    self.mojing = self.root.mojing_export
    self.btn_rmb = self.root.mojing_export.btn_rmb_export
    self.rmb_num = self.root.mojing_export.btn_rmb_export.rmb_num_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.FileNode_1 = UITitleListItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.FileNode_1)
    self.FileNode_2 = UITitleListItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.ScrollView_1_export.FileNode_2)
    self.FileNode_3 = UITitleListItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.ScrollView_1_export.FileNode_3)

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tb_content:getContentSize())
        :setCellSize(self.tb_item_content:getContentSize())
        :setCellTemplate(UITitleListCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.tb_add_node:addChild(self.tableView)

    self.ResSetControl = ResSetControl.new(self.root,self)
    self.mojing.btn_rmb_export:setEnabled(false)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UITitleList:onEnter()

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

end

function UITitleList:setData(data)
    -- self.tableView:setData(data)
    for k ,v in pairs(data) do
      self["FileNode_"..k]:setData(v)
    end 
end



return UITitleList

--endregion

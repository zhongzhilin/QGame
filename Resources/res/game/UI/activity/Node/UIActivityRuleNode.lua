--region UIActivityRuleNode.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityRuleNode  = class("UIActivityRuleNode", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIActivityRuleItemCell = require("game.UI.activity.cell.UIActivityRuleItemCell")

function UIActivityRuleNode:ctor()
    
end

function UIActivityRuleNode:CreateUI()
    local root = resMgr:createWidget("activity/point_rule_node")
    self:initUI(root)
end

function UIActivityRuleNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_rule_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.table_bottom = self.root.table_bottom_export
    self.table_add = self.root.table_add_export
    self.table_top = self.root.table_top_export
    self.table_item_contont = self.root.table_item_contont_export
    self.table_content = self.root.table_content_export

--EXPORT_NODE_END

 self.tableView = UITableView.new()
            :setSize(self.table_content:getContentSize(),  self.table_top,  self.table_bottom )-- 设置大小， scrollview滑动区域（定位置， 低位置）
            :setCellSize(self.table_item_contont:getContentSize()) -- 每个小intem 的大小
            :setCellTemplate(UIActivityRuleItemCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
            :setColumn(1)
    self.table_add:addChild(self.tableView)
end

function UIActivityRuleNode:setData(data)
    self.data = data
    if not self.data then return end 
    self:updateUI()
end

function UIActivityRuleNode:updateUI()
    -- dump(self.data,"what the ")
    local point_rule_data = global.ActivityData:getPointRuleDataByAitivityID(self.data.activity_id)
    if point_rule_data then 
        table.sort(point_rule_data,function(A,B) return A.id<B.id end )
        self.tableView:setData(point_rule_data)
    end 
 end 

function UIActivityRuleNode:onExit()

end 

function UIActivityRuleNode:onEnter()

end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIActivityRuleNode

--endregion

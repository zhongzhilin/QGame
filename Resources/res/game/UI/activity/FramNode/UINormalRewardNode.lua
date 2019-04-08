--region UINormalRewardNode.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINormalRewardNode  = class("UINormalRewardNode", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UINormalRewardNodeCell = require("game.UI.activity.cell.UINormalRewardNodeCell")
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UINormalRewardNode:ctor()
    self:CreateUI()
end

function UINormalRewardNode:CreateUI()
    local root = resMgr:createWidget("activity/normal_reward_node")
    self:initUI(root)
end

function UINormalRewardNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/normal_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.reward_text = self.root.Node_2.bg.reward_text_export
    self.table_contont = self.root.table_contont_export
    self.table_item_contont = self.root.table_item_contont_export
    self.table_top = self.root.table_top_export
    self.table_top_botoom = self.root.table_top_botoom_export
    self.table_add = self.root.table_add_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
            :setSize(self.table_contont:getContentSize(), self.table_top, self.table_top_botoom)-- 设置大小�? scrollview滑动区域（定位置�? 低位置）
            :setCellSize(self.table_item_contont:getContentSize()) -- 每个小intem 的大�?
            :setCellTemplate(UINormalRewardNodeCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
            :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
            :setColumn(1)
    self.table_add:addChild(self.tableView)
end

function UINormalRewardNode:setData(data)
    self.data =data
    self:updateUI()
 end 

function UINormalRewardNode:updateUI()
    local item_data =  global.ActivityData:getDropItemByDropID(self.data.reward)
     self.reward_text:setString(self.data.reward_desc)
    if  not item_data then return end 
    for _ ,v in pairs(item_data) do 
        v.tips_node  = self.data.tips_node
    end 

    dump(self.data.activity_id,"self.data.activity_id1223123123")
    if global.ActivityData:isShowNumberActiviy(self.data.activity_id) then  --是否显示数字 
        for _ ,v in  pairs(item_data) do  
            v.isshownumber = true 
         end
    end 

    dump(item_data,"大量减少地方加啊四的积分")

    self.tableView:setData(item_data)
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UINormalRewardNode

--endregion

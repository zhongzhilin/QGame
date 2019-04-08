--region UIPlunderItem.lua
--Author : anlitop
--Date   : 2017/09/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPlunderItem  = class("UIPlunderItem", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")


function UIPlunderItem:ctor()
    self:CreateUI()
end

function UIPlunderItem:CreateUI()
    local root = resMgr:createWidget("activity/exp_activity/rank_item_export")
    self:initUI(root)
end

function UIPlunderItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/exp_activity/rank_item_export")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.rank_bg = self.root.bg_export.rank_bg_export
    self.rank_num = self.root.bg_export.rank_num_export
    self.scrollView = self.root.bg_export.reward_bg.scrollView_export
    self.table_add = self.root.table_add_export
    self.table_item = self.root.table_item_export
    self.table_contont = self.root.table_contont_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)
end

function UIPlunderItem:setData(data)

    self.data = data 

    self.drop_data =  global.ActivityData:getDropItemByDropID(self.data.reward)

    for _ ,v in pairs(self.drop_data) do 

        v.tips_panel = self.data.tips_panel
    end

    local level = ""

    if self.data.rank_min ==  self.data.rank_max then 
        level = self.data.rank_min
    else 
         level =  self.data.rank_min .. "-".. self.data.rank_max 
    end  

    self.rank_num:setString(level)

    local isShowNumber =  global.ActivityData:isShowNumberActiviy(self.data.activity_id)

    for _ ,v in pairs(self.drop_data) do 

        v.scale = 1.285
        v.isshownumber = isShowNumber 
    end 

    self.tableView:setData(self.drop_data)
end 


function UIPlunderItem:setTBTouchEable(state)

    if state then 
        if not  self.tableView:isTouchEnabled()  then 

            self.tableView:setTouchEnabled(true)
        end
    else 
        
        self.tableView:setTouchEnabled(false)
    end 
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIPlunderItem

--endregion

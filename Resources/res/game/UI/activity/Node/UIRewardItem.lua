--region UIRewardItem.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRewardItem  = class("UIRewardItem", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIRewardItem:ctor()
    self:CreateUI()
end

function UIRewardItem:CreateUI()
    local root = resMgr:createWidget("activity/rank_reward_node")
    self:initUI(root)
end

function UIRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/rank_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.rank_beging_text = self.root.rank_beging_text_export
    self.table_contont = self.root.table_contont_export
    self.table_item = self.root.table_item_export
    self.table_add = self.root.table_add_export

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

-- ] - "UIRewardItem=========" = {
-- [LUA-print] -     "activity_id" = 13001
-- [LUA-print] -     "id"          = 3
-- [LUA-print] -     "rank_max"    = 5
-- [LUA-print] -     "rank_min"    = 4
-- [LUA-print] -     "reward"      = 100029
-- [LUA-print] - }
-- [LUA-print] GuideMg

function UIRewardItem:setData(data)

    if not data then return end 
    self.data = data 
    self.reward_window  = data.reward_window
    self.drop_data =  global.ActivityData:getDropItemByDropID(self.data.reward)
    for _ ,v in pairs(self.drop_data) do 
        v.tips_panel = self.data.tips_panel
    end 
    self:updateUI()

    if global.UIRewardItemCell then 
        global.UIRewardItemCell[self.data.index] = self 
    end 
end 


function UIRewardItem:setTBTouchEable(state)
    
    if state then 
        if not  self.tableView:isTouchEnabled()  then 

            self.tableView:setTouchEnabled(true)
        end
    else 
        self.tableView:setTouchEnabled(false)
    end 
end 


function UIRewardItem:updateUI()
    local tips = ""
    if self.reward_window == 4 or self.reward_window == 5 or self.reward_window == 3 then
        if self.data.rank_min == self.data.rank_max then 
            tips = self.data.rank_min
        else 
             tips =  self.data.rank_min .. "-".. self.data.rank_max 
        end  
    elseif  self.reward_window == 21 then --  领主等级活动
         tips = self.data.point
    elseif  self.reward_window == 22 then --城堡活动
         tips = self.data.point
    end
    self.rank_beging_text:setString(tips)

    if global.ActivityData:isShowNumberActiviy(self.data.activity_id) then  --是否显示数字 
        for _ ,v in  pairs(self.drop_data) do  
            v.isshownumber = true 
        end
    end 

    self.tableView:setData(self.drop_data)
 end 

function UIRewardItem:onExit()
    if  global.UIRewardItemCell then 
        global.UIRewardItemCell[self.data.index] = nil 
    end 
end 

function UIRewardItem:onEnter()

end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRewardItem

--endregion

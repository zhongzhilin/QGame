--region UIKillItem.lua
--Author : anlitop
--Date   : 2017/09/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIKillItem  = class("UIKillItem", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIKillItem:ctor()
    self:CreateUI()
end

function UIKillItem:CreateUI()
    local root = resMgr:createWidget("activity/kill_activity/kill_reward_node")
    self:initUI(root)
end

function UIKillItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/kill_activity/kill_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.table_contont = self.root.table_contont_export
    self.table_item = self.root.table_item_export
    self.table_add = self.root.table_add_export
    self.bg = self.root.bg_export
    self.rank_bg = self.root.bg_export.rank_bg_export
    self.rank_num = self.root.bg_export.rank_num_export
    self.scrollView = self.root.bg_export.reward_bg.scrollView_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 璁剧疆澶у皬锛 scrollview婊戝姩鍖哄煙锛堝畾浣嶇疆锛 浣庝綅缃級
        :setCellSize(self.table_item:getContentSize()) -- 姣忎釜灏廼ntem 鐨勫ぇ灏
        :setCellTemplate(UIRewardItemCell) -- 鍥炶皟鍑芥暟
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)


end


--                  3 = {
-- [LUA-print] -         "activity_id" = 11001
-- [LUA-print] -         "id"          = 12
-- [LUA-print] -         "rank_max"    = 50
-- [LUA-print] -         "rank_min"    = 11
-- [LUA-print] -         "reward"      = 60116
-- [LUA-print] -     }
-- [LUA-print] -     4 = {
-- [LUA-print] -         "activity_id" = 11001
-- [LUA-print] -         "id"          = 11
-- [LUA-print] -         "rank_max"    = 10
-- [LUA-print] -         "rank_min"    = 4
-- [LUA-print] -         "reward"      = 60115
-- [LUA-print] -     }
    
function UIKillItem:setData(data)

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


function UIKillItem:setPKdata(data)

    self.data = data 

    self.drop_data =  global.ActivityData:getDropItemByDropID(self.data.reward)

    for _ ,v in pairs(self.drop_data) do 

        v.tips_panel = self.data.tips_panel
    end

    local level = ""

    if self.data.minRank ==  self.data.maxRank then 
        level = self.data.minRank
    else 
         level =  self.data.minRank .. "-".. self.data.maxRank 
    end  

    self.rank_num:setString(level)


    local isShowNumber =  true

    for _ ,v in pairs(self.drop_data) do 

        v.scale = 1.285
        v.isshownumber = isShowNumber 

    end 


    self.tableView:setData(self.drop_data)

end 

function UIKillItem:setTBTouchEable(state)

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

return UIKillItem

--endregion

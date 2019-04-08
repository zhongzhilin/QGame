--region UIRankReward.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankReward  = class("UIRankReward", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIRankRewardCell = require("game.UI.activity.cell.UIRankRewardCell")
 
function UIRankReward:ctor()
end

function UIRankReward:CreateUI()
    local root = resMgr:createWidget("activity/rank_reward")
    self:initUI(root)
end
function UIRankReward:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/rank_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.rank_text = self.root.Node_2.text_node.rank_text_mlan_6_export
    self.table_content = self.root.table_content_export
    self.table_item_contont = self.root.table_item_contont_export
    self.table_add = self.root.table_add_export
    self.table_bottom = self.root.table_bottom_export

--EXPORT_NODE_END
	self.tableView = UITableView.new()
            :setSize(self.table_content:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
            :setCellSize(self.table_item_contont:getContentSize()) -- 每个小intem 的大小
        	:setCellTemplate(UIRankRewardCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
            :setColumn(1)
    self.table_add:addChild(self.tableView)


    -- self.tableView:setSwallowTouches(false)
end

function UIRankReward:initTouch()
    --添加监听  
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)

    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)

end

local moveMax_x = 30
local moveMax_y = 30

local  prohibit_slide= 0 

function UIRankReward:onTouchMoved(touch, event)

    if prohibit_slide == 1 then return  end 

    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if y then 

        prohibit_slide = 1

        for _ ,v in pairs(global.UIRewardItemCell or {} ) do 

            if v.setTBTouchEable then 

                v:setTBTouchEable(false)
            end 

        end 
        return 
    end 

    if x  then 

        self.tableView:setTouchEnabled(false)

        prohibit_slide = 1 
    end 

end

function UIRankReward:onTouchBegan(touch, event)

    prohibit_slide =  0 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 
    return true
end

function UIRankReward:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    for _ ,v in pairs(global.UIRewardItemCell or {} ) do 

        if v.setTBTouchEable then 

            v:setTBTouchEable(true)
        end 

    end 
end

function UIRankReward:onTouchCancel()

    self.tableView:setTouchEnabled(true)
end 
 

function UIRankReward:ClearEventListener()
        
    if self.touchEventListener  then 
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener  = nil
    end
end 

function UIRankReward:onExit()

    self:ClearEventListener()
end 
 

function UIRankReward:setData(data,reward_window)
	self.data = clone(data)
    -- dump(self.data)
   self.activity_id = self.data[1].activity_id
    self.reward_window = reward_window
    if not self.data then return end 
    print(self.reward_window ,"    self.reward_window = reward_window")
    local rank_level =""
    if  self.reward_window == 5  then  -- 这里设置排行榜界面的 我的排名  我的等级  等 ， 最好让策划为每一个活动配一个字段。
        rank_name= global.luaCfg:get_localization_by(10613).value
        rank_level = global.luaCfg:get_localization_by(10612).value
         table.sort(self.data ,function(A,B) return A.rank_max< B.rank_max end )
    elseif self.reward_window == 3 then 
        rank_name= global.luaCfg:get_localization_by(10613).value
        rank_level = global.luaCfg:get_localization_by(10612).value
        table.sort(self.data ,function(A,B) return A.rank_max< B.rank_max end )
    elseif  self.reward_window == 21 then --  领主等级活动
        rank_name = global.luaCfg:get_localization_by(10564).value
        rank_level=global.luaCfg:get_localization_by(10566).value
        table.sort(self.data ,function(A,B) return A.point> B.point end )
    elseif  self.reward_window == 22 then --城堡活动
        rank_name = global.luaCfg:get_localization_by(10564).value
         rank_level= global.luaCfg:get_localization_by(10565).value
        table.sort(self.data ,function(A,B) return A.point> B.point end )
    end
    --  方便后面处理
    for index ,v in pairs(self.data) do 
        v.index = index 
        v.reward_window = reward_window
    end 

    self:initTouch()

    self:updateUI()
    self.rank_name:setString(rank_name)
    self.rank_text:setString(rank_level)

    if self.reward_window == 21 then 
         self.rank_number:setString(global.userData:getLevel())
        self.mypoint_num_node:setVisible(false)
    elseif self.reward_window == 22 then 
         self.rank_number:setString(global.cityData:getBuildingById(1).serverData.lGrade)
          self.mypoint_num_node:setVisible(false)
    else 

       global.ActivityAPI:ActivityListReq({self.activity_id},function(ret,msg)
            if msg and msg.tagAct then --排名一直显示为 0  
                self.rank_number:setString(msg.tagAct[1].lParam2 or 0 )
                if  global.ActivityData:isPointActiviy(self.activity_id) then 
                     self.mypoint_num_node:setVisible(true)
                     self.mypoint_num_text:setString( msg.tagAct[1].lParam or 0)
                else 
                    self.mypoint_num_node:setVisible(false)
                 end 
            end 
        end)
    end

 end


function UIRankReward:updateUI()
    
    self.tableView:setData(self.data)
end 

function UIRankReward:onEnter()

    self:ClearEventListener()

    global.UIRewardItemCell ={} 

end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRankReward:showRankClick(sender, eventType)
    if  self.reward_window == 21 then --  领主等级活动
        local data = global.luaCfg:get_rank_by(5)
        global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
        return 
    elseif  self.reward_window == 22 then --城堡活动   
        local data = global.luaCfg:get_rank_by(7)
        global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
        return 
    end

    for _ ,v in pairs(global.luaCfg:activity_rank()) do
        if v.activity_id == self.activity_id then 
            local  panel =  global.panelMgr:openPanel("UIRankInfoPanel")
            panel:setActvityData(v)
            return 
        end 
    end 

end

function UIRankReward:militaryHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIRankReward

--endregion

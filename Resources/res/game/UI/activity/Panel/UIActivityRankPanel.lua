--region UIActivityRankPanel.lua
--Author : anlitop
--Date   : 2017/04/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRankFramNode = require("game.UI.activity.FramNode.UIRankFramNode")
--REQUIRE_CLASS_END

local UIActivityRankPanel  = class("UIActivityRankPanel", function() return gdisplay.newWidget() end )

function UIActivityRankPanel:ctor()
    self:CreateUI()
end

function UIActivityRankPanel:CreateUI()
    local root = resMgr:createWidget("activity/rank_panel")
    self:initUI(root)
end

function UIActivityRankPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/rank_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Node = UIRankFramNode.new()
    uiMgr:configNestClass(self.Node, self.root.Node_export)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_5, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END

    self.tips_node  =self.root.tips_node_export
     self.tips_node:setLocalZOrder(1)
 end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN



function UIActivityRankPanel:updateUI()
    self.Node:setData(self.rank_data, self.data.reward_window)
end 

function UIActivityRankPanel:setData(data)
    self.data =data
    if not self.data then return end
    if  self.data.reward_window == 3 or self.data.reward_window == 5  then  
        self.rank_data =  global.ActivityData:getRankRewardByActivityID(self.data.activity_id)
    elseif  self.data.reward_window == 22 then -- 城堡活动 
         self.rank_data =  global.ActivityData:getActivityBoxData(self.data.activity_id)
    elseif  self.data.reward_window == 21 then --领主等级活动
         self.rank_data =  global.ActivityData:getActivityBoxData(self.data.activity_id)
    end 
     if not self.rank_data then return end 

    for _ ,v in pairs(self.rank_data) do 
        v.tips_panel = self
    end 
    -- dump(self.rank_data,"UIActivityRankPanel")    
    self:updateUI()
    
    global.loginApi:clickPointReport(nil,self.data.activity_id,2,nil)
end

function UIActivityRankPanel:onExit()

end 

function UIActivityRankPanel:onEnter()
end 

function UIActivityRankPanel:close_panel(sender, eventType)
    global.panelMgr:closePanel("UIActivityRankPanel")
end
--CALLBACKS_FUNCS_END

return UIActivityRankPanel

--endregion

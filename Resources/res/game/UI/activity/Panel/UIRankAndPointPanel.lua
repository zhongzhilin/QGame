--region UIRankAndPointPanel.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityPointNode = require("game.UI.activity.Node.UIActivityPointNode")
local UIRankReward = require("game.UI.activity.Node.UIRankReward")
--REQUIRE_CLASS_END

local UIRankAndPointPanel  = class("UIRankAndPointPanel", function() return gdisplay.newWidget() end )

function UIRankAndPointPanel:ctor()
    self:CreateUI()
end

function UIRankAndPointPanel:CreateUI()
    local root = resMgr:createWidget("activity/point_rank_panel")
    self:initUI(root)
end

function UIRankAndPointPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_rank_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_3 = self.root.Node_export.FileNode_3_export
    self.FileNode_3 = UIActivityPointNode.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.FileNode_3_export)
    self.FileNode_1 = UIRankReward.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.act_name = self.root.Node_export.act_name_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_2, function(sender, eventType) self:close_panel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_7, function(sender, eventType) self:bt_close_panel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRankAndPointPanel:setData(data)
    self.data =data 
    if not self.data then return end 
    
    dump(self.data,"self.data =data ")

    -- 宝箱 理论上只能有三个
    local point_data = global.ActivityData:getActivityBoxData(self.data.activity_id)
    self.FileNode_3:setData(point_data)
    
    -- 排行    
    local Reward_data = global.ActivityData:getRankRewardByActivityID(self.data.activity_id)
    for _ ,v in pairs(Reward_data)  do 
        v.tips_panel  = self
    end 
    self.FileNode_1:setData(Reward_data,self.data.reward_window) 

    global.loginApi:clickPointReport(nil,self.data.activity_id,4,nil)
 end


function UIRankAndPointPanel:updateUI()

end


function UIRankAndPointPanel:onEnter()

end

function UIRankAndPointPanel:onExit()

end
 
function UIRankAndPointPanel:close_panel(sender, eventType)
    global.panelMgr:closePanel("UIRankAndPointPanel")
end

function UIRankAndPointPanel:bt_close_panel(sender, eventType)
    global.panelMgr:closePanel("UIRankAndPointPanel")
end

function UIRankAndPointPanel:infoCall(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIRankAndPointPanel

--endregion

--region UINormalRewardPanel.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UINormalRewardNode = require("game.UI.activity.FramNode.UINormalRewardNode")
--REQUIRE_CLASS_END

local UINormalRewardPanel  = class("UINormalRewardPanel", function() return gdisplay.newWidget() end )

function UINormalRewardPanel:ctor()
    self:CreateUI()
end

function UINormalRewardPanel:CreateUI()
    local root = resMgr:createWidget("activity/normal_reward_panel")
    self:initUI(root)
end

function UINormalRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/normal_reward_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Node = UINormalRewardNode.new()
    uiMgr:configNestClass(self.Node, self.root.Node_export)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END
    self.tips_node:setLocalZOrder(1)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UINormalRewardPanel:close_panel(sender, eventType)
    global.panelMgr:closePanel("UINormalRewardPanel")
end
--CALLBACKS_FUNCS_END

function UINormalRewardPanel:onEnter()
    
end 

function UINormalRewardPanel:setData(data)
    self.data =data
    self.data.tips_node=  self.tips_node
    self.Node:setData(data)

    global.loginApi:clickPointReport(nil,self.data.activity_id,4,nil)
end 

return UINormalRewardPanel

--endregion

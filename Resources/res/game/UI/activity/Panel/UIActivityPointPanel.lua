--region UIActivityPointPanel.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityPointFram = require("game.UI.activity.FramNode.UIActivityPointFram")
--REQUIRE_CLASS_END

local UIActivityPointPanel  = class("UIActivityPointPanel", function() return gdisplay.newWidget() end )

function UIActivityPointPanel:ctor()
    self:CreateUI()
end

function UIActivityPointPanel:CreateUI()
    local root = resMgr:createWidget("activity/point_reward_panel")
    self:initUI(root)
end

function UIActivityPointPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_reward_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Node = UIActivityPointFram.new()
    uiMgr:configNestClass(self.Node, self.root.Node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END
end

function UIActivityPointPanel:setData(data)
	self.data =data
    if not self.data then return end 
    -- 获取宝箱数据 -- 理论上只能有三个
    local Reward_data = global.ActivityData:getActivityBoxData(self.data.activity_id)
    self.Node:setData(Reward_data)
    global.loginApi:clickPointReport(nil,self.data.activity_id,3,nil)
end 

function UIActivityPointPanel:onEnter()

end 

function UIActivityPointPanel:onExit()

end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIActivityPointPanel:close_panel(sender, eventType)
	global.panelMgr:closePanel("UIActivityPointPanel")
end
--CALLBACKS_FUNCS_END

return UIActivityPointPanel

--endregion

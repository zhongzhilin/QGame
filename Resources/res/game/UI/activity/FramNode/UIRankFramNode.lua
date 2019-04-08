--region UIRankFramNode.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRankReward = require("game.UI.activity.Node.UIRankReward")
--REQUIRE_CLASS_END

local UIRankFramNode  = class("UIRankFramNode", function() return gdisplay.newWidget() end )

function UIRankFramNode:ctor()
    
end

function UIRankFramNode:CreateUI()
    local root = resMgr:createWidget("activity/rank_fream_node")
    self:initUI(root)
end

function UIRankFramNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/rank_fream_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIRankReward.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

--EXPORT_NODE_END
end

function UIRankFramNode:setData(data,reward_window)
	self.data =data
    self.reward_window = reward_window
	self:updateUI()
end 

function UIRankFramNode:updateUI()
	if not self.data  then return  end
  	self.FileNode_1:setData(self.data, self.reward_window )
end



function UIRankFramNode:onExit()

end 

function UIRankFramNode:onEnter()

end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRankFramNode

--endregion

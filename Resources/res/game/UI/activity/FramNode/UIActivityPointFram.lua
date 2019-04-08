--region UIActivityPointFram.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityPointNode = require("game.UI.activity.Node.UIActivityPointNode")
--REQUIRE_CLASS_END

local UIActivityPointFram  = class("UIActivityPointFram", function() return gdisplay.newWidget() end )

function UIActivityPointFram:ctor()
    
end

function UIActivityPointFram:CreateUI()
    local root = resMgr:createWidget("activity/point_reward")
    self:initUI(root)
end

function UIActivityPointFram:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIActivityPointNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

--EXPORT_NODE_END
end

function UIActivityPointFram:setData(data)
    self.data =data
     if not self.data then return end 
    self.FileNode_1:setData( self.data)
end 

function UIActivityPointFram:onEnter()
end 

function UIActivityPointFram:onExit()
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIActivityPointFram

--endregion

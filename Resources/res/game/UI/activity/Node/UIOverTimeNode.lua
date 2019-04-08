--region UIOverTimeNode.lua
--Author : anlitop
--Date   : 2017/05/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOverTimeNode  = class("UIOverTimeNode", function() return gdisplay.newWidget() end )

function UIOverTimeNode:ctor()
    self:CreateUI()
end

function UIOverTimeNode:CreateUI()
    local root = resMgr:createWidget("activity/overtime_node")
    self:initUI(root)
end

function UIOverTimeNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/overtime_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.load = self.root.Panel_1.load_export
    self.loading_effect = self.root.Panel_1.loading_effect_export
    self.time = self.root.time_export

--EXPORT_NODE_END
    self.barW = self.load:getContentSize().width
end

function UIOverTimeNode:setData()

end 

function UIOverTimeNode:updateInfo(data)
    self.load:setPercent(data.percent)
    self.time:setString(data.time)
    self.loading_effect:setPositionX(9+self.barW*data.percent/100)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIOverTimeNode

--endregion

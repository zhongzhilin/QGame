--region UIWorldActivity.lua
--Author : Untory
--Date   : 2018/01/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldActivity  = class("UIWorldActivity", function() return gdisplay.newWidget() end )

function UIWorldActivity:ctor()
    
end

function UIWorldActivity:CreateUI()
    local root = resMgr:createWidget("world/activity_world_icon")
    self:initUI(root)
end

function UIWorldActivity:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/activity_world_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:callBack(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldActivity:onEnter()
    self.root:stopAllActions() 
    self.timeLine =resMgr:createTimeline("world/activity_world_icon")
    self.root:runAction(self.timeLine)
    self.timeLine:play("animation0",true)
end 


function UIWorldActivity:callBack(sender, eventType)
	local panel =   global.panelMgr:openPanel("UIActivityPanel")
    panel:setData(2)
end
--CALLBACKS_FUNCS_END

return UIWorldActivity

--endregion

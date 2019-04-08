--region UIDailyTaskIcon.lua
--Author : yyt
--Date   : 2016/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDailyTaskIcon  = class("UIDailyTaskIcon", function() return gdisplay.newWidget() end )

function UIDailyTaskIcon:ctor()
    self:CreateUI()
end

function UIDailyTaskIcon:CreateUI()
    local root = resMgr:createWidget("effect/picture_bx")
    self:initUI(root)
end

function UIDailyTaskIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/picture_bx")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:icon_click(sender, eventType) end)
--EXPORT_NODE_END

	local nodeTimeLine = resMgr:createTimeline("effect/picture_bx")
	nodeTimeLine:play("animation0", true)
	self.root:runAction(nodeTimeLine)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDailyTaskIcon:icon_click(sender, eventType)

	global.panelMgr:openPanel("UIDailyTaskPanel"):setData()
end
--CALLBACKS_FUNCS_END

return UIDailyTaskIcon

--endregion

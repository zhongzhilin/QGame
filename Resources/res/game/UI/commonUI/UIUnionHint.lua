--region UIUnionHint.lua
--Author : yyt
--Date   : 2017/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionHint  = class("UIUnionHint", function() return gdisplay.newWidget() end )

function UIUnionHint:ctor()
   
end

function UIUnionHint:CreateUI()
    local root = resMgr:createWidget("common/union_tips")
    self:initUI(root)
end

function UIUnionHint:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/union_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hintNode = self.root.hintNode_export
    self.btn_apply = self.root.hintNode_export.btn_apply_export
    self.firstEnter = self.root.hintNode_export.firstEnter_export
    self.dia_icon = self.root.hintNode_export.firstEnter_export.dia_icon_export
    self.dia_num = self.root.hintNode_export.firstEnter_export.dia_num_export

    uiMgr:addWidgetTouchHandler(self.btn_apply, function(sender, eventType) self:joinHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.hintNode_export.Button_close, function(sender, eventType) self:closeHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUnionHint:onEnter()
    self:hideHint()
end

function UIUnionHint:showHint()

    if self.hintNode:isVisible() then return end
	self.root:stopAllActions()
	local nodeTimeLine = resMgr:createTimeline("common/union_tips")
    nodeTimeLine:gotoFrameAndPause(0)
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0", false)
    self.hintNode:setVisible(true)
    self.firstEnter:setVisible(global.userData:islAllyFirstAdd())
end
function UIUnionHint:hideHint()
	self.hintNode:setVisible(false)
end

function UIUnionHint:setData()
end

function UIUnionHint:joinHandler(sender, eventType)
	self:hideHint()
	global.panelMgr:openPanel("UIUnionPanel"):setData()
end

function UIUnionHint:closeHandler(sender, eventType)
	self:hideHint()
end
--CALLBACKS_FUNCS_END

return UIUnionHint

--endregion

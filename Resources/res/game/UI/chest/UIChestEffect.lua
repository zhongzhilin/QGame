--region UIChestEffect.lua
--Author : yyt
--Date   : 2017/03/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChestEffect  = class("UIChestEffect", function() return gdisplay.newWidget() end )

function UIChestEffect:ctor()
    
end

function UIChestEffect:CreateUI()
    local root = resMgr:createWidget("chest/EffectNode1")
    self:initUI(root)
end

function UIChestEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chest/EffectNode1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ButtonR = self.root.ButtonR_export
    uiMgr:addWidgetTouchHandler(self.ButtonR, function(sender, eventType) self:vipBagHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIChestEffect:onEnter()
    self.nodeTimeLine = resMgr:createTimeline("chest/EffectNode1")
    self:runAction(self.nodeTimeLine)
end

function UIChestEffect:playEffect()
	self.nodeTimeLine:play("animation0", true)
end

function UIChestEffect:setData(call)
	self.m_call = call
end

function UIChestEffect:vipBagHandler(sender, eventType)
	if self.m_call then
		self.m_call()
	end
end
--CALLBACKS_FUNCS_END

return UIChestEffect

--endregion

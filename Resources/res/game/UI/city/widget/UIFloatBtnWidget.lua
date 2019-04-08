--region UIFloatBtnWidget.lua
--Author : wuwx
--Date   : 2017/02/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFloatBtnWidget  = class("UIFloatBtnWidget", function() return gdisplay.newWidget() end )

function UIFloatBtnWidget:ctor()
    self:CreateUI()
end

function UIFloatBtnWidget:CreateUI()
    local root = resMgr:createWidget("city/building_float_btn")
    self:initUI(root)
end

function UIFloatBtnWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building_float_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pic = self.root.btn.bg.pic_export

    uiMgr:addWidgetTouchHandler(self.root.btn, function(sender, eventType) self:onClick(sender, eventType) end)
--EXPORT_NODE_END
	self.nodeTimeLine = resMgr:createTimeline("city/building_float_btn")
    self:runAction(self.nodeTimeLine)
end

function UIFloatBtnWidget:setData(flag,clickCall)
	self.m_clickCall = clickCall
	self:playEffectBag( flag )
end

function UIFloatBtnWidget:setIcon( frameName )
	self.pic:setSpriteFrame(frameName)
end

function UIFloatBtnWidget:playEffectBag( flag )
	self.m_flag = flag or self.m_flag
	if self.m_flag == 0 then 
		self.nodeTimeLine:play("animation0", true)
    else 
		self.nodeTimeLine:play("animation1", true)
	end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIFloatBtnWidget:onClick(sender, eventType)
	if self.m_clickCall then self.m_clickCall() end
end
--CALLBACKS_FUNCS_END

return UIFloatBtnWidget

--endregion

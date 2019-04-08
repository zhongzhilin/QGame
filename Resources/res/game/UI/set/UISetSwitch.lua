--region UISetSwitch.lua
--Author : untory
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISetSwitch  = class("UISetSwitch", function() return gdisplay.newWidget() end )

function UISetSwitch:ctor()
    
end

function UISetSwitch:CreateUI()
    local root = resMgr:createWidget("settings/setting_switch")
    self:initUI(root)
end

function UISetSwitch:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    local uiMgr = global.uiMgr
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/setting_switch")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.effect_rect = self.root.effect_rect_export
    self.buttom_effect = self.root.effect_rect_export.buttom_effect_export
    self.point = self.root.point_export
    self.close = self.root.close_mlan_4_export
    self.open = self.root.open_mlan_4_export

    uiMgr:addWidgetTouchHandler(self.root.buttom, function(sender, eventType) self:onClick(sender, eventType) end)
--EXPORT_NODE_END

	self.root.buttom:setZoomScale(0)
	self.effect_rect:setTouchEnabled(false)
	self.isSelect = false
end

function UISetSwitch:onEnter()
    -- self:setOpenCloseModal()
end

function UISetSwitch:setCloseOpenLan(closeId,openId)
	self.close:setString(luaCfg:get_local_string(closeId))
	self.open:setString(luaCfg:get_local_string(openId))
end

function UISetSwitch:setSelect(select,isNeedAction,noCall)
	
	self.isSelect = select

	self.point:stopAllActions()
	self.buttom_effect:stopAllActions()

	if not self.isSelect then		

		if isNeedAction then
		
			self.point:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.15,cc.p(-52,0)),2))
			self.buttom_effect:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.15,0.10,1),2))
		else

			self.point:setPosition(cc.p(-52,0))
			self.buttom_effect:setScale(0.10,1)
		end		
	else

		if isNeedAction then
			self.point:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.15,cc.p(61,0)),2))
			self.buttom_effect:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.15,1,1),2))
		else

			self.point:setPosition(cc.p(61,0))
			self.buttom_effect:setScale(1,1)
		end
	end

	if not noCall and self.callback then self.callback(self.isSelect) end
end

function UISetSwitch:addEventListener(callback)
	
	self.callback = callback
end

function UISetSwitch:setOpenCloseModal()
	local close = global.luaCfg:get_ui_language_string_by(442)
	local open = global.luaCfg:get_ui_language_string_by(443)
	self.close:setString(close.value)
	self.open:setString(open.value)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISetSwitch:onClick(sender, eventType)

	self:setSelect(not self.isSelect,true)
end
--CALLBACKS_FUNCS_END

return UISetSwitch

--endregion

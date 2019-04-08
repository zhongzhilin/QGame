--region citybuffbutton.lua
--Author : anlitop
--Date   : 2017/03/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local citybuffbutton  = class("citybuffbutton", function() return gdisplay.newWidget() end )

function citybuffbutton:ctor()
    
end

function citybuffbutton:CreateUI()
    local root = resMgr:createWidget("common/buff_btn")
    self:initUI(root)
end

function citybuffbutton:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/buff_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node_gray = self.root.Button_1.node_gray_export
    self.node_effect = self.root.node_effect_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:onbtCityBuff(sender, eventType) end)
--EXPORT_NODE_END
	
    local nodeTimeLine = resMgr:createTimeline("common/buff_btn")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end


function citybuffbutton:setGray(isGray)
    global.colorUtils.turnGray(self.node_gray,isGray)
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN



function citybuffbutton:showEffect(isShow)
	self.node_effect:setVisible(isShow)
end 



function citybuffbutton:onbtCityBuff(sender, eventType)
	 local combatPanel = global.panelMgr:openPanel("UICityBufferPanel")
end
--CALLBACKS_FUNCS_END

return citybuffbutton

--endregion

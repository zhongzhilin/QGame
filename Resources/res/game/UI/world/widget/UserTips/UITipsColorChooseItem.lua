--region UITipsColorChooseItem.lua
--Author : untory
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITipsColorChooseItem  = class("UITipsColorChooseItem", function() return gdisplay.newWidget() end )

function UITipsColorChooseItem:ctor()
    
end

function UITipsColorChooseItem:CreateUI()
    local root = resMgr:createWidget("world/info/stickers_write_color")
    self:initUI(root)
end

function UITipsColorChooseItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/stickers_write_color")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Panel = self.root.Panel_export
    self.light = self.root.light_export

    uiMgr:addWidgetTouchHandler(self.Panel, function(sender, eventType) self:beChoose(sender, eventType) end)
--EXPORT_NODE_END
end

function UITipsColorChooseItem:setChooseState(isChoose)
	
	self.light:setVisible(isChoose)
end

function UITipsColorChooseItem:setIndex(index)
	
	self.index = index
	self.light:setVisible(false)	
	self.Panel:setColor(cc.c3b(unpack(luaCfg:get_stickers_color_by(index).color)))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITipsColorChooseItem:beChoose(sender, eventType)

	global.panelMgr:getPanel("UITipsWritePanel"):choose(self.index)
end
--CALLBACKS_FUNCS_END

return UITipsColorChooseItem

--endregion

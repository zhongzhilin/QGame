--region UIBuffItem.lua
--Author : Untory
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuffItem  = class("UIBuffItem", function() return gdisplay.newWidget() end )

function UIBuffItem:ctor()
    self:CreateUI()
end

function UIBuffItem:CreateUI()
    local root = resMgr:createWidget("offical/offical_buff_node")
    self:initUI(root)
end

function UIBuffItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "offical/offical_buff_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.reward_icon = self.root.reward_icon_export
    self.add_text = self.root.add_text_export
    self.desc_text = self.root.desc_text_export

--EXPORT_NODE_END
end

function UIBuffItem:setData(data)
	
	-- local str = golbal.buffData:getBuffStrBy({lValue = data[2],lID = data[1]})

    local league1Cfg = luaCfg:get_data_type_by(data[1])
	self.desc_text:setString(league1Cfg.paraName)
	self.reward_icon:setSpriteFrame(league1Cfg.icon)
	self.add_text:setString(data[2] .. league1Cfg.str .. league1Cfg.extra)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBuffItem

--endregion

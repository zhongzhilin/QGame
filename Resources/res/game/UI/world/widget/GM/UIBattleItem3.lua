--region UIBattleItem3.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIObverse = require("game.UI.world.widget.GM.UIObverse")
local UIBattleItem3  = class("UIBattleItem3", function() return gdisplay.newWidget() end )

local itemHeight = 84

function UIBattleItem3:ctor(data)
    
    self:CreateUI(data)
end

function UIBattleItem3:CreateUI(data)
    local root = resMgr:createWidget("battle/BattleNode3")
    self:initUI(root,data)
end

function UIBattleItem3:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode3")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END

	local tgRoundData = data.tgRoundData
	local roundCount = #tgRoundData
	for i,v in ipairs(tgRoundData) do

		local node = UIObverse.new(v)
		node:setPositionY((roundCount - i) * itemHeight)
		self:addChild(node)
	end

	self:setContentSize({width = 0,height = itemHeight * roundCount})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItem3

--endregion

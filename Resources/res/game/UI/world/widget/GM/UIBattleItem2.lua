--region UIBattleItem2.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleItem2  = class("UIBattleItem2", function() return gdisplay.newWidget() end )
local UIOutside1 = require("game.UI.world.widget.GM.UIOutside1")
local UIOutside2 = require("game.UI.world.widget.GM.UIOutside2")

local itemHeight = 77
local itemHeight2 = 40

function UIBattleItem2:ctor(data)
   self:CreateUI(data) 
end

function UIBattleItem2:CreateUI(data)
    local root = resMgr:createWidget("battle/BattleNode2")
    self:initUI(root,data)
end

function UIBattleItem2:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END

	if data.tgFightOne == nil then return end

	local tgFightOne = data.tgFightOne
	local tgFightOneCount = #tgFightOne

	local tgFightSec = data.tgFightSec
	local tgFightSecCount = #tgFightSec

	for i,v in ipairs(tgFightOne) do

		local node = UIOutside1.new(v,i)
		node:setPositionY((i - 1) * itemHeight)
		self:addChild(node)
	end

	for i,v in ipairs(tgFightSec) do

		local node = UIOutside2.new(v,i)
		node:setPositionY((i - 1) * itemHeight2 + itemHeight * tgFightOneCount)
		self:addChild(node)
	end


	self:setContentSize({width = 0,height = itemHeight * tgFightOneCount + itemHeight2 * tgFightSecCount})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItem2

--endregion

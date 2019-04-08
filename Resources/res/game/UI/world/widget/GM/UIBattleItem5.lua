--region UIBattleItem5.lua
--Author : Administrator
--Date   : 2016/11/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UIBattleItemNodeEnd = require("game.UI.world.widget.GM.UIBattleItemNodeEnd")
local UIBattleItem5  = class("UIBattleItem5", function() return gdisplay.newWidget() end )

local space_height = 10

function UIBattleItem5:ctor(data)
   
   self:CreateUI(data) 
end

function UIBattleItem5:CreateUI(data)
    local root = resMgr:createWidget("battle/BattleNode5")
    self:initUI(root,data)
end

function UIBattleItem5:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode5")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node2 = self.root.node2_export
    self.node1 = self.root.node1_export

--EXPORT_NODE_END

	-- self:addChild(UIBattleItemNodeEnd.new(data))
	-- self:setContentSize({width = 0,height = 33})

	local tgAtkTroop = data.tgAtkTroop
	local atkCount = #tgAtkTroop

	local tgDefTroop = data.tgDefTroop
	local defCount = #tgDefTroop

	local atkHeight = 0
	local defHeight = 0

	for i,v in ipairs(tgAtkTroop) do

		-- local tgSoldier = v.tgSoldier
		local battleItem = UIBattleItemNodeEnd.new(v,true,data.lRate)
		self.node1:addChild(battleItem)
		local height = battleItem:getContentSize().height
		battleItem:setPositionY(atkHeight + height / 2 + (i - 1) * space_height)

		-- print(battleItem:getPositionY())

		atkHeight = atkHeight + height
		if i ~= 0 then atkHeight = atkHeight + space_height end
	end

	for i,v in ipairs(tgDefTroop) do

		-- local tgSoldier = v.tgSoldier
		local battleItem = UIBattleItemNodeEnd.new(v,false,data.lRate)
		self.node2:addChild(battleItem)
		local height = battleItem:getContentSize().height
		battleItem:setPositionY(defHeight + height / 2 + (i - 1) * space_height)

		defHeight = defHeight + height
		if i ~= 0 then defHeight = defHeight + space_height end
	end

	atkHeight = atkHeight + atkCount * 5
	defHeight = defHeight + defCount * 5
	local max = math.max(defHeight,atkHeight)
	self:setContentSize({width = 0,height = max})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItem5

--endregion

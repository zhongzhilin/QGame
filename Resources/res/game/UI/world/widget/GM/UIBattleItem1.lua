--region UIBattleItem1.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleItem1  = class("UIBattleItem1", function() return gdisplay.newWidget() end )
local UIBattleItemNode = require("game.UI.world.widget.GM.UIBattleItemNode")

local itemHeight = 128
local space_height = 10

function UIBattleItem1:ctor(data)
    
    self:CreateUI(data)
end

function UIBattleItem1:CreateUI(data)
    local root = resMgr:createWidget("battle/BattleNode1")
    self:initUI(root,data)
end

function UIBattleItem1:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode1")
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node1 = self.root.node1_export
    self.node2 = self.root.node2_export

--EXPORT_NODE_END

	-- dump(data)

	local tgAtkTroop = data.tgAtkTroop
	local atkCount = #tgAtkTroop

	local tgDefTroop = data.tgDefTroop
	local defCount = #tgDefTroop

	local atkHeight = 0
	local defHeight = 0

	for i,v in ipairs(tgAtkTroop) do

		-- local tgSoldier = v.tgSoldier
		local battleItem = UIBattleItemNode.new(v,true)
		self.node1:addChild(battleItem)
		local height = battleItem:getContentSize().height
		battleItem:setPositionY(atkHeight + height / 2 + (i - 1) * space_height)

		-- print(battleItem:getPositionY())

		atkHeight = atkHeight + height
		if i ~= 0 then atkHeight = atkHeight + space_height end
	end

	for i,v in ipairs(tgDefTroop) do

		-- local tgSoldier = v.tgSoldier
		local battleItem = UIBattleItemNode.new(v,false)
		self.node2:addChild(battleItem)
		local height = battleItem:getContentSize().height
		battleItem:setPositionY(defHeight + height / 2 + (i - 1) * space_height)

		defHeight = defHeight + height
		if i ~= 0 then defHeight = defHeight + space_height end
	end

	atkHeight = atkHeight + atkCount * 5
	defHeight = defHeight + defCount * 5

	-- for i = 0,1 do

	-- 	local battleItem = UIBattleItemNode.new()
	-- 	self.node1:addChild(battleItem)

	-- 	battleItem:setPositionY(itemHeight * i + 2 * itemHeight )
	-- end

	-- for i = 0,3 do

	-- 	local battleItem = UIBattleItemNode.new()
	-- 	self.node2:addChild(battleItem)

	-- 	battleItem:setPositionY(itemHeight * i)
	-- end


	local max = math.max(defHeight,atkHeight)

	-- self.node1:setPositionY((max - atkHeight))
	-- self.node2:setPositionY((max - defHeight))

	self:setContentSize({width = 0,height = max})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItem1

--endregion

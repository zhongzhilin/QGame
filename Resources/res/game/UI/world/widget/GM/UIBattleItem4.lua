--region UIBattleItem4.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleItem4  = class("UIBattleItem4", function() return gdisplay.newWidget() end )

local UIObverse = require("game.UI.world.widget.GM.UIObverse")
local LastItem = require("game.UI.world.widget.GM.LastItem")
local itemHeight = 84

function UIBattleItem4:ctor(data)
    
    self:CreateUI(data)
end

function UIBattleItem4:CreateUI(data)
    local root = resMgr:createWidget("battle/BattleNode4")
    self:initUI(root,data)
end

function UIBattleItem4:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode4")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END

	local tgRoundDataThird = data.tgRoundDataThird
	local roundCount = #tgRoundDataThird
	for i,v in ipairs(tgRoundDataThird) do

		if v.lDefSoldierid == 71 or v.lDefSoldierid == 72 then

			print("local node = LastItem.new(v)")

			local node = LastItem.new(v)
			node:setPositionY((roundCount - i) * itemHeight)
			self:addChild(node)		
		else
		
			print("local node = UIObverse.new(v)")

			local node = UIObverse.new(v)
			node:setPositionY((roundCount - i) * itemHeight)
			self:addChild(node)	
		end
	end

	self:setContentSize({width = 0,height = itemHeight * roundCount})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItem4

--endregion

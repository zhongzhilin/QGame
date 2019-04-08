--region UIBattleItemNode.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UISoldier1 = require("game.UI.world.widget.GM.UISoldier1")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleItemNode  = class("UIBattleItemNode", function() return gdisplay.newWidget() end )

function UIBattleItemNode:ctor(data,isAtt)
    
    self:CreateUI(data,isAtt)
end

local itemHeight = 33

function UIBattleItemNode:CreateUI(data,isAtt)
    local root = resMgr:createWidget("battle/army_start_node")
    self:initUI(root,data,isAtt)
end

function UIBattleItemNode:initUI(root,data,isAtt)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/army_start_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.army_name = self.root.top_export.army_name_export
    self.atk_type = self.root.top_export.atk_type_export

--EXPORT_NODE_END

	if isAtt then

		self.atk_type:setString("进攻")
	else

		self.atk_type:setString("防守")
	end
	
    local sdCount = #data.tgSoldier
	for i,v in ipairs(data.tgSoldier) do

		-- dump(v,"data ininin")
        local soldier = UISoldier1.new(v)
        soldier:setPositionY((i - 1) * itemHeight)

        self:addChild(soldier)
	end

    self.top:setPositionY(sdCount * itemHeight)

    self:setContentSize({width = 0,height = sdCount * itemHeight + itemHeight})
    -- self:setPositionY(self:getContentSize().height / 2)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItemNode

--endregion

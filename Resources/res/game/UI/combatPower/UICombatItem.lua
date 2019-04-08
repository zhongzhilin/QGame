--region UICombatItem.lua
--Author : yyt
--Date   : 2016/11/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICombatItem  = class("UICombatItem", function() return gdisplay.newWidget() end )

function UICombatItem:ctor()
    self:CreateUI()
end

function UICombatItem:CreateUI()
    local root = resMgr:createWidget("combatpower/combat_rank_node")
    self:initUI(root)
end

function UICombatItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "combatpower/combat_rank_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.part_combat_norank = self.root.part_combat_norank_export
    self.combat_rank = self.root.combat_rank_export
    self.combat_num = self.root.combat_num_export
    self.combat_name = self.root.combat_name_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICombatItem:setData(data)
    
    if data.lRank == -1 then
        self.combat_rank:setVisible(false)
        self.part_combat_norank:setString(luaCfg:get_local_string(10059))
    else
        self.part_combat_norank:setVisible(false)
        self.combat_rank:setString(data.lRank)
    end

    self.combat_num:setString(data.lValue)
    if data.lType == 7 then
        self.combat_name:setString(luaCfg:get_local_string(10957))
    else
        self.combat_name:setString(luaCfg:get_local_string(10052+data.lType))
    end
end

--CALLBACKS_FUNCS_END

return UICombatItem

--endregion

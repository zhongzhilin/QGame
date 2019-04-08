--region UIObverse.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIObverse  = class("UIObverse", function() return gdisplay.newWidget() end )

function UIObverse:ctor(data)
    
    self:CreateUI(data)
end

function UIObverse:CreateUI(data)
    local root = resMgr:createWidget("battle/obverse_soldier_node")
    self:initUI(root,data)
end

function UIObverse:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/obverse_soldier_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.round_num = self.root.round_num_export
    self.atk_army_name = self.root.atk_node.atk_army_name_export
    self.atk_soldier_name = self.root.atk_node.atk_soldier_name_export
    self.atk_damage_num = self.root.atk_node.atk_damage_num_export
    self.atk_num = self.root.atk_node.atk_num_export
    self.atk_dis_num = self.root.atk_node.atk_dis_num_export
    self.def_army_name = self.root.def_node.def_army_name_export
    self.def_soldier_name = self.root.def_node.def_soldier_name_export
    self.def_damage_num = self.root.def_node.def_damage_num_export
    self.def_num = self.root.def_node.def_num_export
    self.def_dis_num = self.root.def_node.def_dis_num_export

--EXPORT_NODE_END

    self.atk_soldier_name:setString(luaCfg:get_soldier_property_by(data.lAtkSoldierid).name)
    self.atk_damage_num:setString(data.lAtkDamage)
    self.atk_dis_num:setString(data.lAtkLosCount)
    self.atk_num:setString(data.lAtkLeftCount)

    self.def_soldier_name:setString(luaCfg:get_soldier_property_by(data.lDefSoldierid).name)
    self.def_damage_num:setString(data.lDefDamage)
    self.def_dis_num:setString(data.lDefLosCount)
    self.def_num:setString(data.lDefLeftCount)

    self.round_num:setString(data.lRound + 1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIObverse

--endregion

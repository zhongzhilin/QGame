--region LastItem.lua
--Author : Administrator
--Date   : 2016/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local LastItem  = class("LastItem", function() return gdisplay.newWidget() end )

function LastItem:ctor(data)
    
    self:CreateUI(data)
end

function LastItem:CreateUI(data)
    local root = resMgr:createWidget("battle/inside_torret_node")
    self:initUI(root,data)
end

function LastItem:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/inside_torret_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.round_num = self.root.round_num_export
    self.atk_dis_num = self.root.atk_node.atk_dis_num_export
    self.atk_num = self.root.atk_node.atk_num_export
    self.atk_destory_num = self.root.atk_node.atk_destory_num_export
    self.atk_soldier_name = self.root.atk_node.atk_soldier_name_export
    self.atk_army_name = self.root.atk_node.atk_army_name_export
    self.torret_num = self.root.torret_node.torret_num_export
    self.torret_damage_num = self.root.torret_node.torret_damage_num_export
    self.torret_dis_num = self.root.torret_node.torret_dis_num_export
    self.loss_num = self.root.torret_node.loss_num_export

--EXPORT_NODE_END

    self.atk_soldier_name:setString(luaCfg:get_soldier_property_by(data.lAtkSoldierid).name)
    -- self.atk_damage_num:setString(data.lAtkDamage)
    self.atk_dis_num:setString(data.lAtkLosCount)
    self.atk_num:setString(data.lAtkLeftCount)
    self.atk_destory_num:setString(data.lAtkDamage)
    self.torret_num:setString(data.lDefCount)
    self.torret_damage_num:setString(data.lDefDamage)
    self.torret_dis_num:setString(data.lDefLosCount)
    self.loss_num:setString(data.lDefLeftCount)
    -- self.atk_army_name:setStin
    -- self.def_soldier_name:setString(luaCfg:get_def_device_by(data.lDefSoldierid).name)
    -- self.def_damage_num:setString(data.lDefDamage)
    -- self.def_dis_num:setString(data.lDefLosCount)
    -- self.def_num:setString(data.lDefLeftCount)

    self.round_num:setString(data.lRound + 1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return LastItem

--endregion

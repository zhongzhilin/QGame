--region UIOutside2.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOutside2  = class("UIOutside2", function() return gdisplay.newWidget() end )

function UIOutside2:ctor(data,round)
    
    self:CreateUI(data,round)
end

function UIOutside2:CreateUI(data,round)
    local root = resMgr:createWidget("battle/outside_2rd_round_node")
    self:initUI(root,data,round)
end

function UIOutside2:initUI(root,data,round)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/outside_2rd_round_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.damage_num = self.root.damage_num_export
    self.soldier_num = self.root.soldier_num_export
    self.soldier_name = self.root.soldier_name_export
    self.army_name = self.root.army_name_export
    self.destroy_num = self.root.destroy_num_export

--EXPORT_NODE_END

    local sd = luaCfg:get_soldier_property_by(data.lid)
    self.damage_num:setString(data.lDamage)
    self.soldier_num:setString(data.lcount)
    self.soldier_name:setString(sd.name)
    self.destroy_num:setString(data.lPower)
    -- self.round_num:setString(round)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIOutside2

--endregion

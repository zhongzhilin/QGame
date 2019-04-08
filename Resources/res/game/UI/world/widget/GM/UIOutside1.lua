--region UIOutside1.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOutside1  = class("UIOutside1", function() return gdisplay.newWidget() end )

function UIOutside1:ctor(data,round)
   
   self:CreateUI(data,round) 
end

function UIOutside1:CreateUI(data,round)
    local root = resMgr:createWidget("battle/outside_1st_round_node")
    self:initUI(root,data,round)
end

function UIOutside1:initUI(root,data,round)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/outside_1st_round_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.round_num = self.root.round_num_export
    self.soldier_name = self.root.soldier_name_export
    self.army_name = self.root.army_name_export
    self.dis_num = self.root.dis_num_export
    self.num = self.root.num_export
    self.device_name = self.root.device_name_export
    self.device_num = self.root.device_num_export
    self.kill_num = self.root.kill_num_export

--EXPORT_NODE_END

    local sd = luaCfg:get_soldier_property_by(data.lSoldierid)
    local td = luaCfg:get_def_device_by(data.lTrapid)
    self.army_name:setString(data.lTroopid)
    self.soldier_name:setString(sd.name)
    self.round_num:setString(round)
    self.dis_num:setString(data.lCosDamage)
    self.num:setString(data.lleftCount)
    self.device_name:setString(td.name)
    self.device_num:setString(data.lCount)
    self.kill_num:setString(data.lCosDamage)
    -- self.kill_num:setString()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIOutside1

--endregion

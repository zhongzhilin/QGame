--region UISoldier1.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldier1  = class("UISoldier1", function() return gdisplay.newWidget() end )

function UISoldier1:ctor(data)
    
    self:CreateUI(data)
end

function UISoldier1:CreateUI(data)
    local root = resMgr:createWidget("battle/soldier_start_node")
    self:initUI(root,data)
end

function UISoldier1:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/soldier_start_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.soldier_name = self.root.soldier_name_export
    self.soldier_num = self.root.soldier_num_export

--EXPORT_NODE_END

	local sd = luaCfg:get_soldier_property_by(data.lID)
    if sd then
    	self.soldier_name:setString(sd.name)    	
    end
    self.soldier_num:setString(data.lCount)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISoldier1

--endregion

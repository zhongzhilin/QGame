--region UISoldierEnd.lua
--Author : Administrator
--Date   : 2016/11/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldierEnd  = class("UISoldierEnd", function() return gdisplay.newWidget() end )

function UISoldierEnd:ctor(data)
    
    self:CreateUI(data)
end

function UISoldierEnd:CreateUI(data)
    local root = resMgr:createWidget("battle/soldier_end_node")
    self:initUI(root,data)
end

function UISoldierEnd:initUI(root,data)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/soldier_end_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.soldier_name = self.root.soldier_name_export
    self.soldier_num = self.root.soldier_num_export
    self.soldier_name1 = self.root.soldier_name1_export
    self.soldier_true_num = self.root.soldier_true_num_export

--EXPORT_NODE_END

    -- dump(data)

    local sd = luaCfg:get_soldier_property_by(data.lID)
    self.soldier_name:setString(sd.name)
    self.soldier_name1:setString(sd.name)
    self.soldier_num:setString(data.lLosCount)
    self.soldier_true_num:setString(data.lCount)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISoldierEnd

--endregion

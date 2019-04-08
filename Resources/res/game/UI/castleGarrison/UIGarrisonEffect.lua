--region UIGarrisonEffect.lua
--Author : yyt
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonEffect  = class("UIGarrisonEffect", function() return gdisplay.newWidget() end )

function UIGarrisonEffect:ctor()
    self:CreateUI()
end

function UIGarrisonEffect:CreateUI()
    local root = resMgr:createWidget("castle_garrison/castle_effect_node")
    self:initUI(root)
end

function UIGarrisonEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/castle_effect_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.effect_1 = self.root.effect_1_export
    self.effect_2 = self.root.effect_2_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- {lBuffid = 47, lValue = 100}
function UIGarrisonEffect:setData(data)
    -- body
    self.data = data
    local typeConfig = global.luaCfg:get_data_type_by(data.lBuffid)
    self.effect_1:setString(typeConfig.paraName)
    self.effect_2:setString("+" .. data.lValue .. typeConfig.extra)
end

--CALLBACKS_FUNCS_END

return UIGarrisonEffect

--endregion

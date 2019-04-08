--region UIGarrisonSelectEffect.lua
--Author : yyt
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonSelectEffect  = class("UIGarrisonSelectEffect", function() return gdisplay.newWidget() end )

function UIGarrisonSelectEffect:ctor()
    
end

function UIGarrisonSelectEffect:CreateUI()
    local root = resMgr:createWidget("castle_garrison/effect_detail_node")
    self:initUI(root)
end

function UIGarrisonSelectEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/effect_detail_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.effect_text = self.root.effect_text_export
    self.upNum = self.root.effect_text_export.upNum_export
    self.up = self.root.effect_text_export.upNum_export.up_export
    self.down = self.root.effect_text_export.upNum_export.down_export
    self.effect_num = self.root.effect_text_export.effect_num_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonSelectEffect:setData(data, firstBuffs)
    -- body

    self.data = data
    self.upNum:setVisible(false)
    local typeConfig = global.luaCfg:get_data_type_by(data.lBuffid)
    self.effect_text:setString(typeConfig.paraName)
    self.effect_num:setString("+" .. data.lValue .. typeConfig.extra)
    if firstBuffs then
        local addVal = data.lValue - firstBuffs.lValue 
        self.upNum:setVisible(addVal ~= 0)
        self.upNum:setString(math.abs(addVal) .. typeConfig.extra)
        if addVal > 0 then
            self.upNum:setTextColor(cc.c3b(87, 213, 63))
            self.up:setVisible(true)
            self.down:setVisible(false)
        else
            self.upNum:setTextColor(gdisplay.COLOR_RED)
            self.up:setVisible(false)
            self.down:setVisible(true)
        end
    end
end

--CALLBACKS_FUNCS_END

return UIGarrisonSelectEffect

--endregion

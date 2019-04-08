--region UITechDetailItem.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechDetailItem  = class("UITechDetailItem", function() return gdisplay.newWidget() end )

function UITechDetailItem:ctor()
    self:CreateUI()
end

function UITechDetailItem:CreateUI()
    local root = resMgr:createWidget("science/detail_node")
    self:initUI(root)
end

function UITechDetailItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/detail_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.Node_1.bg_export
    self.lv = self.root.Node_1.lv_export
    self.num1 = self.root.Node_1.num1_export
    self.combat = self.root.Node_1.combat_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITechDetailItem:setData(data)
    
    self.lv:setString(data.lv)

    local buffData = luaCfg:get_data_type_by(data.buff)
    self.num1:setString("+"..data.buffNum..buffData.extra)
    self.combat:setString(data.combat)
    self.bg:setVisible(data.lv%2 == 0)
end

--CALLBACKS_FUNCS_END

return UITechDetailItem

--endregion

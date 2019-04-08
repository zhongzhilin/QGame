--region InfoNode3.lua
--Author : yyt
--Date   : 2016/10/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local InfoNode3  = class("InfoNode3", function() return gdisplay.newWidget() end )

function InfoNode3:ctor()
    self:CreateUI()
end

function InfoNode3:CreateUI()
    local root = resMgr:createWidget("city/building_3info")
    self:initUI(root)
end

function InfoNode3:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building_3info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.lv = self.root.lv_export
    self.num1 = self.root.num1_export
    self.combat = self.root.combat_export
    self.currentBg = self.root.currentBg_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function InfoNode3:setData( data )

    self.bg:setVisible(data.level%2==0)
    self.lv:setString(data.level)
    self.combat:setString(data.combat)
   
    local i = 1
    for _,v in pairs(data.data) do
        local str = data["para"..i.."Num"]
        local dataType = global.luaCfg:get_data_type_by(v)
        if dataType.extra ~= "" then
            str = str..dataType.extra
        end
        self["num"..i]:setString(str)
        i = i + 1
    end

    self.currentBg:setVisible(global.panelMgr:getPanel("UICityDetailPanel"):isCurrLv(data.level))
end

--CALLBACKS_FUNCS_END

return InfoNode3

--endregion

--region UIWorldMapBtn.lua
--Author : untory
--Date   : 2016/09/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldMapBtn  = class("UIWorldMapBtn", function() return gdisplay.newWidget() end )

function UIWorldMapBtn:ctor()
    
end

function UIWorldMapBtn:CreateUI()
    local root = resMgr:createWidget("world/world_map")
    self:initUI(root)
end

function UIWorldMapBtn:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_map")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_state = self.root.btn_state_export
    self.icon = self.root.btn_state_export.icon_export
    self.txt_count_export = self.root.btn_state_export.txt_count_export_mlan_5

    uiMgr:addWidgetTouchHandler(self.btn_state, function(sender, eventType) self:onStateHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWorldMapBtn:onStateHandler(sender, eventType)

    local truePos = global.g_worldview.mapPanel:getTruePos()
    if global.g_worldview.worldPanel.mainCityPos ~= nil and truePos ~= nil then

        local panel = global.panelMgr:openPanel("UINewWorldMap")
        panel:setCurrentPos(truePos)
    end    
end
--CALLBACKS_FUNCS_END

return UIWorldMapBtn

--endregion

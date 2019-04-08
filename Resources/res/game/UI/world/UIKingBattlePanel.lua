--region UIKingBattlePanel.lua
--Author : Untory
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIKingBattlePanel  = class("UIKingBattlePanel", function() return gdisplay.newWidget() end )

function UIKingBattlePanel:ctor()
    self:CreateUI()
end

function UIKingBattlePanel:CreateUI()
    local root = resMgr:createWidget("world/Kingseat/Kingseat")
    self:initUI(root)
end

function UIKingBattlePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/Kingseat/Kingseat")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.close_node = self.root.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.close_node_export)

    uiMgr:addWidgetTouchHandler(self.root.Node_1.Button_1, function(sender, eventType) self:onInfoClick(sender, eventType) end)
--EXPORT_NODE_END

    self.close_node:setData(function()
        
        global.panelMgr:closePanelForBtn("UIKingBattlePanel")
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIKingBattlePanel:onInfoClick(sender, eventType)

        -- global.tipsMgr:showWarning("activity_closed")
        local data =global.luaCfg:get_introduction_by(22)
        local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
        infoPanel:setData(data)

end

--CALLBACKS_FUNCS_END

return UIKingBattlePanel

--endregion

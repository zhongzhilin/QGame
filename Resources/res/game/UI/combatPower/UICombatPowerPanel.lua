--region UICombatPowerPanel.lua
--Author : yyt
--Date   : 2016/11/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UICombatItem = require("game.UI.combatPower.UICombatItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICombatPowerPanel  = class("UICombatPowerPanel", function() return gdisplay.newWidget() end )

function UICombatPowerPanel:ctor()
    self:CreateUI()
end

function UICombatPowerPanel:CreateUI()
    local root = resMgr:createWidget("combatpower/combat_power_bg")
    self:initUI(root)
end

function UICombatPowerPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "combatpower/combat_power_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.all_combat = self.root.Node_export.all_combat_export
    self.all_norank = self.root.Node_export.all_norank_mlan_4_export
    self.all_rank = self.root.Node_export.all_rank_export
    self.itemLayout = self.root.Node_export.itemLayout_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.more_rank_btn, function(sender, eventType) self:moreRank_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICombatPowerPanel:setData(data)
   
    if data == nil then return end

    self.data = data
    self.all_combat:setString(data[1].lValue)
    if data[1].lRank == -1 then
        self.all_rank:setVisible(false)
        self.all_norank:setString(luaCfg:get_local_string(10059))
    else
        self.all_norank:setVisible(false)
        self.all_rank:setVisible(true)
        self.all_rank:setString(data[1].lRank)
    end

    self:initCombat()
end

function UICombatPowerPanel:initCombat()
   
    self.ScrollView_1:removeAllChildren()

    local itemH = self.itemLayout:getContentSize().height
    local scroW = self.ScrollView_1:getContentSize().width
    local containerSize = (#self.data)*itemH 
    self.ScrollView_1:setInnerContainerSize(cc.size( scroW , containerSize ))

    local pY = self.ScrollView_1:getInnerContainerSize().height - itemH/2
    local i = 0
    for k,v in pairs(self.data) do
        
        if k > 1 then
            local item = UICombatItem.new()
            item:setPosition(cc.p(scroW/2-5, pY - itemH*i))
            item:setData(v)
            if i%2==0 then
                item.bg:setVisible(false)
            else
                item.bg:setVisible(true)
            end
            self.ScrollView_1:addChild(item)
            i = i + 1
        end
    end

end

function UICombatPowerPanel:exit(sender, eventType)
    global.panelMgr:closePanel("UICombatPowerPanel")
end

function UICombatPowerPanel:moreRank_click(sender, eventType)
    global.panelMgr:openPanel("UIRankPanel")
end
--CALLBACKS_FUNCS_END

return UICombatPowerPanel

--endregion

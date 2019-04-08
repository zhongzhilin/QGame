--region UIGMBattlePanel.lua
--Author : untory
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIGMBattlePanel  = class("UIGMBattlePanel", function() return gdisplay.newWidget() end )

function UIGMBattlePanel:ctor()
    self:CreateUI()
end

function UIGMBattlePanel:CreateUI()
    local root = resMgr:createWidget("ui/debug_simtest")
    self:initUI(root)
end

function UIGMBattlePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "ui/debug_simtest")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.target = self.root.Node_export.target_export
    self.itemId = self.root.Node_export.itemId_export
    self.itemId = UIInputBox.new()
    uiMgr:configNestClass(self.itemId, self.root.Node_export.itemId_export)
    self.itemCount = self.root.Node_export.itemCount_export
    self.itemCount = UIInputBox.new()
    uiMgr:configNestClass(self.itemCount, self.root.Node_export.itemCount_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn01, function(sender, eventType) self:attack_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn02, function(sender, eventType) self:attack_city_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn03, function(sender, eventType) self:lueduo_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn04, function(sender, eventType) self:zhencha_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn05, function(sender, eventType) self:sim_attack(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn06, function(sender, eventType) self:zhufang_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIGMBattlePanel:testFight(attackType)
    
    global.worldApi:GMRobotFight("robot" .. self.itemId:getString(), "robot" .. self.itemCount:getString(), global.g_worldview.worldPanel.chooseCityId or 0, attackType, function(msg)
        
        global.panelMgr:closePanel("UIGMBattlePanel")
    end)
end

function UIGMBattlePanel:onEnter()
    if global.g_worldview and global.g_worldview.worldPanel then
        self.target:setString(global.g_worldview.worldPanel.chooseCityName)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGMBattlePanel:exit(sender, eventType)

    global.panelMgr:closePanel("UIGMBattlePanel")
end

function UIGMBattlePanel:attack_call(sender, eventType)

    self:testFight(2)
end

function UIGMBattlePanel:attack_city_call(sender, eventType)

    self:testFight(1)
end

function UIGMBattlePanel:lueduo_call(sender, eventType)

    self:testFight(6)
end

function UIGMBattlePanel:zhencha_call(sender, eventType)

    self:testFight(3)
end

function UIGMBattlePanel:sim_attack(sender, eventType)

    self:testFight(-1)
end

function UIGMBattlePanel:zhufang_call(sender, eventType)

    self:testFight(4)
end
--CALLBACKS_FUNCS_END

return UIGMBattlePanel

--endregion

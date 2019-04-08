--region UIUWarDefChoicePanel.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarDefChoicePanel  = class("UIUWarDefChoicePanel", function() return gdisplay.newWidget() end )

function UIUWarDefChoicePanel:ctor()
    self:CreateUI()
end

function UIUWarDefChoicePanel:CreateUI()
    local root = resMgr:createWidget("union/union_battle_helpdef")
    self:initUI(root)
end

function UIUWarDefChoicePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_helpdef")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.collection = self.root.Node_export.collection_export
    self.attack = self.root.Node_export.attack_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:onCancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:onSureHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUWarDefChoicePanel:setData(lMapID,closeCall)
    self.m_lMapID = lMapID
    self.m_closeCall = closeCall
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarDefChoicePanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUWarDefChoicePanel")
end

function UIUWarDefChoicePanel:onCancelHandler(sender, eventType)
    global.panelMgr:closePanel("UIUWarDefChoicePanel")
end

function UIUWarDefChoicePanel:onSureHandler(sender, eventType)
    local function callback(msg)
        if self.m_closeCall then self.m_closeCall(1) end
        global.tipsMgr:showWarning("UnionBattle04")
        self:onCloseHanler()
    end
    global.unionApi:askSupportForAllyWar(callback,self.m_lMapID,4)
end
--CALLBACKS_FUNCS_END

return UIUWarDefChoicePanel

--endregion

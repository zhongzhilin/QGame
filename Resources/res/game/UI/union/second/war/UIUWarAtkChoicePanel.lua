--region UIUWarAtkChoicePanel.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarAtkChoicePanel  = class("UIUWarAtkChoicePanel", function() return gdisplay.newWidget() end )

function UIUWarAtkChoicePanel:ctor()
    self:CreateUI()
end

function UIUWarAtkChoicePanel:CreateUI()
    local root = resMgr:createWidget("union/union_battle_helpatk")
    self:initUI(root)
end

function UIUWarAtkChoicePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_helpatk")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_1.gj_btn, function(sender, eventType) self:onHelpGJHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_2.gc_btn, function(sender, eventType) self:onHelpGCHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_3.ld_btn, function(sender, eventType) self:onHelpLDHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUWarAtkChoicePanel:setData(lMapID,closeCall, defCityName)
    self.m_lMapID = lMapID
    self.m_closeCall = closeCall
    self.defCityName = defCityName
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarAtkChoicePanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUWarAtkChoicePanel")
end
-- 支援类型 0:无  1：攻城 2：攻击 4：增援 6：掠夺
function UIUWarAtkChoicePanel:onHelpGJHandler(sender, eventType)
    local function callback(msg)
        if self.m_closeCall then self.m_closeCall(1) end
        self:sendHelpChat()
        global.tipsMgr:showWarning("UnionBattle04")
        self:onCloseHanler()
    end
    global.unionApi:askSupportForAllyWar(callback,self.m_lMapID,2)
end

function UIUWarAtkChoicePanel:onHelpGCHandler(sender, eventType)
    local function callback(msg)
        if self.m_closeCall then self.m_closeCall(1) end
        self:sendHelpChat()
        global.tipsMgr:showWarning("UnionBattle04")
        self:onCloseHanler()
    end
    global.unionApi:askSupportForAllyWar(callback,self.m_lMapID,1)
end

function UIUWarAtkChoicePanel:onHelpLDHandler(sender, eventType)
    local function callback(msg)
        if self.m_closeCall then self.m_closeCall(1) end
        self:sendHelpChat()
        global.tipsMgr:showWarning("UnionBattle04")
        self:onCloseHanler()
    end
    global.unionApi:askSupportForAllyWar(callback,self.m_lMapID,6)
end

function UIUWarAtkChoicePanel:sendHelpChat()
    
    local tagSpl = {}
    tagSpl.lKey = 8
    tagSpl.lValue  = -1
    tagSpl.szParam = ""
    tagSpl.szInfo = self.defCityName or ""
    tagSpl.lTime  = global.dataMgr:getServerTime()   

    global.chatApi:senderMsg(function(msg)
        
        global.chatData:addChat(3, msg.tagMsg or {})
        global.chatData:setCurLType(3)
        global.chatData:setCurChatPage(3)
    end, 3, "", global.userData:getUserId(), 0, tagSpl)
end

--CALLBACKS_FUNCS_END

return UIUWarAtkChoicePanel

--endregion

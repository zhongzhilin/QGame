--region UIBattleShare.lua
--Author : yyt
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleShare  = class("UIBattleShare", function() return gdisplay.newWidget() end )

function UIBattleShare:ctor()
    
end

function UIBattleShare:CreateUI()
    local root = resMgr:createWidget("mail/mail_war_share")
    self:initUI(root)
end

function UIBattleShare:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_war_share")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.closePanel = self.root.closePanel_export

    uiMgr:addWidgetTouchHandler(self.closePanel, function(sender, eventType) self:hidePanel_export(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.btnCancel, function(sender, eventType) self:cancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btnCountry, function(sender, eventType) self:countryShareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btnUnion, function(sender, eventType) self:unionShareHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBattleShare:setData(szReportid, curPanel)
    
    -- 战报id
    self.szReportid = szReportid
    self.curPanel = curPanel
end

function UIBattleShare:hidePanel_export(sender, eventType)
    
    if not self.curPanel then return end
    local panel = global.panelMgr:getPanel(self.curPanel)
    if panel.hideSharePanel then
        panel:hideSharePanel()
    end
end

function UIBattleShare:cancelHandler(sender, eventType)
    
    if not self.curPanel then return end
    local panel = global.panelMgr:getPanel(self.curPanel)
    if panel.hideSharePanel then
        panel:hideSharePanel()
    end
end

function UIBattleShare:countryShareHandler(sender, eventType)

    local tagSpl = {}
    tagSpl.lKey = 1
    tagSpl.lValue = 0
    tagSpl.szParam = self.szReportid
    tagSpl.szInfo = global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    local szContent = ""
    local lFromId = global.userData:getUserId()

    global.chatApi:senderMsg(function(msg)

        global.chatData:setCurLType(2)
        global.chatData:setCurChatPage(2)

        local isFirst = global.chatData:getFirstPush(2)
        if not isFirst then
            global.chatData:addChat(2, msg.tagMsg or {})
        end

        global.panelMgr:openPanel("UIChatPanel")

        if self.curPanel == "UIMailBattlePanel" then
            global.panelMgr:closePanel(self.curPanel)
            global.panelMgr:closePanel("UIMailListPanel")
            global.panelMgr:closePanel("UIMailPanel")
            global.panelMgr:getPanel("UIMailPanel"):setPosition(cc.p(0, 0))
        end

    end, 2, szContent, lFromId, 0, tagSpl )

end

function UIBattleShare:unionShareHandler(sender, eventType)

    local allyId = global.userData:getlAllyID()
    if allyId == 0 then
        global.tipsMgr:showWarning("ChatUnionNo")
        return
    end
    
    local tagSpl = {}
    tagSpl.lKey = 1
    tagSpl.lValue = 0
    tagSpl.szParam = self.szReportid
    tagSpl.szInfo = global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    local szContent = ""
    local lFromId = global.userData:getUserId()

    global.chatApi:senderMsg(function(msg)

        global.chatData:setCurLType(3)
        global.chatData:setCurChatPage(3)

        local isFirst = global.chatData:getFirstPush(3)
        if not isFirst then
            global.chatData:addChat(3, msg.tagMsg or {})
        end

        global.panelMgr:openPanel("UIChatPanel")
         
        if self.curPanel == "UIMailBattlePanel" then
            global.panelMgr:closePanel(self.curPanel)
            global.panelMgr:closePanel("UIMailListPanel")
            global.panelMgr:closePanel("UIMailPanel")
            global.panelMgr:getPanel("UIMailPanel"):setPosition(cc.p(0, 0))
        end

    end, 3, szContent, lFromId, 0,  tagSpl )

end
--CALLBACKS_FUNCS_END

return UIBattleShare

--endregion

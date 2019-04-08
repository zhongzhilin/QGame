--region UIMailWritePanel.lua
--Author : yyt
--Date   : 2016/12/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIMailWritePanel  = class("UIMailWritePanel", function() return gdisplay.newWidget() end )

function UIMailWritePanel:ctor()
    self:CreateUI()
end

function UIMailWritePanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_write_bg")
    self:initUI(root)
end

function UIMailWritePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_write_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.common_title = self.root.common_title_export
    self.mail_1_title = self.root.common_title_export.mail_1_title_fnt_mlan_12_export
    self.mail_name_bg = self.root.mail_name_bg_export
    self.tf_Title = self.root.mail_name_bg_export.tf_Title_export
    self.tf_Title = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Title, self.root.mail_name_bg_export.tf_Title_export)
    self.tf_Content = self.root.mail_name_bg_export.tf_Content_export
    self.tf_Content = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Content, self.root.mail_name_bg_export.tf_Content_export)
    self.btn_sentMail = self.root.btn_sentMail_export

    uiMgr:addWidgetTouchHandler(self.btn_sentMail, function(sender, eventType) self:senderMail(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_more, function(sender, eventType) self:selectUser(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)

    self.tf_Content:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMailWritePanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 
 
function UIMailWritePanel:onEnter()
    
    self.tf_Title:setString("")
    self.tf_Content:setString("")

    self:addEventListener(global.gameEvent.EV_ON_UNION_SELECTUSER, function (event, msg)
        self:setSelectUser(msg)
    end)

end

function UIMailWritePanel:setSelectUser(data)
    self.tf_Title:setString(data.szName or "")
end

function UIMailWritePanel:senderMail(sender, eventType)

    local szto = self.tf_Title:getString() 
    local szContent = self.tf_Content:getString() 
    local lFromId = global.userData:getUserId()

    local tagSpl = {}
    tagSpl.lKey = 0
    tagSpl.lValue = 0
    tagSpl.szParam = ""
    tagSpl.szInfo = ""
    tagSpl.lTime = 0

    if szto == "" or szto == " " then
        global.tipsMgr:showWarning("NoSentPlayer")
        return
    end

    if szContent ~= "" and szContent ~= " " then
    
        global.chatApi:senderMsg(function(msg)

            msg.tagMsg = msg.tagMsg or {}
            msg.tagMsg.lTo = msg.tagMsg.lTo or 0 
            global.panelMgr:closePanel("UIMailWritePanel")
            global.chatData:addChat(tonumber(msg.tagMsg.lTo), msg.tagMsg or {})
            global.panelMgr:openPanel("UIChatPrivatePanel"):init(tonumber(msg.tagMsg.lTo), szto)
        
        end, 1, szContent, lFromId, 0, tagSpl ,szto )
    else
        global.tipsMgr:showWarning("mailEmpty")
    end

end

function UIMailWritePanel:selectUser(sender, eventType)
    global.panelMgr:openPanel("UIUnionAskPanel"):setData(nil, nil, 1)
end

function UIMailWritePanel:btn_exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMailWritePanel")
end


function UIMailWritePanel:searchXY_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIMailWritePanel

--endregion

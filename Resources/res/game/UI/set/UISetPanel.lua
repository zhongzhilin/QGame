--region UISetPanel.lua
--Author : untory
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr


-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UISetPanel  = class("UISetPanel", function() return gdisplay.newWidget() end )

function UISetPanel:ctor()
    self:CreateUI()
end

function UISetPanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_1st")
    self:initUI(root)
end

function UISetPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_1st")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UISetTIme.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.title = self.root.title_export
    self.account_btn = self.root.account_btn_export
    self.server_btn = self.root.server_btn_export
    self.lanuage_btn = self.root.lanuage_btn_export
    self.sound_btn = self.root.sound_btn_export
    self.message_btn = self.root.message_btn_export
    self.gift_btn = self.root.gift_btn_export
    self.perform_btn = self.root.perform_btn_export
    self.developer_btn = self.root.developer_btn_export
    self.shieldUser_btn = self.root.shieldUser_btn_export
    self.FAQ_btn = self.root.FAQ_btn_export
    self.private_btn = self.root.private_btn_export
    self.invite_btn = self.root.invite_btn_export
    self.notice_btn = self.root.notice_btn_export

    uiMgr:addWidgetTouchHandler(self.account_btn, function(sender, eventType) self:setAccount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.server_btn, function(sender, eventType) self:server_set(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.lanuage_btn, function(sender, eventType) self:setLanguage(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.sound_btn, function(sender, eventType) self:openSound(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.message_btn, function(sender, eventType) self:onClickPushMessage(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.gift_btn, function(sender, eventType) self:onbtgiftcode(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.perform_btn, function(sender, eventType) self:onPerformance(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.developer_btn, function(sender, eventType) self:onBtDeveloperList(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.shieldUser_btn, function(sender, eventType) self:onShieldUserList(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.FAQ_btn, function(sender, eventType) self:onFAQClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.private_btn, function(sender, eventType) self:onprivateClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.invite_btn, function(sender, eventType) self:oninviteClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.notice_btn, function(sender, eventType) self:noticeClick(sender, eventType) end)
--EXPORT_NODE_END
    
    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local serverData = global.ServerData:getServerDataBy(global.loginData:getCurServerId())
    if global.ServerData:isIosCheckSvr(serverData.check) then
        self.gift_btn:setVisible(false)
    else
        self.gift_btn:setVisible(true)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISetPanel:openSound(sender, eventType)

    global.panelMgr:openPanel("UISetSoundPanel")
end

function UISetPanel:exit_call(sender,e)
    
    global.panelMgr:closePanelForBtn("UISetPanel")
end


function UISetPanel:onBtDeveloperList(sender, eventType)
  --  global.panelMgr:closePanelForBtn("UISetPanel")
      global.panelMgr:openPanel("UIDeveloperPanel")
end

function UISetPanel:onbtgiftcode(sender, eventType)
   -- global.panelMgr:closePanel("UISetPanel")
     global.panelMgr:openPanel("UIGiftCodePanel")
end

function UISetPanel:onPerformance(sender, eventType)
     global.panelMgr:openPanel("UISetPerformancePanel")
end

function UISetPanel:onShieldUserList(sender, eventType)
    
    local shieldData = global.chatData:getShield()
    if #shieldData == 0 then
        global.tipsMgr:showWarning("NO_BLACK_LIST")
        return
    end

    global.panelMgr:openPanel("UIShieldUserPanel")
end

function UISetPanel:setLanguage(sender, eventType)
    global.panelMgr:openPanel("UISetLanguagePanel")
end

function UISetPanel:onClickPushMessage(sender, eventType)
    global.panelMgr:openPanel("UIPushMessgePanel")
end

function UISetPanel:setAccount(sender, eventType)
    global.panelMgr:openPanel("UISetAccountPanel")
end

function UISetPanel:server_set(sender, eventType)
    global.panelMgr:openPanel("UIServerSwitchPanel")
end


function UISetPanel:onFAQClick(sender, eventType)
    global.sdkBridge:hs_showFAQs()
end

function UISetPanel:onprivateClick(sender, eventType)
    global.panelMgr:openPanel("UISwitchPanel"):setData(1)
end

function UISetPanel:oninviteClick(sender, eventType)

    global.panelMgr:openPanel("UIInvitePanel")

end

function UISetPanel:noticeClick(sender, eventType)
    global.panelMgr:openPanel("UICustomNoticePanel")
end
--CALLBACKS_FUNCS_END

return UISetPanel

--endregion

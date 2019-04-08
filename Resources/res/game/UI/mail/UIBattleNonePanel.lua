--region UIBattleNonePanel.lua
--Author : yyt
--Date   : 2016/12/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleNonePanel  = class("UIBattleNonePanel", function() return gdisplay.newWidget() end )

function UIBattleNonePanel:ctor()
    self:CreateUI()
end

function UIBattleNonePanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_war_none_bg")
    self:initUI(root)
end

function UIBattleNonePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_war_none_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.common_title = self.root.common_title_export
    self.texTitleHead = self.root.common_title_export.texTitleHead_fnt_mlan_12_export
    self.btn_deleteMail = self.root.btn_deleteMail_export
    self.date = self.root.date_export
    self.mailTitle = self.root.mailTitle_export

    uiMgr:addWidgetTouchHandler(self.btn_deleteMail, function(sender, eventType) self:deleteMail(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIBattleNonePanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 
function UIBattleNonePanel:setData(data)
    
    self.data = data
    self.date:setString(global.mailData:getData(data.mailID))

    local content = ""
    local szDefName = data.tgFightReport.szDefName
    local lFightType = data.tgFightReport.lFightType
    if szDefName and szDefName ~= "" then 

        if lFightType and lFightType ~= 1 then
            local rwData = global.mailData:getDataByType(lFightType, tonumber(szDefName))
            content = rwData.name or ""
        else         
            content = szDefName
        end
    else
        content = "-"
    end

    local titleStr = global.luaCfg:get_local_string(10147)
    self.mailTitle:setString(content.." "..titleStr)
    self.btn_deleteMail:setVisible(not data.isErrorCode)

end

function UIBattleNonePanel:btn_exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIBattleNonePanel")
    self:updateInit()
end

function UIBattleNonePanel:deleteMail(sender, eventType)

    global.mailApi:actionMail({self.data.mailID}, 3, function(msg)
        global.sactionMgr:closePanelForAction("UIBattleNonePanel", "UIMailListPanel")
        global.mailData:deleteMail({self.data.mailID})
        self:updateInit()
    end)
end

function UIBattleNonePanel:updateInit()
    local  panel = global.panelMgr:getPanel("UIMailListPanel")
    panel:initData()
end

function UIBattleNonePanel:exit_call(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIBattleNonePanel

--endregion

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userDat
local mailData = global.mailData
local UIMailListItemCell  = class("UIMailListItemCell", function() return cc.TableViewCell:create() end )
local UIMailListItem = require("game.UI.mail.UIMailListItem")
local UIMailDetailPanel = require("game.UI.mail.UIMailDetailPanel")

function UIMailListItemCell:ctor()
    
    self:CreateUI()
end

function UIMailListItemCell:CreateUI()

    self.item = UIMailListItem.new() 
    self:addChild(self.item)
end

function UIMailListItemCell:onClick()

    dump(self.data, "-----> UIMailListItemCell:onClick(): ")

    if global.m_listPanel.isEditSelect then

        self.item:checkHandler()
        return
    end
    
    -- 分享战报需要标题内容
    if (mailData:isBattle(self.data.firstType)) and self.data.tgFightReport then

        local mailId = self.data.lMailID
        local defName = self.data.tgFightReport.szDefName
        local firstType = self.data.firstType
        mailData:setCurMailTitleStr(firstType, self.data.tgFightReport.lFightType , mailId, defName, self.item:getContentParm())
    end

    -- 音效播放
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")

    
    local typeId = mailData._MAILTYPEID 
    if typeId ~= 3 then

        local listPanel = global.panelMgr:getPanel("UIMailListPanel")
        listPanel.preTableOffset = listPanel.tableView:getContentOffset()
        listPanel.minOffset = listPanel.tableView:minContainerOffset().y

        local detailPanel = mailData:getMailPanel(self.data.firstType) or "UIMailDetailPanel"  
        mailData._CURRENTMAILID = self.data.mailID

        global.sactionMgr:openPanelForAction("UIMailListPanel", detailPanel)
        local mailDetailPanel = global.panelMgr:getPanel(detailPanel) 
        mailDetailPanel:setData(self.data, true)
        if typeId ~= 7 and mailDetailPanel.showCollect then
            mailDetailPanel:showCollect()
        end
        local dataM = mailData:getItemMailData(self.data.mailID)
        if dataM and dataM.state == 0 then
            global.mailApi:actionMail({self.data.mailID}, 1, function(msg)
                mailData:updataReadState(self.data.mailID)     -- 修改邮箱读取状态
            end)
        end
    else

        -- 全联盟邮件
        if self.data.lUserID == global.userData:getUserId() then
            if not global.unionData:isHadPower(25) then
                return global.tipsMgr:showWarning("unionPowerNot")
            end
            global.panelMgr:openPanel("UIUnionMailPanel")
        else
            -- 私聊
            global.chatData:removeChatByKey(self.data.lUserID)
            global.sactionMgr:openPanelForAction("UIMailListPanel", "UIChatPrivatePanel")
            local privatePanel = global.panelMgr:getPanel("UIChatPrivatePanel")
            privatePanel:setCurMsg(self.data)
            privatePanel:init(self.data.lUserID, self:getCurrChatManName(), true)
            mailData:setCurPriUnReadNum(mailData:getCurPriUnReadNum() - self.data.lNewCount)
        end
        
    end

end

function UIMailListItemCell:getCurrChatManName()
    local name = ""
    if self.data.szAllyNick and self.data.szAllyNick ~= "" then
        name = "【"..self.data.szAllyNick.."】"..self.data.szName
    else
        name = self.data.szName
    end
    return name
end

function UIMailListItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMailListItemCell:updateUI()
    self.item:setData(self.data)
end

return UIMailListItemCell
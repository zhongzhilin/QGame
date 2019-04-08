--region UIMailPanel.lua
--Author : yyt
--Date   : 2016/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gevent = gevent
local mailData = global.mailData
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UIMailPanel  = class("UIMailPanel", function() return gdisplay.newWidget() end )
local UIMailTypeItem = require("game.UI.mail.UIMailTypeItem")
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

function UIMailPanel:ctor()
    self:CreateUI()
end

function UIMailPanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_first_bg")
    self:initUI(root)
end

function UIMailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_first_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.bg = self.root.bg_export
    self.common_title = self.root.common_title_export
    self.mail_1_title = self.root.common_title_export.mail_1_title_fnt_mlan_12_export
    self.btn_addMail = self.root.btn_addMail_export
    self.top = self.root.top_export
    self.own = self.root.ListView_1.own_export
    self.union = self.root.ListView_1.union_export
    self.system = self.root.ListView_1.system_export
    self.notice = self.root.ListView_1.notice_export
    self.type_name_export = self.root.ListView_1.split_bg.type_name_export_mlan_10
    self.battle = self.root.ListView_1.battle_export
    self.battle_pvp = self.root.ListView_1.battle_pvp_export
    self.harvest = self.root.ListView_1.harvest_export
    self.collect = self.root.ListView_1.collect_export

    uiMgr:addWidgetTouchHandler(self.btn_addMail, function(sender, eventType) self:addMail(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.own, function(sender, eventType) self:own_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.union, function(sender, eventType) self:union_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.system, function(sender, eventType) self:system_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.notice, function(sender, eventType) self:notice_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.battle, function(sender, eventType) self:battle_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.battle_pvp, function(sender, eventType) self:battle_click_pvp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.harvest, function(sender, eventType) self:harvestHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collect, function(sender, eventType) self:collectMailHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)
    self.own_Node = UIMailTypeItem.new()
    self.union_Node = UIMailTypeItem.new()
    self.system_Node = UIMailTypeItem.new()
    self.notice_Node = UIMailTypeItem.new()
    self.battle_Node = UIMailTypeItem.new()
    self.battle_pvp_node = UIMailTypeItem.new()
    self.collectMail_Node = UIMailTypeItem.new()
    self.harvestMail_Node = UIMailTypeItem.new()

    self.own:addChild(self.own_Node)    
    self.union:addChild(self.union_Node) 
    self.system:addChild(self.system_Node)    
    self.notice:addChild(self.notice_Node) 
    self.battle:addChild(self.battle_Node)    
    self.battle_pvp:addChild(self.battle_pvp_node)    
    self.collect:addChild(self.collectMail_Node)
    self.harvest:addChild(self.harvestMail_Node)
    self.root.ListView_1:setScrollBarEnabled(false)
    self.own:setPressedActionEnabled(false)
    self.union:setPressedActionEnabled(false)
    self.system:setPressedActionEnabled(false)
    self.notice:setPressedActionEnabled(false)
    self.battle:setPressedActionEnabled(false)
    self.battle_pvp:setPressedActionEnabled(false)
    self.collect:setPressedActionEnabled(false)
    self.harvest:setPressedActionEnabled(false)
 

    self:adapt()
 
end

 
function UIMailPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 
 
 
function UIMailPanel:onExit()
 if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
    end
end 


function UIMailPanel:onEnter()
    --- 新消息通知监听
    self:addEventListener(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM, function ()
        
        self:initData()
    end) 

    self:initData()
    self.FileNode_1:setData(5)
end

function  UIMailPanel:initData()

    self.system_Node:setData(mailData:getMailTypeData(1))  
    self.notice_Node:setData(mailData:getMailTypeData(2))
    self.own_Node:setData(mailData:getMailTypeData(3))
    self.union_Node:setData(mailData:getMailTypeData(4))
    self.battle_Node:setData(mailData:getMailTypeData(5))
    self.battle_pvp_node:setData(mailData:getMailTypeData(6))
    self.collectMail_Node:setData(mailData:getMailTypeData(7))
    self.harvestMail_Node:setData(mailData:getMailTypeData(8))
 end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailPanel:addMail(sender, eventType)

    global.panelMgr:openPanel("UIMailWritePanel")
end

function UIMailPanel:btn_exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMailPanel") 
    gevent:call(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM) 
end


function UIMailPanel:system_click(sender, eventType)
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(1))
end

function UIMailPanel:notice_click(sender, eventType)
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(2))
end

function UIMailPanel:own_click(sender, eventType)
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(3))
end

function UIMailPanel:union_click(sender, eventType)
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(4))
end

function UIMailPanel:battle_click(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(5))
end

function UIMailPanel:battle_click_pvp(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(6))
end

function UIMailPanel:collectMailHandler(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(7))
end

function UIMailPanel:harvestHandler(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_choice")
    self:initClickData(mailData:getMailTypeData(8))
end

function  UIMailPanel:initClickData(data)
    if data == nil then return end

    mailData._MAILTITLE = data.name
    mailData._MAILTYPEID = data.typeId

    global.sactionMgr:openPanelForAction("UIMailPanel", "UIMailListPanel")
    local  mailListPanel = global.panelMgr:getPanel("UIMailListPanel")
    mailListPanel:initData(data.typeId)
end

--CALLBACKS_FUNCS_END

return UIMailPanel

--endregion

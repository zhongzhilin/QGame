--region UIChatUserInfoPanel.lua
--Author : yyt
--Date   : 2017/01/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionMemProDetails = require("game.UI.union.widget.UIUnionMemProDetails")
local UIPKHeroItem = require("game.UI.pk.UIPKHeroItem")
--REQUIRE_CLASS_END

local UIChatUserInfoPanel  = class("UIChatUserInfoPanel", function() return gdisplay.newWidget() end )

function UIChatUserInfoPanel:ctor()
    self:CreateUI()
end

function UIChatUserInfoPanel:CreateUI()
    local root = resMgr:createWidget("chat/chat_user_info")
    self:initUI(root)
end

function UIChatUserInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_user_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = UIUnionMemProDetails.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.shieldStr = self.root.Node_export.shield.shieldStr_export
    self.hero_share = self.root.Node_export.hero_share_export
    self.hero_1 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_1, self.root.Node_export.hero_share_export.hero_1)
    self.hero_2 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_2, self.root.Node_export.hero_share_export.hero_2)
    self.hero_3 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_3, self.root.Node_export.hero_share_export.hero_3)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.request, function(sender, eventType) self:mailHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.shield, function(sender, eventType) self:shieldHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.inunion, function(sender, eventType) self:onInvite(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.union, function(sender, eventType) self:onUnionDetail(sender, eventType) end)
--EXPORT_NODE_END
    self.FileNode_1:setCascadeOpacityEnabled(true)
    for i=1,3 do
        self["hero_"..i]:setCascadeOpacityEnabled(true)
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIChatUserInfoPanel:setData(data, call)

    self.FileNode_1.node_tableView:setVisible(true)

    self.data = data
    self.m_call = call

    self.FileNode_1:setParam(1)
    self.FileNode_1:setData(data, data)

    if global.chatData:isShieldUser(data.lUserID) then
        self.shieldStr:setString(global.luaCfg:get_local_string(10471))
    else
        self.shieldStr:setString(global.luaCfg:get_local_string(10470))
    end

end

function UIChatUserInfoPanel:onEnter()

    self.hero_share:setVisible(false)

end

local  luaCfg = global.luaCfg
local  panelMgr = global.panelMgr

function UIChatUserInfoPanel:setHeroData(data) 

    gdisplay.loadSpriteFrames("hero.plist")

    self:addEventListener(global.gameEvent.EV_ON_PANEL_CLOSE,function()
          gdisplay.loadSpriteFrames("hero.plist")
    end)

    self.heroData = data 
    self.hero_share:setVisible(true)
    self:setData(data.tagInfo)
    self.FileNode_1.node_tableView:setVisible(false)

    for i= 1, 3 do 
        
        local temp = self.heroData.tagHero[i]

        self["hero_"..i]:setData({heroId=temp.lID ,serverData={lGrade=temp.lGrade , lStar=temp.lStar}})

        uiMgr:addWidgetTouchHandler(self["hero_"..i].bt_bg, function(sender, eventType) 
            local call = function(msg)
                    msg.tgHero = msg.tgHero or {}
                    msg.tgEquip = msg.tgEquip or {}
                    if not msg.tgHero.lID then return end                   
                    local heroData  = {}
                    local equipData = {}
                    for index,v in ipairs(msg.tgEquip) do        
                        local equipLua = luaCfg:equipment()  
                        for _,vv in pairs(equipLua) do
                            if vv.id == v.lGID then
                                v.lType = vv.type
                                break
                            end
                        end
                        equipData[v.lType] = {id = v.lGID, lv = v.lStronglv, lType = v.lType, lCombat=v.lCombat, tgAttr=v.tgAttr}
                    end
                    heroData.equipData = equipData
                    heroData.serverData = msg.tgHero
                    panelMgr:openPanel("UIShareHero"):setData(heroData)
            end

            local msg =self:getheroInfo(temp.lID)
            call(msg)
        end)
    end 
end 

function UIChatUserInfoPanel:getheroInfo( heroId )

    local msg ={}
    msg.tgHero = msg.tgHero or {}
    msg.tgEquip = msg.tgEquip or {}

    for _ , v in pairs(self.heroData.tagEquip or {} ) do 
        if v.lHeroID == heroId then 
            table.insert( msg.tgEquip , v)
        end 
    end 

    for _ , v in pairs(self.heroData.tagHero or {} ) do 
        if v.lID ==heroId then 
             msg.tgHero  = v
        end 
    end 

    return msg
end 


function UIChatUserInfoPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIChatUserInfoPanel")
    --local curPanel = global.panelMgr:getTopPanelName()
    --if curPanel == "UIChatPanel" or curPanel == "UIChatPrivatePanel" then
       --  global.panelMgr:getPanel(curPanel):getChatData() 
    --end
end

function UIChatUserInfoPanel:mailHandler(sender, eventType)

    if global.chatData:isShieldUser(self.data.lUserID) then
        global.tipsMgr:showWarning("BLACK_LIST_SEND")
        return
    end

    if global.userData:isMine(self.data.lUserID) then
        global.tipsMgr:showWarning("unionMyNot")
        return
    end

    -- 私聊
    global.panelMgr:closePanel("UIChatUserInfoPanel")
    global.panelMgr:openPanel("UIChatPrivatePanel"):init(self.data.lUserID, self.data.szName)

end

function UIChatUserInfoPanel:shieldHandler(sender, eventType)

    if global.userData:isMine(self.data.lUserID) then
        global.tipsMgr:showWarning("unionMyNot")
        return
    end

    global.panelMgr:closePanel("UIChatUserInfoPanel")

    if global.chatData:isShieldUser(self.data.lUserID) then
        global.chatData:removeShield(self.data.lUserID)
        if self.m_call then self.m_call() end
    else

        if global.panelMgr:isPanelExist("UIChatPrivatePanel") then
            global.panelMgr:getPanel("UIChatPrivatePanel"):exit_call()
        end
        -- 加入屏蔽名单
        global.chatData:addShield(self.data.lUserID)
    end

    

end

function UIChatUserInfoPanel:onInvite(sender, eventType)
    if global.userData:isMine(self.data.lUserID) then
        global.tipsMgr:showWarning("unionMyNot")
        return
    end
    if global.unionData:isMineUnion(0) then
        return global.tipsMgr:showWarning("InvitationNOUnion")
    end
    if not global.unionData:isHadPower(14) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    if self.data.lAllyID and self.data.lAllyID ~= 0 then
        return global.tipsMgr:showWarning("InvitationUnionOk")
    end
    global.unionApi:allyAction(function(msg)
        -- body
        global.tipsMgr:showWarning("UnionInvitation")
    end,7,0,self.data.lUserID)
end

function UIChatUserInfoPanel:onUnionDetail(sender, eventType)
    if self.data.lAllyID and self.data.lAllyID ~= 0 then 
        global.unionApi:getUnionInfo(function (msg)
            msg.tgAlly = msg.tgAlly or {}
            local panel  = global.panelMgr:openPanel("UIJoinUnionPanel")
            panel:setData(msg.tgAlly)
            panel.m_inputMode  = 0
            panel:updateUI()
        end, self.data.lAllyID)
    else 
        global.tipsMgr:showWarning("castle_union")
    end       
end
--CALLBACKS_FUNCS_END

return UIChatUserInfoPanel

--endregion

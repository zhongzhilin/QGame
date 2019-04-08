--region UISharePanel.lua
--Author : untory
--Date   : 2017/05/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISharePanel  = class("UISharePanel", function() return gdisplay.newWidget() end )

function UISharePanel:ctor()
    self:CreateUI()
end

function UISharePanel:CreateUI()
    local root = resMgr:createWidget("common/common_share_panel")
    self:initUI(root)
end

function UISharePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_share_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.closePanel = self.root.closePanel_export

    uiMgr:addWidgetTouchHandler(self.closePanel, function(sender, eventType) self:hidePanel_export(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1.btn_bj.btnCancel, function(sender, eventType) self:cancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1.btnCountry, function(sender, eventType) self:countryShareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1.btnUnion, function(sender, eventType) self:unionShareHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UISharePanel:setData(shareData , okCall)
    
    self.shareData = shareData

    self.okCall = okCall
end

function UISharePanel:onEnter()
    
    self.root.Node_1:stopAllActions()
    self.root.Node_1:setPositionY(-400)
    self.root.Node_1:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.5,cc.p(0,0))))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISharePanel:hidePanel_export(sender, eventType)

    global.panelMgr:closePanel("UISharePanel")
end

function UISharePanel:cancelHandler(sender, eventType)

    global.panelMgr:closePanel("UISharePanel")
end

function UISharePanel:countryShareHandler(sender, eventType)

    if self.shareData == nil then return end

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

        if self.okCall then 
            self.okCall()
        end 

    end, 2, szContent, lFromId, 0, self.shareData )

    global.panelMgr:closePanel("UISharePanel")
end

function UISharePanel:unionShareHandler(sender, eventType)

    if global.unionData:isMineUnion(0) then
        global.tipsMgr:showWarning("ChatUnionNo")
        return
    end

    if self.shareData == nil then return end

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

        if self.okCall then 
            self.okCall()
        end 


    end, 3, szContent, lFromId, 0, self.shareData )

    global.panelMgr:closePanel("UISharePanel")
end
--CALLBACKS_FUNCS_END

return UISharePanel

--endregion

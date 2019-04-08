local global = global
local resMgr = global.resMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent
local pvpData = global.userData:GetPVPData() 

local _M = {}
_M = class("ConfirmDownloadPanel", function() return gdisplay.newWidget() end )

function _M:ctor()    

    local tipWidget = GuiReaderHelper:getInstance():widgetFromJsonFile("asset/ui/LoginIn_UpgradeTipsUI.ExportJson")
    self:addChild(tipWidget)
    self._widget = tipWidget
    tipWidget:setSize(CCSize(gdisplay.size.width, gdisplay.size.height))
    self.tipTitle = tolua.cast(ccui.Helper:seekWidgetByName(tipWidget, "Label_title"), "Label")
    self.tipContent = tolua.cast(ccui.Helper:seekWidgetByName(tipWidget, "Label_dis"), "Label")
    local tipConfirm = tolua.cast(ccui.Helper:seekWidgetByName(tipWidget, "Button_confirm"), "Button")
    tipConfirm:setTouchEnabled(true)
    tipConfirm:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            if self.callBack then
                self.callBack()
            end
        end
    end)

    local tipCancel = tolua.cast(ccui.Helper:seekWidgetByName(tipWidget, "Button_confirm_0"), "Button")
    tipCancel:setTouchEnabled(true)
    tipCancel:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            global.panelMgr:closePanel("ConfirmDownloadPanel")
            local panel = global.panelMgr:openPanel("LoginServerPanel")
            panel:HideLoadingUI()
        end
    end)

    local tipConfirmText = tolua.cast(ccui.Helper:seekWidgetByName(tipConfirm, "Label_1"), "Label")
    local tipCancelText = tolua.cast(ccui.Helper:seekWidgetByName(tipCancel, "Label_1"), "Label")

    self.tipConfirm = tipConfirm
    self.tipConfirmText = tipConfirmText
    self.tipConfirm.originText = tipConfirmText:getStringValue()
    self.tipCancel = tipCancel
    self.tipCancelText = tipCancelText
    self.tipCancel.originText = tipCancelText:getStringValue()
end

function _M:setCallBack(size, callBack)
    -- body

    self.tipConfirmText:setText(self.tipConfirm.originText)
    self.tipCancelText:setText(self.tipCancel.originText)

    self.tipConfirm:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            if self.callBack then
                self.callBack()
            end
        end
    end)

    self.tipCancel:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            global.panelMgr:closePanel("ConfirmDownloadPanel")
            local panel = global.panelMgr:openPanel("LoginServerPanel")
            panel:HideLoadingUI()
        end
    end)

    local mbCount = size / 1000
    local mbSufix = "KB"
    if mbCount < 1 then
        mbCount = size 
        mbSufix = "B"
    elseif mbCount > 1000 then
        mbCount = mbCount / 1000
        mbSufix = "MB"
    end

    local messageConfigs = require("asset.conf.message")

    local sizeStr = gformat("%0.2f%s", mbCount, mbSufix)
    local config = messageConfigs:getdata()[2000]
    self.tipTitle:setText(config.title)
    self.tipContent:setText(string.format(config.content, sizeStr))
    self.callBack = callBack
end

function _M:setData(data)

    self.tipConfirm:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            if data.confirm then
                data.confirm()
            end
        end
    end)

    self.tipCancel:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then 
            if data.cancel then
                data.cancel()
            end
        end
    end)

    self.tipConfirmText:setText(data.rightText)
    self.tipCancelText:setText(data.leftText)

    self.tipTitle:setText(data.title)
    self.tipContent:setText(data.content)
    self.callBack = nil
end

function _M:onEnter()
    self._widget:setVisible(true)
    self._widget:setTouchEnabled(true)
end

function _M:onExit()
    self._widget:setVisible(false)
    self._widget:setTouchEnabled(false)

    self.tipConfirmText:setText(self.tipConfirm.originText)
    self.tipCancelText:setText(self.tipCancel.originText)
end

return _M
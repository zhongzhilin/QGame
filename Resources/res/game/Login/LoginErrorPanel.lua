local global = global
local resMgr = global.resMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent
local pvpData = global.userData:GetPVPData()

local _M = {}
_M = class("LoginErrorPanel", function() return gdisplay.newWidget() end )

function _M:ctor()    

    local widget = global.resMgr:createWidget("LoginIn_Error")
    self._widget = widget
    self._widget:setSize(cc.size(gdisplay.size.width, gdisplay.size.height))    
    self:addChild(self._widget)    
end

function _M:setData(data, callBack)
    -- body
    local tipTitle = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "Label_title"), "Label")
    tipTitle:setText(data.title)
    local tipContent = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "Label_dis"), "Label")
    tipContent:setText(data.content)
    local tipConfirm = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "Button_confirm"), "Button")
    tipConfirm:setTouchEnabled(true)
    tipConfirm:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.ended then
            panelMgr:closePanel("LoginErrorPanel")
            if callBack ~= nil then
                callBack()
            end
        end
    end)
end

function _M:onEnter()
    self._widget:setVisible(true)
    self._widget:setTouchEnabled(true)
end

function _M:onExit()
    self._widget:setVisible(false)
    self._widget:setTouchEnabled(false)
end

return _M

local global = global
local resMgr = global.resMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent
local pvpData = global.userData:GetPVPData()

local _M = {}
_M = class("SelectServerListItem", function() return gdisplay.newWidget() end )

function _M:ctor()
    self._widget = global.resMgr:createWidget("ServerAreaButtonUI", true)
    self:addChild(self._widget)   

    local size = self._widget:getSize()

    self:ignoreContentAdaptWithSize(false)
    self:setSize(size)
    log.debug("size %s %s", size.width, size.height)

    self._widget:setPosition(cc.p(-0.5 * size.width, -0.5 * size.height))

    self.selectIcon = ccui.Helper:seekWidgetByName(self._widget, "Image_Select")

    local serverAreaBtn = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "Button_ServerArea"), "Button")
    serverAreaBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccs.TouchEventType.began then
            log.debug("OnClick serverAreaBtn")
            self:Select()
        end
    end)

    self.title = global.uiMgr:getLabel(self._widget, "Label_Area")
end

-- data = { index = index, title = "2 - 3", callBack = callBack}
function _M:setData(data)
    self.index = data.index
    self.title:setText(data.title)
    self.callBack = data.callBack
end

function _M:Select()
    if self.callBack then
        self.callBack(self.index)
    end 
    self.selectIcon:setVisible(true)
end

function _M:UnSelect()
    self.selectIcon:setVisible(false)
end

function _M:onEnter()
    self._widget:setVisible(true)
    self._widget:setTouchEnabled(true)
    self:UnSelect()
end

function _M:onExit()
    self._widget:setVisible(false)
    self._widget:setTouchEnabled(false)
end

return _M
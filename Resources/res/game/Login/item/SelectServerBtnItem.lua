local global = global
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent

local pvpData = global.userData:GetPVPData()

local tipMap = {
    [WPBCONST.EN_PLAT_DIR_ST_MAINTAIN]    = { text = global.luaCfg:get_local_string(10828), color = {134, 134, 134} },
    [WPBCONST.EN_PLAT_DIR_ST_NORMAL]     = { text = global.luaCfg:get_local_string(10829), color = {42, 224, 0} },
    [WPBCONST.EN_PLAT_DIR_ST_HOT]       = { text = global.luaCfg:get_local_string(10830), color = {224, 84, 0} },
}

local TagMap = {
    [WPBCONST.EN_PLAT_DIR_TIP_NEW] = global.luaCfg:get_local_string(10836),
    [WPBCONST.EN_PLAT_DIR_TIP_RECOM] = global.luaCfg:get_local_string(10837),
}

local _M = {}
_M = class("SelectServerBtnItem", function() return gdisplay.newWidget() end )

function _M:ctor()    

    self._widget = global.resMgr:createWidget("ServerButtonUI", true)  
    self:addChild(self._widget)

    local size = self._widget:getSize()
    self._widget:setPosition(cc.p(-0.5 * size.width, -0.5 * size.height))
    
    self.selectIcon = ccui.Helper:seekWidgetByName(self._widget, "Image_Select")

    -- self.NewIcon = ccui.Helper:seekWidgetByName(self._widget, "Image_label2")
    -- self.RecommendIcon = ccui.Helper:seekWidgetByName(self._widget, "Image_label1")

    self.serverBtn = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "Button_Server"), "Button")
    self.serverBtn:addTouchEventListener(function(sender, eventType)
        if not self.isEnabled then
            return
        end
        if eventType == ccs.TouchEventType.began then
            self:Select()
            if self.callBack then
                self.callBack(self.index)
            end
        end
    end)

    self.svrId = uiMgr:getLabel(self._widget, "Label_serverid")
    self.svrName = uiMgr:getLabel(self._widget, "Label_servername")
    self.svrState = uiMgr:getLabel(self._widget, "Label_serverstate")
end

-- data { state = 0|1|2, index = 1, svrId = 1, svrName = global.luaCfg:get_local_string(10838), tag = 0|1|2, callBack = callBack}
-- state 
--      1 维护
--      2 流畅
--      3 爆满
-- tag 
--      0 无
--      1 新区
--      2 推荐
-- callBack 选中回调
function _M:setData(data)
    -- for k, v in pairs(TagMap) do
    --     self[v]:setVisible(k == data.tag)
    -- end
    self.svrId:setText(string.format(global.luaCfg:get_local_string(10919), data.svrArea))
    self.svrName:setText(string.format("%s", data.svrName))

    local colorData = tipMap[data.state].color
    local colorValue = cc.c3b(colorData[1], colorData[2], colorData[3])

    self.svrId:setColor(colorValue)
    self.svrName:setText(data.svrName)
    self.svrName:setColor(colorValue)

    if data.tag ~= WPBCONST.EN_PLAT_DIR_TIP_NORMAL then
        self.svrState:setText(TagMap[data.tag])
    else
        self.svrState:setText(tipMap[data.state].text)
    end
    self.svrState:setColor(colorValue)

    self.callBack = data.callBack
    self.index = data.index
    self.svrData = data

    self:Enable()
end

function _M:Enable()
    self.isEnabled = true
end

function _M:Disable()
    self.isEnabled = false
end

function _M:Select()
    if self.selectIcon then
        self.selectIcon:setVisible(true)
    end
end

function _M:UnSelect()
    if self.selectIcon then
        self.selectIcon:setVisible(false)
    end
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
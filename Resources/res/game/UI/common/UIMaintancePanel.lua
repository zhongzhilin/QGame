--region UIMaintancePanel.lua
--Author : wuwx
--Date   : 2017/05/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMaintancePanel  = class("UIMaintancePanel", function() return gdisplay.newWidget() end )

function UIMaintancePanel:ctor()
    self:CreateUI()
end

function UIMaintancePanel:CreateUI()
    local root = resMgr:createWidget("loading/plat_maintance_server")
    self:initUI(root)
end

function UIMaintancePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/plat_maintance_server")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.update_node.update_bg.time_export

    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.gm_btn, function(sender, eventType) self:contactGM(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end, nil, true)
    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.gm_btn, function(sender, eventType) self:contactGM(sender, eventType) end, nil, true)

    self.root.update_node.update_bg.gm_btn:setVisible(false)

    self.root.update_node.update_bg.confirm_btn:setPositionX(300)
    if global.panelMgr:isPanelOpened("UIInputAccountPanel") then
        global.panelMgr:getPanel("UIInputAccountPanel"):closeWebLogin()
    end
end

function UIMaintancePanel:setData(isShowTime,confirmCall)
    self.time:setVisible(isShowTime)
    self.m_confirmCall = confirmCall
end

function UIMaintancePanel:setTime(timestamp)
    timestamp = tonumber(timestamp)
    local tt = global.funcGame.formatTimeToTime(timestamp)
    local hm = global.funcGame.formatTimeToHM(timestamp)
    local str = global.luaCfg:get_local_string(10682,tt.year,tt.month,tt.day,hm)
    self.time:setString(str)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMaintancePanel:confirmHandler(sender, eventType)
    if self.m_confirmCall then self.m_confirmCall() end
end

function UIMaintancePanel:contactGM(sender, eventType)
    global.sdkBridge:hs_showConversation()
end
--CALLBACKS_FUNCS_END

return UIMaintancePanel

--endregion

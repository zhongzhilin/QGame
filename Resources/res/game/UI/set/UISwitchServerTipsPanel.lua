--region UISwitchServerTipsPanel.lua
--Author : anlitop
--Date   : 2017/04/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local loginData = global.loginData

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISwitchServerTipsPanel  = class("UISwitchServerTipsPanel", function() return gdisplay.newWidget() end )

function UISwitchServerTipsPanel:ctor()
    self:CreateUI()
end

function UISwitchServerTipsPanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_switch_server_tips")
    self:initUI(root)
end

function UISwitchServerTipsPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_switch_server_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.model = self.root.model_export
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.serve_name_text = self.root.Node_export.serve_name_text_export

    uiMgr:addWidgetTouchHandler(self.model, function(sender, eventType) self:model_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:cancel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn_0, function(sender, eventType) self:go_to_server(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISwitchServerTipsPanel:setData(data)
    self.data= data
    self.serve_name_text:setString(data.servername)
end 


function UISwitchServerTipsPanel:model_click(sender, eventType)
    self:exit_call()
end

function UISwitchServerTipsPanel:cancel(sender, eventType)
    self:exit_call()
end

function UISwitchServerTipsPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UISwitchServerTipsPanel")
end

function UISwitchServerTipsPanel:go_to_server(sender, eventType)
    loginData:setCurServerId(self.serverid)
    -- local loginProc = require "game.Login.LoginProc"
    -- loginProc.loginServerQuick()
    global.panelMgr:getPanel("UILogin"):loginGame()
end
--CALLBACKS_FUNCS_END

return UISwitchServerTipsPanel

--endregion

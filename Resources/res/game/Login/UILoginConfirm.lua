--region UILoginConfirm.lua
--Author : yyt
--Date   : 2017/04/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILoginConfirm  = class("UILoginConfirm", function() return gdisplay.newWidget() end )

function UILoginConfirm:ctor()
    print(debug.traceback())
    self:CreateUI()
end

function UILoginConfirm:CreateUI()
    local root = resMgr:createWidget("loading/loading_lag1")
    self:initUI(root)
end

function UILoginConfirm:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/loading_lag1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.text = self.root.Node_export.text_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.Node_export.update_bg.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end, nil, true)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.node.btn_service, function(sender, eventType) self:onService(sender, eventType) end, nil, true)

    self.root.Node_export.node.btn_service:setVisible(false)

    if global.panelMgr:isPanelOpened("UIInputAccountPanel") then
        global.panelMgr:getPanel("UIInputAccountPanel"):closeWebLogin()
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UILoginConfirm:setData(errorCode, call, ...)
    if errorCode and (errorCode == 10619) then
        local isClientNet,netState = global.netRpc:checkClientNetAvailable()
        if isClientNet then
            -- 客户端网络正常，就认为服务器出问题了。
            global.panelMgr:closePanel("UISystemConfirm",true)
            global.netRpc:checkNetRpc(global.loginData:getCurServerId(), function(isNormal)  
                if isNormal then
                    local okcall = function(isok)
                        if not isok then
                            gscheduler.unscheduleAll()
                            global.panelMgr:closePanel("ConnectingPanel",true)
                            global.tipsMgr:showQuitConfirmPanelNoClientNet()
                        end
                    end
                    global.netRpc:reconnectSocket(okcall)
                else
                    gscheduler.unscheduleAll()
                    global.panelMgr:closePanel("ConnectingPanel",true)
                    global.tipsMgr:showQuitConfirmPanelNoClientNet()
                end
            end)
            return
        end
    end
    gscheduler.unscheduleAll()
    global.panelMgr:closePanel("ConnectingPanel",true)
	
	local str =  self:getErrorBykey(errorCode,...)
    local args = {...}
    local count = #args

    if str and count > 0 then
       str = string.format(str , unpack(args))
    end

    if str == nil then
        str = global.luaCfg:get_local_string(errorCode) or errorCode
    end
    self.text:setString(str)

    self.confirmCall = call
end

function UILoginConfirm:showClientNoNet(call, ...)    
    str = global.luaCfg:get_local_string(10619)
    
    self.text:setString(str)

    self.confirmCall = call
end

function UILoginConfirm:getErrorBykey(_errorKey,...)
    
    local  tb_error = global.luaCfg:get_errorcode_by(_errorKey)
    if not tb_error then
        tb_error = {}
        tb_error.text = nil
        return nil
    end
    return string.format(tb_error.text,...) 
end

function UILoginConfirm:confirmHandler(sender, eventType)
	if self.confirmCall then 
        self.confirmCall()
    end 
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_confirm")
    global.panelMgr:closePanel("UILoginConfirm", nil, true)

end

function UILoginConfirm:onService(sender, eventType)
    global.sdkBridge:hs_showConversation()
end
--CALLBACKS_FUNCS_END

return UILoginConfirm

--endregion

local _M = class("ActivationCodePanel", function() return gdisplay.newWidget() end )
local func = global.funcGame
local define = global.define
local uiMgr = global.uiMgr

function _M:ctor()   
    local widget = global.resMgr:createWidget("ActivationCode")
    self._widget = widget
    self._widget:setSize(cc.size(gdisplay.size.width, gdisplay.size.height))    
    self:addChild(self._widget)    
    
    self.labelTitle = uiMgr:configLabel(self._widget, "Label_title", define.STROKE_COLOR_TITLE)
    self.textCode = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "TextField_ActivationCode"), "TextField")
    self.labelError = uiMgr:getLabel(self._widget, "Label_Player_0")    
    self.labelError:setVisible(false)
    
    self.btnLink = uiMgr:configButton(self._widget, "Button_confirm")
    local gotoLink = function()
        if self.url then
            CCNative:openURL(self.url)
        end
    end
    self.btnLink:addTouchEventListener(ccs.TouchEventWrapper(gotoLink))
    
    self.btnConfirm = uiMgr:configButton(self._widget, "Button_confirm_0")    
    local activeCallBack = function(ret, msg)        
        if ret == HQCODE.OK then
            local prompt = msg.pkg.result.prompt
            if prompt == nil or prompt == WPBCONST.PROMPT_OK then
                self.labelError:setVisible(false)
                self.callBack(msg)
                global.tipsMgr:showWarning(1105)
                global.panelMgr:closePanel("ActivationCodePanel")
            elseif prompt == WPBCONST.PROMPT_CDKEY_INV_CDKEY then
                --激活码无效！
                local str = global.luaCfg:get_localization_by(10114).value
                self.labelError:setText(str)                
                self.labelError:setVisible(true)
            elseif prompt == WPBCONST.PROMPT_CDKEY_INV_TIME then                
                --激活码已过期，请重新领取！
                local str = global.luaCfg:get_localization_by(10115).value
                self.labelError:setText(str)                
                self.labelError:setVisible(true)
            end
        end
    end
    
    local checkCode = function()
        log.debug("checkCode")
        local code = self.textCode:getStringValue()
        if code ~= "" then
            self.activeFunc(code, activeCallBack)
        end
    end
    self.btnConfirm:addTouchEventListener(ccs.TouchEventWrapper(checkCode))
end

function _M:setData(activeFunc, url, callBack)
    self.activeFunc = activeFunc
    
    if url ~= nil and url ~= "" then
        self.url = url
        self.btnLink:setTouchEnabled(true)
        self.btnLink:setBright(true)
    else
        self.btnLink:setTouchEnabled(false)
        self.btnLink:setBright(false)
    end
    
    self.callBack = callBack
end

return _M




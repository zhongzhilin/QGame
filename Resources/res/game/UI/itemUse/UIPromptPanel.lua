--region UIPromptPanel.lua
--Author : yyt
--Date   : 2016/09/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPromptPanel  = class("UIPromptPanel", function() return gdisplay.newWidget() end )

function UIPromptPanel:ctor()
    self:CreateUI()
end

function UIPromptPanel:CreateUI()
    local root = resMgr:createWidget("bag/item_Prompt")
    self:initUI(root)
end

function UIPromptPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/item_Prompt")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Prompt_bg = self.root.Node_export.Prompt_bg_export
    self.text = self.root.Node_export.Prompt_bg_export.text_export
    self.richText = self.root.Node_export.Prompt_bg_export.richText_export
    self.Text_4 = self.root.Node_export.Prompt_bg_export.Button_1.Text_4_mlan_5_export
    self.Text_1 = self.root.Node_export.Prompt_bg_export.Button_2.Text_1_mlan_5_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.Prompt_bg_export.Button_1, function(sender, eventType) self:btn_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Prompt_bg_export.Button_2, function(sender, eventType) self:cancel_click(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.bg, function(sender, eventType) self:exit(sender, eventType) end)

    local oldSetString = self.text.setString
    self.text.setString = function(node,string)
        
        local size = node:getContentSize()
        node:setTextAreaSize(cc.size(node:getContentSize().width,0))

        oldSetString(node,string)

        local height = node:getVirtualRenderer():getContentSize().height                

        node:setContentSize(cc.size(size.width,height))
        node:setPositionY((height + 150) / 2 + 35)
        self.Prompt_bg:setContentSize(cc.size(694,height + 150))
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPromptPanel:setData(errorCode, callFunc, ...)
        self.callback = callFunc

        self.modalEnabled = true

        errorCode = errorCode or ""
        if not self.getErrorBykey then
            return
        end
        local args = {...}
        for i=1, 10 do --防止参数不足时 ，format 报错
            table.insert(args , i)
        end 
        local str =  self:getErrorBykey(errorCode,unpack(args))
        local count = #args

        if str == nil then
            if count > 0 then
                str = global.luaCfg:get_local_string(errorCode, unpack(args)) or errorCode
            else
                str = global.luaCfg:get_local_string(errorCode) or errorCode
            end
        end

        if str and count > 0 then
           -- str = string.format(str , unpack(args))
        end


        -- local size = self.text:getContentSize()
        -- self.text:setTextAreaSize(cc.size(self.text:getContentSize().width,0))
        
        self.text:setString(str)
        self.Prompt_bg.Button_2:setEnabled(true)
        self.Prompt_bg.Button_1:setEnabled(true)

        self.text:setVisible(true)
        self.richText:setVisible(false)

        self:setCancelLabel(10949)

        if self.richArgs then 
            self.text:setVisible(false)
            self.richText:setVisible(true)
            uiMgr:setRichText(self, "richText", tonumber(errorCode), self.richArgs)
        
            self.Prompt_bg:setContentSize(cc.size(694,280))
        end

end

function UIPromptPanel:setRichData(args)
    local datas = {}
    for index,v in ipairs(args) do
        datas['key_'..index] = v
    end
    self.richArgs = datas
end

function UIPromptPanel:setPanelExitCallFun(exitcall)
    self.PanelExitcall =   exitcall 
end  

function UIPromptPanel:setPanelonExitCallFun(call)
    self.PanelOnExitcall =   call 
end  


function UIPromptPanel:getErrorBykey(_errorKey,...)
    
    local  tb_error = global.luaCfg:get_errorcode_by(_errorKey)
    if not tb_error then
        tb_error = {}
        tb_error.text = nil
        return nil
    end

    text = tb_error.text
    text = string.gsub(text,"#1#","\n")
    local num = 0
    for _ in string.gmatch(text, "%%s") do
        num = num + 1
    end

    local args = {...}
    local count = #args
    if count > 0 then
        if count < num then
            for i=1, num do
                if args[i] == nil then
                    args[i] = "%s"
                end
            end
            log.debug("[Warning] string.format's args(%s) less than %%s(%s) !", count, num)
        end
        return string.format(text, unpack(args))
    end

    return string.format(tb_error.text,...) 
end


function UIPromptPanel:btn_click(sender, eventType)
    
    
    self.Prompt_bg.Button_2:setEnabled(false)
    self.Prompt_bg.Button_1:setEnabled(false)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_confirm")
    global.panelMgr:closePanel("UIPromptPanel")
    if self.callback then self.callback() end
end

function UIPromptPanel:onEnter()
    self.PanelOnExitcall = nil
    self.PanelExitcall = nil
    self.m_cancelCall = nil
    self.callback = nil
end

function UIPromptPanel:onExit()
    self.richArgs = nil
    if self.PanelOnExitcall then 
        self.PanelOnExitcall()
    end
end

function UIPromptPanel:exit(sender, eventType)
    self:onCloseHandler()
end

function UIPromptPanel:setModalEnable(enabled)    
    self.modalEnabled = enabled
end

function UIPromptPanel:onCloseHandler()
    
    if not self.modalEnabled then
        return
    end

    if self.PanelExitcall then 
         self.PanelExitcall()
    end 
    global.panelMgr:closePanel("UIPromptPanel")
end

function UIPromptPanel:cancel_click(sender, eventType)
    
    self.Prompt_bg.Button_2:setEnabled(false)
    self.Prompt_bg.Button_1:setEnabled(false)
    
    if self.PanelExitcall then 
         self.PanelExitcall()
    end 

    if self.m_cancelCall then 
        self.m_cancelCall() 
    end
    global.panelMgr:closePanelForBtn("UIPromptPanel")    
end

function UIPromptPanel:setCancelCall(call)
    self.m_cancelCall = call
    return self
end

function UIPromptPanel:setCancelLabel(str)
    if type(str) == 'number' then
        self.Text_1:setString(global.luaCfg:get_local_string(str))
    else
        self.Text_1:setString(str)
    end    
    return self
end

function UIPromptPanel:setConfirmLabel(str)
    if type(str) == 'number' then
        self.Text_4:setString(global.luaCfg:get_local_string(str))
    else
        self.Text_4:setString(str)
    end    
    return self
end

--CALLBACKS_FUNCS_END

return UIPromptPanel

--endregion

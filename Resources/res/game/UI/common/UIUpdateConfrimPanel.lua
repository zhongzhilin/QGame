--region UIUpdateConfrimPanel.lua
--Author : untory
--Date   : 2017/04/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUpdateConfrimPanel  = class("UIUpdateConfrimPanel", function() return gdisplay.newWidget() end )

function UIUpdateConfrimPanel:ctor()
    self:CreateUI()
end

function UIUpdateConfrimPanel:CreateUI()
    local root = resMgr:createWidget("loading/update_comfirm_panel")
    self:initUI(root)
end

function UIUpdateConfrimPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/update_comfirm_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.update = self.root.update_node.update_bg.update_export

    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.conceal_btn, function(sender, eventType) self:cancelHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUpdateConfrimPanel:setData(data,sureCall,cancelCall)
    
    self.sureCall = sureCall
    self.cancelCall = cancelCall
    self.update:setString(luaCfg:get_local_string(10620,data.byte))   
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUpdateConfrimPanel:confirmHandler(sender, eventType)

    if self.sureCall then self.sureCall() end
    global.panelMgr:closePanel("UIUpdateConfrimPanel")
end

function UIUpdateConfrimPanel:cancelHandler(sender, eventType)

    if self.cancelCall then self.cancelCall() end
    global.panelMgr:closePanel("UIUpdateConfrimPanel")
end
--CALLBACKS_FUNCS_END

return UIUpdateConfrimPanel

--endregion

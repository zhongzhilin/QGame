--region UIPayPanel.lua
--Author : anlitop
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPayPanel  = class("UIPayPanel", function() return gdisplay.newWidget() end )

function UIPayPanel:ctor()
    self:CreateUI()
end

function UIPayPanel:CreateUI()
    local root = resMgr:createWidget("pay/pay_not")
    self:initUI(root)
end

function UIPayPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pay/pay_not")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.Battle = self.root.Node_export.Battle_export
    self.text1 = self.root.Node_export.btn_getdiamond.text1_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn_getdiamond, function(sender, eventType) self:btn_getdiamond_call(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPayPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIPayPanel")
end
 
function UIPayPanel:btn_getdiamond_call(sender, eventType)
    
    global.panelMgr:openPanel("UIRechargePanel")
end
--CALLBACKS_FUNCS_END

return UIPayPanel

--endregion

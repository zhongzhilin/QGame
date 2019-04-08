--region UIPetResetPanel.lua
--Author : yyt
--Date   : 2017/12/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetResetPanel  = class("UIPetResetPanel", function() return gdisplay.newWidget() end )

function UIPetResetPanel:ctor()
    self:CreateUI()
end

function UIPetResetPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_skill_reset")
    self:initUI(root)
end

function UIPetResetPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_skill_reset")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt = self.root.Node_export.txt_mlan_22_export
    self.txt2 = self.root.Node_export.txt2_mlan_16_export
    self.txt3 = self.root.Node_export.txt3_mlan_20_export
    self.diamond = self.root.Node_export.diamond_export
    self.diamond_num = self.root.Node_export.diamond_export.diamond_num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:closeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.resetBtn, function(sender, eventType) self:resetHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.cancelBtn, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetResetPanel:setData(num, callBack)
    self.callBack = callBack
    self.diamond_num:setString(num)
    global.tools:adjustNodePos(self.txt2 , self.diamond)
end

function UIPetResetPanel:closeHandler(sender, eventType)
    global.panelMgr:closePanel("UIPetResetPanel")
end

function UIPetResetPanel:resetHandler(sender, eventType)
    if self.callBack then
        self:closeHandler()
        self.callBack()
    end
end

function UIPetResetPanel:exitCall(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetResetPanel")
end
--CALLBACKS_FUNCS_END

return UIPetResetPanel

--endregion

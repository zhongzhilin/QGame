--region UISdefineHeadPanel.lua
--Author : wuwx
--Date   : 2018/05/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISdefineHeadPanel  = class("UISdefineHeadPanel", function() return gdisplay.newWidget() end )

function UISdefineHeadPanel:ctor()
    self:CreateUI()
end

function UISdefineHeadPanel:CreateUI()
    local root = resMgr:createWidget("rolehead/sdefine_panel")
    self:initUI(root)
end

function UISdefineHeadPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/sdefine_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onClose(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_camera, function(sender, eventType) self:onCamera(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_photo, function(sender, eventType) self:onPhoto(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISdefineHeadPanel:onCamera(sender, eventType)
    if global.tools:isMobile() then
        CCNative:definePortrait(true,133)
    end
end

function UISdefineHeadPanel:onPhoto(sender, eventType)
    if global.tools:isMobile() then
        CCNative:definePortrait(false,133)
    end
end

function UISdefineHeadPanel:onClose(sender, eventType)
    global.panelMgr:closePanel("UISdefineHeadPanel")
end
--CALLBACKS_FUNCS_END

return UISdefineHeadPanel

--endregion

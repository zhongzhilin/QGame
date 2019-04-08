--region UIShieldUserItem.lua
--Author : yyt
--Date   : 2017/03/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIShieldUserItem  = class("UIShieldUserItem", function() return gdisplay.newWidget() end )

function UIShieldUserItem:ctor()
    self:CreateUI()
end

function UIShieldUserItem:CreateUI()
    local root = resMgr:createWidget("settings/settings_shieldUserNode")
    self:initUI(root)
end

function UIShieldUserItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_shieldUserNode")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btnHead = self.root.Node_8.btnHead_export
    self.IconNode = self.root.Node_8.btnHead_export.IconNode_export
    self.userName = self.root.Node_8.userName_export
    self.combat = self.root.Node_8.combat_export
    self.shieldBtn = self.root.Node_8.shieldBtn_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.btnHead, function(sender, eventType) self:headClickHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.shieldBtn, function(sender, eventType) self:reShieldHandler(sender, eventType) end, true)

    self.shieldBtn:setSwallowTouches(false)
    self.btnHead:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIShieldUserItem:setData(data)
    
    self.data = data
    self.userName:setString(data.szName)
    self.combat:setString(data.lPower)
    local head = luaCfg:get_rolehead_by(data.lFace)
    head = global.headData:convertHeadData(data,head)
    global.tools:setCircleAvatar(self.IconNode, head)

end

function UIShieldUserItem:headClickHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIShieldUserPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end

        local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
        panel:setData(self.data, handler(self, self.dealUser))
    end
end

function UIShieldUserItem:dealUser()
    
    global.panelMgr:getPanel("UIShieldUserPanel"):refersh()
end

function UIShieldUserItem:reShieldHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIShieldUserPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isStartMove then 
            return
        end

        global.chatData:removeShield(self.data.lUserID)
        sPanel:refersh()
    end

end
--CALLBACKS_FUNCS_END

return UIShieldUserItem

--endregion

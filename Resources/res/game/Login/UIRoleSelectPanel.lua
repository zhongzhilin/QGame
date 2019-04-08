--region UIRoleSelectPanel.lua
--Author : ethan
--Date   : 2016/04/18
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UIRoleSelectPanel  = class("UIRoleSelectPanel", function() return gdisplay.newWidget() end )

function UIRoleSelectPanel:ctor()
    self:CreateUI()
end

function UIRoleSelectPanel:CreateUI()
    local root = resMgr:createWidget("RoleSelect")
    self:initUI(root)
end

function UIRoleSelectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "RoleSelect")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text_name = self.root.text_name_export

    uiMgr:addWidgetTouchHandler(self.root.button_1, function(sender, eventType) self:onConfirmHandler1(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.button_2, function(sender, eventType) self:onConfirmHandler2(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.button_3, function(sender, eventType) self:onConfirmHandler3(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.button_4, function(sender, eventType) self:onConfirmHandler4(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.button_random, function(sender, eventType) self:randomNameHandler(sender, eventType) end, true)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRoleSelectPanel:onConfirmHandler1(sender, eventType)
    if eventType == ccui.TouchEventType.ended and self.callBack then
        self.callBack(WCONST.CAREER.INFANTRY, self.text_name:getString())
    end
end

function UIRoleSelectPanel:onConfirmHandler2(sender, eventType)
    if eventType == ccui.TouchEventType.ended and self.callBack then
        self.callBack(WCONST.CAREER.ARTILLERY, self.text_name:getString())
    end
end

function UIRoleSelectPanel:onConfirmHandler3(sender, eventType)
    if eventType == ccui.TouchEventType.ended and self.callBack then
        self.callBack(WCONST.CAREER.PANZER, self.text_name:getString())
    end
end

function UIRoleSelectPanel:onConfirmHandler4(sender, eventType)
    if eventType == ccui.TouchEventType.ended and self.callBack then
        self.callBack(WCONST.CAREER.AIRFORCE, self.text_name:getString())
    end
end

function UIRoleSelectPanel:randomNameHandler(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.text_name:setString(self:getRandName())
    end
end
--CALLBACKS_FUNCS_END

function UIRoleSelectPanel:onEnter()
    self.text_name:setString(self:getRandName())
end

function UIRoleSelectPanel:setCallBack(callBack)
    self.callBack = callBack
end

function UIRoleSelectPanel:getRandName()
    -- body
    if self.randNameTable == nil then
        local randNameDB = CCHgame:GetFileData("bin/namedb.dat")
        self.randNameTable = json.decode(randNameDB)
    end
    local surName = self.randNameTable.surname[math.random(1, #self.randNameTable.surname)]
    local firstName = self.randNameTable.firstname[math.random(1, #self.randNameTable.firstname)]
    return surName..firstName
end

return UIRoleSelectPanel

--endregion









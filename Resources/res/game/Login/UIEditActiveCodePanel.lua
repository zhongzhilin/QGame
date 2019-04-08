--region UIEditActiveCodePanel.lua
--Author : wuwx
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIEditActiveCodePanel  = class("UIEditActiveCodePanel", function() return gdisplay.newWidget() end )

function UIEditActiveCodePanel:ctor()
    self:CreateUI()
end

function UIEditActiveCodePanel:CreateUI()
    local root = resMgr:createWidget("loading/activitation_code_panel")
    self:initUI(root)
end

function UIEditActiveCodePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/activitation_code_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.codeTextField = UIInputBox.new()
    uiMgr:configNestClass(self.codeTextField, self.root.update_node.activitation_code_bg.codeTextField)

    uiMgr:addWidgetTouchHandler(self.root.update_node.update_bg.confirm_btn, function(sender, eventType) self:onConfirmHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIEditActiveCodePanel:setData(call)
    self.m_call = call
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIEditActiveCodePanel:onConfirmHandler(sender, eventType)
    --激活码
    local i_code = self.codeTextField:getString()
    if i_code == "" then
        global.tipsMgr:showWarning("code_not_exist")
    else
        global.loginData:setActiveCode(i_code)
        if self.m_call then self.m_call() end
    end

end
--CALLBACKS_FUNCS_END

return UIEditActiveCodePanel

--endregion

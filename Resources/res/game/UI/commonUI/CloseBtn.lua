--region CloseBtn.lua
--Author : yyt
--Date   : 2017/03/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local CloseBtn  = class("CloseBtn", function() return gdisplay.newWidget() end )

function CloseBtn:ctor()
    
end

function CloseBtn:CreateUI()
    local root = resMgr:createWidget("common/close_btn")
    self:initUI(root)
end

function CloseBtn:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/close_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.close_btn = self.root.close_btn_export

    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function CloseBtn:setData(call)
	self.m_call = call
end

function CloseBtn:exit_call(sender, eventType)
	
    if not self.m_call then
        
        print(">>> exit call")
        global.panelMgr:closePanelForAndroidBack()
        return
    end

    self.m_call()
end
--CALLBACKS_FUNCS_END

return CloseBtn

--endregion

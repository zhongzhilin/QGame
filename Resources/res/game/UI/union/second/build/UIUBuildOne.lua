--region UIUBuildOne.lua
--Author : wuwx
--Date   : 2017/02/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUBuildOne  = class("UIUBuildOne", function() return gdisplay.newWidget() end )

function UIUBuildOne:ctor()
    self:CreateUI()
end

function UIUBuildOne:CreateUI()
    local root = resMgr:createWidget("union/union_build_tab")
    self:initUI(root)
end

function UIUBuildOne:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_build_tab")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.go = self.root.btn_export.go_export
    self.name = self.root.btn_export.name_export
    self.exp_icon_bg = self.root.btn_export.exp_icon_bg_export
    self.icon = self.root.btn_export.exp_icon_bg_export.icon_export
    self.spReadState = self.root.btn_export.spReadState_export
    self.Text = self.root.btn_export.spReadState_export.Text_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:onTab(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUBuildOne:setData(data)
    self.data = data
    self.name:setString(data.text)
-- self.icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.icon,data.icon)

    self.spReadState:setVisible(data.childCount>0)
    self.Text:setString(data.childCount)

    self:setFocus(self.data.uiData.showChildren)
end

function UIUBuildOne:setFocus(isFocus)
    self.go:setRotation(isFocus and 90 or 0)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUBuildOne:onTab(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIUBuildOne

--endregion

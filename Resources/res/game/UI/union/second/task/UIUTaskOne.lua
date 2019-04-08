--region UIUTaskOne.lua
--Author : wuwx
--Date   : 2017/02/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUTaskOne  = class("UIUTaskOne", function() return gdisplay.newWidget() end )

function UIUTaskOne:ctor()
    
    self:CreateUI()
end

function UIUTaskOne:CreateUI()
    local root = resMgr:createWidget("union/union_task_tab")
    self:initUI(root)
end

function UIUTaskOne:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_tab")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.go = self.root.btn_export.go_export
    self.name = self.root.btn_export.name_export
    self.exp_icon_bg = self.root.btn_export.exp_icon_bg_export
    self.icon = self.root.btn_export.exp_icon_bg_export.icon_export
    self.height = self.root.height_export
    self.spReadState = self.root.spReadState_export
    self.Text = self.root.spReadState_export.Text_export

--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUTaskOne:setData(data)
    self.data = data
    self.name:setString(data.text)
    -- self.icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.icon,data.icon)

    self.spReadState:setVisible(data.canGetNum > 0)
    self.Text:setString(data.canGetNum)

    self:setFocus(self.data.uiData.showChildren)
end

function UIUTaskOne:setFocus(isFocus)
    self.go:setRotation(isFocus and 90 or 0)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUTaskOne

--endregion

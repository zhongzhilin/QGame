--region UIUnionWarItem.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionWarItem  = class("UIUnionWarItem", function() return gdisplay.newWidget() end )

function UIUnionWarItem:ctor()
    self:CreateUI()
end

function UIUnionWarItem:CreateUI()
    local root = resMgr:createWidget("union/union_function")
    self:initUI(root)
end

function UIUnionWarItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_function")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_item = self.root.btn_item_export
    self.icon = self.root.btn_item_export.icon_export
    self.union_name = self.root.btn_item_export.union_name_export
    self.spReadState = self.root.btn_item_export.spReadState_export
    self.num = self.root.btn_item_export.spReadState_export.num_export

--EXPORT_NODE_END
    self.btn_item:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn_item:setSwallowTouches(false)
end

--1.联盟外交
function UIUnionWarItem:setData(data)
    self.data = data

    self.union_name:setString(data.name)
    -- self.icon:setSpriteFrame(data.btn)
    global.panelMgr:setTextureFor(self.icon,data.btn)
    self.spReadState:setVisible(false)
end

function UIUnionWarItem:setRed(v)
    self.spReadState:setVisible(false)
    if v <= 0 then return end
    self.spReadState:setVisible(true)
    self.num:setString(v)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionWarItem

--endregion

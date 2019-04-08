--region UIUnionBtnItem.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionBtnItem  = class("UIUnionBtnItem", function() return gdisplay.newWidget() end )

function UIUnionBtnItem:ctor()
    self:CreateUI()
end

function UIUnionBtnItem:CreateUI()
    local root = resMgr:createWidget("union/union_btn")
    self:initUI(root)
end

function UIUnionBtnItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.icon = self.root.btn_export.icon_export
    self.text = self.root.btn_export.text_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:clickHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.btn:setSwallowTouches(false)
end

function UIUnionBtnItem:setData(data)
    self.data = data

    self.text:setString(data.name)
    -- self.icon:loadTexture(data.btn, ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.icon,data.btn)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionBtnItem:clickHandler(sender, eventType)
end
--CALLBACKS_FUNCS_END

return UIUnionBtnItem

--endregion

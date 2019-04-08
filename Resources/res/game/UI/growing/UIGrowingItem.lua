--region UIGrowingItem.lua
--Author : zzl
--Date   : 2018/02/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGrowingItem  = class("UIGrowingItem", function() return gdisplay.newWidget() end )

function UIGrowingItem:ctor()
    self:CreateUI()
end

function UIGrowingItem:CreateUI()
    local root = resMgr:createWidget("growing_up/growing_up_item")
    self:initUI(root)
end

function UIGrowingItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "growing_up/growing_up_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.go_btn = self.root.Button_1_export.go_btn_export
    self.name = self.root.Button_1_export.name_export
    self.build_icon = self.root.Button_1_export.build_icon_export
    self.satus = self.root.Button_1_export.satus_export
    self.btnSelect = self.root.btnSelect_export
    self.selectPng = self.root.btnSelect_export.selectPng_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:goHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.go_btn, function(sender, eventType) self:goHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btnSelect, function(sender, eventType) self:selectHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    
    self.Button_1:setSwallowTouches(false)
    self.go_btn:setSwallowTouches(false)
    self.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGrowingItem:onEnter()

end 

function UIGrowingItem:onEixt()
    
end 

function UIGrowingItem:setData(data)
    self.data = data 
    self.data.scale =self.data.scale or 75
    self.name:setString(self.data.des)
    self.build_icon:setScale(self.data.scale / 100)
    global.panelMgr:setTextureFor(self.build_icon,data.icon)
end 

function UIGrowingItem:goHandler(sender, eventType)
    
end

function UIGrowingItem:selectHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIGrowingItem

--endregion

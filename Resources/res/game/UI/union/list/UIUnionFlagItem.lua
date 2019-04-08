--region UIUnionFlagItem.lua
--Author : wuwx
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionFlagItem  = class("UIUnionFlagItem", function() return gdisplay.newWidget() end )

function UIUnionFlagItem:ctor()
    self:CreateUI()
end

function UIUnionFlagItem:CreateUI()
    local root = resMgr:createWidget("union/flag_btn")
    self:initUI(root)
end

function UIUnionFlagItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/flag_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.node.btn_export
    self.icon = self.root.node.btn_export.icon_export
    self.national = self.root.node.btn_export.icon_export.national_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:clickFlagHandler(sender, eventType) end)
--EXPORT_NODE_END
    -- self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionFlagItem:setData(data)
    self.data = data
    -- self.icon:setSpriteFrame(data.flag)
    -- dump(data)
    global.panelMgr:setTextureFor(self.icon,data.flag)
    self.national:setVisible(false)
    if data.national and data.national ~= "" then
        self.national:setVisible(true)
        -- self.national:setSpriteFrame(data.national)
        global.panelMgr:setTextureFor(self.national,data.national)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionFlagItem:clickFlagHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIUnionFlagItem

--endregion

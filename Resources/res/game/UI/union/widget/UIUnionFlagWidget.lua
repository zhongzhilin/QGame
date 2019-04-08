--region UIUnionFlagWidget.lua
--Author : wuwx
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionFlagWidget  = class("UIUnionFlagWidget", function() return gdisplay.newWidget() end )

function UIUnionFlagWidget:ctor()
    
end

function UIUnionFlagWidget:CreateUI()
    local root = resMgr:createWidget("union/flag_go")
    self:initUI(root)
end

function UIUnionFlagWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/flag_go")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.icon = self.root.icon_export
    self.national = self.root.national_export

--EXPORT_NODE_END
end

function UIUnionFlagWidget:setData(flag)
    local flagData = global.unionData:getUnionFlagData(tonumber(flag))
    -- dump(flagData)
    -- self.icon:setSpriteFrame(flagData.flag)
    global.panelMgr:setTextureFor(self.icon,flagData.flag)
    self.national:setVisible(false)
    if flagData.national and flagData.national ~= "" then
        self.national:setVisible(true)
        -- self.national:setSpriteFrame(flagData.national)
        global.panelMgr:setTextureFor(self.national,flagData.national)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionFlagWidget

--endregion

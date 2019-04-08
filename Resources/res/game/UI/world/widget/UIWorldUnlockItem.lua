--region UIWorldUnlockItem.lua
--Author : Untory
--Date   : 2017/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldUnlockItem  = class("UIWorldUnlockItem", function() return gdisplay.newWidget() end )

function UIWorldUnlockItem:ctor()
    self:CreateUI()
end

function UIWorldUnlockItem:CreateUI()
    local root = resMgr:createWidget("world/info/unlockk_list")
    self:initUI(root)
end

function UIWorldUnlockItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/unlockk_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.name = self.root.name_export

--EXPORT_NODE_END
end

function UIWorldUnlockItem:setData(data)
	
	self.name:setString(data.text)
	local image = luaCfg:get_world_surface_by(data.image).worldmap
	global.panelMgr:setTextureFor(self.icon, image)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWorldUnlockItem

--endregion

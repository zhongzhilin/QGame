--region UILocationInfo.lua
--Author : untory
--Date   : 2016/09/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILocationInfo  = class("UILocationInfo", function() return gdisplay.newWidget() end )

function UILocationInfo:ctor()
    
end

function UILocationInfo:CreateUI()
    local root = resMgr:createWidget("world/world_coordinate")
    self:initUI(root)
end

function UILocationInfo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_coordinate")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.X = self.root.X_export
    self.Y = self.root.Y_export

--EXPORT_NODE_END

	
end


function UILocationInfo:setPos(pos)
	
    pos = global.g_worldview.const:converPix2Location(pos)

	self.X:setString(pos.x)
	self.Y:setString(pos.y)

    global.collectData:setCurPos(pos.x, pos.y)
end

function UILocationInfo:setPosLocation(pos)

    self.X:setString(pos.x)
    self.Y:setString(pos.y)
    global.collectData:setCurPos(pos.x, pos.y)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UILocationInfo

--endregion

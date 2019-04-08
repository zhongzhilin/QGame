--region UICreateCityPoint.lua
--Author : untory
--Date   : 2017/01/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICreateCityPoint  = class("UICreateCityPoint", function() return gdisplay.newWidget() end )

function UICreateCityPoint:ctor()
    
end

function UICreateCityPoint:CreateUI()
    local root = resMgr:createWidget("world/mainland/world_city_name")
    self:initUI(root)
end

function UICreateCityPoint:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/world_city_name")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.point = self.root.point_export
    self.name = self.root.name_export

--EXPORT_NODE_END
end

function UICreateCityPoint:setData(data)
	
	self.point:setColor(cc.c3b(unpack(data.color)))
	self.name:setTextColor(cc.c3b(unpack(data.color)))
	self.name:setString(data.name)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UICreateCityPoint

--endregion

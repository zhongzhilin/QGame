--region BuildingName.lua
--Author : zzl
--Date   : 2018/09/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildingName  = class("BuildingName", function() return gdisplay.newWidget() end )

function BuildingName:ctor()
    
end

function BuildingName:CreateUI()
    local root = resMgr:createWidget("city/buildingName")
    self:initUI(root)
end

function BuildingName:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/buildingName")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name_node = self.root.name_node_export
    self.name = self.root.name_node_export.name_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function BuildingName:onEnter()

	-- self.isshow = nil 

end 

function BuildingName:showName(action)

	self:stopAllActions()

	local nodeTimeLine = resMgr:createTimeline("city/buildingName")
    self:runAction(nodeTimeLine)
    if not action then 
	    nodeTimeLine:gotoFrameAndPause(15)
    else
        nodeTimeLine:play("animation0", false)
	end

    self.isshow = true 
end 

function BuildingName:hideName(action)


	self:stopAllActions()

    local nodeTimeLine = resMgr:createTimeline("city/buildingName")
	self:runAction(nodeTimeLine)
    if not action then 
        nodeTimeLine:gotoFrameAndPause(30)
    else
        nodeTimeLine:play("animation1", false)
    end

    self.isshow = nil 
end 


--CALLBACKS_FUNCS_END

return BuildingName

--endregion

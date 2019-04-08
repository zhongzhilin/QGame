--region UIEmptyNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEmptyNode  = class("UIEmptyNode", function() return gdisplay.newWidget() end )

function UIEmptyNode:ctor()
    self:CreateUI()
end

function UIEmptyNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_empty_node")
    self:initUI(root)
end

function UIEmptyNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_empty_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.empty = self.root.Node.empty_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIEmptyNode:setData(data)

    self.data = data
    if data.lType == 1 then
    	self.empty:setString(global.luaCfg:get_local_string(10807))
    elseif data.lType == 2 then
    	self.empty:setString(global.luaCfg:get_local_string(10808))
    elseif data.lType == 3 then
    	self.empty:setString(global.luaCfg:get_local_string(10805))
    elseif data.lType == 4 then
        self.empty:setString(global.luaCfg:get_local_string(10806))
    end
end

--CALLBACKS_FUNCS_END

return UIEmptyNode

--endregion

--region UIEmptyTroopNode.lua
--Author : yyt
--Date   : 2017/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEmptyTroopNode  = class("UIEmptyTroopNode", function() return gdisplay.newWidget() end )

function UIEmptyTroopNode:ctor()
    self:CreateUI()
end

function UIEmptyTroopNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_no_troop")
    self:initUI(root)
end

function UIEmptyTroopNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_no_troop")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.empty = self.root.soldier_list_bg.empty_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIEmptyTroopNode:setData(data)
	-- body
	self.data = data
    self.empty:setString(global.luaCfg:get_local_string(10817, data.cdata.lType))
end

--CALLBACKS_FUNCS_END

return UIEmptyTroopNode

--endregion

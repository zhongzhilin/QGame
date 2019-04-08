--region UIEmptySoldierNo.lua
--Author : yyt
--Date   : 2017/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEmptySoldierNo  = class("UIEmptySoldierNo", function() return gdisplay.newWidget() end )

function UIEmptySoldierNo:ctor()
    self:CreateUI()
end

function UIEmptySoldierNo:CreateUI()
    local root = resMgr:createWidget("common/pandect_no_soldier")
    self:initUI(root)
end

function UIEmptySoldierNo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_no_soldier")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.noFriend = self.root.noFriend_mlan_32_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIEmptySoldierNo:setData(data)
	-- body
	self.data = data
end

--CALLBACKS_FUNCS_END

return UIEmptySoldierNo

--endregion

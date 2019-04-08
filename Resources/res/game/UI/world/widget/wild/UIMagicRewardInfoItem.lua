--region UIMagicRewardInfoItem.lua
--Author : wuwx
--Date   : 2017/04/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMagicRewardInfoItem  = class("UIMagicRewardInfoItem", function() return gdisplay.newWidget() end )

function UIMagicRewardInfoItem:ctor()
    
end

function UIMagicRewardInfoItem:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_reward_info")
    self:initUI(root)
end

function UIMagicRewardInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_reward_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.success1 = self.root.Node_1.success1_mlan_5_export
    self.success = self.root.Node_1.success1_mlan_5_export.success_export
    self.failed0 = self.root.Node_1.failed0_mlan_5_export
    self.failed1 = self.root.Node_1.failed0_mlan_5_export.failed1_mlan_10_export
    self.failed = self.root.Node_1.failed0_mlan_5_export.failed_export

--EXPORT_NODE_END
end

function UIMagicRewardInfoItem:setData(data)
	if data then
		self.success1:setVisible(true)
		self.failed0:setVisible(true)
	    self.success:setString(luaCfg:get_local_string(11035)..string.format(luaCfg:get_local_string(10204),data.damage))
	    self.failed:setString(string.format(luaCfg:get_local_string(10204),data.hp))

	    global.tools:adjustNodePosForFather(self.success1,self.success)
	    global.tools:adjustNodePosForFather(self.failed1:getParent(),self.failed1)
	    global.tools:adjustNodePos(self.failed1,self.failed)
	else
		self.success1:setVisible(false)
		self.failed0:setVisible(false)
	end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMagicRewardInfoItem

--endregion

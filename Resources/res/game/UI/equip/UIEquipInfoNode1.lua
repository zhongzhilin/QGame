--region UIEquipInfoNode1.lua
--Author : Administrator
--Date   : 2017/02/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIEquipInfoNode1Pro = require("game.UI.equip.UIEquipInfoNode1Pro")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipInfoNode1  = class("UIEquipInfoNode1", function() return gdisplay.newWidget() end )

function UIEquipInfoNode1:ctor()
    
end

function UIEquipInfoNode1:CreateUI()
    local root = resMgr:createWidget("equip/equipInfoNode1")
    self:initUI(root)
end

function UIEquipInfoNode1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equipInfoNode1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.base_pro = self.root.Node_2.base_pro_mlan_4_export
    self.proNode = self.root.Node_2.proNode_export

--EXPORT_NODE_END
end

function UIEquipInfoNode1:setData(data)

	self.proNode:removeAllChildren()

	local equipData = data.confData

	local index = 0
	for i = 1,4 do

		local count = data.tgAttr[i] or 0
		if count ~= 0 then			
			local pro = UIEquipInfoNode1Pro.new()
			pro:setData(luaCfg:get_local_string(WCONST.BASE_PROPERTY[i].LOCAL_STR),count,0)
			pro:setPositionY(-index * 30)
			self.proNode:addChild(pro)
			index = index + 1
		end		
	end

	local extraPro = equipData.extraPro or {}
	for _,v in ipairs(extraPro) do
		local pro = UIEquipInfoNode1Pro.new()
		local leagueCfg = luaCfg:get_data_type_by(v[1])
		local leaguecount = v[2]
		pro:setData(leagueCfg.paraName,leaguecount .. leagueCfg.extra,0)
		pro:setPositionY(-index * 30)
		self.proNode:addChild(pro)
		index = index + 1
	end

	self.proNode:setPositionY((index - 1) * 30)
	self.base_pro:setPositionY(index * 30)

	self.height = index * 30 + 45
end

function UIEquipInfoNode1:getHeight()
	
	return self.height
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEquipInfoNode1

--endregion

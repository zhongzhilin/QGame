--region UIBuffDes.lua
--Author : yyt
--Date   : 2018/02/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuffDes  = class("UIBuffDes", function() return gdisplay.newWidget() end )

function UIBuffDes:ctor()
    self:CreateUI()
end

function UIBuffDes:CreateUI()
    local root = resMgr:createWidget("common/common_buffDes")
    self:initUI(root)
end

function UIBuffDes:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_buffDes")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.divine_buff = self.root.divine_buff_export
    self.divine_buff_desc = self.root.divine_buff_desc_mlan_7_export
    self.item_buff = self.root.item_buff_export
    self.item_buff_desc = self.root.item_buff_desc_mlan_7_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_sBEGIN

function UIBuffDes:setData(data)
	
	if data.itemAdd and data.itemAdd[2] and data.itemAdd[2] > 0 then
		local data1 = global.luaCfg:get_data_type_by(data.itemAdd[1])
		self.item_buff:setString(data1.paraName .. "+" .. data.itemAdd[2] .. data1.extra)
	else
		self.item_buff:setString("-")
	end

	if data.divineAdd and data.divineAdd[2] and data.divineAdd[2] > 0 then
		local data2 = global.luaCfg:get_data_type_by(data.divineAdd[1])
		self.divine_buff:setString(data2.paraName .. "+" .. data.divineAdd[2] .. data2.extra)
	else
		self.divine_buff:setString("-")
	end

	global.tools:adjustNodePos(self.item_buff_desc, self.item_buff)
    global.tools:adjustNodePos(self.divine_buff_desc, self.divine_buff)

end

--CALLBACKS_FUNCS_END

return UIBuffDes

--endregion

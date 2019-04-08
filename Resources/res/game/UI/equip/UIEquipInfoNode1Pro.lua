--region UIEquipInfoNode1Pro.lua
--Author : Administrator
--Date   : 2017/02/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipInfoNode1Pro  = class("UIEquipInfoNode1Pro", function() return gdisplay.newWidget() end )

function UIEquipInfoNode1Pro:ctor()
    
    self:CreateUI()
end

function UIEquipInfoNode1Pro:CreateUI()
    local root = resMgr:createWidget("equip/property_node")
    self:initUI(root)
end

function UIEquipInfoNode1Pro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/property_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.extra_pro = self.root.extra_pro_export
    self.base_pro = self.root.base_pro_export
    self.pro_type = self.root.pro_type_export

--EXPORT_NODE_END
end

function UIEquipInfoNode1Pro:setData(proType,baseNum,addNum)
	
	self.pro_type:setString(proType)
	self.base_pro:setString("+"..baseNum)
    self.base_pro:setPositionX(self.pro_type:getContentSize().width + self.pro_type:getPositionX() + 15)
	self.extra_pro:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEquipInfoNode1Pro

--endregion

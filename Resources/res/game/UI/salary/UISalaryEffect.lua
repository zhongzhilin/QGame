--region UISalaryEffect.lua
--Author : yyt
--Date   : 2017/02/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISalaryEffect  = class("UISalaryEffect", function() return gdisplay.newWidget() end )

function UISalaryEffect:ctor()
    
end

function UISalaryEffect:CreateUI()
    local root = resMgr:createWidget("salary/fontNode")
    self:initUI(root)
end

function UISalaryEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "salary/fontNode")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.cheng = self.root.fontNode.cheng_export
    self.mutileNum = self.root.fontNode.mutileNum_export
    self.baseNum = self.root.fontNode.baseNum_export
    self.textB = self.root.fontNode.textB_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISalaryEffect:setData(lCritMultiple, baseNum)
	-- body
	if tonumber(lCritMultiple) <= 1 then
		self.cheng:setVisible(false)
		self.mutileNum:setVisible(false)
		self.textB:setVisible(false)
	else
		self.cheng:setVisible(true)
		self.mutileNum:setVisible(true)
		self.textB:setVisible(true)
	end
	
	self.mutileNum:setString(tonumber(lCritMultiple))
	self.baseNum:setString(tonumber(baseNum)*tonumber(lCritMultiple))

	local nodeTimeLine = resMgr:createTimeline("salary/fontNode")
    nodeTimeLine:play("animation0", false)
    self:runAction(nodeTimeLine)
	
end

--CALLBACKS_FUNCS_END

return UISalaryEffect

--endregion

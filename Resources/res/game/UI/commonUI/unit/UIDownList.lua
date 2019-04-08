--region UIDownList.lua
--Author : yyt
--Date   : 2016/09/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UIDownListItem = require("game.UI.commonUI.unit.UIDownListItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDownListItem = require("game.UI.commonUI.unit.UIDownListItem")
--REQUIRE_CLASS_END

local UIDownList  = class("UIDownList", function() return gdisplay.newWidget() end )

function UIDownList:ctor()
    self:CreateUI()
end

function UIDownList:CreateUI()
    local root = resMgr:createWidget("common/common_downlist")
    self:initUI(root)
end

function UIDownList:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_downlist")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.item_layout = self.root.Panel_2.item_layout_export
    self.FileNode_2 = UIDownListItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Panel_2.item_layout_export.FileNode_2)
    self.FileNode_2_0 = UIDownListItem.new()
    uiMgr:configNestClass(self.FileNode_2_0, self.root.Panel_2.item_layout_export.FileNode_2_0)
    self.FileNode_2_1 = UIDownListItem.new()
    uiMgr:configNestClass(self.FileNode_2_1, self.root.Panel_2.item_layout_export.FileNode_2_1)
    self.DownListBox = self.root.Panel_2.DownListBox_export
    self.default_text = self.root.Panel_2.DownListBox_export.default_text_export

    uiMgr:addWidgetTouchHandler(self.DownListBox, function(sender, eventType) self:downListClick(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDownList:setData( data )
	
	self.data = data
	self.item_layout:removeAllChildren()

	local itemW = self.item_layout:getContentSize().width
	local itemH = self.item_layout:getContentSize().height
	for i,v in pairs(self.data) do
		
		local item = UIDownListItem.new()
		item:setPosition(cc.p(0, itemH*(i-1)))
		item:setData(v)
		self.item_layout:addChild(item)
	end
	self.item_layout:setContentSize(cc.size(itemW, itemH*(#self.data)))

	--	默认选中第一个
	self.default_text:setString(data[1])

end


function UIDownList:downListClick(sender, eventType)

	
end
--CALLBACKS_FUNCS_END

return UIDownList

--endregion

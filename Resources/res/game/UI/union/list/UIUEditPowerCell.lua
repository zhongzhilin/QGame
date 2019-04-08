local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUEditPowerCell  = class("UIUEditPowerCell", function() return cc.TableViewCell:create() end )
local UIUEditPowerItem = require("game.UI.union.list.UIUEditPowerItem")

function UIUEditPowerCell:ctor()
    self:CreateUI()
end

function UIUEditPowerCell:CreateUI()

    self.item = UIUEditPowerItem.new() 
    self:addChild(self.item)
end

function UIUEditPowerCell:onClick()
	if not self.item:isEditModel() then return end
	if self.m_selectedId then
		print("########UIUEditPowerCell:onClick()")
		self.item:selectTarget(self.m_selectedId)
	end
end

function UIUEditPowerCell:setSelectedId(id)
	self.m_selectedId = id
end

function UIUEditPowerCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUEditPowerCell:updateUI()
    self.item:setData(self.data)
end

return UIUEditPowerCell
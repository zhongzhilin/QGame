local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPandectItemCell  = class("UIPandectItemCell", function() return cc.TableViewCell:create() end )
local UIPandectItem = require("game.UI.pandect.UIPandectItem")
local UITroopNode = require("game.UI.pandect.UITroopNode")
local UISoldierNode = require("game.UI.pandect.UISoldierNode")
local UIEmptyTroopNode = require("game.UI.pandect.occupy.UIEmptyTroopNode")
local UIEmptySoldierNo = require("game.UI.pandect.occupy.UIEmptySoldierNo")
local UIResItem = require("game.UI.resource.UIResItem")

function UIPandectItemCell:ctor()
end

function UIPandectItemCell:CreateUI()

	if self.data.cType == 5 then
		self.item = UITroopNode.new()
	elseif self.data.cType == 6 then
		self.item = UISoldierNode.new()
    elseif self.data.cType == 7 then
        self.item = UIEmptyTroopNode.new()
    elseif self.data.cType == 8 then
        self.item = UIEmptySoldierNo.new()
    elseif self.data.cType == 9 then
        self.item = UIResItem.new()
	else
    	self.item = UIPandectItem.new() 
    end
    self:addChild(self.item)
end

function UIPandectItemCell:onClick()
end

function UIPandectItemCell:setData(data)
    self.data = data
    if not self.item  then
        self:CreateUI()
    elseif self.item and (data.cType ~= self.item.data.cType) then
        self.item:removeFromParent()
        self:CreateUI()
    end
    self:updateUI()
end

function UIPandectItemCell:updateUI()
    self.item:setData(self.data)
end

return UIPandectItemCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIRechargeCell  = class("UIRechargeCell", function() return cc.TableViewCell:create() end )
local UIRechargeItem = require("game.UI.recharge.UIRechargeItem")
local UIDayGiftItem = require("game.UI.recharge.UIDayGiftItem")

function UIRechargeCell:ctor()
end

function UIRechargeCell:CreateUI()

	if self.data.cType == 1 then
    	self.item = UIRechargeItem.new() 
    elseif self.data.cType == 2 then
    	self.item = UIDayGiftItem.new()
    end
    self:addChild(self.item)
end

function UIRechargeCell:onClick()

    if self.data.cType == 2 then
        global.panelMgr:openPanel("UIADGiftPanel"):setData(self.data.id, true)
    end
end

function UIRechargeCell:setData(data)
    self.data = data
    if not self.item  then
        self:CreateUI()
    elseif self.item and (data.cType ~= self.item.data.cType) then
        self.item:removeFromParent()
        self:CreateUI()
    end
    self:updateUI()
end

function UIRechargeCell:updateUI()
    self.item:setData(self.data)
end

return UIRechargeCell
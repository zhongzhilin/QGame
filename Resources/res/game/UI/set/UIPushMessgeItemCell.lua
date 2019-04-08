--
-- Author: Your Name
-- Date: 2017-03-31 17:11:09
--


local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPushMessgeItemCell  = class("UIPushMessgeItemCell", function() return cc.TableViewCell:create() end )
local uiPushMessgeItem = require("game.UI.set.UIPushMessgeItem")

function UIPushMessgeItemCell:ctor()
    self:CreateUI()
end

function UIPushMessgeItemCell:CreateUI()
    self.item = uiPushMessgeItem.new() 
    self:addChild(self.item)
end

function UIPushMessgeItemCell:onClick()
	
end

function UIPushMessgeItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIPushMessgeItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIPushMessgeItemCell
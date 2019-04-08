--
-- Author: Your Name
-- Date: 2017-03-23 13:25:47
--


local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UICifItemCell  = class("UICifItemCell", function() return cc.TableViewCell:create() end )
local UIUnionBtnItem = require("game.UI.gift.UIGiftItem")

function UICifItemCell:ctor()
    self:CreateUI()
end

function UICifItemCell:CreateUI()
    self.item = UIUnionBtnItem.new() 
    self:addChild(self.item)
end


function UICifItemCell:onClick()
 
end

function UICifItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end


function UICifItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UICifItemCell
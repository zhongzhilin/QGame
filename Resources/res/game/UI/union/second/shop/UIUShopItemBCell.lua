local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUShopItemBCell  = class("UIUShopItemBCell", function() return cc.TableViewCell:create() end )
local UIUShopItemB = require("game.UI.union.second.shop.UIUShopItemB")

function UIUShopItemBCell:ctor()
    self:CreateUI()
end

function UIUShopItemBCell:CreateUI()
    self.item = UIUShopItemB.new() 
    self:addChild(self.item)
end

function UIUShopItemBCell:onClick()
end

function UIUShopItemBCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUShopItemBCell:updateUI()
    self.item:setData(self.data)
end

return UIUShopItemBCell
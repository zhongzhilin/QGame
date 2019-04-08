local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUShopItemACell  = class("UIUShopItemACell", function() return cc.TableViewCell:create() end )
local UIUShopItemA = require("game.UI.union.second.shop.UIUShopItemA")

function UIUShopItemACell:ctor()
    self:CreateUI()
end

function UIUShopItemACell:CreateUI()

    self.item = UIUShopItemA.new() 
    self:addChild(self.item)
end

function UIUShopItemACell:onClick()
end

function UIUShopItemACell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUShopItemACell:updateUI()
    self.item:setData(self.data)
end

return UIUShopItemACell
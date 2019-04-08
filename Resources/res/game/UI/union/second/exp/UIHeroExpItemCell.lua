local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIHeroExpItemCell  = class("UIHeroExpItemCell", function() return cc.TableViewCell:create() end )
local UIUShopItemA = require("game.UI.union.second.exp.UIHeroExpItem")

function UIHeroExpItemCell:ctor()
    self:CreateUI()
end

function UIHeroExpItemCell:CreateUI()

    self.item = UIUShopItemA.new() 
    self:addChild(self.item)
end

function UIHeroExpItemCell:onClick()
end

function UIHeroExpItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIHeroExpItemCell:updateUI()
    self.item:setData(self.data)
end

return UIHeroExpItemCell
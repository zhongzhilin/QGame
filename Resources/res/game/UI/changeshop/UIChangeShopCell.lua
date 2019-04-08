local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIChangeShopCell  = class("UIChangeShopCell", function() return cc.TableViewCell:create() end )
local UIChangeShopItem = require("game.UI.changeshop.UIChangeShopItem")

function UIChangeShopCell:ctor()
    self:CreateUI()
end

function UIChangeShopCell:CreateUI()

    self.item = UIChangeShopItem.new() 
    self:addChild(self.item)
end

function UIChangeShopCell:onClick()
end

function UIChangeShopCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIChangeShopCell:updateUI()
    self.item:setData(self.data)
end

return UIChangeShopCell
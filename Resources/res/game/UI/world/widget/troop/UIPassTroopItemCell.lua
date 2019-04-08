local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIPassTroopItemCell  = class("UIPassTroopItemCell", function() return cc.TableViewCell:create() end )
local UIPassTroopItem = require("game.UI.world.widget.troop.UIPassTroopItem")

function UIPassTroopItemCell:ctor()
    
    self:CreateUI()
end

function UIPassTroopItemCell:CreateUI()

    self.item = UIPassTroopItem.new()    
    self:addChild(self.item)
end

function UIPassTroopItemCell:onClick()
    
end

function UIPassTroopItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPassTroopItemCell:updateUI()
    self.item:setData(self.data)
end

return UIPassTroopItemCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIBattleCell  = class("UIBattleCell", function() return cc.TableViewCell:create() end )
local UIBagItem = require("game.UI.bag.UIBagItem")

function UIBattleCell:ctor()
    self:CreateUI()
end

function UIBattleCell:CreateUI()

    self.item = UIBagItem.new() 
    self.item:setScale(0.62)
    self:addChild(self.item)
end

function UIBattleCell:onClick()
end

function UIBattleCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIBattleCell:updateUI()
    self.item:setItemData(self.data, false)
end

return UIBattleCell
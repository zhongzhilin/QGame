local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIAttackInfoItemCell = class("UIAttackInfoItemCell", function() return cc.TableViewCell:create() end )
local UIAttackInfoItem = require("game.UI.world.widget.UIAttackInfoItem")

function UIAttackInfoItemCell:ctor()
    
    self:CreateUI()
end

function UIAttackInfoItemCell:CreateUI()

    self.item = UIAttackInfoItem.new() 
    self:addChild(self.item)
end

function UIAttackInfoItemCell:onClick()

end

function UIAttackInfoItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIAttackInfoItemCell:updateUI()
    self.item:setData(self.data)
end

return UIAttackInfoItemCell
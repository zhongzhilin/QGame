local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIGarrisonItemCell = class("UIGarrisonItemCell", function() return cc.TableViewCell:create() end )
local UIGarrisonItem = require("game.UI.world.widget.UIGarrisonItem")

function UIGarrisonItemCell:ctor()
    
    self:CreateUI()
end

function UIGarrisonItemCell:CreateUI()

    self.item = UIGarrisonItem.new() 
    self:addChild(self.item)
end

function UIGarrisonItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGarrisonItemCell:updateUI()
    self.item:setData(self.data)
end

return UIGarrisonItemCell
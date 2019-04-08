local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIHeroNoOrderCell  = class("UIHeroNoOrderCell", function() return cc.TableViewCell:create() end )
local UINoOrderItem = require("game.UI.hero.UINoOrderItem")

function UIHeroNoOrderCell:ctor()
    self:CreateUI()
end

function UIHeroNoOrderCell:CreateUI()

    self.item = UINoOrderItem.new() 
    self:addChild(self.item)
end

function UIHeroNoOrderCell:onClick()
end

function UIHeroNoOrderCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIHeroNoOrderCell:updateUI()
    self.item:setData(self.data)
end

return UIHeroNoOrderCell
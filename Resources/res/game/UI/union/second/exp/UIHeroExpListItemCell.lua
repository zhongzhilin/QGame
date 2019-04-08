--
-- Author: Your Name
-- Date: 2017-12-22 13:48:32
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIHeroExpListItemCell  = class("UIHeroExpListItemCell", function() return cc.TableViewCell:create() end )
local UIHeroExpListItem = require("game.UI.union.second.exp.UIHeroExpListItem")

function UIHeroExpListItemCell:ctor()
    self:CreateUI()
end

function UIHeroExpListItemCell:CreateUI()

    self.item = UIHeroExpListItem.new() 
    self:addChild(self.item)
end

function UIHeroExpListItemCell:onClick()
end

function UIHeroExpListItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIHeroExpListItemCell:updateUI()
    self.item:setData(self.data)
end

return UIHeroExpListItemCell
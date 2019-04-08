local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIGarrisonCell  = class("UIGarrisonCell", function() return cc.TableViewCell:create() end )
local UIGarrisonItem = require("game.UI.castleGarrison.UIGarrisonItem")

function UIGarrisonCell:ctor()
    self:CreateUI()
end

function UIGarrisonCell:CreateUI()

    self.item = UIGarrisonItem.new() 
    self:addChild(self.item)
end

function UIGarrisonCell:onClick()
end

function UIGarrisonCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGarrisonCell:updateUI()
    self.item:setData(self.data)
end

return UIGarrisonCell
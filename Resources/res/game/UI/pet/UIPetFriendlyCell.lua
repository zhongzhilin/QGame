local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPetFriendlyCell  = class("UIPetFriendlyCell", function() return cc.TableViewCell:create() end )
local UIPetFriendlyItem = require("game.UI.pet.UIPetFriendlyItem")

function UIPetFriendlyCell:ctor()
    self:CreateUI()
end

function UIPetFriendlyCell:CreateUI()

    self.item = UIPetFriendlyItem.new() 
    self:addChild(self.item)
end

function UIPetFriendlyCell:onClick()
end

function UIPetFriendlyCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPetFriendlyCell:updateUI()
    self.item:setData(self.data)
end

return UIPetFriendlyCell
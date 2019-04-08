local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPKItemCell  = class("UIPKItemCell", function() return cc.TableViewCell:create() end )
local UIPKItem = require("game.UI.world.UIPKItem")

function UIPKItemCell:ctor()
    self:CreateUI()
end

function UIPKItemCell:CreateUI()

    self.item = UIPKItem.new() 
    self:addChild(self.item)
end

function UIPKItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPKItemCell:updateUI()
    self.item:setData(self.data)
end

return UIPKItemCell
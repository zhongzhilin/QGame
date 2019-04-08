local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIPetCell  = class("UIPetCell", function() return cc.TableViewCell:create() end )
local UIPetItem = require("game.UI.pet.UIPetItem")

function UIPetCell:ctor()
    self:CreateUI()
end

function UIPetCell:CreateUI()

    self.item = UIPetItem.new() 
    self:addChild(self.item)
end

function UIPetCell:onClick()
end

function UIPetCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPetCell:updateUI()
    self.item:setData(self.data)
end

return UIPetCell
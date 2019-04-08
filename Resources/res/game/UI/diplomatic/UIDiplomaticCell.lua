local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIDiplomaticCell  = class("UIDiplomaticCell", function() return cc.TableViewCell:create() end )
local UIDiplomaticItem = require("game.UI.diplomatic.UIDiplomaticItem")

function UIDiplomaticCell:ctor()
    self:CreateUI()
end

function UIDiplomaticCell:CreateUI()

    self.item = UIDiplomaticItem.new() 
    self:addChild(self.item)
end

function UIDiplomaticCell:onClick()
end

function UIDiplomaticCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIDiplomaticCell:updateUI()
    self.item:setData(self.data)
end

return UIDiplomaticCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIScienceDCell  = class("UIScienceDCell", function() return cc.TableViewCell:create() end )
local UIScienceDItem = require("game.UI.science.UIScienceDItem")

function UIScienceDCell:ctor()
    self:CreateUI()
end

function UIScienceDCell:CreateUI()

    self.item = UIScienceDItem.new() 
    self:addChild(self.item)
end

function UIScienceDCell:onClick()
end

function UIScienceDCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIScienceDCell:updateUI()
    self.item:setData(self.data)
end

return UIScienceDCell
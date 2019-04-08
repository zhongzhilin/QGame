local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIPandectInfoCell  = class("UIPandectInfoCell", function() return cc.TableViewCell:create() end )
local UIPandectInfoItem = require("game.UI.pandect.UIPandectInfoItem")

function UIPandectInfoCell:ctor()
    self:CreateUI()
end

function UIPandectInfoCell:CreateUI()

    self.item = UIPandectInfoItem.new() 
    self:addChild(self.item)
end

function UIPandectInfoCell:onClick()
end

function UIPandectInfoCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPandectInfoCell:updateUI()
    self.item:setData(self.data)
end

return UIPandectInfoCell
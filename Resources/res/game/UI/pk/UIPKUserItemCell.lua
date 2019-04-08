local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIPKUserItemCell  = class("UIPKUserItemCell", function() return cc.TableViewCell:create() end )
local UIPKUserItem = require("game.UI.pk.UIPKUserItem")

function UIPKUserItemCell:ctor()
    self:CreateUI()
end

function UIPKUserItemCell:CreateUI()

    self.item = UIPKUserItem.new() 
    self:addChild(self.item)
end

function UIPKUserItemCell:onClick()
	
end

function UIPKUserItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPKUserItemCell:updateUI()
    self.item:setData(self.data)
end

return UIPKUserItemCell



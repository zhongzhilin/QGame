local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIPKRecordItemCell  = class("UIPKRecordItemCell", function() return cc.TableViewCell:create() end )
local UIPKRecordItem = require("game.UI.pk.UIPKRecordItem")

function UIPKRecordItemCell:ctor()
    self:CreateUI()
end

function UIPKRecordItemCell:CreateUI()

    self.item = UIPKRecordItem.new() 
    self:addChild(self.item)
end

function UIPKRecordItemCell:onClick()
	
end

function UIPKRecordItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPKRecordItemCell:updateUI()
    self.item:setData(self.data)
end

return UIPKRecordItemCell



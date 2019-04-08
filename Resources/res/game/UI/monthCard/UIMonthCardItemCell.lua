local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIMonthCardItemCell  = class("UIMonthCardItemCell", function() return cc.TableViewCell:create() end )
local UIMonthCardInfoItem = require("game.UI.monthCard.UIMonthCardInfoItem")

function UIMonthCardItemCell:ctor()
    self:CreateUI()
end

function UIMonthCardItemCell:CreateUI()

    self.item = UIMonthCardInfoItem.new() 
    self:addChild(self.item)
end

function UIMonthCardItemCell:onClick()
	
end

function UIMonthCardItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMonthCardItemCell:updateUI()
    self.item:setData(self.data)
end

return UIMonthCardItemCell
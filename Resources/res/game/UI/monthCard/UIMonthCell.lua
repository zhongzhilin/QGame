local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIMonthCell  = class("UIMonthCell", function() return cc.TableViewCell:create() end )
local UIMonthItem = require("game.UI.monthCard.UIMonthItem")

function UIMonthCell:ctor()
    self:CreateUI()
end

function UIMonthCell:CreateUI()

    self.item = UIMonthItem.new() 
    self:addChild(self.item)
end

function UIMonthCell:onClick()
end

function UIMonthCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMonthCell:updateUI()
    self.item:setData(self.data)
end

return UIMonthCell
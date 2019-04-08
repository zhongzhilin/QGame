local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UISevenDayRechargeItemCell  = class("UISevenDayRechargeItemCell", function() return cc.TableViewCell:create() end )
local NormalTaskItem = require("game.UI.fund.UISevenDayRechargeItem")

function UISevenDayRechargeItemCell:ctor()
    self:CreateUI()
end

function UISevenDayRechargeItemCell:CreateUI()

    self.item = NormalTaskItem.new()    
    self:addChild(self.item)
end

function UISevenDayRechargeItemCell:onClick()
   
end

function UISevenDayRechargeItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UISevenDayRechargeItemCell:updateUI()
    self.item:setData(self.data)
end

return UISevenDayRechargeItemCell
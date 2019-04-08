local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIFundItemCell  = class("UIFundItemCell", function() return cc.TableViewCell:create() end )
local NormalTaskItem = require("game.UI.fund.UIFundItem")

function UIFundItemCell:ctor()
    self:CreateUI()
end

function UIFundItemCell:CreateUI()

    self.item = NormalTaskItem.new()    
    self:addChild(self.item)
end

function UIFundItemCell:onClick()
   
end

function UIFundItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIFundItemCell:updateUI()
    self.item:setData(self.data)
end

return UIFundItemCell
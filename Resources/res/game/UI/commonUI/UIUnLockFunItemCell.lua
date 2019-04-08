local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnLockFunItemCell  = class("UIUnLockFunItemCell", function() return cc.TableViewCell:create() end )
local UIUnLockFunItem = require("game.UI.commonUI.UIUnLockFunItem")

function UIUnLockFunItemCell:ctor()
    self:CreateUI()
end

function UIUnLockFunItemCell:CreateUI()

    self.item = UIUnLockFunItem.new() 
    self:addChild(self.item)
end

function UIUnLockFunItemCell:onClick()
end

function UIUnLockFunItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnLockFunItemCell:updateUI()
    self.item:setData(self.data)
end

return UIUnLockFunItemCell
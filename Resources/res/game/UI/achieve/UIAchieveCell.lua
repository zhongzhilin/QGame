local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIAchieveCell  = class("UIAchieveCell", function() return cc.TableViewCell:create() end )
local UIAchieveItem = require("game.UI.achieve.UIAchieveItem")

function UIAchieveCell:ctor()
    self:CreateUI()
end

function UIAchieveCell:CreateUI()

    self.item = UIAchieveItem.new() 
    self:addChild(self.item)
end

function UIAchieveCell:onClick()
end

function UIAchieveCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIAchieveCell:updateUI()
    self.item:setData(self.data)
end

return UIAchieveCell
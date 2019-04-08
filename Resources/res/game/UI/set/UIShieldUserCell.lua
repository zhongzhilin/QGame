local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIShieldUserCell  = class("UIShieldUserCell", function() return cc.TableViewCell:create() end )
local UIShieldUserItem = require("game.UI.set.UIShieldUserItem")

function UIShieldUserCell:ctor()
    self:CreateUI()
end

function UIShieldUserCell:CreateUI()

    self.item = UIShieldUserItem.new() 
    self:addChild(self.item)
end

function UIShieldUserCell:onClick()
end

function UIShieldUserCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIShieldUserCell:updateUI()
    self.item:setData(self.data)
end

return UIShieldUserCell
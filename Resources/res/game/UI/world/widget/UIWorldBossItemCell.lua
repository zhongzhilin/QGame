local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIWorldBossItemCell  = class("UIWorldBossItemCell", function() return cc.TableViewCell:create() end )
local UIWorldBossItem = require("game.UI.world.widget.UIWorldBossItem")

function UIWorldBossItemCell:ctor()
    self:CreateUI()
end

function UIWorldBossItemCell:CreateUI()

    self.item = UIWorldBossItem.new() 
    self:addChild(self.item)
end

function UIWorldBossItemCell:onClick()
end

function UIWorldBossItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIWorldBossItemCell:updateUI()
    self.item:setData(self.data)
end

return UIWorldBossItemCell
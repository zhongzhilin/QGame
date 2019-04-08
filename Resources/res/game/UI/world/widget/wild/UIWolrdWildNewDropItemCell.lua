local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIWolrdWildNewDropItemCell  = class("UIWolrdWildNewDropItemCell", function() return cc.TableViewCell:create() end )
local UIWolrdWildNewDropItem = require("game.UI.world.widget.wild.UIWolrdWildNewDropItem")

function UIWolrdWildNewDropItemCell:ctor()
    self:CreateUI()
end

function UIWolrdWildNewDropItemCell:CreateUI()

    self.item = UIWolrdWildNewDropItem.new() 
    self:addChild(self.item)
end

function UIWolrdWildNewDropItemCell:onClick()
end

function UIWolrdWildNewDropItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIWolrdWildNewDropItemCell:updateUI()
    self.item:setData(self.data)
end

return UIWolrdWildNewDropItemCell
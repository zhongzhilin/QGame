local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIWildSoldierItemCell = class("UIWildSoldierItemCell", function() return cc.TableViewCell:create() end )
local UIWildSoldierItem = require("game.UI.world.widget.wild.UIWildSoldierItem")

function UIWildSoldierItemCell:ctor()
    
    self:CreateUI()
end

function UIWildSoldierItemCell:CreateUI()

    self.item = UIWildSoldierItem.new() 
    self:addChild(self.item)
end

function UIWildSoldierItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIWildSoldierItemCell:updateUI()
    self.item:setData(self.data)
end

return UIWildSoldierItemCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UITurntableHeroCell  = class("UITurntableHeroCell", function() return cc.TableViewCell:create() end )
local UITurntableHeroItem = require("game.UI.turnable.UITurntableHeroItem")

function UITurntableHeroCell:ctor()
    self:CreateUI()
end

function UITurntableHeroCell:CreateUI()

    self.item = UITurntableHeroItem.new() 
    self.item:setPosition(cc.p(60, 60))
    self.item:CreateUI()
    self:addChild(self.item)
end

function UITurntableHeroCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITurntableHeroCell:updateUI()
    self.item:setData(self.data)
end

return UITurntableHeroCell
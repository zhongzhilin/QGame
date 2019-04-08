local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIGarrisonEffectCell  = class("UIGarrisonEffectCell", function() return cc.TableViewCell:create() end )
local UIGarrisonEffect = require("game.UI.castleGarrison.UIGarrisonEffect")

function UIGarrisonEffectCell:ctor()
    self:CreateUI()
end

function UIGarrisonEffectCell:CreateUI()

    self.item = UIGarrisonEffect.new() 
    self:addChild(self.item)
end

function UIGarrisonEffectCell:onClick()
end

function UIGarrisonEffectCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGarrisonEffectCell:updateUI()
    self.item:setData(self.data)
end

return UIGarrisonEffectCell
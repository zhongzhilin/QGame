local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIGarrisonHeroCell  = class("UIGarrisonHeroCell", function() return cc.TableViewCell:create() end )
local UIGarrisonHero = require("game.UI.castleGarrison.UIGarrisonHero")

function UIGarrisonHeroCell:ctor()
    self:CreateUI()
end

function UIGarrisonHeroCell:CreateUI()

    self.item = UIGarrisonHero.new() 
    self:addChild(self.item)
end

function UIGarrisonHeroCell:onClick()
	gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
	global.panelMgr:getPanel("UIGarrisonSelectPanel"):refershSelect(self.data, true)
end

function UIGarrisonHeroCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGarrisonHeroCell:updateUI()
    self.item:setData(self.data)
end

return UIGarrisonHeroCell
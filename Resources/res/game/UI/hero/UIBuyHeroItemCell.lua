--
-- Author: Your Name
-- Date: 2017-03-20 20:12:46
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIBuyHeroItemCell  = class("UIBuyHeroItemCell", function() return cc.TableViewCell:create() end )
local UIBuyHeroItem = require("game.UI.hero.UIBuyHeroItem")

function UIBuyHeroItemCell:ctor()
    self:CreateUI()
end

function UIBuyHeroItemCell:CreateUI()
    self.item = UIBuyHeroItem.new() 
    self:addChild(self.item)
end
 

function UIBuyHeroItemCell:onClick()
	global.panelMgr:openPanel("UIDetailPanel"):setData(global.heroData:getHeroDataById(self.data.dropid))
end

function UIBuyHeroItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end
 
return UIBuyHeroItemCell
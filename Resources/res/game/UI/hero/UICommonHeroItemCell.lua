--
-- Author: Your Name
-- Date: 2017-03-20 20:12:46
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UICommonHeroItemCell = class("UICommonHeroItemCell", function() return cc.TableViewCell:create() end )
local UICommonHeroItem = require("game.UI.hero.UICommonHeroItem")

function UICommonHeroItemCell:ctor()
    self:CreateUI()
end

function UICommonHeroItemCell:CreateUI()
    self.item = UICommonHeroItem.new() 
    self:addChild(self.item)
end    

function UICommonHeroItemCell:onClick()

    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    global.panelMgr:openPanel("UIDetailPanel"):setData(self.data)
end

function UICommonHeroItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end
 
return UICommonHeroItemCell
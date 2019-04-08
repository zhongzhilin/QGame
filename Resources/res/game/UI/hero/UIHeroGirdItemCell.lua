--
-- Author: Your Name
-- Date: 2017-03-20 20:12:46
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIHeroGirdItemCell  = class("UIHeroGirdItemCell", function() return cc.TableViewCell:create() end )
local UIHeroGirdItem = require("game.UI.hero.UIHeroGirdItem")

function UIHeroGirdItemCell:ctor()
    self:CreateUI()
end

function UIHeroGirdItemCell:CreateUI()
    self.item = UIHeroGirdItem.new() 
    self:addChild(self.item)
end
 

function UIHeroGirdItemCell:onClick()

   	gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    global.panelMgr:openPanel("UIDetailPanel"):setData(self.data,true)
end

function UIHeroGirdItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end
 
return UIHeroGirdItemCell
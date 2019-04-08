--
-- Author: Your Name
-- Date: 2017-03-20 20:12:46
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIHeroItemCell  = class("UIHeroItemCell", function() return cc.TableViewCell:create() end )
local UIHeroItem = require("game.UI.hero.UIHeroItemArr")

function UIHeroItemCell:ctor()
    self:CreateUI()
end

function UIHeroItemCell:CreateUI()
    self.item = UIHeroItem.new() 
    self:addChild(self.item)
end
 

function UIHeroItemCell:onClick()

end

function UIHeroItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end
 
return UIHeroItemCell
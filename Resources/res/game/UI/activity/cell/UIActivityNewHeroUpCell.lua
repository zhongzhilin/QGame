--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIActivityNewHeroUpCell = class("UIActivityNewHeroUpCell", function() return cc.TableViewCell:create() end )
local UIActivityNewHeroUpItem  =   require("game.UI.activity.Node.UIActivityNewHeroUpItem")

function UIActivityNewHeroUpCell:ctor()
    self:CreateUI()
end

function UIActivityNewHeroUpCell:CreateUI()
    self.item = UIActivityNewHeroUpItem.new() 
    self:addChild(self.item)
end

function UIActivityNewHeroUpCell:onClick()
end
 
function UIActivityNewHeroUpCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIActivityNewHeroUpCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIActivityNewHeroUpCell




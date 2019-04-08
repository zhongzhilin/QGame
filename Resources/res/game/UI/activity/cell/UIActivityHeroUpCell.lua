--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIActivityHeroUpCell = class("UIActivityHeroUpCell", function() return cc.TableViewCell:create() end )
local UIActivityHeroUpItem  =   require("game.UI.activity.Node.UIActivityHeroUpItem")

function UIActivityHeroUpCell:ctor()
    self:CreateUI()
end

function UIActivityHeroUpCell:CreateUI()
    self.item = UIActivityHeroUpItem.new() 
    self:addChild(self.item)
end

function UIActivityHeroUpCell:onClick()
end
 
function UIActivityHeroUpCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIActivityHeroUpCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIActivityHeroUpCell




--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIKillItemCell = class("UIKillItemCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.killactivity.UIKillItem")

function UIKillItemCell:ctor()
    self:CreateUI()
end

function UIKillItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIKillItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

function UIKillItemCell:chooseServer()
end 

function UIKillItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIKillItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIKillItemCell




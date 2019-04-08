--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIRewardItemCell = class("UIRewardItemCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.Node.UIIconNode")

function UIRewardItemCell:ctor()
    self:CreateUI()
end

function UIRewardItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIRewardItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

function UIRewardItemCell:chooseServer()
end 

function UIRewardItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIRewardItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIRewardItemCell




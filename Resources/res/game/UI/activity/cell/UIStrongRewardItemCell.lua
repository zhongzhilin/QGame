--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIStrongRewardItemCell = class("UIStrongRewardItemCell", function() return cc.TableViewCell:create() end )
local item  =   require("game.UI.activity.Node.UIStrongRewardItem")

function UIStrongRewardItemCell:ctor()
    self:CreateUI()
end

function UIStrongRewardItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIStrongRewardItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

 
function UIStrongRewardItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIStrongRewardItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIStrongRewardItemCell




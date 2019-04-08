--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UISevenDaysRewardItemCell = class("UISevenDaysRewardItemCell", function() return cc.TableViewCell:create() end )
local item  =   require("game.UI.activity.sevendays.UIItem")

function UISevenDaysRewardItemCell:ctor()
    self:CreateUI()
end

function UISevenDaysRewardItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UISevenDaysRewardItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

 
function UISevenDaysRewardItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UISevenDaysRewardItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UISevenDaysRewardItemCell




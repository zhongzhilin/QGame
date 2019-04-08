--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UISevenDaysItemCell = class("UISevenDaysItemCell", function() return cc.TableViewCell:create() end )
local item  =   require("game.UI.activity.sevendays.UISevenDaysItem")

function UISevenDaysItemCell:ctor()
    self:CreateUI()
end

function UISevenDaysItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UISevenDaysItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

 
function UISevenDaysItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UISevenDaysItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UISevenDaysItemCell




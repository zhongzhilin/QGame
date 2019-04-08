--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIActivityRuleItemCell = class("UIActivityRuleItemCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.Node.UIActivityRuleItem")

function UIActivityRuleItemCell:ctor()
    self:CreateUI()
end

function UIActivityRuleItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIActivityRuleItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

function UIActivityRuleItemCell:chooseServer()
end 

function UIActivityRuleItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIActivityRuleItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIActivityRuleItemCell




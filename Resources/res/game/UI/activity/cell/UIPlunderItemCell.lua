--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPlunderItemCell = class("UIPlunderItemCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.plunderactivity.UIPlunderItem")

function UIPlunderItemCell:ctor()
    self:CreateUI()
end

function UIPlunderItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIPlunderItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end


function UIPlunderItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIPlunderItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIPlunderItemCell




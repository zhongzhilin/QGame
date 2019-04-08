--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIPKRewordItemCell = class("UIPKRewordItemCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.killactivity.UIKillItem")

function UIPKRewordItemCell:ctor()
    self:CreateUI()
end

function UIPKRewordItemCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UIPKRewordItemCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

function UIPKRewordItemCell:chooseServer()
end 

function UIPKRewordItemCell:setData(data)
    self.data = data
    self.item:setPKdata(self.data)
end

function UIPKRewordItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIPKRewordItemCell




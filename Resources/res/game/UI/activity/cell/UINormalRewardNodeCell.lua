--
-- Author: Your Name
-- Date: 2017-04-23 18:27:42

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UINormalRewardNodeCell = class("UINormalRewardNodeCell", function() return cc.TableViewCell:create() end )
local item = require("game.UI.activity.Node.UIRewardItemNode")

function UINormalRewardNodeCell:ctor()
    self:CreateUI()
end

function UINormalRewardNodeCell:CreateUI()
    self.item = item.new() 
    self:addChild(self.item)
end

function UINormalRewardNodeCell:onClick()
	-- local panel =global.panelMgr:openPanel("UIActivityDetailPanel")
	-- panel:setData(self.data)
end

function UINormalRewardNodeCell:chooseServer()
end 

function UINormalRewardNodeCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UINormalRewardNodeCell:updateUI()
   --self.item:setData(self.data)
end

 
return UINormalRewardNodeCell




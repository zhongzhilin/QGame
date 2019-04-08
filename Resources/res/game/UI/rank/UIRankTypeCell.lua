local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIRankTypeCell  = class("UIRankTypeCell", function() return cc.TableViewCell:create() end )
local UIRankTypeItem = require("game.UI.rank.UIRankTypeItem")

function UIRankTypeCell:ctor()
    self:CreateUI()
end

function UIRankTypeCell:CreateUI()

    self.item = UIRankTypeItem.new() 
    self:addChild(self.item)
end

function UIRankTypeCell:onClick()
	global.panelMgr:openPanel("UIRankInfoPanel"):setData(self.data)
end

function UIRankTypeCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIRankTypeCell:updateUI()
    self.item:setData(self.data)
end

return UIRankTypeCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local InfoNodeCell  = class("InfoNodeCell", function() return cc.TableViewCell:create() end )
InfoNodeCell.nodeIdx = 2

function InfoNodeCell:ctor()
    self:CreateUI()
end

function InfoNodeCell:CreateUI()
	local BuildInfoItem = require("game.UI.city.detail.widget.InfoNode"..InfoNodeCell.nodeIdx)
    self.item = BuildInfoItem.new() 
    self:addChild(self.item)
end

function InfoNodeCell:onClick()
end

function InfoNodeCell:setData(data)
    self.data = data
    self:updateUI()
end

function InfoNodeCell:updateUI()
    self.item:setData(self.data)
end

return InfoNodeCell
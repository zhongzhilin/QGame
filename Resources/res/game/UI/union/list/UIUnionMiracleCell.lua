local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionMiracleCell  = class("UIUnionMiracleCell", function() return cc.TableViewCell:create() end )
local UIUnionMiracleItem = require("game.UI.union.list.UIUnionMiracleItem")

function UIUnionMiracleCell:ctor()
    self:CreateUI()
end

function UIUnionMiracleCell:CreateUI()

    self.item = UIUnionMiracleItem.new() 
    self:addChild(self.item)
end

function UIUnionMiracleCell:onClick()
	print("##########UIUnionMiracleCell:onClick()  self.data.id=")
end

function UIUnionMiracleCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionMiracleCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionMiracleCell
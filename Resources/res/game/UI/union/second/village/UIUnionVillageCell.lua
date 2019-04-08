local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionVillageCell  = class("UIUnionVillageCell", function() return cc.TableViewCell:create() end )
local UIUnionVillageItem = require("game.UI.union.second.village.UIUnionVillageItem")

function UIUnionVillageCell:ctor()
    self:CreateUI()
end

function UIUnionVillageCell:CreateUI()

    self.item = UIUnionVillageItem.new() 
    self:addChild(self.item)
end

function UIUnionVillageCell:onClick()
end

function UIUnionVillageCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionVillageCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionVillageCell
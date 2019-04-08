local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionDynamicItemCell  = class("UIUnionDynamicItemCell", function() return cc.TableViewCell:create() end )
local UIUnionDynamicItem = require("game.UI.union.second.dynamic.UIUnionDynamicItem")

function UIUnionDynamicItemCell:ctor()
    self:CreateUI()
end

function UIUnionDynamicItemCell:CreateUI()

    self.item = UIUnionDynamicItem.new() 
    self:addChild(self.item)
end

function UIUnionDynamicItemCell:onClick()
end

function UIUnionDynamicItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionDynamicItemCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionDynamicItemCell
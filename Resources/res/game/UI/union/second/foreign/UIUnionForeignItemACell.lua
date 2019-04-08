local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionForeignItemACell  = class("UIUnionForeignItemACell", function() return cc.TableViewCell:create() end )
local UIUnionForeignItemA = require("game.UI.union.second.foreign.UIUnionForeignItemA")

function UIUnionForeignItemACell:ctor()
    self:CreateUI()
end

function UIUnionForeignItemACell:CreateUI()

    self.item = UIUnionForeignItemA.new() 
    self:addChild(self.item)
end

function UIUnionForeignItemACell:onClick()
end

function UIUnionForeignItemACell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionForeignItemACell:updateUI()
    self.item:setData(self.data)
end

return UIUnionForeignItemACell
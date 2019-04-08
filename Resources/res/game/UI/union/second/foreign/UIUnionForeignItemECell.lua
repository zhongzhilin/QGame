local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionForeignItemECell  = class("UIUnionForeignItemECell", function() return cc.TableViewCell:create() end )
local UIUnionForeignItemE = require("game.UI.union.second.foreign.UIUnionForeignItemE")

function UIUnionForeignItemECell:ctor()
    self:CreateUI()
end

function UIUnionForeignItemECell:CreateUI()

    self.item = UIUnionForeignItemE.new() 
    self:addChild(self.item)
end

function UIUnionForeignItemECell:onClick()
end

function UIUnionForeignItemECell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionForeignItemECell:updateUI()
    self.item:setData(self.data)
end

return UIUnionForeignItemECell
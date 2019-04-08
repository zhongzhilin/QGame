local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionHelpItemCell  = class("UIUnionHelpItemCell", function() return cc.TableViewCell:create() end )
local UIUShopItemA = require("game.UI.union.second.help.UIUnionHelpItem")

function UIUnionHelpItemCell:ctor()
    self:CreateUI()
end

function UIUnionHelpItemCell:CreateUI()

    self.item = UIUShopItemA.new() 
    self:addChild(self.item)
end

function UIUnionHelpItemCell:onClick()
end

function UIUnionHelpItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionHelpItemCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionHelpItemCell
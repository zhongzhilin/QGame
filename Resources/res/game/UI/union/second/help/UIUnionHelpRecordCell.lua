local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionHelpRecordCell  = class("UIUnionHelpRecordCell", function() return cc.TableViewCell:create() end )
local UIUShopItemA = require("game.UI.union.second.help.UIUnionHelpRecord")

function UIUnionHelpRecordCell:ctor()
    self:CreateUI()
end

function UIUnionHelpRecordCell:CreateUI()

    self.item = UIUShopItemA.new() 
    self:addChild(self.item)
end

function UIUnionHelpRecordCell:onClick()
end

function UIUnionHelpRecordCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionHelpRecordCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionHelpRecordCell
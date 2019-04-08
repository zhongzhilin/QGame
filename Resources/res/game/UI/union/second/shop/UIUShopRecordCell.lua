local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUShopRecordCell  = class("UIUShopRecordCell", function() return cc.TableViewCell:create() end )
local UIUShopRecordItem = require("game.UI.union.second.shop.UIUShopRecordItem")

function UIUShopRecordCell:ctor()
    self:CreateUI()
end

function UIUShopRecordCell:CreateUI()

    self.item = UIUShopRecordItem.new() 
    self:addChild(self.item)
end

function UIUShopRecordCell:onClick()
end

function UIUShopRecordCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUShopRecordCell:updateUI()
    self.item:setData(self.data)
end

return UIUShopRecordCell
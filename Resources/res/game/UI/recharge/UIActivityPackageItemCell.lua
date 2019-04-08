local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIActivityPackageItemCell  = class("UIActivityPackageItemCell", function() return cc.TableViewCell:create() end )
local UIActivityPackageItem = require("game.UI.recharge.UIActivityPackageItem")

function UIActivityPackageItemCell:ctor()
    self:CreateUI()
end

function UIActivityPackageItemCell:CreateUI()

    self.item = UIActivityPackageItem.new() 
    self:addChild(self.item)
end

function UIActivityPackageItemCell:onClick()

    global.panelMgr:openPanel("UIADGiftPanel"):setData(self.data.id)
end

function UIActivityPackageItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIActivityPackageItemCell:updateUI()
    self.item:setData(self.data)
end

return UIActivityPackageItemCell
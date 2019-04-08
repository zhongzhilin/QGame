local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIGiftListItemCell  = class("UIGiftListItemCell", function() return cc.TableViewCell:create() end )
local UIGiftListItem = require("game.UI.chat.UIGiftListItem")

function UIGiftListItemCell:ctor()
    self:CreateUI()
end

function UIGiftListItemCell:CreateUI()

    self.item = UIGiftListItem.new() 
    self:addChild(self.item)
end

function UIGiftListItemCell:onClick()
end

function UIGiftListItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGiftListItemCell:updateUI()
    self.item:setData(self.data)
end

return UIGiftListItemCell
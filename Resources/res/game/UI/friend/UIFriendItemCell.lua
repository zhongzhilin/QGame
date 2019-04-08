local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIFriendItemCell  = class("UIFriendItemCell", function() return cc.TableViewCell:create() end )
local UIFriendItem = require("game.UI.friend.UIFriendItem")

function UIFriendItemCell:ctor()
    self:CreateUI()
end

function UIFriendItemCell:CreateUI()

    self.item = UIFriendItem.new() 
    self:addChild(self.item)
end

function UIFriendItemCell:onClick()
end

function UIFriendItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIFriendItemCell:updateUI()
    self.item:setData(self.data)
end

return UIFriendItemCell
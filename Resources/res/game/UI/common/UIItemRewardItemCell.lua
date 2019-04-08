local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIItemRewardItemCell  = class("UIItemRewardItemCell", function() return cc.TableViewCell:create() end )
local UIItemRewardItem = require("game.UI.common.UIItemRewardItem")

function UIItemRewardItemCell:ctor()
    
    self:CreateUI()
end

function UIItemRewardItemCell:CreateUI()

    self.item = UIItemRewardItem.new()    
    self:addChild(self.item)
end

function UIItemRewardItemCell:onClick()
end

function UIItemRewardItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIItemRewardItemCell:updateUI()
    self.item:setData(self.data)
end

return UIItemRewardItemCell
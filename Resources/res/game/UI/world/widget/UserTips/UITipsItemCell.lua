local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UITipsItemCell  = class("UITipsItemCell", function() return cc.TableViewCell:create() end )
local UITipsItem = require("game.UI.world.widget.UserTips.UITipsItem")

function UITipsItemCell:ctor()
    
    self:CreateUI()
end

function UITipsItemCell:CreateUI()

    self.item = UITipsItem.new()    
    self:addChild(self.item)
end

function UITipsItemCell:onClick()
    
end

function UITipsItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITipsItemCell:updateUI()
    self.item:setData(self.data)
end

return UITipsItemCell
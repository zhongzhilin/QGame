local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userDat

local UIMailDetailItemCell  = class("UIMailDetailItemCell", function() return cc.TableViewCell:create() end )
local UIMailRewardItem = require("game.UI.mail.UIMailRewardItem")


function UIMailDetailItemCell:ctor()
    
    self:CreateUI()
end

function UIMailDetailItemCell:CreateUI()

    self.item = UIMailRewardItem.new() 
    self:addChild(self.item)
end


function UIMailDetailItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMailDetailItemCell:updateUI()
    self.item:setData(self.data)
end

return UIMailDetailItemCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIMailAllRewardCell  = class("UIMailAllRewardCell", function() return cc.TableViewCell:create() end )
local UIMailAllRewardItem = require("game.UI.mail.UIMailAllRewardItem")

function UIMailAllRewardCell:ctor()
  
    self:CreateUI()
end

function UIMailAllRewardCell:CreateUI()

    self.item = UIMailAllRewardItem.new()    
    self:addChild(self.item)
end

function UIMailAllRewardCell:onClick()
end

function UIMailAllRewardCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMailAllRewardCell:updateUI()
    self.item:setData(self.data)
end

return UIMailAllRewardCell
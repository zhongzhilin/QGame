local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIMailAllRewardNodeCell  = class("UIMailAllRewardNodeCell", function() return cc.TableViewCell:create() end )
local UIMonsterItem = require("game.UI.mail.UIMonsterItem")

function UIMailAllRewardNodeCell:ctor()
  
    self:CreateUI()
end

function UIMailAllRewardNodeCell:CreateUI()

    self.item = UIMonsterItem.new()  
    self:addChild(self.item)
    
end

function UIMailAllRewardNodeCell:onClick()
end

function UIMailAllRewardNodeCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMailAllRewardNodeCell:updateUI()
    self.item:setData(self.data, true)
end

return UIMailAllRewardNodeCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIApproveCell  = class("UIApproveCell", function() return cc.TableViewCell:create() end )
local UIApproveItem = require("game.UI.diplomatic.UIApproveItem")

function UIApproveCell:ctor()
    self:CreateUI()
end

function UIApproveCell:CreateUI()

    self.item = UIApproveItem.new() 
    self:addChild(self.item)
end

function UIApproveCell:onClick()
end

function UIApproveCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIApproveCell:updateUI()
    self.item:setData(self.data)
end

return UIApproveCell
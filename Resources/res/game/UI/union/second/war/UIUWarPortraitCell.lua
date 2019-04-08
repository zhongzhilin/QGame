local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUWarPortraitCell  = class("UIUWarPortraitCell", function() return cc.TableViewCell:create() end )
local UIUWarPortraitItem = require("game.UI.union.second.war.UIUWarPortraitItem")

function UIUWarPortraitCell:ctor()
    self:CreateUI()
end

function UIUWarPortraitCell:CreateUI()

    self.item = UIUWarPortraitItem.new() 
    self:addChild(self.item)
end

function UIUWarPortraitCell:onClick()
end

function UIUWarPortraitCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUWarPortraitCell:updateUI()
    self.item:setData(self.data)
end

return UIUWarPortraitCell
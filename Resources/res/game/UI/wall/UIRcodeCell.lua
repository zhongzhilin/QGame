local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIRcodeCell  = class("UIRcodeCell", function() return cc.TableViewCell:create() end )
local UIRecodeItem = require("game.UI.wall.UIRecodeItem")

function UIRcodeCell:ctor()
    self:CreateUI()
end

function UIRcodeCell:CreateUI()

    self.item = UIRecodeItem.new() 
    self:addChild(self.item)
end

function UIRcodeCell:onClick()
end

function UIRcodeCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIRcodeCell:updateUI()
    self.item:setData(self.data)
end

return UIRcodeCell
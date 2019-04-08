local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIBuffCell  = class("UIBuffCell", function() return cc.TableViewCell:create() end )
local UIBuffItem = require("game.UI.offical.UIBuffItem")

function UIBuffCell:ctor()
    self:CreateUI()
end

function UIBuffCell:CreateUI()

    self.item = UIBuffItem.new() 
    self:addChild(self.item)
end

function UIBuffCell:onClick()
end

function UIBuffCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIBuffCell:updateUI()
    self.item:setData(self.data)
end

return UIBuffCell
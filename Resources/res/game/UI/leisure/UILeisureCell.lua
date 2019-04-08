local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UILeisureCell  = class("UILeisureCell", function() return cc.TableViewCell:create() end )
local UILeisureItem = require("game.UI.leisure.UILeisureItem")

function UILeisureCell:ctor()
    self:CreateUI()
end

function UILeisureCell:CreateUI()

    self.item = UILeisureItem.new() 
    self:addChild(self.item)
end

function UILeisureCell:onClick()
end

function UILeisureCell:setData(data)
    self.data = data
    self:updateUI()
end

function UILeisureCell:updateUI()
    self.item:setData(self.data)
end

return UILeisureCell
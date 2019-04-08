local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIMiracleDoorHistoryItemCell  = class("UIMiracleDoorHistoryItemCell", function() return cc.TableViewCell:create() end )
local UIMiracleDoorHistoryItem = require("game.UI.world.widget.UIMiracleDoorHistoryItem")

function UIMiracleDoorHistoryItemCell:ctor()
    
    self:CreateUI()
end

function UIMiracleDoorHistoryItemCell:CreateUI()

    self.item = UIMiracleDoorHistoryItem.new()    
    self:addChild(self.item)
end

function UIMiracleDoorHistoryItemCell:onClick()
end

function UIMiracleDoorHistoryItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMiracleDoorHistoryItemCell:updateUI()
    self.item:setData(self.data)
end

return UIMiracleDoorHistoryItemCell
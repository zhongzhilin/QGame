local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIEquipForgeItemCell  = class("UIEquipForgeItemCell", function() return cc.TableViewCell:create() end )
local UIEquipForgeItem = require("game.UI.equip.UIEquipForgeItem")

function UIEquipForgeItemCell:ctor()
    self:CreateUI()
end

function UIEquipForgeItemCell:CreateUI()

    self.item = UIEquipForgeItem.new() 
    self:addChild(self.item)
end

function UIEquipForgeItemCell:onClick()
end

function UIEquipForgeItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIEquipForgeItemCell:updateUI()
    self.item:setData(self.data)
end

return UIEquipForgeItemCell
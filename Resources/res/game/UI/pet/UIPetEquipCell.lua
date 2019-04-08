local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIPetEquipCell  = class("UIPetEquipCell", function() return cc.TableViewCell:create() end )
local UIPetEquipItem = require("game.UI.pet.UIPetEquipItem")

function UIPetEquipCell:ctor()
    self:CreateUI()
end

function UIPetEquipCell:CreateUI()

    self.item = UIPetEquipItem.new() 
    self:addChild(self.item)
end

function UIPetEquipCell:onClick()
end

function UIPetEquipCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIPetEquipCell:updateUI()
    self.item:setData(self.data)
end

return UIPetEquipCell
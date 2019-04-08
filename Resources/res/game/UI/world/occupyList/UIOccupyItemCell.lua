local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local UIOccupyItemCell  = class("UIOccupyItemCell", function() return cc.TableViewCell:create() end )
local UIOccupyItem = require("game.UI.world.occupyList.UIOccupyItem")

function UIOccupyItemCell:ctor()
    
    self:CreateUI()
end

function UIOccupyItemCell:CreateUI()

    self.item = UIOccupyItem.new()    
    self:addChild(self.item)
end

function UIOccupyItemCell:onClick()
    
end

function UIOccupyItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIOccupyItemCell:updateUI()
    self.item:setData(self.data)
end

return UIOccupyItemCell
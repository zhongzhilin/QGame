--
-- Author: Your Name
-- Date: 2017-03-15 12:00:11
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIMysteriousItemCell  = class("UIMysteriousItemCell", function() return cc.TableViewCell:create() end )
local UIUnionBtnItem = require("game.UI.mysterious.UIMysteriousItem")

function UIMysteriousItemCell:ctor()
    self:CreateUI()
end

function UIMysteriousItemCell:CreateUI()
    self.item = UIUnionBtnItem.new() 
    self:addChild(self.item)
end


function UIMysteriousItemCell:onClick()
 
end

function UIMysteriousItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end


function UIMysteriousItemCell:updateUI()
end
 
return UIMysteriousItemCell
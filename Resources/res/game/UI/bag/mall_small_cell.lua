--
-- Author: Your Name
-- Date: 2017-03-13 13:04:01
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local panelMgr = global.panelMgr

local UIBagTableView = require("game.UI.bag.UIBagTableView")
local mall_small_cell  = class("mall_small_cell", function() return cc.TableViewCell:create() end )
local UIBagItem = require("game.UI.bag.mallsmallitem")

function mall_small_cell:ctor()
    self:CreateUI()
end

function mall_small_cell:CreateUI()
    self.item = UIBagItem.new()    
    self:addChild(self.item)
end

function mall_small_cell:onClick()

end

function mall_small_cell:setData(data)
    self.data = data
    self:updateUI()
end

function mall_small_cell:updateUI()
    self.item:setData(self.data)
end

function mall_small_cell:getData()
	
	return self.data
end

return mall_small_cell
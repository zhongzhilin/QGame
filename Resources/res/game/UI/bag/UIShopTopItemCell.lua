--
-- Author: Your Name
-- Date: 2017-03-13 13:04:53
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr

local UITableView = require("game.UI.common.UITableView")
local UIShopTopItemCell  = class("UIShopTopItemCell", function() return cc.TableViewCell:create() end )
local UIBagItem = require("game.UI.bag.UIShopTopItem")

function UIShopTopItemCell:ctor()
    self:CreateUI()
end

function UIShopTopItemCell:CreateUI()
    self.item = UIBagItem.new()    
    self:addChild(self.item)
end

function UIShopTopItemCell:onClick()
end

function UIShopTopItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIShopTopItemCell:updateUI()
    self.item:setData(self.data)
end

function UIShopTopItemCell:getData()
	
	return self.data
end

return UIShopTopItemCell
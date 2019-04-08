--
-- Author: Your Name
-- Date: 2017-03-13 13:04:01
--
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local panelMgr = global.panelMgr

local UIMallsmallitemCell  = class("UIMallsmallitemCell", function() return cc.TableViewCell:create() end )
local UIMallsmallitem = require("game.UI.bag.UIMallsmallitem")

function UIMallsmallitemCell:ctor()
    self:CreateUI()
end

function UIMallsmallitemCell:CreateUI()
    self.item = UIMallsmallitem.new()    
    self:addChild(self.item)
end

function UIMallsmallitemCell:onClick()

end

function UIMallsmallitemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIMallsmallitemCell:updateUI()
    self.item:setData(self.data)
end

function UIMallsmallitemCell:getData()
	
	return self.data
end

return UIMallsmallitemCell
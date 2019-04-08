local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionAppointedCell  = class("UIUnionAppointedCell", function() return cc.TableViewCell:create() end )
local UIUnionAppointedItem = require("game.UI.union.list.UIUnionAppointedItem")

function UIUnionAppointedCell:ctor()
    self:CreateUI()
end

function UIUnionAppointedCell:CreateUI()
    self.item = UIUnionAppointedItem.new() 
    self:addChild(self.item)
end

function UIUnionAppointedCell:onClick()
	log.debug("##########UIUnionAppointedCell:onClick()  self.data.id=%s",self.data.id)
end

function UIUnionAppointedCell:setData(data)
	self.data = data
    self:updateUI()
end

function UIUnionAppointedCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionAppointedCell
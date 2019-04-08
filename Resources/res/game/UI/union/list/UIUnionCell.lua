local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionCell  = class("UIUnionCell", function() return cc.TableViewCell:create() end )
local UIUnionItem = require("game.UI.union.list.UIUnionItem")

function UIUnionCell:ctor()
    self:CreateUI()
end

function UIUnionCell:CreateUI()

    self.item = UIUnionItem.new() 
    self:addChild(self.item)
end

function UIUnionCell:onClick()
	gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
	global.panelMgr:openPanel("UIJoinUnionPanel"):setData(self.data)
end

function UIUnionCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionCell
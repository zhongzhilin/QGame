local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIHeadFrameItemCell  = class("UIHeadFrameItemCell", function() return cc.TableViewCell:create() end )
local UIHeadFrameItem = require("game.UI.roleHead.UIHeadFrameItem")

function UIHeadFrameItemCell:ctor()
    self:CreateUI()
end

function UIHeadFrameItemCell:CreateUI()

    self.item = UIHeadFrameItem.new() 
    self:addChild(self.item)
end

function UIHeadFrameItemCell:onClick()
	
end

function UIHeadFrameItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIHeadFrameItemCell:updateUI()
    self.item:setData(self.data)
end

return UIHeadFrameItemCell
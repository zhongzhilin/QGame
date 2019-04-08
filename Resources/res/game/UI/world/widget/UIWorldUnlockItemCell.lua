local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local UIWorldUnlockItemCell  = class("UIWorldUnlockItemCell", function() return cc.TableViewCell:create() end )
local UIWorldUnlockItem = require("game.UI.world.widget.UIWorldUnlockItem")

function UIWorldUnlockItemCell:ctor()
    
    self:CreateUI()
end

function UIWorldUnlockItemCell:CreateUI()

    self.item = UIWorldUnlockItem.new()    
    self:addChild(self.item)
end

function UIWorldUnlockItemCell:onClick()
    
    -- local panel = global.panelMgr:getPanel("UIWorldSearchPanel")
    -- panel:chooseIndex(self.data.id)
end

function UIWorldUnlockItemCell:setData(data)

    self.data = data
    self:updateUI()
end

function UIWorldUnlockItemCell:updateUI()
    self.item:setData(self.data)
end

function UIWorldUnlockItemCell:getData()
	
	return self.data
end

return UIWorldUnlockItemCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local UIWorldSearchItemCell  = class("UIWorldSearchItemCell", function() return cc.TableViewCell:create() end )
local UIWorldSearchItem = require("game.UI.world.widget.UIWorldSearchItem")

function UIWorldSearchItemCell:ctor()
    
    self:CreateUI()
end

function UIWorldSearchItemCell:CreateUI()

    self.item = UIWorldSearchItem.new()    
    self:addChild(self.item)
end

function UIWorldSearchItemCell:onClick()
    
    if self.item:isLocked() then
        local unlockLevel = self.item:getUnLockLevel()
        global.tipsMgr:showWarning('seek01',unlockLevel)
        return
    end

    local panel = global.panelMgr:getPanel("UIWorldSearchPanel")
    panel:chooseIndex(self.data.id)
end

function UIWorldSearchItemCell:setData(data)

    self.data = data
    self:updateUI()
end

function UIWorldSearchItemCell:updateUI()
    self.item:setData(self.data)
end

function UIWorldSearchItemCell:getData()
	
	return self.data
end

return UIWorldSearchItemCell
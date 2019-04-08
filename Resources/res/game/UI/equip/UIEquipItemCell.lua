local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local panelMgr = global.panelMgr
local UIEquipItemCell  = class("UIEquipItemCell", function() return cc.TableViewCell:create() end )
local UIEquipItem = require("game.UI.equip.UIEquipItem")

function UIEquipItemCell:ctor()
    
    self:CreateUI()
end

function UIEquipItemCell:CreateUI()

    self.item = UIEquipItem.new()    
    self:addChild(self.item)
end

function UIEquipItemCell:onClick()
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_itemsel")
end

function UIEquipItemCell:setData(data)

    self.data = data
    self:updateUI()
end

function UIEquipItemCell:updateUI()
    self.item:setData(self.data)
end

function UIEquipItemCell:setFocus(isSelect,panel)
    
    self.item:setFocus(isSelect,panel)
end

return UIEquipItemCell
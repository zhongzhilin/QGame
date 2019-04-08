--region UIHpSoldierCell.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local panelMgr = global.panelMgr

local UIHpSoldierCell  = class("UIHpSoldierCell", function() return cc.TableViewCell:create() end )
local UIHpSoldierCard = require("game.UI.city.panel.widget.UIHpSoldierCard")

function UIHpSoldierCell:ctor()
    self:CreateUI()
end

function UIHpSoldierCell:CreateUI()
    self.item = UIHpSoldierCard.new()    
    self.item:CreateUI()
    self:addChild(self.item)
end

function UIHpSoldierCell:onClick()
end

function UIHpSoldierCell:setFocus(isSelected)
    self.item:setSelected(isSelected)
end

function UIHpSoldierCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIHpSoldierCell:updateUI()
    self.item:setData(self.data)
end

function UIHpSoldierCell:getItem()
    return self.item
end

function UIHpSoldierCell:getData()
    return self.data
end


return UIHpSoldierCell

--endregion
--region UIAccRewardItem.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIFirRechargeCell  = class("UIFirRechargeCell", function() return cc.TableViewCell:create() end )

function UIFirRechargeCell:ctor()
    self:CreateUI()
end

function UIFirRechargeCell:CreateUI()
    self.item = require("game.UI.activity.firRecharge.UIFirRechargeItem").new() 
    self:addChild(self.item)
end

function UIFirRechargeCell:onClick()
end

function UIFirRechargeCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIFirRechargeCell:updateUI()
    self.item:setData(self.data)
end

return UIFirRechargeCell
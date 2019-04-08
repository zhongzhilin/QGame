local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UISkinBuffTextCell  = class("UISkinBuffTextCell", function() return cc.TableViewCell:create() end )
local UISkinBuffText = require("game.UI.world.skin.UISkinBuffText")

function UISkinBuffTextCell:ctor()
    self:CreateUI()
end

function UISkinBuffTextCell:CreateUI()

    self.item = UISkinBuffText.new() 
    self:addChild(self.item)
end

function UISkinBuffTextCell:onClick()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_List")
end

function UISkinBuffTextCell:setData(data)
    self.data = data
    self:updateUI()
end

function UISkinBuffTextCell:updateUI()
    self.item:setData(self.data)
end

return UISkinBuffTextCell
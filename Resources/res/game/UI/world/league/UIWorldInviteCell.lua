local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIWorldInviteCell  = class("UIWorldInviteCell", function() return cc.TableViewCell:create() end )
local UIWorldInviteItem = require("game.UI.world.league.UIWorldInviteItem")

function UIWorldInviteCell:ctor()
    self:CreateUI()
end

function UIWorldInviteCell:CreateUI()

    self.item = UIWorldInviteItem.new() 
    self:addChild(self.item)
end

function UIWorldInviteCell:onClick()
    global.panelMgr:openPanel("UIWorldInviteDetailPanel"):setData(self.data)
end

function UIWorldInviteCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIWorldInviteCell:updateUI()
    self.item:setData(self.data)
end

return UIWorldInviteCell
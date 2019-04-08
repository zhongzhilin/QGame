local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionAskCell  = class("UIUnionAskCell", function() return cc.TableViewCell:create() end )
local UIUnionAskItem = require("game.UI.union.list.UIUnionAskItem")

function UIUnionAskCell:ctor()
    self:CreateUI()
end

function UIUnionAskCell:CreateUI()

    self.item = UIUnionAskItem.new() 
    self:addChild(self.item)
end

function UIUnionAskCell:onClick()
    global.panelMgr:openPanel("UIUnionAskDetailPanel"):setData(self.data)
end

function UIUnionAskCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionAskCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionAskCell
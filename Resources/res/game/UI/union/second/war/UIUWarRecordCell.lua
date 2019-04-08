local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUWarRecordCell  = class("UIUWarRecordCell", function() return cc.TableViewCell:create() end )
local UIUWarRecordItem = require("game.UI.union.second.war.UIUWarRecordItem")

function UIUWarRecordCell:ctor()
    self:CreateUI()
end

function UIUWarRecordCell:CreateUI()

    self.item = UIUWarRecordItem.new() 
    self:addChild(self.item)
end

function UIUWarRecordCell:onClick()
end

function UIUWarRecordCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUWarRecordCell:updateUI()
    self.item:setData(self.data)
end

return UIUWarRecordCell
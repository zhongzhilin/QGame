local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UITechDetailCell  = class("UITechDetailCell", function() return cc.TableViewCell:create() end )
local UITechDetailItem = require("game.UI.science.tech.UITechDetailItem")

function UITechDetailCell:ctor()
    self:CreateUI()
end

function UITechDetailCell:CreateUI()

    self.item = UITechDetailItem.new() 
    self:addChild(self.item)
end

function UITechDetailCell:onClick()
end

function UITechDetailCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITechDetailCell:updateUI()
    self.item:setData(self.data)
end

return UITechDetailCell
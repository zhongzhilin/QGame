local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UITitleListCell  = class("UITitleListCell", function() return cc.TableViewCell:create() end )
local UITitleListItem = require("game.UI.activity.Node.UITitleListItem")

function UITitleListCell:ctor()
    self:CreateUI()
end


function UITitleListCell:CreateUI()

    self.item = UITitleListItem.new() 
    self:addChild(self.item)
end

function UITitleListCell:onClick()
	
end

function UITitleListCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITitleListCell:updateUI()
    self.item:setData(self.data)
end

return UITitleListCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionFlagCell  = class("UIUnionFlagCell", function() return cc.TableViewCell:create() end )
local UIUnionFlagItem = require("game.UI.union.list.UIUnionFlagItem")

function UIUnionFlagCell:ctor()
    self:CreateUI()
end

function UIUnionFlagCell:CreateUI()

    self.item = UIUnionFlagItem.new() 
    self:addChild(self.item)
end

function UIUnionFlagCell:onClick()
	print("##########UIUnionFlagCell:onClick()  self.data.id="..self.data.id)

    global.panelMgr:getPanel("UIUnionModifyFlag"):setFlag(self.data.id)
end

function UIUnionFlagCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionFlagCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionFlagCell
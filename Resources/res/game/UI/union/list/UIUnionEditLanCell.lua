local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionEditLanCell  = class("UIUnionEditLanCell", function() return cc.TableViewCell:create() end )
local UIUnionEditLanItem = require("game.UI.union.list.UIUnionEditLanItem")

function UIUnionEditLanCell:ctor()
    self:CreateUI()
end

function UIUnionEditLanCell:CreateUI()

    self.item = UIUnionEditLanItem.new() 
    self:addChild(self.item)
end

function UIUnionEditLanCell:onClick()
	print("###########self.data.id="..self.data.id)
	global.panelMgr:getPanel("UIUnionEditLan"):setLanId(self.data.id,true)
end

function UIUnionEditLanCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionEditLanCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionEditLanCell
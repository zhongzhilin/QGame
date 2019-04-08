local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIForgeSelectCell  = class("UIForgeSelectCell", function() return cc.TableViewCell:create() end )
local UIForgeSelectItem = require("game.UI.equip.UIForgeSelectItem")

function UIForgeSelectCell:ctor()
    self:CreateUI()
end

function UIForgeSelectCell:CreateUI()

    self.item = UIForgeSelectItem.new() 
    self:addChild(self.item)
end

function UIForgeSelectCell:onClick()
end

function UIForgeSelectCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIForgeSelectCell:updateUI()
    self.item:setData(self.data)
end

return UIForgeSelectCell
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIBankRecodeCell  = class("UIBankRecodeCell", function() return cc.TableViewCell:create() end )
local UIBankRecodeItem = require("game.UI.diamondBank.UIBankRecodeItem")

function UIBankRecodeCell:ctor()
    self:CreateUI()
end

function UIBankRecodeCell:CreateUI()

    self.item = UIBankRecodeItem.new() 
    self:addChild(self.item)
end

function UIBankRecodeCell:onClick()
end

function UIBankRecodeCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIBankRecodeCell:updateUI()
    self.item:setData(self.data)
end

return UIBankRecodeCell
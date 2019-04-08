local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIDiamondBankCell  = class("UIDiamondBankCell", function() return cc.TableViewCell:create() end )
local UIDiamondBankItem = require("game.UI.diamondBank.UIDiamondBankItem")

function UIDiamondBankCell:ctor()
    self:CreateUI()
end

function UIDiamondBankCell:CreateUI()

    self.item = UIDiamondBankItem.new() 
    self:addChild(self.item)
end

function UIDiamondBankCell:onClick()
	    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
end

function UIDiamondBankCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIDiamondBankCell:updateUI()
    self.item:setData(self.data)
end

return UIDiamondBankCell
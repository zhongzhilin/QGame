local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUDonateRankCell  = class("UIUDonateRankCell", function() return cc.TableViewCell:create() end )
local UIUDonateRankItem = require("game.UI.union.second.donate.UIUDonateRankItem")

function UIUDonateRankCell:ctor()
    self:CreateUI()
end

function UIUDonateRankCell:CreateUI()

    self.item = UIUDonateRankItem.new() 
    self:addChild(self.item)
end

function UIUDonateRankCell:onClick()
	gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
    global.chatApi:getUserInfo(function(msg)
    	global.panelMgr:openPanel("UIUnionMemDetails"):setData(msg.tgInfo[1])
    end, {self.data.lFindID})
end

function UIUDonateRankCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUDonateRankCell:updateUI()
    self.item:setData(self.data)
end

return UIUDonateRankCell
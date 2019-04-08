--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local baseControl  =require("game.UI.replay.control.baseControl")

local centerControl = class("centerControl" ,function () return  baseControl.new() end)

local UIPKSoldier = require("game.UI.replay.view.UIPKSoldier")
local UITitle = require("game.UI.replay.view.UITitle")


function centerControl:start()
	print("centerControl -----------------start")
	self:initWidget()
end 


function centerControl:initWidget()
	-- body
	self:initAttackWidget()
end

function centerControl:initAttackWidget()                                                                                                                                                                           
	-- body
	self.view.attack_left = UIPKSoldier.new()
	self.view.attack_right= UIPKSoldier.new()
	self.view.title = UITitle.new()

	self.view.attack_left:setPositionX(50)

	self.view.attack_right:setPositionX(440)
	self.view.title:setPositionY(150)
	
	self.view:addChild( self.view.attack_left)
	self.view:addChild( self.view.attack_right)
	self.view:addChild( self.view.title)

	self.view.attack_left:setVisible(false)
	self.view.attack_right:setVisible(false)
	self.view.title:setVisible(false)


	table.insert(self.WidgetTable , self.view.attack_left)
	table.insert(self.WidgetTable ,  self.view.attack_right)
	table.insert(self.WidgetTable ,  self.view.title)
end


function centerControl:showtitle()
	self.view.title:setVisible(true)
	local tt = gscheduler.performWithDelayGlobal(function()
		self.view.title:setVisible(false)
		gevent:call(global.gameEvent.EV_ON_UI_SHOWTITLEED)
	end, 1)
end 


function centerControl:showpk()

	self.view.attack_left:setVisible(true)
	self.view.attack_right:setVisible(true)

	-- 已经显示界面了。
	gevent:call(global.gameEvent.EV_ON_UI_SHOWATTACK)
end 



return centerControl

--endregion

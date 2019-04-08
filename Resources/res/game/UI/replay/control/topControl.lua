--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local baseControl  =require("game.UI.replay.control.baseControl")


local topControl = class("topControl" ,function () return  baseControl.new() end)

local UITopHero = require("game.UI.replay.view.UITopHero")
local modehero = require("game.UI.replay.mode.hero")

local UISoldier = require("game.UI.replay.view.UISoldier")


function topControl:start()

	self:initWidget()
end


function topControl:initWidget()

	local hero1 = modehero.new()
	hero1:init({name="攻击方黑熊", soldier ={soldier1,soldier2} , lv= 12})                              
	local d_hero1 = modehero.new()
	d_hero1:init({name="防御方白熊", soldier ={d_soldier_1,d_soldier_2} , lv= 12})                              


	local uihero1 = UITopHero.new()
	local uihero2 = UITopHero.new()

	uihero1:setData(hero1)
	uihero2:setData(d_hero1)

	table.insert(self.WidgetTable , uihero1)
	table.insert(self.WidgetTable , uihero2)
	
	local UISoldier1 = UISoldier.new()
	local UISoldier2 = UISoldier.new()

	table.insert(self.WidgetTable , UISoldier2)
	table.insert(self.WidgetTable , UISoldier1)


	UISoldier1:setVisible(false)
	UISoldier2:setVisible(false)

	uihero1:setVisible(false)
	uihero2:setVisible(false)


	self.view:addHero({uihero1 , uihero2})
	self.view:addsoldier({UISoldier2,UISoldier1})
end


function topControl:showhero()

	 self.view:showHero()
end 


function topControl:hideHero()

	 self.view:hideHero()

end 


function topControl:showsoldier()

	 self.view:showSoldier()
end 

return topControl

--endregion

--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local soldier  =require("game.UI.replay.mode.soldier")


local citywall  = class("citywall" , function () return  soldier.new() end)
 

function citywall:ctor()

	self.type = "citywall"
end 

function setDurability(durability) 
	self.durability = durability
end 

function getDurability() 
	return  self.durability 
end 

function setCityImageId(cityimageid)
	self.cityimageid = cityimageid
end 

function setCityImageId()
	return self.cityimageid
end 


return citywall
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local troop  = class("troop")
local hero  =  require("game.UI.replay.mode.hero")
local soldier  =  require("game.UI.replay.mode.soldier")


function troop:ctor()
	self.type = "troop"
end 

function troop:init(data)

	dump(troop,"troop")

	self.soldier = data.soldier
	
	self.hero= data.hero

	self.id = data.id 
end 


function troop:setsoldier(soldier)

	self.soldier = soldier
end 

function troop:getsoldier()

	return self.soldier 
end 

function troop:setId(id)
	self.id = id 
end 

function troop:getId()

	return self.id 
end 

function troop:getHero()

	return self.hero 
end 

function troop:setLoradName(lorad_name)

	self.lorad_name =  lorad_name 
end

function troop:getLoradName()

	return self.lorad_name 
end
 
return troop
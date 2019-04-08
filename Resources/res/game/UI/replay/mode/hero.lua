--
-- Author: Your Name
-- Date: 2017-06-19 15:16:39
--
 
local hero  = class("hero")

function hero:ctor()

	self.type = "hero"
end 

function hero:init(data)
	
	dump(data,"hero")
	self.name  = data.name
	self.hero = data.troop
	self.lv = data.lv
	self.icon = data.icon
	self.id = data.id 
end 

function hero:setName(name)

	self.name =  name 
end

function hero:setLv(lv)

	self.lv = lv 
end 

function hero:setId(id)
	self.id = id 
end 

function hero:getId()
	
	return self.id 
end 


function hero:setTroop(trooop)
	self.trooop =trooop
end 


function hero:getTroop()
	return self.troop
end 

function hero:setImageId(imageId)
	self.imageId = imageId 
end 

function hero:getImageId()
	
	return self.imageId 
end


function hero:setLeaderName(leader_name)
	
	 self.leader_name  = leader_name
end


function hero:setCommand(command)
	
	 self.command  = command
end

function hero:getCommand()
	
	return  self.command 
end


function hero:getLeaderName()
	
	return self.leader_name 
end


function hero:getIcon(lv)

	return 	self.icon or "icon/hero/hero_head_01.png"
end 

function hero:getLv()

	return self.lv 
end 

function hero:getName()

	return self.name 
end

function hero:setSoldier(soldier)

	self.soldier =soldier
end 


function hero:getSoldier()

	return self.soldier
end 

return hero
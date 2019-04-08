--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local war  = class("war")

function war:init(data)
	self.id = 0 
	self.attacker = data.attacker
	self.defensive = data.defensive
end

function war:ctor()
	self.type = "war"
end 

function war:setID(id)

	self.id = id 
end 

function war:getID()

	return self.id 
end 

function war:setAttacker(attacker)

	 self.attacker   = attacker
end 

function war:setDefensive(defensive)
	self.defensive = defensive
end 

function war:getAttacker()

	return self.attacker
end 


function war:getDefensive()
	
	return self.defensive
end 


return war
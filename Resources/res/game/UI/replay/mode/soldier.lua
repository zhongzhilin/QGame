--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local soldier  = class("soldier")


function soldier:ctor()
	
	self.type = "soldier"
end 

function soldier:init(data)

	dump(data,"soldier")

	self.name  = data.name

	self.lv =  data.lv 

	self.count  =  data.count  

	self.id = data.id 
end 

function soldier:setName(name)

	self.name =  name 
end

function soldier:setLv(lv)
	
	self.lv = lv 
end 

function soldier:getLv()

	return self.lv 
end 

function soldier:setImageId(imageId)
	self.imageId = imageId 
end 

function soldier:getImageId()
	
	return self.imageId 
end


function soldier:getName()

	return self.name 
end

function soldier:getIcon()

	return 	self.icon or "icon/hero/hero_head_01.png"
end 


function soldier:setCount(count)

	self.count =count
end 

function soldier:getCount()

	return self.count
end 
 
return soldier
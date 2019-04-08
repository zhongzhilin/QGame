local _M = {
--EnterWorld:id = 50010660,name = "测试1",lv=10,Kind=2,avatar = 1,state = 2


}


local names = {10569,10570,10571,10572,10573,10574,10575,10576,
				10577,10578,}

local race = {1,6,8}
local lv = {1,5,10}


-- 减少城堡数量
for i=1,3 do 

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = i+50090260,name = names[i],lv = lv[math.random(1,3)],Kind=race[math.random(1,3)],state=2}
	})	

end


-- 改成村庄
for i=4,9 do 

	table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i+50090260,id = i+50090260,file="world/director/Village"}
	})	

end






	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70100541,name = 10571,lv = 10,Kind=8}
	})	

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70100540,name = 10569,lv = 10,Kind=8}
	})	
	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70100542,name = 10574,lv = 10,Kind=8}
	})	

print("part2结束")

return _M
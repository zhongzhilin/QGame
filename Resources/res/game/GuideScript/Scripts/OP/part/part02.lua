local _M = {
--EnterWorld:id = 50010660,name = "测试1",lv=10,Kind=2,avatar = 1,state = 2


}


local names = {10569,10570,10571,10572,10573,10574,10575,10576,
				10577,10578,}

local race = {1,6,8}
local lv = {1,5,10}

for i=1,9 do 

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = i+50090260,name = names[i],lv = lv[math.random(1,3)],Kind=race[math.random(1,3)],state=2}
	})	

end


-- local names = {"玛佩尔","哈林顿","汉森","格兰特","布斯林","巴拉森","戈斯","哈珀",
-- 				"玛可欣","玛蒂娜",}

-- for i=1,9 do 

-- 	table.insert(_M,{
		
-- 		key = "AddCity",
-- 		data = {id = i+70100535,name = names[i],lv = 10,Kind=8}
-- 	})	

-- end


	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70100537,name = 10569,lv = 10,Kind=8}
	})	

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70100539,name = 10570,lv = 10,Kind=8}
	})	

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
local _M = {
--EnterWorld:id = 50010660,name = "测试1",lv=10,Kind=2,avatar = 1,state = 2


}


local names = {"玛佩尔","哈林顿","汉森","格兰特","布斯林","巴拉森","戈斯","哈珀",
				"玛可欣","玛蒂娜",}

local race = {1,6,8}
local lv = {1,5,10}

for i=1,9 do 

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = i+50030260,name = names[i],lv = lv[math.random(1,3)],Kind=race[math.random(1,3)],state=2}
	})	

end


-- local names = {"玛佩尔","哈林顿","汉森","格兰特","布斯林","巴拉森","戈斯","哈珀",
-- 				"玛可欣","玛蒂娜",}

-- for i=1,9 do 

-- 	table.insert(_M,{
		
-- 		key = "AddCity",
-- 		data = {id = i+70040535,name = names[i],lv = 10,Kind=8}
-- 	})	

-- end


	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70040537,name = "玛佩尔",lv = 10,Kind=8}
	})	

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70040539,name = "哈林顿",lv = 10,Kind=8}
	})	

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70040541,name = "汉森",lv = 10,Kind=8}
	})	

	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70040540,name = "玛佩尔",lv = 10,Kind=8}
	})	
	table.insert(_M,{
		
		key = "AddCity",
		data = {id = 70040542,name = "巴拉森",lv = 10,Kind=8}
	})	

print("part2结束")

return _M
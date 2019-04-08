local _M = {
--EnterWorld:id = 50010660,name = "测试1",lv=10,Kind=2,avatar = 1,state = 2

	{
		key = "AddModel",
	},

	{
		key = "ShowDes",
		data = {time = 1.5,title = "",des = "     西耀1359年11月……",delay=1/60}
	},



	{
		key = "EnterWorld",
		data = {id = 50030260,name = "罗波安",state = 2,lv=10,Kind=1,avatar = 0}
	},

	{
		key = "AddScreenEffect",
		data = {id=320,x=360,y = gdisplay.height*0.5,file="effect/kc_story_01"}
	},



--***创建小物
	{
		key = "AddMonster",
		data = {id=303,cityId = 50030267,kind = 5110011, x = 300,y = -100}
	},

	{
		key = "AddMonster",
		data = {id=304,cityId = 50030265,kind = 5110011, x = 80,y = 300}
	},



	{
		key = "AddMonster",
		data = {id=305,cityId = 50030267,kind = 5040013, x = -200,y = 0, isNeedAction=false}
	},

--***战斗特效
	{
		key = "AddEffect",
		data = {x=-73715,y = 1982,file="world/director/battle_node3"}
	},


	{
		key = "AddEffect",
		data = {x=-73027,y = 2453,file="world/director/battle_node3"}
	},



	{
		key = "AddEffect",
		data = {x=-74215,y = 2082,file="world/director/battle_node2"}
	},

--野地
	{
		key = "AddWild",
		data = {id=601,cityId = 70040544,kind = 10301,x=200,y=0}
	},

	{
		key = "AddWild",
		data = {id=602,cityId = 70040542,kind = 20301,x=-200,y=0}
	},
	{
		key = "AddWild",
		data = {id=603,cityId = 70040541,kind = 30301,x=250,y=250}
	},


	{
		key = "AddWild",
		data = {id=604,cityId = 70040543,kind = 40301,x=0,y=-200}
	},




	{
		key = "AddWild",
		data = {id=606,cityId = 70040540,kind = 30301,x=-300,y=-200}
	},



	{
		key = "AddWild",
		data = {id=607,cityId = 70040545,kind = 20301,x=200,y=200}
	},


	{
		key = "AddMonster",
		data = {id=313,cityId = 50030260,kind = 5120011, x = 300,y = -200}
	},

	{
		key = "AddMonster",
		data = {id=314,cityId = 50030260,kind = 5140011, x = 0,y = -400}
	},


	{
		key = "AddWild",
		data = {id=617,cityId = 60032053,kind = 40301,x=0,y=100}
	},




--玩家所在村庄

	{
		key = "AddEmpty",
		data = {ids = {60032049,60032050,60032051,60032052,60032053,60032054,
		60032057,60032058,60032059}}
	},

	{
		key = "AddEmpty",
		data = {lType=22,ids = {60032056,60032055,60032061,60032060}}
	},

		{
		key = "AddEmpty",
		data = {lType=15,ids = {70032211}}
	},

	{
		key = "AddWild",
		data = {id=810,cityId = 60032058,kind = 30101,x=180,y=-0}
	},


	{
		key = "AddWild",
		data = {id=811,cityId = 60032055,kind = 40201,x=-100,y=480}
	},




}




table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = 40030133,id = 40030133,file="world/director/Village"}

})	


-- for i=50030261,50030269 do 

-- 	table.insert(_M,{
		
-- 		key = "AddEmpty",
-- 		data = {ids = {i}}
-- 	})	

-- end



-- for i=40030131,40030140 do 

-- 	table.insert(_M,{
		
-- 		key = "AddEmpty",
-- 		data = {ids = {i}}
-- 	})	

-- end



for i=60020778,60020787 do 

	table.insert(_M,{
		
		key = "AddEmpty",
		data = {ids = {i}}
	})	


end


-- for i=40020899,40020908 do 

-- 	table.insert(_M,{
		
-- 		key = "AddEmpty",
-- 		data = {ids = {i}}
-- 	})	


-- 	table.insert(_M,{
		
-- 		key = "AddCityEffect",
-- 		data = {cityId = i,id = i,file="world/director/battle_node3"}

-- })	

-- end


for i=50021024,50021033 do 


	table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}

})	


end

--


-- for i=60040401,60040410 do 

-- 	table.insert(_M,{
		
-- 		key = "AddEmpty",
-- 		data = {ids = {i}}
-- 	})	


-- 	table.insert(_M,{
		
-- 		key = "AddCityEffect",
-- 		data = {cityId = i,id = i,file="world/director/battle_node3"}

-- })	

-- end


for i=70040536,70040545 do 

	table.insert(_M,{
		
		key = "AddEmpty",
		data = {ids = {i}}
	})	

end


-- for i=50040660,50040669 do 

-- 	table.insert(_M,{
		
-- 		key = "AddEmpty",
-- 		data = {ids = {i}}
-- 	})	

-- 	table.insert(_M,{
		
-- 		key = "AddCityEffect",
-- 		data = {cityId = i,id = i,file="world/director/battle_node3"}

-- })	


-- end


for i=60010401,60010410 do 

table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}

})	


end



return _M
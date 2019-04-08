local _M = {


	{
		key = "AddModel",
	},

	{
		key = "ShowDes",
		data = {time = 1.5,title = "",des = 10541,delay=1/60}
	},

	{
		key = "PlaySound",
		data = {key = "start_dialogue_1" }
	},

	--记录开始看开场
	{
		key = "SignGuide",
		data = {step=1},
	},

	{
		key = "Delay",
		data = {time = 1},
	},

	{
		key = "EnterWorld",
		data = {id = 50090260,name = 10568,state = 2,lv=10,Kind=1,avatar = 0}
	},



---屏蔽火焰特效
	-- {
	-- 	key = "AddScreenEffect",
	-- 	data = {id=320,x=360,y = gdisplay.height*0.5,file="effect/kc_story_01"}
	-- },

--***创建小物
	{
		key = "AddMonster",
		data = {id=303,cityId = 50090267,kind = 5110011, x = 300,y = -100}
	},

	{
		key = "AddMonster",
		data = {id=304,cityId = 50090265,kind = 5110011, x = 80,y = 300}
	},



	{
		key = "AddMonster",
		data = {id=305,cityId = 50090267,kind = 5040013, x = -200,y = 0, isNeedAction=false}
	},


--***战斗特效
	{
		key = "AddEffect",
		data = {x=-67569,y = -4163,file="world/director/battle_node3"}
	},


	{
		key = "AddEffect",
		data = {x=-66881,y = -3692,file="world/director/battle_node3"}
	},



	{
		key = "AddEffect",
		data = {x=-68069,y = -4063,file="world/director/battle_node2"}
	},


--野地
	{
		key = "AddWild",
		data = {id=601,cityId = 70100544,kind = 10301,x=200,y=0}
	},

	{
		key = "AddWild",
		data = {id=602,cityId = 70100542,kind = 20301,x=-200,y=0}
	},
	{
		key = "AddWild",
		data = {id=603,cityId = 70100541,kind = 30301,x=250,y=250}
	},


--屏蔽野地
	-- {
	-- 	key = "AddWild",
	-- 	data = {id=604,cityId = 70100543,kind = 40301,x=0,y=-200}
	-- },




	-- {
	-- 	key = "AddWild",
	-- 	data = {id=606,cityId = 70100540,kind = 30301,x=-300,y=-200}
	-- },



	-- {
	-- 	key = "AddWild",
	-- 	data = {id=607,cityId = 70100545,kind = 20301,x=200,y=200}
	-- },


	{
		key = "AddMonster",
		data = {id=313,cityId = 50090260,kind = 5120011, x = 300,y = -200}
	},

	{
		key = "AddMonster",
		data = {id=314,cityId = 50090260,kind = 5140011, x = 0,y = -400}
	},


	-- {
	-- 	key = "AddWild",
	-- 	data = {id=617,cityId = 60092053,kind = 40301,x=0,y=100}
	-- },




--玩家所在村庄

	{
		key = "AddEmpty",
		data = {ids = {60092049,60092050,60092051,60092052,60092053,60092054,
		60092057,60092058,60092059}}
	},

	{
		key = "AddEmpty",
		data = {lType=22,ids = {60092056,60092055,60092061,60092060}}
	},

		{
		key = "AddEmpty",
		data = {lType=15,ids = {70092211}}
	},

	{
		key = "AddWild",
		data = {id=810,cityId = 60092058,kind = 30101,x=180,y=-0}
	},


	-- {
	-- 	key = "AddWild",
	-- 	data = {id=811,cityId = 60092055,kind = 40201,x=-100,y=480}
	-- },




}




table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = 40090133,id = 40090133,file="world/director/Village"}

})	



for i=60080778,60080787 do 

	table.insert(_M,{
		
		key = "AddEmpty",
		data = {ids = {i}}
	})	


end


for i=50081024,50081033 do 


	table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}

})	


end



--有三个

for i=70100536,70100539 do 

	table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}
	})	

end





for i=70100540,70100542 do 

	table.insert(_M,{
		
		key = "AddEmpty",
		data = {ids = {i}}
	})	
	

end



for i=70100543,70100545 do 

	table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}
	})	

end







for i=60010401,60010410 do 

table.insert(_M,{
		
		key = "AddCityEffect",
		data = {cityId = i,id = i,file="world/director/Village"}

})	


end



return _M
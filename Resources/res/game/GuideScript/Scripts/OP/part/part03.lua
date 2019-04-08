local _M = {

	{
		key = "PlaySound",
		data = {key = "Start_battle" }
	},	

--***加载
	{
		key = "Delay",
		data = {time = 1 }
	},


	{
		key = "AddMonster",
		data = {id=301,cityId = 50090264,kind = 5020013, x = -50,y = 200}
	},



	{
		key = "Delay",
		data = {time = 0.1 }
	},

	{
		key = "CheckFPS",
	},


	{
		key = "Delay",
		data = {time = 3 }
	},

	-- 检测帧率/记录关键步（开场5秒）
	{
		key = "SignTag",
		data = {step=1},
	},


	


--***创建怪物

	{
		key = "AddMonster",
		data = {id=302,cityId = 50090266,kind = 5060013, x = 0,y = 250}
	},



--***创建剧情城堡
	{
		key = "AddCity",
		data = {id = 60092052,name = 10579,lv=10,Kind=6,avatar = 1}
	},

	{
		key = "AddCity",
		data = {id = 60092059,name = 10580,state = 2,lv=5,Kind=6,avatar = 2}
	},

	{
		key = "AddCity",
		data = {id = 60092049,name = 10581,state = 2,lv=5,Kind=8,avatar = 2}
	},

	{
		key = "AddCity",
		data = {id = 60092051,name = 10582,state = 2,lv=5,Kind=1,avatar = 2}
	},


	{
		key = "AddCity",
		data = {id = 60092062,name = 10583,state = 2,lv=5,Kind=1,avatar = 2}
	},




	{
		key = "Delay",
		data = {time = 1}
	},

	--检测帧率/记录关键步（第一句话出来）
	{
		key = "SignTag",
		data = {step=2,isWait=true},
	},



--剧情对话


	{
		key = "GpsLine",	-- X-200
		data = {x= -66433,y=-3197,time = 5,delay=0}	
	},





	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "PlaySound",
		data = {key = "world_wild_3207" }
	},

	{
		key = "Delay",
		data = {time = 1.7}
	},

	{
		key = "PlaySound",
		data = {key = "world_wild_3203" }
	},

	{
		key = "Delay",
		data = {time = 3.1}
	},


--***添加剧情对话
	{
		key = "AddScreenEffect",
		data = {id=311,file="world/director/prelude",animation="animation0",isLoop=true}
	},

	{
		key = "Delay",
		data = {time = 8 / 60 }
	},
	{
		key = "UpdateEffect",
		data = {id=311,animation="animation1",isLoop=true}
	},



	{
		key = "Delay",
		data = {time = 0.5}
	},

	{
		key = "ShowNpc",
		data = {side = 1,desId = 1,npc = "npc1"}
	},

	{
		key = "ShowNpc",
		data = {side = 0,desId = 2,npc = "npc2",keepSound=true}
	},



--***骑兵求援

	{
		key = "AddTroop",
		data = {
			time = 5,
			id=1008,
			heroId=8105,
			name=10595,
			path = {
            	[1] = 60092052,
            	[2] = 60092053,
            	[3] = 60095022,
            	[4] = 60100410,
            	[5] = 60100408,
        	}
        }
	},


	{
		key = "UpdateEffect",
		data = {id=311,animation="animation2",isLoop=false}--关闭特效
	},



}

--print("part3结束")

return _M
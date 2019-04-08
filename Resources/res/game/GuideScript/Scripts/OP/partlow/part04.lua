local _M = {

--***等待
	{
		key = "Delay",
		data = {time = 0.5}
	},


	{
		key = "GpsLine",	-- Y-300
		data = {x= -66433,y=-2797,time = 1}	
	},

--***创建BOSS
	{
		key = "AddMonster",
		data = {id=401,cityId = 60092052,kind = 5080013, x = 320,y = 250}
	},
--***镜头震动
	{
		key = "StartShaky",
		data = {power=20,speed = 0.05}
	},


	{
		key = "PlaySound",
		data = {key = "world_call" }
	},




	{
		key = "Delay",
		data = {time = 1}
	},


	-- {
	-- 	key = "PlaySound",
	-- 	data = {key = "world_wild_3209" }
	-- },



	{
		key = "EndShaky",
	},


	{
		key = "Delay",
		data = {time = 2.3}
	},


	{
		key = "PlaySound",
		data = {key = "world_wild_3209" }
	},

	--检测帧率/记录关键步（第跳过引导按钮出现）
	{
		key = "SignTag",
		data = {step=3,isWait=true},
	},


--跳过引导

	{
		key = "OpenSkipGuide",
	},


--***镜头震动
	{
		key = "StartShaky",
		data = {power=50,speed = 0.02}
	},

	{
		key = "Delay",
		data = {time = 1}
	},

	{
		key = "EndShaky",
	},


	{
		key = "AddCity",
		data = {id = 60092052,name = 10579,lv=10,Kind=6,avatar = 1,state=2}
	},





--***剧情对话

--***添加剧情对话
	{
		key = "Delay",
		data = {time = 1}
	},
	{
		key = "AddScreenEffect",
		data = {id=312,file="world/director/prelude",animation="animation0",isLoop=true}
	},

	{
		key = "Delay",
		data = {time = 8 / 60 }
	},
	{
		key = "UpdateEffect",
		data = {id=312,animation="animation1",isLoop=true}
	},



	{
		key = "CloseNpcSound",
	},



	{
		key = "ShowNpc",
		data = {side = 1,desId = 3,npc = "npc4"}
	},

	{
		key = "ShowNpc",
		data = {side = 0,desId = 4,npc = "npc2",keepSound=true}
	},


	{
		key = "UpdateEffect",
		data = {id=312,animation="animation2",isLoop=false}
	},




--***切入援军
	{
		key = "GpsCity",	
		data = {id=70100540,time = 1,ease = 2}	
	},






--***援军对话框

	{
		key = "Delay",
		data = {time = 0.5}
	},


	{
		key = "AddScreenEffect",
		data = {id=313,file="world/director/prelude",animation="animation0",isLoop=true}
	},

	{
		key = "Delay",
		data = {time = 8 / 60 }
	},
	{
		key = "UpdateEffect",
		data = {id=313,animation="animation1",isLoop=true}
	},


	{
		key = "CloseNpcSound",
	},




	{
		key = "ShowNpc",
		data = {side = 1,desId = 5,npc = "npc3",keepSound=true}
	},


	{
		key = "UpdateEffect",
		data = {id=313,animation="animation2",isLoop=false}
	},



	{
		key = "GpsCity",	
		data = {id=70100542,time = 1,ease = 2}	
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=1008,
			heroId=8101,
			name=10569,
			path = {
            	[1] = 70100542,
            	[2] = 70100544,
            	[3] = 70105123,
            	[4] = 60100402,
        	}
        }
	},


	{
		key = "Delay",
		data = {time = 0.5}
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=1009,
			heroId=8102,
			name=10570,
			path = {
            	[1] = 70100540,
            	[2] = 70100545,
            	[3] = 70105024,
            	[4] = 70090134,
        	}
        }
	},

	{
		key = "GpsCity",	
		data = {id=70100541,time = 1,ease = 2}	
	},


	{
		key = "AddTroop",
		data = {
			time = 20,
			id=1010,
			heroId=8102,
			name=10571,
			path = {
			    [1] = 70100541,
            	[2] = 70100543,
            	[3] = 70100542,
            	[4] = 70100544,
            	[5] = 70105123,
            	[6] = 70100402,
        	}
        }
	},






	{
		key = "GpsLine",	-- X-1878 Y -573
		data = {x= -64555,y=-3370,time = 2}	
	},




}

return _M
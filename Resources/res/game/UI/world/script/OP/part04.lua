local _M = {

--***等待
	{
		key = "Delay",
		data = {time = 0.5}
	},

	{
		key = "GpsLine",	
		data = {x= -72578,y=3248,time = 1}	
	},

--***创建BOSS
	{
		key = "AddMonster",
		data = {id=401,cityId = 60032052,kind = 5080013, x = 320,y = 250}
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


	{
		key = "PlaySound",
		data = {key = "world_wild_3209" }
	},



	{
		key = "EndShaky",
	},


	{
		key = "Delay",
		data = {time = 2.3}
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
		data = {id = 60032052,name = "我的城堡",lv=10,Kind=6,avatar = 1,state=2}
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
		key = "ShowNpc",
		data = {side = 1,des = "哈哈哈哈，渺小的凡人们真的以为能够战胜我吗？受死吧！！！",npc = "npc4"}
	},

	{
		key = "ShowNpc",
		data = {side = 0,des = "将士们坚持住，誓死保卫我们的家园，援军马上就到！",npc = "npc2"}
	},


	{
		key = "UpdateEffect",
		data = {id=312,animation="animation2",isLoop=false}
	},




--***切入援军
	{
		key = "GpsCity",	
		data = {id=70040540,time = 1,ease = 2}	
	},

--***淡出电影模式
	-- {
	-- 	key = "Delay",
	-- 	data = {time = 0.5}
	-- },

	-- {
	-- 	key = "UpdateEffect",
	-- 	data = {id=311,animation="animation2",isLoop=false}
	-- },




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

--***删除场景火焰
	-- {
	-- 	key = "RemoveEffect",
	-- 	data = {id=320}
	-- },


	{
		key = "ShowNpc",
		data = {side = 1,des = "领主大人，奥特兰德王国前来支援！",npc = "npc3"}
	},


	{
		key = "UpdateEffect",
		data = {id=313,animation="animation2",isLoop=false}
	},



	{
		key = "GpsCity",	
		data = {id=70040542,time = 1,ease = 2}	
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=1002,
			heroId=8101,
			name="玛佩尔",
			path = {
            	[1] = 70040542,
            	[2] = 70040544,
            	[3] = 70045123,
            	[4] = 60040402,
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
			id=1003,
			heroId=8102,
			name="哈林顿",
			path = {
            	[1] = 70040540,
            	[2] = 70040545,
            	[3] = 70045024,
            	[4] = 70030134,
        	}
        }
	},

	{
		key = "GpsCity",	
		data = {id=70040541,time = 1,ease = 2}	
	},


	{
		key = "AddTroop",
		data = {
			time = 20,
			id=1004,
			heroId=8102,
			name="汉森",
			path = {
			    [1] = 70040541,
            	[2] = 70040543,
            	[3] = 70040542,
            	[4] = 70040544,
            	[5] = 70045123,
            	[6] = 70040402,
        	}
        }
	},



-- --****测试等待
-- 	{
-- 		key = "Delay",
-- 		data = {time = 5000}
-- 	},



--****测试等待
	-- {
	-- 	key = "Delay",
	-- 	data = {time = 5000}
	-- },


	{
		key = "GpsLine",	
		data = {x= -70700,y=2675,time = 2}	
	},


	-- {
	-- 	key = "Delay",
	-- 	data = {time = 1}
	-- },


--****测试等待
	-- {
	-- 	key = "Delay",
	-- 	data = {time = 5000}
	-- -- },
	-- }

}

return _M
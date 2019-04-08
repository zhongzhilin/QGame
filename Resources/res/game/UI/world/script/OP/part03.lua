local _M = {







--***加载
	{
		key = "Delay",
		data = {time = 1 }
	},


	{
		key = "AddMonster",
		data = {id=301,cityId = 50030264,kind = 5020013, x = -50,y = 200}
	},






	{
		key = "Delay",
		data = {time = 3 }
	},

--测试音效



	{
		key = "PlaySound",
		data = {key = "world_wild_3205" }
	},


--***创建怪物
	-- {
	-- 	key = "AddMonster",
	-- 	data = {id=301,cityId = 20030264,kind = 5020013, x = -50,y = 200}
	-- },

	{
		key = "AddMonster",
		data = {id=302,cityId = 50030266,kind = 5060013, x = 0,y = 250}
	},

-- --***创建小物
-- 	{
-- 		key = "AddMonster",
-- 		data = {id=303,cityId = 50030267,kind = 5110011, x = 300,y = -100}
-- 	},

-- 	{
-- 		key = "AddMonster",
-- 		data = {id=304,cityId = 50030265,kind = 5110011, x = 80,y = 300}
-- 	},

-- 	{
-- 		key = "AddMonster",
-- 		data = {id=305,cityId = 50030267,kind = 5040013, x = -200,y = 0, isNeedAction=false}
-- 	},

-- --***战斗特效
-- 	{
-- 		key = "AddEffect",
-- 		data = {x=-73715,y = 1982,file="world/director/battle_node3"}
-- 	},


-- 	{
-- 		key = "AddEffect",
-- 		data = {x=-73027,y = 2453,file="world/director/battle_node3"}
-- 	},



-- 	{
-- 		key = "AddEffect",
-- 		data = {x=-74215,y = 2082,file="world/director/battle_node2"}
-- 	},





	-- {
	-- 	key = "SignGuide",
	-- },




--***创建剧情城堡
	{
		key = "AddCity",
		data = {id = 60032052,name = "我的城堡",lv=10,Kind=6,avatar = 1}
	},

	{
		key = "AddCity",
		data = {id = 60032059,name = "茉伊拉",state = 2,lv=5,Kind=6,avatar = 2}
	},

	{
		key = "AddCity",
		data = {id = 60032049,name = "玛可欣",state = 2,lv=5,Kind=8,avatar = 2}
	},

	{
		key = "AddCity",
		data = {id = 60032051,name = "雷思丽",state = 2,lv=5,Kind=1,avatar = 2}
	},


	{
		key = "AddCity",
		data = {id = 60032062,name = "格兰汉",state = 2,lv=5,Kind=1,avatar = 2}
	},

	-- {
	-- 	key = "AddCity",
	-- 	data = {id = 60032053,name = "格兰汉",state = 2,lv=5,Kind=1,avatar = 2}
	-- },


--****测试

	-- {
	-- 	key = "GpsCity",	
	-- 	data = {id=60030004,time = 0.5,ease = 2}	
	-- },



--***添加特效，移动镜头

	-- {
	-- 	key = "AddScreenEffect",
	-- 	data = {id=320,x=360,y = gdisplay.height*0.5,file="effect/kc_story_01"}
	-- },

	{
		key = "Delay",
		data = {time = 1}
	},




--剧情对话

	-- {
	-- 	key = "AddScreenEffect",
	-- 	data = {id=3214,file="world/director/prelude",animation="animation0",isLoop=true}
	-- },

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 8 / 60 }
	-- },
	-- {
	-- 	key = "UpdateEffect",
	-- 	data = {id=3214,animation="animation1",isLoop=true}
	-- },

	-- {
	-- 	key = "ShowNpc",
	-- 	data = {side = 1,des = "领主大人,大事不好了！",npc = "npc1"}
	-- },

	-- {
	-- 	key = "UpdateEffect",
	-- 	data = {id=3214,animation="animation2",isLoop=false}--关闭特效
	-- },


	{
		key = "GpsLine",	
		data = {x= -72578,y=2948,time = 5,delay=0}	
	},



	-- {
	-- 	key = "Delay",
	-- 	data = {time = 0.5}
	-- },

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

	-- {
	-- 	key = "RemoveEffect",
	-- 	data = {id=311}
	-- },

	-- {
	-- 	key = "AddScreenEffect",
	-- 	data = {id=312,file="world/director/prelude",animation="animation1"}
	-- },


	{
		key = "Delay",
		data = {time = 0.5}
	},

	{
		key = "ShowNpc",
		data = {side = 1,des = "报！领主大人，塔兰帝国勾结黑暗势力偷袭我国，恶魔的力量。。啊。。啊！",npc = "npc1"}
	},
	-- {
	-- 	key = "Delay",
	-- 	data = {time = 0.1}
	-- },


	{
		key = "ShowNpc",
		data = {side = 0,des = "立刻派遣信使前往盟国请求支援！！",npc = "npc2"}
	},



--***骑兵求援

	{
		key = "AddTroop",
		data = {
			time = 5,
			id=1002,
			heroId=8105,
			name="求援部队",
			path = {
            	[1] = 60032052,
            	[2] = 60032053,
            	[3] = 60035022,
            	[4] = 60040410,
            	[5] = 60040408,
        	}
        }
	},

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 0.5}
	-- },
	{
		key = "UpdateEffect",
		data = {id=311,animation="animation2",isLoop=false}--关闭特效
	},


-- --***添加特效

-- 	{
-- 		key = "AddEffect",
-- 		data = {x=-74778,y = -1181,file="world/director/yun"}
-- 	},

-- 	{
-- 		key = "Delay",
-- 		data = {time = 1}
-- 	},
-- --***镜头拉高，并且移动
-- 	{
-- 		key = "ScaleTo",
-- 		data = {scale = 0.75,time=0.1}
-- 	},	







}

print("part3结束")

return _M
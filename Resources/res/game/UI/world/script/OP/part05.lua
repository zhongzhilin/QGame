local _M = {
	-- {
	-- 	key = "GpsCity",	
	-- 	data = {id=60020781,time = 0.5,ease = 2}	
	-- },

	{
		key = "GpsLine",	
		data = {x= -73464,y=3850,time = 2,ease =2}	
	},

	{
		key = "AddCity",
		data = {id = 60020781,name = "亚特斯国王",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},


	{
		key = "Delay",
		data = {time = 2}
	},



	{
		key = "AddScreenEffect",
		data = {id=314,file="world/director/prelude",animation="animation0",isLoop=true}
	},

	{
		key = "Delay",
		data = {time = 8 / 60 }
	},
	{
		key = "UpdateEffect",
		data = {id=314,animation="animation1",isLoop=true}
	},


	{
		key = "ShowNpc",
		data = {side = 1,des = "领主大人，亚特斯王国前来支援！",npc = "npc1"}
	},



	{
		key = "AddCity",
		data = {id = 60020778,name = "亚特斯武士",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60020779,name = "亚特斯勇士",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


		{
		key = "UpdateEffect",
		data = {id=314,animation="animation2",isLoop=false}
	},

-- --***添加特效

	{
		key = "AddEffect",
		data = {x=-73664,y = 3250,file="world/director/yun"}
	},


-- --***镜头拉高，并且移动
	{
		key = "ScaleTo",
		data = {scale = 0.75,time=0.1}
	},	


	{
		key = "AddCity",
		data = {id = 60020780,name = "亚特斯剑圣",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60020782,name = "亚特斯先知",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


	{
		key = "AddCity",
		data = {id = 60020783,name = "亚特斯大使",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60020784,name = "亚特斯伯爵",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "GpsLine",	
		data = {x= -74064,y=3850,time = 2,delay=0}	
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


	{
		key = "AddCity",
		data = {id = 60020785,name = "亚特斯教主",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60020786,name = "亚特斯统领",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60020787,name = "亚特斯爵士",lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},



	{
		key = "Delay",
		data = {time = 2}
	},

	{
		key = "AddScreenEffect",
		data = {id=316,file="world/director/prelude",animation="animation0",isLoop=true}
	},

	{
		key = "Delay",
		data = {time = 8 / 60 }
	},
	{
		key = "UpdateEffect",
		data = {id=316,animation="animation1",isLoop=true}
	},



	{
		key = "ShowNpc",
		data = {side = 0,des = "感谢两国的及时支援，将士们一举消灭黑暗势力，全军突击！",npc = "npc2"}
	},



	{
		key = "UpdateEffect",
		data = {id=316,animation="animation2",isLoop=false}
	},


	{
		key = "GpsLine",	
		data = {x= -73064,y=3850,time = 7,delay=0}	
	},

--***开始创建各种部队

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5001,
			heroId=8201,
			name="援军部队",
			path = {
			    [1] = 60020786,
            	[2] = 60020778,
            	[3] = 60020780,
            	[4] = 60025011,
            	[5] = 60032057,  
            	[6] = 60032059,   
            	[7] = 60032062,        	
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
			id=5002,
			heroId=8202,
			name="援军部队",
			path = {
			    [1] = 60020787,
            	[2] = 60020785,
            	[3] = 60020781,
            	[4] = 60020782,
             	[5] = 60025012,
             	[6] = 60032058,    
             	[7] = 60032057,    
             	[8] = 60032062,        	
 			}
        }
	},

		{
		key = "Delay",
		data = {time = 0.4}
	},

	{
		key = "AddTroop",
		data = {
			time = 15,
			id=5003,
			heroId=8202,
			name="援军部队",
			path = {
			    [1] = 60020784,
            	[2] = 60020785,
            	[3] = 60020781,
            	[4] = 60020782,
             	[5] = 60025012,
             	[6] = 60032058,    
             	[7] = 60032057,    
             	[8] = 60032062,        	
 			}
        }
	},




	{
		key = "Delay",
		data = {time = 0.3}
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5004,
			heroId=8203,
			name="援军部队",
			path = {
			    [1] = 60020779,
             	[2] = 60025125,
             	[3] = 70020907,
             	[4] = 70020905,
       			[5] = 70020906,
 			}
        }
	},

	{
		key = "Delay",
		data = {time = 0.3}
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5005,
			heroId=8204,
			name="援军部队",
			path = {
			    [1] = 60020783,
             	[2] = 60025013,
             	[3] = 60030002,  
             	[4] = 60030007,            	
 			}
        }
	},


	{
		key = "Delay",
		data = {time = 0.4}
	},

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5006,
			heroId=8205,
			name="援军部队",
			path = {
             	[1] = 60020785,
             	[2] = 60020781,
             	[3] = 60020782,  
             	[4] = 60025012,
             	[5] = 60032058,    
             	[6] = 60032057,    
             	[7] = 60032062, 
       	    }
  	    }
	},

	{
		key = "Delay",
		data = {time = 0.4}
	},


	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5007,
			heroId=8206,
			name="援军部队",
			path = {
             	[1] = 60020781,
             	[2] = 60020782,  
             	[3] = 60025012,
             	[4] = 60032058,    
             	[5] = 60032057,    
             	[6] = 60032062, 
       	    }
  	    }
	},

	{
		key = "Delay",
		data = {time = 0.3}
	},

	{
		key = "AddTroop",
		data = {
			time = 15,
			id=5008,
			heroId=8207,
			name="援军部队",
			path = {
            	[1] = 60020782,
             	[2] = 60025012,
             	[3] = 60032058,    
             	[4] = 60032057,    
             	[5] = 60032062,        	
 			}
        }
	},





	{
		key = "Delay",
		data = {time = 2}
	},

--结束剧情
	{
		key = "SignGuide",
	},


	{
		key = "ShowDes",
		data = {time = 3,isFadeIn=true,   title="《序章·重建帝国》",des = "历经三天三夜，终于击退了黑暗势力，但王国也受到了近乎毁灭的重创，一段重建帝国的序章拉开序幕……"}
	},

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 3}
	-- },	

--结局保存，发布时必须打开
	{
		key = "GotoMainScene",
	},


}
return _M
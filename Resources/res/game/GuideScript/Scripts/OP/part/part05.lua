local _M = {
	-- {
	-- 	key = "GpsCity",	
	-- 	data = {id=60080781,time = 0.5,ease = 2}	X+200
	-- },

	{
		key = "GpsLine",	
		data = {x= -67319,y=-2295,time = 2,ease =2}	
	},

	{
		key = "AddCity",
		data = {id = 60080781,name = 10584,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},


	{
		key = "PlaySound",
		data = {key = "world_movecity" }
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
		key = "CloseNpcSound",
	},



	{
		key = "ShowNpc",
		data = {side = 1,desId = 6,npc = "npc1",keepSound=true}
	},



	{
		key = "AddCity",
		data = {id = 60080778,name = 10585,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	--------------------------------------------
	{
		key = "PlaySound",
		data = {key = "Start_movecity" }
	},
----------------------------------------------

	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60080779,name = 10586,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


		{
		key = "UpdateEffect",
		data = {id=314,animation="animation2",isLoop=false}
	},

-- --***添加特效 -800

	{
		key = "AddEffect",
		data = {x=-67948,y = -3210,file="world/director/yun"}
	},

--------------------------------------------
	{
		key = "PlaySound",
		data = {key = "Start_movecity" }
	},
----------------------------------------------

-- --***镜头拉高，并且移动
	{
		key = "ScaleTo",
		data = {scale = 0.75,time=0.1}
	},	


	{
		key = "AddCity",
		data = {id = 60080780,name = 10587,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60080782,name = 10588,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


	{
		key = "AddCity",
		data = {id = 60080783,name = 10589,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

--------------------------------------------
	{
		key = "PlaySound",
		data = {key = "Start_movecity" }
	},
----------------------------------------------
	--检测帧率/记录关键步（迁城援军出现）
	{
		key = "SignTag",
		data = {step=4,isWait=true},
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60080784,name = 10590,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "GpsLine",	
		data = {x= -67919,y=-2295,time = 2,delay=0}	
	},

	{
		key = "Delay",
		data = {time = 0.2}
	},


	{
		key = "AddCity",
		data = {id = 60080785,name = 10591,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},
	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60080786,name = 10592,lv=10,Kind=6,avatar = 2,isNeedAction=true}
	},

--------------------------------------------
	{
		key = "PlaySound",
		data = {key = "Start_movecity" }
	},
----------------------------------------------



	{
		key = "Delay",
		data = {time = 0.2}
	},

	{
		key = "AddCity",
		data = {id = 60080787,name = 10593,lv=10,Kind=6,avatar = 2,isNeedAction=true}
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
		key = "CloseNpcSound",
	},




	{
		key = "ShowNpc",
		data = {side = 0,desId = 7,npc = "npc2",keepSound=true}
	},



	{
		key = "UpdateEffect",
		data = {id=316,animation="animation2",isLoop=false}
	},


	{
		key = "GpsLine",	
		data = {x= -66919,y=-2295,time = 7,delay=0}	
	},

--***开始创建各种部队

	{
		key = "AddTroop",
		data = {
			time = 20,
			id=5001,
			heroId=8201,
			name=10594,
			path = {
			    [1] = 60080786,
            	[2] = 60080778,
            	[3] = 60080780,
            	[4] = 60085011,
            	[5] = 60092057,  
            	[6] = 60092059,   
            	[7] = 60092062,        	
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
			id=5008,
			heroId=8202,
			name=10594,
			path = {
			    [1] = 60080787,
            	[2] = 60080785,
            	[3] = 60080781,
            	[4] = 60080782,
             	[5] = 60085012,
             	[6] = 60092058,    
             	[7] = 60092057,    
             	[8] = 60092062,        	
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
			id=5009,
			heroId=8202,
			name=10594,
			path = {
			    [1] = 60080784,
            	[2] = 60080785,
            	[3] = 60080781,
            	[4] = 60080782,
             	[5] = 60085012,
             	[6] = 60092058,    
             	[7] = 60092057,    
             	[8] = 60092062,        	
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
			id=5010,
			heroId=8203,
			name=10594,
			path = {
			    [1] = 60080779,
             	[2] = 60085125,
             	[3] = 70080907,
             	[4] = 70080905,
       			[5] = 70080906,
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
			name=10594,
			path = {
			    [1] = 60080783,
             	[2] = 60085013,
             	[3] = 60092050,  
             	-- [4] = 60090407,         -----段路   	
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
			name=10594,
			path = {
             	[1] = 60080785,
             	[2] = 60080781,
             	[3] = 60080782,  
             	[4] = 60085012,
             	[5] = 60092058,    
             	[6] = 60092057,    
             	[7] = 60092062, 
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
			name=10594,
			path = {
             	[1] = 60080781,
             	[2] = 60080782,  
             	[3] = 60085012,
             	[4] = 60092058,    
             	[5] = 60092057,    
             	[6] = 60092062, 
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
			name=10594,
			path = {
            	[1] = 60080782,
             	[2] = 60085012,
             	[3] = 60092058,    
             	[4] = 60092057,    
             	[5] = 60092062,        	
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
		key = "CloseNpcSound",
	},



	{
		key = "ShowDes",
		data = {time = 13,isFadeIn=true,  title=10542,des = 10859,delay=1/60}
	},

	{
		key = "Delay",
		data = {time = 1}
	},

	{
		key = "PlaySound",
		data = {key = "start_dialogue_9" }
	},

	{
		key = "Delay",
		data = {time = 3}
	},

	-- {
	-- 	key = "PlaySound",
	-- 	data = {key = "start_dialogue_10" }
	-- },

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 3}
	-- },


	{
		key = "Delay",
		data = {time = 5}
	},	

--结局保存，发布时必须打开
	{
		key = "GotoMainScene",
	},


}
return _M
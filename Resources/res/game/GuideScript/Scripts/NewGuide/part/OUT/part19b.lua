
local _M = {



{
	key = "GpsCity",
	data = {isFast = true,idFunc = function()
		return global.guideMgr:getStepArg()
	end}
},

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_WORLD_SCENE},
},


{
	key = "AddModel",
},

---等待大地图全部显示出来
{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE},
},

	--检测帧率/记录关键步（第二次成功进入大地图）
	{
		key = "SignTag",
		data = {step=14},
	},



{
	key = "Delay",
	data = {time = 2}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 102,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()		
		return "worldcity" .. global.guideMgr:getStepArg()
	end
		,isShowLight = true,scaleY = 1}
},

{
	key = "Delay",
	data = {time = 1}
},



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "world_btn_14",isCircle=true,len=125,isShowLight = true}
},


{
		key = "SignGuide",
},


}

return _M
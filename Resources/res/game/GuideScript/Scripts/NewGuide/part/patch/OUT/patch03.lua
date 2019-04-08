
local _M = {

{
	key = "AddModel",
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 34,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_world"}
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
		key = "SignGuide",
},



}

return _M
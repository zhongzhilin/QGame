local BaseBuildScript3 = require("game.GuideScript.Scripts.util.BaseBuildScript3")

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





{
	key = "Delay",
	data = {time = 2}
},



{
		key = "SignGuide",
		data = {step=1601},
},




{
	key = "InsertStory",
	data = {data = BaseBuildScript3.setData()},
	target = {137}
},






-----------------------------------


{
	key = "ShowNpc",
	data = {side = 0,desId = 33,isSkipAction=true,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn_world"}
},

	--检测帧率/记录关键步（第三次点击进内城按钮）
	{
		key = "SignTag",
		data = {step=15},
	},



{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
},




}

return _M
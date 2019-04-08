local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")


local _M = {

{
	key = "AddModel",
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 10,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_task"}
},

	--检测帧率/记录关键步（点击任务按钮完成，等待领奖）
	{
		key = "SignTag",
		data = {step=6},
	},


{
	key = "Delay",
	data = {time = 0.2}
},




{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export",waitForNet =true}
},




{
		key = "SignGuide",
},



}

return _M
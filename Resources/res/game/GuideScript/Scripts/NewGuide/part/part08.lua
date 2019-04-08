local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")


local _M = {

{
	key = "AddModel",
},



{
	key = "Delay",
	data = {time = 1}
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_task"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},


{
	key = "Delay",
	data = {time = 0.2}
},



{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "task_btn1",waitForNet =true}
},


{
		key = "SignGuide",
},


{
	key = "RemoveModel",
},





}

return _M
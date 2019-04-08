local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")
local BaseBuildScript2 = require("game.GuideScript.Scripts.util.BaseBuildScript2")

local _M = {


{
	key = "Delay",
	data = {time = 1}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 11,npc = "npc6"}
},

	--检测帧率/记录关键步（准备点击任务面板建造兵营）
	{
		key = "SignTag",
		data = {step=7},
	},



{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export"}
},



{
	key = "InsertStory",
	data = {data = BaseBuildScript2.setData(2)}
},


{
	key = "RemoveModel",
},


}

return _M
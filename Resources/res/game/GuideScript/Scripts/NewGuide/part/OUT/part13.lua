local BaseBuildScript2 = require("game.GuideScript.Scripts.util.BaseBuildScript2")
local _M = {


{
	key = "AddModel",
},

{
		key = "SignGuide",
		data = {step=13002},
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 24,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",buttonName = "task_node",widgetName = "guide_task",isShowLight = true}
},



{
	key = "InsertStory",
	data = {data = BaseBuildScript2.setData(4)}
},



{
	key = "RemoveModel",
},


}

return _M
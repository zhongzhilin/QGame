local BaseBuildScript3 = require("game.GuideScript.Scripts.util.BaseBuildScript3")


local _M = {

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
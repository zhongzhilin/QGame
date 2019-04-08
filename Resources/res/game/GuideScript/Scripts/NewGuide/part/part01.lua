local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")



local _M = {

	{
		key = "AddModel",
	},

	--检测帧率/记录关键步（首次进入内城）
	{
		key = "SignTag",
		data = {step=5,isWait=true},
	},


{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 109,npc = "npc2"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=6,isWait=true},
	},

{
	key = "ShowNpc",
	data = {side = 0,desId = 110,npc = "npc6"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=7,isWait=false},
	},

{
	key = "ShowNpc",
	data = {side = 0,desId = 111,isSkipAction=true,npc = "npc6"}
},


{
	key = "SignGuide",
},

{
	key = "RemoveModel",
},

}

return _M
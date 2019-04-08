local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")
local BaseBuildScript2 = require("game.GuideScript.Scripts.util.BaseBuildScript2")

local _M = {


{
	key = "Delay",
	data = {time = 1}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 112,npc = "npc6"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},


-- {
-- 	key = "Guide",
-- 	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export"}
-- },



{
	key = "InsertStory",
	data = {data = BaseBuildScript.setData(2)}
},


{
	key = "RemoveModel",
},


}

return _M
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
	data = {panelName = "UICityPanel",widgetName = "guide_task",waitForNet =true}
},

	--检测帧率/记录关键步（点击任务按钮完成，等待领奖）
	-- {
	-- 	key = "SignTag",
	-- 	data = {step=6},
	-- },

{
		key = "SignGuide",
},


{
	key = "Delay",
	data = {time = 0.5}
},



-- {
-- 	key = "Guide",
-- 	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export",waitForNet =true}
-- },






}

return _M
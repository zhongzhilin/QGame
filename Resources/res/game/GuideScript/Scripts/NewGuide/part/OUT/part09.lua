local BaseBuildScript4 = require("game.GuideScript.Scripts.util.BaseBuildScript4")

local _M = {

{
	key = "AddModel",
},

	--检测帧率/记录关键步（第二次成功进入内城）
	{
		key = "SignTag",
		data = {step=13},
	},

{
	key = "Delay",
	data = {time = 1}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 21,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UICityPanel",buttonName = "task_node",widgetName = "guide_task",isShowLight = true}
},

-----定位任务

{
	key = "InsertStory",
	data = {data = BaseBuildScript4.setData(0)}
},
----



	{
		key = "Delay",
		data = {time = 0.1}
	},

	{
		key = "Delay",
		data = {time = WDEFINE.SCROLL_SLOW_DT}
	},
	{
		key = "Delay",
		data = {time = 0.1}
	},

{
	key = "Guide",
	data = {panelName = "UpgradePanel",widgetName = "btn_upgrade_export",waitForNet =true}
},



{
		key = "SignGuide",
},

{
	key = "Delay",
	data = {time = 1}
},

------------------处理城堡升弹窗


{
	key = "Guide",
	data = {panelName = "UIUnLockFunPanel",widgetName = "close_noe_export",isShowHand=false,isShowLight = false}
},

{
	key = "Delay",
	data = {time = 1}
},
------------------处理城堡升弹窗




{
	key = "RemoveModel",
},


}

return _M
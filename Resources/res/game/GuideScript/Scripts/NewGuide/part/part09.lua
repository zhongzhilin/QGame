local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")


local _M = {

{
	key = "AddModel",
},



{
	key = "Delay",
	data = {time = 1.5}
},



{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=11,isWait=true},
	},



		{
			key = "Delay",
			data = {time = 0.2}
		},

		{
			key = "Guide",
			data = {panelName = "UICityPanel",tableViewName = "buildlistTableview",dataCatch = {id = 3}}
		},


		{
			key = "Delay",
			data = {time = 1/60}
		},

		{
			key = "Delay",
			data = {time = WDEFINE.SCROLL_SLOW_DT}
		},


	{
		key = "SignTag",
		data = {step=12,isWait=true},
	},


		{
			key = "Guide",
			data = {panelName = "BuildPanel",widgetName = "btn_upgrade_export",waitForNet =true}
		},
		
{
	key = "SignGuide",
},

		{
			key = "Delay",
			data = {time = 0.5}
		},


{
	key = "RemoveModel",
},




}

return _M
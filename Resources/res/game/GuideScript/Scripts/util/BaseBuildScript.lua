local _M = {}

function _M.setData(id)

	local data = {		

		{
			key = "Guide",
			data = {panelName = "UICityPanel",widgetName = "btn_build_export"}
		},

		{
			key = "Delay",
			data = {time = 0.2}
		},

			--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=11,isWait=true},
	},

		{
			key = "Guide",
			data = {panelName = "UICityPanel",tableViewName = "buildlistTableview",dataCatch = {id = id}}
		},

		{
			key = "Delay",
			data = {time = 1/60}
		},

		{
			key = "Delay",
			data = {time = WDEFINE.SCROLL_SLOW_DT}
		},


			--【后台每一步统计】
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
			data = {time = 1}
		},
	}	

	return data
end

return _M
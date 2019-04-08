local _M = {}

function _M.setData(id)

	local data = {		

		{
			key = "Delay",
			data = {time = 0.25}
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
		{
			key = "Delay",
			data = {time = 1/60}
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
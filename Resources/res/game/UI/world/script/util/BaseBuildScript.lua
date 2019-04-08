local _M = {}

function _M.setData(id)

	local data = {		

		{
			key = "Guide",
			data = {panelName = "UICityPanel",widgetName = "btn_build_export"}
		},

		{
			key = "Delay",
			data = {time = 0.5}
		},

		{
			key = "Guide",
			data = {panelName = "UICityPanel",tableViewName = "buildlistTableview",dataCatch = {id = id}}
		},

		{
			key = "Delay",
			data = {time = 0.3}
		},

		{
			key = "Guide",
			data = {panelName = "BuildPanel",widgetName = "btn_upgrade_export"}
		},

		{
			key = "Delay",
			data = {time = 1}
		},
	}	

	return data
end

return _M
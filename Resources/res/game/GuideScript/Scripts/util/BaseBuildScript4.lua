local _M = {}

function _M.setData(id)

	local data = {		


					{
							key = "GpsBuild",
							data = {idFunc = function( ... )
								return global.guideMgr:getStepArg()
							end}
					},

					{
						key = "Delay",
						data = {time = 0.1}
					},


					{
						key = "OpenBuildPanel",
						data = {
							idFunc = function()
								return global.guideMgr:getStepArg()
							end
						}
					},


					{
						key = "Delay",
						data = {time = 0.5}
					},

					{
						key = "Guide",


						data = {panelName = "UICityPanel",widgetName = "build_btn_2",isCircle=true,len=113,isShowLight = true}
					},






	}	

	return data
end

return _M
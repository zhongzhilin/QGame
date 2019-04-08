local _M = {


{
	key = "AddModel",
},

{

	key = "CloseAllPanel",
},


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
	data = {panelName = "UICityPanel",
	widgetName = "build_btn_2",isCircle=true,len=120,isShowLight = true,dtX = -4}
},


---

{
	key = "RemoveModel",
},


}

return _M
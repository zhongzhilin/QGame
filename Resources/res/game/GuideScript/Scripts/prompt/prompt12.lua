local _M = {


{
	key = "AddModel",
},

{

	key = "CloseAllPanel",
},



-----大地图特殊设定

{
	key = "GotoMainScene",
	target = {107}
},

{
	key = "wait",
	target = {107}
},

{
	key = "AddModel",
},

-----大地图特殊设定

{
	key = "Delay",
	data = {time = 0.5}
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
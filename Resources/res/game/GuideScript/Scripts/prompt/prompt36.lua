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
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",
	widgetName = "PET_GUID_POS" , isCircle=false, len=120,isShowLight = false, dtX = -4  , dtY = 100}
},


{
	key = "RemoveModel",
},


}

return _M
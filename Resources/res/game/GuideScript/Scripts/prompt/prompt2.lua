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
	data = {panelName = "UICityPanel",widgetNameFunc = function()
		
		local train_btn = (global.guideMgr:getStepArg() == 14) and 'build_btn_24' or 'build_btn_6'

		local cityPanel = global.panelMgr:getPanel("UICityPanel")
		local btn = ccui.Helper:seekNodeByName(cityPanel,train_btn)
		if btn then			
			return train_btn
		else
			return "build_btn_3"
		end
	end,isCircle=true,len=120,isShowLight = true,dtX = -4}
},

{
	key = "RemoveModel",
},

{
	key = "CheckTrain",	
},

}

return _M
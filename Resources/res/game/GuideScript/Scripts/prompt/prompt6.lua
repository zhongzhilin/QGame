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
	key = "Delay",
	data = {time = 0.4}
},

{
	key = "OpenBuildPanel",
	data = {
		idFunc = function()
			return global.guideMgr:getStepArg()
		end
	}
},


---

{
	key = "RemoveModel",
},


}

return _M
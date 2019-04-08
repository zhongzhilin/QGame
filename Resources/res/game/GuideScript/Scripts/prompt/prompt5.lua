local _M = {


{
	key = "AddModel",
},

{

	key = "CloseAllPanel",
},

---等待大地图全部显示出来
{
	key = "WaitForWorldLoad",
	data = {
		widgetNameFunc = function()		
			return global.guideMgr:getStepArg()
		end
	},
},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "RemoveModel",
},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()		
		return global.guideMgr:getStepArg()
	end,isShowLight = false,scaleY = 1}
},

{
	key = "CheckVillage",
	-- data = {desc = function()
	-- 	return global.guideMgr:getStepArg()
	-- end}	
}

}

return _M
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
			return global.guideMgr:getStepArg().widgetName
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
	key = "ChooseCity",
	data = {cityIdFunc = function()
		local stepD = global.guideMgr:getStepArg()
		if stepD and type(stepD) == 'table' then
			return stepD.cityId
		end
	end,cityTypeFunc = function()
		local stepD = global.guideMgr:getStepArg()
		if stepD and type(stepD) == 'table' then
			return stepD.cityType
		end
	end}
},

-- {
-- 	key = "CheckVillage",
-- 	-- data = {desc = function()
-- 	-- 	return global.guideMgr:getStepArg()
-- 	-- end}	
-- }

}

return _M
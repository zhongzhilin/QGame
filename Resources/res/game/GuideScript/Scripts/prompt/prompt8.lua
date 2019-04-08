local _M = {


{
	key = "AddModel",
},

{
	key = "GpsCity",
	data = {isFast = true,idFunc = function()
		return global.guideMgr:getStepArg().id
	end,isWildFunc = function()
		return global.guideMgr:getStepArg().isWild
	end}
 },

---等待大地图全部显示出来
{
	key = "WaitForWorldLoad",
	data = {
		widgetNameFunc = function()		
		    local names = {[0] = "worldcity",[1] = "wildres",[2] = "monsterObj"}
			local data = global.guideMgr:getStepArg()
			return names[data.isWild] .. data.id
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
	data = {panelName = "UIWorldPanel",skip = true,widgetNameFunc = function()		
		
        local names = {[0] = "worldcityName",[1] = "wildresName",[2] = "monsterObj"}
		local data = global.guideMgr:getStepArg() 
		local id = 0
		if type(data) == "table" then
			id = data.id or 0
		else
			id = data
		end
		return names[data.isWild] .. id
	end
		,isShowLight = false,scaleY = 1}
},

}

return _M
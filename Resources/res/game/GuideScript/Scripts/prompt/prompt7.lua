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

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_WORLD_SCENE},
},


{
	key = "AddModel",
},

---等待大地图全部显示出来
{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE},
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
		return names[data.isWild] .. data.id
	end
		,isShowLight = false,scaleY = 1}
},

}

return _M
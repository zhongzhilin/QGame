
local _M = {



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

	--检测帧率/记录关键步（第二次成功进入大地图）
	{
		key = "SignTag",
		data = {step=14,isWait=true},
	},



-- {
-- 	key = "Delay",
-- 	data = {time = 2}
-- },

-- {
-- 	key = 'Log',
-- 	data = {desc = function()
-- 		return 'worlcity' .. global.userData:getWorldCityID()
-- 	end}
-- },

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()		
		return "worldcity" .. global.userData:getWorldCityID()
	end
		,isShowLight = true,scaleY = 1}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=15,isWait=true},
	},

{
	key = "Delay",
	data = {time = 1}
},



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "world_btn_14",isCircle=true,len=125,isShowLight = true}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=16,isWait=true},
	},



{
		key = "SignGuide",
},

{
	key = "RemoveModel",
},

}

return _M
local _M = {




{
	key = "AddModel",
},


{
	key = "GpsCity",
	data = {isFast = true,idFunc = function()
		return global.userData:getWorldCityID()
	end},

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
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()		
		return "worldcity" .. global.userData:getWorldCityID()
	end
		,isShowLight = true,scaleY = 1}
},


{
	key = "Delay",
	data = {time = 1}
},


{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "world_btn_5",isCircle=true,len=125,isShowLight = true,waitForNet =true}
},



{
	key = "RemoveModel",
},


}

return _M
local _M = {}

function _M.setData()

	local data = {		



{
	key = "Delay",
	data = {time = 1}
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 103,npc = "npc6"}
},


{
	key = "Delay",
	data = {time = 0.5}
},




{
	key = "GpsCity",	
	data = {idFunc = function() return global.guideMgr:getStepArg() end,time = 1}	
},





{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()
		
		return "worldcity" .. global.guideMgr:getStepArg()
	end
			,isShowLight = true,scaleY = 1 }
},




{
	key = "Delay",
	data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "world_btn_11",isCircle=true,len=125,isShowLight = true,waitForNet =true}
},



{
	key = "Delay",
	data = {time = 0.75}
},



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn03",waitForNet =true}
},


-------------------------
{
	key = "Delay",
	data = {time = 0.75}
},



{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg1"}
},




-----
{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "btn_edit_export"}
},


------
------------------------------------------------------

------------------------------------------------------

{
	key = "Guide",
	data = {panelName = "UITroopDetailPanel",widgetName = "hero_panel"}
},

{
	key = "Delay",
	data = {time = 0.05}
},


{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "heorlistitem8211"}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"}
},





------------------------------------------1111--

{
	key = "ShowNpc",
	data = {side = 0,desId = 31,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UITroopDetailPanel",widgetName = "Button_confirm",waitForNet =true}
},



{
	key = "Delay",
	data = {time = 0.75}
},



{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg1"}
},




{
	key = "Delay",
	data = {time = 0.25}
},

{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "btn_Battle_export"}
},


{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN},
},



{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UIPromptPanel",widgetName = "Button_1",scaleY = -1 ,waitForNet =true}
},




{
		key = "SignGuide",
},



{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ATTACK_FINISH,maxTime = 10},
},


{
	key = "Delay",
	data = {time = 1}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 104,npc = "npc6"}
},



	}	

	return data
end

return _M
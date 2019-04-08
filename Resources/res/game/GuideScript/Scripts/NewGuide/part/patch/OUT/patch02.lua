
local _M = {


{
	key = "AddModel",
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 15,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_world"}
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
	key = "SignGuide",
	data = {step=801},
},



{
	key = "Delay",
	data = {time = 1.5}
},


{
	key = "ShowNpc",
	data = {side = 1,desId = 17,npc = "npc7"}
},


{
	key = "AddTroop",
	data = {
		time = 4,
		id=1002,
		heroId=8101,
		name=10596,
		pathFunc = function()
			
			return {
				[1] = global.g_worldview.mapInfo:getLastCityId(),
				[2] = global.userData:getWorldCityID()
			}
		end
    }
},


{
	key = "Delay",
	data = {time = 4} 
},


{
	key = "RemoveTroop",
	data = {id = 1002}
},


{
	key = "Delay",
	data = {time = 1}
},





--

{
	key = "GpsCity",	
	data = {idFunc = function() return global.guideMgr:getStepArg() end,time = 1}	
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 18,npc = "npc6"}
},




{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()
		
		return "monsterObj" .. global.guideMgr:getStepArg()
	end
			,isShowLight = true,scaleY = 1 }
},


{
	key = "Delay",
	data = {time = 0.1}
},



{
	key = "Guide",
	data = {panelName = "UIWildMonsterPanel",widgetName = "attack_export"}
},

{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 19,npc = "npc6"}
},

	--检测帧率/记录关键步（成功点击冰原狼并打开了编辑部队界面）
	{
		key = "SignTag",
		data = {step=8},
	},




{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg1"}
},

{
	key = "Delay",
	data = {time = 0.05}
},

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
	data = {panelName = "UISelectHeroPanel",widgetName = "heorlistitem8101"}
},


{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"}
},

{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "RemoveModel",
},

	--检测帧率/记录关键步（准备将兵拖满300个）
	{
		key = "SignTag",
		data = {step=9},
	},




{
	key = "GuideRect",
	data = {panelName = "UITroopDetailPanel",widgetName = "soldier_list_bg",isShowHand=false}
},


{
	key = "AddScreenEffect",
	data = {id=1999,x=360,panelName="UIGuideRectPanel",y = gdisplay.height - 768,file="world/director/guide_troop"}
},





--添加模态
{
	key = "SetPanelModel",
	data = {panelName = "UITroopDetailPanel"}
},

{
	key = "WaitSildier",
	data = {count = 300,}	
},


{
	key = "RemoveEffect",
	data = {id = 1999}
},


{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},


--新模态
{
	key = "AddModel",
},

	--检测帧率/记录关键步（成功将兵拖满300个）
	{
		key = "SignTag",
		data = {step=10},
	},



{
	key = "SetPanelModel",
	data = {panelName = "UITroopDetailPanel",isHide=true}
},



{
	key = "Guide",
	data = {panelName = "UITroopDetailPanel",widgetName = "Button_confirm",waitForNet =true}
},

{
	key = "SignGuide",
},


{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UIPromptPanel",widgetName = "Button_1",scaleY = -1 }
},


{
	key = "Delay",
	data = {time = 3}
},

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ATTACK_FINISH},
},

	--检测帧率/记录关键步（冰原狼战斗结束）
	{
		key = "SignTag",
		data = {step=11},
	},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 20,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn_world"}
},


	--检测帧率/记录关键步（首次点击进入内城按钮）
	{
		key = "SignTag",
		data = {step=12},
	},

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
},



}

return _M 
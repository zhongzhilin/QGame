
local _M = {


-------------

{
	key = "AddModel",
},

---等待大地图全部显示出来
-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE},
-- },



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
	data = {side = 1,desId = 116,npc = "npc7"}
},
	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},


{
	key = "AddTroop",
	data = {
		time = 4,
		id=1002,
		heroId=8101,
		name=10596,
		pathFunc = function()
			
			-- print('global.g_worldview.mapInfo:getLastCityId()',global.g_worldview.mapInfo:getLastCityId())
			-- print('global.userData:getWorldCityID()',global.userData:getWorldCityID())
			-- print('global.g_worldview.mainCityID',global.g_worldview.worldPanel.mainId)

			return {

				[1] = global.g_worldview.mapInfo:getLastCityId(global.g_worldview.worldPanel.mainId),
				[2] = global.g_worldview.worldPanel.mainId
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
	key = "ShowNpc",
	data = {side = 1,desId = 117,npc = "npc7"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=2,isWait=true},
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


-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 18,npc = "npc6"}
-- },



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetNameFunc = function()
		
		return "monsterObj" .. global.guideMgr:getStepArg()
	end
			,isShowLight = true,scaleY = 1 }
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=3,isWait=true},
	},


{
	key = "Delay",
	data = {time = 0.3}
},



{
	key = "Guide",
	data = {panelName = "UIWildMonsterPanel",widgetName = "attack_export"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=4,isWait=true},
	},

{
	key = "Delay",
	data = {time = 0.1}
},

-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 19,npc = "npc6"}
-- },



{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg1"}
},
	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=5,isWait=true},
	},
-- {
-- 	key = "Delay",
-- 	data = {time = 0.1}
-- },

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UITroopDetailPanel",widgetName = "hero_panel"}
-- },
-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=6,isWait=true},
-- 	},
-- {
-- 	key = "Delay",
-- 	data = {time = 0.1}
-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISelectHeroPanel",widgetName = "heorlistitem8101"}
-- },

-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=7,isWait=true},
-- 	},
-- {
-- 	key = "Delay",
-- 	data = {time = 0.1}
-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"}
-- },

-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=8,isWait=true},
-- 	},

-- {
-- 	key = "Delay",
-- 	data = {time = 0.05}
-- },

-- {
-- 	key = "RemoveModel",
-- },

-- 	--检测帧率/记录关键步（准备将兵拖满300个）
-- 	{
-- 		key = "SignTag",
-- 		data = {step=9,isWait=true},
-- 	},




-- {
-- 	key = "GuideRect",
-- 	data = {panelName = "UITroopDetailPanel",widgetName = "soldier_list_bg",isShowHand=false}
-- },


-- {
-- 	key = "AddScreenEffect",
-- 	data = {id=1999,x=360,panelName="UIGuideRectPanel",y = gdisplay.height - 768,file="world/director/guide_troop"}
-- },




-- --添加模态
-- {
-- 	key = "SetPanelModel",
-- 	data = {panelName = "UITroopDetailPanel"}
-- },

-- {
-- 	key = "WaitSildier",
-- 	data = {count = 300,}	
-- },

-- 	--检测帧率/记录关键步（成功将兵拖满300个）
-- 	{
-- 		key = "SignTag",
-- 		data = {step=10,isWait=true},
-- 	},

-- {
-- 	key = "ClosePanel",
-- 	data = {panelName = "UIGuideRectPanel",}
-- },

-- {
-- 	key = "RemoveEffect",
-- 	data = {id = 1999}
-- },

-- --新模态
-- {
-- 	key = "AddModel",
-- },

	--检测帧率/记录关键步（成功将兵拖满300个）
	-- {
	-- 	key = "SignTag",
	-- 	data = {step=11,isWait=true},
	-- },

{
		key = "SignGuide",
		data = {step=900},
},


-- {
-- 	key = "SetPanelModel",
-- 	data = {panelName = "UITroopDetailPanel",isHide=true}
-- },



{
	key = "Guide",
	data = {panelName = "UITroopDetailPanel",widgetName = "Button_confirm_export",waitForNet =true}
},

{
	key = "SignGuide",
},
	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=12,isWait=true},
	},




}

return _M
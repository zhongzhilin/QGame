
local _M = {



-- {

-- 	key = "CloseAllPanel",
-- },

-- ---等待大地图全部显示出来
-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE},
-- },

{
	key = "AddModel",
},


------------------处理城堡升弹窗
{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UILordLvUpPanel",widgetName = "PanelModel_export",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)},
	target = {147}
},

{
	key = "Delay",
	data = {time = 1.5},
	target = {147}
},


{
	key = "Guide",
	data = {panelName = "UIUnLockFunPanel",widgetName = "close_noe_export",isShowHand=false,isShowLight = false},
	target = {146}
},

{
	key = "Delay",
	data = {time = 0.5}
},

------------------处理城堡升弹窗

-- {
-- 	key = 'Delay',
-- 	data = {time = 1}
-- },


{

	key = "CloseAllPanel",
},

{
	key = "ShowRedScreen",
},

{
	key = 'Delay',
	data = {time = 1}
},

{
	key = "ShowNpc",
	data = {side = 1,desId = 120,npc = "npc10"}
},


-- 	--检测帧率/记录关键步（点击进大大地图）
	{
		key = "SignTag",
		data = {step=1},
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
	key = "ShowRedScreen",
},

-- 	--检测帧率/记录关键步（到了大地图）
	{
		key = "SignTag",
		data = {step=2},
	},

{
	key = "GpsCity",	
	data = {idFunc = function() 

		local farestVillageId = global.g_worldview.mapPanel:getFarestVillage()
		global.guideMgr:setTempData(farestVillageId)
		return farestVillageId
	end,time = 1}	
},

-- {
-- 	key = 'Delay',
-- 	data = {time = 1}
-- },


	{
		key = "ShowNpc",
		data = {side = 1,desId = 122,npc = "npc4"}
	},

{
	key = "ShowNpc",
	data = {side = 1,desId = 125,isSkipAction=true,npc = "npc4"}
},

{
	key = 'AddTroopWithServerPath',
	data = {
		time = 60,
		id=1002,
		heroId=10001,
		name=10860,
		avatar=4,
		isMonster = true,
		startIdFunc = function()
			return global.guideMgr:getTempData()
		end,
		endIdFunc = function()
			return global.userData:getWorldCityID()
		end
	}
},

-- {
-- 	key = 'InsertAttackBoard',
-- 	data = {time = 60,troopId = 1002,desc = 10860}
-- },

{
	key = 'Delay',
	data = {time = 1}
},

{
	key = "GpsLine",	
	data = {posFunc = function() 

		return global.userData:getMainCityPos()
	end,time = 1}	
},



{
	key = 'Delay',
	data = {time = 1}
},


---说句话


{
	key = 'AddTroopWithServerPath',
	data = {
		time = 6000,
		id=1002,
		heroId=10001,
		isMonster = true,
		isMonster = true,
		name=10860,
		avatar=4,
		startIdFunc = function()
			return global.guideMgr:getTempData()
		end,
		endIdFunc = function()
			return global.userData:getWorldCityID()
		end
	}
},

-- {
-- 	key = "ShowNpc",
-- 	data = {side = 1,desId = 121,npc = "npc7"}
-- },


{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn_troops_export",isCircle=true,len=130}
},



{
	key = "CloseRedScreen",
},

----进入了编辑部队界面


	----

	{
		key = "Delay",
		data = {time = 0.2}
	},


		-- 	--检测帧率/记录关键步（到了大地图）
			{
				key = "SignTag",
				data = {step=3},
				target = {239}
			},

		---

		--若没有部队，直接创建部队，若有部队，跳过这一步
		{
			key = "Guide",
			data = {panelName = "UITroopPanel",widgetName = "troops_list_bg1"},
			target = {305}
		},
		





------若英雄可编辑且有部队，定位到待命中的那只部队上
	-- {
	-- 	key = "Guide",
	-- 	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg6"},
	-- 	target = {239,237}
	-- },


	{
		key = "Delay",
		data = {time = 0.5},
		target = {239,237}
	},

	{
		key = "Guide",
		data = {panelName = "UITroopPanel",widgetNameFunc = function()
			return "GuideChoosePanel" .. global.troopData:getMineTroopNumForGuideTroopID()
		end
			,isShowLight = true,scaleY = 1},
		target = {239,237}
	},
------若英雄可编辑且有部队，定位到待命的那只部队上


	{
		key = "Delay",
		data = {time = 0.1},
		target = {239,237}
	},


	{
		key = "Guide",
		data = {panelName = "UITroopPanel",widgetName = "btn_edit_export6"},
		target = {239,237}
	},



	{
		key = "Delay",
		data = {time = 0.1},
	},

	{
		key = "Guide",
		data = {panelName = "UITroopDetailPanel",widgetName = "hero_panel"},
		target = {239}
	},

	{
		key = "Delay",
		data = {time = 0.1},
		target = {239}
	},


	{
		key = "Guide",
		data = {panelName = "UISelectHeroPanel",widgetName = "heorlistitem8111"},
		target = {239}
	},

	{
		key = "Delay",
		data = {time = 0.1},
		target = {239}
	},


	{
		key = "Guide",
		data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"},
		target = {239}
	},

	{
		key = "Delay",
		data = {time = 0.5},
		target = {239}
	},



	{
		key = "Guide",
		data = {panelName = "UITroopDetailPanel",widgetName = "Button_confirm_export",waitForNet =true},
		target = {239}
	},


{
	key = "Delay",
	data = {time = 0.1}
},

---
{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "troops_list_bg6"}
},

---

{
	key = "Delay",
	data = {time = 0.1}
},

---点击驻防
{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "btn_Battle_export6"}
},
---点击驻防

-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN},
-- },



{
	key = "Delay",
	data = {time = 0.49}
},

{
		key = "SignGuide",
},

{
	key = "Guide",
	data = {panelName = "UIPromptPanel",widgetName = "Button_1",scaleY = -1 ,waitForNet =true}
},

--刷新
{
	key = "FlushTroopPanel",
},

-- 	--检测帧率/记录关键步（成功将部队驻防到地图）
	{
		key = "SignTag",
		data = {step=15,isWait=true},
	},





{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UITroopPanel",widgetName = "esc"}
},

-- {

-- 	key = "CloseAllPanel",
-- },


----

{
	key = 'AddTroopWithServerPath',
	data = {
		time = 60,
		id=1002,
		heroId=10001,
		name=10860,
		isMonster = true,
		avatar=4,
		alreadyTime=55,
		startIdFunc = function()
			local tempData = global.guideMgr:getTempData()
			global.guideMgr:setTempData(nil)
			return tempData
		end,
		endIdFunc = function()
			return global.userData:getWorldCityID()
		end
	}
},

----
{
	key = "Delay",
	data = {time = 5}
},
--模拟战斗

{
	key = 'AddTroop',
	data = {
		time = 60,
		id=1002,
		heroId=10001,
		name=10860,
		state=11,
		pathFunc = function()
			
			local tb = {}
			table.insert(tb,global.userData:getWorldCityID())
			return tb
		end
	}
},





{
	key = 'InsertAttackBoard',
	data = {time = 3,troopId = 1002,desc = 10860}
},

{
	key = 'Delay',
	data = {time = 3}
},

{
	key = 'RemoveTroop',
	data = {id = 1002}
},



---


--战斗结束

{
	key = "StartBeat",	
	data = {posFunc = function() 

		return global.userData:getMainCityPos()
	end,time = 1}	
},

-- 	--检测帧率/记录关键步（成战斗结束地图）
	{
		key = "SignTag",
		data = {step=16,isWait=true},
	},


{
	key = 'Delay',
	data = {time = 1}
},
-- {

-- 	key = "CloseAllPanel",
-- },



{
	key = "Guide",
	data = {panelName = "UIBattleErrorcodeNo",widgetName = "guide_btnBattle"}
},

-- 	--检测帧率/记录关键步（查看战报地图）
	{
		key = "SignTag",
		data = {step=17,isWait=true},
	},
-- {
-- 	key = "RemoveModel",
-- },


{
	key = 'Delay',
	data = {time = 1}

},


{
	key = "GuideRect",
	data = {panelName = "UIMailBattlePanel",widgetName = "guide_mail1",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height - 640,des = 10861}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},








{
	key = "GuideRect",
	data = {panelName = "UIMailBattlePanel",widgetName = "guide_mail2",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height - 320,des = 10862}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},



{
	key = "GuideRect",
	data = {panelName = "UIMailBattlePanel",widgetName = "replay_bt_export",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height - 280,des = 10863}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},




-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIMailBattlePanel",widgetName = "replay_bt_export"}
-- },






{
	key = 'Delay',
	data = {time = 1}

},

{
	key = "Guide",
	data = {panelName = "UIMailBattlePanel",widgetName = "esc"}
},




---等待
-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_GUIDE_EXIT_MAIL},
-- },


{

	key = "CloseAllPanel",
},

-- {
-- 	key = "AddModel",
-- },

{
	key = 'Delay',
	data = {time = 0.5}

},

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIWorldPanel",widgetName = "btn_info"}
-- },


-- {
-- 	key = 'Delay',
-- 	data = {time = 0.5}

-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIMailPanel",widgetName = "guide_mail5"}
-- },

-- {
-- 	key = 'Delay',
-- 	data = {time = 0.5}

-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIMailListPanel",widgetName = "CellBtn_export"}
-- },

-- {
-- 	key = 'Delay',
-- 	data = {time = 0.5}

-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIMailBattlePanel",widgetName = "replay_bt_export"}
-- },


-- {
-- 	key = 'Log',
-- 	data = {desc = 'end'}
-- }







-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
-- },

-- {
-- 	key = "AddModel",
-- },

-- {
-- 	key = 'Delay',
-- 	data = {time = 1}

-- },


	{
		key = "ShowNpc",
		data = {side = 1,desId = 130,npc = "npc4"}
	},





{
	key = "ShowNpc",
	data = {side = 0,desId = 123,npc = "npc6"}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 124,isSkipAction=true,npc = "npc6"}
},



-- {
-- 	key = "RemoveModel",
-- },




{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn_world"}
},

-- 	--检测帧率/记录关键步（大地欧得洋）
	{
		key = "SignTag",
		data = {step=18,isWait=true},
	},


{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
},




}

return _M
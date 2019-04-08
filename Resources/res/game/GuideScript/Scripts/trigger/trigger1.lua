local _M = {
-- {

-- 	key = "CloseAllPanel",
-- },

{
	key = "AddModel",
},


{
		key = "SignGuide",
},

------------------处理城堡升弹窗
{
	key = "Delay",
	data = {time = 1}
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
	data = {time = 1}
},

------------------处理城堡升弹窗

-- {
-- 	key = "Delay",
-- 	data = {time = 1}
-- },



{
	key = "CloseAllPanel",
},

---
{
	key = "ShowNpc",
	data = {side = 0,desId = 41,npc = "npc6"}
},

{
		key = "GpsBuild",
		data = {id = 28}
},


{
	key = "Delay",
	data = {time = 0.5}
},

{

	key = "CloseAllPanel",
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 42,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem28",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 44,npc = "npc6"}
},




{
	key = "Guide",
	data = {panelName = "UIBossPanel",widgetName = "guide_boss"}
},

{
	key = "ClosePanel",
	data = {panelName = "UIDescGuidePanel"},
},

{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "Guide",
	data = {panelName = "UIBosMonstPanel",widgetName = "Refresh_export"}
},


{
	key = "RemoveModel",
},

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_WORLD_SCENE},
},



--模态
{
	key = "AddModel",
},



{
	key = "Delay",
	data = {time = 4}
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
	data = {time = 1}
},


{
	key = "GuideRect",
	data = {panelName = "UIBosMonstPanel",widgetName = "guide01",isShowHand=false},
	target = {236}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height/2 - 150,des = 10539},
	target = {236}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel"},
	--target = {236}
},



{
	key = "GuideRect",
	data = {panelName = "UIBosMonstPanel",widgetName = "guide02",isShowHand=false},
	target = {236}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height/2 - 160,des = 10540},
	target = {236}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel"},
	--target = {236}
},



{
	key = "Guide",
	data = {panelName = "UIBosMonstPanel",widgetName = "attack_export"},
	target = {236}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 45,npc = "npc6"}
},


{
	key = "RemoveModel",
},

-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
-- },



}

return _M
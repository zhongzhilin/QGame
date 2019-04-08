local gameEvent = global.gameEvent

--[[
***常用事件
EV_ON_ITEM_UPDATE 						道具变更
EV_ON_CITY_UPDATE_BUILDINGS_STATE		内城建筑变更
EV_ON_PANEL_OPEN						打开界面
EV_ON_UI_USER_UPDATE					用户数据变更（经验，等级，战力）
]]--

local _M = {
	
	--升级到多少级 -测试引导
	-- {
	-- 	name = "trigger.trigger999",
	-- 	key = 101,
	-- 	event = gameEvent.EV_ON_UI_USER_UPDATE,
	-- 	isAnyTime = true,
	-- 	target = {12}
	-- },

	-- {
	-- 	name = "trigger.trigger2",
	-- 	key = 102,
	-- 	event = gameEvent.EV_ON_PANEL_OPEN,
	-- 	eventData = "UIHeroPanel",				
	-- },
	-- 


	-- --科技引导
	{
		name = "trigger.trigger4",
		key = 10001,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {95}
	},




	-- --占卜引导 首次点击占卜界面
	-- {
	-- 	name = "trigger.trigger2",
	-- 	key = 10002,
	-- 	event = gameEvent.EV_ON_PANEL_OPEN,
	-- 	eventData = "UIDivinePanel",				
	-- },

	{
		name = "trigger.trigger2",
		key = 10002,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {96}
	},





	-- --贴条引导
	{
		name = "trigger.trigger3",
		key = 10003,
		event = gameEvent.EV_ON_OPEN_TIPS_PANEL,				
	},



	-- --炼金池引导
	{
		name = "trigger.trigger6",
		key = 10004,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {19}
	},





	-- --神秘商店引导
	{
		name = "trigger.trigger5",
		key = 10005,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {56}
	},



		-- --boss引导
	{
		name = "trigger.trigger1",
		key = 11001,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {105}
	},



	-- --营地引导
	{
		name = "trigger.trigger7",
		key = 12001,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIWildTown",				
	},


	-- --奇迹引导
	{
		name = "trigger.trigger8",
		key = 12002,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIMagicTown",				
	},





	-- --避难所引导
	{
		name = "trigger.trigger9",
		key = 10006,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {97}
	},



	-- --铁匠铺引导
	{
		name = "trigger.trigger10",
		key = 10007,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {98}
	},



	-- --联盟引导 城堡4级

	-- {
	-- 	name = "trigger.trigger11",
	-- 	key = 13001,
	-- 	event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
	-- 	isAnyTime = true,
	-- 	target = {105}
	-- },


	-- --联盟引导 首次点击界面

	{
		name = "trigger.trigger12",
		key = 13002,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIUnionPanel",				
	},




	-- --联盟引导 建造大使馆

	{
		name = "trigger.trigger13",
		key = 13003,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {106}
	},



	-- --首次点击敌方城堡

	{
		name = "trigger.trigger14",
		key = 20001,
		event = gameEvent.EV_ON_UI_CHOOSE_CITY,
		eventData = 50,

	},

	{
		name = "trigger.trigger14",
		key = 20002,
		event = gameEvent.EV_ON_UI_CHOOSE_CITY,
		eventData = 54,

	},
	{
		name = "trigger.trigger14",
		key = 20003,
		event = gameEvent.EV_ON_UI_CHOOSE_CITY,
		eventData = 52,

	},

	{
		name = "trigger.trigger14",
		key = 20004,
		event = gameEvent.EV_ON_UI_CHOOSE_CITY,
		eventData = 53,

	},



	-- --首次点击小村庄

	{
		name = "trigger.trigger15",
		key = 20005,
		event = gameEvent.EV_ON_UI_CHOOSE_CITY,
		eventData = 0,

	},




	-- --首次点击传送门


	{
		name = "trigger.trigger16",
		key = 20006,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIPassDoorPanel",				
	},



	{
		name = "trigger.trigger16",
		key = 20007,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIPassDoorRandomPanel",				
	},



	-- --首次点击野怪

	{
		name = "trigger.trigger17",
		key = 20008,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIWildMonsterPanel",				
	},


	-- --首次点击野地

	{
		name = "trigger.trigger18",
		key = 20009,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIWildResOwnerPanel",				
	},


	-- --首次招募内政型英雄

	{
		name = "trigger.trigger19",
		key = 20010,
		event = gameEvent.EV_ON_UI_GOT_GOV_HERO,		
	},


	-- --加速引导,当训练士兵后触发（有加速道具）

	{
		name = "trigger.trigger20",
		key = 20011,
		event = gameEvent.EV_ON_UI_TRAINCLICK,
		target = {238}		
	},



	-- --联盟引导 首次进入联盟内部的主界面

	{
		name = "trigger.trigger21",
		key = 30001,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UIHadUnionPanel",				
	},



	-- --史诗英雄引导（英雄面板）

	{
		name = "trigger.trigger22",
		key = 30002,
		event = gameEvent.EV_ON_UI_HERO_KNOW,	
		target = {131},	
	},


	-- --史诗英雄引导（背包面板）
	{
		name = "trigger.trigger23",
		key = 30003,
		event = gameEvent.EV_ON_UI_HERO_KNOW,	
		target = {132},		
	},



	-- --VIP引导
	{
		name = "trigger.trigger24",
		key = 30004,
		event = gameEvent.EV_ON_PANEL_OPEN,
		eventData = "UILordLvUpPanel",	
		target = {133},				
	},






---首次打开攻击指令列表时，触发指令列表引导


	{
		name = "trigger.trigger25",
		key = 30005,
		event = gameEvent.EV_ON_GUIDE_FIRST_ATTACT_BOARD,
		target = {135},					
	},




---首次在编辑部队更换英雄时，触发统帅、粮耗、速度的介绍



	-- {
	-- 	name = "trigger.trigger26",
	-- 	key = 30006,
	-- 	event = gameEvent.EV_ON_GUIDE_FIRST_CHANGE_HERO_IN_EDIT_SELECT_CONFRIM,			
	-- },



---30007  侦查营引导

	{
		name = "trigger.trigger27",
		key = 30007,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {136}
	},




	--新号签到引导 城堡3级

	{
		name = "trigger.trigger28",
		key = 40001,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {1}
	},




	--每日任务引导 城堡5级

	{
		name = "trigger.trigger29",
		key = 40002,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {14}
	},


	--穿装备引导  首次点击英雄界面

	{
		name = "trigger.trigger30",
		key = 40004,
		event = gameEvent.EV_ON_GUIDE_HERO_PANEL_2,
		target = {243,244,285}
		--eventData = "UIHeroPanel",				
	},



	--驻防引导 城堡6级

	{
		name = "trigger.trigger31",
		key = 40003,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {188}
	},


	-- --首次驻防引导
	{
		name = "trigger.trigger32",
		key = 40005,
		event = global.gameEvent.EV_ON_GUIDE_WARIN,				
	},


	-- 首次村庄引导
	-- {
	-- 	name = "trigger.trigger33",
	-- 	key = 40006,
	-- 	event = global.gameEvent.EV_ON_GUIDE_VILLAGE_GUIDE_DONE,				
	-- },


	-- 训练30个兵引导
	{
		name = "trigger.trigger34",
		key = 40007,
		event = global.gameEvent.EV_ON_GUIDE_TRAIN_GUIDE_DONE,				
	},



	--澡堂引导 城堡7级

	{
		name = "trigger.trigger35",
		key = 40008,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {94}
	},

	-- --英雄竞技场引导
	{
		name = "trigger.trigger36",
		key = 40009,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		isAnyTime = true,
		target = {292}
	},

	-- --神兽引导
	{
		name = "trigger.trigger47",
		key = 40010,
		event = gameEvent.EV_ON_GUIDE_UNLOCK_PET,
		-- eventData = "UIPetInfoPanel",				
	},

	-- --英雄说服引导
	{
		name = "trigger.trigger48",
		key = 40011,
		event = gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE,
		-- eventData = "UIPetInfoPanel",
		target = {301},	
	},
	-- --神兽引导
	{
		name = "trigger.trigger49",
		key = 40012,
		event = gameEvent.EV_ON_ENTER_MAIN_SCENE,
		-- eventData = "UIPetInfoPanel",
		target = {300,282},	
	},

}

return _M
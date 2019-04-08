local gameEvent = global.gameEvent

--[[
***常用事件
EV_ON_ITEM_UPDATE 						道具变更
EV_ON_CITY_UPDATE_BUILDINGS_STATE		内城建筑变更
EV_ON_PANEL_OPEN						打开界面
EV_ON_UI_USER_UPDATE					用户数据变更（经验，等级，战力）
]]--

local _M = {
	

---首次在编辑部队更换英雄时，触发统帅、粮耗、速度的介绍


	{
		name = "prompt.prompt1",
		key = 90001,
		event = gameEvent.EV_ON_LOOP_GUIDE_UPDATE,		
		target = {108}	
	},

	{
		name = "prompt.prompt12",
		key = 900012,
		event = gameEvent.EV_ON_LOOP_GUIDE_UPDATE,		
		target = {107}	
	},



	{
		name = "prompt.prompt36",
		key = 900052,
		event = gameEvent.EV_ON_GPSBUILID,		
	},



	{
		name = "prompt.prompt2",
		key = 90002,
		event = gameEvent.EV_ON_LOOP_GUIDE_TRAIN,			
	},

	{
		name = "prompt.prompt9",
		key = 90007,
		event = gameEvent.EV_ON_LOOP_GUIDE_TRAIN_SPEED,			
	},

	---内城定位城堡特色界面
	{
		name = "prompt.prompt3",
		key = 90003,
		event = gameEvent.EV_ON_CASTINFOGUIDE,
		target = {108}			
	},

	---大地图定位城堡特色界面
	{
		name = "prompt.prompt4",
		key = 90004,
		event = gameEvent.EV_ON_CASTINFOGUIDE,
		target = {107}			
	},

	{
		name = "prompt.prompt5",
		key = 90005,
		event = gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH,			
	},

	{
		name = "prompt.prompt11",
		key = 900051,
		event = gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH_OPEN_PANEL,			
	},

	{
		name = "prompt.prompt6",
		key = 90006,
		event = gameEvent.EV_ON_LOOP_GUIDE_OPEN_BUILD,			
	},

	---1 定位大地图并指引村庄、野地等建筑
	{
		name = "prompt.prompt7",
		key = 90004,
		event = gameEvent.EV_ON_LOOP_GUIDE_PANDECT,	
		target = {108}				
	},


	---2 定位大地图并指引村庄、野地等建筑
	{
		name = "prompt.prompt8",
		key = 90005,
		event = gameEvent.EV_ON_LOOP_GUIDE_PANDECT,		
		target = {107}			
	},

	---2 定位大地图并指引村庄、野地等建筑
	{
		name = "prompt.prompt10",
		key = 90009,
		event = gameEvent.EV_ON_LOOP_GUIDE_FIX_SCENE,				
	},

-- 首次村庄引导
	{
		name = "trigger.trigger33",
		key = 90010,
		event = gameEvent.EV_ON_GUIDE_VILLAGE_GUIDE_DONE,				
	},

	-- 资源加速
	{
		name = "prompt.prompt34",
		key = 90034,
		event = gameEvent.EV_ON_LOOP_GUIDE_ADD_RES_SPEED,			
	},

		--改名引导 点击头像
	{
		name = "prompt.prompt35",
 		key = 90011,
  		event = gameEvent.EV_ON_PANEL_OPEN,
  		eventData = "UILordPanel",
  		isAnyTime = true,
  		target = {287,288}
	},
}

return _M
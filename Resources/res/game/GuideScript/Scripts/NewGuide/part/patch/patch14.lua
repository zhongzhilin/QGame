
local _M = {

{
	key = "AddModel",
},


	--检测帧率/记录关键步（成功建造酒馆）
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},


{
	key = "Delay",
	data = {time = 1}
},


----如果不是重新登录，不做GPS
{
		key = "GpsBuild",
		data = {id = 15}
},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 118,npc = "npc8"}
},
	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=2,isWait=true},
	},


-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 119,isSkipAction=true,npc = "npc6"}
-- },


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem15",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=3,isWait=true},
	},

{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "build_btn_25",isCircle=true,len=113,isShowLight = true,waitForNet =true}
},



-- {
-- 	key = "GpsHero",
-- 	data = {heroId = 8217}
-- },

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=4,isWait=true},
	},


{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "buy_coin_btn8111"}
},

---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

	--【后台每一步统计】
	-- {
	-- 	key = "SignTag",
	-- 	data = {step=5,isWait=true},
	-- },


-- {
-- 	key = "Delay",
-- 	data = {time = 0.1}
-- },

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIHeroPanel",widgetName = "buy_exploit_btn8111"}
-- },

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIDetailPanel",widgetName = "btn_Persuade_export"}
-- },

-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=6,isWait=true},
-- 	},



-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },





-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIPersuadePanel",widgetName = "item_export"}
-- },

-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=7,isWait=true},
-- 	},


-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },




-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISpeedPanel",widgetName = "bg12327"},
-- },
-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=8,isWait=true},
-- 	},



-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },


-- {
-- 	key = "SetSildier",
-- 	data = {panelName = "UISpeedPanel",count = 20}
-- },



-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISpeedPanel",widgetName = "btnUse_export",waitForNet =true},
-- },



{
		key = "SignGuide",
},



-- --结识成功
{
	key = "Delay",
	data = {time = 2}
},

{
	key = "Guide",
	data = {panelName = "UIGotHeroPanel",widgetName = "Panel_1",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=9,isWait=true},
	},
-------
-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },




-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIHeroPanel",widgetName = "esc"}
-- },

-- {

-- 	key = "CloseAllPanel",
-- },

-- 	--【后台每一步统计】
-- 	{
-- 		key = "SignTag",
-- 		data = {step=10,isWait=true},
-- 	},


{
	key = "RemoveModel",
},


--结识成功



}

return _M
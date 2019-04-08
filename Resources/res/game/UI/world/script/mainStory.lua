local BaseBuildScript = require("game.UI.world.script.util.BaseBuildScript")



local _M = {
	
	-- {
	-- 	key = "Delay",
	-- 	data = {time = 0.5}
	-- },
	
	-- {
	-- 	key = "ShowNpc",
	-- 	data = {side = 0,des = "领主大人！我们要尽快发展城堡！巴拉巴拉……",npc = "npc1"}
	-- },

	-- {
	-- 	key = "ShowNpc",
	-- 	data = {side = 1,des = "需要木材建设城堡巴拉巴拉……",npc = "npc2"}
	-- },

	-- {
	-- 	key = "InsertStory",
	-- 	data = {data = BaseBuildScript.setData(9)}
	-- },

	-- {	
	-- 	key = "ShowNpc",
	-- 	data = {side = 1,des = "可以通过木材建校场，校场很重要巴拉巴拉……",npc = "npc2"}
	-- },

	-- {
	-- 	key = "InsertStory",
	-- 	data = {data = BaseBuildScript.setData(4)}
	-- },

	-- {
	-- 	key = "ShowNpc",
	-- 	data = {side = 1,des = "有了校场有兵原建造兵营啦巴拉巴拉……",npc = "npc2"}
	-- },

	-- {
	-- 	key = "InsertStory",
	-- 	data = {data = BaseBuildScript.setData(2)}
	-- },
		
	{
		key = "Delay",
		data = {time = 1}
	},

	{
		key = "Guide",
		data = {panelName = "UICityPanel",widgetName = "btn_hero"}
	},

	{
		key = "Delay",
		data = {time = 0.5}
	},

	{
		key = "Guide",
		data = {panelName = "UIHeroPanel",widgetName = "Button_3"}
	},

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 5}
	-- },

	{
		key = "Guide",
		data = {panelName = "UIHeroPanel",widgetName = "buy_coin_btn8114"}
	},

	-- {
	-- 	key = "SetSildier",
	-- 	data = {panelName = "TrainNumPanel",count = 999999}
	-- },

	-- {
	-- 	key = "Delay",
	-- 	data = {time = 1}
	-- },

	-- {
	-- 	key = "ClosePanel",
	-- 	data = {panelName = "TrainNumPanel"}
	-- },
}

return _M
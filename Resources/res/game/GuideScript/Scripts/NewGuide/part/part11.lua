
local _M = {

{
	key = "AddModel",
},


-- 	--升级城堡2级
	{
		key = "SignTag",
		data = {step=19,isWait=true},
	},



------------------处理城堡升弹窗
{
	key = "Delay",
	data = {time = 1.5}
},


{
	key = "Guide",
	data = {panelName = "UIUnLockFunPanel",widgetName = "close_noe_export",isShowHand=false,isShowLight = false},
},

{
	key = "Delay",
	data = {time = 1}
},

------------------处理城堡升弹窗





{
	key = "ShowNpc",
	data = {side = 1,desId = 115,npc = "npc9"}
},

	{
		key = "SignTag",
		data = {step=20,isWait=true},
	},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_world"}
},

-- -- 	--升级城堡2级
-- 	{
-- 		key = "SignTag",
-- 		data = {step=21,isWait=true},
-- 	},

	-- {
	-- 	key = "SignGuide",
	-- },



-----加入创建名字引导 inputBox
-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },



-- {
-- 	key = "RemoveModel",
-- },

-- {
-- 	key = "SetPanelModel",
-- 	data = {panelName = "UICreateCityPanel"}
-- },
---------------------------------------------

-- {
-- 	key = "Wait",
-- 	data = {taskEvent=global.gameEvent.EV_ON_ENTER_WORLD_SCENE},
-- },



-- {
-- 		key = "SignGuide",
-- },


}

return _M
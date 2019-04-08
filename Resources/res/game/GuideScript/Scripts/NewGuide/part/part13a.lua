	
local _M = {


{
	key = "Delay",
	data = {time = 0.45}
},

{
	key = "Guide",
	data = {panelName = "UIPromptPanel",widgetName = "Button_1",scaleY = -1 ,waitForNet =true}
},

{
	key = "SignGuide",
},

{
	key = "RemoveModel",
},

{
	key = "DisableButtons",
},


-- {
-- 	key = "Delay",
-- 	data = {time = 3}
-- },

{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ATTACK_FINISH,maxTime = 10},
},

	--检测帧率/记录关键步（冰原狼战斗结束）
	{
		key = "SignTag",
		data = {step=13,isWait=true},
	},




{
	key = "Delay",
	data = {time = 0.5}
},

-- {
-- 	key = "Delay",
-- 	data = {time = 2.5}
-- },

-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 20,npc = "npc6"}
-- },

-- {

-- 	key = "CloseAllPanel",
-- },

-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },
{
	key = "AddModel",
},

{
	key = "EnableButtons",
},

{
		key = "SignGuide",
		data = {step=901},
},
-- 	--检测帧率/记录关键步（首次点击进入内城按钮）
	{
		key = "SignTag",
		data = {step=14,isWait=true},
	},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn_world"}
},




{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_MAIN_SCENE},
},


---说两句话
-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 129,npc = "npc6"}
-- },



-- {
-- 	key = "AddModel",
-- },


-- {
-- 	key = "Delay",
-- 	data = {time = 1}
-- },


-- {
-- 	key = "RemoveModel",
-- },


}

return _M
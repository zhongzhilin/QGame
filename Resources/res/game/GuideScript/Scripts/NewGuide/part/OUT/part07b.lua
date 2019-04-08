
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




-----加入创建名字引导 inputBox
{
	key = "Delay",
	data = {time = 0.5}
},

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UICreateCityPanel",widgetName = "guide"}
-- },


{
	key = "RemoveModel",
},

{
	key = "SetPanelModel",
	data = {panelName = "UICreateCityPanel"}
},


{
	key = "Wait",
	data = {taskEvent=global.gameEvent.EV_ON_ENTER_WORLD_SCENE},
},



-- {
-- 		key = "SignGuide",
-- },


}

return _M
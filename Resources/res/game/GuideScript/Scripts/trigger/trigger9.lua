local _M = {

{

	key = "CloseAllPanel",
},
{
	key = "AddModel",
},

{
	key = "Delay",
	data = {time = 1}
},

{

	key = "CloseAllPanel",
},

{
	key = "Delay",
	data = {time = 1}
},


---
{
	key = "ShowNpc",
	data = {side = 0,desId = 70,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 13}
},


{
	key = "Delay",
	data = {time = 0.5}
},
{

	key = "CloseAllPanel",
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem13",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},




{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_t3",isCircle=true,len=113,isShowLight = true}
},


------------
{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 71,npc = "npc6"}
},



{
		key = "SignGuide",
},


{
	key = "Guide",
	data = {panelName = "UIHpPanel",widgetName = "all_heal_btn_export"}
},


{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UIAllCureSurePanel",widgetName = "free_btn_export"}
},


{
	key = "Delay",
	data = {time = 1.5}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 72,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UIHpPanel",widgetName = "all_recruit_btn_export"}
},


{
	key = "Delay",
	data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIAllRecruitSurePanel",widgetName = "coin_recruit_btn"}
},


{
	key = "Delay",
	data = {time = 1.5}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 73,npc = "npc6"}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 74,isSkipAction=true,npc = "npc6"}
},


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIHpPanel",widgetName = "esc"}
-- },


{

	key = "CloseAllPanel",
},


{
	key = "RemoveModel",
},



{
	key = "Delay",
	data = {time = 1}
},


}

return _M
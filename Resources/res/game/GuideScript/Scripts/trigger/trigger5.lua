 local _M = {
-- {

-- 	key = "CloseAllPanel",
-- },

{
	key = "AddModel",
},


------------------处理城堡升弹窗
{
	key = "Delay",
	data = {time = 1}
},


{
	key = "Guide",
	data = {panelName = "UIUnLockFunPanel",widgetName = "close_noe_export",isShowHand=false,isShowLight = false},
	target = {146}
},

------------------处理城堡升弹窗


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

{
	key = "ShowNpc",
	data = {side = 0,desId = 58,npc = "npc6"}
},



{
		key = "GpsBuild",
		data = {id = 19}
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
	data = {panelName = "UICityPanel",widgetName = "citybuilditem19",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},





{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "build_btn_38",isCircle=true,len=113,isShowLight = true}
},




{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 59,npc = "npc6"}
},



{
	key = "RemoveModel",
},

{
		key = "SignGuide",
},


}

return _M
local _M = {

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
	data = {time = 0.5}
},

------------------处理城堡升弹窗

{
	key = "ShowNpc",
	data = {side = 0,desId = 134,npc = "npc6"}
},


---
{
		key = "GpsBuild",
		data = {id = 31}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "guide_pet_city",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},


{
		key = "SignGuide",
},


{
	key = "Delay",
	data = {time = 0.4}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 135,npc = "npc6"}
},



{
	key = "RemoveModel",
},

}

return _M
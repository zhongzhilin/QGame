local _M = {

{
	key = "AddModel",
},

{

	key = "CloseAllPanel",
},

{
	key = "Delay",
	data = {time = 1}
},

{

	key = "CloseAllPanel",
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 62,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 25}
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
	data = {panelName = "UICityPanel",widgetName = "citybuilditem25",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},




{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_t3",isCircle=true,len=113,isShowLight = true}
},







---
{
	key = "Delay",
	data = {time = 2}
},


---
{
	key = "ShowNpc",
	data = {side = 0,desId = 46,npc = "npc6"}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 47,isSkipAction=true,npc = "npc6"}
},


--------------------插入介绍

{
	key = "GuideRect",
	data = {panelName = "UIDivinePanel",widgetName = "resetFreeBtn_export",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = 310,des = 10550}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel"}
},





{
	key = "GuideRect",
	data = {panelName = "UIDivinePanel",widgetName = "divFreeBtn_export",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = 310,des = 10551}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel"}
},








-----------------------------

{
	key = "ShowNpc",
	data = {side = 0,desId = 48,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UIDivinePanel",widgetName = "divFreeBtn_export"}
},



{
	key = "Delay",
	data = {time = 3}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 49,npc = "npc6"}
},

{
	key = "RemoveModel",
},


{
		key = "SignGuide",
},





}

return _M
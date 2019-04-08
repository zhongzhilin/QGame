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
	data = {side = 0,desId = 75,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 20}
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
	data = {panelName = "UICityPanel",widgetName = "citybuilditem20",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "build_btn_33",isCircle=true,len=113,isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.1}
},

--------------------------新增内容

{
	key = "ShowNpc",
	data = {side = 0,desId = 132,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UIEquipForgePanel",widgetName = "Button_2"}
},

{
	key = "Delay",
	data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIEquipForgePanel",widgetName = "btn1_export"}
},


{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 133,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UIForgeSelectPanel",widgetName = "Button_3"}
},


{
	key = "Delay",
	data = {time = 0.2}
},


{
	key = "Guide",
	data = {panelName = "UIForgeSelectPanel",widgetName = "forge_btn_export"}
},


{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UIForgeInfoPanel",widgetName = "forge_btn_export"}
},


{
	key = "Delay",
	data = {time = 5}
},

{
		key = "SignGuide",
},



{
	key = "Guide",
	data = {panelName = "UIForgeSuccess",widgetName = "Panel_2",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},
{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UIForgeInfoPanel",widgetName = "esc"}
},

{

	key = "CloseAllPanel",
},
{
	key = "Delay",
	data = {time = 0.2}
},





----下面是强化引导




{
	key = "ShowNpc",
	data = {side = 0,desId = 131,npc = "npc6"}
},




{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem20",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},



{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "build_btn_10",isCircle=true,len=113,isShowLight = true}
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 76,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UIEquipStrongPanel",widgetName = "equipIcon_export"}
},




------------




{
	key = "Guide",
	data = {panelName = "UIEquipPanel",widgetName = "icon_export"}
},

{
		key = "Delay",
		data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIEquipPanel",widgetName = "strengthen_export"}
},


{
		key = "Delay",
		data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIEquipStrongPanel",widgetName = "Image_7"}
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
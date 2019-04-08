local _M = {



{
		key = "SignGuide",
},


{
	key = "AddModel",
},


------增加了动画，插入一个点击

{
	key = "Delay",
	data = {time = 2.5}
},

{
	key = "Guide",
	data = {panelName = "UILordLvUpPanel",widgetName = "PanelModel_export",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 81,npc = "npc6"}
},


-----大地图特殊设定
{
	key = "RemoveModel",
},


{
	key = "GotoMainScene",
	target = {107}
},

{
	key = "wait",
	target = {107}
},


{
	key = "AddModel",
},

-----大地图特殊设定


{

	key = "CloseAllPanel",
},

{
	key = "Delay",
	data = {time = 0.5}
},


{
		key = "GpsBuild",
		data = {id = 1}
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
	data = {panelName = "UICityPanel",widgetName = "citybuilditem1",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},




{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_t3",isCircle=true,len=113,isShowLight = true}
},



{
	key = "Delay",
	data = {time = 0.2}
},




{
	key = "Guide",
	data = {panelName = "UIHeroGarrisionPanel",widgetName = "choose_hero"},
	target = {113}
},

{
	key = "Delay",
	data = {time = 0.1}
},



{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "hero_icon_export"},
	target = {113}
},

{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"},
	target = {113}
},




{
	key = "ShowNpc",
	data = {side = 0,desId = 82,npc = "npc6"}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 83,isSkipAction=true,npc = "npc6"}
},



{
	key = "RemoveModel",
},




}

return _M
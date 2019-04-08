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

	key = "CloseAllPanel",
},
{
	key = "Delay",
	data = {time = 0.5}
},
{
	key = "ShowNpc",
	data = {side = 0,desId =146 ,npc = "npc8"}
},

{
		key = "GpsBuild",
		data = {id = 15}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem15",scaleX = -1 ,scaleY = 1 , isShowLight = true}
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
	data = {time = 0.4}
},
{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "guide_btn"},
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 147,npc = "npc8"}
},

{
	key = "Delay",
	data = {time = 0.2}
},

{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "hero_come1_1"},
},
{
	key = "Delay",
	data = {time = 1}
},
{
	key = "ShowNpc",
	data = {side = 0,desId =148 ,npc = "npc8"}
},
{
	key = "Delay",
	data = {time = 0.5}
},
{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "start1_btn"},
},
{
	key = "Delay",
	data = {time = 1}
},
{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "bg13802"},
	target = {302}
},
{
	key = "Delay",
	data = {time = 0.5}
},
{
	key = "SetSildier",
	data = {panelName = "UISpeedPanel",count = 5}
},

{
	key = "Delay",
	data = {time = 1}
},
{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "btnUse_export"},
},
{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "RemoveModel",
},


}

return _M

local _M = {

{
	key = "AddModel",
},

{
	key = "Delay",
	data = {time = 0.5}
},


----如果不是重新登录，不做GPS
{
		key = "GpsBuild",
		data = {id = 15}
},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 26,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem15",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_t3",isCircle=true,len=113,isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "btnBg_guide1"}
},

---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

{
	key = "Delay",
	data = {time = 0.1}
},

{
	key = "Guide",
	data = {panelName = "UIDetailPanel",widgetName = "btn_Know_export"}
},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UIBagUseSingle",widgetName = "Button_4_0",waitForNet =true}
},


{
		key = "SignGuide",
},

--结识成功

{
	key = "Delay",
	data = {time = 0.5}
},


}

return _M
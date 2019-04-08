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
	data = {time = 1}
},

------------------处理城堡升弹窗

{

	key = "CloseAllPanel",
},

---
{
	key = "ShowNpc",
	data = {side = 0,desId = 126,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 1}
},

{
	key = "Delay",
	data = {time = 0.1}
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
	data = {panelName = "UICityPanel",widgetName = "build_btn_23",isCircle=true,len=113,isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.2}
},

{
	key = "Guide",
	data = {panelName = "UICityGarrisonPanel",widgetName = "guide_garrison"}
},



{
	key = "Delay",
	data = {time = 0.2}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 127,npc = "npc6"}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 128,npc = "npc6"}
},


{
	key = "Guide",
	data = {panelName = "UIGarrisonSelectPanel",widgetName = "btn_1"}
},





{
	key = "RemoveModel",
},




}

return _M
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
	data = {side = 0,desId = 141,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 33}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem33",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},



{
	key = "GuideRect",
	data = {panelName = "UIPKPanel",widgetName = "Guide_1",isShowHand=false}
},
{
	key = "GuideDesc",
	data = {y = gdisplay.height - 420,des = 11119}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},


{
	key = "GuideRect",
	data = {panelName = "UIPKPanel",widgetName = "Guide_2",isShowHand=false}
},
{
	key = "GuideDesc",
	data = {y = gdisplay.height - 210,des = 11120}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},


{
	key = "GuideRect",
	data = {panelName = "UIPKPanel",widgetName = "Guide_3",isShowHand=false}
},
{
	key = "GuideDesc",
	data = {y = 325,des = 11121}
},
{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 142,npc = "npc6"}
},

{
	key = "RemoveModel",
},



}

return _M
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
	data = {side = 0,desId = 105,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 24}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem24",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

{
	key = "Delay",
	data = {time = 0.4}
},


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UICityPanel",widgetName = "build_btn_30",isCircle=true,len=113,isShowLight = true}
-- },

-- {
-- 	key = "Delay",
-- 	data = {time = 0.4}
-- },

{
	key = "Guide",
	data = {panelName = "UIActivityPanel",scaleY = -1 ,widgetName = "guide2"}
},



{
	key = "Delay",
	data = {time = 0.4}
},

{
	key = "Guide",
	data = {panelName = "UIActivityPanel",scaleY = -1 ,widgetName = "frame_bg18001"}
},

{
	key = "Delay",
	data = {time = 0.4}
},

{
	key = "ShowNpc",
	data = {side = 0,desId = 106,npc = "npc6"}
},



{
	key = "RemoveModel",
},




}

return _M
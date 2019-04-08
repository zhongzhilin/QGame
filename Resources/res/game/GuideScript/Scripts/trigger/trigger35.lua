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
	data = {side = 0,desId = 138,npc = "npc6"}
},


{
		key = "GpsBuild",
		data = {id = 32}
},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem32",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 139,npc = "npc6"}
},




{
	key = "Guide",
	data = {panelName = "UIHeroExpPanel",widgetName = "help_btn_export"}
},

{
	key = "Delay",
	data = {time = 0.2}
},



{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "hero_icon_export"}
},





{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "Guide",
	data = {panelName = "UISelectHeroPanel",widgetName = "confirmBtn"}
},



{
	key = "Delay",
	data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIHeroExpPanel",widgetName = "my_start_export"}
},

-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },



-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISpeedPanel",widgetName = "bg13501"},
-- },


{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "btnUse_export"},
},


{
	key = "RemoveModel",
},




}

return _M

local _M = {


{
	key = "ShowNpc",
	data = {side = 0,desId = 92,npc = "npc6"}
},



{
	key = "Guide",
	data = {panelName = "UIDetailPanel",widgetName = "btn_Persuade_export"}
},

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UIPersuadePanel",widgetName = "item_export"}
},
{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "bg12402"}
},
{
	key = "Delay",
	data = {time = 0.5}
},
{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "btnUse_export",waitForNet =true}
},


{
		key = "SignGuide",
},

{
	key = "Delay",
	data = {time = 2.5}
},

{
	key = "Guide",
	data = {panelName = "UIGotHeroPanel",widgetName = "Panel_1",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},


-------
{
	key = "Delay",
	data = {time = 1}
},




{
	key = "Guide",
	data = {panelName = "UIDetailPanel",widgetName = "esc"}
},

{

	key = "CloseAllPanel",
},


{
	key = "RemoveModel",
},





}

return _M
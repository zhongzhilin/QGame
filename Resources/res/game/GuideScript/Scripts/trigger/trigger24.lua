local _M = {


{
		key = "SignGuide",
},


{
	key = "AddModel",
},


-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UILordLvUpPanel",widgetName = "PanelModel_export",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)},
-- 	target = {134}
-- },


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

------

{
	key = "Guide",
	data = {panelName = "UIUnLockFunPanel",widgetName = "close_noe_export",isShowHand=false,isShowLight = false},
	target = {146}
},

{
	key = "Delay",
	data = {time = 1}
},

------
{
	key = "ShowNpc",
	data = {side = 0,desId = 95,npc = "npc6"}
},

{

	key = "CloseAllPanel",
},


{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "user_vip_node_export"}
},


{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UIvipPanel",widgetName = "bt_activation_node_export"}
},

-- {
-- 	key = "Delay",
-- 	data = {time = 0.5}
-- },

-- {
-- 	key = "Guide",
-- 	data = {panelName = "UISpeedPanel",widgetName = "bg20702"},
-- 	target = {112}
-- },

{
	key = "Delay",
	data = {time = 1}
},

{
	key = "Guide",
	data = {panelName = "UISpeedPanel",widgetName = "btnUse_export"},
	target = {112}
},



{
	key = "Delay",
	data = {time = 2}
},





{
	key = "GuideRect",
	data = {panelName = "UIvipPanel",widgetName = "VIPguide01",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height - 350,des = 10704}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},





{
	key = "GuideRect",
	data = {panelName = "UIvipPanel",widgetName = "guide_VIP_fun",isShowHand=false}
},

{
	key = "GuideDesc",
	data = {y = gdisplay.height - 450,des = 10705}
},

{
	key = "ClosePanel",
	data = {panelName = "UIGuideRectPanel",}
},


{
	key = "ShowNpc",
	data = {side = 0,desId = 96,npc = "npc6"}
},


{
	key = "RemoveModel",
},




}

return _M
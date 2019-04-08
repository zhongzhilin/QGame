local _M = {


{
	key = "AddModel",
},

{
	key = "Delay",
	data = {time = 0.25}
},

{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "Panel_bg",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)},
	target = {275}
},
{
	key = "Delay",
	data = {time = 0.25}
},


{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "world_btn_11",isCircle=true,len=125,isShowLight = true,dtX=-6,dtY=2}
},


{
	key = "Delay",
	data = {time = 0.4}
},


{
	key = "HideAttackBoard",
},



{
	key = "Delay",
	data = {time = 0.1}
},



{
	key = "Guide",
	data = {panelName = "UIWorldPanel",widgetName = "btn01", dtX=-5, dtY=5}
},


-- {
-- 		key = "SignGuide",
-- },



{
	key = "RemoveModel",
},



}

return _M
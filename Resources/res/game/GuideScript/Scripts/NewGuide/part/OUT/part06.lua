
local _M = {

{
	key = "AddModel",
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 14,npc = "npc6"}
},

{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_task"}
},



{
	key = "Delay",
	data = {time = 0.05}
},



{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "arrive_btn_export",waitForNet =true}
},


{
		key = "SignGuide",
},

-----------------------------------
{
	key = "Delay",
	data = {time = 0.8} 
},



{
	key = "Guide",
	data = {panelName = "UILordLvUpPanel",widgetName = "PanelModel_export",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},


{
	key = "Delay",
	data = {time = 2}  --等待动画结束
},


{
	key = "Guide",
	data = {panelName = "TaskPanel",widgetName = "Button_1"}
},



{
	key = "RemoveModel",
},

}

return _M
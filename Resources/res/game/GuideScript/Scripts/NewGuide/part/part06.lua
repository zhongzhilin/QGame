
local _M = {

{
	key = "AddModel",
},


-- {
-- 	key = "ShowNpc",
-- 	data = {side = 0,desId = 13,npc = "npc6"}
-- },



{
	key = "Delay",
	data = {time = 0.5}
},


{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "citybuilditem2",scaleX = -1 ,scaleY = 1 , isShowLight = true}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},

{
	key = "Delay",
	data = {time = 0.4}
},




{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "btn_t3",isCircle=true,len=113,isShowLight = true}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=2,isWait=true},
	},

{
	key = "Guide",
	data = {panelName = "TrainPanel",widgetName = "btn_train_export2"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=3,isWait=true},
	},

{
	key = "Delay",
	data = {time = 0.1}
},


{
	key = "SetSildier",
	data = {panelName = "TrainNumPanel",count = 300}
},


{
	key = "Guide",
	data = {panelName = "TrainNumPanel",widgetName = "btn_train_export",isShowLight = true}
},




{
	key = "ClosePanel",
	data = {panelName = "TrainNumPanel",}
},

{
	key = "ClosePanel",
	data = {panelName = "TrainPanel",}
},


{
		key = "SignGuide",
},

{
	key = "Delay",
	data = {time = 0.2}
},

{
	key = "RemoveModel",
},


}

return _M
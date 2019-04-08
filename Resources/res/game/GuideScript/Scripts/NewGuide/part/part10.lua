local BaseBuildScript = require("game.GuideScript.Scripts.util.BaseBuildScript")


local _M = {

{
	key = "AddModel",
},




{
	key = "Delay",
	data = {time = 1}
},



{
	key = "Guide",
	data = {panelName = "UICityPanel",widgetName = "guide_task",waitForNet =true}
},

{
		key = "SignGuide",
},


{
	key = "Delay",
	data = {time = 1}
},

{
	key = "Guide",
	data = {panelName = "UILordLvUpPanel",widgetName = "PanelModel_export",isShowHand=false,isShowLight = false,touchPos = cc.p(360,80)}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=1,isWait=true},
	},

{
	key = "Delay",
	data = {time = 1.5}  --等待动画结束
},





{
	key = "ShowNpc",
	data = {side = 0,desId = 113,npc = "npc6"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=2,isWait=false},
	},

{
	key = "ShowNpc",
	data = {side = 0,desId = 114,isSkipAction=true,npc = "npc6"}
},

	--【后台每一步统计】
	{
		key = "SignTag",
		data = {step=3,isWait=true},
	},


{
	key = "RemoveModel",
},





}

return _M

local _M = {


{
	key = "AddModel",
},



{
		key = "SignGuide",
},



{
	key = "ShowNpc",
	data = {side = 0,desId = 78,npc = "npc6"}
},


-- {
-- 	key = "Guide",
-- 	data = {panelName = "UIHeroPanel",widgetName = "incall_export"}
-- },

-- {
-- 		key = "Delay",
-- 		data = {time = 0.5}
-- },

------------解决适配
{
	key = "FixScrollView",
	data = {panelName = "UIHeroPanel",widgetName = "ScrollView_1_export"}
},

------------


{
	key = "Guide",
	data = {panelName = "UIHeroPanel",widgetName = "guide_eq"}
},

{
		key = "Delay",
		data = {time = 0.5}
},

{
	key = "Guide",
	data = {panelName = "UIEquipPanel",widgetName = "icon_export"}
},

{
		key = "Delay",
		data = {time = 0.5}
},



{
	key = "Guide",
	data = {panelName = "UIEquipPanel",widgetName = "put_export",waitForNet =true}
},



{
	key = "RemoveModel",
},




}

return _M
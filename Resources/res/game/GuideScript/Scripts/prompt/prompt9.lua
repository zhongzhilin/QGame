local _M = {


{
	key = "AddModel",
},

-- {
-- 	key = "ResetCityCamera",
-- },

{
	key = "Delay",
	data = {time = 0.5}
},

{
	key = "Guide",
	data = {
		panelName = "UICityPanel",
		widgetName = 'build_btn_6',
		beforeCheck = true,
		isCircle=true,
		len=120,
		skip = true,
		isShowLight = true,
		dtX = -4,
		isShowHand = false,
		scaleFunc = function()
			return global.g_cityView:getCamera().m_scrollView:getContainer():getScale()
		end
	}
},

{
	key = "RemoveModel",
},

}

return _M
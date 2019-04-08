--region UIHeroExpTimeItem.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroExpTimeItem  = class("UIHeroExpTimeItem", function() return gdisplay.newWidget() end )

function UIHeroExpTimeItem:ctor()
    
end

function UIHeroExpTimeItem:CreateUI()
    local root = resMgr:createWidget("hero_exp/rest_time_node")
    self:initUI(root)
end

function UIHeroExpTimeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/rest_time_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.rest_time = self.root.rest_time_mlan_10.rest_time_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
	

function UIHeroExpTimeItem:setData(endTime , endCall)

	self.data = endTime

	global.netRpc:delHeartCall(self)

	local call = function () 
		local time = self.data - global.dataMgr:getServerTime()
		if time < 0 then 
			time =0 
			if endCall then 
				endCall()
			end 
		end 
		self.rest_time:setString(global.funcGame.formatTimeToHMS(time))
	    global.tools:adjustNodePosForFather(self.rest_time:getParent(),self.rest_time , 10 )

	end 
	global.netRpc:addHeartCall(function() 
		if not self.data then return end 
		call()
	end ,self)
	call()
end


function UIHeroExpTimeItem:onExit()

	global.netRpc:delHeartCall(self)
end

--CALLBACKS_FUNCS_END

return UIHeroExpTimeItem

--endregion

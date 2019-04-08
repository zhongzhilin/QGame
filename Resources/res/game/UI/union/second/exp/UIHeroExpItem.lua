--region UIHeroExpItem.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroExpItem  = class("UIHeroExpItem", function() return gdisplay.newWidget() end )

function UIHeroExpItem:ctor()
    self:CreateUI()
end

function UIHeroExpItem:CreateUI()
    local root = resMgr:createWidget("hero_exp/exp_add_node")
    self:initUI(root)
end

function UIHeroExpItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/exp_add_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time_export
    self.exp_add = self.root.exp_add_export

--EXPORT_NODE_END
end

function UIHeroExpItem:setData(data)

	-- if data.time > 60 then 

	--  	local time = data.time - (data.time % 30)

	--  	local h  = time  / 60 

	--  	time = time - h  * 60 

	--  	if time == 30 then 
	--  		h = h..".5"
	--  	end 
  
    local time = global.funcGame.formatTimeToTime(data.time,true)
	-- local str = global.funcGame.formatTimeToHMSByLargeTime()
	self.time:setString(global.luaCfg:get_local_string("%s:%02d:%02d",time.hour,time.minute,time.second))

	-- 	self.time:setString(h..global.luaCfg:get_local_string(10087))
	-- 	self.exp_add:setString("+"..data.speed)	
	-- else
	self.exp_add:setString("+"..data.speed.." exp")
	-- end 

	-- global.tools:adjustNodePos(self.time , self.exp_add)

end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIHeroExpItem

--endregion

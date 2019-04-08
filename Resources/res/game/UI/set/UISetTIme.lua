--region UISetTIme.lua
--Author : untory
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISetTIme  = class("UISetTIme", function() return gdisplay.newWidget() end )

function UISetTIme:ctor()
    
end

function UISetTIme:CreateUI()
    local root = resMgr:createWidget("settings/server_time_node")
    self:initUI(root)
end

function UISetTIme:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/server_time_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.sever_time = self.root.sever_time_export
    self.time2 = self.root.time2_export
    self.time_node = self.root.time_node_mlan_4_export

--EXPORT_NODE_END

    self:checkTime()
end

function UISetTIme:onExit()
	
	if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)        
    end
end

function UISetTIme:onEnter()
	
	self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime() 
    end, 1)
    self:checkTime()
end


function UISetTIme:checkTime()

    self.time_node:setVisible(false)
    self.time2:setVisible(false)

    local time = global.funcGame.formatTimeToTime(global.dataMgr:getServerTime(),true)
	-- local str = global.funcGame.formatTimeToHMSByLargeTime()
    if self.mode and self.mode == 1 then 
        self.sever_time:setVisible(false)
        self.time_node:setVisible(true)
        self.time2:setVisible(true)
        self.time2:setString(luaCfg:get_local_string("%s:%02d:%02d",time.hour,time.minute,time.second))
        
        -- global.tools:adjustNodePos(self.time2 , self.time2:getParent())       
    else 
       self.sever_time:setString(luaCfg:get_local_string("%s %s-%s-%s %s:%02d:%02d",luaCfg:get_local_string(10483),time.year,time.month,time.day,time.hour,time.minute,time.second))
    end 
    --世界时间  %s-%s-%s %s:%s:%s
end


function UISetTIme:setMode(mode)
    self.mode = mode 
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISetTIme

--endregion

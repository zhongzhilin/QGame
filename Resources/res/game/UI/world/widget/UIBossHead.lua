--region UIBossHead.lua
--Author : Untory
--Date   : 2018/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBossHead  = class("UIBossHead", function() return gdisplay.newWidget() end )

function UIBossHead:ctor()
   self:CreateUI() 
end

function UIBossHead:CreateUI()
    local root = resMgr:createWidget("world/world_boss_time")
    self:initUI(root)
end

function UIBossHead:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_boss_time")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.timeNode = self.root.timeNode_export
    self.stale = self.root.timeNode_export.stale_export
    self.time = self.root.timeNode_export.time_export
    self.name = self.root.timeNode_export.name_export

--EXPORT_NODE_END
end

function UIBossHead:setData(time,state,name)    
    self.endTime = time
    self.state = state

    self.name:setString(name)
    self:startCheckTime()

    if state == 0 then
        self.time:setTextColor(cc.c3b(223,58,26))
        self.stale:setString(luaCfg:get_local_string(11044))
    else
        self.time:setTextColor(cc.c3b(87,213,63))
        self.stale:setString(luaCfg:get_local_string(11043))
    end
end

function UIBossHead:startCheckTime()

    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime()
    end, 1) 
    self:checkTime()
end
function UIBossHead:onExit()
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end
function UIBossHead:checkTime()
    local contentTime = self.endTime - global.dataMgr:getServerTime()
    if contentTime < 0 then contentTime = 0 end
    local str = global.troopData:timeStringFormat(contentTime)
    self.time:setString(str)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBossHead

--endregion

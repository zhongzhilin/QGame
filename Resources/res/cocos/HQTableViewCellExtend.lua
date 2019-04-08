
HQTableViewCellExtend = class("HQTableViewCellExtend")
HQTableViewCellExtend.__index = HQTableViewCellExtend

function HQTableViewCellExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, WidgetExtend)
    target:setNodeEventEnabled(true)
    return target
end

-- event map
function HQTableViewCellExtend:getEventMap()
    self.EXTEND_EVENT_MAP = self.EXTEND_EVENT_MAP or {}
    return self.EXTEND_EVENT_MAP
end

function HQTableViewCellExtend:addEventListener(eventType, func)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        self:removeEventListener(eventType)
    end
    map[eventType] = gevent:addListener(eventType, func)
end

function HQTableViewCellExtend:removeEventListener(eventType)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        gevent:removeListener(map[eventType])
        map[eventType] = nil
    end
end

function HQTableViewCellExtend:removeAllEventListener()
    local map = self:getEventMap()
    for k, v in pairs(map) do
        gevent:removeListener(v)
        map[k] = nil
    end
end

-- schedule map
function HQTableViewCellExtend:getScheduleMap()
    self.EXTEND_SCHEDULE_MAP = self.EXTEND_SCHEDULE_MAP or {}
    return self.EXTEND_SCHEDULE_MAP
end

function HQTableViewCellExtend:schedule(func, interval, times)
    interval = interval or 0.025
    times = times or -1
    local map = self:getScheduleMap()
    if map[func] ~= nil then
        self:unschedule(map[func].scheduleId)
    end
    map[func] = { totalTimes = times, remainTime = times }
    local warpFunc = function(dt)
        -- body
        if map[func].totalTimes > 0 then
            map[func].remainTime = map[func].remainTime - 1
            if map[func].remainTime == 0 then
                self:unschedule(func)
            end
        end
        func(dt)
    end
    map[func].scheduleId = gscheduler.scheduleGlobal(warpFunc, interval)
end

function HQTableViewCellExtend:unschedule(func)
    local map = self:getScheduleMap()
    if func ~= nil and map[func] ~= nil then
        gscheduler.unscheduleGlobal(map[func].scheduleId)
        map[func] = nil
    end
end

function HQTableViewCellExtend:unscheduleAll()
    local map = self:getScheduleMap()
    for k, v in pairs(map) do
        gscheduler.unscheduleGlobal(v.scheduleId)
        map[k] = nil
    end
end

function HQTableViewCellExtend:onEnter()
end

function HQTableViewCellExtend:onExit()
end

function HQTableViewCellExtend:onEnterTransitionFinish()
end

function HQTableViewCellExtend:onExitTransitionStart()
end

function HQTableViewCellExtend:onCleanup()
end

function HQTableViewCellExtend:setNodeEventEnabled(enabled, handler)
    if enabled then
        if not handler then
            handler = function(event)
                if event == "enter" then
                    self:onEnter()
                elseif event == "exit" then
                    self:onExit()
                elseif event == "enterTransitionFinish" then
                    self:onEnterTransitionFinish()
                elseif event == "exitTransitionStart" then
                    self:onExitTransitionStart()
                elseif event == "cleanup" then
                    self:onCleanup()
                end
            end
        end
        self:registerScriptHandler(handler)
    else
        self:unregisterScriptHandler()
    end
    return self
end
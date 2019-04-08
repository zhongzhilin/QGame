
WidgetExtend = class("WidgetExtend")
WidgetExtend.__index = WidgetExtend

function WidgetExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, WidgetExtend)
    return target
end

-- event map
function WidgetExtend:getEventMap()
    self.EXTEND_EVENT_MAP = self.EXTEND_EVENT_MAP or {}
    return self.EXTEND_EVENT_MAP
end

function WidgetExtend:addEventListener(eventType, func)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        self:removeEventListener(eventType)
    end
    map[eventType] = gevent:addListener(eventType, func)
end

function WidgetExtend:removeEventListener(eventType)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        gevent:removeListener(map[eventType])
        map[eventType] = nil
    end
end

function WidgetExtend:removeAllEventListener()
    local map = self:getEventMap()
    for k, v in pairs(map) do
        gevent:removeListener(v)
        map[k] = nil
    end
end

-- schedule map
function WidgetExtend:getScheduleMap()
    self.EXTEND_SCHEDULE_MAP = self.EXTEND_SCHEDULE_MAP or {}
    return self.EXTEND_SCHEDULE_MAP
end

function WidgetExtend:schedule(func, interval, times)
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

function WidgetExtend:unschedule(func)
    local map = self:getScheduleMap()
    if func ~= nil and map[func] ~= nil then
        gscheduler.unscheduleGlobal(map[func].scheduleId)
        map[func] = nil
    end
end

function WidgetExtend:unscheduleAll()
    local map = self:getScheduleMap()
    for k, v in pairs(map) do
        gscheduler.unscheduleGlobal(v.scheduleId)
        map[k] = nil
    end
end

function WidgetExtend:updateGuide(name)
    local guideName = name or self:getName()
    if guideName then
        gevent:call(global.gameEvent.UPDATE_GUIDE, guideName)
    end
end

function WidgetExtend:onEnter()
end

function WidgetExtend:onExit()
end


function WidgetExtend:onExitWrap()
    self:removeAllEventListener();
    self:unscheduleAll();
end

function WidgetExtend:onEnterTransitionFinish()
end

function WidgetExtend:onExitTransitionStart()
end

function WidgetExtend:onCleanup()
end

function WidgetExtend:setNodeEventEnabled(enabled, handler)
    if enabled then
        if not handler then
            handler = function(event)
                if event == "enter" then
                    self:onEnter()
                elseif event == "exit" then
                    self:onExitWrap()
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
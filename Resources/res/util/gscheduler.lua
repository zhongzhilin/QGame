
---@classdef gscheduler
gscheduler = {}

local sharedScheduler = cc.Director:getInstance():getScheduler()
gscheduler.sharedScheduler = sharedScheduler
local handles = {}

function gscheduler.scheduleUpdateGlobal(listener)
    local th = sharedScheduler:scheduleScriptFunc(listener, 0, false)
    handles[th] = true
    return th
end

function gscheduler.scheduleGlobal(listener, interval)
    local th = sharedScheduler:scheduleScriptFunc(listener, interval, false)
    handles[th] = true
    return th
end

function gscheduler.unscheduleGlobal(handle)
    if handle and  handles and handles[handle] then
        handles[handle] = nil
    end  
    sharedScheduler:unscheduleScriptEntry(handle)
end

function gscheduler.unscheduleAll()
    if not handles then return end
    for handle,v in pairs(handles) do
        gscheduler.unscheduleGlobal(handle)
    end
end

function gscheduler.performWithDelayGlobal(listener, time)
    local handle
    handle = gscheduler.scheduleGlobal(function(dt)
        gscheduler.unscheduleGlobal(handle)
        listener(dt)
    end, time)
    return handle
end

function gscheduler.performWithDelayGlobalBindTarget(target,listener,time)
    if not target then return end
    target:runAction(cc.Sequence:create(
        cc.DelayTime:create(time),
        cc.CallFunc:create(listener)
        )
    )
end

local _Manager = {}

local global = global
local dataMgr = global.dataMgr
local id

local scheduleList = nil
local onceScheduleList = {}

local checktime = 0--每秒一次
local interCfg = 
{
    0,
    1,
    10,
    60,    
    300,
    600,
    3600,
    86400,
}

function _Manager.onLooHandler(delta)
	--server time
    for k,v in pairs(scheduleList) do
        v.time = v.time - delta
        if v.time < 0 then
            v.time = interCfg[k]
            for k,s in pairs(v.schedule) do
                s.callBack(delta)
                if s.count then
                    s.count = s.count - 1
                    if s.count == 0 then
                        v.schedule[k] = nil
                    end
                end
            end
        end
    end    

    checktime = checktime - delta
    if checktime < 0 then
        checktime = 1
        local sysTime = dataMgr:getServerTime()
        for k,v in pairs(onceScheduleList) do
            if sysTime > v.endTime then
                onceScheduleList[k] = nil
                v.callBack()                
            end
        end
    end
    
    global.dataMgr:update(delta)

end

function _Manager.registOnceSchedule(callback, endtime)    
    for k,v in pairs(onceScheduleList) do
        if v.callBack == callback then
            v.endTime = endtime
            return
        end
    end
    local schedule = {}
    schedule.callBack = callback
    schedule.endTime = endtime
    table.insert(onceScheduleList, schedule)
end

function _Manager.registSchedule(callback, interval, count)
    if scheduleList == nil then
        scheduleList = {}
        for k,v in ipairs(interCfg) do
            scheduleList[k] = {}
            scheduleList[k].time = v
            scheduleList[k].schedule = {}
        end
    end
    local schedule = {}
    schedule.callBack = callback
    schedule.count = count
    if interval then
        for k,v in ipairs(interCfg) do
            if interval < v then
                table.insert(scheduleList[k - 1].schedule, schedule)
                return
            end
        end
    end
end

function _Manager.logOff()    
    
end

function _Manager.startup()
	if id == nil then
		id = gscheduler.scheduleGlobal(_Manager.onLooHandler, 0)
	end
    
    _Manager.registSchedule(global.gameReq.SyncProfile,300)
end

function _Manager:shutdown()
	if id ~= nil then
		gscheduler.unscheduleGlobal(id)
		id = nil
	end
    scheduleList = {}
end

global.scheduleMgr = _Manager

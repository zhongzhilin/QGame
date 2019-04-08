
local ctime = require "ctime"

---@classdef datetime
local datetime = {}

function datetime.now()
    local rets = {ctime.now()}
    return {
        secs = rets[1],
        year = rets[2],
        month = rets[3],
        day = rets[4],
        hour = rets[5],
        min = rets[6],
        sec = rets[7],
        wday = rets[8],
        yday = rets[9],
    }
end

function datetime.clock()
    return ctime.clock()
end

function datetime.utc()
    return math.floor(ctime.clock())
end

function datetime.sleep(ms)
    ctime.sleep(ms)
end

function datetime.totm(sec)
    local rets = {ctime.totm(sec)}
    return {
        secs = rets[1],
        year = rets[2],
        month = rets[3],
        day = rets[4],
        hour = rets[5],
        min = rets[6],
        sec = rets[7],
        wday = rets[8],
        yday = rets[9],
    }   
end

function datetime.togmtm(sec)
    local rets = {ctime.togmtm(sec)}
    return {
        secs = rets[1],
        year = rets[2],
        month = rets[3],
        day = rets[4],
        hour = rets[5],
        min = rets[6],
        sec = rets[7],
        wday = rets[8],
        yday = rets[9],
    }   
end

function datetime.tosvrgmtm(sec)
    return datetime.togmtm(sec + 8 * 3600)
end

function datetime.fmt(param)
    local t = nil
    if param then
        local ptype = type(param)
        if ptype == "table" then
            t = param
        elseif ptype == "number" then
            t = datetime.totm(param)
        else
            return ""
        end
    else
        t = datetime.now()
    end
    return string.format("%02d%02d%02d%02d%02d", t.year-2000, t.month, t.day, t.hour, t.min, t.sec)
end

function datetime.fmtf()
    local t = datetime.now()
    local f = (t.secs - math.floor(t.secs)) * 1000000 
    return string.format("%02d%02d%02d %02d:%02d:%02d.%06d", t.year-2000, t.month, t.day, t.hour, t.min, t.sec, f)
end

function datetime.daynum()
    local tm = datetime.now()
    return 10000 * (tm.year-2000) + 100 * tm.month + tm.day
end

function datetime.hournum()
    local tm = datetime.now()
    return 1000000 * (tm.year-2000) + 10000 * tm.month + 100 * tm.day + tm.hour
end

local SECS_ONE_DAY = 86400

-- 当前已过去的秒数
function datetime.get_passed_secs_inday(tm)
    -- 加8小时是因为处于东八区，uinx时间从1970-1-1 8:00开始
    return (tm % SECS_ONE_DAY + 8 * 3600) % SECS_ONE_DAY
end

return datetime


local hqnetlib = require "hqnetlib"
local datetime = require "datetime"

local _T = { tstart = 0 }

-- g_profi:time_start()
function _T:time_start()
    self.tstart = datetime.clock()
    self.m_times = 0
end

-- g_profi:time_show()
function _T:time_show(logput,adstr)
    local tend = datetime.clock()
    local t = tend - self.tstart
    if t > 0.001 and logput then
        log.profi("TIME STAT:%d, name:%s, dt:%s/s",self.m_times, adstr, t)
        -- print(debug.traceback())
        self.m_times = self.m_times+1
    end
    self.tstart = tend
    return math.floor(t*1000)
end

function _T:time_end(times)
    local tend = datetime.clock()
    local t = tend - self.tstart
    local qps = 9999999999
    if t > 0 then
        qps = times/t
    end
    log.debug("TIME STAT, start:%s, end:%s, qps:%d/s", self.tstart, tend, qps)
end

function _T:run()
    local t = datetime.now()
    local sec = math.floor(t.secs)
    local tnow = datetime.totm(sec+3600)
    log.debug(datetime.clock())
    log.debug(datetime.fmt(tnow))
    log.debug(datetime.fmt(sec))
    log.debug(datetime.fmt())
    log.debug("sleep 1 sec")
    datetime.sleep(1000)
    log.debug("ok")
    
    local times = 10000000
    log.debug("test os.clock()")
    self:time_start()
    for i=1,times do
        os.clock()
    end
    self:time_end(times)
    log.debug("test datetime.clock()")
    self:time_start()
    for i=1,times do
        datetime.clock()
    end
    self:time_end(times)
end

g_profi = _T
return _T 



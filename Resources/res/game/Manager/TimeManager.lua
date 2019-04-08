local _M = {}


local TimeResult = {}
local TimeBegin = {}
local datetime = require "datetime"

function _M.Begin(name)
    TimeBegin[name] = datetime.now().secs
    -- log.debug("----TimeTest---- %s Begin %0.3f", name, TimeBegin[name])
end

function _M.End(name)
    if TimeBegin[name] == nil then
        return
    end
    local ends = datetime.now().secs
    local begins = TimeBegin[name] or 0
    
    TimeResult[name] = TimeResult[name] or {total = 0, times = 0}
    local result = TimeResult[name]
    
    result.total = result.total + ends - begins
    result.times = result.times + 1
    result.last = ends - begins
    -- log.debug("----TimeTest---- %s End %0.3f, total %.3f", name, ends, ends - begins)
end

function _M.ShowResult(name)
    if TimeResult[name] == nil then
        return
    end
    local result = TimeResult[name]
    log.debug("----TimeTest---- %s use time %f, total:%f, times:%d, Average:%f", name, result.last, result.total, result.times, result.total / result.times)
end

function _M.ShowAllResult()
    for k,v in pairs(TimeResult) do
        log.debug("----TimeTest---- %s use time %f, total:%f, times:%d, Average:%f", k, v.last, v.total, v.times, v.total / v.times)
    end
end

function _M.Reset()
    TimeResult = {}
end

global.timeMgr = _M


local datetime = require "datetime"

local _M = {}

_M.LALL    = 0 
_M.LTRACE  = 9
_M.LDEBUG  = 10
_M.LNOTICE = 11
_M.LINFO   = 12
_M.LWARN   = 13
_M.LERROR  = 14

_M.LFATAL  = 16
_M.LPROFI  = 17

_M.level  = _M.LFATAL
_M.bnet   = false
_M.logsvr = {ip = "127.0.0.1", port = 11001}
_M.device = "INVALID DEVICE"
_M.dbgcall = nil
_M.prefix = ""

local i_echo = echo

function _M.echo(tag, lv, fmt, ...)
    local str = ""
    local allargs = { ... }       
    str = string.wformat("[%s|%s] %s", string.upper(tostring(tag)), os.date("%Y-%m-%d %H:%M:%S", os.time()), string.wformat(tostring(fmt), unpack(allargs)))

    i_echo(str)

    if _M.bnet then
        _M.netrace(str)
    end
    if _M.dbgcall then
        _M.dbgcall(str) 
    end
end

function _M.netrace(str)
    --TODO
end

function _M.set_loglevel(lv)
    _M.level = lv
end

function _M.isTrace()
    return _M.level == _M.LTRACE
end

function _M.get_loglevel()
    return _M.level
end

function _M.set_prefix(prefix)
    assert(type(prefix) == "string")
    _M.prefix = prefix
end

function _M.set_net(on, ip, port, device)
    if on then
        _M.bnet = on
        _M.logsvr.ip = ip or "127.0.0.1"
        _M.logsvr.port = port or 11001
        _M.device = device or "INVALID DEVICE"
    else
        _M.bnet = on
    end
end

function _M.fatal(fmt, ...)
    if _M.level <= _M.LFATAL then
      _M.echo("FAT", _M.LFATAL, fmt, ...)
      i_echo(debug.traceback("", 2))
    end
end

function _M.profi(fmt, ...)
    if _M.level <= _M.LPROFI then
      _M.echo("PROFI", _M.LPROFI, fmt, ...)
    end
end

function _M.error(fmt, ...)
    if _M.level <= _M.LERROR then
      _M.echo("ERROR", _M.LERROR, fmt, ...)
    end
end

function _M.warn(fmt, ...)
    if _M.level <= _M.LWARN then
        _M.echo("WARN", _M.LWARN, fmt, ...)
    end
end

function _M.info(fmt, ...)
    if _M.level <= _M.LINFO then
        _M.echo("INFO", _M.LINFO, fmt, ...)
    end
end

function _M.debug(fmt, ...)
    if _M.level <= _M.LDEBUG then
        _M.echo("DEBUG", _M.LDEBUG, fmt, ...)
    end
end

function _M.trace(fmt, ...)
    if _M.level <= _M.LTRACE then
        _M.echo("TRACE", _M.LTRACE, fmt, ...)
    end
end

function _M.setdbgcall(callFunc)
    _M.dbgcall = callFunc
end

function _M.reportError(title, content)
    local curPlatform = CCApplication:sharedApplication():getTargetPlatform()
    require("util.cocos2dx")
    if cc.IsMobilePhone() and onLuaException then
        onLuaException(title, content)
    end
end

log = _M


---@classdef gluadbg
gluadbg = {}

gluadbg.host = "default"
gluadbg.conn = nil
gluadbg.cfg  = nil
gluadbg.logger = nil
gluadbg.device_plat = "win"
gluadbg.device_root = "[INVALID PATH]"

local app_cfg = require("app_cfg")

function gluadbg.init(host)
    gluadbg.set(host)
end

function gluadbg.set(host)
    if host == nil then
        host = app_cfg.default_host()
    end
    
    gluadbg.host = host or "default"
    gluadbg.cfg = app_cfg.get_cfg(gluadbg.host)
    
    local sharedApplication = CCApplication:sharedApplication()
    local target = sharedApplication:getTargetPlatform()
    if target == kTargetWindows then
        gluadbg.device_plat = "win"
    else
        gluadbg.device_plat = "unix"
    end
    
    gluadbg.device_root = CCHgame:GetLuaDeviceRoot() or "[INVALID PATH]"
    gluadbg.develop_root = gluadbg.cfg.path
    if gluadbg.device_plat == "win" then
        gluadbg.develop_root = string.gsub("\\" .. gluadbg.device_root .. "\\", "\\", "/")
    end
    
    --gluadbg.logger = CCLuaLog
end

function gluadbg.zbstart()
    require("mobdebug").start()
end

function gluadbg.ldtstart(host)
    host = host or "default"
    if host ~= gluadbg.host then
        gluadbg.set(host)
    end
    
    log.debug("DEV ROOT::" .. gluadbg.develop_root)
    log.debug("LUA ROOT::" .. gluadbg.device_root)
    log.debug("DBG SERVER:host:%s,ip:%s,port:%s", gluadbg.host, gluadbg.cfg.ip, gluadbg.cfg.port)
    
    gluadbg.conn = require("external.debugger")
    
    local function dbgstart()
        gluadbg.conn(gluadbg.cfg.ip, gluadbg.cfg.port, gluadbg.cfg.key, 
                    nil, gluadbg.device_plat, gluadbg.device_root)    
    end
    
    local st, err = pcall(dbgstart)
    if st == false then
        log.debug("Lua debug connect failed, host:%s, ip:%s", gluadbg.host, gluadbg.cfg.ip)
        log.debug("Error info:%s", err)
        gluadbg.conn = nil
    end

end

function gluadbg.stop()
end

local function cocos_parse_class(cls, tb, f)
    local mt = getmetatable(tb)
    if mt ~= nil then
        cocos_parse_class(cls, mt, f)
    end
    for k, v in pairs(tb) do
        if type(v) == "function" and k ~= "end" then
            local first = string.sub(k, 1, 1)
            if  first ~= "_" and first ~= "."  then
                if k == "create" then
                    f:write(string.format("---\n-- @return @class %s\n--\n", cls))
                end
                f:write(string.format("function %s:%s() end \n", cls, k))
            end
        end
    end   
end

function gluadbg.assist()
    
    local assist_path = CCHgame:GetLuaDeviceRoot() .. "/tags/"
    
    -- class and function
    for k,v in pairs(_G) do
        if type(v) == "table" then
            -- cocos class list TODO
            local firstChar = string.byte(k, 1)
            if firstChar >= string.byte("A") and firstChar <= string.byte("Z") then 
                --log.debug("got cocos class:%s", k)
                local assitFile = io.open(assist_path .. k .. ".lua", "w")
                assitFile:write(string.format("---@classdef %s\n", k))
                assitFile:write(string.format("%s = {}\n", k))
                cocos_parse_class(k, v, assitFile)
                assitFile:close()
            end
        end
    end
    
    local assitFile = io.open(assist_path .. "Define.lua", "w")
    -- functions
    assitFile:write("-- function\n")
    for k,v in pairs(_G) do
        if type(v) == "function" then
            if string.startswith(k, "cc") or string.startswith(k, "GCF") then
                assitFile:write(string.format("function  %s() end\n", k))
            end
        end
    end
    
    -- define
    assitFile:write("-- cocos2dx const\n")
    for k,v in pairs(_G) do
        if type(v) == "number" then
            assitFile:write(string.format("%s = %s\n", k, v))
        end
    end
    assitFile:close()
    
end

function gluadbg.is_boot_dbg()
    return app_cfg.bootdbg or false
end

function gluadbg.showMemoryUsage()
    log.debug( string.format("LUA VM MEMORY USED: %0.2f KB", collectgarbage("count")) )
end

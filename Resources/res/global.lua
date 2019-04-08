
---@classdef global
global = {
    LOCAL   = false, -- 是否本地版本
    
    RELEASE = false, -- 是否是发布版本

    OPENGUIDE = true, --是否开启引导
    
    maincity_fg_scale = 1.55,
    maincity_bg_scale = 0.5,
    maincity_fg_cloud_speed = 0.05,

    m_startTime = nil,
    m_serverTime = nil,

    game_fps = nil,
    isloadOver = false,

    isReplay = false,
    badNetTimes = 0,
    badNetDt = 0,
}

local __xpcall = _G.xpcall
_G.xpcall = function(hdl, err, ... )
    local params = { ... }
    local xpcallWrap = function()
        return hdl(unpack(params))
    end
    return __xpcall(xpcallWrap, err)
end

-- 改写pcall，捕获导出接口发生异常时的信息
local __pcall = _G.pcall
_G.pcall = function(f, ...)
    return xpcall(f, hqxpcall_error, ...)
end
_G.sys_pcall = __pcall

local random = math.random
math.random = function( ... )
    local params = { ... }
    if #params <= 1 or #params > 2 then
        return random(unpack(params))
    end
    if params[2] <= params[1] then
        return params[1]
    end
    return random(unpack(params))
end

local format = string.format
string.wformat = function( ... )
    local params = { ... }

    if #params >= 1 then

        local fmt = params[1]
        local fmtArgsNum = 0
        local startPos, endPos = string.find(fmt, "%%.")
        while(startPos)
        do
            local subStr = string.sub(fmt, startPos, endPos)
            fmtArgsNum = fmtArgsNum + 1
            if subStr == "%f" then
                params[fmtArgsNum + 1] = format(subStr, params[fmtArgsNum + 1] or 0)
            elseif subStr == "%s" and type(params[fmtArgsNum + 1]) == "number" then
                params[fmtArgsNum + 1] = format(subStr, params[fmtArgsNum + 1])
            end
            startPos, endPos = string.find(fmt, "%%.", endPos)
        end

        params[1] = string.gsub(params[1], "%%f", "%%s") 
        params[1] = string.gsub(params[1], "%%d", "%%s") 
    end

    if #params > 1 then

        for i = 2, #params do
            if type(params[i]) == "number" then
                params[i] = format("%d", params[i])
            end
            params[i] = tostring(params[i])
        end
    end

    params[#params + 1] = params[#params + 1] or "nil"
    params[#params + 1] = params[#params + 1] or "nil"
    params[#params + 1] = params[#params + 1] or "nil"
    params[#params + 1] = params[#params + 1] or "nil"
    params[#params + 1] = params[#params + 1] or "nil"
    
    return format(unpack(params))
end

--------------------------------------------------------------------------------------------- 
-- 全局LUA函数定  
---------------------------------------------------------------------------------------------

-- 打印全局错误处理
-- function __G__TRACKBACK__(errorMessage)
--     local dbginfo = debug.traceback(errorMessage)
--     CCLuaLog("----------------------------------------")
--     --CCLuaLog("LUA ERROR: "..tostring(errorMessage).."\n")
--     CCLuaLog("LUA ERROR: " .. dbginfo)
--     require("util.cocos2dx")
--     local appVersion = require("app_ver")
--     local testinDbgInfo = string.format("[version %s] %s", appVersion, dbginfo)
--     if cc.IsMobilePhone() then
--         CCLuaLog("LUA ERROR: onLuaException")
--         onLuaException(tostring(errorMessage), testinDbgInfo)
--     end
--     CCLuaLog("----------------------------------------")

--     global.netRpc:OssLog(WPBCONST.ENOSS_CLILUAERR, testinDbgInfo)
    
--     if cc.IsMobilePhone() then
--         local data = {
--                 title = "", 
--                 content = global.luaCfg:get_local_string(10900), 
--                 pvpnotify = {
--                     name = global.luaCfg:get_local_string(10818),
--                     handler = function() global.funcGame.RestartGame() end,
--                 }
--             } 

--         global.panelMgr:openPanel("UISystemMessagePanel"):setData(data)
--     else
--         GLFShowLuaError(dbginfo)
--     end
-- end

--- lua全局变量定义约定  
--- LUA全局函数 除了 common中定义的部分函数外 原则上都已 GLFXxxxYxxx 格式定义 

--C++ 调用Lua函数唯一入口
function GLFRun(name, ...)
    log.debug("GLFRun lua function:%s", name)
    -- 查找对象及函数
    local fields = string.split(name, '.')
    local callobj = nil
    for _, v in pairs(fields) do
        local parent = callobj or _G
        callobj = parent[v]
        if callobj == nil then
            break
        end
    end
    
    
    -- 调用
    local result = {}
    if callobj == nil then
        result.ERROR = 1
    elseif type(callobj) ~= "function" then
        result.ERROR = 2
    else
        result = {callobj(...)}
--        local str = vardump(result)
--        log.debug(str)
    end
    
    -- 返回
    local json = require "json"
    return json.encode(result)
end

-- 全局变量定义检查
local dbginfo   = debug.getinfo
local sysrawset, sysprint, syseror = rawset, print, error
local varinfo = {}
function GLFReadOnly(tbTarget, tbReadOnlyFields, bPrint)
    bPrint = bPrint or false
    if bPrint == true then
        for vk,vv in pairs(varinfo) do
            for _, inf in pairs(vv) do
                sysprint(string.format("global var in lua:%s, %s:%s", vk, inf[1], inf[2]))
            end
        end
        return
    end
    
    local proxy = tbTarget or {}
    local mt = {
        --__index = tbTarget,
        __newindex = function(_, k, v)
            if tbReadOnlyFields[k] then
                syseror("attempt to update a read-only table", 2)
            else
                local info = dbginfo(2, "Sl")
                if varinfo[k] == nil then
                    varinfo[k] = {}
                end
                table.insert(varinfo[k], {info.short_src, info.currentline})
                --sysprint("------------------------------:" .. k)
                sysrawset(tbTarget, k, v)
            end
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

if _DEBUG then
    GLFReadOnly(_G, {})
end

-- 文件加载  TODO 修改实现 
function GLFRequire(mod, reload)
    if reload == true and package.loaded[mod] ~= nil  then
        package.loaded[mod] = nil
    end
    return require(mod)
end

-- GLRLoadProject
-- @param #string parent 如果加载根目录文件 parent 为 "" 
function GLFLoadProject(parent, reload, loadArr) 
    parent = parent or ""
    reload = reload or false
    
    local mod_prefix = ""
    if parent ~= "" then
        mod_prefix = parent .. "."
    end
    
    local list_mod = mod_prefix .. "_plist"  
    local file_list = GLFRequire(list_mod)
    
    for k,v in ipairs(file_list) do 
        if string.sub(v, #v) == "/" then
            parent = mod_prefix .. string.sub(v, 1, #v-1)
            GLFLoadProject(parent, reload, loadArr)
        else
            --log.debug("load lua: " .. v )
            if loadArr ~= nil and type(loadArr) == "table" then
                table.insert(loadArr, mod_prefix .. v)
            else
                GLFRequire(mod_prefix .. v, reload)
            end
        end
    end
end

-- 延迟一帧调用函数
function global.delayCallFunc(callFunc, object, delayTime)

    local scheduleID = nil

    local scheduleHandler = function()
        gscheduler.unscheduleGlobal(scheduleID)
        
        if callFunc then
            if object then
                callFunc(object)
            else
                callFunc()
            end
        end
    end
    
    scheduleID = gscheduler.scheduleGlobal(scheduleHandler, delayTime or 0)
    return scheduleID
end

function global.stopDelayCallFunc(scheduleID)
    if scheduleID then
        gscheduler.unscheduleGlobal(scheduleID)
    end
end

function global.initResPath()
    local resPath = {
        "asset", 
        "asset/xml", 
        "asset/ui", 
        "asset/map", 
        "asset/sound", 
        "asset/config",
        "asset/fonts",
        "asset/effect",
        "asset/logo",
        "res/external",
        }
    
    -- local curVerDir = ResUpdateManager:getCurVerDir()
    local curVerDir = ""
    -- local patchDir = ResUpdateManager:getPatchDir()
    local patchDir = ""
    local fileUtils = cc.FileUtils:getInstance()
    -- local writablePath = fileUtils:getWritablePath() .. patchDir.. curVerDir
    -- for _,v in ipairs(resPath) do 
    --     fileUtils:addSearchPath(writablePath .. v)
    -- end

    for _,v in ipairs(resPath) do 
        fileUtils:addSearchPath(v)
    end
end

function global.reportOnce(title, content)
    local userDefault = CCUserDefault:sharedUserDefault()

    if userDefault:getStringForKey(content) ~= "1" then
        userDefault:setStringForKey(content, "1")
        userDefault:flush()
        title = title .. global.luaCfg:get_local_string(10819) .. GLFGetChanID() .. global.luaCfg:get_local_string(10820) .. GLFGetAppVer()      
        log.debug("===========> reportOnce content %s, title %s", content, title)
    end
end

function global.handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end
--底层的发布版本宏
_CPP_RELEASE = CCHgame:IsRelease()

require("boot_conf")

function __G__TRACKBACK__(errorMessage)
    local dbginfo = debug.traceback(errorMessage,3)
    if _CPP_RELEASE == 1 then
        local tempTxt = "---------------------start-------------------\n"
        tempTxt = tempTxt.."LUA ERROR: "..dbginfo
        tempTxt = tempTxt.."\n--------------------end--------------------"
        -- print("----------------------------------------")
        -- print("LUA ERROR: " .. dbginfo)
        -- print("----------------------------------------")
        -- SocketTcp:sendCrashMessage(error_txt)
        
        -- post lua错误信息
        if global.ServerData then
            global.ServerData:postErrorLog(tempTxt)
        end

    else
        LogMore:writeAllRecordToFile()
        LogMore:logError("----------------------------------------")
        LogMore:logError("LUA ERROR: " .. dbginfo)
        LogMore:showErrorWindow()
    end

end

local orgin = pairs
pairs = function(table)
    table = table or {} 
    return orgin(table)
end 

local orgin = ipairs
ipairs = function(table)
    table = table or {} 
    return orgin(table)
end 
require("src.config")
require("src.cocos.init")

-- avoid memory leak
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

require("res.common.base.ext.string")
require("res.util.cocos2dx")


if cc.UserDefault:getInstance():getBoolForKey("alertdialog_warning",false) then
    return
end

local fileUtils = cc.FileUtils:getInstance()

if cc.IsMobilePhone() == false and fileUtils:isFileExist("dev") then
    local requireBack = _G.require
    require = function(modname)
        if modname == nil then
            return
        end
        --print("require: ", modname)
        local arr = string.split(modname, ".")
        if arr[#arr] == "lua" then
            table.remove(arr, #arr)
        end

        local arrStr = table.concat(arr, "/")
        local modPath = fileUtils:fullPathForFilename(arrStr  .. ".lua")
        local filePath = modPath
        modPath = string.gsub(modPath, "\\", "/")
        modPath = string.gsub(modPath, "//", "/")
        arr = string.split(modPath, "Resources/")
        modPath = arr[#arr] or ""
        modPath = string.gsub(modPath, "/", ".")

        if filePath ~= nil and fileUtils:isFileExist(filePath) then
            return requireBack(modPath)
        end

        return requireBack(modname)
    end
end

-- 加载基本库
require('global')

global.initResPath()

require('hqnetlib')

-- 加载渠道配置
local chanid = WPBCONST.EN_CHAN_DEFAULT -- default
local worldid = WPBCONST.EN_WORLD_DEV -- default
local st, chan = _G.sys_pcall(require, "app_chan")
if st then 
    chanid = chan.getid()
    worldid = chan.getworld()
end

function GLFGetChanID()
    return chanid
end

function GLFGetWorldID()
    return worldid
end

function co_yield(...)
    return coroutine.yield(...)
end

function co_create(func)
    return coroutine.create(func)
end

local load_ver = function()
        
    local cjson = require "base.pack.json"
    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist("app_ver_update") then

        return cjson.decode(cc.FileUtils:getInstance():getStringFromFile("app_ver_update"))
    else

        return cjson.decode(cc.FileUtils:getInstance():getStringFromFile("app_ver"))
    end
end

local app_ver = {1,0,0,0}
local app_ver_str = "1.0.0.0"
local client_ver = {1,0,0}
local client_ver_str = "1.0.0"
local json = require("json")
local verData = load_ver()

if verData then
    app_ver_str = verData.app_ver    
    client_ver_str = verData.client_ver

    local arr = string.split(app_ver_str,".")
    app_ver = arr

    local c_arr = string.split(client_ver_str,".")
    client_ver = c_arr
end

function GLFGetClientVer()
    return client_ver
end

function GLFGetAppVer()
    if _CPP_RELEASE == 1 then
        return app_ver
    else
        --无敌登陆
        -- return {62131668,57657654,21428418,50228394}
        return {62131668,57657654,21428418,50228395}
    end
end


function GLFGetClientVerStr()
    -- return global.luaCfg:get_local_string(10122, app_ver_str)
    return client_ver_str
end


function GLFGetAppVerStr()
    -- return global.luaCfg:get_local_string(10122, app_ver_str)
    return app_ver_str
end

function GLFSetAppVer(ver)
    app_ver = ver or app_ver
end

local zone_id = 99999
local zone_area = ""
local zone_name = ""
function GLFSetZone(value)
    if value then
        zone_id = value.id
        zone_area = value.area
        zone_name = value.name
    end
end

function GLFGetZoneId()
    return zone_id
end

function GLFGetZoneArea()
    return zone_area
end

function GLFGetZoneName()
    return zone_name
end

function GLFSetZoneName(value)
    zone_name = value
end

local isLoaded = false
function GLFIsProjectLoaded()
    -- body
    return isLoaded
end

-- 加载脚本
local loadArr = {}
GLFLoadProject("", "", loadArr)

-- 调试信息
GLFLoadProject('util')
GLFLoadProject('cocos')
require('game.Rpc.NetRpc')
require('game.Config.LuaConfigMgr')
require('game.Manager.SceneManager')
require('game.Manager.ResManager')
require('game.UI.common.Tools')
gdevice.showInfo()
gsound.initEvents()

require('dev.errpanel')
require('dev.test_ctime')

global.SKIP_LOGO = not (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID)
-- global.SKIP_LOGO = false

-- global.delayCallFunc(function()
    
    local index = 1
    local wrap = {}

    local function glfrequire()
        while(index <= #loadArr) do
            GLFRequire(loadArr[index])
            index = index + 1
            if not global.SKIP_LOGO then
                break
            end
        end
        
        if fileUtils:isFileExist("dev/debugPanel.lua") then
            require('dev.debugPanel')
        end
    end

    local function checkProgress()
        if index > #loadArr then
            isLoaded = true
            return true
        end 
    end

    -- 开始运行 
    xpcall(function()
        -- body
        global.app = require "game.world"
        global.app:startup()
        if global.SKIP_LOGO then 
            glfrequire()
            checkProgress()
            global.app:bootSuccess()
        else
            local scheduleId = nil
            scheduleId = gscheduler.scheduleGlobal(function()
                -- body
                glfrequire()
                if checkProgress() then
                    gscheduler.unscheduleGlobal(scheduleId)
                end
            end, 0)
        end
    end, __G__TRACKBACK__)
-- end)


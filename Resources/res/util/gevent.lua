
---@classdef gevent
gevent = {
    id = 0,
    eventMap = {},
}

-- sdk登陆之后， c++ 回调
function onEnterGameCall(uid, token, channelId, lStatus)

    print(" =====> gevent uid: "..uid)
    print(" =====> gevent token: "..token)
    print(" =====> gevent channelId: "..channelId)
    print(" =====> gevent lStatus: "..lStatus)
    local codeMsg = tonumber(lStatus)
    if codeMsg == 0 then
        global.tipsMgr:showWarning("bind_success")
    elseif codeMsg == 1 then
        global.tipsMgr:showWarning("bind_failed")
    elseif codeMsg == 2 then
        global.tipsMgr:showWarning("remove_bind_success")
    end
end
local app_cfg = require("app_cfg")
local crypto   = require "hqgame"
local cjson = require "base.pack.json"
function gevent_defineportrait_over()
    -- 
    print("------>gevent_defineportrait_over")
    local fileUtils = cc.FileUtils:getInstance()
    local portaitPath = cc.FileUtils:getInstance():getWritablePath().."mine_90086357_definePortrait.png"

    if global.tools:isAndroid() then
        local ss = gluaj.callGooglePayStaticMethod("getAssetsPath",{},"()Ljava/lang/String;")
        portaitPath = ss.."/mine_90086357_definePortrait.png"
    end
    print("---------------<",portaitPath)
    gdisplay.removeImage(portaitPath)
    print("---------------<","11111")
    if fileUtils:isFileExist(portaitPath) then
        gscheduler.performWithDelayGlobal(function()

            print("---------------<","11112")
            -- local sprite = cc.Sprite:create()
            -- sprite:setTexture(portaitPath)
            -- global.panelMgr:addWidgetToSuper(sprite)

            print("---------------<","11113")
            local url = app_cfg.get_serverlist_url()
            print("---------------<",url)
            url = string.gsub(url,"verify.php","ico/upload.php")
            print("---------------<",url)
            url = string.format(url.."?uid=%s&sid=%s",global.userData:getUserId(),global.loginData:getCurServerId())
            print("-------------upload--->",url)
            print(crypto.md5file(portaitPath))
            global.uiMgr:addSceneModel(5,99999)
            gnetwork.uploadFile(function(evt)
                    if evt.name == "completed" then
                        local request = evt.request
                        printf("REQUEST getResponseStatusCode() = %d", request:getResponseStatusCode())
                        printf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
                        printf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
                        printf("REQUEST getResponseString() =\n%s", request:getResponseString())
                        local data = cjson.decode(request:getResponseData())
                        if data then 
                            global.itemApi:diamondUse(function(msg)
                                global.headData:setSdefineHead(data.md5)
                                global.headData:setlCustomIcoCount(1)
                                gevent:call(global.gameEvent.EV_ON_USER_FLUSHUSEMSG)
                                global.uiMgr:removeSceneModal(99999)
                            end,18,nil,nil,nil,nil,data.md5)
                        end 
                    end

                end,
                url,
                {
                    fileFieldName="file",
                    filePath=portaitPath,
                    contentType="Image/jpeg",
                    extra={
                        {"act", "upload"},
                        {"submit", "upload"},
                    }
                }
            )
            global.panelMgr:closePanel("UISdefineHeadPanel")
        end, 0.05)
    else
        log.error("gevent_defineportrait_over--->no picture!!!")
    end
end

local isPause = false
local isJutsForground = false
function gevent_netstate_change(param)
    -- 
    print("------>gevent_netstate_change")
    if global and global.netRpc and not global.netRpc:noRelogin() then
        global.netRpc.mneed_relogin = true
    end
end

function gevent_is_back()
    return isJutsForground
end

local ishandleWarning = false
function gevent_on_memory_warning()
    global.panelMgr:clearRecords()
    --gdisplay.removeUnusedSpriteFrames()
    --gaudio.uncacheAll()
    global.panelMgr:destroyAllCachePanel()

    global.commonApi:sendMemWarningTimes()
    if global.tools:isIos() then
        if not global.scMgr:getChangeState() then
            global.resMgr:unloadMemWarningTextures()
        end
        local totalmem = CCNative:getTotalMemorySize()
        if not ishandleWarning and totalmem and totalmem < 800 then
            ishandleWarning = true
            global.funcGame:checkLowMemToShowPromt(function()
                -- body
                ishandleWarning = false
            end)
        end
    else
        if global.funcGame:isOutofMemMB(WDEFINE.FREE_ANDROID_RES_LIMIT_MEM_LV1) then
            -- 低于100m，要规模释放资源
            if not global.scMgr:getChangeState() then
                global.resMgr:unloadMemWarningTextures()
            end
            if not ishandleWarning then
                ishandleWarning = true
                global.funcGame:checkLowMemToShowPromt(function()
                    -- body
                    ishandleWarning = false
                end)
            end
        end
    end
    gdisplay.removeUnusedSpriteFrames()
end

function gevent_is_no_operate_state()
    local a = global.panelMgr:isPanelOpened("UISystemConfirm")
    local b = global.panelMgr:isPanelOpened("UIMaintancePanel")
    return a or b
end

local noExecBc = false
function gevent_set_no_pause_resume(s)
    noExecBc = s
end

local performHandler = nil
function gevent_onresume()

    global.ClientStatusData:setClientLastResumeTime(os.time())
    global.ClientStatusData:CheckPauseGameTime()

    global.uiMgr:removeSceneModal(109010)
    -- if global.tools:isWindows() or noExecBc then
    --     noExecBc = false
    --     return
    -- end

    if gevent_is_no_operate_state() then
        -- 当网络出现问题时，禁止任何操作
        return
    end

    if not isPause then return end

    -- body
    -- gsound.checkLoopSounds()

    -- if performHandler then
    --     gscheduler.unscheduleGlobal(performHandler)
    --     performHandler = nil
    -- end
    -- if isJutsForground then
    --     performHandler = gscheduler.performWithDelayGlobal(function()
    --         isJutsForground = false
    --     end, 1)
    -- end
    isPause = false
    if global.netRpc:noRelogin() then return end
    print("gevent_onresume()")

    -- local is = cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled")
    -- gaudio.enableSound()
    -- cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",is)
    local okCall = function(isReconnect)
        -- body
        global.techData:resumeDeal()
        gevent:call(global.gameEvent.EV_ON_GAME_RESUME)
        global.unionApi:getRedCount(function() end,nil)
    end
    if global.netRpc:checkConnect(okCall) then
        --只要网络保持通畅，才派发事件
    end
end

function gevent_onpause()
    -- gaudio.stopAllSounds()
    global.ClientStatusData:setClientLastPauseTime(os.time())
    if noExecBc then return end
    isPause = true
    -- isJutsForground = true
    print("gevent_onpause()")
    -- local is = cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled")
    -- gaudio.disableSound()
    -- cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",is)
    -- if performHandler then
    --     gscheduler.unscheduleGlobal(performHandler)
    --     performHandler = nil
    -- end
    if global.netRpc:noRelogin() then return end
    gevent:call(global.gameEvent.EV_ON_GAME_PAUSE)
    
end

function gevent:removeAll()
    self.id = 0
    self.eventMap = {}
end

function gevent:call(event, ...)
    log.trace("$gevent:call event = %s,args=%s",event,vardump(...))
    if event == nil then
        log.trace("%s",vardump(debug.traceback()))
    end
    self:dispatch(event, ...)
end

function gevent:addListener(eventType, callBack, object, priority)
    if priority ~= nil then
        assert(type(priority) == "number", "invalid event priority")
    end
    priority = priority or 99

    local id = self:getID()
    
    local group = self:getGroup(eventType, priority)
    table.insert(group, { id = id, callBack = callBack, object = object }) 

    return { id = id, eventType = eventType, priority = priority }
end

function gevent:removeListener(data)
    local isValidData = (data ~= nil) and (type(data) == "table")
    isValidData = isValidData and (data.id ~= nil) and (type(data.id) == "number")
    isValidData = isValidData and (data.eventType ~= nil)
    isValidData = isValidData and (data.priority ~= nil) and (type(data.priority) == "number")
    
    assert(isValidData, string.format("invalid eventListener data:%s", vardump(data)))

    local group = self:getGroup(data.eventType, data.priority)
    assert(group ~= nil, string.format("invalid event type:%s, priority:%s", data.eventType, data.priority))

    local count = #group
    for i = 1, count do
        local value = group[i]
        if value.id == data.id then
            table.remove(group, i)
            break
        end
    end
    
end

function gevent:dispatch(eventType, ...)
    local event = self.eventMap[eventType]
    if event == nil then 
        return 
    end
    
    for ek,ev in pairs(event) do
        for k,v in pairs(ev) do
            local callBack = v.callBack
            local object = v.object
            if object then
                callBack(object, eventType, ...)
            else
                if callBack then 
                    callBack(eventType, ...)
                end 
            end            
        end
    end
end

function gevent:getID()
    self.id = self.id + 1
    return self.id
end

function gevent:getGroup(_type, priority)
    assert(nil ~= _type,"this eventType == nil,please add it in GameEvent.lua")
    if self.eventMap[_type] == nil then
        self.eventMap[_type] = {}
    end
    
    local event = self.eventMap[_type]
    if event[priority] == nil then
        event[priority] = {}
    end

    return event[priority]
end

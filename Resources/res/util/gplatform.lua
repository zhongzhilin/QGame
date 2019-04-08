---@classdef gplatform
gplatform = {
    eventListenerIdMap = {}
}

function gplatform.initEvents()
    log.debug("gplatform.initEvents()")
	local gevent = gevent
    local gameEvent = global.gameEvent
    
    for _, v in pairs(gplatform.eventListenerIdMap) do
        gevent:removeListener(v)
    end
    
    gplatform.eventListenerIdMap = {}

    gplatform.eventListenerIdMap[gameEvent.EV_ON_SDK_PLATFORM_LOGIN] = gevent:addListener(gameEvent.EV_ON_SDK_PLATFORM_LOGIN, function( ... )
            -- body
            log.debug("1on event %s", vardump({...}))
            gplatform.LoginPlatform(...)
        end)

    gplatform.eventListenerIdMap[gameEvent.EV_ON_SDK_USER_CREATE] = gevent:addListener(gameEvent.EV_ON_SDK_USER_CREATE, function( ... )
            -- body
            log.debug("2on event %s", vardump({...}))
            gplatform.CreateUser(...)
        end)

    gplatform.eventListenerIdMap[gameEvent.EV_ON_SDK_USER_LOGIN] = gevent:addListener(gameEvent.EV_ON_SDK_USER_LOGIN, function( ... )
            -- body
            log.debug("3on event %s", vardump({...}))
            gplatform.LoginUser(...)
        end)

    local talkingDataMap = {
        [gameEvent.EV_ON_TALKING_DATA_REGISTER]       = 1,       --1 注册
        [gameEvent.EV_ON_TALKING_DATA_ENTER_LOGIN]    = 2,       --2 进入登录界面
        [gameEvent.EV_ON_TALKING_DATA_SELECT_SVR]     = 3,       --3 完成选服步骤
        [gameEvent.EV_ON_TALKING_DATA_ENTER_GAME]     = 4,       --4 进入游戏
        [gameEvent.EV_ON_TALKING_DATA_GUIDE_OUT]      = 5,       --5 完成开场引导对话，点击出城
        [gameEvent.EV_ON_TALKING_DATA_NANYANG_1]      = 6,       --6 完成南阳第一关战斗
        [gameEvent.EV_ON_TALKING_DATA_NANYANG_2]      = 7,       --7 完成南阳第二关战斗
        [gameEvent.EV_ON_TALKING_DATA_NANYANG_3]      = 8,       --8 完成南阳第三关战斗
        [gameEvent.EV_ON_TALKING_DATA_NANYANG_END]    = 9,       --9 完成第一章南阳
        [gameEvent.EV_ON_TALKING_DATA_PVP_END]        = 10,      --10 完成第一场PVP
    }   

    for k,v in pairs(talkingDataMap) do
        gplatform.eventListenerIdMap[k] = gevent:addListener(k, function( ... )
            -- body
            log.debug("on talkingDataMap event %s", vardump({...}))
            -- GamePlatform:getInstance():onCustomEvent(v)
        end)
    end
    
    -- [gameEvent.EV_ON_TALKING_DATA_FIRST_OPEN]     = 0,       --0 第一次打开游戏
    local userDefault = cc.UserDefault:getInstance()
    gplatform.eventListenerIdMap[gameEvent.EV_ON_TALKING_DATA_FIRST_OPEN] = gevent:addListener(gameEvent.EV_ON_TALKING_DATA_FIRST_OPEN, function( ... )
        -- body
        log.debug("on talkingDataMap event %s", vardump({...}))

        if userDefault:getStringForKey(gameEvent.EV_ON_TALKING_DATA_FIRST_OPEN) ~= "1" then
            userDefault:setStringForKey(gameEvent.EV_ON_TALKING_DATA_FIRST_OPEN, "1")
            userDefault:flush()
            -- GamePlatform:getInstance():onCustomEvent(0)
        end
    end)
end

function gplatform.LoginPlatform(eventType)
	-- body
    global.delayCallFunc(function()
        log.debug("============> gplatform.LoginPlatform")
        -- GamePlatform:getInstance():platformLogin()
        -- global.funcGame.StartLoginTimeout()
    end, nil, 0.1)
end

function gplatform.CreateUser(eventType, userId, userName, userLv, svrId, svrName, extStr)
	-- body
	-- GamePlatform:getInstance():CreateRole(userId, userName, userLv, svrId, svrName, extStr)
end

function gplatform.LoginUser(eventType, userId, userName, userLv, svrId, svrName, extStr)
	-- body
	-- GamePlatform:getInstance():EnterGame(userId, userName, userLv, svrId, svrName, extStr)
end
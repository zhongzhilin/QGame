
CCSceneExtend = class("CCSceneExtend", CCNodeExtend)
CCSceneExtend.__index = CCSceneExtend

function CCSceneExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, CCSceneExtend)

    local function handler(event)
        if event == "enter" then
            log.debug("Scene \"%s:onEnter()\"", target.name or (target.__cname or "unknown"))
            target:onEnter()
        elseif event == "enterTransitionFinish" then
            target:onEnterTransitionFinish()
        elseif event == "exitTransitionStart" then
            target:onExitTransitionStart()
        elseif event == "cleanup" then
            target:onCleanup()
        elseif event == "exit" then
            log.debug("Scene \"%s:onExit()\"", target.name or (target.__cname or "unknown"))

            if target.autoCleanupImages_ then
                for imageName, v in pairs(target.autoCleanupImages_) do
                    display.removeSpriteFrameByImageName(imageName)
                end
                target.autoCleanupImages_ = nil
            end

            target:onExit()

            if DEBUG_MEM then
                log.debug("----------------------------------------")
                log.debug(string.format("LUA VM MEMORY USED: %0.2f KB", collectgarbage("count")))
                CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
                log.debug("----------------------------------------")
            end
        end
    end
    target:setNodeEventEnabled(true, handler)

    return target
end

function CCSceneExtend:InitBg()
    local sharedDirector         = cc.Director:getInstance()
    local glview = sharedDirector:getOpenGLView()
    local policy = glview:getResolutionPolicy()

    if policy ~= kResolutionFillAll then
        return
    end

    local frameSize = glview:getFrameSize()
    local designSize = glview:getDesignResolutionSize()
    local scaleX = glview:getScaleX()
    local scaleY = glview:getScaleY()

    local maskScaleY = (frameSize.height * (designSize.width / frameSize.width) - designSize.height) / (768 * (designSize.width / 1024.00) - designSize.height)

    local mask = cc.Sprite:create("pad_mask.png")
    self:addChild(mask, 999)
    mask:setAnchorPoint(cc.p(0.5, 0))
    mask:setScaleX(1.005)
    mask:setScaleY(maskScaleY)
    mask:setPosition(cc.p(480 + 1, 640 - 3))

    mask = cc.Sprite:create("pad_mask.png")
    self:addChild(mask, 999)
    mask:setAnchorPoint(cc.p(0.5, 1))
    mask:setScaleX(-1.005)
    mask:setScaleY(maskScaleY)
    mask:setPosition(cc.p(480 - 1, 0 + 3))
end

function CCSceneExtend:markAutoCleanupImage(imageName)
    if not self.autoCleanupImages_ then self.autoCleanupImages_ = {} end
    self.autoCleanupImages_[imageName] = true
    return self
end

-- event map
function CCSceneExtend:getEventMap()
    self.EXTEND_EVENT_MAP = self.EXTEND_EVENT_MAP or {}
    return self.EXTEND_EVENT_MAP
end

function CCSceneExtend:addEventListener(eventType, func)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        self:removeEventListener(eventType)
    end
    map[eventType] = gevent:addListener(eventType, func)
end

function CCSceneExtend:removeEventListener(eventType)
    local map = self:getEventMap()
    if map[eventType] ~= nil then
        gevent:removeListener(map[eventType])
        map[eventType] = nil
    end
end

function CCSceneExtend:removeAllEventListener()
    local map = self:getEventMap()
    for k, v in pairs(map) do
        gevent:removeListener(v)
        map[k] = nil
    end
end

-- schedule map
function CCSceneExtend:getScheduleMap()
    self.EXTEND_SCHEDULE_MAP = self.EXTEND_SCHEDULE_MAP or {}
    return self.EXTEND_SCHEDULE_MAP
end

function CCSceneExtend:schedule(func, interval, times)
    interval = interval or 0.025
    times = times or -1
    local map = self:getScheduleMap()
    if map[func] ~= nil then
        self:unschedule(map[func].scheduleId)
    end
    map[func] = { totalTimes = times, remainTime = times }
    local warpFunc = function(dt)
        -- body
        if map[func].totalTimes > 0 then
            map[func].remainTime = map[func].remainTime - 1
            if map[func].remainTime == 0 then
                self:unschedule(func)
            end
        end
        func(dt)
    end
    map[func].scheduleId = gscheduler.scheduleGlobal(warpFunc, interval)
end

function CCSceneExtend:unschedule(func)
    local map = self:getScheduleMap()
    if func ~= nil and map[func] ~= nil then
        gscheduler.unscheduleGlobal(map[func].scheduleId)
        map[func] = nil
    end
end

function CCSceneExtend:unscheduleAll()
    local map = self:getScheduleMap()
    for k, v in pairs(map) do
        gscheduler.unscheduleGlobal(v.scheduleId)
        map[k] = nil
    end
end

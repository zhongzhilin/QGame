
---@classdef gsound
gsound = {
    eventListenerIdMap = {},
    effectMap = {},
    m_sCurBgm = {},
}
gsound.EV_ON_PLAYSOUND = "EV_ON_PLAYSOUND"

local voicePre = "sound/mp3/"

function gsound.initEvents()
    local gevent = gevent
    
    for _, v in pairs(gsound.eventListenerIdMap) do
        gevent:removeListener(v)
    end
    
    gsound.eventListenerIdMap = {}
    
    gsound.eventListenerIdMap[gsound.EV_ON_PLAYSOUND] = 
        gevent:addListener(gsound.EV_ON_PLAYSOUND, function(eventType, sound, delay)   
            local soundData = global.luaCfg:get_sounds_by(sound)
            if not soundData then 
                log.warn("##gsound EV_ON_PLAYSOUND,sound=%s not found!",sound)
                return 
            end
            if delay then
                gscheduler.performWithDelayGlobal(function()
                    gsound.checkAndPlayEffect(soundData)
                end, delay)
            else
                gsound.checkAndPlayEffect(soundData,soundData.loop)
            end
        end)
end

local paramsForBgm = {}
function gsound.playBgm(soundKey,isAdd,noClear,initVol)
    if log.isTrace() then
        printf("#######[gsound] playBgm() - soundKey: %s", tostring(soundKey))
    end

    if paramsForBgm[soundKey] then
        isAdd = isAdd or paramsForBgm[soundKey].isAdd
        noClear = noClear or paramsForBgm[soundKey].noClear
        initVol = initVol or paramsForBgm[soundKey].initVol 
    end
    local soundData = global.luaCfg:get_sounds_by(soundKey)
    gsound.m_sCurBgm.add = gsound.m_sCurBgm.add or {}
    if isAdd then
        if gsound.m_sCurBgm.add[soundKey] then
            gaudio.stopSound(gsound.m_sCurBgm.add[soundKey])
        end
        gsound.m_sCurBgm.add[soundKey] = false
    else
        gsound.m_sCurBgm.soundKey = soundKey
        gaudio.stopSound(gsound.m_sCurBgm.handle)

        if not noClear then
            for k,v in pairs(gsound.m_sCurBgm.add) do
                gaudio.stopSound(v)
                paramsForBgm[v] = {}
            end
            gsound.m_sCurBgm.add = {}
        end

        if gsound.m_iSchduleId then
            gscheduler.unscheduleGlobal(gsound.m_iSchduleId)
            gsound.m_iSchduleId = nil
        end
    end

    if not cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled") then 
        local loop = soundData.loop ~= -1
        if not isAdd then
            gsound.m_sCurBgm.handle = gaudio.playSound(voicePre..soundData.name,loop)
            gsound.setBgmVolume(soundData.volume,nil)
        else
            gsound.m_sCurBgm.add[soundKey] = gaudio.playSound(voicePre..soundData.name,loop)
            local vol = initVol or soundData.volume
            gsound.setBgmVolume(vol,soundKey)
        end
    end

    paramsForBgm[soundKey] = {["isAdd"]=isAdd,["noClear"]=noClear,["initVol"]=initVol}
    
    log.debug("=============> gsound.playBgm gsound.m_iSchduleId %s", gsound.m_iSchduleId)
end

function gsound.fadeIn(targetVol,dt)
    local flag = 1
    local outTime = 1
    local spd = targetVol/(outTime/0.01)
    gsound.setBgmVolume(0)
    gsound.m_iSchduleId = gscheduler.scheduleGlobal(function()
        local vol = gsound.getCurBgmVolume() + flag * spd
        if vol >= targetVol then
            gscheduler.unscheduleGlobal(gsound.m_iSchduleId)
            gsound.m_iSchduleId = nil
            vol = targetVol
        end
        gsound.setBgmVolume(vol)
    end, 0.01)
end

function gsound.fadeOut(call,dt)
    local flag = -1
    local outTime = dt or 2
    local spd = (gsound.getCurBgmVolume())/(outTime/0.01)
    local waitTime = 0.1
    local switchVol = 0-waitTime/0.01*spd
    gsound.m_iSchduleId = gscheduler.scheduleGlobal(function()
        local vol = gsound.getCurBgmVolume() + flag * spd
        gsound.setBgmVolume(vol)
        if vol <= switchVol then
            vol = 0
            if gsound.m_iSchduleId then
                gscheduler.unscheduleGlobal(gsound.m_iSchduleId)
                gsound.m_iSchduleId = nil
            end
            if call then call() end
        end
    end, 0.01)
end

function gsound.setBgmVolume(volume,soundKey)

    if not soundKey then
        gsound.m_fCurBgmVolume = volume
    end
    local vl = volume * 0.01
    if not cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled") then 
        if not soundKey then
            gaudio.setSoundsVolume(gsound.m_sCurBgm.handle,vl)
        else
            if gsound.m_sCurBgm.add[soundKey] then
                gaudio.setSoundsVolume(gsound.m_sCurBgm.add[soundKey],vl)
            end
        end
    end

    if paramsForBgm[soundKey] then
        paramsForBgm[soundKey].initVol = volume
    end

end

function gsound.getCurBgm()
    return gsound.m_sCurBgm
end

function gsound.getCurBgmVolume()
    return gsound.m_fCurBgmVolume or 100
end

function gsound.stopBgm(soundKey)
    
    log.debug("=============> gsound.stopBgm gsound.m_iSchduleId %s", gsound.m_iSchduleId)
    if not soundKey then
        if gsound.m_iSchduleId then
            gscheduler.unscheduleGlobal(gsound.m_iSchduleId)
            gsound.m_iSchduleId = nil
        end
        gaudio.stopSound(gsound.m_sCurBgm.handle)
    else
        if gsound.m_sCurBgm.add[soundKey] then
            gaudio.stopSound(gsound.m_sCurBgm.add[soundKey])
            gsound.m_sCurBgm.add[soundKey] = false
        end
    end
end

function gsound.getEffectName(soundname)
    local fileUtils = cc.FileUtils:getInstance()
    local namepre = voicePre
    local effectName = namepre..soundname
    if global.tools:isAndroid() and not fileUtils:isFileExist(effectName) then
        namepre = "sound/ogg/"
        effectName = namepre..soundname
        effectName = string.gsub(effectName,".mp3",".ogg")
    end
    return effectName
end

--强制播放音效，不加入自动管理
function gsound.playEffectForced(soundKey)
    if not cc.UserDefault:getInstance():getBoolForKey("user_effect_disabled") then
        local soundData = global.luaCfg:get_sounds_by(soundKey)

        if not soundData.name or soundData.name == "" then
            return
        end

        local loop = soundData.loop ~= -1
        local effectName = gsound.getEffectName(soundData.name)
        return gaudio.playSound(effectName,loop)
    end
end

function gsound.playEffect(soundData)
    if not cc.UserDefault:getInstance():getBoolForKey("user_effect_disabled") then
        if not soundData.name or soundData.name == "" then
            return
        end
        local effectName = gsound.getEffectName(soundData.name)
        if gsound.effectMap[soundData.key] and gaudio.isLoop(gsound.effectMap[soundData.key]) then
        else
            gsound.effectMap[soundData.key] = gaudio.playSound(effectName)
        end        
    end
end

function gsound.setEffectVolume(soundData,volume)
    if type(soundData) == "string" then
        if log.isTrace() then
            printf("#########soundKey="..soundData)
        end
        soundData = global.luaCfg:get_sounds_by(soundData)
        volume = volume or soundData.volume
    else
        if log.isTrace() then
            printf("#########soundKey="..soundData.key)
        end
    end
    local effectName = gsound.getEffectName(soundData.name)
    if not cc.UserDefault:getInstance():getBoolForKey("user_effect_disabled") then
        local handle = gsound.effectMap[soundData.key]
        -- if not handle or gaudio.getSoundsVolume(handle)==0 then
        --     gsound.playEffect(soundData,soundData.loop)
        --     handle = gsound.effectMap[soundData.key]
        -- end
        if soundData.distance > 0 then
            volume = volume*soundData.distance
        end
        local vl = volume * 0.01
        if not cc.UserDefault:getInstance():getBoolForKey("user_effect_disabled") then
            gaudio.setSoundsVolume(handle,vl)
        end
    end
end

function gsound.stopEffect(soundKey)
    if log.isTrace() then
        printf("[gsound] stopEffect() - soundKey: %s", tostring(soundKey))
    end
    if gsound.effectMap[soundKey] ~= nil then
        gaudio.stopSound(gsound.effectMap[soundKey])
        gsound.effectMap[soundKey] = nil
    end
end

function gsound.stopAllEffect()
    gsound.effectMap = {}
    gaudio.stopAllSounds()
end

function gsound.checkAndPlaySound(soundKey)
    local key = soundKey
    local soundData = soundKey
    if type(soundData) == "string" then
        soundData = global.luaCfg:get_sounds_by(soundKey)
    else
        key = soundKey.key
    end
    if not gsound.effectMap[key] then
        gsound.playEffect(soundData)
    end
end

function gsound.isSoundOpen()
    
    return not cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled")
end

function gsound.isEffectOpen()
    
    return not cc.UserDefault:getInstance():getBoolForKey("user_effect_disabled")
end

function gsound.disableSounds()
    gaudio.pauseSound(gsound.m_sCurBgm.handle)

    for soundKey,handle in pairs(gsound.m_sCurBgm.add) do
        if handle then
            if gaudio.isLoop(handle) then
                gaudio.pauseSound(handle)
            else
                gsound.m_sCurBgm.add[soundKey] = false
            end
        end
    end
    cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",true)
end
function gsound.pauseBGM()

    if not cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled") then 
        
        if gsound.m_sCurBgm.handle then 
            gaudio.pauseSound(gsound.m_sCurBgm.handle)
        end
    end  
end

function gsound.resumeBGM()

    if not cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled") then 
        if gsound.m_sCurBgm.handle then 
            gaudio.resumeSound(gsound.m_sCurBgm.handle)
        end 
    end 
end

function gsound.enableSounds()
    cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",false)
    gsound.checkLoopSounds()
end

function gsound.enableEffects()
    cc.UserDefault:getInstance():setBoolForKey("user_effect_disabled",false)
end

function gsound.disableEffects()
    cc.UserDefault:getInstance():setBoolForKey("user_effect_disabled",true)
end

function gsound.clearAll()
    gsound.m_sCurBgm = {}
    paramsForBgm = {}
end

--检测所有失效音乐，并开起来
function gsound.checkLoopSounds()
    if cc.UserDefault:getInstance():getBoolForKey("user_sound_disabled") then return end

    if gaudio.isLoop(gsound.m_sCurBgm.handle) then
        gaudio.resumeSound(gsound.m_sCurBgm.handle)
    else
        gsound.playBgm(gsound.m_sCurBgm.soundKey,false,true)
    end

    for soundKey,handle in pairs(gsound.m_sCurBgm.add) do
        local soundData = global.luaCfg:get_sounds_by(soundKey)
        local handleLoop = gaudio.isLoop(handle)
        if handle then
            if not handleLoop then
                --循环音效重新播放播放
                gsound.playBgm(soundKey,true)
            else
                if paramsForBgm[soundKey] then
                    local vol = paramsForBgm[soundKey].initVol or soundData.volume
                    gsound.setBgmVolume(vol, soundKey)
                end            
                gaudio.resumeSound(handle)
            end
        else
            gsound.playBgm(soundKey,true)
        end
    end
end

function gsound.checkAndPlayEffect(soundData,loop)
    if soundData.loop ~= -1 then
        --对于循环音效当作背景音处理
        gsound.playBgm(soundData.key,true)
        return
    end
    gsound.playEffect(soundData)
    gsound.setEffectVolume(soundData,soundData.volume)
end

function gsound.preloadAllSounds()
    local sounds = global.luaCfg:sounds()

    for i,v in pairs(sounds) do
        if v.loadkey and tonumber(v.loadkey) > 0 then
            local name = voicePre..v.name
            gaudio.preload(name)
        end
    end
end

---@classdef gaudio
gaudio = {}

local engine = cc.SimpleAudioEngine:getInstance()
local audioEngine = ccexp.AudioEngine
local resouceManager = ResourceManager:getInstance()

function gaudio.getMusicVolume()
    local volume = engine:getMusicVolume()
    if log.isTrace() then
        printf("[gaudio] getMusicVolume() - volume: %0.2f", volume)
    end
    return volume
end

function gaudio.setMusicVolume(volume)
    volume = checknumber(volume)
    if log.isTrace() then
        printf("[gaudio] setMusicVolume() - volume: %0.2f", volume)
    end
    engine:setMusicVolume(volume)
end

function gaudio.preloadMusic(filename)
    assert(filename, "gaudio.preloadMusic() - invalid filename")
    if log.isTrace() then
        printf("[gaudio] preloadMusic() - filename: %s", tostring(filename))
    end
    engine:preloadMusic(filename)
end

function gaudio.playMusic(filename, isLoop)
    assert(filename, "gaudio.playMusic() - invalid filename")
    if type(isLoop) ~= "boolean" then isLoop = true end

    -- gaudio.stopMusic()
    if log.isTrace() then
        printf("[gaudio] playMusic() - filename: %s, isLoop: %s", tostring(filename), tostring(isLoop))
    end
    resouceManager:PlayBackgroundMusic(filename)
end

function gaudio.getState(handle)
    local state = audioEngine:getState(handle)
    if state then
        printf("[gaudio] getState() - state: %s", state)
    end
    return state
end

function gaudio.stopMusic()
    -- isReleaseData = checkbool(isReleaseData)
    -- if log.isTrace() then
    --     printf("[gaudio] stopMusic() - isReleaseData: %s", tostring(isReleaseData))
    -- end
    engine:stopMusic(true)
end

function gaudio.pauseMusic()
    if log.isTrace() then
        printf("[gaudio] pauseMusic()")
    end
    engine:pauseMusic()
end

function gaudio.resumeMusic()
    if log.isTrace() then
        printf("[gaudio] resumeMusic()")
    end
    resouceManager:ResumeBackgroundMusic()
end

function gaudio.rewindMusic()
    if log.isTrace() then
        printf("[gaudio] rewindMusic()")
    end
    engine:rewindMusic()
end

function gaudio.isMusicPlaying()
    local ret = engine:isMusicPlaying()
    if log.isTrace() then
        printf("[gaudio] isMusicPlaying() - ret: %s", tostring(ret))
    end
    return ret
end

function gaudio.getSoundsVolume(handle)
    -- local volume = engine:getEffectsVolume()
    local volume = audioEngine:getVolume(handle)
    if log.isTrace() then
        printf("[gaudio] getSoundsVolume() - volume: %0.1f", volume)
    end
    return volume
end

function gaudio.setSoundsVolume(handle,volume)
    volume = checknumber(volume)
    if not handle then
        -- printError("gaudio.setSoundsVolume() - invalid handle")
        return
    end
    if log.isTrace() then
        -- printf("[gaudio] setSoundsVolume() - volume: %0.1f,handle=%s", volume,handle)
    end
    -- engine:setEffectsVolume(volume)
    -- resouceManager:SetEffectVolume(1,volume)

    audioEngine:setVolume(handle,volume)
end

function gaudio.playSound(filename, isLoop)
    if not filename then
        printError("gaudio.playSound() - invalid filename")
        return
    end
    if type(isLoop) ~= "boolean" then isLoop = false end
    if log.isTrace() then
        printf("[gaudio] playSound() - filename: %s, isLoop: %s", tostring(filename), tostring(isLoop))
    end
    local handle = audioEngine:play2d(filename, isLoop)
    return handle
    -- return resouceManager:PlayEffect(filename)
    -- return engine:playEffect(filename, isLoop)
end

function gaudio.pauseSound(handle)
    if not handle then
        printError("gaudio.pauseSound() - invalid handle")
        return
    end
    if log.isTrace() then
        printf("[gaudio] pauseSound() - handle: %s", tostring(handle))
    end
    -- engine:pauseEffect(handle)
    audioEngine:pause(handle)
end

function gaudio.pauseAllSounds()
    if log.isTrace() then
        printf("[gaudio] pauseAllSounds()")
    end
    -- engine:pauseAllEffects()
    audioEngine:pauseAll()
end

function gaudio.resumeSound(handle)
    if not handle then
        printError("gaudio.resumeSound() - invalid handle")
        return
    end
    if log.isTrace() then
        printf("[gaudio] resumeSound() - handle: %s", tostring(handle))
    end
    -- engine:resumeEffect(handle)
    audioEngine:resume(handle)
end

function gaudio.resumeAllSounds()
    if log.isTrace() then
        printf("[gaudio] resumeAllSounds()")
    end
    -- engine:resumeAllEffects()
    audioEngine:resumeAll()
end

function gaudio.stopSound(handle)
    if not handle then
        printf("gaudio.stopSound() - invalid handle")
        return
    end
    if log.isTrace() then
        printf("[gaudio] stopSound() - handle: %s", tostring(handle))
    end
    -- engine:stopEffect(handle)
    audioEngine:stop(handle)
end

function gaudio.stopAllSounds()
    if log.isTrace() then
        printf("[gaudio] stopAllSounds()")
    end
    -- engine:stopAllEffects()
    audioEngine:stopAll()
end

function gaudio.preload(file,callback)
    if log.isTrace() then
        printf("[gaudio] preload()")
    end
    -- engine:stopAllEffects()
    audioEngine:preload(file)
    print('-------gaudio.preload-----name=',file)
end

function gaudio.uncacheAll()
    if log.isTrace() then
        printf("[gaudio] uncacheAll()")
    end
    -- engine:stopAllEffects()
    audioEngine:uncacheAll()
end

function gaudio.reset()
    if log.isTrace() then
        printf("[gaudio] reset()")
    end
    -- engine:stopAllEffects()
    if global.tools:isIos() then
        audioEngine:endToLua()
    end    
    audioEngine:lazyInit()
end

function gaudio.isLoop(handle)
    if not handle then
        printf("gaudio.isLoop() - invalid handle")
        return
    end
    local isLoop = audioEngine:isLoop(handle)
    if log.isTrace() then
        log.trace("[gaudio] isLoop() isLoop=%s",isLoop)
    end
    return isLoop
end

function gaudio.preloadSound(filename)
    if not filename then
        printError("gaudio.preloadSound() - invalid filename")
        return
    end
    if log.isTrace() then
        printf("[gaudio] preloadSound() - filename: %s", tostring(filename))
    end
    engine:preloadEffect(filename)
end

function gaudio.unloadSound(filename)
    if not filename then
        printError("gaudio.unloadSound() - invalid filename")
        return
    end
    if log.isTrace() then
        printf("[gaudio] unloadSound() - filename: %s", tostring(filename))
    end
    engine:unloadEffect(filename)
end

function gaudio.enableSound(delay)
    -- if delay then
    --     gscheduler.performWithDelayGlobal(function()
    --         -- resouceManager:EnableSound()
    --         cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",true)
    --         gsound.enableSounds()
    --     end, delay)
    -- else
    --     -- resouceManager:EnableSound()
    --     cc.UserDefault:getInstance():setBoolForKey("user_sound_disabled",true)
    --     gsound.enableSounds()
    -- end
end

function gaudio.disableSound()
    -- gsound.disableSounds()
    -- resouceManager:DisableSound()
end

CCSpriteExtend = class("CCSpriteExtend", CCNodeExtend)
CCSpriteExtend.__index = CCSpriteExtend

function CCSpriteExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, CCSpriteExtend)
    return target
end

function CCSpriteExtend:playAnimationOnce(animation, removeWhenFinished, onComplete, delay)
    return gtransition.playAnimationOnce(self, animation, removeWhenFinished, onComplete, delay)
end

function CCSpriteExtend:playAnimationForever(animation, delay)
    return gtransition.playAnimationForever(self, animation, delay)
end

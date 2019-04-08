
---@classdef gtransition
gtransition = {}

local ACTION_EASING = {}
ACTION_EASING["BACKIN"]           = {CCEaseBackIn, 1}
ACTION_EASING["BACKINOUT"]        = {CCEaseBackInOut, 1}
ACTION_EASING["BACKOUT"]          = {CCEaseBackOut, 1}
ACTION_EASING["BOUNCE"]           = {CCEaseBounce, 1}
ACTION_EASING["BOUNCEIN"]         = {CCEaseBounceIn, 1}
ACTION_EASING["BOUNCEINOUT"]      = {CCEaseBounceInOut, 1}
ACTION_EASING["BOUNCEOUT"]        = {CCEaseBounceOut, 1}
ACTION_EASING["ELASTIC"]          = {CCEaseElastic, 2, 0.3}
ACTION_EASING["ELASTICIN"]        = {CCEaseElasticIn, 2, 0.3}
ACTION_EASING["ELASTICINOUT"]     = {CCEaseElasticInOut, 2, 0.3}
ACTION_EASING["ELASTICOUT"]       = {CCEaseElasticOut, 2, 0.3}
ACTION_EASING["EXPONENTIALIN"]    = {CCEaseExponentialIn, 1}
ACTION_EASING["EXPONENTIALINOUT"] = {CCEaseExponentialInOut, 1}
ACTION_EASING["EXPONENTIALOUT"]   = {CCEaseExponentialOut, 1}
ACTION_EASING["IN"]               = {CCEaseIn, 2, 1}
ACTION_EASING["INOUT"]            = {CCEaseInOut, 2, 1}
ACTION_EASING["OUT"]              = {CCEaseOut, 2, 1}
ACTION_EASING["RATEACTION"]       = {CCEaseRateAction, 2, 1}
ACTION_EASING["SINEIN"]           = {CCEaseSineIn, 1}
ACTION_EASING["SINEINOUT"]        = {CCEaseSineInOut, 1}
ACTION_EASING["SINEOUT"]          = {CCEaseSineOut, 1}

local actionManager = cc.Director:getInstance():getActionManager()

function gtransition.newEasing(action, easingName, more)
    local key = string.upper(tostring(easingName))
    if string.sub(key, 1, 6) == "CCEASE" then
        key = string.sub(key, 7)
    end
    local easing
    if ACTION_EASING[key] then
        local cls, count, default = unpack(ACTION_EASING[key])
        if count == 2 then
            easing = cls:create(action, more or default)
        else
            easing = cls:create(action)
        end
    end
    return easing or action
end

function gtransition.create(action, args)
    args = totable(args)
    if args.easing then
        if type(args.easing) == "table" then
            action = gtransition.newEasing(action, unpack(args.easing))
        else
            action = gtransition.newEasing(action, args.easing)
        end
    end

    local actions = {}
    local delay = tonum(args.delay)
    if delay > 0 then
        actions[#actions + 1] = CCDelayTime:create(delay)
    end
    actions[#actions + 1] = action

    local onComplete = args.onComplete
    if type(onComplete) ~= "function" then onComplete = nil end
    if onComplete then
        actions[#actions + 1] = CCCallFunc:create(onComplete)
    end

    if #actions > 1 then
        return gtransition.sequence(actions)
    else
        return actions[1]
    end
end

function gtransition.execute(target, action, args)
    assert(not tolua.isnull(target), "gtransition.execute() - target is not CCNode")
    local action = gtransition.create(action, args)
    target:runAction(action)
    return action
end

function gtransition.rotateTo(target, args)
    assert(not tolua.isnull(target), "gtransition.rotateTo() - target is not CCNode")
    -- local rotation = args.rotate
    local action = CCRotateTo:create(args.time, args.rotate)
    return gtransition.execute(target, action, args)
end

function gtransition.moveTo(target, args)
    assert(not tolua.isnull(target), "gtransition.moveTo() - target is not CCNode")
    local tx, ty = target:getPosition()
    local x = args.x or tx
    local y = args.y or ty
    local action = CCMoveTo:create(args.time, CCPoint(x, y))
    return gtransition.execute(target, action, args)
end

function gtransition.moveBy(target, args)
    assert(not tolua.isnull(target), "gtransition.moveBy() - target is not CCNode")
    local x = args.x or 0
    local y = args.y or 0
    local action = CCMoveBy:create(args.time, CCPoint(x, y))
    return gtransition.execute(target, action, args)
end

function gtransition.fadeIn(target, args)
    assert(not tolua.isnull(target), "gtransition.fadeIn() - target is not CCNode")
    local action = CCFadeIn:create(args.time)
    return gtransition.execute(target, action, args)
end

function gtransition.fadeOut(target, args)
    assert(not tolua.isnull(target), "gtransition.fadeOut() - target is not CCNode")
    local action = CCFadeOut:create(args.time)
    return gtransition.execute(target, action, args)
end

function gtransition.fadeTo(target, args)
    assert(not tolua.isnull(target), "gtransition.fadeTo() - target is not CCNode")
    local opacity = toint(args.opacity)
    if opacity < 0 then
        opacity = 0
    elseif opacity > 255 then
        opacity = 255
    end
    local action = CCFadeTo:create(args.time, opacity)
    return gtransition.execute(target, action, args)
end

function gtransition.scaleTo(target, args)
    assert(not tolua.isnull(target), "gtransition.scaleTo() - target is not CCNode")
    local action
    if args.scale then
        action = CCScaleTo:create(tonum(args.time), tonum(args.scale))
    elseif args.scaleX or args.scaleY then
        local scaleX, scaleY
        if args.scaleX then
            scaleX = tonum(args.scaleX)
        else
            scaleX = target:getScaleX()
        end
        if args.scaleY then
            scaleY = tonum(args.scaleY)
        else
            scaleY = target:getScaleY()
        end
        action = CCScaleTo:create(tonum(args.time), scaleX, scaleY)
    end
    return gtransition.execute(target, action, args)
end

function gtransition.sequence(actions)
    if #actions < 1 then return end
    if #actions < 2 then return actions[1] end

    local prev = actions[1]
    for i = 2, #actions do
        prev = CCSequence:createWithTwoActions(prev, actions[i])
    end
    return prev
end

function gtransition.playAnimationOnce(target, animation, removeWhenFinished, onComplete, delay)
    local actions = {}
    if type(delay) == "number" and delay > 0 then
        target:setVisible(false)
        actions[#actions + 1] = CCDelayTime:create(delay)
        actions[#actions + 1] = CCShow:create()
    end

    actions[#actions + 1] = CCAnimate:create(animation)

    if removeWhenFinished then
        actions[#actions + 1] = CCRemoveSelf:create()
    end
    if onComplete then
        actions[#actions + 1] = CCCallFunc:create(onComplete)
    end

    local action
    if #actions > 1 then
        action = gtransition.sequence(actions)
    else
        action = actions[1]
    end
    target:runAction(action)
    return action
end

function gtransition.playAnimationForever(target, animation, delay)
    local animate = CCAnimate:create(animation)
    local action
    if type(delay) == "number" and delay > 0 then
        target:setVisible(false)
        local sequence = gtransition.sequence({
            CCDelayTime:create(delay),
            CCShow:create(),
            animate,
        })
        action = CCRepeatForever:create(sequence)
    else
        action = CCRepeatForever:create(animate)
    end
    target:runAction(action)
    return action
end

function gtransition.removeAction(action)
    if not tolua.isnull(action) then
        actionManager:removeAction(action)
    end
end

function gtransition.stopTarget(target)
    if not tolua.isnull(target) then
        actionManager:removeAllActionsFromTarget(target)
    end
end

function gtransition.pauseTarget(target)
    if not tolua.isnull(target) then
        actionManager:pauseTarget(target)
    end
end

function gtransition.resumeTarget(target)
    if not tolua.isnull(target) then
        actionManager:resumeTarget(target)
    end
end

function gtransition.removeAllActions()
    actionManager:removeAllActions()
end

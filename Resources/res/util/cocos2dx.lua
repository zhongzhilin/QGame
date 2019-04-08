
---@classdef cc
cc = cc or {}

cc.IsMobilePhone = function()
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_ANDROID then
        return true
    elseif platform == cc.PLATFORM_OS_IPHONE then
        return true
    elseif platform == cc.PLATFORM_OS_IPAD then
        return true
    end
    return false
end

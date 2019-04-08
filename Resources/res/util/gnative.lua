
---@classdef gnative
gnative = {}

---@classdef gluaoc
gluaoc = {}
function gluaoc.callStaticMethod(className, methodName, args)
    local callStaticMethod = LuaObjcBridge.callStaticMethod
    local ok, ret = callStaticMethod(className, methodName, args)
    if not ok then
        local msg = string.format("gluaoc.callStaticMethod(\"%s\", \"%s\", \"%s\") - error: [%s] ",
                className, methodName, tostring(args), tostring(ret))
        if ret == -1 then
            log.error(msg .. "INVALID PARAMETERS")
        elseif ret == -2 then
            log.error(msg .. "CLASS NOT FOUND")
        elseif ret == -3 then
            log.error(msg .. "METHOD NOT FOUND")
        elseif ret == -4 then
            log.error(msg .. "EXCEPTION OCCURRED")
        elseif ret == -5 then
            log.error(msg .. "INVALID METHOD SIGNATURE")
        else
            log.error(msg .. "UNKNOWN")
        end
    end
    return ok, ret
end

---@classdef gluaj
gluaj = {}
local function checkArguments(args, sig)
    if type(args) ~= "table" then args = {} end
    if sig then return args, sig end

    sig = {"("}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            sig[#sig + 1] = "F"
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end
    sig[#sig + 1] = ")V"

    return args, table.concat(sig)
end

function gluaj.callStaticMethod(className, methodName, args, sig)
    local callJavaStaticMethod = LuaJavaBridge.callStaticMethod
    local args, sig = checkArguments(args, sig)
    log.debug("gluaj.callStaticMethod(\"%s\",\n\t\"%s\",\n\targs,\n\t\"%s\"", className, methodName, sig)
    local a,b,c = callJavaStaticMethod(className, methodName, args, sig)
    if a then
        return a,b,c
    end
    return nil
end

function gluaj.callNetStateStaticMethod(methodName,sig)
    local className = "org/cocos2dx/lua/NetWorkStateReceiver"
    local args = {}
    local sig = sig or "()Z"
    return gluaj.callStaticMethod(className, methodName, args, sig)
end

function gluaj.callUtilsStaticMethod(methodName,args,sig)
    local className = "org/cocos2dx/lua/Utils"
    local args = args or {}
    local sig = sig or "()Z"
    return gluaj.callStaticMethod(className, methodName, args, sig)
end

function gluaj.callGooglePayStaticMethod(methodName,args,sig)
    local className = "org/cocos2dx/lua/AppActivity"
    local args = args or {}
    local sig = sig or "()Z"
    local a,b,c = gluaj.callStaticMethod(className, methodName, args, sig)

    return b
end

function gluaj.callNetworkStaticMethod(methodName,args,sig)
    local className = "org/cocos2dx/utils/PSNetwork"
    local args = args or {}
    local sig = sig or "()Z"
    local a,b,c = gluaj.callStaticMethod(className, methodName, args, sig)
    return b
end
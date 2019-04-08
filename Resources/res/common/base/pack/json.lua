local cjson = require("cjson")

---@classdef json
local json = {} 

function json.encode(var)
    local status, result = xpcall(cjson.encode, hqxpcall_error, var)
    if status then return result end
    --log.error("json.encode() - encoding failed: %s", tostring(result))
end

function json.decode(text)
    local status, result = xpcall(cjson.decode, hqxpcall_error, text)
    if status then return result end
    --log.error("json.decode() - decoding failed: %s", tostring(result))
end

json.null = cjson.null

return json

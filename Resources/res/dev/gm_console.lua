local gameReq = global.gameReq

local function meta_new(key, v_type)
    v_type = v_type or "number"
    return { key = key, v_type = v_type }
end

local gm_cmd_list = 
{   
    {cmd = "call_rpc", params ={meta_new("rpcname", "string"), meta_new("luatable", "table")}, desc = "CALL_RPC"},
    {cmd = "add_item", params ={meta_new("tid"), meta_new("num")}, desc = "增加物品"},
    {cmd = "set_level", params ={meta_new("setlv") }, desc = "设置等级"},
    {cmd = "add_slave", params ={meta_new("tid") }, desc = "增加部队", callback = function( ... ) 
        local msg = { ... }
        log.debug("==============> %s", vardump(msg))
        global.slaveData:ReformSlave(nil, nil, msg[2].slave)
    end},
}

local CMDTable = 
{
    GM_EXP = {"(.+) (.*)", "gmCmdHandler"},
}

local M = {}

function M:findCmd(cmdName)
    for i, cmdObj in ipairs(gm_cmd_list) do
        if cmdObj.cmd == cmdName then
            return cmdObj
        end    
    end
end

function M:getCmdDesc(cmdItem)
    local desc = ""

    local str = ""
    for i, param in ipairs(cmdItem.params) do
        str = str .. string.format("参数%d（%s)\n", i, param.key)
    end

    return str
end

function M:send_gm(gm_cmd, params)
    if #params ~= #gm_cmd.params then
        return false, gm_cmd.desc.."参数错误 \n" .. self:getCmdDesc(gm_cmd)
    end

    local function trans_param(meta, value)
        if meta.v_type == "number" then 
            return tonumber(value)
        elseif meta.v_type == "string" then
            return value
        elseif meta.v_type == "table" then
            local lua_str = "return " .. value
            local f = loadstring(lua_str)
            return f()
        else
            return value
        end
    end

    local req_metas = gm_cmd.params
    local req_name = gm_cmd.cmd
    local reqmsg = {}
    local paramIdx = 1
    for i, meta in ipairs(req_metas) do
        local value = params[paramIdx]
            
        paramIdx =  paramIdx + 1

        value = trans_param(meta, value)
        reqmsg[meta.key] = value
    end

    global.gmApi:sendGMRpc(req_name, reqmsg, gm_cmd.callback)

    return true, gm_cmd.cmd.." ok \n"
end

function M:getCmdList()
    return gm_cmd_list
end

return M

--endregion








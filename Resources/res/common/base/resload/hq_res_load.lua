require "common"
local table         = table


local hq_res_load = {
    is_init = false,
    version = 0,
    res_mgr = {} -- 各资源的管理器
}

local __load_one = function(pkgpre, name, mgr)
    assert(type(pkgpre) == "string" and type(name) == "string" and mgr)
    
    local haserr = false
    local ok, res = unsafe_pcall(require, pkgpre .. name)
    if not ok then
        log.fatal("ERROR: require resource %s error", pkgpre .. name)
        haserr = true
        return haserr
    end
    
    -- parse each record to server prototype
    for _, v in pairs(res:getdata()) do
        local ptt = nil

        -- 如果不指定解析函数，则默认server的原型等于资源的数据
        if mgr.parser == nil then
            ptt = v
        else
            local ret = WCODE.OK
            ret, ptt = mgr.parser(v)
            if ret ~= WCODE.OK then
                haserr = true
                ptt = nil
            end
        end

        if ptt then
            -- 获取每一条记录的key
            local ptt_key = nil
            -- 如果不指定key的获取函数，则默认资源中需要有id字段
            if mgr.key == nil then
                ptt_key = assert(ptt.id) 
            else 
                ptt_key = mgr.key(ptt)
            end

            --有重复的key记录
            if mgr.svr_ptt[ptt_key] ~= nil then
                log.fatal("duplicated resource key %s for resource %s"
                            , tostring(ptt_key), name)
                haserr = true                            
            end

            mgr.svr_ptt[ptt_key] = ptt
            mgr.idx_key_arr[#mgr.idx_key_arr + 1] = ptt_key
            table.sort(mgr.idx_key_arr)
        end
    end
    
    return haserr
end

-- 注册各资源的load方法
-- @param parser 单行解析函数
-- @param key key自定义函数
-- @param assembler 单行组装函数，主要用于跨表组装
-- @param checker 单行检查函数
-- @param overall_checker 整表检查函数
-- @param overall_reset 整表重置，主要用于reload之前一些数据的重置
function hq_res_load.register_res_load(res_name
                                        , parser
                                        , key
                                        , assembler
                                        , checker
                                        , overall_checker
                                        , overall_reset)
    if hq_res_load.res_mgr[res_name] then
        log.error("res_name<%d> already registered", res_name)
        return WCODE.ERR_ALREADY_EXISTED
    end
    
    hq_res_load.res_mgr[res_name] = {
        name = res_name,
        
        parser = parser,
        key = key,
        assembler = assembler,
        checker = checker,
        overall_checker = overall_checker,
        overall_reset = overall_reset,
        
        svr_ptt = {},       -- 服务器资源原型数据， key <--> ptt
        idx_key_arr = {},   -- idx与key的对应关系
    }
    return WCODE.OK
end

-- load所有资源(包括解析、多表数据联合组装、数据校验)
function hq_res_load.load_all(pkgpre)
    pkgpre = pkgpre or ""
    hq_res_load.version = require(pkgpre .. "version")
    log.info("res version: %d", hq_res_load.version)

    local is_err = false
    
    log.debug("<<---- begin parse all resources ---->>")
    -- step 1: parse all resouce
    for name, mgr in pairs(hq_res_load.res_mgr) do
        if __load_one(pkgpre, name, mgr) then
            is_err = true
            break
        end
    end
    
    if is_err then
        log.fatal("<<---- parse resource error ---->>")
        return WCODE.ERR_RESOURCE_PARSE
    end
    
    log.debug("<<---- parse all resources done ---->>")
    hq_res_load.is_init = true
    
    log.debug("<<---- begin assemble all resources ---->>")
    
    -- step 2: assemble server prototype
    for name, mgr in pairs(hq_res_load.res_mgr) do
        if mgr.assembler ~= nil then
            log.info("assemble res:%s", pkgpre..name)
            -- 按顺序assemble
            for _, raw_key in pairs(mgr.idx_key_arr) do
                local ret = mgr.assembler(mgr.svr_ptt[raw_key])
                if ret ~= WCODE.OK then
                    is_err = true
                end
            end
            if is_err then break end
        end
    end
    
    
    if is_err then
        log.fatal("<<---- assemble resource error ---->>")
        return WCODE.ERR_RESOURCE_ASSEMBLE
    end
    log.debug("<<---- assemble all resources done ---->>")
    
    log.debug("<<---- begin check all resources ---->>")
    -- step 3: check server prototype
    for name, mgr in pairs(hq_res_load.res_mgr) do
        if mgr.checker ~= nil then
            log.info("check res:%s", pkgpre..name)
            -- 按顺序check
            for _, raw_key in pairs(mgr.idx_key_arr) do
                local ret = mgr.checker(mgr.svr_ptt[raw_key])
                if ret ~= WCODE.OK then
                    is_err = true
                end                
            end  
            if is_err then break end
        end
        -- 整表check
        if mgr.overall_checker ~= nil then
            local ret = mgr.overall_checker()
            if ret ~= WCODE.OK then
                is_err = true
                break
            end
        end
    end
    
    if is_err then
        log.fatal("<<---- check resource error ---->>")
        return WCODE.ERR_RESOURCE_CHECK
    end
    log.debug("<<---- check all resources done ---->>")
                
    return WCODE.OK
end

function hq_res_load.get_version()
    return hq_res_load.version
end

function hq_res_load.get_ptt_by_key(name, key)
    assert(hq_res_load.is_init, "resource not load in this service!")
    local mgr = assert(hq_res_load.res_mgr[name], "resource name not exist: " .. name)
    return mgr.svr_ptt[key]
end

function hq_res_load.get_ptt_by_idx(name, idx)
    assert(hq_res_load.is_init, "resource not load in this service!")
    local mgr = assert(hq_res_load.res_mgr[name], "resource name not exist: " .. name)
    if type(idx) ~= "number" then return nil end
    if idx < 1 or idx > #mgr.idx_key_arr then return nil end
    
    local key = assert(mgr.idx_key_arr[idx])
    return mgr.svr_ptt[key]
end

function hq_res_load.get_ptt_count(name)
    assert(hq_res_load.is_init, "resource not load in this service!")
    local mgr = assert(hq_res_load.res_mgr[name], "resource name not exist: " .. name)
    return #mgr.idx_key_arr
end

function hq_res_load.get_all_ptt(name)
    assert(hq_res_load.is_init, "resource not load in this service!")
    local mgr = assert(hq_res_load.res_mgr[name], "resource name not exist: " .. name)
    return mgr.svr_ptt
end

function hq_res_load.reset_one(confname)
    assert(type(confname) == "string")
    
    log.info("begin to reset resource data: %s", confname)
    local foundmgr = nil
    for name, mgr in pairs(hq_res_load.res_mgr) do
        if name == confname then
            foundmgr = mgr
            break
        end
    end
    
    if not foundmgr then
        log.fatal("resource %s not exist", confname)
        return WCODE.ERR_NOT_FOUND
    end
    
    if foundmgr.overall_reset ~= nil then
        foundmgr.overall_reset()
    end
    log.info("finish reseting resource data: %s", confname)
end

-- 重新加载某个配置表
function hq_res_load.reload_one(confname)
    assert(type(confname) == "string")
    
    log.info("begin to reload resource: %s", confname)
    local haserr = false
    local foundmgr = nil
    for name, mgr in pairs(hq_res_load.res_mgr) do
        if name == confname then
            foundmgr = mgr
            break
        end
    end
    
    if not foundmgr then
        log.fatal("reload resource %s not exist", confname)
        return WCODE.ERR_NOT_FOUND
    end
    
    -- 安全起见重载之前先备份，出错好恢复
    local bak_mgr = clone(foundmgr)
    
    local function __restore_mgr()
        log.info("restore mgr: %s", confname)
        hq_res_load.res_mgr[confname] = bak_mgr
    end
    
    -- 先清空现有数据
    local pkgpre = "conf."
    package.loaded[pkgpre .. confname] = nil
    foundmgr.svr_ptt = {}
    foundmgr.idx_key_arr = {}
    
    log.info("parse res:%s", confname)
    if __load_one(pkgpre, confname, foundmgr) then
        log.fatal("<<---- parse resource error ---->>")
        __restore_mgr()
        return WCODE.ERR_RESOURCE_PARSE
    end    
    
    if foundmgr.assembler ~= nil then
        log.info("assemble res:%s", confname)
        -- 按顺序assemble
        for _, raw_key in pairs(foundmgr.idx_key_arr) do
            local ret = foundmgr.assembler(foundmgr.svr_ptt[raw_key])
            if ret ~= WCODE.OK then
                haserr = true
            end                
        end

        if haserr then
            log.fatal("<<---- parse resource error ---->>")
            __restore_mgr()
            return WCODE.ERR_RESOURCE_PARSE
        end
    end
    
    if foundmgr.checker ~= nil then
        log.info("check res:%s", confname)
        -- 按顺序check
        for _, raw_key in pairs(foundmgr.idx_key_arr) do
            local ret = foundmgr.checker(foundmgr.svr_ptt[raw_key])
            if ret ~= WCODE.OK then
                haserr = true
            end                
        end            
    end            
    
    if haserr then
        log.fatal("<<---- check resource error ---->>")
        __restore_mgr()
        return WCODE.ERR_RESOURCE_CHECK
    end
    
    log.info("reload resource: %s ok!", confname)
    
    return WCODE.OK
end


return hq_res_load

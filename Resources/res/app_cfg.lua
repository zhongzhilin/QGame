
local _M = {}

--日志等级
_M.loglv = log.LFATAL
log.set_loglevel(_M.loglv)

-- 是否通信加密
_M.bcrypto = true

--启动进入调试
_M.bootdbg = true

_M.gmlv = 0
_M.super = 0

-- _M.plat_url = "http://plat.lb.han7.net"
_M.plat_url = {
    --release
    [1] = { 
        url = "http://wzxtlogin-internal.030303.com/",
        server_list_url = "http://wzxtlogin-internal.030303.com/verify.php",
    },
    --debug-yanzhen
    [2] = {
        url = "http://60.191.28.90:8484/",
        server_list_url = "http://60.191.28.90:8484/verify.php",
    },
    --debug-tjf
    [3] = {
        url = "http://wzxtlogin-internal.030303.com/",
        server_list_url = "http://wzxtlogin-internal.030303.com/verify.php",
    },
}

_M.notice_url = _M.plat_url[1].url.."/notice.php"

local default_plat_index = 2
_M.plat_index = default_plat_index

_M.ip_addr = ""
_M.rank_url = ""
_M.replay_url = ""
local isOpen = cc.UserDefault:getInstance():getBoolForKey("debug_open_google_recharge",false)
if _CPP_RELEASE == 1 or isOpen then
    _M.plat_index = 1
else
    _M.plat_index = cc.UserDefault:getInstance():getIntegerForKey("kgame_plat_index",default_plat_index)
end

local isOpen = cc.UserDefault:getInstance():getBoolForKey("debug_close_print",false)
if isOpen then
    print = function ()
        -- body
    end
    dump = function() end
end

_M.server_list_pw = "c7802D62fbbd35e3*("
_M.server_list_dictionarydata=  {code='list',sn=nil,sc=nil,partner_id=1}
_M.server_list_method = "GET"
_M.server_list_transformat = "json"

-- _M.cdn_url = "http://download-hgame.3333.cn/"
_M.cdn_url = {
    [1] = {
        url = "http://download-hgame.3333.cn/",     --网宿CDN
        cur_times = 0,      -- 当前失败次数
        max_times = 3,      -- 最大失败次数
    },
    [2] = {
        url = "http://download-hgame-lx.3333.cn/",  --蓝迅CDN
        cur_times = 0,      -- 当前失败次数
        max_times = 3,      -- 最大失败次数
    },
}
_M.cdn_index = 1

_M.dbg_cfg = { default  = {ip = "127.0.0.1", port = 10000, key ="luaidekey", path=""} }

function _M.get_cfg(name)
    return _M.dbg_cfg.default
end

function _M.set_super()
    _M.super = 1
end

function _M.get_cli_gmlv()
   return _M.gmlv 
end

function _M.get_plat_url(index)
    if index then
        return _M.plat_url[index].url
    end
    return _M.plat_url[_M.plat_index].url
end

function _M.get_serverlist_url(index)
    if index then
        return _M.plat_url[index].server_list_url
    end
    return _M.plat_url[_M.plat_index].server_list_url
end

function _M.on_plat_res(res)
    -- body
    if res ~= true then
        local cur = _M.plat_url[_M.plat_index]
        cur.cur_times = cur.cur_times + 1
        if cur.cur_times >= cur.max_times then
            cur.cur_times = cur.max_times
            _M.plat_index = _M.plat_index + 1
            if _M.plat_index > #_M.plat_url then
                _M.plat_index = 1
            end
        end
    end
end

function _M.set_rank_url(url)
    _M.rank_url = url
end

function _M.get_rank_url()
    return _M.rank_url
end

function _M.set_replay_url(url)
    _M.replay_url = url
end

function _M.get_replay_url()
    return _M.replay_url
end

function _M.is_crypto()
    return _M.bcrypto
end

function _M.get_cdn_url()
    return _M.cdn_url[_M.cdn_index].url
end

function _M.on_cdn_res(res)
    -- body
    if res ~= true then
        local cur = _M.cdn_url[_M.cdn_index]
        cur.cur_times = cur.cur_times + 1
        if cur.cur_times >= cur.max_times then
            cur.cur_times = cur.max_times
            _M.cdn_index = _M.cdn_index + 1
            if _M.cdn_index > #_M.cdn_url then
                _M.cdn_index = 1
            end
        end
    end
end

return _M 


local table = table
local hqtimer = require "hqtimer"


local hqfsm = {
    fsms = {},
    fsm_id = 0,
}

local FSM_STATE_NUM_MIN = 1


-- todo  default timeout func
local function __default_timeout_func(fsm_info, ctx)
    log.info("[===FSM timeout===] proc fsm default timeout func")
end

local function __check_fsm(fsm)
    if not fsm then
        log.error("fsm is nil")
    end
    
    if type(fsm.fsm_name) ~= "string" then
        log.error("invalid fsm_name<%s>", vardump(fsm.fsm_name))
        return false
    end
    
    -- 没有重复注册
    if hqfsm.fsms[fsm.fsm_name] ~= nil then
        log.error("duplicated fsm_name<%s>", fsm.fsm_name)
        return false
    end
    
    -- states数目>1
    if type(fsm.states) ~= "table" or #(table.keys(fsm.states)) <= FSM_STATE_NUM_MIN then
        log.error("invalid states<%s>", vardump(fsm.states))
        return false
    end
    
    --  checker用于检查是否有重复状态
    local checker = {}
    for _, state in pairs(fsm.states) do
        if type(state.state_name) ~= "string" then
            log.error("invalid state_name<%s>", vardump(state.state_name))
            return false
        end
        
        -- 没有重复的state
        if checker[state.state_name] ~= nil then
            log.error("duplicated state_name<%s>", state.state_name)
            return false
        end
        
        if type(state.funcs) ~= "table" then
            log.error("invalid state<%s> funcs<%s> "
                        , state.state_name, vardump(state.funcs))
            return false
        end
        
        if type(state.funcs.on_proc) ~= "function" then
            log.error("invalid state<%s> funcs.on_proc<%s> "
                        , state.state_name, vardump(state.funcs.on_proc))
            return false
        end
        
        if state.funcs.on_enter and type(state.funcs.on_enter) ~= "function" then
            log.error("invalid state<%s> funcs.on_enter<%s> "
                , state.state_name, vardump(state.funcs.on_enter))
            return false
        end

        if state.funcs.on_leave and type(state.funcs.on_leave) ~= "function" then
            log.error("invalid state<%s> funcs.on_leave<%s> "
                        , state.state_name, vardump(state.funcs.on_leave))
            return false
        end
               
        if state.funcs.timeout_func and type(state.funcs.timeout_func) ~= "function" then
            log.error("invalid state<%s> funcs.timeout_func<%s>"
                        , state.state_name, vardump(state.funcs.timeout_func))
            return false
        end

        if state.timeout and (type(state.timeout) ~= "number" or state.timeout <= 0) then
            log.error("invalid state<%s> timeout<%s>"
                        , state.state_name, vardump(state.timeout))
            return false
        end

        -- 状态名不能重复
        checker[state.state_name] = true
    end
    
    return true
end

local function __add_fsm(fsm)
    for _, v in pairs(fsm.states) do
        if v.timeout then
            v.funcs.timeout_func = v.funcs.timeout_func or __default_timeout_func            
        end
    end
    
    hqfsm.fsms[fsm.fsm_name] = fsm 
end

function hqfsm.init()
    hqtimer.register_timer_func("fsm_timeout", function(fsm_info, ctx) 
        log.trace("[===FSM PROC===] proc fsm_timeout, fsm_name<%s> cur_state<%s>"
                , fsm_info.fsm_name, fsm_info.cur_state)

        local states = hqfsm.fsms[fsm_info.fsm_name].states
        states[fsm_info.cur_state].funcs.timeout_func(fsm_info, ctx)
    end)
end

function hqfsm.register_fsm(fsm)
    assert(__check_fsm(fsm) == true)
    __add_fsm(fsm)
    log.info("register_fsm <%s>", fsm.fsm_name)
end

-- 状态机根据msg消息进行相应处理
function hqfsm.deal_msg(fsm_info, msg, data)
    assert(type(msg) == "string")
    assert(type(fsm_info) == "table")
    
    local fsm_id = assert(fsm_info:get_fsm_id())
    local fsm_name = assert(fsm_info:get_fsm_name())
    local cur_state = assert(fsm_info:get_cur_state())


    local curr_fsm = hqfsm.fsms[fsm_name]
    local notrace = curr_fsm.notrace

    -- 获取当前状态机的states
    local states = curr_fsm.states
    
    -- 获取当前状态的state
    local state = assert(states[cur_state])
    if not notrace then
        log.debug("[===FSM===] fsm_id<%d>, fsm_name<%s> proc msg: cur_state<%s> msg<%s>"
                    ,fsm_id, fsm_name, cur_state, msg)
    end
                
    -- 调用当前状态的on_proc
    local chg_state, next_state = state.funcs.on_proc(fsm_info, msg, data)
    if chg_state == true and next_state ~= cur_state then
        assert(next_state ~= nil)
        if not notrace then
            log.debug("[===FSM===] fsm_id<%d>, fsm_name<%s> change state: state<%s --> %s>"
                        ,fsm_id, fsm_name, cur_state, next_state)
        end

        -- 调用当前状态的on_leave
        if state.funcs.on_leave then
            state.funcs.on_leave(fsm_info)
        end
        
        -- 删除timeout定时器
        if state.timeout then
--            log.trace("[===FSM timeout===] del timeout timer fsm_id<%d>,"
--                        .. "fsm_name<%s> state<%s>"
--                        ,fsm_id, fsm_name, next_state)
            hqtimer.del_timer(fsm_info.timeout_timer)
        end
        
        -- 更新当前状态
        fsm_info:set_cur_state(next_state)
        state = assert(states[next_state])
        
        -- 添加timeout定时器
        if state.timeout then
            log.trace("[===FSM timeout===] add timeout timer fsm_id<%d>,"
                    .. "fsm_name<%s> state<%s>"
                    ,fsm_id, fsm_name, next_state)
            fsm_info.timeout_timer = hqtimer.add_timer("fsm_timeout"
                            , hqtimer.time_to_tick(state.timeout), fsm_info)
        end
        
        -- 调用下一状态的on_enter
        if state.funcs.on_enter then
            state.funcs.on_enter(fsm_info)
        end
    end
end



return hqfsm


local fsm_info = {}


---
-- @param fsm_id      状态机的唯一标识
-- @param fsm_name    字符串，状态机名
-- @param cur_state   字符串，当前状态
-- @param ctx         创建状态机时的上下文
-- @return            返回一个状态机实例，交由上层fsm_mgr管理 
function fsm_info.new(fsm_id, fsm_name, cur_state, ctx)
    local instance = {}
    instance = setmetatable(instance, { __index = fsm_info })
    ------------------------------------
    instance.fsm_id = fsm_id
    instance.fsm_name = fsm_name
    instance.cur_state = cur_state
    instance.ctx = ctx
    ------------------------------------
    
    return instance
end


function fsm_info:get_fsm_name()
    return self.fsm_name
end

function fsm_info:get_cur_state()
    return self.cur_state
end

function fsm_info:set_cur_state(cur_state)
    self.cur_state = cur_state
end

function fsm_info:get_fsm_id()
    return self.fsm_id
end

function fsm_info:get_context()
    return self.ctx
end

return fsm_info

local hqfsm = require "fsm.hqfsm"
local fsm_info = require "fsm.fsm_info"

---@classdef fsm_mgr
local fsm_mgr = {
    fsm_infos = {},
    fsm_id = 0,
} 

---
-- @return @class fsm_mgr
--
function fsm_mgr.new()
    local instance = {}
    instance = setmetatable(instance, {__index = fsm_mgr })
    ------------------------------------
    for k,v in pairs(fsm_mgr) do
        local vt = type(v)
        if vt ~= "function" then
            if vt == "table" then
                instance[k] = clone(v)
            else
                instance[k] = v
            end
        end
    end
    ------------------------------------
    return instance
end



function fsm_mgr:gen_fsm_id()
    self.fsm_id = self.fsm_id + 1
    if self.fsm_id == 0 then
        self.fsm_id = self.fsm_id + 1
    end
    return self.fsm_id
end

function fsm_mgr:create_fsm_info(fsm_name, start_state, ctx)
    assert(type(fsm_name) == "string" and type(start_state) == "string")
    
    local fsm_id = fsm_mgr:gen_fsm_id()
    local fsm_info = fsm_info.new(fsm_id, fsm_name, start_state, ctx)
    assert(self.fsm_infos[fsm_id] == nil)
    self.fsm_infos[fsm_id] = fsm_info
    
    log.trace("[===FSM===] create_fsm_info fsm_id<%d>, fsm_name<%s>"
                , fsm_id, fsm_name)
    return fsm_info
end

function fsm_mgr:get_fsm_info(fsm_id)
    assert(fsm_mgr.fsm_infos[fsm_id])
    
    return fsm_mgr.fsm_infos[fsm_id]
end

function fsm_mgr:delete_fsm_info(fsm_info)
    assert(type(fsm_info) == "table")
    log.debug("delete_fsm_info fsm_id<%d>, fsm_name<%s>"
        , fsm_info:get_fsm_id(), fsm_info:get_fsm_name())
    local fsm_id = assert(fsm_info:get_fsm_id())
    self.fsm_infos[fsm_id] = nil
end



return fsm_mgr

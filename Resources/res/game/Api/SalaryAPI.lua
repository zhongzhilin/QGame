--
-- Author: Your Name
-- Date: 2017-06-08 12:21:22
--
local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- 根据购买商品
function _M:requestSalaryState(callback)

    local pbmsg = msgpack.newmsg("GetSalaryInfoReq")

    local rsp_call = function(ret,msg)

    	dump(ret,"ret=========")
    	dump(ret,"msg =========")
        if ret.retcode == WCODE.OK then 
        	if callback then 
        		callback(msg)
        	end 
        end 
    end
    gameReq.CallRpc("requestDailaySalaryState","requestDailaySalaryState",rsp_call,pbmsg)
end


global.SalaryAPI = _M
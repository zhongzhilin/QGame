--
-- Author: Your Name
-- Date: 2017-04-12 17:05:03
--
--
-- Author: Your Name
-- Date: 2017-03-14 11:24:51
--
 
local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

-- 获取top
function _M:gateBossChestReq(lGateID, callback)
    local pbmsg = msgpack.newmsg("GateBossChestReq")
    pbmsg.lGateID = lGateID
    local rsp_call = function(msg,ret)
        callback(msg,ret)
        gevent:call(global.gameEvent.EV_ON_BOSS_POINT)
    end
    gameReq.CallRpc("BossChestAPI","BossChestAPI",rsp_call,pbmsg)
end

-- 拉取所有boss 关卡信息
function _M:gateBoss(lGateID, callback)

	local pbmsg = msgpack.newmsg("GateInfoReq")
    pbmsg.lGateID = lGateID
    
    local rsp_call = function(ret,msg)

    	if ret.retcode == WCODE.OK then 
        	callback(msg)
        end
    end
    gameReq.CallRpc("boss","gateBoss",rsp_call,pbmsg)

end

global.BossChestAPI = _M
--endregio
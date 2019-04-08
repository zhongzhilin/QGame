--
-- Author: Your Name
-- Date: 2017-03-14 11:24:51
--
 

local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}



-- 获取top
function _M:mysteriousReq(lType,localId , callback)
    local pbmsg = msgpack.newmsg("SecretShopReq")
    pbmsg.lType = lType
    pbmsg.localId = localId
    local rsp_call = function(msg,ret)
            callback(msg,ret)
    end
    gameReq.CallRpc("mysteriousshop","mysteriousshop",rsp_call,pbmsg)
end


global.SecretShopAPI = _M

--endregio
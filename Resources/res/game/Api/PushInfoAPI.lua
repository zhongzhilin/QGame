--
-- Author: Your Name
-- Date: 2017-04-06 10:15:32
--
--
-- Author: Your Name
-- Date: 2017-03-14 11:24:51
--
local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}
-- message SendClientidReq
-- {
--     required string     lClientId = 1;//设备ID
-- }
-- message SendClientidResp
-- {
-- }
-- message PushInfo
-- {
--     required int32      lType = 1;
--     required int32      lstate = 2;//0表示关  1 表示开启
-- }
-- message GetPushInfoReq
-- {
--     required int32      lType = 1;//请求类型（0 拉取列表,1 操作推送类型）
--     optional int32      lPushType = 2;//推送类型
-- }

-- 获取配置列表
function _M:getConfigureList(lType,lPushType ,callback)
    local pbmsg = msgpack.newmsg("GetPushInfoReq")
    pbmsg.lType = lType
    pbmsg.lPushType = lPushType
    local rsp_call = function(msg,ret)
            callback(msg,ret)
    end
    gameReq.CallRpc("getConfigureList","getConfigureList",rsp_call,pbmsg)
end

function _M:operateSwitch(lType,lPushType ,callback)
    local pbmsg = msgpack.newmsg("GetPushInfoReq")
    pbmsg.lType = lType
    pbmsg.lPushType = lPushType
    local rsp_call = function(msg,ret)
            callback(msg,ret)
    end
    gameReq.CallRpc("getConfigureList","getConfigureList",rsp_call,pbmsg)
end


-- 发送设备ID
function _M:SendClientidReq(lClientId,lToken, szparam, callback)
    local pbmsg = msgpack.newmsg("SendClientidReq")
    pbmsg.lClientId = lClientId
    pbmsg.lToken = lToken
    pbmsg.szparam = szparam
    local rsp_call = function(msg,ret)
        callback(msg,ret)
    end
    gameReq.CallRpcSilentAndNoRetry("SendClientidReq","SendClientidReq",rsp_call,pbmsg, false)
end

function _M:sendClientID()
    if device.platform == "android" then 
        local clientId =  nil 
        local google_token = CCHgame:getXGToken()
        local szparam = ""
        if not google_token or  google_token == "##" then google_token ="" end 
        if not clientId   then clientId ="" end 
        if global.tools:isAndroid() then
            szparam = gluaj.callGooglePayStaticMethod("getXGAccesses",{},"()Ljava/lang/String;")        
        end
        if szparam == "" then
            return
        end
        self:SendClientidReq(clientId,google_token,szparam,function(msg,ret) end)
    end

    local language = global.languageData:getCurrentLanguage()
    self:sendClientLanguage(language , nil)
    
end

function _M:sendClientStatus(lState,callback)
    local pbmsg = msgpack.newmsg("ClientStateReq")
    pbmsg.lState = lState
    local rsp_call = function(msg,ret)
            callback(msg,ret)
    end
    gameReq.CallRpcSilentAndNoRetry("sendClientStatus","sendClientStatus",rsp_call,pbmsg)
end 


function _M:sendClientLanguage(language,callback , type_)

    local pbmsg = msgpack.newmsg("GameCommonReq")
    pbmsg.szParam = language
    pbmsg.lType =  type_ or 1 
    local rsp_call = function(msg,ret)
        if callback then callback(msg , ret ) end 
    end
    gameReq.CallRpcSilentAndNoRetry("sendClientLanguage","sendClientLanguage",rsp_call,pbmsg)
end 


global.PushInfoAPI = _M
--endregio
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- ---- 修改邮箱读取以及礼包领取状态 
-- ---- lID: 邮件id（list）
-- ---- lState：1已读, 2已领取, 3删除邮件
function _M:actionMail(lID, lState, callback)
    
    local pbmsg = msgpack.newmsg("MailActionReq")
    pbmsg.lID = lID
    pbmsg.lState = lState

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("mail","action_mail",rsp_call,pbmsg)
end

-- required string      szTitle = 1;
-- required string      szto = 2;
-- required string      szContent = 3;
function _M:senderMail(szTitle, szto, szContent, callback)
    
    local pbmsg = msgpack.newmsg("SendMailReq")
    pbmsg.szTitle = szTitle
    pbmsg.szto = szto
    pbmsg.szContent = szContent

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            global.tipsMgr:showWarning("NoSentPlayer")
        end
    end

    gameReq.CallRpc("mail","senderMail",rsp_call,pbmsg)
end

-- 上拉刷新
function _M:pushMail(callback, lMinID, lType, lCount)
    
    local pbmsg = msgpack.newmsg("CTGetMailBeforeReq")
    pbmsg.lMinID = lMinID
    pbmsg.lType = lType
    pbmsg.lCount = lCount

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("mail","pushMail",rsp_call,pbmsg)
end

 
--获取战报文件是否存在
function _M:checkFightReplay(lFightId , callback)
    
    local pbmsg = msgpack.newmsg("CheckFightReplayReq")
    pbmsg.lFightId = lFightId

    local rsp_call = function(ret,msg)
            callback(ret , msg)
    end
    gameReq.CallRpc("mail","pushMail",rsp_call,pbmsg)
end

global.mailApi = _M

--endregion

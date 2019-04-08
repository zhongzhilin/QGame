--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

-- required uint32     lType       = 1;//1，私聊 2，世界，3，联盟，4，聊天组
-- required string     szContent   = 2;//内容
-- required int32      lFrom       = 3;//发送方id
-- optional int32      lTo         = 4;//接收方id
-- optional string     szTo        = 5;//接收方名字
-- optional int32      lTime       = 6;//发送时间
-- optional int32      lAllyID     = 7;//发送方联盟id
-- optional string     szFrom      = 8;//发送方名字
-- optional string     szAlly      = 9;//发送方联盟名
-- optional string     szAllyNick  = 10;//发送方联盟简称
-- repeated int32      lParams     = 11;//type+value
function _M:senderMsg(callback, lType, szContent, lFrom, lTo, tagSpl , szTo, lTime, lAllyID, szFrom, szAlly, szAllyNick)
    
    local pbmsg = msgpack.newmsg("CTSendMessageReq")
    local data = {

        lType = lType,
        szContent = szContent,
        lFrom = lFrom,
        tagSpl = tagSpl,
        lTo = lTo,
        szTo = szTo,
    }

    pbmsg.tagMsg = data
    
    -- pbmsg.lTo = lTo
    -- pbmsg.szTo = szTo
    -- pbmsg.lTime = lTime
    -- pbmsg.lAllyID = lAllyID
    -- pbmsg.szFrom = szFrom
    -- pbmsg.szAlly = szAlly
    -- pbmsg.szAllyNick = szAllyNick
    -- pbmsg.lParams = lParams

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then
            callback(msg)

            global.EasyDev:tDChat(tostring(lTo or ""), tostring(lType or ""))

        else
            global.tipsMgr:showWarning("NoSentPlayer")
        end
    end

    gameReq.CallRpc("chat","sender_msg",rsp_call,pbmsg)
end


-- 获取聊天列表
function _M:getChatList(callback, lPage)
    
    local pbmsg = msgpack.newmsg("CTGetRecordListReq")
    pbmsg.lPage = lPage

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("chat","get_chatList",rsp_call,pbmsg)
end


-- 获取聊天内容详情
-- required int32      lType       = 1;//聊天频道
-- optional int32      lUserID     = 2;//聊天对象
function _M:getMsgInfo(callback, lType, lPage, lUserID)
    
    local pbmsg = msgpack.newmsg("CTGetMsgInfoReq")
    pbmsg.lType = lType
    pbmsg.lUserID = lUserID
    pbmsg.lPage = lPage
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpcSilentAndNoRetry("chat","get_msgInfo",rsp_call,pbmsg)
end

-- 分享战报(请求战报数据)
-- required int32      lID       = 1;
function _M:getBattleInfo(szID, callback, lUserID, lChannel)
    
    local pbmsg = msgpack.newmsg("CTGetSpecialInfoReq")
    pbmsg.szID = szID
    pbmsg.lUserID = lUserID
    pbmsg.lChannel = lChannel
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpcSilentAndNoRetry("chat","get_battleInfo",rsp_call,pbmsg)
end

-- 拉取用户信息
-- optional int32      lUserID     = 1;
-- optional string     szName      = 2;
function _M:getUserInfo(callback, lUserID, szName)
    
    local pbmsg = msgpack.newmsg("GetPubUserInfoReq")
    pbmsg.lUserID = lUserID
    pbmsg.szName = szName
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("chat","get_userInfo",rsp_call,pbmsg)
end


-- 关闭私聊界面，通知服务器
function _M:logicNotifyRead(callback, lTargerID, lClose)
    
    local pbmsg = msgpack.newmsg("CTCloseWindowReq")
    pbmsg.lTargerID = lTargerID
    pbmsg.lClose = lClose
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("chat","logicNotifyRead",rsp_call,pbmsg)
end

-- 批量操作私聊列表
-- required int32      lType       = 1;//操作标记:1.删除。2.拉黑... 
-- repeated int32      lUserID     = 2;//
function _M:operateChatList(callback, lType, lUserID)
    
    local pbmsg = msgpack.newmsg("CTRemoveListReq")
    pbmsg.lType = lType
    pbmsg.lUserID = lUserID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("chat","operateChatList",rsp_call,pbmsg)
end

-- required int32      lType       = 1; //=2.联盟未读条数
function _M:getUnReadNum(callback, lType)

    local pbmsg = msgpack.newmsg("CTGetUnReadReq")
    pbmsg.lType = lType

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("chat","getUnReadNum",rsp_call,pbmsg)

end

-- 拉取英雄信息
-- required int32      lHeroID = 1;    //英雄配备ID
-- optional int32      lUserID = 2;    //用户ID，=0查找本人
-- optional int32      lHeroUID    = 3;    //英雄唯一ID
function _M:getHeroInfo(callback, lHeroID, lUserID, lHeroUID)
    
    local pbmsg = msgpack.newmsg("GetHeroInfoReq")
    pbmsg.lHeroID = lHeroID
    pbmsg.lUserID = lUserID
    pbmsg.lHeroUID = lHeroUID
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            global.tipsMgr:showWarning("hero_fired")
        end
    end
    gameReq.CallRpc("chat","getHeroInfo",rsp_call,pbmsg)
end

-- 聊天联盟红包
function _M:chatRedGift(callback, lType, lID)
    
    local pbmsg = msgpack.newmsg("RedEnvelopeActionReq")
    pbmsg.lType = lType
    pbmsg.lID = lID
    
    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg, 0)
            if lType == 1 then -- 领取完之后,更新礼包列表
                global.chatData:removeUnionGiftLog(lID[1])
            end
        else
            callback(msg, 1) -- 礼包已失效
        end
    end
    gameReq.CallRpc("chat","chatRedGift",rsp_call,pbmsg)
end

global.chatApi = _M

--endregion

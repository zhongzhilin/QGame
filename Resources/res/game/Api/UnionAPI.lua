--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}


-- 创建联盟
---- szName: 联盟名称
---- lTotem: 联盟信息
---- lAutoApprove: 是否自动审批，0=否，1=是
function _M:createUnion(szName,szInfo,lAutoApprove, callback)
    if not szName or szName == "" then
        global.tipsMgr:showWarning("UnionCreateName")
        return
    end
    local pbmsg = msgpack.newmsg("AllyCreateReq")
    pbmsg.szName = szName
    pbmsg.szInfo = szInfo
    pbmsg.lAutoApprove = lAutoApprove

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            --设置自己为盟主
            global.userData:setlAllyRole(5)
            global.tipsMgr:showWarning("UnionCreatesuccess")
            global.unionApi:getRedCount(function() 
                callback(msg)
            end,nil,true)

            if msg and msg.tgAlly then
                global.EasyDev:tDCreateGuild(tostring(msg.tgAlly.lID or ""), tostring(msg.tgAlly.szName or ""))
            end
        end
    end

    gameReq.CallRpc("union","create_union",rsp_call,pbmsg)
end


---- 申请加入、取消联盟
---- lID: 联盟id
---- lType：1申请加入,2取消申请
function _M:joinUnion(lID, lType,callback)
    
    local pbmsg = msgpack.newmsg("AllyApplyReq")
    pbmsg.lID = lID
    pbmsg.lType = lType

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            if msg.lFinish == 1 then
                global.userData:setlAllyRole(1)
                if lType == 1 then
                    global.unionApi:getRedCount(function() 
                        callback(msg)
                    end,nil,true)
                else
                    callback(msg)
                end
                -- 加入联盟
                gevent:call(global.gameEvent.EV_ON_UNION_JOIN)
                global.chatData:refershUnionGift()

                if msg and msg.tgAlly then
                    global.EasyDev:tDJoinGuild(tostring(msg.tgAlly.lID or ""), tostring(msg.tgAlly.szName or ""))
                end

            else
                global.tipsMgr:showWarning("unionApply")
            end
        else
            -- global.tipsMgr:showWarning(global.luaCfg:get_local_string(10082))
        end
    end

    gameReq.CallRpc("union","join_union",rsp_call,pbmsg)
end

--审批申请列表
-- required int32      lType       = 1;// 操作类型，0=查询，1=接受，2=拒绝
-- repeated int32      lTargetID   = 2;// 操作对象
function _M:replyUnionApply(lType, lTargetID, callback)
    
    local pbmsg = msgpack.newmsg("ReplyApplyReq")
    pbmsg.lType = lType
    pbmsg.lTargetID = lTargetID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            if msg.lType == 1 then
                global.tipsMgr:showWarning("unionApplyYes")
            elseif msg.lType == 2 then
                global.tipsMgr:showWarning("unionApplyNo")
            end
            callback(msg)
        else
            if ret.retcode == 1 then
                global.tipsMgr:showWarning("unionPowerNot")
            else
                --拒绝或者接受失败，则刷新成员列表
                gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)

                global.unionApi:getRedCount(function() end,nil)
            end
        end
    end

    gameReq.CallRpc("union","join_union",rsp_call,pbmsg)
end

-- 退出联盟
function _M:quitUnion(callback)
    
    local pbmsg = msgpack.newmsg("AllyQuitReq")

    local unionId, unionName = "",""
    local mineUnion = global.unionData:getInUnion()
    if mineUnion then
        unionId = tostring(mineUnion.lID or "")
        unionName = tostring(mineUnion.szName or "")
    end

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlAllyRole(0)
            global.userData:setlAllyDonate({})
            callback(msg)
        -- elseif ret.retcode == 34 then
        --     --盟主不能退
            gevent:call(global.gameEvent.EV_ON_UNION_QUITUNION)
            global.chatData:cleanUnionGift()


            global.EasyDev:tDLeaveGuild(unionId, unionName, "quitUnion")

        end
    end

    gameReq.CallRpc("union","quit_union",rsp_call,pbmsg)
end

-- 获取10个联盟列表
function _M:getUnionList(callback,lPage,lLanguage,szKey,errorCall)
    
    local pbmsg = msgpack.newmsg("AllyGetListReq")
    pbmsg.lPage = lPage
    pbmsg.lLanguage = lLanguage
    pbmsg.szKey = szKey

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        else
            if errorCall then errorCall(ret) end
        end
    end

    gameReq.CallRpc("union","getUnionList",rsp_call,pbmsg)
end

--解散
function _M:letAllyDismissReq(callback,lID)
    
    local pbmsg = msgpack.newmsg("AllyDismissReq")
    pbmsg.lID = lID

    local unionId, unionName = "",""
    local mineUnion = global.unionData:getInUnion()
    if mineUnion then
        unionId = tostring(mineUnion.lID or "")
        unionName = tostring(mineUnion.szName or "")
    end

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlAllyRole(0)
            global.userData:setlAllyDonate({})
            callback(msg)

            global.EasyDev:tDLeaveGuild(unionId, unionName, "missUnion")
        end
    end

    gameReq.CallRpc("union","AllyDismissReq",rsp_call,pbmsg)
end

--退出联盟
function _M:sendExitAlly()
    print("###########sendExitAlly()")
    local pbmsg = msgpack.newmsg("ExitAllyReq")

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then

        end
    end

    gameReq.CallRpc("union","ExitAllyReq",rsp_call,pbmsg)
end

--获取成员列表
function _M:getAllyMemberlist(callback,lID)
    local pbmsg = msgpack.newmsg("AllyMemberlistReq")
    pbmsg.lID = lID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("union","AllyMemberlistReq",rsp_call,pbmsg)
end

-- 检查输入名字字符
function _M:checkNameStr(szName, callback)
    local pbmsg = msgpack.newmsg("CheckStringReq")
    pbmsg.szName = szName

    local rsp_call = function(ret, msg) 
        msg.retcode = ret.retcode
        callback(msg)
    end
    gameReq.CallRpc("union", "checkNameStr", rsp_call, pbmsg)
end

-- optional string     szName      = 1;//联盟名称
-- optional string     szShortName = 2;//联盟简称
-- optional string     szInfo      = 3;//宣言
-- optional string     szNotice    = 4;//公告
-- optional int32      lAutoApprove    = 5;//是否自动审批，1=否，2=是
-- optional int32      lLanguage   = 6;//语言
function _M:setAllyUpdate(texts, callback)
    local pbmsg = msgpack.newmsg("AllyUpdateReq")
    local data = global.unionData:getInUnion()

    pbmsg.szName = texts.szName 
    pbmsg.szShortName = texts.szShortName
    pbmsg.szInfo = texts.szInfo
    pbmsg.szNotice = texts.szNotice
    pbmsg.lAutoApprove = tonumber(texts.lAutoApprove or data.lAutoApprove)
    pbmsg.lLanguage = tonumber(texts.lLanguage or data.lLanguage)
    pbmsg.lMinCityGrade = tonumber(texts.lMinCityGrade or data.lMinBuild)
    pbmsg.lMinPower = tonumber(texts.lMinPower or data.lMinPower)
    pbmsg.lTotem = tonumber(texts.lTotem or data.lTotem)
    pbmsg.lUpdateID = texts.lUpdateID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyUpdateReq", rsp_call, pbmsg)
end
function _M:setAllyRight(callback,tgAllyRight)
    local pbmsg = msgpack.newmsg("SetAllyRightReq")
    pbmsg.tgAllyRight = tgAllyRight

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "SetAllyRightReq", rsp_call, pbmsg)
end
function _M:getAllyRight(callback)
    local pbmsg = msgpack.newmsg("GetAllyRightReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyRightReq", rsp_call, pbmsg, false)
end


-- required int32      lType   = 1;//1申请官职,2分配官职,3分配等级 , 8 -- 同意别人邀请入盟
-- required int32      lParam  = 2;//官职或等级
-- optional int32      lTargetID = 3;  //操作对象
function _M:allyAction(callback,lType,lParam,lTargetID,failCall)
    local pbmsg = msgpack.newmsg("AllyActionReq")
    pbmsg.lType = lType
    pbmsg.lParam = lParam
    pbmsg.lTargetID = lTargetID

    if lType <= 2 or lType == 5 or lType == 6 then 
        --申请和分配官职特殊处理
        pbmsg.lParam = math.pow(2,pbmsg.lParam-1)
    end


    if lType ~= 8 and  lTargetID and global.userData:getUserId() == lTargetID then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
        else
            if failCall then failCall(ret,msg) end
        end
    end
    gameReq.CallRpc("union", "AllyActionReq", rsp_call, pbmsg)
end


function _M:tickMember(callback,lUserID)
    local pbmsg = msgpack.newmsg("AllyQuitReq")
    pbmsg.lUserID = lUserID

    if lUserID and global.userData:getUserId() == lUserID then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.tipsMgr:showWarning("unionFromOK")
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
        else
            global.tipsMgr:showWarning("unionPowerNot")
        end
    end
    gameReq.CallRpc("union", "AllyQuitReq", rsp_call, pbmsg)
end

--获取联盟奇迹列表
function _M:getAllyMiracle(callback,lAllyID)
    local pbmsg = msgpack.newmsg("GetAllyMiracleReq")
    pbmsg.lAllyID = lAllyID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyMiracleReq", rsp_call, pbmsg)
end

--获取相关盟友
function _M:getAllyMemUserByKey(callback,lID,szKey,errorCall)
    local pbmsg = msgpack.newmsg("AllyMemberlistReq")
    pbmsg.lID = lID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            msg.tgMember = msg.tgMember or {}
            local data = {}
            data.lPage = 1
            data.tgUser = {}
            if szKey and szKey ~= "" then
                for i,v in ipairs(msg.tgMember) do
                    if string.find(string.upper(v.szName),string.upper(szKey)) then
                        table.insert(data.tgUser,v)
                    end
                end
                if #data.tgUser <= 0 then
                    --传入搜索key 并且没有查找到对应数据
                    global.tipsMgr:showWarning("UnionPlyaerNon")
                end
            else
                data.tgUser = clone(msg.tgMember)
            end
            callback(data)
        else
            if errorCall then errorCall(ret) end
        end
    end
    gameReq.CallRpc("union", "AllyMemberlistReq", rsp_call, pbmsg)
end


--获取可邀请用户列表
function _M:getRandUser(callback,lPage,szKey,errorCall)
    local pbmsg = msgpack.newmsg("GetRandUserReq")
    pbmsg.lPage = lPage
    pbmsg.szKey = szKey

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            msg.tgUser = msg.tgUser or {}
            if szKey and #msg.tgUser <= 0 then
                --传入搜索key 并且没有查找到对应数据
                global.tipsMgr:showWarning("UnionPlyaerNon")
            end
            callback(msg)
        else
            if errorCall then errorCall(ret) end
        end
    end
    gameReq.CallRpc("union", "GetRandUserReq", rsp_call, pbmsg)
end

--获取玩家最近分享战报列表
function _M:getFightShareList(callback,lTarget)
    local pbmsg = msgpack.newmsg("CTFightShareListReq")
    pbmsg.lTarget = lTarget

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpcSilentAndNoRetry("union", "CTFightShareListReq", rsp_call, pbmsg)
end

--获取联盟外交列表
function _M:getAllyRelationList(callback)
    local pbmsg = msgpack.newmsg("AllyRelationListReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyRelationListReq", rsp_call, pbmsg)
end

--设置联盟关系
-- required int32      lType       = 1;//1请求2回应
-- required int32      lTargetAlly = 2;//目标联盟ID
-- required int32      lRelation   = 3;//关系值 0:中立,1:自己,2:同盟,3:联盟友好,4:敌对
function _M:setAllyRelation(callback,lType,lTargetAlly,lRelation)
    local pbmsg = msgpack.newmsg("AllyRelationReq")
    pbmsg.lType = lType
    pbmsg.lTargetAlly = lTargetAlly
    pbmsg.lRelation = lRelation

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_FOREIGN_PANEL)
        else
            if ret.retcode == 1 then
                gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_FOREIGN_PANEL)
            end
        end
    end
    gameReq.CallRpc("union", "AllyRelationReq", rsp_call, pbmsg)
end

--联盟战争
function _M:getAllyWarInfo(callback,lMapID)
    local pbmsg = msgpack.newmsg("GetAllyWarInfoReq")
    pbmsg.lMapID = lMapID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyWarInfoReq", rsp_call, pbmsg, false)
end
--联盟战争请求援助
-- 1:攻击  2：防御 0：无
function _M:askSupportForAllyWar(callback,lMapID,lSupportType)
    local pbmsg = msgpack.newmsg("AllyUserWarSupportReq")
    pbmsg.lMapID = lMapID
    pbmsg.lSupportType = lSupportType

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyUserWarSupportReq", rsp_call, pbmsg)
end

-- 联盟留言
function _M:getAllyMsgList(callback,lAllyID, lPage)
    local pbmsg = msgpack.newmsg("AllyMsgListReq")
    pbmsg.lAllyID = lAllyID or global.userData:getlAllyID()
    pbmsg.lPage = lPage

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if msg.tgMsg then
                local maxId = cc.UserDefault:getInstance():getIntegerForKey(WDEFINE.USERDEFAULT.UNION_MESSAGE_READ_ID..global.userData:getAccount()) or 0
                for k,v in pairs(msg.tgMsg) do
                    if v.lID > maxId then
                        maxId = v.lID
                    end
                end
                cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.UNION_MESSAGE_READ_ID..global.userData:getAccount(), maxId)
                gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
            end
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyMsgListReq", rsp_call, pbmsg)
end

function _M:sendAllyLeaveMsg(callback,lAllyID,szContent)
    local pbmsg = msgpack.newmsg("AllyLeaveMsgReq")
    pbmsg.lAllyID = lAllyID or global.userData:getlAllyID()
    pbmsg.szContent = szContent


    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyLeaveMsgReq", rsp_call, pbmsg)
end

-- 联盟战争记录
function _M:getAllyWarRecord(callback)
    local pbmsg = msgpack.newmsg("AllyWarRecordReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyWarRecordReq", rsp_call, pbmsg)
end

-- 联盟动态
function _M:getDynamic(callback, lAllyID, lPage)
    
    local pbmsg = msgpack.newmsg("AllyActListReq")
    pbmsg.lAllyID = lAllyID
    pbmsg.lPage = lPage

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if msg.tgAct then
                local maxId = cc.UserDefault:getInstance():getIntegerForKey(WDEFINE.USERDEFAULT.UNION_DYNAMIC_READ_ID..global.userData:getAccount()) or 0
                for k,v in pairs(msg.tgAct) do
                    if v.lID > maxId then
                        maxId = v.lID
                    end
                end
                cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.UNION_DYNAMIC_READ_ID..global.userData:getAccount(), maxId)
                gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
            end
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyActListReq", rsp_call, pbmsg)

end

-- 联盟捐献
function _M:donateAllyEndow(callback, lID, lCount)
    
    local pbmsg = msgpack.newmsg("AllyEndowReq")
    pbmsg.lID = lID
    pbmsg.lCount = lCount

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlAllyDonate(msg)
            global.unionData:setInUnionStrong(msg.lAllyStrong)
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_DONATE)
        end
    end
    gameReq.CallRpc("union", "AllyEndowReq", rsp_call, pbmsg)
end
--联盟捐献排行
function _M:getUserRankList(callback, lID, lPage)
    
    local pbmsg = msgpack.newmsg("GetUserRankListReq")
    pbmsg.lID = lID
    pbmsg.lPage = 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetUserRankListReq", rsp_call, pbmsg)

end
--联盟任务列表
function _M:getAllyTaskList(callback)
    
    local pbmsg = msgpack.newmsg("GetAllyTaskListReq")
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyTaskListReq", rsp_call, pbmsg)

end
--领取联盟任务奖励
function _M:getAllyTaskBonus(callback, lID)
    
    local pbmsg = msgpack.newmsg("AllyTaskBonusReq")
    pbmsg.lID = lID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlAllyStrong(msg.lStrong)
            callback(msg)
            global.unionApi:getRedCount(function() end,nil)
        end
    end
    gameReq.CallRpc("union", "AllyTaskBonusReq", rsp_call, pbmsg)

end
--开启联盟任务
function _M:openAllyTask(callback, lTaskID)
    
    local pbmsg = msgpack.newmsg("AllyTaskActiveReq")
    pbmsg.lTaskID = lTaskID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyTaskActiveReq", rsp_call, pbmsg)

end

--拉取排行榜第一名列表
function _M:getTopRankList(callback)
    
    local pbmsg = msgpack.newmsg("GetTopListReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetTopListReq", rsp_call, pbmsg)

end

--联盟建设的功能建设
function _M:startAllyBuild(callback,lID,lType)
    
    local pbmsg = msgpack.newmsg("AllyBuildActionReq")
    pbmsg.lID = lID
    pbmsg.lType = lType or 0

    if pbmsg.lType == 1 then
        if not global.unionData:isHadPower(17) then
            return global.tipsMgr:showWarning("unionPowerNot")
        end
    end
    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if pbmsg.lType == 1 then
                --联盟帮助个人贡献
                global.userData:setlAllyStrong(msg.lAllyStrong)
            else
                --建设
                global.unionData:setInUnionStrong(msg.lAllyStrong)
            end
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyBuildActionReq", rsp_call, pbmsg)

end

--获取联盟详细信息
function _M:getUnionInfo(callback, lAllyID)
    
    local pbmsg = msgpack.newmsg("GetPubAllyInfoReq")
    pbmsg.lAllyID = lAllyID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "getUnionInfo", rsp_call, pbmsg)

end

--获取联盟正在研究建筑信息
function _M:getAllyBuildState(callback, lAllyID)
    
    local pbmsg = msgpack.newmsg("GetAllyBuildStateReq")
    pbmsg.lAllyID = lAllyID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyBuildStateReq", rsp_call, pbmsg)

end

---------------------联盟商店---->>>>>>>
function _M:getAllyShop(callback, lType)
    --获取商品列表
    local pbmsg = msgpack.newmsg("GetAllyShopReq")
    pbmsg.lType = lType

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyShopReq", rsp_call, pbmsg)
end
function _M:setAllyShopAction(callback, lType,lID,lCount)
    --获取商品列表
    -- required int32      lType = 1;//1.购买，2.进货
    -- required int32      lID = 2;//商品id
    -- required int32      lCount = 3;//数量
    local pbmsg = msgpack.newmsg("AllyShopActionReq")
    pbmsg.lType = lType
    pbmsg.lID = lID
    pbmsg.lCount = lCount

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            -- body
            if lType == 1 then
                --个人贡献
                global.userData:setlAllyStrong(msg.lStrong)
            else
                global.unionData:setInUnionStrong(msg.lAllyStrong)
            end
            if msg.lDiamonds then
                global.propData:setProp(WCONST.ITEM.TID.DIAMOND, msg.lDiamonds)
            end
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "AllyShopActionReq", rsp_call, pbmsg)
end
function _M:getAllyBuyRecordList(callback)
    --联盟购买记录
    local pbmsg = msgpack.newmsg("GetAllyBuyListReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end
    gameReq.CallRpc("union", "GetAllyBuyListReq", rsp_call, pbmsg)
end

-- noShowMsgAndDynamicRed： true-->不显示联盟动态和留言红点
function _M:getRedCount(callback,lID,noShowMsgAndDynamicRed)
    --联盟购买记录
    local pbmsg = msgpack.newmsg("GetRedCountReq")
    pbmsg.lID = lID or 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlAllyRedCount(msg.tagRed,noShowMsgAndDynamicRed)
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
        end
    end
    gameReq.CallRpc("union", "GetRedCountReq", rsp_call, pbmsg)
end

-- 联盟村庄
function _M:getVillageList(callback, lPage)
    -- body
    local pbmsg = msgpack.newmsg("AllyVillageListReq")
    pbmsg.lPage = lPage 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)        
        end
    end
    gameReq.CallRpc("union", "AllyVillageListReq", rsp_call, pbmsg)
end

-- 个人外交协议
function _M:getUserRelationShip(callback, lType, lParam)
    -- body
    local pbmsg = msgpack.newmsg("GetUserRelationshipReq")
    pbmsg.lType = lType 
    pbmsg.lParam = lParam 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)        
        end
    end
    gameReq.CallRpc("union", "GetUserRelationshipReq", rsp_call, pbmsg)
end

-- 好友申请
-- required int32  lType           = 1;// 1.拉取好友列表和申请列表 2.添加好友 3.删除好友  4.同意申请 5.拒绝申请
-- optional int32  lParam      = 2;//UID

-- ["Friend01"] = { keyWord="Friend01",  id=478,  text="您尚未建造大使馆，无法加其他玩家为好友，请先建造大使馆"},
-- ["Friend02"] = { keyWord="Friend02",  id=479,  text="该玩家没有建造大使馆，无法加该玩家为好友"},
-- ["Friend03"] = { keyWord="Friend03",  id=480,  text="你们已经是好友了"},
-- ["Friend04"] = { keyWord="Friend04",  id=481,  text="您已经在对方的申请列表中了，请等待对方处理"},
-- ["Friend05"] = { keyWord="Friend05",  id=482,  text="对方已经在您的申请列表中了，是否同意加为好友？",
-- ["Friend06"] = { keyWord="Friend06",  id=483,  text="好友申请成功，请等待对方处理", 
function _M:getFriendList(callback, lType, lParam)
    -- body
    local pbmsg = msgpack.newmsg("GetUserFriendReq")
    pbmsg.lType = lType 
    pbmsg.lParam = lParam 

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            if lType == 2 then
                global.tipsMgr:showWarning("Friend06")
            end

            if lType == 2 then
                global.EasyDev:tDAddFriend(tostring(lParam or ""))
            elseif lType == 3 then
                global.EasyDev:tDDelFriend(tostring(lParam or ""))
            end

        elseif ret.retcode == 478 then  
            global.tipsMgr:showWarning("Friend01")
        elseif ret.retcode == 479 then
            global.tipsMgr:showWarning("Friend02") 
        elseif ret.retcode == 480 then 
            global.tipsMgr:showWarning("Friend03")
        elseif ret.retcode == 481 then    
            global.tipsMgr:showWarning("Friend04") 
        elseif ret.retcode == 482 then
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("Friend05", function()
                global.unionApi:getFriendList(function (msg)
                    gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
                    global.tipsMgr:showWarning("Friend08")
                end, 4, lParam)
            end)
        end
    end
    gameReq.CallRpc("union", "GetUserFriendReq", rsp_call, pbmsg)
end

-- 帮助列表
function _M:HelpList(callback)
    -- body
    local pbmsg = msgpack.newmsg("GetAllyBuildHelpReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)        
        end
    end
    gameReq.CallRpc("getHelpList", "GetAllyBuildHelpReq", rsp_call, pbmsg)
end


-- 帮助建造
function _M:helpBuild(helpArr , callback)
 -- body
    local pbmsg = msgpack.newmsg("AllyHelpReq")
    pbmsg.lHelpID = helpArr

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callback(msg)        
        end
    end
    gameReq.CallRpc("helpBuild", "AllyHelpReq", rsp_call, pbmsg)
end


-- 联盟英雄经验池
function _M:heroSpring(callback, lType, lHeroID, lID , lItemID , upDateLocalData , station)
    -- body
    local pbmsg = msgpack.newmsg("AllyHeroSpringReq")
    pbmsg.lType = lType
    pbmsg.lHeroID = lHeroID
    pbmsg.lID = lID
    pbmsg.lItemID = lItemID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if upDateLocalData then 
                global.unionData:setHeroExpData(msg)
            end 
            if callback then 
                callback(msg)
            end 
            gevent:call(global.gameEvent.EV_ON_UNION_HEREXPUPDATE,station)
            gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
        end
    end
    gameReq.CallRpc("heroSpring", "AllyHeroSpringReq", rsp_call, pbmsg)
end



function _M:updateHeroSpring(station)
    global.unionApi:heroSpring(nil , 4 , 0 , nil , nil , true ,station)
end 

-- 联盟资源运输
function _M:unionTroopTransportRes(params,callback)
    local pbmsg = msgpack.newmsg("TroopTransportReq")
    pbmsg.lStartUniqueID = params.lStartUniqueID
    pbmsg.lEndUniqueID = params.lEndUniqueID
    pbmsg.lAttackType = params.lAttackType
    pbmsg.lTroopID = params.lTroopID
    pbmsg.tgParam = params.tgParam

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if callback then 
                callback(msg)
            end 
        end
    end
    gameReq.CallRpc("union", "TroopTransport", rsp_call, pbmsg)
end 


global.unionApi = _M

--endregion

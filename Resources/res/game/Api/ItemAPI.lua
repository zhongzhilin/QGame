--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

-- 道具使用
function _M:itemUse(id,count,param,targetId,callBack,szParam)
    
    local pbmsg = msgpack.newmsg("UseItemReq")
    pbmsg.lID = id
    pbmsg.lCount = count
    pbmsg.lParam = param
    pbmsg.lTargetID = targetId
    pbmsg.szParam = szParam

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if msg.tgPlus then
                global.buffData:setServerBuffsBy(msg.tgPlus)
            end
            callBack(msg)

            local item =  global.luaCfg:get_item_by(id)
            if item and item.itemType == 101 and  item.typePara1 then 
                for _ , v in pairs(global.luaCfg:get_drop_by(item.typePara1).dropItem) do 
                    if v[1] <= 4 then 
                        local soundKey = "ui_harvest_"..v[1] 
                        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)
                    end 
                end                 
            end 
        end
    end
    gameReq.CallRpc("item", "item_use", rsp_call, pbmsg)
end

-- 魔晶使用
-- required int32      lType       = 1;    //4:资源加速
-- optional int32      lParam      = 2;    //使用参数
-- optional int32      lTargetID   = 3;    //使用对象
function _M:diamondUse(callBack,lType,lParam,lTargetID,lToolID, lExParam, szExParam, errorCall)
    local pbmsg = msgpack.newmsg("UseDiamondsReq")
    pbmsg.lType = lType
    pbmsg.lParam = lParam
    pbmsg.lTargetID = lTargetID
    pbmsg.lToolID = lToolID
    pbmsg.lExParam = lExParam
    pbmsg.szExParam = szExParam

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if msg.tgPlus then
                global.buffData:setServerBuffsBy(msg.tgPlus)
            end

            if lToolID and lType and lParam and lType == 1 and lParam == 1  then 
                local item = global.luaCfg:get_item_by(lToolID)
                if item and item.itemType == 101 and  item.typePara1 then 
                    for _ , v in pairs(global.luaCfg:get_drop_by(item.typePara1).dropItem) do 
                        if v[1] <= 4 then 
                            local soundKey = "ui_harvest_"..v[1] 
                            gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)
                        end 
                    end                 
                end 
            end 

            callBack(msg)
        else
            if errorCall then 
                errorCall(ret,msg) 
            else
                local errorData = global.luaCfg:get_errorcode_by(tostring(ret.retcode))
                if errorData then
                    global.tipsMgr:showWarning(tostring(ret.retcode))
                end
            end
        end
    end
    gameReq.CallRpc("item", "diamond_use", rsp_call, pbmsg)
end

-- 战斗力详细
function _M:combatRank(callBack)
    local pbmsg = msgpack.newmsg("GetUserRankReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end
    gameReq.CallRpc("combat", "combat_rank", rsp_call, pbmsg)
end

function _M:GMGetItem(callback,itemId,count)
    
    local pbmsg = msgpack.newmsg("GMGetItemReq")
    pbmsg.lId = itemId
    pbmsg.lCount = count

    local rsp_call = function(ret,msg)


        if ret.retcode == WCODE.OK then

            callback(msg)
        end
    end

    gameReq.CallRpc("itemGm","getItem",rsp_call,pbmsg)
end

function _M:GMGetEquip(callback,itemId)
    
    local pbmsg = msgpack.newmsg("GMGetEquipReq")
    pbmsg.lId = itemId    

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then

            callback(msg)
        end
    end

    gameReq.CallRpc("itemGm","GMGetEquipReq",rsp_call,pbmsg)
end

function _M:swapEquip(opType,equipId,heroId,index,callback)
    

    local pbmsg = msgpack.newmsg("SwapEquipReq")
    pbmsg.lOpType = opType
    pbmsg.lEquipID = equipId
    pbmsg.lHeroID = heroId
    pbmsg.lSlot = index    

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then

            callback(msg)

            if heroId == 1 then --领主装备buff 更新
                global.userData:updateLordEquipBuff()
            end 
        end
    end

    gameReq.CallRpc("itemGm","SwapEquipReq",rsp_call,pbmsg)
end

function _M:sellItem(itemId,itemCount,callback)
   
    local pbmsg = msgpack.newmsg("SaleItemReq")
    pbmsg.tgItems = {{lID = itemId,lValue = itemCount}}     

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then

            callback(msg)
        end
    end

    gameReq.CallRpc("itemGm","SaleItemReq",rsp_call,pbmsg)     
end

function _M:deleteEquip(equips,callback)
        
    local pbmsg = msgpack.newmsg("EquipSplitReq")
    pbmsg.lEquips = equips

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then

            callback(msg)
        end
    end

    gameReq.CallRpc("Equip","EquipSplitReq",rsp_call,pbmsg)
end

function _M:equipStrong(equipId,balances,rate,callback)

    local pbmsg = msgpack.newmsg("EquipStrongReq")
    pbmsg.lEquipID = equipId    
    pbmsg.tgBalance = balances
    
    if rate then
        pbmsg.tgRate = rate
    end

    local rsp_call = function(ret,msg)

        if ret.retcode == WCODE.OK then

            callback(msg)
        end
    end

    gameReq.CallRpc("Equip","EquipStrongReq",rsp_call,pbmsg) 
end

function _M:equipForge(lEquipID, callback)

    local pbmsg = msgpack.newmsg("EquipForgeReq")
    pbmsg.lEquipID = lEquipID    

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            gevent:call(global.gameEvent.EV_ON_EQUIP_FORGIN_POINT)
        end
    end

    gameReq.CallRpc("Equip","equipForge",rsp_call,pbmsg) 
end

-- 魔晶库和开服基金
-- required int32      lKind = 1;  //1存款 2基金
-- required int32      lType = 2;  //操作档位
-- required int32      lOperate = 3;   //操作类型0查看1储蓄2取出/领取
-- optional int32      lParam = 4;  //操作数量  
-- optional int64      lTarget = 5;    //操作目标 (存款单id)

function _M:bankAction(callback, lKind, lType, lOperate, lParam, lTarget)

    local pbmsg = msgpack.newmsg("BankActionReq")
    pbmsg.lKind = lKind    
    pbmsg.lType = lType
    pbmsg.lOperate = lOperate
    pbmsg.lParam = lParam
    pbmsg.lTarget = lTarget

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            global.propData:initDiamond(msg)
            callback(msg)
        end
    end

    gameReq.CallRpc("diamond","bankAction",rsp_call,pbmsg,true)
end

-- 军工商店
-- required int32      lType = 1;  //操作类型  1.每日领取金币  2.军功购买道具
-- optional int32      lParam = 2; //参数
-- optional int32      lCount = 3; //参数
function _M:exploitAction(callback, lType, lParam, lCount)

    local pbmsg = msgpack.newmsg("ExploitActionReq")
    pbmsg.lType = lType    
    pbmsg.lParam = lParam
    pbmsg.lCount = lCount

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
            if lType == 1 then
                gevent:call(global.gameEvent.EV_ON_EXPLOIT_GETREWARD)
            end
        end
    end

    gameReq.CallRpc("exploit","exploitAction",rsp_call,pbmsg) 
end

-- 兑换商店
-- required int32      lItemID = 1;//兑换的英雄碎片ID
-- required int32      lChangeID   = 2;//兑换方式ID
-- required int32      lCount  = 3;//兑换方式数量
function _M:changeShop(callback, lItemID, lChangeID, lCount)

    local pbmsg = msgpack.newmsg("ExchangeItemReq")
    pbmsg.lItemID = lItemID    
    pbmsg.lChangeID = lChangeID
    pbmsg.lCount = lCount

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("change","changeShop",rsp_call,pbmsg) 
end


function _M:updateBankDate(call)
    self:bankAction(function (msg)
        if call then 
            call()
        end 
        -- dump(msg,"魔晶库和开服基金")
    end ,2, 1 , 0 , 0, 0)
end 


global.itemApi = _M

--endregion

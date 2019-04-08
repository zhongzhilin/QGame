--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local gameReq = global.gameReq
local msgpack = require "msgpack"

local _M = {}

function _M:addItem(tid, num)
    gameReq.GmCmd("add_item", {tid = tid, num = num})
end

function _M:onekeyAddItem(itemType, itemNum)
    gameReq.GmCmd("onekey_additem", {typ = itemType, num = itemNum})
end

function _M:sendGMRpc(cmd, param, callBack)
    if cmd == "call_rpc" then
        self:callRpc(param.rpcname, param.luatable, callBack)
    else
        if callBack then
            gameReq.GmCmd(cmd, callBack, param)
        else
            gameReq.GmCmd(cmd, param)
        end
    end
end

function _M:callRpc(rpcname, tabledata, callBack)
    local names = string.split(rpcname, ".")
    if #names ~= 2 then
        assert(false, "error, incorrect rpcname!")
        return
    end

    local function callbak()

    end

    local module_, rpc = names[1], names[2]
    gameReq.CallRpc(module_, rpc, callBack or callbak, tabledata)
end

-- buffer 效果
function _M:effectBuffer(tgReq, callback,modalTag)

    local pbmsg = msgpack.newmsg("AllEffectInfoReq")
    pbmsg.tgReq = tgReq

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(self:changePetBuff(msg))
        end
    end

    gameReq.CallRpc("effect","effectBuffer",rsp_call,pbmsg,modalTag or 2)
end

-- 神兽技能buff转化
function _M:changePetBuff(msg)
    -- body
    for i,v in ipairs(msg.tgEffect or {}) do
        for k,vv in ipairs(v.tgEffect or {}) do
            if vv.lFrom == 14 then
                local petPer = global.luaCfg:get_pet_activation_by(1).skillExpand
                v.tgEffect[k].lVal = v.tgEffect[k].lVal/petPer
            end
        end
    end
    return msg
end

function _M:gmColStrong(beginLv,toLv,count,callback)

    local pbmsg = msgpack.newmsg("GMEquipStrongReq")
    pbmsg.lBeginlv = beginLv
    pbmsg.lCount = count
    pbmsg.lTolv = toLv

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("effect","GMEquipStrongReq",rsp_call,pbmsg)   
end

global.gmApi = _M
--endregion

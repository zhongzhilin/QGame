--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gameReq = global.gameReq
local msgpack = require "msgpack"
local _M = {}

function _M:actionPet(callback, lID, lGodType, lType, lOptionType, lResCount, lEquipID)
    
    local pbmsg = msgpack.newmsg("GodAnimalActionReq")
    pbmsg.lID = lID
    pbmsg.lGodType = lGodType
    pbmsg.lType = lType
    pbmsg.lOptionType = lOptionType
    pbmsg.lResCount = lResCount
    pbmsg.lEquipID = lEquipID

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            
            local oldPetLv = global.petData:getGodAnimalLv(lGodType)
            callback(msg)

            -- 显示神兽升级页面
            local curPetLv = global.petData:getGodAnimalLv(lGodType)
            if lID == 2 and curPetLv > oldPetLv then
                global.panelMgr:openPanel("UIPetLvUp"):setData(global.petData:getGodAnimalByType(lGodType), oldPetLv)
            end
            if lID == 4 then -- for GUIID 
                 gevent:call(global.gameEvent.EV_ON_GUIDE_UNLOCK_PET)
            end 

        end
    end

    gameReq.CallRpc("pet","actionPet",rsp_call,pbmsg)
end

function _M:getSkill(callback, lGodType, ltype)
    
    local pbmsg = msgpack.newmsg("GetGodAnimalSKillReq")
    pbmsg.ltype = ltype
    pbmsg.lGodType = lGodType

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("pet","getSkill",rsp_call,pbmsg)
end

function _M:actionSkill(callback, lGodType, ltype, lSkillID, lKind)
    
    local pbmsg = msgpack.newmsg("GodAnimalSKillActionReq")
    pbmsg.ltype = ltype
    pbmsg.lGodType = lGodType
    pbmsg.lSkillID = lSkillID
    pbmsg.lKind = lKind

    local rsp_call = function(ret,msg)
        if ret.retcode == WCODE.OK then
            callback(msg)
        end
    end

    gameReq.CallRpc("pet","actionSkill",rsp_call,pbmsg)
end

global.petApi = _M

--endregion

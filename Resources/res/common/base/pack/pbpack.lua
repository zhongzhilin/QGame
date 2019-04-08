
require "protobuf"

---@classdef pbpack
local pbpack = {
    pkgname_ = "yy.",
    pbfile_ = "", 
    init_ = false,
}

function pbpack.init(conf)
    if pbpack.init_ == true then
        return
    end
    
    pbpack.pkgname_ = conf.pkg
    pbpack.pbfile_ = conf.pbfile 
    
    local filedata = CCHgame:GetFileData(pbpack.pbfile_)
    if not filedata then
        log.error("failed to load protobuf description file:" .. pbpack.pbfile_)
        return
    end
    protobuf.register(filedata) 

    pbpack.init_ = true
end

function pbpack.pack(msg, mtype)
    if pbpack.init_ == false then
        assert(false, "pbpack not init")
    end
    local msgtype = pbpack.pkgname_ .. mtype
    log.debug("#############pbpack.pack msgtype:%s,%s",msgtype,vardump(msg))
    local status, result = xpcall(protobuf.encode, hqxpcall_error, msgtype, msg)
    if status then 
        return result 
    end
    
    log.error("encode protobuf faild, type:%s, err:%s", msgtype, tostring(result))
    return nil
end

function pbpack.unpack(bin, mtype, all)
    if pbpack.init_ == false then
        return nil
    end
    
    if all == nil then all = true end
    local msgtype = pbpack.pkgname_ .. mtype
    local status, result, errStr
    if all == true then
        status, result, errStr = xpcall(protobuf.decodeAll, hqxpcall_error, msgtype, bin)
        --result, err = protobuf.decodeall(msgtype, bin)
    else 
        status, result, errStr = xpcall(protobuf.decode, hqxpcall_error, msgtype, bin)
    end
    
    if status then 
        if type(result) == "table" then
            --OK
            return result 
        else
            log.error("decode protobuf msg failed, type:%s,status=%s,result=%s,errStr=%s", msgtype,status,result,errStr)
            return nil
        end
    end
    
    log.error("decode protobuf faild, type:%s, err:%s", msgtype, tostring(result));
    return nil   
end

function pbpack.newmsg(msgtype)
    return {
        enctype__ = "pb",
        msgtype__ = msgtype,
    }
end
    
function pbpack.check(typename)
    if pbpack.init_ == false then
        return false
    end

    return protobuf.check(pbpack.pkgname_ .. typename)
end

return pbpack


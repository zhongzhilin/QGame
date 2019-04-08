
local pbpack = require "pbpack"
local struct = require "struct"
local json   = require "json"
local crypto = require "hqgame"

---@classdef msgpack
local msgpack = {  

    -- 后台见  hqpacket.go
    EN_BODY_PB     = 1,
    EN_BODY_JSON   = 2,
    EN_BODY_BIN    = 3,
    
    HQPKG_KIND_CS   = 1,
    HQPKG_KIND_SS   = 2,
    HQPAC_VER_INIT  = 1,
    HQPAC_BINHD_LEN = 24,
    
    HQPKG_MAX = 40,
    
    mconf = {},
    
    mhddef = {typ = crypto.ENCRYPT_NONE, key = crypto.clef(0) },
    mbddef = {typ = crypto.ENCRYPT_XOR, key = crypto.clef(0) },
}

function msgpack.init(conf)
    conf = conf or { pbcfg = {pbfile = "tbin/cmd.pb", pkg = "yy."}, max_cli = 1024*5, max_svr = 1024 * msgpack.HQPKG_MAX}
    local app_cfg = require "app_cfg"
    if app_cfg.is_crypto() == false then
        log.info("!!! run in uncrypt mode.")
        msgpack.mhddef.typ = crypto.ENCRYPT_NONE
        msgpack.mbddef.typ = crypto.ENCRYPT_NONE
    end
    msgpack.mconf = conf
    pbpack.init(msgpack.mconf.pbcfg)
end

function msgpack.get_bddef_enc()
    return { typ = msgpack.mbddef.typ, key = msgpack.mbddef.key }
end

-- 只支持PB编码
-- enc = {typ, key}
function msgpack.pkg_pack(csmsg, enc)  
    local pkg = csmsg.pkg
    local head = csmsg.head
    local msgtype = csmsg.msgtype
    local bdData = ""
    
    -- 包体编码
    local ptype = table.find(WPBCONST, head.Type) 
    if ptype == nil then
        log.error("############pkg_pack pkgtype invalid:" .. ptype or "INVALID")
        return nil
    end
    bdData = msgpack.pbpack(csmsg)
    if bdData == nil then
        log.error("############pkg_pack pbpack failed:" .. ptype)
        return nil
    end
    local enc_bddata = crypto.encrypt(enc.typ, bdData, enc.key)
    if enc_bddata == nil then
        log.error("############pkg_pack body crypt failed:" .. ptype)
        return nil    
    end
    print(#bdData,"#bdData",#enc_bddata,"enc_bddata")
    log.debug("pkg_pack bdData:%s,len=%s",string.hex(bdData),#bdData)
    head.OriginLen = #enc_bddata
    head.Len = head.OriginLen+4*6
    log.trace("############pkg_pack pack:%s",vardump(head))
    local hddata = struct.pack("<BBBBIIIII", head.Sign1, head.Sign2, head.Sign3, head.Sign4, head.Type, 
                    head.LinkNum, head.Len, head.Crypt, head.OriginLen)
    -- log.debug("############pkg_pack hddata:%s",string.hex(hddata))
    local enc_hddata = crypto.encrypt(msgpack.mhddef.typ, hddata, msgpack.mhddef.key)            
    if enc_hddata == nil then
        log.error("############pkg_pack head pack failed:" .. ptype)
        return nil
    end
    
    local pkg_data = enc_hddata .. enc_bddata
    -- log.debug("############pkg_pack pack:%s",string.hex(pkg_data))
    return pkg_data  
end

function msgpack.pkg_unpack(data, enc)
     local dlen = #data
    if dlen <= msgpack.HQPAC_BINHD_LEN then
        return WCODE.ERR_PKG_UNPACK_INV_HDLEN, nil
    end
    local ret, hdpkg, hdlen = msgpack.unpack_head(data)
    if ret ~= WCODE.OK then
        return ret, nil
    end
    if enc.typ ~= hdpkg.Crypt then
        log.debug("pkg_unpack inv cc, this:%d, net:%d", enc.typ, hdpkg.Crypt)
        return WCODE.ERR_PKG_UNPACK_INV_CRYPT, nil
    end
    hdpkg.pkg.param = string.sub(data, msgpack.HQPAC_BINHD_LEN+1)
    
    return msgpack.unpack_body(hdpkg, enc)
end

function msgpack.unpack_head(pkgdata)
    local recvlen = #pkgdata
    if recvlen < msgpack.HQPAC_BINHD_LEN then
        log.error("############unpack_head recvlen not enough long:recvlen=%s", recvlen)
        return WCODE.OK, nil, 0
    end
    
    local hddata = string.sub(pkgdata, 1, msgpack.HQPAC_BINHD_LEN)
    
    local Sign, Type, LinkNum, Len, Crypt, OriginLen = struct.unpack("<IIIIII", hddata)
    
    -- if Sign ~= -4370 then
    --     log.error("############unpack_head inva head param:Sign=%s", Sign)
    --     return WCODE.ERR_PKG_HD_DEC_FAILED, nil, 0 
    -- end
    
    local packet = {
        head = {
            Sign = Sign, 
            -- Type = Type-0X1000,  
            Type = Type, 
            LinkNum = LinkNum,   
            Len = Len,   
            Crypt = Crypt,          
            OriginLen = OriginLen,
        },
        pkg = {
            param = {}
        }
    }
    
    -- log.debug("msgpack.unpack_head(pkgdata) param:Type=%s, packet:%s", packet.head.Type, vardump(packet))
    return WCODE.OK, packet, msgpack.HQPAC_BINHD_LEN
end
-- print] - "<var>" = {
-- [LUA-print] -     "head" = {
-- [LUA-print] -         "Crypt"     = 2
-- [LUA-print] -         "Len"       = 43
-- [LUA-print] -         "LinkNum"   = 10
-- [LUA-print] -         "OriginLen" = 11
-- [LUA-print] -         "Sign"      = -4370
-- [LUA-print] -         "Type"      = 4388
-- [LUA-print] -     }
-- [LUA-print] -     "pkg" = {
-- [LUA-print] -         "param" = "x??b?``b~??
-- [LUA-print] -     }
-- [LUA-print] - }

-- 只支持PB编码
-- enc = {typ, key}
function msgpack.unpack_body(i_csmsg, enc)
    local bddata = i_csmsg.pkg.param

    local funzip = zlib.inflate() 
    if i_csmsg.head.Crypt ==1  then --加密
        local dec_data = crypto.decrypt(enc.typ, bddata, enc.key)
        i_csmsg.pkg.param = dec_data
    elseif i_csmsg.head.Crypt == 2  then --压缩
        local inflated, eof, bytes_in, bytes_out = funzip(bddata)  
        -- log.debug("unpack_body:inflated=%s",string.hex(inflated))
        -- log.debug("unpack_body:bytes_out=%s",string.hex(bytes_out))
        -- local dec_data = crypto.decrypt(enc.typ, inflated, enc.key)
        if inflated == nil then
            log.error("unpack_body decrypt failed:%s", enc.typ)
    --        log.debug("enctype:%d, key:%s", enc.typ, string.hex(enc.key))
    --        log.debug("data:%s", string.hex(bddata))
            return WCODE.ERR_PKG_UNPACK_BD_DEC_ERR, nil
        end
        i_csmsg.pkg.param = inflated
    elseif i_csmsg.head.Crypt == 3 then --压缩加密
        local dec_data = crypto.decrypt(enc.typ, bddata, enc.key)
        --log.debug("unpack_body:dec_data=%s",string.hex(dec_data))
        local st,inflated, eof, bytes_in, bytes_out = pcall(funzip,dec_data)
        if st == false then
            print("unpcak_body,error:",WCODE.ERR_PKG_UNPACK_BD_DEC_ERR)
            return WCODE.ERR_PKG_UNPACK_BD_DEC_ERR, nil
        end
        --log.debug("unpack_body:inflated=%s",string.hex(inflated))
        i_csmsg.pkg.param = inflated
    end 
    return msgpack.pbunpack(i_csmsg)
end
-- 将lua结构打包成cs报文()
function msgpack.pbpack(csmsg)
    local userData = global.userData
    local param = csmsg.pkg.param
    local pbtype = csmsg.msgtype
    local seq = csmsg.seq

    if pbtype == nil then
        log.error("msgpack.pbpack pb unpack failed ptype=nil")
        return nil
    end

    local t_ptype = string.sub(pbtype,1,#pbtype-3)
    local field = "tag" .. t_ptype
    local pbmsg = {
        --数据头，根据需要可以增删
        tagHead = {
            lUserID = userData:getUserId(),
            lSeq = seq or 0,
            lToken = global.loginData:getToken()
        }, 
        tagBody = {
        }
    }
    --增加协议数据
    pbmsg.tagBody[field] = param  
    if not pbpack.check(pbtype) then
        pbmsg.tagBody[field] = nil
    end

    -- log.debug("msgpack.pbpack:%s,pbtype=%s",vardump(pbmsg),pbtype)
    local databuf = pbpack.pack(pbmsg, "MSGReq",false)

    return databuf
end

-- 将cs报文（MHQPkg）解包成lua结构
function msgpack.pbunpack(csmsg)

    local hd = csmsg.head
    log.debug("msgpack.pbunpack hd.Type:%s",hd.Type)
    local pbtype = table.keyOfItem(WPBCONST, hd.Type)

    local unpackStruct = ""
    if hd.Type >= 0x01000000 then
        unpackStruct = "MSGNotify"
        csmsg.isNotify = true
    else
        unpackStruct = "MSGResp"
        csmsg.isNotify = false
    end
    if csmsg.unpackStruct then
        unpackStruct = csmsg.unpackStruct
        pbtype = "selfdefine_struct"
    end
    log.debug("msgpack.pbunpack bodydata:%s,pbtype:%s,unpackStruct=%s",csmsg.pkg.param,pbtype,unpackStruct)
    local pbmsg = pbpack.unpack(csmsg.pkg.param, unpackStruct)
    -- log.debug("msgpack.pbunpack pbmsg:%s",vardump(pbmsg))
    if pbmsg == nil then
        log.error("pb unpack failed")
        return WCODE.ERR_PKG_UNPACK_PBDEC_ERR, nil
    end

    csmsg.pkg.param = pbmsg
    csmsg.pbtype = pbtype

    -- 初始化token
    if pbmsg.tagHead and pbmsg.tagHead.lToken and (pbmsg.tagHead.lToken ~= 0) then
        global.loginData:setToken(pbmsg.tagHead.lToken)
    end
    -- log.debug(" 0102===========> msgpack.pbunpack csmsg:%s",vardump(csmsg))
    return WCODE.OK, csmsg
end

-- 默认创建PB格式协议
function msgpack.newmsg(msgtype)
    local msg = {}
    msg.enctype__ = "pb"
    msg.msgtype__ = msgtype
    return msg  
end

-- 检查协议是否存在
function msgpack.checkmsg(msgtype)
    return pbpack.check(msgtype)
end

-- 创建PB包装的js格式协议
function msgpack.newjsmsg(msgtype)
    local msg = {}
    msg.enctype__ = "json"
    msg.msgtype__ = msgtype  
    return msg     
end

-- 检查协议是否存在
function msgpack.checkmsg(msgtype)
    return pbpack.check(msgtype)
end

------------------------------------------------
-- @param msg 格式 {head = {}, msgs = {{},{},{}}}
function msgpack._pb_pre(msg)
    local head = msg.head 
    if head == nil then
        head = {retcode = 0}
    end
    local csmsg = {head = head, body = {}}
    
    local msgnum = 1
    for k, m in pairs(msg.msgs) do
        assert(m.enctype__)
        assert(m.msgtype__)
        if m.enctype__ == "json" then
            csmsg.body[msgnum] = {ptype = "MBox"}
            local fieldname = "vmbox"
            csmsg.body[msgnum]["vmbox"] = {encode = "json", mtype = m.msgtype__}
            m.enctype__ = nil
            m.msgtype__ = nil 
            csmsg.body[msgnum]["vmbox"].mbody = json.encode(m)
        else
            csmsg.body[msgnum] = {ptype = m.msgtype__}
            local fieldname = "v" .. string.lower(m.msgtype__)
            m.enctype__ = nil
            m.msgtype__ = nil 
            csmsg.body[msgnum][fieldname] = m  
        end
        msgnum = msgnum + 1        
    end
    
    return csmsg
end

---
-- @param msg
-- @return  {head = {}, msgs = {{},{},{}}}
function msgpack._pb_after(pbmsg)
    local csmsg = {head = pbmsg.head, msgs = {}}
    
    local msgnum = 1
    for k, m in pairs(pbmsg.body) do
        if m.ptype == "MBox" then
            local boxmsg = m.vmbox 
            -- only json
            csmsg.msgs[msgnum] = json.decode(boxmsg.mbody)
            csmsg.msgs[msgnum].msgtype__ = boxmsg.mtype  
            csmsg.msgs[msgnum].enctype__ = "json"
        else 
            local fieldname = "v" .. string.lower(m.ptype)
            csmsg.msgs[msgnum] = m[fieldname]
            csmsg.msgs[msgnum].msgtype__ = m.ptype
            csmsg.msgs[msgnum].enctype__ = "pb"
        end
        
        msgnum = msgnum + 1        
    end
    
    return csmsg
end


------------------------临时存放位置：自己写的字节解析器-----------------------------------------
-- local loginPb = {
--     msgType = 1,
--     up = {
--         {key = "nUserID", len = 4},
--         {key = "nClientIP", len = 4},
--         {key = "nPartnerID", len = 4},
--         {key = "nPartnerID", len = 65},
--         {key = "nBornSvrID", len = 4},
--         {key = "szAuthenticate", len = 33},
--     },
--     down = {
--         {key = "nRet", len = 4},
--         {key = "nUserID", len = 4},
--         {key = "nTimeZone", len = 4},
--         {key = "tCurTime", len = 4},
--         {key = "tTodayZero", len = 4},
--         {key = "tServerStamp", len = 4},
--         {key = "tIsDay", len = 4},
--     }
-- }

-- local createRolePb = {
--     msgType = 4,
--     up = {
--         {key = "nUserID", len = 4},
--         {key = "nKind", len = 4},
--         {key = "szName", len = 64},
--     },
--     down = {
--         {key = "nRet", len = 4},
--         {key = "nUserID", len = 4},
--     }
-- }

-- local getLoginDetailPb = {
--     msgType = 5,
--     up = {
--         {key = "nUserID", len = 4},
--     },
--     down = {
--         {key = "nRet", len = 4},
--         {key = "nUserID", len = 4},
--         {key = "nLevel", len = 4},
--         {key = "szName", len = 64},
--         {key = "nTotleExp", len = 4},
--         {key = "nCurExp", len = 4},
--         {key = "nTotleMP", len = 4},
--         {key = "nCurMP", len = 4},
--         {key = "nVIPGrade", len = 4},
--         {key = "nLordPower", len = 4},
--         {key = "nUserPic", len = 4},
--         {key = "szCityName", len = 15},
--         {key = "nRes", len = 4},
--         {key = "nStatus", len = 4},
--         {key = "nMap", len = 4},
--         {key = "nCounts", len = 4},
--     }
-- }

-- local pb_by_type = {
--     [1] = loginPb,
--     [3] = createRolePb,
--     [5] = getLoginDetailPb,
-- }

-- local function packCodeBodyByType(i_type,data)
--     local databuf = ""
--     local pb = pb_by_type[i_type].up
--     local upData = {}
--     for i,v in ipairs(pb) do
--         upData[v.key] = data and data[v.key] or 0
--         local i_v = upData[v.key]
--         if v.len ~= 4 then
--             i_v = tostring(i_v)
--             log.debug("i_v.len:%s",#i_v)
--             --确认字符长度
--             local idx = 1   --遍历字节下标
--             local cidx = 1  --遍历字符下标
--             while(idx <= v.len) do
--                 if cidx <= #i_v then
--                     databuf  = databuf .. struct.pack("<IIII", string.byte(i_v,cidx),0,0,0)

--                     idx = idx+4
--                 else
--                     databuf  = databuf .. struct.pack("<I", 0)
--                     idx = idx + 1
--                 end
--                 cidx = cidx + 1
--             end
--         else
--             databuf = databuf..struct.pack("<I",i_v)
--         end
--     end
--     return databuf,upData
-- end

-- local function unpackCodeBodyByType(i_type,i_buffer)
--     if i_buffer then 
--         log.debug("unpackCodeBodyByType:%s,i_type:%s",string.hex(i_buffer),i_type)
--         local pb = pb_by_type[i_type].down
--         local downData = {}
--         local idx = 1   --遍历字节下标
--         for i,v in ipairs(pb) do
--             if v.len ~= 4 then
--                 --确认字符长度
--                 local str = ""
--                 while(idx <= v.len) do
--                     if cidx <= #i_buffer then
--                         str = str .. struct.unpack("<IIII", string.sub(i_buffer,idx,idx+3))

--                         log.debug("i_buffer.idx:%s,str:%s",idx,str)
--                         idx = idx+4
--                     else
--                         idx = idx + 1
--                     end
--                 end
--                 log.debug("i_buffer str:%s",str)
--                 downData[v.key] = str
--             else
--                 log.debug("i_buffer idx:%s,v.len:%s,i_buffer:%s",idx,v.len,i_buffer)
--                 local a = string.sub(i_buffer,idx,idx+v.len-1)
--                 log.debug("a:%s,i_buffer=%s",string.hex(a),string.hex(i_buffer))
--                 downData[v.key] = struct.unpack("<I",a)
--                 idx=idx+v.len
--             end
--         end
--         dump(downData)
--         log.debug("unpackCodeBodyByType:%s",vardump(downData))
--         return downData
--     end
-- end

return msgpack



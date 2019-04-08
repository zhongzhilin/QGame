--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local json = require "json"
local bit = require("bit")

local _M = {
    serverInfoVer = 0,
    isCreateRole  = true,
    accountList = {},
    curBindInfo = {},
 }

function _M:init(msg)
end

 --server ver
function _M:getSerInfoVer()
    return self.serverInfoVer
end

function _M:ResetSerInfoVer()
    self.serverInfoVer = 0
end

function _M:setPlatInfo(msg)
    local m = msg
end

function _M:setAccId(id)
    self.accId = id
end

function _M:getAccId()
    return self.accId or 0
end

function _M:isSelf(accid)
    return self.accId == accid
end

function _M:setChanId(id)
    self.chanId = id
end

function _M:getChanId()
    return self.chanId
end

function _M:setOpenId(id)
    self.openId = id
end

function _M:getOpenId()
    return self.openId or 0
end

function _M:setOpenKey(key)
    self.openKey = key
end

function _M:getOpenKey()
    return self.openKey or 0
end

function _M:setHttpSc(key)
    self.qSc = key
end

function _M:getHttpSc()
    return self.qSc
end

function _M:setHttpSn(key)
    self.qSn = key
end

function _M:getHttpSn()
    return self.qSn
end

function _M:setTmExpire(key)
    self.tmExpire = key
end

function _M:getTmExpire()
    return self.tmExpire
end

function _M:getLoginAuth()
    local auth = {
        accid = self.accId,
        openid = self.openId,
        openkey = self.openKey,
        hqtoken = self.hqToken,
        tmexpire = self.tmExpire,
        chanid = self.chanId,
    }
    return auth
end

local CUR_SVR_KEY = "user-svr"
function _M:setLastGameSvrInfo(svrId)
    cc.UserDefault:getInstance():setStringForKey(CUR_SVR_KEY .. self.accId, svrId)
end

function _M:getLastGameSvrId(userId)
    return cc.UserDefault:getInstance():getStringForKey(CUR_SVR_KEY .. self.accId)
end

function _M:setUserBit(userBit)
    self.userBit = userBit
end

function _M:isDevUser()
    require "bit"
    return self.userBit and bit.band(self.userBit, HQPBCONST.ACC_BITMAP_DEVELOPER) > 0
end

function _M:isDebugUser()
    require "bit"
    return self.userBit and bit.band(self.userBit, HQPBCONST.ACC_BITMAP_DEBUG) > 0
end

function _M:setLoginRecords(records)    
    self.loginRecords = records or {}    
    if records and #records > 0 then
        local lastSvrTm = nil
        local lastSvrId = nil
        for i,v in ipairs(records) do
            if lastSvrTm == nil or v.tmlogin > lastSvrTm then
                lastSvrTm = v.tmlogin
                lastSvrId = v.zoneid
            end
        end
        self:setLastGameSvrInfo(lastSvrId)
    end
end

function _M:getLoginRecords()
    return self.loginRecords 
end

function _M:setPlatNotify(notify)
    self.platNotify = notify
end

function _M:getPlatNotify()
    if #self.platNotify ~= 0 then
        local notify = self.platNotify[1]
        table.remove(self.platNotify,1)
        return notify
    end
end

function _M:setActiveUrl(url)
    self.activeurl = url
end

function _M:getActiveUrl()
    return self.activeurl
end

function _M:getCurServerName()
    local serverData = global.ServerData:getServerDataBy(global.loginData:getCurServerId())
    return serverData.servername
end

function _M:checkSvrId(id)
    --if true then return 11 end
    id = tonumber(id)
    return id
end

function _M:getCurServerId()
    local id = self.curServerId
    if not id then return nil end
    return self:checkSvrId(id)
end

function _M:setCurServerId(id)
    self.curServerId = id
end
-- 获取推荐服务器id
function _M:getFirstServerId()
    local serverList = global.ServerData:getSeverList()
    for _,v in pairs(serverList) do
        if tonumber(v.isfirst) == 1 then
            local id = v.serverid
            return tonumber(id)
        end
    end
    return nil
end

function _M:setFirstServerId(id)
    self.firstServerId = id
end

function _M:getActiveCode()
    return self.m_activeCode
end

function _M:setActiveCode(code)
    self.m_activeCode = code
end

-- 协议头文件ltoken
function _M:setToken(lToken)
    self.lToken = lToken
end

function _M:getToken()
    return self.lToken or 0
end

-- 是否创角
function _M:isCreateRole(isCreate)
    if isCreate then
        self.isCreateRole = isCreate
    end
    return self.isCreateRole 
end


-----------------------------------**  sdk  **------------------------------------

function _M:getAccountList()
    return self.accountList
end

-- 更新绑定状态
function _M:updateBindState(channelId, isBind)

    for _,v in pairs(self.accountList) do
        if v.id == channelId then
            if isBind then
                v.switch = 0          -- 已绑定
            else                
                if v.switch == 0 then
                    v.switch = 1      -- 未绑定
                else
                    v.switch = 0      -- 已绑定
                end
            end
        end
    end

end


--/*
-- responsedata = {
--     "account_id"      = "3002273"
--     "facebook"        = "87776df2c9990181c9905e392c991e"
--     "fbalias"         = "3002273"
--     "last_login_time" = "1492701702"
--     "login_name"      = "guest3299"
--     "svr_id"          = "2"
-- }
-- {"id":"5","account_id":null,"device_id":null,"bind_passport_name":null,
-- "alias":null,"facebook":null,"fbalias":null,"gamecenter":null,"gcalias":null,
-- "sn":"test","last_login_time":"1496906050","active":null,"login_name":"guest71907402","svr_id":"1",
-- "ip":"192.168.10.189","status":"0"}
--*/

-- 解析http数据, 返回table
function _M:dealHttpMsg(msg)
    -- body
    local responsedata = {}
    local httpMsg = msg:getResponseData()
    if httpMsg then 
       responsedata = json.decode(httpMsg).param
    end
    return responsedata
end

-- 账号绑定平台区分
function _M:setAccountList()

    local list = {}
    table.insert(list, self:getAccountBySys(3))
    if device.platform == "ios" then
        table.insert(list, self:getAccountBySys(2))
    elseif device.platform == "android" then
        table.insert(list, self:getAccountBySys(1))
    end
    self.accountList = list
end

function _M:getAccountBySys(system)
    local accList = global.luaCfg:account_list()
    for _,v in pairs(accList) do
        if v.system == system then
            return v
        end
    end
    return {}
end


--------------------------------**  sdk  **--------------------------------------

global.loginData = _M

--endregion

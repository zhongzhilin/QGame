local app_cfg = require "app_cfg"
local crypto  = require "hqgame"

local cjson = require "base.pack.json"

local _M = {
    curChannel = 1,
    url = "",
    channelUser = {}, -- 记录本地各渠道id
}

local WCODE_OK=0            -- 成功
local WCODE_HBINDED=-201    -- 账号已绑定
local WCODE_EXITBIND=-202   -- 当前服已有账号绑定
local WCODE_NOBIND=-2       -- query请求，没有找到对应bindName 

local urlHead = app_cfg.get_serverlist_url()

function _M:setChannel(channelId)
    self.curChannel = channelId
end
function _M:getChannel()
    return self.curChannel
end

----------------------------** 用户信息 **----------------------------

-- /* 将第三方userid加密 */
function _M:mdChannelUserId(userId)

    if not userId then return end
    local bindSrc = userId
    local md5Bind = crypto.md5(bindSrc, false)
    return md5Bind
end

-- 渠道信息本地保存
function _M:setChannelInfo(channelId, userName, token)

    cc.UserDefault:getInstance():setStringForKey(channelId.."CHANNELINFO_NAME", userName)
    cc.UserDefault:getInstance():setStringForKey(channelId.."CHANNELINFO_TOKEN", token)
    cc.UserDefault:getInstance():flush()
    self:setLoginBind(true)
end

function _M:getChannelInfo(channelId)
    local name = cc.UserDefault:getInstance():getStringForKey(channelId.."CHANNELINFO_NAME")
    local id = cc.UserDefault:getInstance():getStringForKey(channelId.."CHANNELINFO_TOKEN")
    return id, name
end

-- 清除本地渠道信息
function _M:deleteChannelInfo()
    for k,v in pairs(WDEFINE.CHANNELKEY) do
        self:setChannelInfo(k, "", "")
    end
end

-- ／* 获取登陆绑定信息 *／
function _M:setLoginBind(isBind, isSwitchId)

    local channelId, loginToken = "", ""
    if isBind then
        if isSwitchId then
            local msg = self:getServerListInfo(isSwitchId)  
            for k,v in pairs(WDEFINE.CHANNELKEY) do
                if msg[v] and msg[v]~="" then
                    channelId, loginToken = k, msg[v]
                    break
                end
            end   
        else
            channelId, loginToken = self:getBindInfo()
        end     
    end
    cc.UserDefault:getInstance():setStringForKey("LOGIN_CHANNEL", channelId)
    cc.UserDefault:getInstance():setStringForKey("LOGIN_TOKEN", loginToken)
    cc.UserDefault:getInstance():flush()

end

function _M:getLoginBind()

    -- 改动登录 key，注意需要兼容老版本客户端key 的问题，不然会导致老版本账号绑定丢失！
    local channelId = cc.UserDefault:getInstance():getStringForKey("LOGIN_CHANNEL")
    local token = cc.UserDefault:getInstance():getStringForKey("LOGIN_TOKEN")
    return channelId, token
end

function _M:getBindInfo()

    for k,v in pairs(WDEFINE.CHANNELKEY) do
        local curToken,_ = self:getChannelInfo(k)
        if curToken and curToken~="" then
            return k, curToken
        end
    end
    return "", ""
end

-- ／* 当前服有绑定信息，切入当前服，没有，则切入最近登陆的服绑定信息 */
function _M:getLastLoginMsg(msg)

    dump(msg,">>>login msg flush")

    for _,v in pairs(msg) do
        local curSer = tonumber(v.svr_id)
        if curSer == global.loginData:getCurServerId() then
            return v
        end
    end
    table.sort(msg, function(s1, s2) return s1.last_login_time > s2.last_login_time end)
    return msg[1] 
end

----------------------------** 用户信息 **----------------------------





----------------------------** SDK **----------------------------
-- /* 同一sdk方法调用
--  * 不用平台进行区分
function _M:PLATFORMCall(methodStr, isAllPlat)

    local pStr = ""
    if device.platform == "android" then
        pStr = "_ANDROID"
    elseif device.platform == "ios" then
        pStr =  "_IOS"
    end

    -- 所有平台
    if isAllPlat then
        pStr = "_ALL"
    end

    methodStr = methodStr..pStr
    if self[methodStr] then
        self[methodStr](self)
    end
end

-- /* 登陆 */
function _M:login(loginCall , noUpdataLocal)
    self.noUpdataLocal = noUpdataLocal
    self.loginCall = loginCall
    self:PLATFORMCall("LOGIN")
end

-- /* 解除绑定 */
function _M:loginOut(loginOutCall)

    self.loginOutCall = loginOutCall
    self:LOGINOUT()
end

-- /* 进入游戏，sdk检测登陆 */
function _M:loginCheck(checkCall)

    self.checkCall = checkCall
    self:PLATFORMCall("LOGINCHECK", true)
end

-- /* 切换账号，获取角色账号信息 */
function _M:changeAccount(changeCall)

    self.changeCall = changeCall
    self:PLATFORMCall("CHANGEACCOUNT")
end


-- /* http绑定 */
function _M:httpBind(body, finishcall)

    local responseCall = function (request, retCode)
        finishcall(request, retCode)
    end
    self:registerHttpCheck(body, responseCall)
end

function _M:loginDeal(userInfo, codeChannel)

    print("#### channel: "..self.curChannel .. "  ,login Account userInfo: " .. userInfo)     
    local strTb = self:strSplit(userInfo,'#') 
    local token = strTb[1] or ""
    local userName = strTb[2] or ""
    if strTb[3] then
        userName = strTb[3]
    end
    userName=string.gsub(userName, " ", ".") -- 名字空格用.代替处理（httpGet不接受空格）

    if token == "" then
        global.tipsMgr:showWarningDelay("bind_failed")
        return false
    end
    token = self:mdChannelUserId(token)

    if self.noUpdataLocal then  -- 服务器合并  不需要绑定
        return self.loginCall(0 ,userName  , token)
    end 

    local responseCall = function (request, retCode)
        if retCode == WCODE_OK then

            self:setChannelInfo(self.curChannel, userName, token)
            self.loginCall(0)

        elseif retCode == WCODE_HBINDED then
            global.tipsMgr:showWarningDelay("repeat_bind")
        elseif retCode == WCODE_EXITBIND then
            global.tipsMgr:showWarningDelay("repeat_bind")
        end
    end

    local body = {code=codeChannel, bindName=token, alias_name=userName}
    self:httpBind(body , responseCall)

end

function _M:LOGIN_ANDROID()
    
    if self.curChannel == WDEFINE.CHANNEL.FACEBOOK then

        self:loginFacebook(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then
                self:loginDeal(userInfo, "fbbind")                                     
            else
                global.tipsMgr:showWarningDelay("bind_failed")
            end

        end, false)

    elseif self.curChannel == WDEFINE.CHANNEL.GOOGLE then

        self:loginGoogle(function(userInfo)

            if userInfo ~= "" and userInfo ~= "false" then
                self:loginDeal(userInfo, "glbind")                                     
            else      
                global.tipsMgr:showWarningDelay("bind_failed")
            end   

        end, false)

    end

end

function _M:LOGIN_IOS()
    
    if self.curChannel == WDEFINE.CHANNEL.FACEBOOK then

        self:loginFB(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then
                self:loginDeal(userInfo, "fbbind")                                     
            else
                global.tipsMgr:showWarningDelay("bind_failed")
            end
        end)

    elseif self.curChannel == WDEFINE.CHANNEL.GAMECENTER then
        
        self:loginGC(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then
                self:loginDeal(userInfo, "gcbind")                                                  
            else
                global.tipsMgr:showWarningDelay("bind_failed")
            end
        end)
    end 

end

function _M:LOGINOUT()

    local dealCall = function(codeChannel)
        
        local responseCall = function (request, retCode)
            if retCode == WCODE_OK then

                self:setChannelInfo(self.curChannel, "", "")
                self:checkServerInfo()

                self.loginOutCall(self.curChannel)
                global.tipsMgr:showWarning("unbind_success")
            else
                global.tipsMgr:showWarning("unbind_failed")
            end
        end
        self:registerHttpCheck({code=codeChannel, bindName=""}, responseCall)
    end

    if self.curChannel == WDEFINE.CHANNEL.FACEBOOK then
        dealCall("fbunbind")
    elseif self.curChannel == WDEFINE.CHANNEL.GOOGLE then
        dealCall("glunbind")
    elseif self.curChannel == WDEFINE.CHANNEL.GAMECENTER then
        dealCall("gcunbind")
    end

end

function _M:changAccountDeal(userInfo)

    print("#### channel: "..self.curChannel .. "  ,Change Account userInfo: " .. userInfo)     
    local strTb = self:strSplit(userInfo,'#') 
    local token = strTb[1] or ""
    local userName = strTb[2] or ""
    if token == "" then
        global.tipsMgr:showWarningDelay("change_accont_fail")
        return false
    end
    token = self:mdChannelUserId(token)

    local curToken,_ = self:getChannelInfo(self.curChannel)
    if token ~= curToken then                
                  
        local responseCall = function (request, retCode)
            if retCode == WCODE_OK then

                -- 清除本地并更新本地存储信息
                self:deleteChannelInfo()
                self:setChannelInfo(self.curChannel, userName, token)                       
                self.changeCall() 

                local msg = cjson.decode(request:getResponseData()).param
                local loginMsg = self:getLastLoginMsg(msg or {})
                cc.UserDefault:getInstance():setStringForKey("selectSever", loginMsg.svr_id)
            else
                global.tipsMgr:showWarningDelay("change_accont_fail")
            end                       
        end
        self:httpCheck({code="query", bind_name=token, partner_id=self.curChannel}, responseCall)
    else
        global.tipsMgr:showWarningDelay("DuplicateLogin")
    end

end

function _M:CHANGEACCOUNT_IOS()

    if self.curChannel == WDEFINE.CHANNEL.FACEBOOK then

        self:loginFB(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then              
                self:changAccountDeal(userInfo)
            else
                global.tipsMgr:showWarningDelay("change_accont_fail")
            end
        end, true)

    elseif self.curChannel == WDEFINE.CHANNEL.GAMECENTER then

        self:loginGC(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then              
                self:changAccountDeal(userInfo)
            else
                global.tipsMgr:showWarningDelay("change_accont_fail")
            end
        end, true)

    end

end

function _M:CHANGEACCOUNT_ANDROID()

    if self.curChannel == WDEFINE.CHANNEL.FACEBOOK then

        self:loginFacebook(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then              
                self:changAccountDeal(userInfo)
            else
                global.tipsMgr:showWarningDelay("change_accont_fail")
            end
        end, true)

    elseif self.curChannel == WDEFINE.CHANNEL.GOOGLE then

        self:loginGoogle(function(userInfo)
            if userInfo ~= "" and userInfo ~= "false" then              
                self:changAccountDeal(userInfo)
            else
                global.tipsMgr:showWarningDelay("change_accont_fail")
            end
        end, true)
    end
end

-- 全平台sdk登陆入口---》
function _M:LOGINCHECK_ALL()
    local responseCall = function (request, retCode)
        if retCode == WCODE_OK then 
            if request then
                local rootData = cjson.decode(request:getResponseData())
                local data = rootData.param     
                local function mergecall(msg)
                    global.userData:setAccount(msg.login_name)
                    global.userData:setCountry(msg.country)

                    local svr_id = msg.svr_id
                    if not svr_id then  
                        log.error("--->author successfully,but no svr_id")
                        svr_id = global.loginData:getFirstServerId()
                    end
                    svr_id = global.loginData:checkSvrId(svr_id)
                    if msg.sn then
                        global.loginData:setHttpSn(msg.sn)
                    end
                    if msg.sc then
                        global.loginData:setHttpSc(msg.sc)
                    end
                    global.loginData:setCurServerId(svr_id)
                    cc.UserDefault:getInstance():setStringForKey("selectSever",svr_id)
                    self:setBindInfo(msg or {})
                    if self.checkCall then self.checkCall() end
                end

                if rootData.params then
                    global.panelMgr:openPanel("UIMergeSRolePanel"):setData(rootData,mergecall)
                else
                    mergecall(data)
                end
            else
                if self.checkCall then self.checkCall() end
            end
        end
    end

    local params = {}
    local defaultSelectSeverId = tonumber(cc.UserDefault:getInstance():getStringForKey("selectSever"))

    params.code = "loginex"
    params.svr_id = defaultSelectSeverId or 0
    params.lang = global.languageData:getCurrentLanguage()
    params.channel = global.sdkBridge:getQuickChannelType()

    local str = cjson.encode(global.loginApi:getCpDeviceInfo(true))
    local ecrypttext = crypto.encrypt(2,str,"SovE904")
    params.param = string.hex(ecrypttext)
    dump(params, " ==> LOGINCHECK_ALL  params: ")
    self:httpCheck(params, responseCall)
end

-- 合服相关
function _M:mergeSKeepRole(call,listdata)

    -- http://192.168.10.20:8484/verify.php?sn=aea42a8e876b93a3f6672f76eee3c95f&code=chgsvr&sc=81f7844281613bf9d66ca5362f8b7dd4&uid=0&des=20&src=1&login_name=guest33430656&type=0&bind_name=%22%22&alias_name=%22%22

    local params = {}
    params.code = "chgsvr"
    local url = self:getSnUrl(params)
    local postFinishCall = function (event)
        if event.name == "inprogress" then 
        elseif event.name == "failed" then
            print(" <----  POST ERRORMSG failed!  ---->")
        elseif event.name == "completed" then           
            print(" <----  POST ERRORMSG success! ---->")
            local rootData = cjson.decode(event.request:getResponseData())
    	    if _CPP_RELEASE ~= 1 then
    	            dump(rootData)
    	            CCHgame:setPasteBoard(vardump(rootData).."--------"..vardump(listdata))
    	    end
            if rootData and  rootData.ret == 0 then
                if call then call() end   
            else
                global.tipsMgr:showWarning("repeat_bind")
            end     
        end 
    end
    local request = gnetwork.createHTTPRequest(postFinishCall, url, "POST", true)
    request:addRequestHeader("Content-Type:text/html")
    dump(listdata)
    req = listdata
    postdata = json.encode(req)
    request:setPOSTData(postdata, #postdata)
    request:setTimeout(15)
    request:start()
end

function _M:encodeToken(origin) 

    if origin and origin ~= "" then 

        local strLen = string.len(origin)
        local mididx = math.floor(strLen/2)
        local str1   = string.sub(origin,1,mididx)
        local str2   = string.sub(origin,mididx+1,strLen)
        local originStr = str2.."@".. str1  -- 加密需要转成字符串
        return originStr
    else
        return ""
    end
end

function _M:dencodeToken(cryptoText)
    
    if cryptoText and cryptoText ~= "" then

        local strTb = self:strSplit(tostring(cryptoText),"@") 
        strTb[1] = strTb[1] or ""
        strTb[2] = strTb[2] or ""
        local originStr = strTb[2]..strTb[1]  -- 加密需要转成字符串
        return originStr 
    else
        return ""
    end
end

----------------------------** SDK **----------------------------



---------------------------** http请求 **----------------------------

-- 开始新游戏，解除老的设备id绑定
function _M:startNewGame(call)
 
    local responseCall = function (request, retCode)
        if retCode == WCODE_OK then 
            if call then call() end
        end
    end
    self:httpCheck({code="logout", svr_id = global.loginData:getCurServerId()}, responseCall)
end

-- /* 登陆游戏，http校验 */
function _M:httpCheck(bodyData, responseCall)
  
    self:setRequestUrl(bodyData)
    self:requestHttpAPI(responseCall)
    
end

-- /* sdk注册成功，服务回调校验 */
function _M:registerHttpCheck(body, responseCall)
    
    local login_name = global.userData:getAccount() 
    local svr_id = global.loginData:getCurServerId()
    local partner_id = self.curChannel
    local bind_name  = body.bindName
    local alias_name = body.alias_name or ""

    local httpData = {code=body.code,sn=nil,sc=nil,partner_id=partner_id, 
        login_name=login_name, alias_name=alias_name, bind_name=bind_name, svr_id = svr_id}
    self:setRequestUrl(httpData)
    self:requestHttpAPI(responseCall)
    
end

-- 获取登陆密码
function _M:getMD5Passport(pw)
    local original = gdevice.getOpenUDID()
    local t_pw = pw or app_cfg.server_list_pw
    local fake = crypto.md5(original..app_cfg.server_list_pw, false)
    return fake
end

--/* 初始化请求url */
function _M:setRequestUrl(requestData)
    self.url = self:getSnUrl(requestData)
end 

--/* 初始化请求url */
function _M:getSnUrl(requestData)
    local original = gdevice.getOpenUDID()
    if global.sdkBridge:getHttpSn() then
        original = global.sdkBridge:getHttpSn()
    end
    local fake = crypto.md5(original..app_cfg.server_list_pw, false)
    requestData.sn = original
    requestData.sc = fake

    -- 解除绑定
    if requestData.bind_name == "" then
        local curBindId,_ = self:getChannelInfo(self.curChannel)
        requestData.bind_name = curBindId 
    end

    local url = urlHead..'?'
    for k,v in pairs(requestData) do 
        if k == "none__" then
            url=url..'&'..v
        else
            url=url..'&'..k..'='..v
        end        
    end 
    print("-----> http url: "..url)
    return url
end 

--/* 发送http请求 */
function _M:requestHttpAPI(resqonsecall)
   
    local function onRequestFinished(event)

        local request = event.request
        if event.name == "inprogress" then
            return 
        elseif event.name == "failed" then
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        elseif event.name == "completed" then  
           
            local responsData = request:getResponseData() 
            if responsData then
                log.trace("---->http call requesturl=%s, respone =%s",self.url,vardump(cjson.decode(request:getResponseData())))
                local  retCode = 0  
                local data = cjson.decode(responsData) 
                if data and  data.ret then 
                    retCode =  data.ret  
                    resqonsecall(request, retCode)
                else
                    global.tipsMgr:showQuitConfirmPanelNoClientNet()
                end  
            else
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end
        end 
    end

    local request = gnetwork.createHTTPRequest(onRequestFinished, self.url, app_cfg.server_list_method)
    request:addRequestHeader("Content-Type:application/text")
    request:setTimeout(15)
    request:start() 
end


-- ／* 游客登陆，获取服务器id *／
function _M:httpGetServerId(responseCall)

    -- 发送http请求，拉取新号默认服务id
    local requestCall = function (status)
        if status=="failed" then 
            -- global.tipsMgr:showWarning("request_fail")
        else
            
            local defaultSelectSeverId = tonumber(cc.UserDefault:getInstance():getStringForKey("selectSever"))
            local iosCheckId = global.ServerData:isIosChecking(defaultSelectSeverId)
            if iosCheckId then
                defaultSelectSeverId = iosCheckId
            else
                if defaultSelectSeverId then
                    local isfind,firId = global.ServerData:isInServerList(defaultSelectSeverId)
                    if not isfind or defaultSelectSeverId == 998 then
                        -- 默认id在服务器列表找不到时,推荐服务器id赋值
                        defaultSelectSeverId = firId
                    end
                else
                    defaultSelectSeverId = 0
                end
            end
            if _DEBUG_SERVER then
                defaultSelectSeverId = _DEBUG_SERVER
            end
            if _CPP_RELEASE~=1 then
                local app_cfg = require("app_cfg")
                if app_cfg.plat_index == 3 then
                end

                if app_cfg.plat_index == 2 then
                end
            end
            if defaultSelectSeverId then
                global.loginData:setCurServerId(defaultSelectSeverId)
                cc.UserDefault:getInstance():setStringForKey("selectSever",defaultSelectSeverId)
            end

            responseCall()
        end
    end
    global.ServerData:requestServerList(requestCall)
   
end

-- 进入游戏，如果是创角新号，则默认绑定当前号
function _M:checkUserBind()

    if not global.m_firstEnter then

        self:refershServerInfo(global.sdkBridge:getQuickChannelType(), global.sdkBridge:getQuickToken())

        -- -- 刚进入游戏，更新当前号绑定信息
        -- self:updateBindInfo()

        -- -- 检测绑定状态
        -- local httpBindCall = function(channelId, token, userName)

        --     local responseCall = function (request, retCode)
        --         if retCode == WCODE_OK then
        --             global.loginData:updateBindState(channelId, true)
        --             self:setLoginBind(true)
        --         end
        --     end

        --     local codeChannel = WDEFINE.BINDKEY[channelId]
        --     local body = {code=codeChannel, bindName=token, alias_name=userName}
        --     self:httpBind(body , responseCall)
        -- end

        -- for k,v in pairs(WDEFINE.CHANNELKEY) do

        --     local curToken, curName = self:getChannelInfo(k)
        --     -- 已经处于绑定状态，不再发送绑定http
        --     local isNotBinding = self.bindState[k] == ""
        --     local isNeedBind   = curToken and curToken~=""

        --     if isNeedBind and isNotBinding then
        --         httpBindCall(k, curToken, curName)
        --     end
        --     if isNeedBind and (not self.serverInfo) then
        --         self:refershServerInfo(k, curToken)
        --     end
        -- end
        global.m_firstEnter = true
    end

end 

-- 更新服务器列表中的绑定信息
function _M:refershServerInfo(channelId, token)

    if channelId <= 0 then
        channelId = -1
    end

    self.serverInfo = {}
    local responseFinish = function (request, retCode)
        if retCode == WCODE_OK then

            local msg = cjson.decode(request:getResponseData()).param
            -- dump(msg, " ======> refershServerInfo: ")
            self:setServerListInfo(msg)

        elseif retCode == WCODE_NOBIND then
            global.tipsMgr:showWarning("WCODE_NOBIND")
        end                       
    end
    self:httpCheck({code="query", bind_name=token, partner_id=channelId}, responseFinish)
end

-- 进入游戏时保存登陆信息，并在角色信息初始化完成后刷新
function _M:updateBindInfo()

    -- 初始化绑定平台列表
    global.loginData:setAccountList()

    local msg = self.curBindInfo
    if msg.facebook and msg.facebook ~= "" then
        self:setChannelInfo(1, msg.fbalias or "", msg.facebook)
        global.loginData:updateBindState(1, true)
        self:setBindState(1, msg.facebook)
    end

    if msg.google and msg.google ~= "" then
        self:setChannelInfo(2, msg.glalias or "", msg.google)
        global.loginData:updateBindState(2, true)
        self:setBindState(2, msg.google)
    end

    if msg.gamecenter and msg.gamecenter ~= "" then
        self:setChannelInfo(3, msg.gcalias or "", msg.gamecenter)
        global.loginData:updateBindState(3, true)
        self:setBindState(3, msg.gamecenter)
    end
end

function _M:setBindInfo(msg)
    self.curBindInfo = msg 

    self.bindState = {}
    for k,v in pairs(WDEFINE.CHANNELKEY) do
        self.bindState[k] = ""
    end
end

function _M:setBindState(channel, token)
    self.bindState[channel] = token 
end

-- 服务器列表中头像和领主等级信息
function _M:setServerListInfo(msg)
    self.serverInfo = msg 
end

function _M:getServerListInfo(serId)
    if not self.serverInfo then return nil end

    for _,v in pairs(self.serverInfo) do
        local curSer = tonumber(v.svr_id)
        if curSer == serId then
            return v
        end
    end
    return nil
end

-- ／*  检测当前是否还有绑定信息，没有，则将绑定用户信息列表清空 */
function _M:checkServerInfo()

    local channelid, token = self:getBindInfo()
    if token == "" then
        self:setServerListInfo(nil)
    else
        self:refershServerInfo(channelid, token)
    end
end

----------------------------** http请求 **----------------------------



----------------------------** gluaoc **----------------------------
-- /* gluaoc
--  * lua调用oc接口
local OCCLASS_NAME = "AppController"

-- /* facebook 登陆 */
function _M:loginFB(callback)
    local ocClassName =  OCCLASS_NAME
    local ocMethodName = "loginFacebook"
    local ocParams = {
        callBack = function (userInfo)
                        if callback then
                            callback(userInfo)
                        end
                    end, 
    }
    gluaoc.callStaticMethod(ocClassName, ocMethodName, ocParams)
end

-- /* gamecenter 登陆 */
function _M:loginGC(callback)
    local ocClassName =  OCCLASS_NAME
    local ocMethodName = "loginGameCenter"
    local ocParams = {
        callBack = function (userInfo)
                        if callback then
                            callback(userInfo)
                        end
                    end, 
    }
    gluaoc.callStaticMethod(ocClassName, ocMethodName, ocParams)
end

----------------------------** gluaoc **----------------------------




----------------------------** gluaj **----------------------------
-- /* gluaj
--  * lua调用java 接口
local CLASS_NAME = "org/cocos2dx/lua/AppActivity"


-- /* facebook 登陆 */
function _M:loginFacebook(callback, isChangeAccount)
    local javaClassName =  CLASS_NAME
    local javaMethodName = "loginFacebook"
    local javaParams = {
        -- 回调方法
        function (userId)
            if callback then
                callback(userId)
            end
        end
    , isChangeAccount}

    local javaMethodSig = "(IZ)V"
    gluaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-- /* facebook 登陆 */
function _M:loginOutFacebook(callback)
    local javaClassName =  CLASS_NAME
    local javaMethodName = "loginOutFacebook"
    local javaParams = {
        -- 回调方法
        function (isSuccess)
            if callback then
                callback(isSuccess)
            end
        end
    }
    local javaMethodSig = "(I)V"
    gluaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-- /* google 登陆 */
function _M:loginGoogle(callback, isChangeAccount)
    local javaClassName =  CLASS_NAME
    local javaMethodName = "loginGoogle"
    local javaParams = {
        -- 回调方法
        function (userId)
            if callback then
                callback(userId)
            end
        end
    , isChangeAccount}

    local javaMethodSig = "(IZ)V"
    gluaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end

-- /* google 登陆 */
function _M:loginOutGoogle(callback)
    local javaClassName =  CLASS_NAME
    local javaMethodName = "loginOutGoogle"
    local javaParams = {
        -- 回调方法
        function (isSuccess)
            if callback then
                callback(isSuccess)
            end
        end
    }
    local javaMethodSig = "(I)V"
    gluaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
-----------------------------------充值------------------------------------>>
local white_device_ids = {
    {did = "091b0fa743425a60d112b930232f89cc",desc = "andorid_vivo"},
    {did = "e61b16b1516ea6c76caddf6259fc061e",desc = "andorid_sumsang"},
    {did = "c68ac27ab3797f9e6d13f8ba7b68e6c5",desc = "andorid_special_1"},
}
function _M:isTestDevice(i_did)
    for i,v in pairs(white_device_ids) do
        if v.did == i_did then
            return true
        end
    end
    return false
end

function _M:app_pay_init()
    if global.tools:isAndroid() then    
    else
    end
end


function _M:app_sdk_pay_getProductId(period)
    local productId = nil
    if global.tools:isAndroid() then
        productId = string.format("com.lingshi.knightscreed.package_%s",period*10)
    elseif global.tools:isIos() then
        productId = string.format("com.company.knightscreed.package_%s",period*100)
    end
    return productId
end

function _M:app_sdk_pay(i_gift_id,i_call)

    if _NO_RECHARGE or (_DEBUG_SERVER == 999 and not _QUICK_SDK) then
        return global.tipsMgr:showWarning("FuncNotFinish")
    end

    self.payQuickFinishCall = i_call
    local gift_id = i_gift_id
    if not gift_id then return end
    local function checkcall()

        if global.tools:isAndroid() then

            global.uiMgr:addSceneModel(45,20181126)
            local data = global.luaCfg:get_gift_by(gift_id)
            local productId = global.sdkBridge:app_sdk_pay_getProductId(data.period)
            local tdata = global.luaCfg:get_recharge_by(data.period)
            local cnPrice = data.cost
            if tdata and tdata.CN then
                cnPrice = tdata.CN
            end

            local default_str = "-"
            local amount = cnPrice  -- 总金额（元）
            local count  = tdata.diamond -- 价值魔晶数量
            local cpOrderID = global.dataMgr:getServerTime()   -- 产品订单号
            local extrasParams = global.userData:getUserId() .. "," .. global.loginData:getCurServerId() .. "," .. gift_id .. "," .. global.userData:getAccount()
            local goodsID = string.format("com.lingshi.knightscreed.package_%s", data.period*10) -- 产品ID，用来识别购买的产品 
            local goodsName = data.name or "Diamond"

            if global.rechargeTest then
                amount = global.rechargeTestAmount
                goodsID = "com.lingshi.knightscreed.package_001"
            end
            goodsID = gift_id

            local roleId = tostring(global.userData:getUserId() or default_str)
            local roleName = tostring(global.userData:getUserName() or default_str)
            local roleLevel = tostring(global.userData:getLevel() or default_str)
            local roleServerId = tostring(global.loginData:getCurServerId() or default_str)
            local roleServerName = tostring(global.ServerData:getServerNameById(roleServerId) or default_str)
            local roleBalance = tostring(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"") or default_str)
            local roleVipLevel = tostring(global.userData:getVipLevel() or default_str)
            local rolePartyName = default_str
            if global.unionData:getInUnionName() ~= "" then 
                rolePartyName =tostring(global.unionData:getInUnionName())
            end
            if _IS_LINGSHI_LOGIN then
                self.payLingshiFinishCall = i_call
                global.sdkBridge:lingshiPay(gift_id)
            else
                global.sdkBridge:payQuick(amount, count, cpOrderID, extrasParams, goodsID, goodsName,
                    roleId, roleName, roleLevel, roleServerId, roleServerName, roleBalance, roleVipLevel, rolePartyName)
            end

        elseif global.tools:isIos() then

            local function checkDropOrder(haveNoFinish)
            -- body
                if haveNoFinish then
                    global.tipsMgr:showWarning("noFinishOrder")
                else
                    
                    if not global.loginData.getCurServerId   then return end
                    if not global.loginData:getCurServerId() then return end
                    if not global.ServerData:isIosSvrCanRecharge(global.loginData:getCurServerId()) then
                        return global.tipsMgr:showWarning("FuncNotFinish")
                    end
                    global.uiMgr:addSceneModel(45,109010)
                    global.rechargeApi:sendRecordRecharge(function()
                      -- body
                    end, 1, gift_id)
                    local data = global.luaCfg:get_gift_by(gift_id)
                    local tdata = global.luaCfg:get_recharge_by(data.period)
                    local cnPrice = data.cost
                    if tdata and tdata.CN then
                        cnPrice = tdata.CN
                    end
                    CCNative:startIosPay(function(state,username,signature)
                        -- body
                        print("sfd---->[][][]username="..username)
                        if state and state == 1 then
                        end
                        if signature then
                            print(signature)
                        end
                        -- local payOrderData = cjson.decode(ret[2])
                        local result = state.."|"..(username or "").."|"..(signature or "")
                        self.m_appstore_pay_finish_call = nil
                        self.m_appstore_pay_finish_call = i_call
                        global.sdkBridge:appstore_pay_on_send_goods(result)
                    end,data.period-1,global.userData:getUserId().."_"..gift_id.."_"..cnPrice)
                    
                    global.sdkBridge:pay_updateSkuState(productId,1)
                    global.loginApi:clickPointReport(nil,23,gift_id,nil)

                end
            end
            self:pay_checkDropOrder(productId,checkDropOrder)

        end
    end

    global.rechargeApi:checkRecharge(checkcall,i_gift_id)

end

function _M:appstore_pay_on_send_goods(result,i_call,i_sendhttpcall)
    -- body
    global.uiMgr:removeSceneModal(109010)
    global.uiMgr:addSceneModel(45,109010,true)
    local paramArr = string.split(result, "|")
    local state = tonumber(paramArr[1])
    local username = paramArr[2]
    local signature = paramArr[3]

    local gift_id = gift_id
    local userId = global.userData:getUserId()

    --print(result)
    --print("appstore_pay_on_send_goods####")
    --print(username)
    --print(userId)
    if string.find(username,userId) then
    else
        global.uiMgr:removeSceneModal(109010)
        return
    end
    local usPrice = usPrice
    local orderId = nil
    if username then
        local arr = string.split(username, "_")
        userId = arr[1]
        gift_id = tonumber(arr[2])
        usPrice = arr[3]
        if arr[4] then
            orderId = arr[4]
        end
        dump(arr)
    end

    local giftData = global.luaCfg:get_gift_by(gift_id)
    local productId = global.sdkBridge:app_sdk_pay_getProductId(giftData.period)
    --print(state)
    if state and state == 0 then
        -- 充值取消或者失败
        global.rechargeApi:sendRecordRecharge(function()
          -- body
        end, 2, gift_id)
        global.uiMgr:removeSceneModal(109010)
        return
    elseif state and state == 1 then
        -- 付款成功
        global.rechargeApi:sendRecordRecharge(function()
          -- body
        end, 3, gift_id)
        

        global.sdkBridge:pay_updateSkuState(productId,2)
        global.sdkBridge:pay_updateSkuState(productId,3,result)
    end
    local params = {}
    params.code = "ipay"
    params.sn = global.loginData:getHttpSn()
    params.sc = global.loginData:getHttpSc()
    params.login_name = global.userData:getAccount()
    params.partner_id = 2
    params.svr_id = global.loginData:getCurServerId()
    params.signature = signature
    params.gift_id = gift_id
    params.price = usPrice

    local responseCall = function (httpMsg, retCode)
        --print(retCode)
        --print('#######1111')
        local jsRe = cjson.decode(httpMsg:getResponseData())
        if retCode == WCODE_OK then
            global.rechargeApi:sendRecordRecharge(function()
              -- body
            end, 4, gift_id)

            if gift_id and (jsRe.environment ~= "Sandbox") then
            -- if gift_id then
                local giftData = global.luaCfg:get_gift_by(gift_id)
                local rechargeData = global.luaCfg:get_recharge_by(giftData.period)
                local cash = rechargeData.US
                local source = 1
                local coin = rechargeData.diamond
                local payOrderData = {}
                payOrderData.order_id = orderId
                payOrderData.productId = global.sdkBridge:app_sdk_pay_getProductId(giftData.period)
                global.sdkBridge:app_sdk_pay_info(cash,coin,source,payOrderData)

                global.loginApi:clickPointReport(nil,24,gift_id,nil)
            end
            global.sdkBridge:pay_updateSkuState(productId,4,result)
        else
            global.uiMgr:removeSceneModal(109010)
            -- 已经发过货啦
            global.sdkBridge:pay_updateSkuState(productId,4,result)
            -- global.tipsMgr:showWarning("发货失败需要配置!")
            -- print("")
            -- todo: 发送发货失败的邮件：上次够用的魔晶大礼包没有成功，这个是补发的。
        end                       
    end
    global.sdkBridge:httpCheck(params, responseCall)
    if i_sendhttpcall then
        i_sendhttpcall()
    end
end
-- sdk 支付协议
function _M:app_sdk_pay_info(cash,coin,source,payOrderData)
    print("--------gumengSdk.pay(cash,source,coin)")
    if global.tools:isAndroid() then
        source = global.sdkBridge:getQuickChannelType() or source
    end
    CCHgame:umengPaySuccess(cash,payOrderData.productId,1,coin,source)
end

local ownSkuList = {}
function _M:pay_updateSkuState(skuid,state,content)
    -- state 0:可用，1:开始购买：，2:付款成功，3：消费成功，4:发货成功
    --print("_M:pay_updateSkuState(skuid,state,content)")
    skuid = skuid or 0
    if device.platform == "windows" then 
        global.tipsMgr:showWarning("FuncNotFinish")
        return
    end 
    print(skuid..state)

    local key = nil
    if content then
        key = crypto.md5(content, false)
        print(content)
    end
    if ownSkuList[skuid] then
        ownSkuList[skuid].state = state
    end
    local userId = global.userData:getUserId()
    if state == 3 then
        local data = {}
        data[key] = {state,0,content}
        cc.UserDefault:getInstance():setStringForKey(string.format("%s#_#%s",userId,skuid) ,cjson.encode(data))
    elseif state == 4 then
        local datajsstr = cc.UserDefault:getInstance():getStringForKey(string.format("%s#_#%s",userId,skuid))
        if datajsstr and datajsstr ~= "" then
            local data = cjson.decode(datajsstr)
            data[key] = nil
            cc.UserDefault:getInstance():setStringForKey(string.format("%s#_#%s",userId,skuid) ,cjson.encode(data))
        end
    end
end
-- 检查是否漏单:处理因为客户端网络问题没有发货的情况
function _M:pay_checkDropOrder(productId,checkCall)
    print("pay_checkDropOrder(skuid,state,content)")
    local t_checkCall = checkCall
    local userId = global.userData:getUserId()
    if global.tools:isIos() then
        for i=1,10 do
            local skuid = global.sdkBridge:app_sdk_pay_getProductId(i) 
            local key = string.format("%s#_#%s",userId,skuid)
            local v = cc.UserDefault:getInstance():getStringForKey(key)
            if v then
                print(key..v)
                -- 处理补单之后的问题
                local datajsstr = v
                if datajsstr and datajsstr ~= "" then
                    local data = cjson.decode(datajsstr)
                    for k,vv in pairs(data) do
                        local state = vv[1]
                        local tryTimes = vv[2]
                        local result = vv[3]
                        if tonumber(state) == 3 and tryTimes then
                            local call = nil
                            if tryTimes > 3 then
                                data[k] = nil
                            else
                                call = function()
                                    vv[2] = tonumber(vv[2])+1
                                end
                            end
                            global.sdkBridge:appstore_pay_on_send_goods(result,nil,call)
                            if t_checkCall and productId == skuid then 
                                t_checkCall(true)
                                t_checkCall = nil
                            end
                        end
                    end
                    cc.UserDefault:getInstance():setStringForKey(string.format("%s#_#%s",userId,skuid) ,cjson.encode(data))
                end
            end
        end
        if t_checkCall then 
            t_checkCall()
            t_checkCall = nil
        end
    elseif global.tools:isAndroid() then
    else
        return
    end
end

local payCountry = "CN"
local paySymbol = "￥"

function _M:getPayCountryInfo()
    return payCountry,paySymbol
end
----------------------------** alipay **-------------------------------

function _M:start_alipay(i_gift_id,i_call)
    global.uiMgr:addSceneModel(45,109010)
    
    local params = {}
    params.sn = global.loginData:getHttpSn()
    params.sc = global.loginData:getHttpSc()
    params.code = "apay"
    params.login_name = global.userData:getAccount()
    params.svr_id = global.loginData:getCurServerId()
    params.gift_id = i_gift_id


    self.m_alipay_finish_call = nil
    local responseCall = function (httpMsg, retCode)
        --print(retCode)
        --print('#######1111')
        local jsRe = cjson.decode(httpMsg:getResponseData())
        if retCode == WCODE_OK then
            dump(jsRe,"asfdasdf---->")
            if jsRe.param then
                self.m_alipay_finish_call = i_call
                local p_param = string.gsub(jsRe.param,"&amp;","&")
                print(p_param)
                gluaj.callGooglePayStaticMethod("startAlipay",{p_param},"(Ljava/lang/String;)V")
            else
                global.uiMgr:removeSceneModal(109010)
            end
        else
            global.uiMgr:removeSceneModal(109010)
        end                       
    end
    global.sdkBridge:httpCheck(params, responseCall)
end

function alipay_pay_result_to_cocos(result)
    -- body
    global.uiMgr:removeSceneModal(109010)
end

----------------------------** helpshift **----------------------------
function _M:hs_login()
    local id = global.userData:getUserId() 
    if id == 0 then
        id = -(global.loginData:getCurServerId() or 0)..gdevice.getOpenUDID()
    end
    
    local userName = global.userData:getUserName() 
    if userName == "" then
        userName = global.userData:getAccount()
    end
    CCHgame:hs_login(id,userName,"")
end

function _M:hs_logout()
    CCHgame:hs_logout()
end

function _M:hs_setUserConfig()
    self:hs_login()
    local lan = global.languageData:getCurrentLanguage()
    local faqlanData = global.luaCfg:get_faq_language_by(lan)
    CCHgame:hs_setSDKLanguage(faqlanData.Locale)

    local config = {}
    config["hs-custom-metadata"] = {}
    if global.dataMgr:isDataMgrInitSuccess() then
    -- if global.netRpc:IsLogin() then
        config["hs-custom-metadata"]["vip-lv"]        = global.vipBuffEffectData:getVipLevel()
        config["hs-custom-metadata"]["sever-id"]      = global.loginData:getCurServerId()
        config["hs-custom-metadata"]["user-id"]       = global.userData:getUserId()
        config["hs-custom-metadata"]["city-lv"]       = global.cityData:getBuildingById(1).serverData.lGrade
        config["hs-custom-metadata"]["user-lv"]       = global.userData:getLevel()
        config["hs-custom-metadata"]["use-memory"]    = global.funcGame:getUseMemMB()
    end
    return config
end

function _M:hs_showFAQs()
    if true then
        return global.tipsMgr:showWarning("FuncNotFinish")
    end
    local config = self:hs_setUserConfig()
    -- dump(config)
    CCHgame:hs_showFAQs(config)
end

function _M:hs_showConversation()
    if true then
        return global.tipsMgr:showWarning("FuncNotFinish")
    end
end
----------------------------** bugly **----------------------------
function _M:buglyAddUserValue()
    if _CPP_RELEASE ~= 1 then
        return
    end
    if not global.tools:isAndroid() then
        return
    end
    if not buglyAddUserValue then
        return
    end
    buglyAddUserValue("sn",gdevice.getOpenUDID().."_"..GLFGetAppVerStr())
    buglyAddUserValue("userid",global.userData:getUserId())
    buglyAddUserValue("serverid",global.loginData:getCurServerId())
    buglyAddUserValue("usermemory",global.funcGame:getUseMemMB())
end

----------------------------** gluaj **----------------------------

-- /* 根据字符delimiter分割字符，返回table */
function _M:strSplit(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


-- 获取国家简称
function _M:getCountryShort()
    -- body
    if global.tools:isAndroid() then
        return gluaj.callGooglePayStaticMethod("get_lan",{},"()Ljava/lang/String;") or "en"
    elseif global.tools:isIos() and CCHgame.get_lan then
        return CCHgame:get_lan()
    else
        return "en"
    end
end

----------------------------** quick sdk接入 **----------------------------

function _M:setHttpSn(sn)
    self.loginSn = sn
end
function _M:getHttpSn()
    return self.loginSn
end
function _M:setQuickToken(token)
    self.loginToken = token
end
function _M:getQuickToken()
    return self.loginToken 
end

-- 登录
function _M:loginQuick(call)
    -- body
    self.loginCallHandler = call
    CCHgame:loginQuick()
end

-- 获取渠道code
function _M:getQuickChannelType()
    -- body
    if global.tools:isAndroid() then
        local channelType = 0
        local sdkName = gluaj.callGooglePayStaticMethod("getSdkName",{},"()Ljava/lang/String;")
        if sdkName == "HUAWEI" then
            channelType = 24
        else
            channelType = tonumber(CCHgame:getQuickChannelType())
        end
        
        return channelType 
    else
        return 0
    end 
    
end

function _M:setSwitchQuickSn(sn)

    cc.UserDefault:getInstance():setStringForKey("QUICKSDK_SN",  sn)
    cc.UserDefault:getInstance():flush()
end

function _M:getSwitchQuickSn()
    local sn = cc.UserDefault:getInstance():getStringForKey("QUICKSDK_SN")
    if sn and sn ~= "" then
        global.loginData:setHttpSn(sn)
        global.sdkBridge:setHttpSn(sn)
        global.sdkBridge:setSwitchQuickSn("")
    end
    return sn
end
-- 注销
function _M:logOutQuick()
    -- body
    CCHgame:logOutQuick()
end

-- 退出
function _M:exitQuickSdk()
    -- body
    local call = function (retCode)
        -- body
        if retCode == 0 then
        else
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData(10651,function ()
                global.funcGame.allExit()
            end)
        end
    end
    if global.tools:isAndroid() then
        CCHgame:exitQuickSdk(call)
    else
        call(1)
    end
end

-- 上传角色信息
function _M:updateRoleInfoWith(isCreateRole, roleId, roleName, roleLevel, roleServerId, roleServerName,roleBalance, roleVipLevel, rolePartyName, roleCreateTime, partyName, partyId, gameRoleGender, gameRolePower,partyRoleId, professionId, profession, friendlist)
    -- body

    if global.tools:isAndroid() then
        local sdkName = gluaj.callGooglePayStaticMethod("getSdkName",{},"()Ljava/lang/String;")

        if sdkName == "HUAWEI" then
            gluaj.callGooglePayStaticMethod("HWsavePlayerInfo",{roleServerId,roleLevel,roleId,roleServerName},"(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
        else
            CCHgame:updateRoleInfoWith(isCreateRole, roleId, roleName, roleLevel, roleServerId, roleServerName,
            roleBalance, roleVipLevel, rolePartyName, roleCreateTime, partyName, partyId, gameRoleGender, gameRolePower, partyRoleId
            , professionId, profession, friendlist)
        end
    end

end

-- 支付
function _M:payQuick(amount,count,cpOrderID,extrasParams,goodsID,goodsName,roleId,roleName,roleLevel,roleServerId,roleServerName, roleBalance,roleVipLevel,partyName)
    -- body

    if global.tools:isAndroid() then
        local sdkName = gluaj.callGooglePayStaticMethod("getSdkName",{},"()Ljava/lang/String;")
        if sdkName == "HUAWEI" then
            -- String productNo,String merchantName,String extend,final int paycall
            local function paycall(retstr)
                -- body
                if retstr == "success" then
                    if self.payQuickFinishCall then
                        self.payQuickFinishCall()
                    end
                else
                end
                global.uiMgr:removeSceneModal(20181126)
            end
            gluaj.callGooglePayStaticMethod("HWPay",{amount,"灵石游戏",goodsName,goodsName,extrasParams,paycall},"(FLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V")
        else
            CCHgame:payQuick(amount,count,cpOrderID,extrasParams,goodsID,goodsName,roleId,roleName,roleLevel,roleServerId,roleServerName, roleBalance,roleVipLevel,partyName)
        end
    end

end


-- 初始化sdk
function _M:initQuickSdk()

    global.sdkBridge:setHttpSn(nil)

    local initCall = function (retCode)
        global.sdkBridge:initCall(retCode)
    end

    local loginCall = function (retCode, uid, userName, token, channel_code)
        global.sdkBridge:loginCall(retCode, uid, userName, token, channel_code)
    end

    local logOutCall = function (retCode)
        global.sdkBridge:logOutCall(retCode)
    end

    local switchAccoutCall = function (retCode, uid, userName, token, channel_code)
        global.sdkBridge:switchAccoutCall(retCode, uid, userName, token, channel_code)
    end

    local exitCall = function (retCode)
        global.sdkBridge:exitCall(retCode)
    end

    local payCall = function (retCode, sdkOrderID, cpOrderID, extrasParams, channel_code)
        global.sdkBridge:payCall(retCode, sdkOrderID, cpOrderID, extrasParams, channel_code)
    end

    if global.tools:isAndroid() then
        CCHgame:initQuickSdk(initCall, loginCall, logOutCall, switchAccoutCall, exitCall, payCall)
    end

end

function _M:payCall(retCode, sdkOrderID, cpOrderID, extrasParams, channel_code)

    if retCode == 0 then 

        print(">>>>>>>>>>>>>>>> quicksdk pay <success> ret0.") 
        if self.payQuickFinishCall then
            self.payQuickFinishCall()
        end

    elseif retCode == 1 then  
        print(">>>>>>>>>>>>>>>> quicksdk pay <failed> ret1.")
    elseif retCode == 2 then 
        print(">>>>>>>>>>>>>>>> quicksdk pay <cancel> ret2.")
    else
        print(">>>>>>>>>>>>>>>> quicksdk pay <error>  ret3.")
    end

    global.uiMgr:removeSceneModal(20181126)

end


function _M:exitCall(retCode)

    if retCode == 0 then  -- 初始化成功
        print("succ exitCall sdk ret1.")
        global.funcGame.allExit()
    elseif retCode == 1 then  -- 初始化失败
        print("fail exitCall sdk ret1.")
    end

end

function _M:switchAccoutCall(retCode, uid, userName, token, channel_code)

    if retCode == 0 then  
        local loginCallHandler = function ()
            -- 用于切换账号
            global.sdkBridge:setSwitchQuickSn(global.sdkBridge:getHttpSn())
            global.funcGame:RestartGame()
        end
        self.loginCallHandler = loginCallHandler
        self:loginSdkServerCheck(retCode, uid, userName, token, channel_code)

    elseif retCode == 1 then  
        print("switchAccout failed ret1.")
    elseif retCode == 2 then 
        print("switchAccout cancel ret2.")
    else
        print("switchAccout error ret.")
    end

end

function _M:logOutCall(retCode)

    if retCode == 0 then  -- 初始化成功
        global.funcGame:RestartGame()
    elseif retCode == 1 then  -- 初始化失败
        print("fail logout sdk ret1.")
    end

end

function _M:initCall(retCode)

    if retCode == 0 then  -- 初始化成功
        print("succ init sdk ret0.")
    elseif retCode == 1 then  -- 初始化失败
        print("fail init sdk ret1.")
    end
end

function _M:loginCall(retCode, uid, userName, token, channel_code)

   
    print(" -----------> loginQuickSdk retCode:" .. retCode)

    if retCode == 0 then
        self:loginSdkServerCheck(retCode, uid, userName, token, channel_code)
    elseif retCode == 1 then  -- 登录取消
        print("login cancel ret1.")
    elseif retCode == 2 then  -- 登录失败
        print("login failed ret2.")
    else
        print("login error ret.")
    end

end

function _M:loginSdkServerCheck(retCode, uid, userName, token, channel_code)

    print("uid:"..uid .. "  userName:"..userName.."  token:"..token.."  channel_code:"..channel_code)

    local requestData = {}
    local original = gdevice.getOpenUDID()
    local fake = crypto.md5(original..app_cfg.server_list_pw, false)
    requestData.sn = original
    requestData.sc = fake
    requestData.code = "quicksdk"
    requestData.token = token
    requestData.uid = uid
    requestData.channel_code = channel_code
    global.sdkBridge:setQuickToken(token)

    local url = urlHead..'?'
    for k,v in pairs(requestData) do 
        url=url..'&'..k..'='..v
    end 

    print(" -----------> loginQuickSdk url:" .. url)

    --服务器登录验证
    local responseCall = function (request, retCode)
        if retCode == 0 then 
            if request then 
                local rootData = cjson.decode(request:getResponseData())
                if rootData and rootData.sn then
                    global.loginData:setHttpSn(rootData.sn)
                    global.sdkBridge:setHttpSn(rootData.sn)
                end
            end
            if self.loginCallHandler then
                self.loginCallHandler()
                self.loginCallHandler = nil
            end
        end
    end
   
    local function onRequestFinished(event)
        local request = event.request
        if event.name == "inprogress" then
            return 
        elseif event.name == "failed" then
        elseif event.name == "completed" then  
            local responsData = request:getResponseData() 
            if responsData then
                log.trace("---->http call requesturl=%s, respone =%s", url, vardump(cjson.decode(request:getResponseData())))
                local retCode = cjson.decode(responsData).ret
                responseCall(request, retCode)
            end
        end 
    end

    local request = gnetwork.createHTTPRequest(onRequestFinished, url, app_cfg.server_list_method)
    request:addRequestHeader("Content-Type:application/text")
    request:setTimeout(15)
    request:start()
end
-- 灵石官方充值
function _M:lingshiPay(gift_id)
    -- http://wzxtlogin-internal.030303.com/verify.php?sc=a4a5e6e018bd82050e09f68199b271c7&code=lspay&sn=d5db98954f89149f8ef6b5eb433856dd&gift_id=1&login_name=xxxx&svr_id=999
    local responseCall = function (request, retCode)
        local rootData = cjson.decode(request:getResponseData())
        local data = rootData.param
        if rootData.ret == 0 then
            -- code=701 说明该参数不允许为空
            -- code=705 请求超时，一般是timestamp数据不正确
            -- code=603 说明存在相同的签名请求，第二次相同的签名会被拒绝
            -- code=402 签名不正确
            -- code=100 下单成功
            -- code=601 下单失败
            -- code=602 系统内部异常
            -- code=602 系统内部异常
            if data.code and data.code == 100 then
                global.sdkBridge:lingshiPayCash(data.data)
            else
                global.tipsMgr:showWarningText(data.code)
            end
        else
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        end    
    end    

    local params = {}
    params.code = "lspay"
    params.gift_id = gift_id
    params.login_name = global.userData:getAccount()    
    params.svr_id = global.loginData:getCurServerId()
    self:httpCheck(params,responseCall)
end

local UIWebView = require("game.UI.common.UIWebView")
-- 灵石官方充值
function _M:lingshiPayCash(data)
    if global.tools:isMobile() then
        local parent = global.scMgr:CurScene()

        local layout = ccui.Layout:create()
        layout:setPosition(gdisplay.center)
        layout:setBackGroundColor(cc.c3b(0,0,0))
        layout:setOpacity(255*0.55)
        layout:setContentSize(cc.size(gdisplay.width,gdisplay.height))
        parent:addChild(layout,100000)

        local web = UIWebView.new()
        web:setName("lingshiPayWebWidget")
        parent:addChild(web,100000)

        global.uiMgr:addWidgetTouchHandler(layout, function(sender, eventType)             
            global.uiMgr:removeSceneModal(20181126)
            layout:removeFromParent()
            web:removeFromParent()
        end)

        web:setPosition(gdisplay.center)
        web:setSize(cc.size(gdisplay.width*0.7,gdisplay.height*0.7))
        web:loadUrl("https://h5.passport.030303.com/choosepay/#/",false,"http://api.orders.030303.com")        

        -- web:loadUrl("https://wwww.baidu.com")
        web:setVisible(false)

        local donecall = function(url,callback)
            -- body
            if tolua.isnull(web) then
                return
            end
            print("-----setOnDidFinishLoading-----url=",url)
            local newurl
            if string.find(url,"result=wechat") then
                newurl = data.wechat_h5_url

                global.uiMgr:removeSceneModal(20181126)
                cc.Application:getInstance():openURL(newurl)                
                layout:removeFromParent()
                web:removeFromParent()  
            elseif string.find(url,"result=alipay") then
                newurl = data.alipay_h5_url 

                global.uiMgr:removeSceneModal(20181126)
                cc.Application:getInstance():openURL(newurl)                
                layout:removeFromParent()
                web:removeFromParent()       
            end
        end

        web:setOnDidFinishLoading(function(sender,url)
            -- body
            if tolua.isnull(web) then
                return
            end
            web:setVisible(true)
            donecall(url)
        end)

        web:setOnShouldStartLoading(function(sender,url)
            -- body
            print("-----setOnShouldStartLoading-----url=",url)
        end)
        
        web:setOnDidFailLoading(function(sender,url)
            -- body
            print("-----setOnDidFailLoading-----url=",url)
        end)
    else
        if call then call() end
    end
end

-- 灵石官方登陆
function _M:lingshiLoginCheck(ticket,i_type,callback)

    -- http://192.168.10.20:8484/verify.php?sn=aea42a8e876b93a3f6672f76eee3c95f&code=chgsvr&sc=81f7844281613bf9d66ca5362f8b7dd4&uid=0&des=20&src=1&login_name=guest33430656&type=0&bind_name=%22%22&alias_name=%22%22
    local responseCall = function (request, retCode)
        if retCode == WCODE_OK then
            local rootData = cjson.decode(request:getResponseData())
            local data = cjson.decode(rootData.param)
            if rootData.ret == 0 then
                if data.code and data.code == 0 then
                    if callback then
                        local sn = crypto.md5("lingshi_official"..data.data.id.."yanzhen@_@")
                        global.loginData:setHttpSn(sn)
                        global.sdkBridge:setHttpSn(sn)
                        callback()
                    end 
                else
                    global.tipsMgr:showWarningText(data.message)
                end
            else
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end            
        end
    end    

    local params = {}
    params.code = "lslogin"
    params.ticket = ticket
    params.type = i_type
    self:httpCheck(params, responseCall)
end


-- 灵石官方登陆
function _M:huaweiLoginCheck(paramStr,callback)

    -- http://192.168.10.20:8484/verify.php?sn=aea42a8e876b93a3f6672f76eee3c95f&code=chgsvr&sc=81f7844281613bf9d66ca5362f8b7dd4&uid=0&des=20&src=1&login_name=guest33430656&type=0&bind_name=%22%22&alias_name=%22%22
    local responseCall = function (request, retCode)
        if retCode == WCODE_OK then
            if callback then
                local paramarr = string.split(paramStr,"&")
                if paramarr[1] then
                    -- string.sub(paramarr[1],10) = "playerId=xxxxx" = xxxxx
                    local sn = crypto.md5("hw_official"..string.sub(paramarr[1],10).."yanzhen@_@")
                    global.loginData:setHttpSn(sn)
                    global.sdkBridge:setHttpSn(sn)
                    callback()
                end
            end            
        else
            global.tipsMgr:showQuitConfirmPanelNoClientNet()
        end
    end    

    local params = {}
    params.code = "hwlogin"
    params.none__ = paramStr
    self:httpCheck(params, responseCall)
end

-- ios 商品列表拉取
function _M:iosShopListGet()
    -- body

    if global.tools:isIos() then
        local shopList = {}
        for i=1,10 do
            table.insert(shopList, global.sdkBridge:app_sdk_pay_getProductId(i))
        end
        CCNative:iosShopListGet(cjson.encode(shopList))
    end

end

global.sdkBridge = _M
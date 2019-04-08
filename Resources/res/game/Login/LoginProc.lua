--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global
local loginData = global.loginData
local loginApi = global.loginApi
local gameEvent = global.gameEvent
local panelMgr = global.panelMgr
local userData = global.userData

local _M = {
    STATUS = 
    {
        LOGINSDK = 1,
        PLATINFO = 2,
        LOGINPLAT = 3,
        LOGINSERVER = 4,
        UPDATE = 5,
        ACTIVE = 6,    
        LISTCHARS = 7, 
        LOGINGAME = 8,
    },    
}

_M.status = _M.STATUS.LOGINSDK

function _M.Reset()    
    _M.status = _M.STATUS.LOGINSDK    
end

function _M.dealProc(callback,isRelogin)
    _M.goFunction = _M.goFunction or 
    {
        [_M.STATUS.LOGINSDK] = _M.loginSKD,
        [_M.STATUS.PLATINFO] = _M.platInfo,
        [_M.STATUS.LOGINPLAT] = _M.loginPlat,
        [_M.STATUS.LOGINSERVER] = _M.loginServer,        
        [_M.STATUS.UPDATE] = _M.update,
        [_M.STATUS.ACTIVE] = _M.activeAccount,
        [_M.STATUS.LISTCHARS] = _M.listChars,
        [_M.STATUS.LOGINGAME] = _M.loginGame,
    }
    
    local func = _M.goFunction[_M.status]
    if func then
        func(callback,isRelogin)
    end
end

function _M.StartProcess()
    _M.status = _M.STATUS.LOGINSDK
    _M.dealProc()
end

--登陆sdk
function _M.loginSKD()
    
    if GLFGetChanID() == WPBCONST.EN_CHAN_DEFAULT then
        
        local inputHandler = function(openid, openkey)
            
            local loginData = global.loginData
            loginData:setOpenId(openid)
            loginData:setOpenKey(openkey)

            _M.status = _M.STATUS.LOGINPLAT
            gevent:call(gameEvent.EV_ON_SDK_LOGIN_SUCCESS)
        end

        panelMgr:openPanel("UIInputAccountPanel"):setCallBack(inputHandler)
    else        
        _M.status = _M.STATUS.LOGINPLAT 
        gevent:call(gameEvent.EV_ON_SDK_PLATFORM_LOGIN)
    end    
end

--登陆平台
function _M.loginPlat()    
    local chanid = GLFGetChanID()
    local function on_plat_login(ret, msg, req)
        log.debug("==============> on_plat_login ret %s msg %s", ret, vardump(msg))
        if ret ~= WCODE.OK or msg.pkg == nil then
            local rptlog = string.format("login failed: %s, %s, %s, %s", chanid, ret or WCODE.ERR, req:getErrorCode() or "", req:getErrorMessage() or "empty!")
            log.debug("on_plat_login error:%s", rptlog)
            global.tipsMgr:showWarning(rptlog)
            _M.loginSKD()
        else
                    
            local loginData = global.loginData
            local result = msg.pkg.result  
                      
            if result.prompt == WPBCONST.PROMPT_OK then
                local accid = string.format("%s", result.accid)
                GamePlatform:getInstance():setAccID(accid)
                loginData:setAccId(result.accid)
                loginData:setHqToken(result.hqtoken)
                loginData:setTmExpire(result.tmexpire)
                loginData:setChanId(chanid)                

                local notify = msg.notify or {}
                if #notify > 0 then
                    loginData:setPlatNotify(msg.notify)
                end

                _M.status = _M.STATUS.PLATINFO          

            elseif result.prompt == WPBCONST.PROMPT_LOGIN_NEED_ACTIVE and result.bactive == true then
                loginData:setActiveUrl(result.activeurl)
                _M.status = _M.STATUS.ACTIVE
            else
                --错误弹框
            end

            loginData:setUserBit(result.bitmap)
            loginData:setLoginRecords(result.records)

            _M.dealProc()
        end
    end

    global.loginApi:loginPlat(on_plat_login)
end

--激活账户
function _M:activeAccount(cdkey)
    local activeCallBack =  function(ret, msg)        

    end
    
    global.loginApi:activeAccount(cdkey)
end

--获取服务器列表
function _M.platInfo()
    local serverSelectCallBack = function()
        _M.status = _M.STATUS.LOGINSERVER
        _M.dealProc()
    end
    local callBack = function(ret, msg)
        if ret == WCODE.OK then
            panelMgr:openPanel("UIServerSelectPanel"):setCallBack(serverSelectCallBack)            
        else
                    
        end
    end
    
    global.loginApi:GetPlatInfo(callBack, 0)
end

--直接登陆游戏服务器
function _M.loginServerQuick()
    _M.status = _M.STATUS.LOGINSERVER
    _M.dealProc()
end

--链接服务器
function _M.loginServer()  
    local auth = global.loginData:getLoginAuth() 
    local serData = global.ServerData:getServerDataBy()
    if not serData then 
        log.error("loginServer cannot get available serverData")
        global.tipsMgr:showQuitConfirmPanelNoClientNet()
        return 
    end
    --temp serData
    --dump(serData)
    local spstrs = string.split(serData.ip, ":")    
    local addr = spstrs[1]
    local port = toint(spstrs[2])
    gamecfg = {
        host = addr, 
        port = port, 
        net = "tcp"
    } 
    --dump(gamecfg)
    global.netRpc:DialGameSvr(auth, gamecfg)

end

--更新版本
function _M.update(callback)
    _M.status = _M.STATUS.UPDATE
    _M.dealProc(callback)
end

--开始登陆
function _M.startLogin(callback,isRelogin)
    _M.status = _M.STATUS.LOGINGAME
    _M.dealProc(callback,isRelogin)
end

--获取角色
function _M.listChars()
    local roleHandler = function(career, name)
        userData:SetCareer(career)
        userData:SetName(name)
        _M.loginGame(1)
    end

    local callBack = function(ret, msg)
        -- code -> MRRetcode
        -- msg -> MRListCharsRet
        if ret.retcode ==  WCODE.OK then
            _M.status = _M.STATUS.LOGINGAME
            log.debug("listchars:msg%s",vardump(msg))
            local chars = msg.chars or {}
            if #chars == 0 then
                panelMgr:openPanel("UIRoleSelectPanel"):setCallBack(roleHandler)
            else                
                _M.loginGame(0)
            end
        end
    end    
    global.loginApi:listChars(callBack)
end


--登陆游戏
function _M.loginGame(callback,isRelogin)
    local createCall = function(msg,callB2)
        -- 创角回调和登陆回调公用跳转
        global.userData:setUserId(msg.lUserID)
        global.userData:setIsLoginSuccess(true)
        global.loginApi:getLoginDetail(function(ret, msg)
            --登陆直通车 获取主城信息
            if ret.retcode == WCODE.OK then
                -- global.guideMgr:init()
                global.dataMgr:init(msg)
                global.PushInfoAPI:sendClientID() -- 登陆成功发送设备ID 2017年4月6日14:14:13 
                --netRpc:heartBeat心跳开始
                if callback then callback() end
                if callB2 then callB2() end
                gevent:call(global.gameEvent.EV_ON_LOGIN_DONE,isRelogin)           
                if isRelogin == 1 then  -- 重连事件派发
                    gevent:call(global.gameEvent.EV_ON_RECONNECT_UPDATE)
                end
            end
        end)
    end

    local callBB = function(ret, msg)        
        if ret.retcode == WCODE.OK then
            createCall(msg)
        elseif ret.retcode == 2 then
            cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.GUIDE_STEP,1)
            cc.UserDefault:getInstance():flush()
	    
            global.resMgr:preloadUITextures()
            global.userData:setIsRegister(true)
            global.userData:setCreateRole(true)

            if global.isloadOver then

                if global.panelMgr:isPanelExist("UIInputAccountPanel") then
                    global.panelMgr:getPanel("UIInputAccountPanel"):hideRoot()
                end
                global.panelMgr:openPanel("UISelectNew"):setCallBack(createCall)
                global.userData:setCreateRoleTime(os.time())
            else
                global.createCall = function()
                    -- body
                    if global.panelMgr:isPanelExist("UIInputAccountPanel") then
                        global.panelMgr:getPanel("UIInputAccountPanel"):hideRoot()
                    end
                    global.panelMgr:openPanel("UISelectNew"):setCallBack(createCall)
                    global.userData:setCreateRoleTime(os.time())
                end
            end
            
        end
    end 
    global.loginApi:loginGame(callBB,isRelogin)


end
return _M
--endregion

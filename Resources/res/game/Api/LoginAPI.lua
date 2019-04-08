--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global
local netRpc = global.netRpc
local gameReq = global.gameReq

local msgpack = require "msgpack"
local crypto  = require "hqgame"

local loginData = global.loginData

_M = {}

local platForm = cc.Application:getInstance():getTargetPlatform()
local platMap = {
    [cc.PLATFORM_OS_WINDOWS] = WPBCONST.EN_SYS_ANDROID,
    [cc.PLATFORM_OS_ANDROID] = WPBCONST.EN_SYS_ANDROID,
    [cc.PLATFORM_OS_IPHONE] = WPBCONST.EN_SYS_IOS,
    [cc.PLATFORM_OS_IPAD] = WPBCONST.EN_SYS_IOS,
}

_M.sysId = platMap[platForm]
-- login

function _M:GetPlatInfo(callBack)
    local pbmsg = msgpack.newmsg("MHPlatDir")
    pbmsg.chanid = GLFGetChanID()
    pbmsg.sysid = _M.sysId
    pbmsg.version = GLFGetAppVer()
    pbmsg.iver = loginData:getSerInfoVer()
    pbmsg.accid = loginData:getAccId()
    pbmsg.svnver = _DSVNVER
    pbmsg.worldid = GLFGetWorldID()

    local wrapCallBack = function(ret, msg)
        if ret == WCODE.OK and msg.pkg then
            loginData:setServerData(msg.pkg.zones)
        end
        log.debug("=================> GetPlatInfo %s %s", ret, vardump(msg))
        callBack(ret, msg)
    end

    netRpc:HttpCallPlat("PlatCtrl.GetDir", wrapCallBack, {data = {dtype="pb", msg=pbmsg}})
end

-- 登录平台
function _M:loginPlat(callBack)
    -- body
    local pbmsg = msgpack.newmsg("MHPlatLogin")
    pbmsg.channid = GLFGetChanID()
    pbmsg.openid = loginData:getOpenId()
    pbmsg.openkey = loginData:getOpenKey() 
    pbmsg.version = GLFGetAppVer()
    pbmsg.svnver = _DSVNVER
    pbmsg.worldid = GLFGetWorldID()

    local csdkChan = {
        [WPBCONST.EN_CHAN_DEFAULT] = 1,
        [WPBCONST.EN_CHAN_LT] = 1,
    }

    if csdkChan[pbmsg.channid] == nil then
        pbmsg.iscsdk = true
        local str = GamePlatform:getInstance():getPlatformLoginRet()
        local json = require "json"
        local loginRet = json.decode(str)
        pbmsg.csdk = loginRet
        loginRet.sdkVersion = nil
    end
        
    netRpc:HttpCallPlat("PlatCtrl.Login", callBack, {data = {dtype="pb", msg=pbmsg} })
end

function _M:VersionUpdate(svrId, callBack)
    local pbmsg = msgpack.newmsg("MHPlatUpdate")
    pbmsg.chanid = GLFGetChanID()
    pbmsg.sysid = _M.sysId
    pbmsg.version = GLFGetAppVer()
    pbmsg.zoneid = svrId
    pbmsg.svnver = _DSVNVER
    pbmsg.worldid = GLFGetWorldID()

    netRpc:HttpCallPlat("PlatCtrl.update", onHttpEnd, { data = { dtype = "pb", msg = pbmsg } })
end

-- 激活用户
function _M:activeAccount(activeCode, callBack)
    -- body
    local pbmsg = msgpack.newmsg("MHPlatActive")
    pbmsg.channid = GLFGetChanID()
    pbmsg.accid = loginData:getAccId()
    pbmsg.openid = loginData:getOpenId()
    pbmsg.openkey = loginData:getOpenKey()
    pbmsg.cdkey = activeCode
    
    netRpc:HttpCallPlat("PlatCtrl.Active", callBack, {data = {dtype="pb", msg=pbmsg} })
end

---------------------------------------------------
-- 拉取角色列表
function _M:listChars(callBack)
    assert(type(callBack) == "function")    
    gameReq.CallRpc("data", "listchars", callBack)
end


-- optional string szDID = 1;//'(必填)玩家注册时设备号 （md5(gaid+imei+android_id+mac+udid+idfa)）',
-- optional string szMAC = 2;// '玩家注册时设备MAC地址',
-- optional string szIDFA = 3;//'注册时苹果IDFA',
-- optional string szGAID = 4;//'注册时设备的谷歌id 默认 null 字符串',
-- optional string szAndroidID = 5;//'注册时设备安卓id',
-- optional string szUDID = 6;//'注册时设备udid',
-- optional string szOpenUDID = 7;//'注册时设备OpenUDID',
-- optional string szIMEI = 8;//'注册时设备IMEI',
-- optional string szClientVersion = 9;//客户端版本
-- optional string szPackageName = 10;//客户端包名
-- optional string szRegLang = 11;//语言
-- optional string szRegIP = 12;//注册ip
-- optional string szRegCountry = 13;//注册国家代码
-- optional string szSystemHardware = 14;//'(可选)移动终端机型, 如 iphone6 iphone6s mi4 等',
-- optional string szSystemSoftware = 15;// '(可选)移动终端操作系统版本',
-- optional string szTelecomOper = 16;// varchar(64) DEFAULT NULL COMMENT '(必填)运营商',
-- optional string szNetwork = 17;//DEFAULT NULL COMMENT '(可选)3G/WIFI/2G/4G',
-- optional int32 lScreenWidth = 18;   //
-- optional int32 lScreenHight = 19;
-- optional int32 lMemory  = 20;
function _M:getCpDeviceInfo(ishttp)

    local data = {}
    if not (global.tools:isIos() or global.tools:isAndroid()) then
        return data
    end 

    local sharedDirector = cc.Director:getInstance()
    local glview = sharedDirector:getOpenGLView()
    local frameSize = glview:getFrameSize()
    -- local state = gnetwork.getInternetConnectionStatus()
    local state = 0
    local netDesc = {
        [0] = "unknown",
        [1] = "wifi",
        [2] = "2g",
        [3] = "3g",
        [4] = "4g",
    }
    data.szOS       = 1
    if global.tools:isAndroid() then
        data.szDID          = gdevice.getOpenUDID()
        data.szMAC          = gluaj.callGooglePayStaticMethod("get_MAC_addr",{},"()Ljava/lang/String;")
        data.szGAID         = gluaj.callGooglePayStaticMethod("get_GAID",{},"()Ljava/lang/String;")
        data.szAndroidID    = gluaj.callGooglePayStaticMethod("get_android_ID",{},"()Ljava/lang/String;")
        data.szIMEI         = gluaj.callGooglePayStaticMethod("get_IMEI_ID",{},"()Ljava/lang/String;")
        data.szPackageName  = gluaj.callGooglePayStaticMethod("get_packageName",{},"()Ljava/lang/String;")
        data.szRegIP        = gluaj.callGooglePayStaticMethod("get_ip",{},"()Ljava/lang/String;")
        data.szRegCountry   = global.userData:getCountry() -- gluaj.callGooglePayStaticMethod("get_Country",{},"()Ljava/lang/String;")
        local lMemory       = gluaj.callGooglePayStaticMethod("get_memory",{},"()Ljava/lang/String;")
        data.szSystemHardware = gluaj.callGooglePayStaticMethod("getPhoneName",{},"()Ljava/lang/String;")
        data.szSystemSoftware = gluaj.callGooglePayStaticMethod("getPhoneSystemVersion",{},"()Ljava/lang/String;")
        data.szTelecomOper = gluaj.callGooglePayStaticMethod("getNetWorkOperatorName",{},"()Ljava/lang/String;")
        data.lMemory        = math.floor(tonumber(string.sub(lMemory,0,-3))*1024)
        data.szOS           = 1
        data.szNetwork = gluaj.callGooglePayStaticMethod("getInternetConnectionStatus",{},"()Ljava/lang/String;")
        print("---->android net state ="..data.szNetwork)
    else
        data.szDID          = ""
        data.szMAC          = ""
        data.szGAID         = ""
        data.szAndroidID    = ""
        data.szIMEI         = ""
        data.szPackageName  = ""
        data.szRegIP        = ""
        data.szRegCountry   = ""
        data.lMemory        = 0
    end

    if global.tools:isIos() then
        data.szNetwork  = CCNative:getNetworktype()
        data.szIDFA     = CCNative:getIDFA()
        data.szUDID     = ""
        data.szOpenUDID = gdevice.getOpenUDID()
        local lMemory = CCNative:getAvailableMemorySize()
        data.lMemory    = math.floor(lMemory*1024)
        data.szOS       = 0
        data.szRegIP = CCNative:getIP()
        data.szRegCountry   = global.userData:getCountry() -- gluaj.callGooglePayStaticMethod("get_Country",{},"()Ljava/lang/String;")
        data.szSystemHardware = gdevice.getIphoneModel() or ""
        data.szSystemSoftware = (CCNative:getSystemName()..CCNative:getSystemVersion()) or ""
        if CCNative:isAllowsVOIP() then
            data.szTelecomOper = string.format("%s_true_%s_%s",CCNative:getIsoCountryCode(),CCNative:getMobileCountryCode(),CCNative:getMobileNetworkCode()) or ""
        else
            data.szTelecomOper = string.format("%s_false_%s_%s",CCNative:getIsoCountryCode(),CCNative:getMobileCountryCode(),CCNative:getMobileNetworkCode()) or ""
        end

        data.szPackageName  = CCNative:getBundleId()
    else
        data.szIDFA     = ""
        data.szUDID     = ""
        data.szOpenUDID = ""
    end
    if not ishttp then
        data.szOS       = nil
    end
    data.szClientVersion = GLFGetAppVerStr() or ""
    data.szRegLang = gdevice.language  or ""
    data.lScreenWidth = frameSize.width--gdisplay.framesize.widget
    data.lScreenHight = frameSize.height--gdisplay.framesize.height
    if (cc.UserDefault:getInstance():getBoolForKey("isLowQuality", false)) then
        data.szUDID = 1
    else
        data.szUDID = 0
    end

    return data
end

-- 用户登录
-- message UserLoginReq   
-- {
--     required int32      lUserID = 1; // ID
--         required int32      lClientIP = 2;  //IP          
--     required string     szPassportID = 3; //utf-8
-- }

function _M:loginGame(callBack,lIsRelogin,isShowActiveTips)
    local pbmsg = msgpack.newmsg("UserLoginReq")
    pbmsg.lClientIP = 0
    pbmsg.szLoginName = global.userData:getAccount()
    -- crypto.md5(gdevice.getOpenUDID(), false) 
    pbmsg.szPassportID = global.loginData:getHttpSc()
    pbmsg.lVersions = GLFGetAppVer()
    if global.tools:isAndroid() then
        pbmsg.lType = global.sdkBridge:getQuickChannelType()
    elseif global.tools:isIos() then
        pbmsg.lType = 0
    end
    pbmsg.szCode = global.loginData:getActiveCode()
    pbmsg.lIsRelogin = (lIsRelogin == 1)
    pbmsg.szDeviceID = gdevice.getOpenUDID()
    pbmsg.szSN = global.loginData:getHttpSn()
    pbmsg.tagDeviceInfo = self:getCpDeviceInfo()

    assert(pbmsg)
    assert(type(callBack) == "function")

    local callbb = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if callBack then callBack(ret, msg) end
        elseif ret.retcode == 1002 then
            --请输入激活码
            if isShowActiveTips then
                global.tipsMgr:showWarning("activitation_code")
            end
            global.panelMgr:openPanel("UIEditActiveCodePanel"):setData(function()
                -- body
                self:loginGame(callBack,lIsRelogin,true)
            end)
        else
            if callBack then callBack(ret, msg) end
        end
    end
    
    gameReq.CallRpc("data", "login", callbb, pbmsg)
end

-- 转职
function _M:turnRole(lRole,callBack)
    local pbmsg = msgpack.newmsg("TurnRoleReq")
    pbmsg.lRole = lRole

    local callbb = function(ret, msg)
        if ret.retcode == WCODE.OK then
            if callBack then callBack(ret, msg) end
        end
    end
    gameReq.CallRpc("data", "TurnRole", callbb, pbmsg)
end

function _M:createRole(race_id,callBack)
    local pbmsg = msgpack.newmsg("UserCreateReq")
    pbmsg.lUserKind = race_id
    pbmsg.szRoleName = global.userData:getUserName()
    pbmsg.szPassportID = global.loginData:getHttpSc()
    pbmsg.szLoginName = global.userData:getAccount()
    pbmsg.szDeviceID = gdevice.getOpenUDID()
    pbmsg.szSN = global.loginData:getHttpSn()
    pbmsg.tagDeviceInfo = self:getCpDeviceInfo()
    if global.tools:isAndroid() then
        pbmsg.lType = global.sdkBridge:getQuickChannelType()
    elseif global.tools:isIos() then
        pbmsg.lType = 0
    end

    assert(pbmsg)
    assert(type(callBack) == "function")    
    
    gameReq.CallRpc("data", "create_role", callBack, pbmsg)
end

function _M:getLoginDetail(callBack)
    local pbmsg = msgpack.newmsg("GetLoginDetailReq")

    if not self.m_lastAccountId or (self.m_lastAccountId ~= global.userData:getAccount()) then
        print("------------->umeng SDK ----=========----->");
        gumengSdk.profileSignIn(global.userData:getAccount(),"knightscreed_cn")
    end
    self.m_lastAccountId = global.userData:getAccount()

    assert(pbmsg)
    assert(type(callBack) == "function")   

    local callbb = function(ret, msg)
        if ret.retcode == WCODE.OK then
            log.debug("#######GetLoginDetailResp:%s",vardump(msg))
        end
        if callBack then callBack(ret, msg) end
    end
    gameReq.CallRpc("data", "get_login_detail", callbb, pbmsg)
    global.dataMgr:setClientStartTime()
end

function _M:getRandName(callBack)
    local pbmsg = msgpack.newmsg("GetRandNameReq")

    assert(pbmsg)
    assert(type(callBack) == "function")    
    
    gameReq.CallRpc("data", "get_rand_name", callBack, pbmsg)
end

-- 修改用户头像
function _M:updateUserInfo(lFaceID, callBack)
    local pbmsg = msgpack.newmsg("UpdateUserInfoReq")
    pbmsg.lFaceID = lFaceID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            global.userData:setlUserPic(msg.lFaceID)
            callBack(msg)
        end
    end

    gameReq.CallRpc("login", "updateUserInfo", rsp_call, pbmsg)
end


-- 修改用户头像边框
function _M:updateUserHeadFrame(lBackID, callBack)
    local pbmsg = msgpack.newmsg("UpdateUserInfoReq")
    pbmsg.lBackID = lBackID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("updateUserHeadFrame", "updateUserInfo", rsp_call, pbmsg)
end


-- 修改用户城堡皮肤
function _M:updateUserCastleSkin(lSkinID, callBack)
    local pbmsg = msgpack.newmsg("UpdateUserInfoReq")
    pbmsg.lSkinID = lSkinID

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("updateUserHeadFrame", "updateUserInfo", rsp_call, pbmsg)
end


-- 获取用户城堡皮肤
function _M:getUserCastleSkin(callBack)
    local pbmsg = msgpack.newmsg("GetAvatarSkinReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
            callBack(msg)
        end
    end

    gameReq.CallRpc("updateUserHeadFrame", "updateUserInfo", rsp_call, pbmsg)
end


-- 获取用户头像信息
function _M:getUserHeadFrameInfo(callBack)
    
    local pbmsg = msgpack.newmsg("GetRoleFrameReq")

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
             callBack(msg)
        end
    end
    gameReq.CallRpc("getUserHeadFrameInfo", "getUserHeadFrameInfo", rsp_call, pbmsg)
end


-- // 1.固定活动
-- // 2.大型活动
-- // 3.开服活动
-- // 4.单个活动(单个活动，第一参数是活动id，第二参数(1.活动详情，2.排名奖励，3.积分奖励，4.正常奖励))
    -- activity_id=2001,  name="失落的经验之泉",       
    -- activity_id=6001,  name="利维亚的祝福",         
    -- activity_id=8001,  name="英魂祭坛召唤石限时出售"
    -- activity_id=15001,  name="城堡升级",            
    -- activity_id=16001,  name="领主升级",            
    -- activity_id=13001,  name="联盟奇迹竞赛",        
    -- activity_id=14001,  name="杀怪竞赛",            
    -- activity_id=18001,  name="新手签到",            
    -- activity_id=11001,  name="联盟掠夺竞赛",        
    -- activity_id=9001,  name="累计充值活动",         
    -- activity_id=3001,  name="战力提升",             
    -- activity_id=40001,  name="首充活动",            
    -- activity_id=4001,  name="神殿争夺战",           
    -- activity_id=19001,  name="七天霸主之路",        
    -- activity_id=20001,  name="塔兰之剑争夺战",      
-- // 11.魔晶
-- // 12.礼包ICON
-- // 13.联盟
-- // 14.资源
-- // 15.领主资料
-- // 16.超值月卡
-- // 20.各个id的礼包和档位魔晶点击
-- // 21.各个id的礼包和档位魔晶展示
-- // 22.各个id的礼包和档位魔晶停留
-- // 23.各个id的礼包和档位魔晶购买
-- // 24.各个id的礼包和档位魔晶购买成功
    -- [1] = { id=1,  ad_type=1,  dropid=60001,  name="资源礼包",  ad_banner="
    -- [2] = { id=2,  ad_type=1,  dropid=60002,  name="中级资源礼包",  ad_bann
    -- [3] = { id=3,  ad_type=1,  dropid=60003,  name="高级资源礼包",  ad_bann
    -- [4] = { id=4,  ad_type=2,  dropid=60004,  name="训练加速礼包",  ad_bann
    -- [5] = { id=5,  ad_type=2,  dropid=60005,  name="中级训练加速礼包",  ad_
    -- [6] = { id=6,  ad_type=2,  dropid=60006,  name="高级训练加速礼包",  ad_
    -- [7] = { id=7,  ad_type=3,  dropid=60007,  name="科技加速礼包",  ad_bann
    -- [8] = { id=8,  ad_type=3,  dropid=60008,  name="中级科技加速礼包",  ad_
    -- [9] = { id=9,  ad_type=3,  dropid=60009,  name="高级科技加速礼包",  ad_
    -- [10] = { id=10,  ad_type=4,  dropid=60010,  name="建造加速礼包",  ad_ba
    -- [11] = { id=11,  ad_type=4,  dropid=60011,  name="中级建造加速礼包",  a
    -- [12] = { id=12,  ad_type=4,  dropid=60012,  name="高级建造加速礼包",  a
    -- [13] = { id=13,  ad_type=5,  dropid=60013,  name="战争礼包",  ad_banner
    -- [14] = { id=14,  ad_type=6,  dropid=60014,  name="高级英雄说服礼包",  a
    -- [15] = { id=15,  ad_type=7,  dropid=60015,  name="装备强化礼包",  ad_ba
    -- [16] = { id=16,  ad_type=7,  dropid=60016,  name="高级装备强化礼包",  a
    -- [17] = { id=17,  ad_type=8,  dropid=60017,  name="联盟礼包",  ad_banner
    -- [18] = { id=18,  ad_type=8,  dropid=60018,  name="中级联盟礼包",  ad_ba
    -- [19] = { id=19,  ad_type=8,  dropid=60019,  name="高级联盟礼包",  ad_ba
    -- [20] = { id=20,  ad_type=0,  dropid=100021,  name="魔晶礼包Ⅰ",  ad_ban
    -- [21] = { id=21,  ad_type=0,  dropid=100022,  name="魔晶礼包Ⅱ",  ad_ban
    -- [22] = { id=22,  ad_type=0,  dropid=100025,  name="魔晶礼包Ⅲ",  ad_ban
    -- [23] = { id=23,  ad_type=0,  dropid=100023,  name="英雄经验周卡",  ad_b
    -- [24] = { id=24,  ad_type=0,  dropid=100024,  name="英雄说服道具周卡",  
    -- [25] = { id=25,  ad_type=0,  dropid=100042,  name="资源周卡",  ad_banne
    -- [26] = { id=26,  ad_type=0,  dropid=100043,  name="领主经验周卡",  ad_b
    -- [27] = { id=27,  ad_type=0,  dropid=100044,  name="魔晶月卡",  ad_banne
    -- [28] = { id=28,  ad_type=0,  dropid=0,  name="科技第二队列周卡",  ad_ba
    -- [29] = { id=29,  ad_type=0,  dropid=0,  name="训练第二队列周卡",  ad_ba
    -- [30] = { id=30,  ad_type=0,  dropid=100045,  name="装备强化道具周卡",  
    -- [31] = { id=31,  ad_type=0,  dropid=100026,  name="魔晶礼包Ⅳ",  ad_ban
    -- [32] = { id=32,  ad_type=0,  dropid=100027,  name="魔晶礼包Ⅴ",  ad_ban
    -- [33] = { id=33,  ad_type=0,  dropid=60157,  name="装备周卡",  ad_banner
    -- [34] = { id=34,  ad_type=0,  dropid=60156,  name="迁城周卡",  ad_banner
    -- [35] = { id=35,  ad_type=9,  dropid=70019,  name="首充礼包",  ad_banner
    -- [36] = { id=36,  ad_type=10,  dropid=60020,  name="中级英雄说服礼包",  
function _M:clickPointReport(callBack,lKind,lType,lDuration)
    
    local pbmsg = msgpack.newmsg("ClickReportReq")
    pbmsg.lKind = lKind
    pbmsg.lType = lType
    pbmsg.lDuration = lDuration or 0

    local rsp_call = function(ret, msg)
        if ret.retcode == WCODE.OK then
             if callBack then callBack(msg) end
        end
    end
    gameReq.CallRpcSilentAndNoRetry("ClickPointReport", "ClickPointReport", rsp_call, pbmsg , true)
end

function _M:sendGiftEnterRecords()
    local ttPanelName = global.panelMgr:getTopPanelName()
    if ttPanelName == "UIRechargePanel" then
        global.loginApi:clickPointReport(nil,11,nil,nil)
    elseif ttPanelName == "UIHadUnionPanel" then
        global.loginApi:clickPointReport(nil,13,nil,nil)
    elseif ttPanelName == "UIResPanel" then
        global.loginApi:clickPointReport(nil,14,nil,nil)
    elseif ttPanelName == "UILordPanel" then
        global.loginApi:clickPointReport(nil,15,nil,nil)
    end
end

global.loginApi = _M

--endregion

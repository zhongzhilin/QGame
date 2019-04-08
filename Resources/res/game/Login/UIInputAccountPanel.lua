--region UIInputAccountPanel.lua
--Author : untory
--Date   : 2016/08/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local CUR_USER_KEY = "user-account"
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local datetime = require "datetime"
local pbpack   = require "pbpack" 
local app_cfg = require "app_cfg"
local gevent = gevent
local gameEvent = global.gameEvent
local UIUpdateControl = require "game.UI.common.UIUpdateControl"

local TextScrollControl = require("game.UI.common.UITextScrollControl")
local UIInputAccountPanel  = class("UIInputAccountPanel", function() return gdisplay.newWidget() end )
local UIWebView = require("game.UI.common.UIWebView")
-- 0：检查热更
-- 1：检查登陆
-- 2：检查角色
-- 3：加载资源
local taskcount = 4

function UIInputAccountPanel:hideRoot()
    
    if not tolua.isnull(self.root) then
        self.root:stopAllActions()
        self.root:setVisible(false)
    end

    if not tolua.isnull(self.Image_1) then
        self.Image_1:removeFromParent()
    end

    if not tolua.isnull(self.Image_2) then
        self.Image_2:removeFromParent()
    end

end

function UIInputAccountPanel:ctor()
    self.configdata={
        hot_update= 35 ,
        check_login=0,
        check_role= 0,
        load_res= 40,
        load_world = 20,
        send_login = 5,
        ConfigTable = 0 ,  
    }
    self.progress={
        hot_update= 0 ,
        check_login=0,
        check_role= 0,
        load_res= 0,
        load_world = 0,
        send_login = 0,
        ConfigTable = 0  ,  
    }
    self.m_isFirstStartUpdateCall = nil
    self.m_isLoginStart = false
    self:CreateUI()
end

function UIInputAccountPanel:onExit()
    global.isloadOver = false
    if self.scheduleListenerLoad then 
        gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
        self.scheduleListenerLoad = nil
    end
end
-- quicksdk 第三方登录
function UIInputAccountPanel:loadMapInfo()

    local call = function ()
        global.panelMgr:openPanel("UICustomNoticePanel"):setExitCall(function ()
            if self.loginStart then 
                self:loginStart()
            end 
        end)
    end

    if global.tools:isAndroid() and (_QUICK_SDK) then        
        if not _IS_LINGSHI_LOGIN then
            local sdkName = gluaj.callGooglePayStaticMethod("getSdkName",{},"()Ljava/lang/String;")

            if sdkName == "HUAWEI" then
                self:HWLogin(call)
            else
                global.sdkBridge:initQuickSdk()
                local switchSn = global.sdkBridge:getSwitchQuickSn()
                if switchSn and switchSn ~= "" then
                    call()
                else
                    global.sdkBridge:loginQuick(call)
                end
            end
        else
            self:lingshiLogin(call)
        end
    else
        if global.tools:isIos() and _CPP_RELEASE == 1 then
        -- if global.tools:isIos() then
            self:lingshiLogin(call)
            -- call()
        else
            call()
        end
    end
    self:loadMapInfoCall()

end
 
local currClock = datetime.now().secs
--加载一些预加载项
function UIInputAccountPanel:loadMapInfoCall()
    if self.m_updateControl and self.m_updateControl:isNeedUpdate() then
        return
    end
    global.m_loadingNetTimeCost =  os.clock()-global.m_loadingNetTimeCost
    --protect 
    if self.progress then 
        self.progress.load_world = 0
    end 

    local worldView = {}
    global.g_worldview = worldView
    worldView.mapInfo = require("game.UI.world.data.MapInfo").new()    
end

function UIInputAccountPanel:updateMapInfoProgress(pen)
    if self.m_updateControl and self.m_updateControl:isNeedUpdate() then
        return
    end
    if not self.progress then
        return
    end
    self.progress.load_world = pen
    self:updateLoadingBar()

    if pen == 100 then

        self:loadWorldCityMgr()
    end
end

function UIInputAccountPanel:loadWorldCityMgr()
    if self.m_updateControl and self.m_updateControl:isNeedUpdate() then
        return
    end
    global.g_worldview = global.g_worldview or {} 
    global.g_worldview.worldCityMgr = require("game.UI.world.mgr.WorldCityMgr").new()
    global.g_worldview.worldCityMgr:loadRoad()
    global.g_worldview.worldCityMgr:loadUseful()

    self:loadRes()
end
 
function UIInputAccountPanel:loadRes()
    if self.m_updateControl and self.m_updateControl:isNeedUpdate() then
        return
    end

    self.preResList = resMgr:preloadUITexturesByLoading()
    self.perResTotalNum = table.nums(self.preResList) 
    -- 开始加载
    self:loadDoneCall()
end 

function UIInputAccountPanel:CreateUI()
    local root = resMgr:createWidget("loading/loading_bg")
    self:initUI(root)
end

function UIInputAccountPanel:checkRichText()
    
    local luaCfg = global.luaCfg
    local richText = luaCfg:richText()

    local errorCount = 0
    local errorIndexs = {}
    for index,v in pairs(richText) do        

        local cnData = uiMgr:decodeRichData(v['text'])
        local keysList = {}
        for _,cnRichData in ipairs(cnData) do

            if cnRichData['key'] then

                keysList[cnRichData['key']] = true
            end
        end

        dump(keysList,'keysList')

        for keys,_ in pairs(v) do
            if string.startswith(keys,'text') then

                local str = v[keys]
                local data =  uiMgr:decodeRichData(str)

                for richIndex,richData in ipairs(data) do

                    if not (richData['type'] or richData['label'] or richData['key']) then
                        
                        dump(data,"error rich data " .. index .. ' ' .. keys)
                        errorCount = errorCount + 1
                        table.insert(errorIndexs,{index = index,key = keys})
                        break
                    end

                    if richData['key'] then

                        if not keysList[richData['key']] then

                            print('can not found key',index,keys,richData['key'])

                            errorCount = errorCount + 1
                            table.insert(errorIndexs,{index = index,key = keys})
                            break
                        end
                    end
                end
            end
        end
    end

    print(errorCount,'errorCount')
    dump(errorIndexs,'errorIndexs')
end

function UIInputAccountPanel:initUI(root)
    
    -- self:checkRichText()

    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/loading_bg")
    
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("test.plist")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Image_1 = self.root.Image_1_export
    self.Image_2 = self.root.Image_2_export
    self.Node_2 = self.root.Image_2_export.Node_2_export
    self.LoadingBar = self.root.LoadingBar_export
    self.loading_tips = self.root.loading_tips_export
    self.star = self.root.Panel_1.star_export
    self.progress_desc = self.root.progress_desc_export
    self.loading_update_node = self.root.loading_update_node_export
    self.unzip_desc = self.root.loading_update_node_export.unzip_desc_mlan_8_export
    self.unzip_pro = self.root.loading_update_node_export.unzip_desc_mlan_8_export.unzip_pro_export
    self.hot_fix_desc = self.root.loading_update_node_export.hot_fix_desc_mlan_6_export
    self.hot_fix_pro = self.root.loading_update_node_export.hot_fix_desc_mlan_6_export.hot_fix_pro_export
    self.version_num = self.root.version_num_export

--EXPORT_NODE_END    
    global.tools:adjustNodePosForFather(self.unzip_desc,self.unzip_pro)
    global.tools:adjustNodePosForFather(self.hot_fix_desc , self.hot_fix_pro)
    
end

function UIInputAccountPanel:setData()
    gsound.preloadAllSounds()
    global.startLoading = true
    global.isStartLoading = true
    self.average_progress =   100 /  taskcount
    self.Percent = 0
    self.index = 0
    self.perId = 0
    self.LoadingBar:setPercent(0)
    self.loadBarW = self.LoadingBar:getContentSize().width
    self.starStartX = self.star:getPositionX() 

    local nodeTimeLine = resMgr:createTimeline("effect/lording_par")
    nodeTimeLine:play("animation0", true)
    self.star:runAction(nodeTimeLine)

    local nodeTimeLine = resMgr:createTimeline("loading/loading_bg")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)

    gsound.playBgm("loading_bg")
    gevent:call(gsound.EV_ON_PLAYSOUND,"loading_battle")
    global.isloadOver = false

    local alltips = global.luaCfg:loading_tips()
    local tipsData = table.keys(alltips)
    local randId = math.random(1,#tipsData)
    self.loading_tips:setString(alltips[tipsData[randId]].text)

    global.m_loadingNetTimeCost =  os.clock()

    if global.tools:isIos() then
        local ok,netType = gluaoc.callStaticMethod("AppController", "isNetInit")
        if netType <= 1 then
            global.panelMgr:openPanel("UILoginConfirm"):showClientNoNet(function()                
                global.funcGame.allExit()
            end)
            local checkIosFirstTimer 
            checkIosFirstTimer = gscheduler.scheduleGlobal(function()                
                local ok,netType = gluaoc.callStaticMethod("AppController", "isNetInit")

                if netType <= 1 then
                else
                    if checkIosFirstTimer then
                        gscheduler.unscheduleGlobal(checkIosFirstTimer)
                    end

                    if not global.netRpc:checkClientNetWithError() then
                        return
                    else
                        global.panelMgr:closePanel("UILoginConfirm",true)
                        self:hotFixCheck()
                    end
                end
            end,1)
            return
        end
    end

    if not global.netRpc:checkClientNetWithError() then
        return
    else        
        self:hotFixCheck()
    end
end

function UIInputAccountPanel:onEnter()
    math.randomseed(os.time())
    math.random()

    g_profi:time_start()
    global.sdkBridge:iosShopListGet()

    self.loading_update_node:setVisible(false)
    self.version_num:setString(GLFGetAppVerStr())

    global.advertisementData:setIsFirstOnEnter(true)
end

function UIInputAccountPanel:closeWebLogin()
    local web = self:getChildByName("lingshiWebWidget")
    if not tolua.isnull(web) then
        web:removeFromParent()
    end
end

function UIInputAccountPanel:lingshiLogin(call)
    if global.tools:isMobile() then
        if global.panelMgr:isPanelOpened("UILoginConfirm") or global.panelMgr:isPanelOpened("UISystemConfirm") or global.panelMgr:isPanelOpened("UIMaintancePanel") then
            return
        end
        local web = UIWebView.new()
        web:setName("lingshiWebWidget")
        self:addChild(web)

        web:setPosition(gdisplay.center)
        web:setSize(cc.size(gdisplay.width*0.7,gdisplay.height*0.7))
        web:loadUrl("https://h5.passport.030303.com/v1/#/login")

        -- web:loadUrl("https://wwww.baidu.com")
        web:setVisible(false)

        local donecall = function(url,callback)
            -- body
            if tolua.isnull(web) then
                return
            end
            print("-----setOnDidFinishLoading-----url=",url)
            if string.find(url,"result=success") then
                web:removeFromParent()
                local dataarr = string.split(url,"&")
                local ticket = nil
                for i,v in pairs(dataarr) do
                    if string.find(v,"ticket=") then
                        ticket = string.sub(v,8)
                        break
                    end
                end
                if string.find(url,"register") then
                    global.sdkBridge:lingshiLoginCheck(ticket,1,call)
                elseif string.find(url,"login") then
                    global.sdkBridge:lingshiLoginCheck(ticket,0,call)
                end
                if callback then callback() end
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

        if global.tools:isIos() then
            local lingshiLoginTimer = nil
            local function closetimer()
                if lingshiLoginTimer then
                    gscheduler.unscheduleGlobal(lingshiLoginTimer)
                    global.loadingDesignTimer = nil
                end
            end
            lingshiLoginTimer = gscheduler.scheduleGlobal(function()
                if tolua.isnull(web) then
                    return
                end
                local url = web:getCurrUrl()
                print("------>url=",url)
                donecall(url,closetimer)
            end,0.5)
        end
    else
        if call then call() end
    end
end

function UIInputAccountPanel:HWLogin(call)
    if global.tools:isAndroid() then

        -- -- 加载登录完成，进入游戏
        local function success(paramStr)
            -- body
            global.sdkBridge:huaweiLoginCheck(paramStr,call)
        end

        local function changed()
            -- 账号异常登陆
            global.ClientStatusData:Errorhandle(WCODE.ERR_ABNORMAL_LOGIN)
        end
        gluaj.callGooglePayStaticMethod("HWlogin",{success,changed},"(II)V")
        
    else
        if call then call() end
    end
end


function UIInputAccountPanel:hotFixCheck()

    -- -- 加载登录完成，进入游戏
    local loginDoneHandler = function()
        if global.isloadOver then
            self.progress_desc:setString(global.luaCfg:get_local_string(10936))
            self:loadFinished()
        else
            global.isloadOver = true
            if global.createCall then
                global.createCall()
                global.createCall = nil
            end
        end
    end
    self:addEventListener(gameEvent.EV_ON_LOGIN_DONE, loginDoneHandler)

    self.progress_desc:setVisible(true)
    self.progress_desc:setString(global.luaCfg:get_local_string(10935))
    -- 模拟连接服务器进度条
    local isCheckFinish1 = false
    local isCheckFinish2 = false
    local isCheckFinish = false
    local oneTimerFunction = nil
    local twoTimerFunction = nil
    oneTimerFunction = function()
        -- body
        self.progress.hot_update = self.progress.hot_update+100/200
        print(self.progress.hot_update)
        print(isCheckFinish)
        if self.progress.hot_update>100 then
            self.progress.hot_update = 100
            self:updateLoadingBar()
            if isCheckFinish then
                self:unschedule(oneTimerFunction)

                self:loginStart()
            end
        else
            self:updateLoadingBar()
            if isCheckFinish then
                local currper = self.progress.hot_update
                twoTimerFunction = function()
                    -- body
                    self.progress.hot_update = self.progress.hot_update+(100-currper)/20           
                    if self.progress.hot_update>100 then
                        self:unschedule(twoTimerFunction)
                        self.progress.hot_update = 100
                        self:loginStart()
                    end
                    self:updateLoadingBar()
                end
                self:schedule(twoTimerFunction, 1/40)

                self:unschedule(oneTimerFunction)
            end
        end
    end
    self:schedule(oneTimerFunction, 1/40)
    self.progress.hot_update = 0

    local updateControl = UIUpdateControl.new(function(pen,str)
        if tolua.isnull(self.loading_update_node) then return end
        pen = pen*0.8+20
        if self.m_isFirstStartUpdateCall then
            -- 拉取到zip包，开始更新
            self.m_isFirstStartUpdateCall()
            self.m_isFirstStartUpdateCall = nil
        end
        self.progress_desc:setVisible(false)
        self.loading_update_node:setVisible(true)
        self.unzip_desc:setVisible(false)
        self.hot_fix_desc:setVisible(true)
        self.Percent = pen
        self.LoadingBar:setPercent(pen)
        self:updateStarStartX()
        self.hot_fix_pro:setString(str.." "..pen.."%")
        self.unzip_pro:setString(pen.."%")  

        global.tools:adjustNodePosForFather(self.hot_fix_desc , self.hot_fix_pro)

    end,function(isAfterunzip)
        if tolua.isnull(self.hot_fix_desc) then return end
        self.hot_fix_desc:setVisible(false)
        self:changeLoading(0)
        self.unzip_pro:setString("0%")

        if isAfterunzip then

            self.hot_fix_desc:setVisible(false)
            self.unzip_desc:setVisible(true)


            self.Percent =0
            self.LoadingBar:setPercent(0)
            self:unschedule(oneTimerFunction)
            self:unschedule(twoTimerFunction)
            local thirdTimerFunction = nil
            local pen2 = 0
            thirdTimerFunction = function()
                -- body
                pen2 = pen2+100/20
                if pen2>100 then
                    pen2=100
                    self:unschedule(thirdTimerFunction)
                    global.funcGame.RestartGame()
                    return
                end
                self.LoadingBar:setPercent(pen2)
                self.unzip_pro:setString(pen2.."%")
                self.star:setPositionX(self.starStartX + self.loadBarW*pen2/100)
            end
            self:schedule(thirdTimerFunction, 1/40)

            self.star:runAction(cc.MoveTo:create(1,cc.p(self.starStartX + self.loadBarW,self.star:getPositionY())))
        else
            isCheckFinish1 = true
            isCheckFinish = isCheckFinish1 and isCheckFinish2
            -- 热更新检测结束，检测服务器状态
            if isCheckFinish2 == nil then
                -- 如果先拉到服务器列表并且服务器维护中，那么检测完热更新弹出服务器维护中
                global.tipsMgr:showQuitConfirmPanel(false,"UIMaintancePanel")
            end
        end        
    end,function(code)
        
        if code == 1 then
            if not global.netRpc:checkClientNetWithError() then
            else
                global.tipsMgr:showQuitConfirmPanelNoClientNet()
            end
        elseif code == 10002 or code == 10001 then
            -- 弹出热更
            self:changeLoading(0)
            self:unschedule(oneTimerFunction)
            self:unschedule(twoTimerFunction)
        end        
        -- global.tipsMgr:showWarningText("update error " .. code)
    end)

    self.m_updateControl = updateControl
    updateControl:startCheck()

    -- 拉取服务器列表
    local loginProcCall = function ()
        -- 服务器手动维护状态--》当状态-1时，增加时间显示
        local serData = global.ServerData:getServerDataBy()
        if serData and not global.ServerData:isSvrCanLogin(serData) then
            if isCheckFinish1 then
                global.tipsMgr:showQuitConfirmPanel(false,"UIMaintancePanel")
            end
            isCheckFinish2 = nil
            -- panel:setTime(serData.birthday)
            return
        end
        isCheckFinish2 = true
        isCheckFinish = isCheckFinish1 and isCheckFinish2
    end            

    global.isMemEnough = not global.funcGame:isOutofMem(900)

    global.sdkBridge:httpGetServerId(loginProcCall)

    currClock = datetime.now().secs
    self.m_updateControl:setDelegate(self)
    -- self:loadMapInfo()
end

function UIInputAccountPanel:changeLoading(per)
    if tolua.isnull(self.LoadingBar) then
        return
    end
    self.Percent = per
    self.LoadingBar:setPercent(per)
    self:updateStarStartX()
end

function UIInputAccountPanel:isOutofMem()
    
    if global.tools:isAndroid() then
        local lMemory       = gluaj.callGooglePayStaticMethod("get_memory",{},"()Ljava/lang/String;")
        lMemory        = math.floor(tonumber(string.sub(lMemory,0,-3))*1024)
        
        print("check l memtory " .. lMemory)

        if lMemory > (10 * 1024) then
            lMemory = lMemory / 1024
        end

        print("check l memtory after " .. lMemory)
        return lMemory < 350
    else
        return false
    end    
end

-- 加载完成, 进入游戏
function UIInputAccountPanel:loadFinished()
    self.star:setVisible(false)
    self.progress.send_login = 100
    self:updateLoadingBar()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function()
        -- body
        global.panelMgr:closePanel("UIInputAccountPanel")
        global.panelMgr:closePanel("UISelectNew")
        global.isCreating = nil

        global.panelMgr:openPanel("LoadingPanel")
        --TODO 根据资源量规划加载缓存 add by song
        global.resMgr:initCsbCache()
        resMgr:unloadLoadingTextures()
    end)))
    
end

-- 进入登录
function UIInputAccountPanel:loginStart()
    -- 获取服务区信息
    if not self.m_isLoginStart then 
        self.m_isLoginStart = true
        return 
    end
    self.progress.send_login = 0
    self:httpLogin()
end

function UIInputAccountPanel:httpLogin()
    -- local defaultAccount = cc.UserDefault:getInstance():getStringForKey("account") 
    -- global.userData:setAccount(defaultAccount)

    global.sdkBridge:loginCheck(function()
        -- 获取登录服务信息成功
        -- self.star:setVisible(false)
        if not tolua.isnull(self.progress_desc) then
            self.progress_desc:setString(global.luaCfg:get_local_string(10937))
        end

        if self.gameStart then 
            self:gameStart(true)
        end 
        
    end)
end

local isfinishGamestart = false
function UIInputAccountPanel:gameStart(loginCheckSuccessfully)

    if not global.sdkBridge.loginCallHandler and loginCheckSuccessfully then
        local loginProc = require "game.Login.LoginProc"
        loginProc.loginServerQuick()
    end
    if isfinishGamestart then
        gevent:call(global.gameEvent.EV_ON_LOGIN_DONE,isRelogin)  
        return
    end
    isfinishGamestart = true
    GLFCreateDebugPanel(global.scMgr:CurScene(), false)
    
end

----------------------------- 进入loading 登录模块 -----------------------------

function UIInputAccountPanel:updateLoadingBar()
    local dit = 0 
    for i, v in pairs(self.configdata) do
        dit = dit + self.progress[i] /100  * v
    end
    self.Percent =dit
    self.LoadingBar:setPercent(self.Percent)
    self:updateStarStartX()
end
function UIInputAccountPanel:updateStarStartX()
    self.star:setPositionX(self.starStartX + self.loadBarW *(self.Percent / 100))
end 


function UIInputAccountPanel:preloadUITextures()
end

function UIInputAccountPanel:loadDoneCall()
    local callBB = function()
        print( self.index," self.index")
    end
    print('-------------------->self.perResTotalNum')
    for i=1,self.perResTotalNum do
        if i <= self.perResTotalNum then
            local data = self.preResList[i]
            if data and (data.plist or data.png) then
                -- gdisplay.loadSpriteFrames( data.plist, data.png, handler(self, self.loadDoneCall))
                gdisplay.loadSpriteFrames( data.plist, data.png, function()
                    -- body
                    -- print("3333333333")
                    if not self.perResTotalNum then return end
                    self.index = self.index + 100/self.perResTotalNum
                    if (self.index+0.000000001) >= 100 then

                        global.startLoading = nil
                        self:cutLoadingBarToPer(100, nil)
                    else
                        self:cutLoadingBarToPer(self.index)
                    end
                end)
            else
                -- print("4544444")
            end
        end
    end
end

function UIInputAccountPanel:cutLoadingBarToPer( per, callBack )
    print(self.progress.load_res ,"self.progress.load_res",per,"per")
    local tempPer =  self.progress.load_res 
    if self.scheduleListenerLoad then 
        gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
        self.scheduleListenerLoad = nil
    end
    self.scheduleListenerLoad = gscheduler.scheduleGlobal(function()
        if tempPer >= per then
    -- print(self.progress.load_res ,"self.4444progress.load_res",per,"per")
            if self.scheduleListenerLoad then 
                gscheduler.unscheduleGlobal(self.scheduleListenerLoad)
                self.scheduleListenerLoad = nil
            end
            if per == 100 then
                --print("1 ->  self.LoadingBar:setPercent: "..self.LoadingBar:getPercent())
                self.progress.load_res = 100
                self:updateLoadingBar()
                
                self:gameStart()
            else
            end
            if callBack then callBack() end
            return
        end
        tempPer = tempPer + 1
        if tempPer <  per  then
            self.progress.load_res = tempPer
            self:updateLoadingBar()
        end
    end, 1/60)

end

-- function UIInputAccountPanel:reload(index)
--     -- body

--     gdisplay.loadSpriteFrames(_plist, "", handler(self, self.loadDoneCall))
-- end


function UIInputAccountPanel:onConfirmHandler(sender, eventType)
--     if eventType == ccui.TouchEventType.ended then
--         local accInput = self.text_name:getString()

--         local fullname = "test"..accInput
-- --        if #fullname < 8 or #fullname > 16 then
-- --            global.delayCallFunc(function( ... )
-- --                global.tipsMgr:showWarning(global.luaCfg:get_local_string(10912))
-- --            end, nil, 0.1)
-- --        else
--             cc.UserDefault:getInstance():setStringForKey(CUR_USER_KEY, accInput)
            
--             if self.callBack then
--                 self.callBack(fullname, "2015")
--             end    
--             global.panelMgr:closePanel("UIInputAccountPanel")
-- --        end
--     end
end

function UIInputAccountPanel:onFiretHandler(sender, eventType)
    -- self.battleScene = self.battleScene or nil
    -- if eventType == ccui.TouchEventType.ended then
    --     if self.battleScene == nil then            
    --         local stageId = tonumber(self.text_stage:getString())
    --         UIInputAccountPanel.STAGE_ID = stageId
    --         local scene = global.scMgr:gotoBattleScene()
    --         log.debug("===============> RunBattle %s", stageId)
    --         scene:RunBattle(true, stageId)
    --         self.battleScene = scene
    --     end
    -- end
end

function UIInputAccountPanel:setCallBack(callback)
    self.callBack = callback
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIInputAccountPanel:onAutoRepair(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")                

    panel:setData(11278,function()
        local patchPath = cc.FileUtils:getInstance():getWritablePath().."patch/";
        cc.FileUtils:getInstance():removeDirectory(patchPath) 
        cc.UserDefault:getInstance():setStringForKey("selectSever",nil)
        cc.UserDefault:getInstance():deleteValueForKey("selectSever")
        cc.UserDefault:getInstance():setStringForKey("kgame_plat_index",nil)
        cc.UserDefault:getInstance():deleteValueForKey("kgame_plat_index")
        global.funcGame.RestartGame()
    end)
end
--CALLBACKS_FUNCS_END

return UIInputAccountPanel

--endregion


local SceneManager = {
    packageRoot = "game",
    curScene    = nil,
    casheScene  = {},
}

local MAIN_SCENE = "MainScene"
local BATTLE_SCENE = "BattleScene"
local NEW_BATTLE_SCENE = "NewBattleScene"
local LOGIN_SCENE = "LoginScene"
local WORLD_SCENE = "WorldScene"

local sharedDirector         = cc.Director:getInstance()

function SceneManager:gotoMainScene(isTrans)
    return self:replaceScene(MAIN_SCENE,isTrans)
end

function SceneManager:gotoWorldScene()
    return self:replaceScene(WORLD_SCENE)
end

function SceneManager:getMainSceneCall()
    if self.m_SceneCall then self.m_SceneCall() end
end
function SceneManager:setMainSceneCall(call)
    self.m_SceneCall = call
end

local isChangeingScene = false

function SceneManager:setChangeState(s)
    isChangeingScene = s
end
function SceneManager:getChangeState()
    return isChangeingScene
end
function SceneManager:gotoMainSceneWithAnimation(callback)

    self:setChangeState(true)
    global.funcGame:printContentTime('start call scene manager goto main scene')

    local resMgr = global.resMgr                
    local uiMgr = global.uiMgr

    local widget = resMgr:createWidget("world/yun_new")
    local timelineAction = resMgr:createTimeline("world/yun_new")
    uiMgr:configUITree(widget)
    local isexitdone = false
    local isanimdone = false

    local donecall = function()
        -- body
        if global.tools:isIos() then
            local totalmem = CCNative:getTotalMemorySize()
            if totalmem and tonumber(totalmem) < 1300 then
                global.resMgr:unloadMemWarningTextures()
            end                
        end
        
        local mainScene = self:gotoMainScene()                 

        local widget = resMgr:createWidget("world/yun_new")
        widget:setLocalZOrder(30)
        mainScene:addChild(widget)
        mainScene.cloud = widget       


        uiMgr:configUITree(widget)
    end

    global.worldApi:exitWorld(function()
        isexitdone = true
        if isexitdone and isanimdone then
            donecall()
        end
    end)


    timelineAction:setLastFrameCallFunc(function()
        isanimdone = true
        if isexitdone and isanimdone then
            donecall()
        end
    end)

    timelineAction:play("animation0", false)
    widget:runAction(timelineAction)        
    widget:setVisible(false)
    widget:runAction(cc.Sequence:create(cc.DelayTime:create(1/60),cc.Show:create()))
    self:CurScene():addChild(widget,32)
    global.panelMgr:getPanel("UIWorldPanel"):changeScene()
end

function SceneManager:gotoWorldSceneWithAnimation(callback)

    --如果城池没有创建并且不处于废墟状态，则让玩家建成
    
    if global.cityData:getMainCityLevel() < 2 then
        global.tipsMgr:showWarning("NewGuide01")
        return
    end

    if global.userData:getWorldCityID() == 0 and global.userData:getCityState() ~= 3 then

        global.panelMgr:openPanel("UICreateCityPanel")
        return        
    end      

    if global.userData:getCityState() == 3 then

        global.panelMgr:openPanel("FireFinish")
        return
    end
    self:setChangeState(true)

    local endCall = function()
        
        local resMgr = global.resMgr
        local uiMgr = global.uiMgr
        local widget = resMgr:createWidget("world/yun_new")
        local timelineAction = resMgr:createTimeline("world/yun_new")
        
        timelineAction:setLastFrameCallFunc(function()
            if global.tools:isIos() then
                local totalmem = CCNative:getTotalMemorySize()
                if totalmem and tonumber(totalmem) < 1300 then
                    global.resMgr:unloadMemWarningTextures()
                end                
            end

            local worldScene = self:gotoWorldScene()     

            local widget = resMgr:createWidget("world/yun_new")
            widget:setLocalZOrder(30)
            worldScene:addChild(widget)
            worldScene.cloud = widget


            uiMgr:configUITree(widget)

            if callback then callback() end

        end)

        timelineAction:play("animation0", false)
        widget:runAction(timelineAction)
        widget:setVisible(false)
        widget:runAction(cc.Sequence:create(cc.DelayTime:create(1/60),cc.Show:create()))


        uiMgr:configUITree(widget)
  

        self:CurScene():addChild(widget,32)
        global.panelMgr:getPanel("UICityPanel"):changeScene()
    end

    endCall()
end

function SceneManager:gotoBattleScene()
    return self:replaceScene(BATTLE_SCENE)
end

function SceneManager:gotoNewBattleScene()
    return self:replaceScene(NEW_BATTLE_SCENE)
end

function SceneManager:getBattleScene()
    if self.curSceneName == BATTLE_SCENE then
        return self.curScene
    end
    return nil
end

function SceneManager:gotoLoginScene()
    return self:replaceScene(LOGIN_SCENE)
end

function SceneManager:replaceScene(sceneName, isFade)    
    self.curSceneName = sceneName
    local scene = self:newScene(sceneName)
    self.curScene = scene
    if isFade then
        gdisplay.replaceScene(scene, "FADEWHITE", 0.5, gdisplay.COLOR_WHITE)
    else
        gdisplay.replaceScene(scene)
    end
    if (sceneName == MAIN_SCENE) or (sceneName == WORLD_SCENE) then
        GLFCreateDebugPanel(scene, false)
    end
    self:androidReturnKeyListener()
    self:registerWholeTouchListener()
    self:registerWindowKeyListener()
    return scene
end

function SceneManager:pushScene(sceneName)  
    table.insert(self.casheScene,self.curSceneName)
    self.curSceneName = sceneName
    local scene = self:newScene(sceneName)
    self.curScene = scene
    sharedDirector:pushScene(scene)
    
    if (sceneName == MAIN_SCENE) or (sceneName == WORLD_SCENE) then
        GLFCreateDebugPanel(scene, false)
    end
    
    return scene
end

function SceneManager:popScene()  
    sharedDirector:popScene()
    self.curSceneName = table.remove(self.casheScene)    
    -- self.curScene = sharedDirector:getRunningScene()
    self.curScene = mainscene
    return self.curScene
end

-- 增加全局点击 滑动及监听 , 方便按钮回调 滑动 检测 --  global.isTouchMove
function SceneManager:registerWholeTouchListener()

    local panel = global.scMgr:CurScene()
    local ALLOW_MOVE_ERROR = 7.0/160.0
    panel.beganPos__ = cc.p(0,0)
    global.isMoved_ = false

    local convertDistanceFromPointToInch = function (pointDis)
        local glview = cc.Director:getInstance():getOpenGLView()
        local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
        return pointDis * factor / cc.Device:getDPI()
    end

    panel.onTouchBegan = function (touch, event)
        global.isMoved_ = false
        panel.beganPos__= touch:getLocation()
        if global.touchbeginCall_ then 
            global.touchbeginCall_(touch , event)
        end 
        return true
    end

    panel.onTouchMoved = function (touch, event)
        global.isMoved_ = true
        if convertDistanceFromPointToInch(cc.pGetDistance(panel.beganPos__  , touch:getLocation())) > ALLOW_MOVE_ERROR then
        end
    end

    panel.onTouchEnded = function (touch, event)
        if global.isMoved_ and convertDistanceFromPointToInch(cc.pGetDistance(panel.beganPos__ , touch:getLocation())) > ALLOW_MOVE_ERROR then
            global.isTouchMove = true 
        else
            global.isTouchMove = false
        end
    end

    local touchNode = cc.Node:create()
    panel:addChild(touchNode ,99998)
    panel.touchEventListener = cc.EventListenerTouchOneByOne:create()
    panel.touchEventListener:setSwallowTouches(false)
    panel.touchEventListener:registerScriptHandler(panel.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    panel.touchEventListener:registerScriptHandler(panel.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    panel.touchEventListener:registerScriptHandler(panel.onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(panel.touchEventListener, touchNode)

end

--增加点电脑键盘监听
function SceneManager:registerWindowKeyListener()

    if not global.tools or not global.tools:isWindows() then return end

    local layer = cc.Layer:create()
    -- print("增加点电脑键盘监听")
    --回调方法
    local function onrelease(code, event)
        if cmd[code] then 
            cmd[code]()
        end 
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher =layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,layer)
    global.scMgr:CurScene():addChild(layer,99997)

end

-- 增加安卓返回键处理
function SceneManager:androidReturnKeyListener()
    if not global.tools or not global.tools:isAndroid() then return end
    local layer = cc.Layer:create()
    print("返回键监听")
    --回调方法
    local function onrelease(code, event)
        log.trace("SceneManager:androidReturnKeyListener()--->code=%s",code)
        if code == cc.KeyCode.KEY_BACK then
            if (self:isMainScene() or self:isWorldScene()) and not global.guideMgr:isPlaying() then
                global.panelMgr:closePanelForAndroidBack()
            end
        elseif code == cc.KeyCode.KEY_HOME then
            -- cc.Director:getInstance():endToLua()
        end
    end
    --监听手机返回键
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher =layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,layer)
    global.scMgr:CurScene():addChild(layer,99999)
end

function SceneManager:newScene(sceneName, ...)
    local params = { ... }
    local scenePackageName = self.packageRoot .. ".Scene." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(params))
    return scene
end

function SceneManager:SetCurScene(scene)
    self.curScene = scene
end

function SceneManager:CurScene()
    return self.curScene
end

function SceneManager:SceneName()
    return self.curSceneName
end

function SceneManager:SetCurSceneName(sceneName)
    self.curSceneName = sceneName
end

function SceneManager:isMainScene()
    local sceneName = self:SceneName()
    local mainSceneName = MAIN_SCENE
    if sceneName == mainSceneName then
        return true
    else
        return false
    end
end

function SceneManager:isLoginScene()
    return self:SceneName() == LOGIN_SCENE
end

function SceneManager:isBattleScene()
    return self:SceneName() == BATTLE_SCENE
end

function SceneManager:isWorldScene()
    
    return self:SceneName() == WORLD_SCENE 
end

function SceneManager:isCurrScene(preName)
    
    return self:SceneName() == preName.."Scene" 
end

global.scMgr = SceneManager
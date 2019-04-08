
local datetime = require "datetime"
local pbpack   = require "pbpack" 

local loginProc = require "game.Login.LoginProc"

local gevent = gevent
local gameEvent = global.gameEvent

local LoginScene = {}
LoginScene = class("LoginScene", function() return gdisplay.newScene("LoginScene") end )
                        
function LoginScene:ctor() 
    self:InitBg()
end

function LoginScene:GetWidget()
    return self._widget
end

function LoginScene:OnLoginSdkTimeout()
    loginProc.Reset()
end

function LoginScene:OnLoginSdkSuccess()
    
end

function LoginScene:onEnter()
    local fileUtils = cc.FileUtils:getInstance()
    local filePath = fileUtils:getWritablePath() .. "config.db"
    if fileUtils:isFileExist(filePath) then
        os.remove(filePath)
    end
    
    gplatform.initEvents() 

    global.sdkBridge:buglyAddUserValue()

    global.panelMgr:destroyAllPanel()
    gdisplay.removeAllSpriteFrames()
    cc.Director:getInstance():purgeCachedData()
    ccs.ActionTimelineCache:getInstance():purge()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,handler(global.ClientStatusData,global.ClientStatusData.ClientResume))
    self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,handler(global.ClientStatusData,global.ClientStatusData.ClientPause))
    
    global.ServerData:init()
    global.ClientStatusData:init()

    -- 登录开始
    global.panelMgr:openPanel("UIInputAccountPanel"):setData()

    global.sdkBridge:app_pay_init()
end

function LoginScene:onExit()

    global.panelMgr:destroyPanel("UIInputAccountPanel")
    global.panelMgr:destroyPanel("UIRoleSelectPanel")

    self:removeAllChildren(true)
    self:removeAllEventListener()
end

function LoginScene:onExitTransitionStart()
end


function LoginScene:loadRes()
    -- 获取加载资源列表
    self.preResList = global.resMgr:preloadUITexturesByLoading()
    self.perResTotalNum = table.nums(self.preResList) 
    -- 开始加载
    self:loadDoneCall()
end

function LoginScene:loadDoneCall()
    for i=1,self.perResTotalNum do
        if i <= self.perResTotalNum then
            local data = self.preResList[i]
            if data and data.plist then
                -- gdisplay.loadSpriteFrames( data.plist, data.png, handler(self, self.loadDoneCall))
                gdisplay.loadSpriteFrames( data.plist, data.png, function()
                end)
            else
                -- print("4544444")
            end
        end
    end
end

return LoginScene


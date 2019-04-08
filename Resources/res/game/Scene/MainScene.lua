local MainScene = class("MainScene", function() return gdisplay.newScene("MainScene") end )

local define = global.define

local gameEvent = global.gameEvent
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local tipsMgr = global.tipsMgr

function MainScene:gotoMainCity(tips)
    self.goto = "mainCity"
    self.tips = tips  
end

function MainScene:gotoMainMap(tips)
    self.goto = "mainMap"
    self.tips = tips  
end

function MainScene:enterMap()
    self.goto = "mainMap"
end

function MainScene:onEnterTransitionFinish()
    panelMgr:getPanel("UICityPanel"):openCloud()
    global.m_firstIn = nil
end

function MainScene:onEnter()
    -- self:registerEvent()
    -- panelMgr:openPanel("UIMainTopBarPanel")
    -- panelMgr:openPanel("UIMainMenuPanel")
    
    gsound.playBgm("city_bg")

    gsound.playBgm("city_main_1",true,false,0)
    gsound.playBgm("city_main_2",true,false,0)

    if global.m_firstIn then
        panelMgr:openPanel("UICityPanel");
        
        global.commonApi:sendChangeSceneDt("0#"..g_profi:time_show())
    else

            
        if global.guideMgr:isPlaying() then
            global.uiMgr:addSceneModel(3,98789)
        end
        local finishcall = function()
            -- body
            global.commonApi:sendChangeSceneDt("2#"..g_profi:time_show())
        end
        global.resMgr:loadTextures("city",function()
            -- body
            panelMgr:openPanel("UICityPanel"):openCloud(finishcall)
        end,global.scMgr:CurScene())
    end

    global.ClientStatusData:init()
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,handler(global.ClientStatusData,global.ClientStatusData.ClientResume))
    self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,handler(global.ClientStatusData,global.ClientStatusData.ClientPause))
    global.PushConfigData:requestUpdateLocalDate()
    ----进入场景开始检测，太早了会有数据没有
    -- require("game.Data.MercenaryData").getInstance();
end

function MainScene:onExit()
    global.panelMgr:clearTextureAsyncQueue()
    self:unregisterEvent()
    panelMgr:destroyAllPanel()
    
    gsound.stopAllEffect()

    global.funcGame:printContentTime("load world")
end

function MainScene:registerEvent()
    self:registerUserEvent()
end

function MainScene:unregisterEvent()
    self:removeAllEventListener()    
end

function MainScene:registerUserEvent()
    local levelUpHandler = function()
        
    end

    self:addEventListener(gameEvent.EV_ON_LEVELUP, levelUpHandler)
end

-- construct
------------------------------------------------------
function MainScene:ctor()
    self.goto = "mainCity"
end

return MainScene

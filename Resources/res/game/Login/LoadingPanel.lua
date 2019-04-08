local global = global
local resMgr = global.resMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent
-- local pvpData = global.userData:GetPVPData()
local cast = tolua.cast
local uiMgr = global.uiMgr
local funcGame = global.funcGame
local luaCfg = global.luaCfg

local _M = {}
_M = class("LoadingPanel", function() return gdisplay.newWidget() end )

function _M:ctor()    
end

function _M:EnterMainScene()
    -- body
    panelMgr:destroyAllPanel()

    if global.scMgr:isLoginScene() then
        gsound.fadeOut(nil,2)
    end

    print("global.userData:getGuideStep()----》"..global.userData:getGuideStep())
    if global.userData:getGuideStep() >= 100 then

        global.m_firstIn = true
        global.scMgr:gotoMainScene(true):gotoMainCity()
    else

        --关键步数为0
        --如果没有引导过的话直接进入大地图播放开场

        global.scMgr:gotoWorldScene()
    end

    -- 静默加载公用资源
    print("######静默加载公用资源")
    local _,load2List = global.resMgr:preloadUITexturesByLoading()
    local needLoad = true
    if global.tools:isIos() then        
        local totalmem = CCNative:getTotalMemorySize()
        if totalmem and tonumber(totalmem) < 1300 then
            needLoad = false
        end   
    end
    if needLoad then
        if global.isMemEnough then
            local panelPlists = global.panelMgr:getloadBigMemoPlists()
            for k,v in pairs(panelPlists) do
                local data = {plist=k,png=k.gsub(k,".plist",".png")}
                table.insert(load2List,data)
            end
        end
        if load2List and #load2List > 0 then
            local doneCall = nil
            doneCall = function(idx)
                -- body
                if idx > #load2List then return end
                gdisplay.loadSpriteFrames( load2List[idx].plist, load2List[idx].png, function()
                    -- body
                    doneCall(idx+1)
                end)
            end
            doneCall(1)
        end
    end
end

function _M:LoadingRes()
end

function _M:onEnter()
    self:EnterMainScene()
end

function _M:onExit()
    self:unscheduleAll()
end

return _M
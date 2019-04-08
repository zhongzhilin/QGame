--region WorldWeatherMgr.lua
--Author : wuwx

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData
local panelMgr = global.panelMgr

local WorldWeatherMgr  = class("WorldWeatherMgr", function() return gdisplay.newWidget() end )

local g_worldview = nil

function WorldWeatherMgr:ctor()
end

function WorldWeatherMgr:onEnter()
    
    g_worldview = global.g_worldview
    self.rainRootNode = g_worldview.worldPanel.mapPanel.rainNode
    self.sunshine  = g_worldview.worldPanel.sunshine
    self.part_node = g_worldview.worldPanel.part_node

    self.timeline = g_worldview.worldPanel.nodeTimeLine
    self.weachers = luaCfg:weather()
    self:changeWeather()

end

function WorldWeatherMgr:onExit()
    
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function WorldWeatherMgr:closeAllWeacher()

    if not tolua.isnull(self.rainNode) then
        self:fadeOut(self.rainNode)
    end
    if not tolua.isnull(self.snowNode) then
        self:fadeOut(self.snowNode)
    end
    if not tolua.isnull(self.sunshineNode) then
        self.sunshineNode:setVisible(false)
    end

    self.rainRootNode:setVisible(false)

    gsound.stopEffect("world_snow")
    gsound.stopEffect("world_rain")

    self.timeline:gotoFrameAndPause(1)
end


function WorldWeatherMgr:fadeIn(node)

    if self.currWeatherkey and self.currWeatherkey == self.lastWeatherkey then
        return
    end

    if tolua.type(node) == "cc.ParticleSystemQuad" then
        node:setVisible(true)
        node:resetSystem()
        local originEmission = node:getEmissionRate()
        node:setEmissionRate(originEmission*0.3)
        node:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
            -- body
            node:setEmissionRate(originEmission)
        end)))
    else
        node:runAction(cc.Sequence:create(cc.Show:create(),cc.FadeIn:create(0.8)))
    end
end

function WorldWeatherMgr:fadeOut(node)
    if self.currWeatherkey and self.currWeatherkey == self.lastWeatherkey then
        return
    end

    if tolua.type(node) == "cc.ParticleSystemQuad" then
        node:stopSystem()
        if not tolua.isnull(node) then
            node:removeFromParent()
        end
    else
        if node and node:isVisible() then
            node:runAction(cc.Sequence:create(cc.FadeOut:create(0.8),cc.Hide:create(), cc.CallFunc:create(function ()
                if not tolua.isnull(node) then
                    node:removeFromParent()
                end
            end)))
        end
    end
end


function WorldWeatherMgr:changeWeather()
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)        
    end

    local weacherTime = math.random(self.weachers[1].minTime,self.weachers[1].maxTime)
    if self.currWeatherData then
    end
    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        
        self:changeWeather()
    end, weacherTime)

    if self.currWeatherkey == "playNormal" and self.lastWeatherkey and self.lastWeatherkey ~= "playNormal" then
        -- print("############curr weather="..self.lastWeatherkey)
        self:closeAllWeacher()
        self[self.lastWeatherkey](self)
        self.currWeatherkey = self.lastWeatherkey
        return
    end


    local weatherIndex = math.random(#self.weachers)

    if global.userData:getGuideStep() < 200 then
        weatherIndex = 2
    end

    local weatherData = self.weachers[weatherIndex]
    local key = "play"..weatherData.weather
    self.currWeatherData = weatherData
    self.currWeatherkey = key
    if self.lastWeatherkey and self.lastWeatherkey ~= key then
        self:closeAllWeacher()
        self:playNormal()
    else
        print("############curr weather="..key)
        self:closeAllWeacher()
        self[key](self)
    end
    self.lastWeatherkey = key
    self.lastWeatherData = weatherData
end

function WorldWeatherMgr:playNormal()
    self.currWeatherkey = "playNormal"
end

function WorldWeatherMgr:playSunshine()

    if tolua.isnull(self.sunshineNode) then
        local sunshineNode = resMgr:createCsbAction("effect/bigworld_env","animation0",true)
        self.sunshine:addChild(sunshineNode)
        self.sunshineNode = sunshineNode
    end
    self.sunshineNode:setVisible(true)
end

function WorldWeatherMgr:playRain()

    if tolua.isnull(self.rainNode) then
        local rain = cc.ParticleSystemQuad:create("effect/bigworld_rain.plist") 
        rain:setRotationSkewX(-17)
        rain:setRotationSkewY(-7)
        rain:setPosition(cc.p(175, 1100))
        rain:setScaleX(1)
        rain:setScaleY(1)
        self.part_node:addChild(rain)
        self.rainNode = rain
    end

    self:fadeIn(self.rainNode)
    self.rainRootNode:setVisible(true)
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_rain")

end


function WorldWeatherMgr:playSnow()

    if tolua.isnull(self.snowNode) then
        local node = resMgr:createCsbAction("effect/city_snow","animation0",true)
        self.part_node:addChild(node)
        self.snowNode = node
    end

    self:fadeIn(self.snowNode)
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_snow")
    self.timeline:play("animation0",true)

end

return WorldWeatherMgr

--endregion

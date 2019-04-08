--region CityWeatherMgr.lua
--Author : wuwx

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData
local panelMgr = global.panelMgr

local CityWeatherMgr  = class("CityWeatherMgr", function() return gdisplay.newWidget() end )

function CityWeatherMgr:ctor()
    self.cityView = global.g_cityView
    self.m_operateNode = nil
end

function CityWeatherMgr:onEnter()
    self.cityView.containerNode.weather:setVisible(false)
    self.cityView.sunshine:setVisible(false)

    self.weachers = luaCfg:weather()
    self:changeWeather()
end

function CityWeatherMgr:onExit()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

function CityWeatherMgr:closeAllWeacher()
    self:fadeOut(self.cityView.containerNode.weather)
    self:fadeOut(self.cityView.rain_par)
    self:fadeOut(self.cityView.sunshine)
    -- self.cityView.sunshine:setVisible(false)
    self:fadeOut(self.cityView.rain_effect)
    self:fadeOut(self.cityView.snow_effect)
    self:fadeOut(self.cityView.m_city_weather_rainwaver)
    self:fadeOut(self.cityView.snow_par)
    self.cityView:removeRain()

    gsound.stopBgm("scene_sun")
    gsound.stopBgm("scene_rain")
    gsound.stopBgm("scene_snow")
end


function CityWeatherMgr:fadeIn(node)
    if not node or tolua.isnull(node) then return end
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
        node:setVisible(true)

        if node.timeLine then node.timeLine:resume() end
    end
end

function CityWeatherMgr:fadeOut(node)
    if not node or tolua.isnull(node) then return end
    if self.currWeatherkey and self.currWeatherkey == self.lastWeatherkey then
        return
    end

    if tolua.type(node) == "cc.ParticleSystemQuad" then
        node:stopSystem()
    else
        if node and node:isVisible() then
            node:setVisible(false)
            if node.timeLine then node.timeLine:pause() end
        end
    end
end


function CityWeatherMgr:changeWeather()
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
    local weatherData = self.weachers[math.random(#self.weachers)]
    local key = "play"..weatherData.weather
    self.currWeatherData = weatherData
    self.currWeatherkey = key
    if self.lastWeatherkey and self.lastWeatherkey ~= key then
        self:closeAllWeacher()
        self:playNormal()
    else
        -- print("############curr weather="..key)
        self:closeAllWeacher()
        self[key](self)
    end
    self.lastWeatherkey = key
    self.lastWeatherData = weatherData
end

function CityWeatherMgr:playNormal()
    self.currWeatherkey = "playNormal"
    self.cityView:setBirdEnvSounds(true)

    if not tolua.isnull(self.cityView.rain_par) then
        self.cityView.rain_par:getParent():removeFromParent()
    end

    if not tolua.isnull(self.cityView.snow_par) then
        self.cityView.snow_par:getParent():removeFromParent()
    end
end

function CityWeatherMgr:playSunshine()
    self:fadeIn(self.cityView.sunshine)
    -- self.cityView.sunshine:setVisible(true)

    gevent:call(gsound.EV_ON_PLAYSOUND,"scene_sun")
    self.cityView:setBirdEnvSounds(true)
end

function CityWeatherMgr:playRain()
    if tolua.isnull(self.cityView.rain_par) then
        global.g_cityView:createRain()
    end
    global.g_cityView:updateRain()
    self:fadeIn(self.cityView.rain_par)
    self:fadeIn(self.cityView.rain_effect)
    self:fadeIn(self.cityView.m_city_weather_rainwaver)
    self:fadeIn(self.cityView.containerNode.weather)

    gevent:call(gsound.EV_ON_PLAYSOUND,"scene_rain")
    self.cityView:setBirdEnvSounds(false)
end


function CityWeatherMgr:playSnow()
    if tolua.isnull(self.cityView.snow_par) then
        global.g_cityView:createSnow()
    end
    self:fadeIn(self.cityView.snow_par)
    
    self:fadeIn(self.cityView.snow_effect)
    gevent:call(gsound.EV_ON_PLAYSOUND,"scene_snow")
    self.cityView:setBirdEnvSounds(false)
end

return CityWeatherMgr

--endregion


local WorldScene = class("WorldScene", function() return gdisplay.newScene("WorldScene") end )

local gameEvent = global.gameEvent
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local tipsMgr = global.tipsMgr

function WorldScene:onEnter()
    
	-- print(">>>>function WorldScene:onEnter()")	

    global.resMgr:loadTextures("world",function()
        -- body
		self:init()   
    end,global.scMgr:CurScene())

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,handler(global.ClientStatusData,global.ClientStatusData.ClientResume))
    self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,handler(global.ClientStatusData,global.ClientStatusData.ClientPause))
end

function WorldScene:onExit()
    
    global.g_worldview.lineViewMgr:cleanAll()
	global.panelMgr:destroyAllPanel()
	global.g_worldview.attackMgr:closeSchedule()	
	-- global.guideMgr:stop()
	gsound:stopAllEffect()
	gsound:clearAll()
	global.g_worldview.isInit = false
end

function WorldScene:ctor()
    
	-- print(">>>function WorldScene:ctor()")
end

function WorldScene:setEnterCallBack(call)
	
	self.enterCall = call
end

function WorldScene:setLoadDoneCallBack(call)
	
	self.loadCall = call
end

function WorldScene:setIsGPS()
	
	self.isGPS = true
end

function WorldScene:init()

	local worldView = {}
	global.g_worldview = worldView

	worldView.isStory = global.userData:getGuideStep() < 100
		
	if worldView.isStory then

		gsound.playBgm("Start_bg")
	else

		gsound.playBgm("world_bg")
	end    

	worldView.const = require("game.UI.world.utils.WorldConst")
	-- worldView.flogMgr= require("game.UI.world.mgr.FlogMgr").new()
	worldView.attackMgr = require("game.UI.world.mgr.AttackMgr").new()
	worldView.lineViewMgr = require("game.UI.world.mgr.LineViewMgr").new()
	worldView.mapInfo = require("game.UI.world.data.MapInfo").new()
	worldView.areaDataMgr = require("game.UI.world.mgr.AreaDataMgr").new()
	worldView.worldCityMgr = require("game.UI.world.mgr.WorldCityMgr").new()	
	worldView.worldPanel = panelMgr:openPanel("UIWorldPanel")
	if not (cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone", false)) then
		global.delayCallFunc(function()
			worldView.weatherMgr = require("game.UI.world.mgr.WorldWeatherMgr").new()
			worldView.worldPanel:addChild(worldView.weatherMgr)	
		end,nil,0)
	end
	worldView.isInit = true

	worldView.worldPanel:setEnterCallBack(self.enterCall)
	worldView.worldPanel:setLoadDoneCallBack(self.loadCall)
	worldView.worldPanel.isGPS = self.isGPS

	self.loadCall = nil
	self.isGPS = nil

	global.commonApi:sendChangeSceneDt("1#"..g_profi:time_show())
end

return WorldScene

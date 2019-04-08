--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local Player = class("Player")

local coreAnalyze  =require("game.UI.replay.excute.coreAnalyze")

global.gameEvent.EV_ON_UI_REPLAY_FINISH = "EV_ON_UI_REPLAY_FINISH"

function Player:init(data)

	self.coreAnalyze = coreAnalyze.new()
	self.coreAnalyze:start(data)
end

function Player:prepare(data)

	self:init(data)
end 


function Player:next()

	self.coreAnalyze:decode_next()

end

function Player:finish()

	gevent:call(global.gameEvent.EV_ON_UI_REPLAY_FINISH)
end 

function Player.getInstance()
	if not global.Player then 
		global.Player=Player.new()
	end 

	return global.Player
end 


function Player:getCoreAnalyze()

	return self.coreAnalyze
end 


function Player:stop()
	
	-- self.coreAnalyze:reStart()
	gevent:call(global.gameEvent.EV_ON_UI_REPLAY_CLEANWIDGET)
end 

function Player:pause()

	gevent:call(global.gameEvent.EV_ON_UI_REPLAY_PAUSE)
end


function Player:skip(Percent)

	gevent:call(global.gameEvent.EV_ON_UI_PLAYBESKIP)

	self.coreAnalyze:skip(Percent , function ()

		gevent:call(global.gameEvent.EV_ON_UI_PLAYSKIP)

	end)
end 

function Player:resume()

	gevent:call(global.gameEvent.EV_ON_UI_REPLAY_RESUME)
end

function Player:start()

    gevent:call(global.gameEvent.EV_ON_UI_PREPARE)
end 

function Player:speed()

	coreAnalyze:speed()
end 

function Player:unspeed()

	coreAnalyze:unspeed()
end 

return Player

-- global.gameEvent.EV_ON_UI_REPLAY_START
-- global.gameEvent.EV_ON_UI_REPLAY_STOP
-- global.gameEvent.EV_ON_UI_REPLAY_PAUSR
-- global.gameEvent.EV_ON_UI_REPLAY_RESUME
-- global.gameEvent.EV_ON_UI_REPLAY_SPEED
-- global.gameEvent.EV_ON_UI_REPLAY_UNSPEED
-- global.gameEvent.EV_ON_UI_REPLAY_FIGHT

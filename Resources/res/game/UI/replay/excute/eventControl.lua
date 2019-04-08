--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
 
local eventControl = class("eventControl" ,function() return gdisplay.newWidget() end)


local Player  =require("game.UI.replay.excute.Player")

function eventControl:ctor(root)

end

-- global.gameEvent.EV_ON_UI_REPLAY_START  开始
-- global.gameEvent.EV_ON_UI_REPLAY_STOP	 停止
-- global.gameEvent.EV_ON_UI_REPLAY_PAUSR  暂停
-- global.gameEvent.EV_ON_UI_REPLAY_RESUME 继续
-- global.gameEvent.EV_ON_UI_REPLAY_SPEED  加速
-- global.gameEvent.EV_ON_UI_REPLAY_UNSPEED  减速
-- global.gameEvent.EV_ON_UI_REPLAY_FIGHT 战斗
-- global.gameEvent.EV_ON_UI_CLeanWidget战斗

--战斗EVENT
--global.gameEvent.EV_ON_UI_INITHERO
--global.gameEvent.EV_ON_UI_SHOWTITLE

function eventControl:setData(root)
	
	self.root = root
	self:initEventListener()

	self:initRewrite()

 	self.Player = Player.getInstance()
end


function eventControl:initEventListener()

  	self.root:addChild(self)

	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_STOP,function()
    	if self.stop then 
     		self:stop()
    	end 
  	end)

	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_SPEED,function()
    	if self.pause then 
   			self:pause()
    	end 
  	end)

  	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_PAUSE,function()
     	if self.speed then 
        	self:speed()
      	end 
  	end)

	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_UNSPEED,function()
    	if self.unspeed then 
      		self:unspeed()
    	end 
  	end)

	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_RESUME,function()
	if self.resume then 
  		self:resume()
    	end 
  	end)


	self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_CLEANWIDGET,function()
   		if self.cleanwidget then 
    		self:cleanwidget()
   		end 
	end)

	self:addEventListener(global.gameEvent.EV_ON_UI_SHOWHERO,function()
      if self.inithero then 
        self:inithero()
      end 
    end)

	self:addEventListener(global.gameEvent.EV_ON_UI_SHOWTITLE,function()
    	if self.showtitle then 
    		self:showtitle()
    	end 
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_PREPAREED,function()
    	if self.prepareed then 
    		self:prepareed()
    	end
    end)

	self:addEventListener(global.gameEvent.EV_ON_UI_SHOWSOLDIERED,function()
     	if self.showsoldiered then 
    		self:showsoldiered()
    	end
    end)

  self:addEventListener(global.gameEvent.EV_ON_UI_FIGHTEND,function()
	 	   if self.fighted then 
          self:fighted()
       end 
    end)
end



function eventControl:fighted()

    gevent:call(global.gameEvent.EV_ON_UI_SHOWRESULT)

end 

function eventControl:prepareed()

	gevent:call(global.gameEvent.EV_ON_UI_REPLAY_START)
end 

function eventControl:showsoldiered()
	gevent:call(global.gameEvent.EV_ON_UI_SHOWPK)
end 

function eventControl:showtitleed()
	gevent:call(global.gameEvent.EV_ON_UI_SHOWSOLDIER)
end 

 

 function eventControl:initRewrite()

end 

return eventControl

--endregion

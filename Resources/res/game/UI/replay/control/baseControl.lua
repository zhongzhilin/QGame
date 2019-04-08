--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
 
local baseControl = class("baseControl" , function() return gdisplay.newWidget() end)

local soldier  =require("game.UI.replay.mode.soldier")
local hero  =require("game.UI.replay.mode.hero")
local troop  =require("game.UI.replay.mode.troop")
local war  =require("game.UI.replay.mode.war")


local Player  =require("game.UI.replay.excute.Player")

local actionManger  =require("game.UI.replay.excute.actionManger")

function baseControl:ctor(root)

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
--global.gameEvent.EV_ON_UI_SHOWTITLEED


function baseControl:initEventListener()

  self.root:addChild(self)

  self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_START,function()
   	if self.start then 
      self:start()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_STOP,function()
    if self.stop then 
      self:stop()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_SPEED,function()
    if self.speed then 
    		self:speed()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_PAUSE,function()

    print("收到暂停通知。。。。。。。。。")
    if self.pause then 
      self:pause()
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
    if self.showhero then 
      self:showhero()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_SHOWTITLE,function()
    if self.showtitle then 
      self:showtitle()
    end 
  end)


  self:addEventListener(global.gameEvent.EV_ON_UI_SHOWSOLDIER,function()
    if self.showsoldier then 
      self:showsoldier()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_SHOWPK,function()
    if self.showpk then 
      self:showpk()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_SHOWATTACK,function()
    if self.showattack then 
      self:showattack()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_PREPARE,function()
    if self.prepare then 
      self:prepare()
    end 
  end)

  self:addEventListener(global.gameEvent.EV_ON_UI_SHOWRESULT,function()
    if self.showresult then 
      self:showresult()
    end 
  end)


  self:addEventListener(global.gameEvent.EV_ON_UI_PLAYSKIP,function()
      if self.skip then 
        self:skip()
      end 
  end)


  self:addEventListener(global.gameEvent.EV_ON_UI_PLAYBESKIP,function()
      if self.beskip then 
        self:beskip()
      end 
  end)


end


function baseControl:setData(root)

  self.root = root

	self:initEventListener()

  self.WidgetTable = {}

  global.actionTable = global.actionTable or {}

  self.actionTable = global.actionTable 
 
  self.Player = Player.getInstance()

  self.coreAnalyze =Player.getInstance():getCoreAnalyze()

  self.view = self.root 

  self.actionManger = actionManger.getInstance()

  -- self.eventControl  = eventControl
  self:initRewrite()
end


function baseControl:cleanwidget()
  if self.WidgetTable  then 
    for _ ,v in pairs(self.WidgetTable) do 
      v:removeFromParent()
    end 
     self.WidgetTable = {}
  end 
end 


function baseControl:initRewrite()

end 

return baseControl

--endregion

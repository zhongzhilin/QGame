--region UISilder.lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISilder  = class("UISilder", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")
local Player  =require("game.UI.replay.excute.Player")



local speed = {[1] = {1,1} , [2] = {2 ,1.7} ,[3] =  {3, 2.5} }   

function UISilder:ctor()
    -- self:CreateUI()
end

function UISilder:CreateUI()
    local root = resMgr:createWidget("player/node/silder")
    self:initUI(root)
end

function UISilder:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/silder")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.colorSilderBlue = self.root.Node_2.colorSilderBlue_export
    self.colorSilderGreen = self.root.Node_2.colorSilderGreen_export
    self.colorSilderOrange = self.root.Node_2.colorSilderOrange_export
    self.Slider = self.root.Node_2.Slider_export
    self.round = self.root.round_export
    self.resume = self.root.resume_export
    self.pause = self.root.pause_export
    self.speee = self.root.speee_export

    uiMgr:addWidgetTouchHandler(self.Slider, function(sender, eventType) self:skip(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.resume, function(sender, eventType) self:repaly_resume(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.pause, function(sender, eventType) self:repaly_pause(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_6, function(sender, eventType) self:onSpeedClick(sender, eventType) end)
--EXPORT_NODE_END

    self.Slider:addEventListener(handler(self, self.sliderChange))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISilder:onEnter()

    self.switch = "OFF"

    self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_RESUME,function()

        self.switch = "ON"

        self.Slider:setTouchEnabled(true)
    end)
    
    self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_PAUSE,function()

        self.switch = "OFF"

        self.Slider:setTouchEnabled(false)

    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_START,function()

        self.switch = "ON"

        self.Slider:setTouchEnabled(true)       
        self.Slider:setTouchEnabled(true)

        self.resume:setTouchEnabled(true)
        self.pause:setTouchEnabled(true)  

    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_REPLAY_FINISH,function()

         self.Slider:setPercent(100)

        self.Slider:setTouchEnabled(false)
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_PLAYBESKIP,function()
        
         self.Slider:setTouchEnabled(false)
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_PLAYSKIP,function()

         self.Slider:setTouchEnabled(true)
     end)


    self:addEventListener(global.gameEvent.EV_ON_UI_PREPARE,function()

        self.Slider:setTouchEnabled(false)       
        self.Slider:setTouchEnabled(false)

        self.resume:setTouchEnabled(false)
        self.pause:setTouchEnabled(false)   
    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_PREPARE,function()
        
        self.Slider:setTouchEnabled(false)       
        self.Slider:setTouchEnabled(false)

        self.resume:setTouchEnabled(false)
        self.pause:setTouchEnabled(false)   

        self:setColorSilder()

    end)



    self.all_round = Player.getInstance():getCoreAnalyze():get_all_round() 


    self.speed = 1 

    gscheduler.sharedScheduler:setTimeScale(speed[self.speed][2])
    
    self.speee:setString("X"..speed[self.speed][1])

    self.silder_order = { self.colorSilderBlue , self.colorSilderOrange , self.colorSilderGreen } 


    for _ ,v in pairs(self.silder_order)  do 
        v:setVisible(false)
    end 

end 

local part_x = 1 

--  "uisilder  ,  `progressv  ...." = {
-- [LUA-print] -     "1" = {
-- [LUA-print] -         "progress" = 0.125
-- [LUA-print] -         "ps"       = 1
-- [LUA-print] -     }
-- [LUA-print] -     "3" = {
-- [LUA-print] -         "progress" = 0.875
-- [LUA-print] -         "ps"       = 3
-- [LUA-print] -     }
-- [LUA-print] - }

function UISilder:setColorSilder()
    
    local  coreAnalyze = Player.getInstance():getCoreAnalyze()

    local  progress =  coreAnalyze:getProgress()

    local all_round = coreAnalyze:get_all_round()

    dump(progress,"fucprogressk////176")

    local silder_width =  self.Slider:getContentSize().width 

    if progress then 

 
        for key , v  in pairs(progress) do 

            self.silder_order[tonumber(key)]:setVisible(true)

            local  silder_size =  self.silder_order[tonumber(key)]:getContentSize()

            self.silder_order[tonumber(key)]:setContentSize(cc.size(v.progress * silder_width - part_x,  silder_size.height))

            local x = v.ps / all_round * silder_width

            self.silder_order[tonumber(key)]:setPositionX(x)
        end 
        
    else 
        -- global.tipsMgr:showWarning("UISilder error  160")

        self.silder_order[1]:setVisible(true)
        self.silder_order[1]:setPositionX(0)
        self.silder_order[1]:setContentSize(cc.size( silder_width,   self.silder_order[1]:getContentSize().height))

    end 
end 

function UISilder:sliderChange(pSender)
 
     if self.switch  == "OFF" then return end 

    local str =global.luaCfg:get_local_string(10738)
    
    local pen = self.Slider:getPercent() 

    local skip_round = math.floor((self.all_round) * pen/100)

    self.round:setString(string.format(str, skip_round))
end 

function UISilder:updateProgress(updateProgress)

    self.Slider:setPercent(updateProgress)

end 


function UISilder:setData(data) 

    self.data = data 

    local str =global.luaCfg:get_local_string(10738)

	self.round:setString(string.format(str, data))

end 


function UISilder:skip(sender, eventType)


    print(eventType,"eventType///////////")

    if  eventType == 2 then

        local pen = self.Slider:getPercent() 
        Player.getInstance():skip(pen)
    end

end


function UISilder:showResumeButton()

     self.resume:setVisible(true)
     self.pause:setVisible(false)
end 


function UISilder:hideResumeButton()
    
     self.resume:setVisible(false)
     self.pause:setVisible(true)
end 




function UISilder:repaly_pause(sender, eventType)
    Player.getInstance():pause()
end


function UISilder:repaly_resume(sender, eventType)
    Player.getInstance():resume()
end

-- function debugPanel:onReduceSpeed()
--     local i_timeScale = gscheduler.sharedScheduler:getTimeScale()
--     i_timeScale = i_timeScale/2
--     gscheduler.sharedScheduler:setTimeScale(i_timeScale)
-- end
-- --常速
-- function debugPanel:onNormalSpeed()
--     gscheduler.sharedScheduler:setTimeScale(1)
-- end
-- --加速
-- function debugPanel:onAcceSpeed()
--     local i_timeScale = gscheduler.sharedScheduler:getTimeScale()
--     i_timeScale = i_timeScale*2
--     gscheduler.sharedScheduler:setTimeScale(i_timeScale)
-- end

function UISilder:onSpeedClick(sender, eventType)

    self.speed = self.speed + 1 

    if self.speed > #speed then 

        self.speed = 1 

    end 

    gscheduler.sharedScheduler:setTimeScale(speed[self.speed][2])
    
    self.speee:setString("X"..speed[self.speed][1])
end
--CALLBACKS_FUNCS_END

return UISilder

--endregion

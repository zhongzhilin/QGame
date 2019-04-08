
--region UITaskJumpBoard.lua
--Author : untory
--Date   : 2016/08/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local taskData = global.taskData
local luaCfg = global.luaCfg

local gameEvent = global.gameEvent
local gevent = gevent
local UITaskRewardSprite = require("game.UI.mission.UITaskRewardSprite")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITaskJumpBoard  = class("UITaskJumpBoard", function() return gdisplay.newWidget() end )

function UITaskJumpBoard:CreateUI()
    local root = resMgr:createWidget("task/task_city")
    self:initUI(root)
end

function UITaskJumpBoard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_city")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Text_2 = self.root.task_node.Text_2_export
    self.get_reward = self.root.task_node.get_reward_mlan_5_export
    self.btn_task_reward = self.root.btn_task_reward_export
    self.red = self.root.red_export
    self.Text = self.root.red_export.Text_export
    self.hand = self.root.hand_export

    uiMgr:addWidgetTouchHandler(self.root.task_node, function(sender, eventType) self:jump_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_task, function(sender, eventType) self:onClickTaskHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_task_reward, function(sender, eventType) self:onClickTaskHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.red:setVisible(false)
    
    self.btn_task = self.root.btn_task


end

function UITaskJumpBoard:checkHand()
    
    if not global.scMgr:isMainScene() then
        self.hand:setVisible(false) 
        return
    end

    local targetId = global.luaCfg:get_config_by(1).guideTargetOver
    if global.funcGame:checkTarget(targetId) then
        
        self.hand:setVisible(false)         
    elseif global.guideMgr:isPlaying() then

        self.hand:setVisible(false) 
    else

        self.hand:setVisible(true)

        local taskCfg = self.data
        if not taskCfg then return end
        if taskCfg.location == 2 or taskCfg.location == 1 then
     
            if global.g_cityView and global.g_cityView.getPlusFreeBuilder and global.g_cityView:getPlusFreeBuilder() then

                self.hand:setVisible(true)
            else
                
                self.hand:setVisible(false)
            end            
        elseif taskCfg.location == 3 then
            
            local build = global.g_cityView.touchMgr:getBuildingNodeByType(taskCfg.taskTarget)
            if build then

                if build:getBtnState() == "SLEEP" then

                    self.hand:setVisible(true)
                else

                    self.hand:setVisible(false)
                end                            
            else

                self.hand:setVisible(false)
            end           
        else

            self.hand:setVisible(true)
        end
        -- dump(mainTaskData,"mainTaskData")
    end
end

function UITaskJumpBoard:hideHand()
    
    self.hand:setVisible(false)
    self:stopAllActions()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(10),cc.CallFunc:create(function()
        self:checkHand()                
    end)))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITaskJumpBoard:jump_call(sender, eventType)
	
    if self.msg.state == 1 then

        self:doReward()
    else

        global.taskApi:checkTask(function(msg)

            local data = msg.tagBaseTask 

            if data and #data == 2 then -- mean this is a compelete
        
                local nextMission = data[2]               
                global.taskData:updateCurrentMainTask({sort = 1,id = nextMission.lID,state = nextMission.lState,progress = nextMission.lProgress}) 
            end
        end)

        self:hideHand()    
   
        -- print()
        global.funcGame.handleQuickTask(self.taskGPSType,self.taskBuildType,self.data.taskTargetlevel)
    end    
end

function UITaskJumpBoard:doReward()
    
    if global.scMgr:isMainScene() then
        global._isUpdateByTask = true
    end
    
    global.taskApi:taskGetGift(self.msg.id,function(msg)

        if not msg then return end
        if not msg.tgNext then return end

        local mainTaskData = {sort = 1,id = msg.tgNext.lID,progress = msg.tgNext.lProgress,state = msg.tgNext.lState}
        local str = taskData.getGiftInfo(msg.tgItem or {})
        if str == "" then

            str = vardump(msg.tgItem)
        end

        -- global.tipsMgr:showTaskTips(str)
        taskData:flushMainTask(mainTaskData)
        taskData:checkCurrentTaskNeedFlush(mainTaskData)        

        if not tolua.isnull(self.nodeTimeLine) then 
            self.nodeTimeLine:play("animation0",false)
        end 

        if not tolua.isnull(self.get_reward) then  --protect 
            self.get_reward:setVisible(false)
        end 

        if self.playEffect then --protect 
            self:playEffect(msg.tgItem)
        end 

        -- uiMgr:addSceneModel(1)

        global.delayCallFunc(function()
            gevent:call(global.gameEvent.EV_ON_TASK_COMPELETE)
            gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)
        end,nil,1)
    end)
end

function UITaskJumpBoard:onClickTaskHandler(sender, eventType)
    
    -- self:hideHand()

    global.panelMgr:openPanel("TaskPanel")
end
--CALLBACKS_FUNCS_END

function UITaskJumpBoard:setData()
    -- body

    local msg = taskData:getMainTask()
    self.msg = msg or {}

    local data = luaCfg:get_main_task_by(msg.id) or {}
    self.data = data

    self.taskBuildType = data.taskTarget
    self.taskGPSType = data.location
    self.data = data

    self.Text_2:setString(data.taskName)

    local isNeedShowRed,Count = taskData:isHaveNewGift()
    self.red:setVisible(isNeedShowRed)
    self.Text:setString(Count)    

    self.hand:setVisible(false)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
         self:checkHand()               
    end)))    

    -- msg.state == 1 mean this mission is can be get reward
    if self.msg.state == 1 then
        self.get_reward:setVisible(true)
        self.btn_task_reward:setVisible(true)
        self.btn_task:setVisible(false)
    else
        self.get_reward:setVisible(false)
        self.btn_task_reward:setVisible(false)
        self.btn_task:setVisible(true)
    end

    -- self.root.btn_task.Text_1_mlan:setString(" ================== ")
end 

function UITaskJumpBoard:checkPoint()
    
    local dailyNum = global.dailyTaskData:getFinishTask()
    local isNeedShowRed,Count = global.taskData:isHaveNewGift()
    local achCount = global.achieveData:getAcieveNum()
    local allCount = achCount + Count
    
    local opLv = global.luaCfg:get_config_by(1).dailyTaskLv
    if global.cityData:checkBuildLv(1, opLv) then
        allCount = allCount + dailyNum
    end

    self.red:setVisible(false)
    if allCount > 0 then
        self.red:setVisible(true)
        self.Text:setString(allCount)
    end

end

function UITaskJumpBoard:playEffect(items)
    
    local itemCountWidth = gdisplay.width / 2 - ((#items - 1) * 120) / 2 - 40

    for index,v in ipairs(items) do

        if v.lID < 6 then
        
            local reward = UITaskRewardSprite.new()
            self:addChild(reward)

            reward:setScale(0)
            reward:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.2,1)))

            reward:setPosition(cc.p((index - 1) * 120 + itemCountWidth,130))
            reward:setData(v)
        end        
    end    

    -- self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function()
    --     global.g_worldview.worldPanel.bot_ui:PlayBagEffect(0)
    -- end),cc.DelayTime:create(0.5),cc.CallFunc:create(function()
    --     global.g_worldview.worldPanel.bot_ui:PlayBagEffect(1)
    -- end))

    if global.scMgr:isWorldScene() and  global.g_worldview then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function()
            global.g_worldview.worldPanel.bot_ui:PlayBagEffect(0)
        end),cc.DelayTime:create(0.8),cc.CallFunc:create(function()
            global.g_worldview.worldPanel.bot_ui:PlayBagEffect(1)    
        end)))
    end    
end

function UITaskJumpBoard:onEnter()	

    self:setData()

    self.hand:stopAllActions()
    self.hand:runAction(cc.RepeatForever:create(cc.EaseInOut:create(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,20)),cc.MoveBy:create(0.5,cc.p(0,-20))),1)))

    self:addEventListener(global.gameEvent.EV_ON_TASK_COMPELETE,function()
        if self.checkPoint then
            self:setData()
            self:checkPoint()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_ACM_UPDATE, function()
        if self.checkPoint then
            self:checkPoint()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_DAILY_TASK_FLUSH, function()
        if self.checkPoint then
            self:checkPoint()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GUIDE_START, function()
        if self.hideHand then
            self:hideHand()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE, function()
        if self.checkHand then
            self:checkHand()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GUIDE_END, function()
       
        print("check hand") 
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
            if self.checkHand then
                self:checkHand()     
            end          
        end)))    
    end)


    self.nodeTimeLine = resMgr:createTimeline("task/task_city")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)
end

return UITaskJumpBoard

--endregion

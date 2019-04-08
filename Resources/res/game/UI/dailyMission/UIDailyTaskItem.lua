--region UIDailyTaskItem.lua
--Author : untory
--Date   : 2016/08/10
--generate by [ui_code_tool.py] automatically

local dailyTaskData = global.dailyTaskData
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
local gameEvent = global.gameEvent
local dataMgr = global.dataMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDailyTaskItem  = class("UIDailyTaskItem", function() return gdisplay.newWidget() end )

function UIDailyTaskItem:ctor()
  
 	self:CreateUI()  
end

function UIDailyTaskItem:CreateUI()
    local root = resMgr:createWidget("task/task_daily_unit")
    self:initUI(root)
end

function UIDailyTaskItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_unit")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Node_1_export
    self.rect_board = self.root.Node_1_export.rect_board_export
    self.finishEffect = self.root.Node_1_export.finishEffect_export
    self.icon = self.root.Node_1_export.icon_export
    self.addScore = self.root.Node_1_export.addScore_export
    self.progress_text = self.root.Node_1_export.progress_text_export
    self.targetFinished = self.root.Node_1_export.targetFinished_export
    self.titleNode = self.root.Node_1_export.titleNode_export
    self.title = self.root.Node_1_export.titleNode_export.title_export
    self.pz_lock = self.root.Node_1_export.titleNode_export.pz_lock_export
    self.pz_lock_effect = self.root.Node_1_export.titleNode_export.pz_lock_effect_export
    self.get_gift = self.root.Node_1_export.get_gift_export
    self.done_icon = self.root.Node_1_export.done_icon_export
    self.lock_icon = self.root.Node_1_export.lock_icon_export

    uiMgr:addWidgetTouchHandler(self.get_gift, function(sender, eventType) self:get_gift_call(sender, eventType) end)
--EXPORT_NODE_END
    self.Node_1:setSwallowTouches(false)

    self.taskPanel = global.panelMgr:getPanel("UIDailyTaskPanel")

    -- local tempSetTextColor = self.title.setTextColor
    -- self.title.setTextColor = function(node,color)
        
    --     print(">>>>>>>>>>set text color")
    --     print(debug.traceback())
    --     tempSetTextColor(node,color)
    -- end
end

function UIDailyTaskItem:setData(data)
    --dump(data,"666666666666666666666")
	-- body

    -- CCOrbitCamera::create(orbitTime, 1, 0, 270, 90, 0, 0);

    -- self.Node_1:runAction(cc.OrbitCamera:create(0.5,1,0,0,360,0,0))

    self.data = data
    self.rect_board:setName("rect_board" .. self.data.state)
    local taskData = luaCfg:get_daily_task_by(data.id)
    
    local dropData = luaCfg:get_drop_by(taskData.reward)

    self.dropItem = dropData.dropItem

    -- self.icon:setSpriteFrame(taskData.icon)
    global.panelMgr:setTextureFor(self.icon,taskData.icon)
    self.title:setString(taskData.taskName)
    self.progress_text:setString(data.progress .. "/" .. taskData.taskRound)

    -- 可获取的领主经验
    local expAdd = 0
    for k,v in pairs(dropData.dropItem) do
        if v[1] and v[1] == 5 then
            expAdd = v[2]
            break
        end
    end
    self.addScore:setString("+"..expAdd)

    self.get_gift:setVisible(false)

    -- self.rect_board:setSpriteFrame("ui_surface_icon/task_bg"..taskData.quality..".png")
    global.panelMgr:setTextureFor(self.rect_board,"icon/daily_task/task_bg"..taskData.quality..".png")
    self.title:setTextColor( dailyTaskData:getTextColor(taskData.quality) ) 

    self.lock_icon:setVisible(false)
    self.done_icon:setVisible(false)
    self.finishEffect:setVisible(false)
    self.progress_text:setVisible(true)
    self.targetFinished:setVisible(false)
    self.pz_lock_effect:removeAllChildren()
    self.Node_1:setScale(1)

    -- 品质是否锁定
    if taskData.quality >= global.dailyTaskData:getLockQualityLv() then
        self.pz_lock:setVisible(true)
    else
        self.pz_lock:setVisible(false)
    end

    global.colorUtils.turnGray(self.root,true)
    if data.state == WDEFINE.DAILY_TASK.TASK_STATE.WORKING then
                
        global.colorUtils.turnGray(self.root,false)    
    elseif data.state == WDEFINE.DAILY_TASK.TASK_STATE.LOCK then

        self.pz_lock:setVisible(false)
        self.lock_icon:setVisible(true)
    elseif data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        
        global.colorUtils.turnGray(self.root,false)
        self.progress_text:setVisible(false)
        self.targetFinished:setVisible(true)
        self.targetFinished:setString(luaCfg:get_local_string(10488))

        self.finishEffect:setVisible(true) 
        self.root:stopAllActions()
        local nodeTimeLine = resMgr:createTimeline("task/task_daily_unit")
        nodeTimeLine:play("animation0", true)
        self.root:runAction(nodeTimeLine) 

        if data.effectFlag == 0 then
            self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(function ()
                self:playFlyAnimation()
            end)))
            data.effectFlag = 1
        end

    elseif data.state == WDEFINE.DAILY_TASK.TASK_STATE.GETD then

        self.pz_lock:setVisible(false)
        self.done_icon:setVisible(true)
        global.colorUtils.turnGray(self.root,false)
        -- self.state:setSpriteFrame("ui_bg/daily_task_unit02.png")       
    end
    self.Node_1:runAction(cc.OrbitCamera:create(0,1,0,0,360,0,0))
  
end

-- 已完成处理
function UIDailyTaskItem:taskFinished()
    -- 自动领取完成任务奖励
    self:get_gift_call()
end

function UIDailyTaskItem:playFlyAnimation()
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_DayTaskOver") 
    local flystar2 = resMgr:createWidget("effect/get_box3")

    local beginPos = cc.p(self.Node_1:getContentSize().width/2, self.Node_1:getContentSize().height/2)
    local posF = self.Node_1:convertToWorldSpace(beginPos)
    flystar2:setPosition(cc.p(posF.x, posF.y))

    local pos = self.taskPanel.progressNode:convertToWorldSpace(cc.p(0,0))
    pos.x = pos.x + self.taskPanel.progressNode:getContentSize().width/2
    flystar2:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(pos.x,pos.y)),cc.RemoveSelf:create(), cc.CallFunc:create(function ()
        
        -- 播放进度条动画
        local timeLine = resMgr:createTimeline("task/task_daily_bg")
        timeLine:play("animation0", false)
        self.taskPanel:runAction(timeLine)

    end)))            
    uiMgr:configUITree(flystar2)     
    flystar2.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
    self.taskPanel.effectNode:addChild(flystar2)
    
end

function UIDailyTaskItem:onEnter() 

    local callBB = function(event, isRefresh)

        local flag = false
        if self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.WORKING or self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
            flag = true
        end
        if self.data.flushState == 0 and isRefresh and flag then 
            self.pz_lock:setVisible(false)
            self.Node_1:runAction(cc.OrbitCamera:create(0,1,0,0,360,0,0))
            self:stopAllActions()
            self.Node_1:runAction( cc.Sequence:create(cc.OrbitCamera:create(0.5,1,0,0,360,0,0),  
            cc.DelayTime:create(0.4),  cc.CallFunc:create(function ()
                
                local taskData = luaCfg:get_daily_task_by(self.data.id) 
                if taskData.quality >= global.dailyTaskData:getLockQualityLv() then
                    self.pz_lock:setVisible(false)
                    local  unLockSp, timeLine = resMgr:createCsbAction("effect/suo_mov","animation0",false, false)
                    self.pz_lock_effect:addChild(unLockSp)
                end
            end)))
        else
            self.Node_1:runAction(cc.OrbitCamera:create(0,1,0,0,360,0,0))
        end

    end
    
    self:addEventListener(gameEvent.EV_ON_DAILY_TASK_FLUSH,callBB)    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDailyTaskItem:get_gift_call(sender, eventType)
    
    if global.isGetRewing then return end
    global.isGetRewing = true

    global.taskApi:taskGetGift(self.data.id,function(msg)

        if msg.tgItem then
            
            local finishcall = function ()
                self.data.state = WDEFINE.DAILY_TASK.TASK_STATE.GETD
                dailyTaskData:getTaskGift(self.data)
                gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH)
                global.tipsMgr:showWarningAction(global.taskData.getGiftInfo(msg.tgItem or {}))
                global.uiMgr:removeSceneModal(10004)
                global.isGetRewing = nil
            end

            self.Node_1:runAction(cc.Sequence:create(  cc.EaseBackIn:create(  cc.ScaleTo:create(0.5,0) ) ,cc.CallFunc:create(finishcall)))
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_DayTaskGet")
            global.uiMgr:addSceneModel(2,10004)

        end
       

    end)
end

function UIDailyTaskItem:onExit()
    global.isGetRewing = nil
end
--CALLBACKS_FUNCS_END

return UIDailyTaskItem

--endregion

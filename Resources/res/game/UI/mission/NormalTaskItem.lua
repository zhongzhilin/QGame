--region NormalTaskItem.lua
--Author : untory
--Date   : 2016/08/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local taskData = global.taskData
local propData = global.propData
local userData = global.userData
local dataMgr = global.dataMgr
local gameEvent = global.gameEvent

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local NormalTaskItem  = class("NormalTaskItem", function() return gdisplay.newWidget() end )
local UIBagItem = require("game.UI.bag.UIBagItem")
function NormalTaskItem:ctor()
    
    self:CreateUI()
end

function NormalTaskItem:CreateUI()
    local root = resMgr:createWidget("task/task_common")
    self:initUI(root)
end

function NormalTaskItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_common")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Text_2 = self.root.Image_2.Text_2_export
    self.LoadingBar_1 = self.root.Image_2.LoadingBar_1_export
    self.progress_text = self.root.Image_2.progress_text_export
    self.item_add_node = self.root.Image_2.item_add_node_export
    self.layout_size = self.root.Image_2.item_add_node_export.layout_size_export
    self.task_btn = self.root.Image_2.task_btn_export
    self.btn_word = self.root.Image_2.task_btn_export.btn_word_export
    self.common_task_icon = self.root.Image_2.common_task_icon_back.common_task_icon_export

    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:btn_call(sender, eventType) end)
--EXPORT_NODE_END

    self.itemContentSize = self.layout_size:getContentSize()
    self.item_add_node:removeAllChildren()

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function NormalTaskItem:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_TASK_NORMAL_COMPELETE, function(event, sort)
        if self.data.sortId == sort then
            self:playEffect()
        end
    end)

end

function NormalTaskItem:playGetGift(msg)
    
    global.panelMgr:getPanel("TaskPanel"):playGiftEffect(self.data.id,true)
    self:setData(msg)
    self:playEffect()
end

function NormalTaskItem:playEffect()
    -- body
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("task/task_common")
    nodeTimeLine:setLastFrameCallFunc(function()
        if msg == nil then return end
        log.debug("--------------get msg")     
    end)
    nodeTimeLine:play("common_get", false)
    self.root:runAction(nodeTimeLine)  
end

function NormalTaskItem:btn_call(sender, eventType)

    if  sender:getTag() == 1 then

        global.panelMgr:closePanel("TaskPanel")

        global.funcGame.handleQuickTask(self.taskGPSType,self.taskBuildType,self.taskTargetlevel)
        
        return
    end

    global.taskApi:taskGetGift(self.data.id,function(msg)

        msg.tgNext = msg.tgNext or {}

        local mainTaskData = {sort = self.data.sort,id = msg.tgNext.lID,progress = msg.tgNext.lProgress,state = msg.tgNext.lState}

        global.tipsMgr:showTaskTips(taskData.getGiftInfo(msg.tgItem))

        if msg.tgNext.lID == nil then

            log.debug("下面没有任务了")
            taskData:removeNormalData(mainTaskData)
            global.panelMgr:getPanel("TaskPanel"):flushView()
        
            gevent:call(gameEvent.EV_ON_TASK_COMPELETE)
            return
        end
        
        global.tipsMgr:showTaskTips(taskData.getGiftInfo(msg.tgItem))
        taskData:flushNormalTask(mainTaskData,msg.tgFinish)
        
        -- local callBB = function()

        --     self:setData(mainTaskData)
        -- end

        -- self:runAction(cc.EaseBackInOut:create(cc.Sequence:create(
        --     cc.DelayTime:create(0.3),
        --     cc.ScaleTo:create(0.3,1,0),
        --     cc.CallFunc:create(callBB),
        --     cc.ScaleTo:create(0.3,1,1))))
        
        self:playGetGift(mainTaskData)
        
        gevent:call(gameEvent.EV_ON_TASK_COMPELETE)

        global.panelMgr:closePanel("UITaskDescPanel")
    end)

    -- local msg = {

    --     status = 1000,
    --     dropItem={{2,20},{1,10}},
    --     taskData = {},--taskData:getNextNormalMission(self.data.sort)
    -- }

    -- if msg.status == 1000 then
        
    --     local tipStr = dataMgr:updateItems(msg.dropItem)

    --     local callBB = function()

    --         -- self:setData(msg.taskData)
    --     end

    --     self:runAction(cc.EaseBackInOut:create(cc.Sequence:create(
    --         cc.DelayTime:create(0.3),
    --         cc.ScaleTo:create(0.3,1,0),
    --         cc.CallFunc:create(callBB),
    --         cc.ScaleTo:create(0.3,1,1))))

    --     -- sender:setEnabled(false)

    --     global.tipsMgr:showTaskTips(tipStr)

    --     -- taskData:updateNormalTask(msg.taskData)
    -- elseif msg.status == taskData.GET_REQUEST_STATUS_ERROR then

    --     log.debug("领取失败")
    -- end

    -- local str = {"city/effect_task_reward_coin","city/effect_task_reward_wood","city/effect_task_reward_food","city/effect_task_reward_stone"}
    -- global.tipsMgr:showEffectTips(str[math.random(1,4)],"animation0",0.3)
end
--CALLBACKS_FUNCS_END

function NormalTaskItem:setData( msg )

    if not msg then 
        -- protect 
        return
    end 

    self.data = msg

    --dump(self.data,"233333333333333")
    self.task_btn:setName("task_btn" .. self.data.state)

    local data = luaCfg:get_common_task_by(msg.id)

    self.taskBuildType = data.taskTarget
    if data.taskType == 30 then 
        self.taskBuildType = 28 
    end 
    self.taskGPSType = data.location
    self.taskTargetlevel = data.taskTargetlevel

    local progressPercent = msg.progress / data.taskAim * 100

    self.task_btn:setEnabled(true)


    if msg.state == taskData.TASK_STATE_ON then
        
        self.task_btn:loadTextureNormal("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.task_btn:loadTexturePressed("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10014))
        self.task_btn:setTag(1)

        self.task_btn:setVisible(data.location ~= 0)
    elseif msg.state == taskData.TASK_STATE_CAN_GET then
      
        self.task_btn:loadTextureNormal("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.task_btn:loadTexturePressed("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10013))
        self.task_btn:setTag(0)

        self.task_btn:setVisible(true)
    end

    self.Text_2:setString(data.taskName)
    -- self.common_task_icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.common_task_icon,data.icon)
    self.LoadingBar_1:setPercent(progressPercent)
    self.progress_text:setString(msg.progress .. "/" .. data.taskAim)


    self.item_add_node:removeAllChildren()


    local dropId = data.reward
    local dropData = luaCfg:get_drop_by(dropId)

    local x = 1 
    for _ ,v in pairs(dropData.dropItem) do 
        local data = {} 
        data.id =v[1]
        data.count =v[2]
        local item = UIBagItem.new()
        item:setScale(0.35)
        if v[1] < 6 then
            item.icon:setScale(2.8)
        else
            item.icon:setScale(1)
        end
        item.count_text:setScale(1.8)
        self.item_add_node:addChild(item)
        item:setData(data)
        item:setPositionX((x-1) * self.itemContentSize.width)
        item.count_text:setVisible(false)
        x = x + 1 
    end 

end


function NormalTaskItem:GPSBuildingOpenPanel()

    local data = luaCfg:get_common_task_by(self.data.id)

    local call =nil 

    local CanGPS = true 

    if not  global.funcGame:checkBuildAndBuildLV(self.taskBuildType) then  --检测建筑是否达到开放等级 and  是否建造
        
        return 
    end

    if self.taskBuildType == 28 then -- 定位到龙潭 打开界面 

        if self:checkPass(data.taskTarget) then
            call = function () 
                global.panelMgr:openPanel("UIBossPanel"):gpsAndOpenItem(data.taskTarget)
            end 
        else
            CanGPS = false 
            global.tipsMgr:showWarning("NotUnlockGate")
        end

    end  

    if CanGPS then 
        global.funcGame.forceGpsCityBuilding(self.taskBuildType,call)
    end 
end 


function NormalTaskItem:checkPass(id)

    local curFinishId = global.bossData:getCurUnlockBoss()
    if curFinishId < id then
        return  false
    end

    return true 
end


return NormalTaskItem

--endregion

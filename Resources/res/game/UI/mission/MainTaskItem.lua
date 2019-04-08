--region MainTaskItem.lua
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

local MainTaskItem  = class("MainTaskItem", function() return gdisplay.newWidget() end )

function MainTaskItem:ctor()
    
end

function MainTaskItem:CreateUI()
    self.root = resMgr:createWidget("task/task_main")
    self:initUI(self.root)
end

function MainTaskItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_main")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.arrive_btn = self.root.main_task_bg.arrive_btn_export
    self.btn_word = self.root.main_task_bg.arrive_btn_export.btn_word_export
    self.LoadingBar_1 = self.root.main_task_bg.LoadingBar_1_export
    self.progress_text = self.root.main_task_bg.progress_text_export
    self.taskName = self.root.main_task_bg.taskName_export
    self.task_icon = self.root.main_task_bg.task_icon_export
    self.reward_icon = self.root.main_task_bg.reward_icon_export
    self.Text_2 = self.root.main_task_bg.Text_2_export

    uiMgr:addWidgetTouchHandler(self.root.main_task_bg, function(sender, eventType) self:jump_desc(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.arrive_btn, function(sender, eventType) self:get_btn(sender, eventType) end)
--EXPORT_NODE_END
    global.funcGame:initBigNumber(self.Text_2, 1)

end

function MainTaskItem:playGetGift(msg)
    -- body

    global.panelMgr:getPanel("TaskPanel"):playGiftEffect(self.data.id)

    self:setData(msg)

    self.root:stopAllActions()

    local nodeTimeLine = resMgr:createTimeline("task/task_main")
    nodeTimeLine:setLastFrameCallFunc(function()

        if msg == nil then return end
        
    end)
    nodeTimeLine:play("get_gift", false)
    self.root:runAction(nodeTimeLine)
end

function MainTaskItem:testPlay()
    
    -- self.clickEffectNode:setPosition(pos)
end

function MainTaskItem:setData( msg )

    self.data = msg

    local data = luaCfg:get_main_task_by(msg.id)
    if not data then return end
    
    self.taskTargetlevel = data.taskTargetlevel
    self.taskBuildType = data.taskTarget
    self.taskGPSType = data.location

    local progressPercent = msg.progress / data.taskAim * 100

    self.taskName:setString(data.taskName)
    -- self.task_icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.task_icon,data.icon)
    self.LoadingBar_1:setPercent(progressPercent)
    self.progress_text:setString(msg.progress .. "/" .. data.taskAim)
    self.arrive_btn:setEnabled(true)

    if msg.state == taskData.TASK_STATE_ON then
        
        self.arrive_btn:loadTextureNormal("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.arrive_btn:loadTexturePressed("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10014))
        self.arrive_btn:setTag(1)
        
        self.arrive_btn:setVisible(data.location ~= 0)
    elseif msg.state == taskData.TASK_STATE_CAN_GET then
      
        self.arrive_btn:loadTextureNormal("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.arrive_btn:loadTexturePressed("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10013))
        self.arrive_btn:setTag(0)

        self.arrive_btn:setVisible(true)
    end    

    local dropId = data.reward
    local dropData = luaCfg:get_drop_by(dropId)
    local max = -1
    local id = -1
    for i,v in ipairs(dropData.dropItem) do        
        local itemId = v[1]    
        local itemNum = v[2]
        if itemNum > max then

            max = itemNum
            id = i
        end
    end

    -- for _,v in ipairs(dropData.dropItem) do

    --     local itemId = v[1]    
    --     local itemNum = v[2]

    --     if itemId < 5 then

    --         local itemData = luaCfg:get_res_icon_by(itemId)
    --         local itemName = itemData.itemName
    --         local itemIcon = itemData.icon        
        
    --         self.reward_icon:setSpriteFrame(itemIcon)
    --         self.Text_2:setString(":"..itemNum)

    --         break
    --     end
    -- end

    local v = dropData.dropItem[id]
    local itemId = v[1]
    local itemNum = v[2]

    local itemData = luaCfg:get_res_icon_by(itemId)
    local itemName = itemData.itemName
    local itemIcon = itemData.icon
    
    self.reward_icon:setSpriteFrame(itemIcon)
    self.Text_2:setString("+"..itemNum)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function MainTaskItem:get_btn(sender, eventType)

    print(">>>>>>>>>>>>tag function MainTaskItem:get_btn(sender, eventType)")

    if  sender:getTag() == 1 then
        
        global.panelMgr:closePanel("TaskPanel")

        global.funcGame.handleQuickTask(self.taskGPSType,self.taskBuildType,self.taskTargetlevel)
        
        return
    end

    global.taskApi:taskGetGift(self.data.id,function(msg)

        print(">>>>>>>>>>>>tag global.taskApi:taskGetGift(self.data.id,function(msg)")

        local mainTaskData = {sort = 1,id = msg.tgNext.lID,progress = msg.tgNext.lProgress,state = msg.tgNext.lState}
        local str = taskData.getGiftInfo(msg.tgItem or {})
        if str == "" then

            str = vardump(msg.tgItem)
        end

        global.tipsMgr:showTaskTips(str)
        taskData:flushMainTask(mainTaskData)
        taskData:checkCurrentTaskNeedFlush(mainTaskData)
        self:playGetGift(mainTaskData)

        gevent:call(global.gameEvent.EV_ON_TASK_COMPELETE)
        gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)

        global.panelMgr:closePanel("UITaskDescPanel")
    end)


    

    -- local msg = {

    --     status = taskData.GET_REQUEST_STATUS_SUCCESS,
    --     dropItem= {{2,20},{1,10}},
    --     taskData = taskData:getNextMainMission()
    -- }

    -- if msg.status == taskData.GET_REQUEST_STATUS_SUCCESS then
        
    --     local tipStr = dataMgr:updateItems(msg.dropItem)

    --     self:playGetGift(msg)

    --     -- self:runAction(cc.EaseBackInOut:create(cc.Sequence:create(
    --     --     cc.DelayTime:create(0.3),
    --     --     cc.ScaleTo:create(0.3,1,0),
    --     --     cc.CallFunc:create(callBB),
    --     --     cc.ScaleTo:create(0.3,1,1))))

    --     -- sender:setEnabled(false)

    --     global.tipsMgr:showTaskTips(tipStr)

    --     taskData:updateMainTask(msg.taskData)
    -- elseif msg.status == taskData.GET_REQUEST_STATUS_ERROR then

    --     log.debug("领取失败")
    -- end

end

function MainTaskItem:jump_desc(sender, eventType)

    print(">>>>>>>>>>>>>tag jump desc")
  
    local descPanel = global.panelMgr:openPanel("UITaskDescPanel")
    descPanel:setData(self.data,true)  
end
--CALLBACKS_FUNCS_END

return MainTaskItem

--endregion

 --region UITaskDescPanel.lua
--Author : untory
--Date   : 2016/08/04
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

local UITaskDescPanel  = class("UITaskDescPanel", function() return gdisplay.newWidget() end )
local UITaskDescGiftCell = require("game.UI.mission.UITaskDescGiftCell")
local UITableView = require("game.UI.common.UITableView")

function UITaskDescPanel:ctor()

    self:CreateUI()
end

function UITaskDescPanel:CreateUI()
    local root = resMgr:createWidget("task/task_second_bg")
    self:initUI(root)
end

function UITaskDescPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_second_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.task_icon = self.root.Image_9.task_icon_export
    self.LoadingBar_1 = self.root.Image_9.LoadingBar_1_export
    self.taskName = self.root.Image_9.taskName_export
    self.progress_text = self.root.Image_9.progress_text_export
    self.task_desc = self.root.Image_9.task_desc_export
    self.Panel_1 = self.root.Image_9.Panel_1_export
    self.Panel_2 = self.root.Image_9.Panel_2_export
    self.table_view = self.root.table_view_export
    self.top_node = self.root.top_node_export
    self.task_btn = self.root.task_btn_export
    self.btn_word = self.root.task_btn_export.btn_word_export

    uiMgr:addWidgetTouchHandler(self.root.Image_7.back, function(sender, eventType) self:btn_exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:jump_call(sender, eventType) end)
--EXPORT_NODE_END

    -- dump(self.top_node)
    log.debug("--------------------"..self.top_node:getPositionY()) 

    self.tableView = UITableView.new()
        :setSize(self.Panel_1:getContentSize(),self.top_node)
        :setCellSize(self.Panel_2:getContentSize())
        :setCellTemplate(UITaskDescGiftCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.table_view:addChild(self.tableView)
end

function UITaskDescPanel:setData( data , isMainTask)
    
    self.isMainTask = isMainTask or false

    self.data = data

    local taskDataTemp = nil
    
    if self.isMainTask == true then
        taskDataTemp = luaCfg:get_main_task_by(data.id)
    else
        taskDataTemp = luaCfg:get_common_task_by(data.id)
    end

    if not taskDataTemp then 

         -- 保护处理 ， 防止报错
        return         
    end 

    local progressPercent = data.progress / taskDataTemp.taskAim * 100

    self.taskBuildType = taskDataTemp.taskTarget
    self.taskTargetlevel = taskDataTemp.taskTargetlevel

    self.taskName:setString(taskDataTemp.taskName)
    -- self.task_icon:setSpriteFrame(taskDataTemp.icon)
    global.panelMgr:setTextureFor(self.task_icon,taskDataTemp.icon)
    self.LoadingBar_1:setPercent(progressPercent)
    self.progress_text:setString(data.progress .. "/" .. taskDataTemp.taskAim)
    self.task_desc:setString(taskDataTemp.taskDescription)
    self.task_btn:setEnabled(true)

    self.taskGPSType = taskDataTemp.location

    if taskDataTemp.taskType == 30 and not self.isMainTask then 
        self.taskBuildType = 28 
    end 

    local dropId = taskDataTemp.reward
    local dropData = luaCfg:get_drop_by(dropId)

    self.tableView:setData(dropData.dropItem)


    if data.state == taskData.TASK_STATE_ON then
        
        self.task_btn:loadTextureNormal("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.task_btn:loadTexturePressed("ui_button/btn_equip.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10014))
        self.task_btn:setTag(1)

        self.task_btn:setVisible(taskDataTemp.location ~= 0)
    elseif data.state == taskData.TASK_STATE_CAN_GET then
      
        self.task_btn:loadTextureNormal("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.task_btn:loadTexturePressed("ui_button/btn_reward.png",ccui.TextureResType.plistType)
        self.btn_word:setString(luaCfg:get_local_string(10013))
        self.task_btn:setTag(0)

        self.task_btn:setVisible(true)
    end

    -- body
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITaskDescPanel:btn_exit(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UITaskDescPanel")
end

function UITaskDescPanel:jump_call(sender, eventType)
    
    -- if not self.isMainTask then

    --     if true then

    --         global.tipsMgr:showWarningText("普通任务功能尚未开启")

    --         return
    --     end
    -- end    

    if  sender:getTag() == 1 then

        log.debug(self.taskGPSType)

        global.funcGame.handleQuickTask(self.taskGPSType,self.taskBuildType,self.taskTargetlevel)

        global.panelMgr:closePanel("TaskPanel")
        global.panelMgr:closePanel("UITaskDescPanel")
        
        return
    end

    global.taskApi:taskGetGift(self.data.id,function(msg)

        msg.tgNext = msg.tgNext or {}

        local mainTaskData = {sort = self.data.sort,id = msg.tgNext.lID,progress = msg.tgNext.lProgress,state = msg.tgNext.lState}
        global.tipsMgr:showTaskTips(taskData.getGiftInfo(msg.tgItem))
        
        if self.isMainTask then
        
            taskData:flushMainTask(mainTaskData)
            taskData:checkCurrentTaskNeedFlush(mainTaskData)        
            global.panelMgr:getPanel("TaskPanel"):playGetGift(mainTaskData)
        else

            if msg.tgNext.lID == nil then

                log.debug("no task")
                taskData:removeNormalData(mainTaskData)
                global.panelMgr:getPanel("TaskPanel"):flushView()

            else           
                taskData:flushNormalTask(mainTaskData,msg.tgFinish)
                global.panelMgr:getPanel("TaskPanel"):playGiftEffect(msg.tgNext.lID, true)              
            end        
        end

        global.panelMgr:getPanel("TaskPanel"):flushView()
        global.panelMgr:closePanel("UITaskDescPanel")

        gevent:call(gameEvent.EV_ON_TASK_COMPELETE)
        
        if not self.isMainTask then
            gevent:call(gameEvent.EV_ON_TASK_NORMAL_COMPELETE, self.data.sortId)
        end

    end)
end
--CALLBACKS_FUNCS_END

function UITaskDescPanel:GPSBuildingOpenPanel()

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


function UITaskDescPanel:checkPass(id)

    local curFinishId = global.bossData:getCurUnlockBoss()
    if curFinishId < id then
        return  false
    end

    return true 
end




function UITaskDescPanel:onEnter()
    -- body

end

return UITaskDescPanel

--endregion

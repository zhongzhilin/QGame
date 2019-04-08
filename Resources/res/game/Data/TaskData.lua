local TaskData = class("TaskData")

local luaCfg = global.luaCfg

local _instance = nil

TaskData._normalTasks = {}

TaskData._mainTask = {}
TaskData._currentTask = {}

TaskData.TASK_STATE_ON = 0
TaskData.TASK_STATE_CAN_GET = 1

TaskData.GET_REQUEST_STATUS_SUCCESS = 1000
TaskData.GET_REQUEST_STATUS_ERROR = 1001


--模拟服务器数据，逻辑,后面不需要有

-- TaskData._buildState = {}
TaskData._updateState = { [1] = 1}
TaskData._updateStateMeta = {
    
    __index = function( key )
        -- body

        return 0
    end
}

TaskData._buildState = { [1] = 1}
TaskData._buildStateMeta = {
    
    __index = function( key )
        -- body

        return 0
    end
}

setmetatable(TaskData._updateState, TaskData._updateStateMeta)
setmetatable(TaskData._buildState, TaskData._buildStateMeta)

TaskData._contentNormalIndex = 20003
TaskData._tempCurrentTask = {id = 10001,progress = 0,sort = 1,state = 1}

--模拟服务器数据，逻辑,后面不需要有

--[[
	TaskData
		sort id state progress isChanged isNew

	baseData
		mainTask (TaskData)
		normalTasks[3] (TaskData)

	type
	 	msgType taskInit taskChange taskReceive
]]--

function TaskData:getInstance()
	
	if _instance == nil then _instance = TaskData.new() end

	return _instance

end

function TaskData:init( msg ,normalTask )	

    log.debug("------------->")

    if not msg then return end
	local auto_msg = {}
    auto_msg.currentMainTask = {sort = 1,id = msg[1].lID,state = msg[1].lState,progress = msg[1].lProgress}
    auto_msg.mainTaskData = {sort = 1,id = msg[#msg].lID,state = msg[#msg].lState,progress = msg[#msg].lProgress}
    auto_msg.normalTasks = {}

    normalTask = normalTask or {}

    local res = {}
    for i,v in ipairs(normalTask) do

        table.insert(res,self:ServerData2TaskData(i,v))
    end

    table.assign(auto_msg.normalTasks,res)

    self:setData(auto_msg)

    gevent:call(global.gameEvent.EV_ON_TASK_COMPELETE)
end

function TaskData:ServerData2TaskData(_sort,data)
    
    return {sort = _sort,state = data.lState,progress = data.lProgress,id = data.lID}
end

function TaskData:setData(msg)
	
	self.msg = msg

	self._mainTask = msg.mainTaskData
	self._normalTasks = msg.normalTasks
    self._currentTask = msg.currentMainTask
end

function TaskData:updateMainTask( msg )    
    
    if msg.id == self._mainTask.id then
    
        self._mainTask = msg
    end

    self:updateNormalTask(msg)

end

function TaskData:flushMainTask(data)
    
    self._mainTask = data
end

function TaskData:flushNormalTask( msg , finishId )    

    for i,v in ipairs(self._normalTasks) do

        print(v.id,finishId)
        if v.id == finishId then

            self._normalTasks[i] = msg
        end
    end
end

function TaskData:isHaveNewGift()
   
    local count = 0

    if self._mainTask.state == 1 then count = count + 1 end

    
    for _,v in ipairs(self._normalTasks) do

        if v.state == 1 then 
            
            count = count + 1
            -- return true
        end
    end

    return count > 0,count
end

function TaskData:removeNormalData( msg )    

    print("remove normal data ")
    dump(msp)

    table.remove(self._normalTasks,msg.sort)
end

function TaskData:checkCurrentTaskNeedFlush(data)

    if data.id > self._currentTask.id then

        self._currentTask = clone(data)
    end
end

function TaskData:updateNormalTask( msg )
    -- body

    print("update normal task")
    dump(msg)

    for i,v in ipairs(self._normalTasks) do

        if v.id == msg.id then

            self._normalTasks[i] = msg
        end
    end
end

function TaskData:updateCurrentMainTask( msg )
    -- body
    self._currentTask = msg
    self._tempCurrentTask = msg
end

--模拟服务器数据，逻辑,后面不需要有

function TaskData:buildTest(data)
    -- body
    
    -- local buildType = data.buildingType

    -- dump(self._buildState)

    -- self._buildState[data.buildingType] = self._buildState[data.buildingType] + 1

    -- self:checkMainTask(data,2)
    -- self:checkNormalTask(data,2)
    -- self:checkTempCurrentTask(data,2)
end

function TaskData.getGiftInfo(drop)
    
    local tipStr = ""

    if not drop or #drop == 0 then

        print(">>>>>>>>>>>>>drop error")
        print(debug.traceback())
        return
    end

    for _,v in ipairs(drop) do

        local itemNum = v.lCount
        local itemId = v.lID

        local itemData = luaCfg:get_item_by(itemId)

        if itemData then
            
            local itemName = itemData.itemName
     
            tipStr = tipStr .. itemName .. "+" .. itemNum .. " "
     
        end    
    end

    return tipStr
end

function TaskData.getGiftInfoBySort(drop)
    
    local tipStr = ""

    for _,v in ipairs(drop) do

        local itemNum = v[2]
        local itemId = v[1]

        local itemData = luaCfg:get_item_by(itemId)

        if itemData then
            
            local itemName = itemData.itemName
     
            tipStr = tipStr .. itemName .. "+" .. itemNum .. " "
     
        end    
    end

    print("tipstr .. " .. tipStr)

    return tipStr
end

function TaskData:updateTest(data)

    -- local buildType = data.buildingType

    -- if data.level > self._updateState[data.id] then

    --     self._updateState[data.buildingType] = data.level 
    -- end

    -- self:checkMainTask(data,1)
    -- self:checkNormalTask(data,1)
    -- self:checkTempCurrentTask(data,1)
end

function TaskData:checkMainTask( data , taskType_test )
    -- body

    local buildType = data.buildingType

    local taskData = luaCfg:get_main_task_by(self._mainTask.id)
    local taskTarget = taskData.taskTarget
    local taskType = taskData.taskType
    local taskTriggersid = taskData.taskTriggersid

    if taskType == taskType_test and taskTarget == buildType then

        local contentProgress = self._mainTask.progress
        local contentState = 1

        if taskData.taskType == 1 then 

            contentProgress = data.level 
        else

            contentProgress = contentProgress + 1
        end            

        if contentProgress >= taskTriggersid then

            contentProgress = taskTriggersid
            contentState = 2
        end

        local LogicNtf = require "game.Rpc.LogicNotify"
        
        LogicNtf:taskCompelete({
            isMainTask = true,
            taskData = {

                sort = self._mainTask.sort,
                id = self._mainTask.id,
                state = contentState,
                progress = contentProgress
            },
        })
    end
end

function TaskData:checkNormalTask( data , taskType_test )
    
    local buildType = data.buildingType

    for _,v in ipairs(self._normalTasks) do

        local taskData = luaCfg:get_common_task_by(v.id)
        local taskTarget = taskData.taskTarget
        local taskType = taskData.taskType
        local taskTriggersid = taskData.taskTriggersid

        if taskType == taskType_test and taskTarget == buildType then

            local contentProgress = v.progress
            local contentState = 1
            
            if taskData.taskType == 1 then 

                contentProgress = data.level 
            else
            
                contentProgress = contentProgress + 1
            end    

            if contentProgress >= taskTriggersid then

                contentProgress = taskTriggersid
                contentState = 2
            end

            local LogicNtf = require "game.Rpc.LogicNotify"
        
            LogicNtf:taskCompelete({
                isMainTask = false,
                taskData = {

                    sort = v.sort,
                    id = v.id,
                    state = contentState,
                    progress = contentProgress
                },
            })
        end
    end
end

function TaskData:checkTempCurrentTask( data , taskType_test )

    local buildType = data.buildingType

    local taskData = luaCfg:get_main_task_by(self._tempCurrentTask.id)
    local taskTarget = taskData.taskTarget
    local taskType = taskData.taskType
    local taskTriggersid = taskData.taskTriggersid

    log.debug("===> "..taskType.." "..taskType_test .." "..taskTarget.." "..buildType)

    if taskType == taskType_test and taskTarget == buildType then

        local contentProgress = self._tempCurrentTask.progress
        local contentState = 1
        local contentId = self._tempCurrentTask.id


        if taskData.taskType == 1 then 

            contentProgress = data.level 
        else

            contentProgress = contentProgress + 1
        end

        log.debug("===> "..contentProgress.." "..taskTriggersid)

        if contentProgress >= taskTriggersid then

            contentProgress = taskTriggersid
            contentState = 2
            contentId = contentId + 1
            
            local LogicNtf = require "game.Rpc.LogicNotify"

            LogicNtf:updateCurrentMainTask(self:getNextCurrentMission(contentId))
        end    
    end
end

function TaskData:getNextMainMission()
   
    local nextId = self._mainTask.id + 1

    local taskData = luaCfg:get_main_task_by(nextId)

    local pro = 0
    local sta = 1
   
    if taskData.taskType == 1 then
        pro = self._updateState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end

    if taskData.taskType == 2 then
        pro = self._buildState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end


    return {sort = 1,
            id = nextId,
            state = sta,
            progress = pro}
end

function TaskData:getNextNormalMission(sort)
    
    self._contentNormalIndex = self._contentNormalIndex + 1

    -- local normal_tasks = luaCfg:common_task()

    -- for _,v in ipairs(normal_tasks) do

    --     local _taskType = v.taskType
    --     local _taskTarget = v.taskTarget
    --     local _taskTriggersid = v.taskTriggersid

    --     if _taskType == 1 then


    --     end 

    -- end

    local taskData = luaCfg:get_common_task_by(self._contentNormalIndex)
    local pro = 0
    local sta = 1

    if taskData.taskType == 1 then
        pro = self._updateState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end

    if taskData.taskType == 2 then
        pro = self._buildState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end

    return {sort = sort,
            id = self._contentNormalIndex,
            state = sta,
            progress = pro}
end

function TaskData:getNextCurrentMission(nextId)

    local taskData = luaCfg:get_main_task_by(nextId)

    local pro = 0
    local sta = 1
   
    if taskData.taskType == 1 then
        pro = self._updateState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end

    if taskData.taskType == 2 then
        pro = self._buildState[taskData.taskTarget]
        if pro >= taskData.taskTriggersid then
            pro = taskData.taskTriggersid
            sta = 2
        end
    end

    if sta == 2 then
        return self:getNextCurrentMission(nextId + 1)
    else
        return {sort = 1,
            id = nextId,
            state = sta,
            progress = pro}
    end
end

--模拟服务器数据，逻辑,后面不需要有

function TaskData:getNormalTasks()
	
	return self._normalTasks
end

function TaskData:getMainTask()

	return self._mainTask
end

function TaskData:getCurrentMainTask()

    return self._currentTask
end

global.taskData = TaskData.getInstance()

return TaskData
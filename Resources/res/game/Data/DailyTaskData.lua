 local chat_cfg = require("asset.config.chat_cfg")

local DailyTaskData = class("DailyTaskData")
local luaCfg = global.luaCfg
local _instance = nil
local gameEvent = global.gameEvent
local gevent = gevent

--[[
    TaskData
        sort id state progress isChanged isNew

    baseData
        mainTask (TaskData)
        normalTasks[3] (TaskData)

    type
        msgType taskInit taskChange taskReceive
]]--

function DailyTaskData:getInstance()
    if _instance == nil then _instance = DailyTaskData.new() end
    return _instance
end

function DailyTaskData:init(msg)  
    
    self:initRewardBagState(msg)   
    self:initRegister(msg)
    self:initStrength(msg)
    self:initDailyTask(msg)
    self:setTimestamp(msg.tagTime)
    self:setQuitClass(msg.lOrangeProgress or 0)
end

---- 每日橙色任务奖励领取 ----
function DailyTaskData:setQuitClass(class)
    self.quitClass = class
end
function DailyTaskData:getQuitClass()
    return self.quitClass
end

-----------------------/- 每日任务 -/-----------------------------

function DailyTaskData:initDailyTask(msg)
    self._tasks = {}
    self._score = 0
    self._perScore = 0

    local auto_msg = clone(self:getAutoMsg())
    self._score = msg.lDailyTaskScore   -- 当前任务积分
    self._perScore = self._score

    self._boxs = self:changeBoxSeverData(auto_msg, msg.lDailyTaskScore, msg.lDailyReward)
    self:setRefershTime()
    self:setFlushTime(msg.tgBuyCount.lTaskCount or 0)

    for k,v in pairs(msg.tgDailyTasks) do
        local data = {}
        data = self:changeServerData(v, k) or {}
        data.effectFlag = 1 -- 是否播放过动画
        table.insert(self._tasks, data)
    end
    self:refershFlushState()
end

function DailyTaskData:getAutoMsg()
    
    local auto_msg = {score = 0,tasks = {},}
    
    local boxM = global.luaCfg:daily_point()
    auto_msg.boxs = {}
    for i,v in ipairs(boxM) do
        local temp = {}
        temp.score = v.taskSegment
        temp.state = WDEFINE.DAILY_TASK.TASK_STATE.WORKING
        table.insert(auto_msg.boxs, temp)
    end

    return auto_msg
end

function DailyTaskData:setRefershTime()
    
    local time = luaCfg:get_time_by(5).time
    if time == 0 then time = 24 end

    local currentTime = global.dataMgr:getServerTime()
    local currTimeTb = global.funcGame.formatTimeToTime(currentTime, true)

    -- 当天0点时间戳
    local zeroTime = currentTime + (time - currTimeTb.hour)*3600 - currTimeTb.minute*60 - currTimeTb.second
    self._nextFlushTime = zeroTime
end

function DailyTaskData:changeIntToBit32(num)

    num = num or 0
    local boxState = {}
    for index ,v in ipairs(global.luaCfg:daily_point()) do 
        boxState[index] = 0 
    end 

    local bitTb = bit._d2b(num)
    for k,v in pairs(bitTb) do
        if k >= 33-(#global.luaCfg:daily_point()) then
            boxState[33-k] = v
        end
    end
    return boxState
end

function DailyTaskData:changeBoxSeverData( auto_msg, currentScore,  rewardScore)

    local boxState = self:changeIntToBit32(rewardScore)

    local i = 1
    local boxData = {}
    for _,v in pairs(auto_msg.boxs) do

        local tb = {}
        local lState = ""
        if v.score <= currentScore then 
            if boxState[i] == 1 then
                lState = WDEFINE.DAILY_TASK.TASK_STATE.GETD  -- 达成领取
            else
                lState = WDEFINE.DAILY_TASK.TASK_STATE.DONE  -- 达成未领取
            end
        else
            lState = WDEFINE.DAILY_TASK.TASK_STATE.WORKING   -- 未达成
        end
        tb.score = v.score
        tb.state = lState
        table.insert(boxData, tb)
        i = i + 1
    end

    table.sort( boxData, function(s1, s2) return s1.score < s2.score end )
    return boxData
end

function DailyTaskData:unGetStateNum()
    
    local num = 0
    for _,v in pairs(self._boxs) do
        if v.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
            num = num + 1
        end
    end
    return num
end

function DailyTaskData:changeServerData(data, id)
    
    local taskData = luaCfg:get_daily_task_by(data.lID)
    if not taskData then
        return
    end

    local tb = {}
    tb.sort = id
    tb.id   = data.lID
    tb.progress = math.floor(data.lProgress/taskData.perNum)
    tb.state = self:getState(data)
    tb.rank = taskData.rank
    return tb
end

function DailyTaskData:refershFlushState()

    for _,v in pairs(self._tasks or {} ) do
        
        local taskData = luaCfg:get_daily_task_by(v.id)
        if taskData and taskData.quality >= global.dailyTaskData:getLockQualityLv() then
            v.flushState = 1
        else
            v.flushState = 0
        end
    end
end

-- 锁住等级
function DailyTaskData:getLockQualityLv()
    return 5
end

function DailyTaskData:closeFlushState(id)

    for _,v in pairs(self._tasks) do
        if v.id == id then
             v.flushState = 1
        end
    end
end

function DailyTaskData:setFlushState()
    for _,v in pairs(self._tasks) do
        local taskData = luaCfg:get_daily_task_by(v.id)
        if taskData.quality >= global.dailyTaskData:getLockQualityLv() then
            v.flushState = 1
        else
            v.flushState = 0
        end
    end
end

function DailyTaskData:getState(v)
    
    local lState = ""
    if v.lState == 0 then      -- 未完成
        lState = WDEFINE.DAILY_TASK.TASK_STATE.WORKING
    elseif v.lState == 1 then  -- 完成未领取
        lState = WDEFINE.DAILY_TASK.TASK_STATE.DONE
    elseif v.lState == 2 then  -- 完成领取
        lState = WDEFINE.DAILY_TASK.TASK_STATE.GETD
    end

    local lockState = self:checkLockState(v.lID)
    if lockState == WDEFINE.DAILY_TASK.TASK_STATE.LOCK then       -- 锁住状态
        lState = lockState
    end
    return lState
end

function DailyTaskData:checkLockState( taskId )
  
    local lockState = WDEFINE.DAILY_TASK.TASK_STATE.LOCK
    local dailyTaskData = luaCfg:get_daily_task_by(taskId)

    local buildId = dailyTaskData.unlockId
    local buildLv = dailyTaskData.unlockLv

    local registerBuild = global.cityData:getRegistedBuild()
    for i,v in ipairs(registerBuild) do
        if v.id == buildId then
            
            local currentLv = v.serverData.lGrade
            if currentLv >= buildLv then

                lockState = WDEFINE.DAILY_TASK.TASK_STATE.WORKING
            end
        end
    end
    return lockState
end

-- 当前已经刷新的次数
function DailyTaskData:setFlushTime(times)
    
    self._flushTime = times 
    gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end

function DailyTaskData:getFlushTime()
    
    return self._flushTime
end

-- 更新任务
function DailyTaskData:updateTask(data, currentScore)
    
    if not self._tasks then return end
    local tempData = self:changeServerData(data)
    for _,v in pairs(self._tasks) do
        
        if v.id == tempData.id then
            v.progress = tempData.progress
            v.state = tempData.state

            -- 播放动画状态
            if v.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE and v.effectFlag == 1 then
                v.effectFlag = 0
            end
        end
    end

    self:updataScore(currentScore)    -- 更新积分    
end

function DailyTaskData:updataScore(currentScore)

    self._score = currentScore

    -- 刷新宝箱状态
    self:refershBoxState()
end

function DailyTaskData:refershBoxState()
    
    for _,v in pairs(self._boxs) do
        if v.state == 1 and v.score <= self._score then
            v.state = 0
        end
    end

    if global.scMgr:isMainScene() then
         --幸运建筑id 27
        local buildingType = 27

        if global.g_cityView then -- 防止报错。
            local buildingItem = global.g_cityView:getTouchMgr():getBuildingNodeBy(buildingType)
            if buildingItem then
                buildingItem:resetData()
            end
        end 
    end
   
end

-- 刷新任务状态
function DailyTaskData:refershLockState( buildId )
    
    local buildTypeId = luaCfg:get_buildings_pos_by(buildId).buildingType

    for _,v in pairs(self._tasks) do
        local unLockId = -1 
        if  luaCfg:get_daily_task_by(v.id) then 
            unLockId=luaCfg:get_daily_task_by(v.id).unlockId
        end 
        if buildTypeId == unLockId then
         
            local curState = self:checkLockState(v.id)
            local lState = WDEFINE.DAILY_TASK.TASK_STATE.LOCK
            if curState ~= lState and v.state == lState then       
                v.state = WDEFINE.DAILY_TASK.TASK_STATE.WORKING  
            end
        end
    end
end

-- 刷新任务
function DailyTaskData:refershTask(taskData)

    local flushData = self:getFlushState()

    self._tasks = {}
    for k,v in pairs(taskData) do
        local data = {}
        data = self:changeServerData(v, k)
        if data and data.id then 
            local order = luaCfg:get_daily_task_by(data.id).order
            data.flushState = self:getFlushStateById(flushData, order)

            -- 播放动画状态
            if data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE and data.effectFlag == 1 then
                data.effectFlag = 0
            end
            table.insert(self._tasks, data)
        end 
    end    
end

function DailyTaskData:getFlushStateById(data, order)
    
    for _,v in pairs(data or {} ) do
        if v.order == order then
            return v.flushState
        end
    end
end

function DailyTaskData:getFlushState()
    
    if not self._tasks then return end
    local data = {}
    for _,v in pairs(self._tasks) do

        local tb = {}
        local order = luaCfg:get_daily_task_by(v.id).order
        tb.order = order
        tb.flushState = v.flushState
        table.insert(data, tb)
    end
    return data
end

-- 零点重置
function DailyTaskData:initTaskData()
    
    local auto_msg = clone(self:getAutoMsg())

    self._score = 0  -- 当前任务积分
    self._boxs = self:changeBoxSeverData( auto_msg, 0, 0 )
    self:setRefershTime()
    self:setFlushTime(0)

    self:refershBoxState() -- 刷新建筑是否有未领取图标
end

-- 获取所有任务总积分
function DailyTaskData:getTotalScore()

    local totalScore = 0
    for _,v in pairs(self._tasks) do
        local taskData = luaCfg:get_daily_task_by(v.id)
        if taskData then 
            totalScore = totalScore + taskData.taskRound*taskData.integral
        end 
    end
    return totalScore
end

function DailyTaskData:getTasks()
    return self._tasks
end

function DailyTaskData:getNextFlushTime()
    -- body
    return self._nextFlushTime
end

-- 当前积分
function DailyTaskData:getScore()
    return  self._score or 0
end
-- 原积分
function DailyTaskData:setPreScore()
    self._perScore = self._score
end
function DailyTaskData:getPreScore()
    return self._perScore
end

function DailyTaskData:getBoxs()
    -- body
    return self._boxs
end

function DailyTaskData:isCanFlush()
    -- body
    local lockNum, qualityNum = 0, 0
    local strErrorKey = "nil" 

    for i,v in ipairs(self._tasks) do

        local taskData = luaCfg:get_daily_task_by(v.id)
        if v.state == WDEFINE.DAILY_TASK.TASK_STATE.LOCK  or v.state == WDEFINE.DAILY_TASK.TASK_STATE.GETD then
            lockNum = lockNum + 1
            qualityNum = qualityNum + 1
        else
            if taskData.quality >= global.dailyTaskData:getLockQualityLv() then
                qualityNum = qualityNum + 1
            end
        end
        
        if v.state == WDEFINE.DAILY_TASK.TASK_STATE.WORKING then

            if taskData.quality < global.dailyTaskData:getLockQualityLv() then
                strErrorKey = "nil"
                return strErrorKey
            end
        end
    end

    if lockNum >= #self._tasks then
        strErrorKey = "DailyTaskLock"
    end

    if qualityNum >= #self._tasks then
        strErrorKey = "DailyTaskMax"
    end

    return strErrorKey 
end

function DailyTaskData:addWaitList()
    self.waitList = self.waitList or 0
    self.waitList = self.waitList + 1
end

function DailyTaskData:cleanWaitList()
    self.waitList = 0
end

function DailyTaskData:getTaskGift(data)
    -- body
    for i,v in ipairs(self._tasks) do
        if v.sort == data.sort then
            self._tasks[i] = data
        end
    end

    self.waitList = self.waitList - 1
    if self.waitList == 0 then
       gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH)
    end
end

function DailyTaskData:getBoxGift(id)
    -- body
    self._boxs[id].state = WDEFINE.DAILY_TASK.TASK_STATE.GETD
    gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH)
end

function DailyTaskData:getTextColor(quality)

    local colors = {
    
        [1] = {r = 255,g = 226,b = 165},  -- 默认
        [2] = {r = 87,g = 213,b = 63},    -- 绿色
        [3] = {r = 255,g = 208,b = 65},   -- 黄色
        [4] = {r = 232,g = 67,b = 237},   -- 紫色
        [5] = {r = 255,g = 120,b = 54},   -- 橙色
    }

    local colorRGB = cc.c3b(colors[quality].r, colors[quality].g, colors[quality].b)
    return colorRGB
end

-- 当前可领取的任务个数
function DailyTaskData:getFinishTask()

    local num = 0
    for _,v in pairs(self._tasks) do
        if v.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE  then
            num = num + 1
        elseif v.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE  then

        end
    end
    return num
end

-- 是否有未完成的任务
function DailyTaskData:isHaveTask()

    local isHaveTask, isCanFlush = false, false
    for _,v in pairs(self._tasks) do
        if v.state == WDEFINE.DAILY_TASK.TASK_STATE.WORKING  or v.state == WDEFINE.DAILY_TASK.TASK_STATE.LOCK then
            isHaveTask = true
        end
        if v.state ~= WDEFINE.DAILY_TASK.TASK_STATE.GETD then
            isCanFlush = true
        end
    end
    return isHaveTask, isCanFlush
end

-----------------------/- 每日任务 -/-----------------------------


-----------------------/- 宝箱 -/-----------------------------

function DailyTaskData:initRewardBagState(msg)
 
    self.bagState = 0
    self.freeBagNum = 0
    self.wildNum = 0
    self.freeLeftTime = 0
    self.vipLeftTime = 0
    self.lastFreeMsg = {}       -- 记录最新的免费宝箱数据
    self.vipBagMsg = {}

    self.freeCostCout =0 
    self.monsterCostCout = 0

    msg.tgPacks = msg.tgPacks or {}
    if msg.tgPacks[1] then
        self:initFreeBagNum(msg.tgPacks[1])
        self:initVipBagNum(msg.tgPacks[2])
    end
end

function DailyTaskData:initFreeBagNum( msg , checkTime)

    if not msg then return end
    
    local freeData = luaCfg:get_free_chest_by(1) 

    local  timeSpace = freeData.time*60

    if checkTime then --时间误差 1 

        local lived_time = global.dataMgr:getServerTime()- msg .lLast

        local temp_time = (lived_time) % timeSpace

        if  temp_time > timeSpace-10 then 

            msg.lLast =   msg.lLast -(timeSpace- temp_time)

        else 
            msg.lLast = msg.lLast + temp_time
        end 

    end 

    if self.checktime then -- 本地时间 与服务器时间 有误差
        msg.lLast  = global.dataMgr:getServerTime()
        self.checktime = false 
    end 

    self.lastFreeMsg = msg or {}

    if not  msg.lLast then 
        -- protect 
        return 
    end    

    local freeTime = global.dataMgr:getServerTime() - msg.lLast

    self.freeBagNum = math.floor(freeTime/timeSpace)

    if self.freeBagNum < 0 then self.freeBagNum = 0 end
    
    self.freeLeftTime = timeSpace - (freeTime - self.freeBagNum*timeSpace)

    self.freeBagNum = self.freeBagNum + msg.lParam

    if self.freeBagNum > freeData.max then 

        self.freeBagNum = freeData.max 

    end

    self.freeCostCout = msg.lcount   or   self.freeCostCout
end



function DailyTaskData:reSertCostCount()

    self.freeCostCout =0

    self.monsterCostCout = 0

end 

function DailyTaskData:initVipBagNum( msg  , checkTime)

    self.vipBagMsg = msg or {}

    local wildData = luaCfg:get_wild_chest_by(2)
    if msg.lParam > wildData.num then
        msg.lParam = wildData.num
    end

    self.wildNum = msg.lParam

    if  checkTime  then   --消除时间误差处理。

        msg.lLast  = global.dataMgr:getServerTime() - wildData.time*60 - 1 

    end

    if self.checkVipTime then --点击宝箱 时间误差 处理

        print("点击vip 宝箱 时间 误差 处理。//////////")

         msg.lLast = global.dataMgr:getServerTime()

        self.checkVipTime = false
    end


    self.vipLeftTime = msg.lLast

    self.monsterCostCout = msg.lcount  or self.monsterCostCout
end

function DailyTaskData:setWildTimes(times)

    local wildData = luaCfg:get_wild_chest_by(2)
    if times > wildData.num then
        times = wildData.num
    end
    self.wildNum = times
end

function DailyTaskData:getWildTimes()
    
    return self.wildNum
end

function DailyTaskData:getLastFreeMsg()
    
    return self.lastFreeMsg
end

function DailyTaskData:getLastVipMsg()
    
    return self.vipBagMsg
end

function DailyTaskData:getBagState()
    
    return self.bagState
end

function DailyTaskData:getRestTime()
    
    return self.freeLeftTime
end

function DailyTaskData:getWildRestTime()
    
    return self.vipLeftTime
end

function DailyTaskData:setWildRestTime(time)
    
    self.vipLeftTime = time
end

function DailyTaskData:getFreeBagNum()
    
    return self.freeBagNum
end

function DailyTaskData:getFreeCostCout()

    return self.freeCostCout
end 

function DailyTaskData:getMonsterCostCout()

    return self.monsterCostCout
end 

function DailyTaskData:setBagState( freeNum, wildNum )

    self.wildNum = wildNum
    self.freeBagNum = freeNum

    local vipNum = 0
    local wildData = luaCfg:get_wild_chest_by(2)
    if wildNum >= wildData.num then
        vipNum = 1
    end
    
    if freeNum == 0 and vipNum == 0 then
        self.bagState = 0
    elseif vipNum > 0 then
        self.bagState = 2
    elseif freeNum > 0 and vipNum == 0 then
        self.bagState = 1
    end

end

function DailyTaskData:checkIsCanWild()

    if not self.vipLeftTime then return false end  --直通车前不处理
    
    local wildData = luaCfg:get_wild_chest_by(2)
    local spaceTime = global.dataMgr:getServerTime() - self.vipLeftTime
    if spaceTime > wildData.time*60 then
        return true
    else
        return false
    end
end

-----------------------/- 宝箱 -/-----------------------------



----------------------/- 体力刷新次数 -/-------------------
function DailyTaskData:initStrength(msg)
    -- body
    self.buyStrengthTimes = 0
    if msg.tgBuyCount and msg.tgBuyCount.lBuyLord then
        self:setBuyStrengthTimes(msg.tgBuyCount.lBuyLord)
    end
end

function DailyTaskData:setBuyStrengthTimes(bugTimes)
    self.buyStrengthTimes = bugTimes
end

function DailyTaskData:getBuyStrengthTimes()
    return self.buyStrengthTimes 
end
----------------------/- 体力刷新次数 -/-------------------


----------------------- 每日签到 --------------------
function DailyTaskData:initRegister(msg)
    -- body
    self.tgSignInfo = {}
    self.isFirstOnEnter = true
    self:setTagSignInfo(msg.tgSignInfo)
end

function DailyTaskData:setTagSignInfo(tgSignInfo)

    if not tgSignInfo then return end
    -- 新号签到跳过 隔天重置处理
    if tgSignInfo.lSignID and tgSignInfo.lSignID == 1 then 
    else
        if self:getCurDay(tgSignInfo.lLastSign) > 1 then 
            tgSignInfo.lSignCnt = 0
            tgSignInfo.lLastSign = 0
        end
    end
    self.tgSignInfo = tgSignInfo or {}
end

function DailyTaskData:getTagSignInfo()
    
    return self.tgSignInfo
end

function DailyTaskData:setIsFirstOnEnter()
    self.isFirstOnEnter = false
end
function DailyTaskData:getIsFirstOnEnter()
    return self.isFirstOnEnter
end


-- 获取当前是同一天(0 同一天  1 第二天   >1 隔天)
function DailyTaskData:getCurDay(time)

    if not time then return 0 end
    local server = self:getZeroTimes(global.dataMgr:getServerTime())
    local cur = self:getZeroTimes(time) or global.dataMgr:getServerTime()

    local DAY = chat_cfg.FORTIME.DAY
    local flagValue = math.abs(server - cur)/DAY
    return flagValue
end

-- 当前时间当天0点时间戳
function DailyTaskData:getZeroTimes(time)

    if time then 
        local curZero = global.userData:getZeroTime() + 24*3600
        local curZeroTemp = global.funcGame.formatTimeToTime(curZero, true) 
        local currTimeTb = global.funcGame.formatTimeToTime(time, true) or {}
        currTimeTb.hour = currTimeTb.hour or 0
        currTimeTb.minute = currTimeTb.minute or 0
        currTimeTb.second = currTimeTb.second or 0
        local zeroTime = time + (24+curZeroTemp.hour - currTimeTb.hour)*3600 - currTimeTb.minute*60 - currTimeTb.second
        return math.floor(zeroTime)
    end 
end

function DailyTaskData:getCurZeroTime()
    
    return  global.userData:getZeroTime() + 16*3600
end

-- 时间戳汇总
function DailyTaskData:setTimestamp(tagTime)
    dump(tagTime,"-------------------------》")
    self.tagTime = tagTime or {}
    global.unionData:setAllyCdTime(self.tagTime.lAllyLimtTime or 0)
end
function DailyTaskData:getTimestamp()
    return self.tagTime or {}
end

-- 获取建号时间
function DailyTaskData:getBornTime()
    return self.tagTime.lBornTime
end

-- 获取英雄谕令转盘免费倒计时
function DailyTaskData:getFreeLotteryTime()
    return self.tagTime.lFreeLotteryTime
end

-- 获取开服时间
function DailyTaskData:getOpenServerTime()
    return self.tagTime.lOpenServerTime
    -- return global.dataMgr:getServerTime()
end

global.dailyTaskData = DailyTaskData.getInstance()

return DailyTaskData
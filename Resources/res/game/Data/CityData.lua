local global = global
local luaCfg = global.luaCfg

local _M = {
    buildings = {},
    buildList = {},
    queueList = {}, 
}

-- tgBuilds = {
--     [1] = {
--         lBuildID = 1,
--         lGID = 1,
--         lGrade = 1,
--         lPosX = 918,
--         lPosY = 1802,
--         lStatus = 2,
--     },
-- },
local RES_BUILDING_TYPES = {3,9,10,11}
function _M:init(buildings)
    -- dump(buildings,"buildings")
    buildings = buildings or {}
    if self.buildings and table.nums(self.buildings) > 0 then
    else
        local i_buildings = clone(luaCfg:buildings_pos())
        self.buildings = {}

        --用来存放资源自动增长数据
        self.resStartSvrTime = global.dataMgr:getServerTime()
        self.resBuildingsData = {}

        for _idx,v in pairs(i_buildings) do
            local raceBuildingId = 16+1000*global.userData:getRace()
            if v.buildingType == 16 and v.id ~= raceBuildingId then
            else
                v.serverData = {} 
                v.serverData.lStatus = v.done
                v.serverData.lGrade = v.level
                self.buildings[v.id] = v
            end
        end
    end

    for _idx,v in pairs(buildings) do 
        if v.lBuildID then
            self.buildings[v.lBuildID].serverData = self.buildings[v.lBuildID].serverData or {}
            table.assign(self.buildings[v.lBuildID].serverData,buildings[_idx])
        end
    end
    
end

function _M:updateBuildings(buildings)
    local i_buildings = buildings or {}
    for _idx,v in pairs(i_buildings) do
        if v.lBuildID then
            self.buildings[v.lBuildID].serverData = self.buildings[v.lBuildID].serverData or {}
            table.assign(self.buildings[v.lBuildID].serverData,buildings[_idx])
        end
    end
end

-- 根据士兵id获取对应的建筑id
function _M:getBuildingIdBySoldierId(soldierId)
    local soldierType = global.soldierData:getSoldierTypeById(soldierId)
    if not soldierType then
        log.error("not soldiertype get by id=%s！",soldierId)
        return nil
    end
    for _idx,v in pairs(self.buildings) do
        if v.soldierType == soldierType then
            return v.id,v
        end
    end
end

function _M:localNotify()
    -- 本地推送 v.serverData.lBdTrain 士兵  城防
    for _ , v in pairs(self.buildings) do 
        if v and v.serverData and   v.serverData.lBdTrain then 
            for _ , vv in pairs(v.serverData.lBdTrain) do 
                local soldierData = luaCfg:get_soldier_train_by(vv.lSID) 
                self:checkType(soldierData , vv)
            end
        end 
    end
    -- dump(self.builders)
    -- 建筑队列
    for i=1 , 3  do 
        if self.builders[i] and self.builders[i].serverData then
             local v = self.builders[i].serverData
            global.ClientStatusData:recordNotifyData(4,v.lRestTime,v.lStartTime)
        end 
    end

    -- dump(self.buildings)
    print("-- 石头 木材 矿石")
    -- 石头 木材 矿石
    for _ ,v in pairs(global.EasyDev.FRAM_ID)  do 
        for _ ,vv in pairs(self.buildings)  do 
            if v == vv.buildingType then 
                self:Fram(vv)
            end 
        end 
    end 
end 

function _M:Fram(data)
    -- dump(data,"vv")
    local outputData = self:getOutputDataByTypeAndLv(data.buildingType,data.serverData.lGrade)
    -- dump(outputData,"dump(outputData)")
    m_totalProduce = outputData.totalProduce
    local perNumForS = outputData.perProduce/global.define.HOUR
    if data.serverData.lBdRes == nil  then  return  end -- 没有开启 则返回
    local m_startServerTime = data.serverData.lBdRes.lInit
    local currServerTime = global.dataMgr:getServerTime()
    m_output = (currServerTime- m_startServerTime)*perNumForS
    m_outputTime = (currServerTime- m_startServerTime)
    local time = m_totalProduce -m_output
    -- --资源 农田 id 
    -- self.FRAM_ID ={11,3,9,10}
    local record_type = nil 
    if data.buildingType == 10 then -- 石矿
        record_type = 8
    elseif data.buildingType == 11 then -- 金矿
        record_type = 7
    elseif data.buildingType == 3 then --农田
        record_type = 5
    elseif data.buildingType == 9 then --伐木场
        record_type = 6
    end 
    global.ClientStatusData:recordNotifyData(record_type,time*60,global.dataMgr:getServerTime())
end 

_M.res_type={9,10,11}
_M.type = {
        [1] ={ key= "soldiers" ,data = {1,2,3,4,5} }, 
        [2]= { key= "city" ,data = {6,7} },
    } 

function _M:checkType(soldierData , train_data)
    -- dump(soldierData,"soldierData")
    if not soldierData  then  return end
    local time = train_data.lEndTime - train_data.lStartTime 
    for _ ,v in pairs(self.type) do 
        for _ , vv in pairs(v.data) do
            if  soldierData.type == vv then 
                local record_type = nil 
                if v.key == "soldiers" then
                    record_type  =1
                elseif  v.key == "city" then 
                    record_type = 3 
                end 
                global.ClientStatusData:recordNotifyData(record_type,time,train_data.lStartTime)
                break
            end 
        end 
    end 
end

-- tgBuilders = {
--     [1] = {
--         lID = 3,
--         lRestTime = 1474354651,
--         lStartTime = 1474354555,
--     },
-- },
---------------------------------------建造队列--------------------------------------------
function _M:initBuilders(builders)
    local serverBuilders = builders or {}
    if self.builders and table.nums(self.builders) > 0 then
    else
        self.builders = clone(luaCfg:build_queue())
        for _idx,v in pairs(self.builders) do
            v.serverData = {}
            v.serverData.lID = v.queueId
            v.serverData.lRestTime = 0
            v.serverData.lStartTime = 0
        end
    end

    for _idx,v in pairs(serverBuilders) do
        if v.lID <= 3 then
            self.builders[v.lID].serverData = self.builders[v.lID].serverData or {}
            table.assign(self.builders[v.lID].serverData,serverBuilders[_idx])
        end
    end

    gevent:call(global.gameEvent.EV_ON_BUILDIERS_UPDATE)
end

--     message Queue
-- {
--     required int32      lID         = 1;//队列id
--     optional uint32     lRestTime   = 2;//剩余时长 秒
--     optional uint32     lStartTime  = 3;//开启时时间戳
--     optional uint32     lTotleTime  = 4;//总的时间时长
--     optional int32      lBindID = 5;//绑定ID
-- }

function _M:cleanBuidersCD(id , time)

    dump(self.builders ,"sdfsdf")

    if self.builders and  self.builders[id].serverData.lTotleTime then 

        self.builders[id].serverData.lTotleTime  = self.builders[id].serverData.lTotleTime  - time

        self.builders[id].serverData.lRestTime  = self.builders[id].serverData.lRestTime -  time

        gevent:call(global.gameEvent.EV_ON_BUILDIERS_UPDATE)
        
    end 
end 


function _M:initQueue( queueState )
    queueState = queueState or {}
    self.queueList = self.queueList or {}

    table.assign(self.queueList,queueState)
    gevent:call(global.gameEvent.EV_ON_BUILDIERS_UPDATE)
end

function _M:getQueue()

    return self.queueList
end

function _M:getQueueById( _queueId )
    -- dump(self.queueList,"###########_queueId=".._queueId)
    for _,v in pairs(self.queueList) do
        
        if v.lID == _queueId then
            return v
        end
    end
end

function _M:setQueueById( _queueId,data )

    for k,v in pairs(self.queueList) do
        
        if v.lID == _queueId then
            table.assign(self.queueList[k],data)
        end
    end
end

function _M:canBuildInOpened(cost)
    local can = false
    local queue = self.queueList[3] or {}
    local currTime = global.dataMgr:getServerTime()
    queue.lRestTime = queue.lRestTime or currTime
    local rest = queue.lRestTime - currTime
    if cost <= rest then
        can = true
    end
    return can
end
----------------------------------------------------------------------------------------

function _M:getBuildings()    
    return self.buildings
end

-- 是否有建筑可以被建造
function _M:isShowBuildRed()
    for _idx,v in pairs(self.buildings) do
        local i_buildingType = v.buildingType
        if i_buildingType == 16 then
            local bid = self:getBuildingType(i_buildingType)
            if v.id == bid and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
                local isEnough = self:checkCondition(v)
                if isEnough then
                    return true
                end
            end
        else
            if v.buildingType == i_buildingType and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
                local isEnough = self:checkCondition(v)
                if isEnough then
                    return true
                end
            end
        end
    end
    return false
end

function _M:getBuildList()
    local list = {}
    local buildSeq = luaCfg:buildings_list()
    for _idx,v in pairs(buildSeq) do
        local buildingData = self:getBuildByType(v.id)
        if buildingData then
            table.insert(list,v)
        end
    end
    table.sort(list,function(a,b)
        return a.listOrder<b.listOrder
    end)
    return list
end

function _M:isBuildAllOver()
    local list = self:getBuildList()
    return #list <= 0
end

function _M:isBuildingExisted(id)
    for _idx,v in pairs(self.buildings) do
        if v.id == id then
            return (v.serverData.lStatus ~= WDEFINE.CITY.BUILD_STATE.BLANK)
        end
    end
    return false
    -- assert(false,"没有找到对应的建筑类型的建造建筑i_buildingType="..i_buildingType)
end

--跟建筑类型获取要建造的建筑信息
function _M:getBuildByType(i_buildingType)
    for _idx,v in pairs(self.buildings) do
        if i_buildingType == 16 then
            local bid = self:getBuildingType(i_buildingType)
            if v.id == bid and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
                return v
            end
        else
            if v.buildingType == i_buildingType and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
                return v
            end
        end
    end
    -- assert(false,"没有找到对应的建筑类型的建造建筑i_buildingType="..i_buildingType)
end

function _M:getBuildingById(i_id)    
    for id,v in pairs(self.buildings) do
        if i_id == id then
            return v
        end
    end
    --assert(false,"没有找到对应的等级的建筑信息id="..i_id)
end

function _M:setNewLvDataBy(i_id,i_data)
    if not i_data then return end
    --更新buildings_pos读取出的内存数据，从buildings_lvup中取出有用的数据
    for id,v in pairs(self.buildings) do
        if i_id == id then
            v.name = i_data.new_name
            v.triggerId = i_data.triggerId
            v.resource = i_data.resource
            v.time = i_data.time
            v.serverData.lGrade = i_data.level
        end
    end
    -- gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)
end

function _M:setBuildingLvById(i_id,i_lv)    
    for id,v in pairs(self.buildings) do
        if i_id == id then
            self.buildings[id].serverData.lGrade = i_lv
            break
        end
    end
    gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)
end

function _M:setServerDataById(i_id,i_data,i_isMerge)    
    i_data = i_data or {}
    for id,v in pairs(self.buildings) do
        if i_id == id then
            if i_isMerge then
                table.deepMerge(self.buildings[id].serverData, i_data)
            else
                table.assign(self.buildings[id].serverData, i_data)
            end
            break
        end
    end

    gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE, i_id)
end

function _M:setBdResById(i_id,i_data)    
    for id,v in pairs(self.buildings) do
        if i_id == id then
            self.buildings[id].serverData.lBdRes = i_data
            break
        end
    end
    -- gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)
end

function _M:checkCanUpgrade(data)
    local newData = self:getBuildingDataByLvAndId(data.id,data.serverData.lGrade+1)
    if newData then
        local isEnough = self:checkCondition(newData)
        return isEnough
    else
        return nil
    end
end

-- 获取珠宝等级
function _M:getMainCityLevel()
    
    local data = global.cityData:getTopLevelBuild(1)
    
    if data then

        return data.serverData.lGrade
    end

    return 1
end

function _M:checkCondition(data)
    local a1 = self:checkTriggers(data.triggerId)
    local a2 = self:checkResources(data.resource)
    return (a1 and a2)
end

function _M:checkTriggers(triggerIds)
    local isEnough = true
    for i,v in ipairs(triggerIds) do
        isEnough = self:checkTrigger(v)
        if not isEnough then
            return isEnough
        end
    end
    return isEnough
end

function _M:checkBuildLv(buildsId, conditLv)

    local isOpen = false
    for _idx,v in pairs(self.buildings) do
        if v.id == buildsId then
            if (v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED) and (v.serverData.lGrade >= conditLv) then
                isOpen = true
            end
        end
    end
    return isOpen
end

function _M:checkBuildLv1(buildsId, conditLv)

    local isOpen = false
    for _idx,v in pairs(self.buildings) do
        if v.id == buildsId then
            if (v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED) and (v.serverData.lGrade == conditLv) then
                isOpen = true
            end
        end
    end
    return isOpen
end



function _M:checkTrigger(triggerId)
    local triggerData = luaCfg:get_triggers_id_by(triggerId)
    local isEnough = false
    if triggerData then
        for _idx,v in pairs(self.buildings) do
            if v.buildingType == triggerData.buildsId then
                if (v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED) and (v.serverData.lGrade >= triggerData.triggerCondition) then
                    isEnough = true
                end
            end
        end
    end
    return isEnough
end

function _M:checkResources(resources)
    if not resources then return true end
    if type(resources) ~= 'table' then return true end

    local isEnough = true
    for i=1,#resources do
        local resource = resources[i]
        isEnough = isEnough and self:checkResource(resource)
    end
    return isEnough
end

function _M:checkResource(resource)
    if not resource or not resource[1] then return true end
    local id = resource[1]
    local num = resource[2]
    local isEnough,dnum = global.propData:checkEnough(id,num)
    return isEnough,dnum
end

function _M:getTopLevelBuild(i_buildingType)
    -- body

    local maxLevel = -1
    local res = nil

    for id,v in pairs(self.buildings) do
        if v.buildingType == i_buildingType and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
            
            if v.serverData.lGrade > maxLevel then

                maxLevel = v.serverData.lGrade
                res = v
            end
        end
    end

    return res
end

function _M:getBuildingDataByLvAndId(i_id,i_lv)
    local comId = i_id*1000+i_lv
    local data = luaCfg:get_buildings_lvup_by(comId)
    return data
end

function _M:getOutputDataByTypeAndLv(i_type,i_lv)
    local comId = self:getBuildingsInfoId(i_type,i_lv)
    local data = luaCfg:get_buildings_resource_by(comId)
    return data
end

---------------------------------公用id获取--------------------------------------------
function _M:getBuildingType(i_type)
    local id = i_type
    if i_type == 16 then
        local race = global.userData:getRace()
        --家族建筑特殊处理
        id = (race*1000+i_type)
    end
    return id
end

function _M:getBuildingsInfoId(i_type,i_lv)
    local i_type = self:getBuildingType(i_type)
    local id = i_type*1000+i_lv
    return id
end

---------------------------------建筑队列相关--------------------------------------------

function _M:getBuilders()    
    return self.builders
end

function _M:getBuilderBy(i_id)
    local temp = self.builders[i_id]
    return temp
end

function _M:setBuilderBy(i_id,i_data)
    local builder = self.builders[i_id]
    if builder then
        builder.serverData = i_data
    end
end

---------------------------------训练队列相关--------------------------------------------

-- 训练完成的士兵检测
function _M:checkFinishCamp()
    -- body
    local checkCall = function (data)
        -- body
        local lBdTrain = data.serverData.lBdTrain
        for _,v in pairs(lBdTrain) do

            local totalTime = v.lEndTime-v.lStartTime
            local totalNum = v.lCount
            local currServerTime = global.dataMgr:getServerTime()
            local endTime = v.lEndTime
            local startTime = v.lStartTime

            local listId = data.id .. v.lSID
            if (currServerTime >= endTime or totalTime <= 0) and (not global.finishData:checkSpecList(listId)) then

                global.finishData:addSpecList(listId)
               
                local soldierTrainData = luaCfg:get_soldier_train_by(v.lSID)
                local data = {listId=listId, param={id=2, args={soldierTrainData.name}}}
                global.finishData:addFinshList(data)
                                         
            end
        end
    end

    local allBuild = luaCfg:buildings_pos()
    for _,v in pairs(allBuild) do
        if v.soldierType > 0 then
            local buildData = self:getBuildingById(v.id)
            if buildData.serverData and buildData.serverData.lBdTrain then               
                checkCall(buildData)    
            end
        end
    end

end

-- 资源已满
function _M:checkFinishFarm()

    local checkCall = function (data)
        -- body
        local outputData = self:getOutputDataByTypeAndLv(data.buildingType,data.serverData.lGrade)
        if not outputData then return end

        local m_totalProduce = outputData.totalProduce
        local m_minSec = outputData.minMinute
        local perNumForS = outputData.perProduce/global.define.HOUR
        local m_startServerTime = data.serverData.lBdRes.lInit

        local currServerTime = global.dataMgr:getServerTime()
        local m_output = (currServerTime-m_startServerTime)*perNumForS
        --总时间-目前为止要到最大值需要的时间+到现在已经过去的时间
        local m_outputTime = (currServerTime-m_startServerTime)

        local stepData = luaCfg:get_guide_stage_by(2)
        if global.userData:getGuideStep() == stepData.Key and data.id == stepData.data1 then
        else

            local listId = data.id
            if m_output >= m_totalProduce and (not global.finishData:checkSpecList(listId)) then 

                global.finishData:addSpecList(listId)

                local data = {listId=listId, param={id=3, args={data.buildsName}}}
                global.finishData:addFinshList(data) 

            end
        end 
    end

    local isResBuild = {[3]=3, [9]=9, [10]=10, [11]=11}
    local allBuild = luaCfg:buildings_pos()
    for _,v in pairs(allBuild) do
        if isResBuild[v.buildingType] then
            local buildData = self:getBuildingById(v.id)
            local isBuilded =  buildData.serverData and buildData.serverData.lStatus ~= WDEFINE.CITY.BUILD_STATE.BLANK
            if isBuilded and buildData.serverData.lBdRes then              
                checkCall(buildData)    
            end
        end
    end
end


-- 任意兵营有300士兵可领取
function _M:getHaveBuildTrainFinish(targetNum)

    local checkFinishCall = function (lBdTrain)
        -- body
        local numTb = {}
        for _,v in pairs(lBdTrain) do

            local harverNum = 0
            local totalTime = v.lEndTime-v.lStartTime
            local totalNum = v.lCount
            local currServerTime = global.dataMgr:getServerTime()
            local endTime = v.lEndTime
            local startTime = v.lStartTime
            if currServerTime >= endTime or totalTime <= 0 then
                harverNum = totalNum
            else 
                local leftTime = currServerTime-startTime
                if leftTime < 0 then leftTime = 0 end
                harverNum = math.floor((leftTime*totalNum)/totalTime)
            end
            table.insert(numTb, harverNum)
        end

        if table.nums(numTb) > 0 then
            table.sort(numTb, function(s1, s2) return s1 > s2 end)
            return  numTb[1]
        else
            return 0
        end
    end

    local allBuild = luaCfg:buildings_pos()
    for _,v in pairs(allBuild) do
        if v.soldierType > 0 then
            local buildData = self:getBuildingById(v.id)
            if buildData.serverData and buildData.serverData.lBdTrain then               
                local harver = checkFinishCall(buildData.serverData.lBdTrain)
                if harver >= targetNum  then
                    return true
                end      
            end
        end
    end
    return false
end

-- 检测正在训练的队列（排除已完成队列）
function _M:getTrainingNum(queueData)
    
    local flag = 0
    for _,v in pairs(queueData) do       
        if v.lEndTime then
            local curTime = global.dataMgr:getServerTime()
            local endTime = v.lEndTime
            if endTime > curTime then
                flag = flag + 1
            end
        end
    end
    return flag
end

function _M:getTrainListById(buildingId, queueId)
    local buildingData = self.buildings[buildingId]
    if buildingData and  buildingData.serverData.lBdTrain then
        for i,v in ipairs(buildingData.serverData.lBdTrain) do
            if v.lID == queueId then
                return v
            end
        end
    end
end

function _M:getTrainList(buildingId)
    local buildingData = self.buildings[buildingId]
    -- log.debug("#######:getTrainList buildingId=%s,buildingData=%s",buildingId,vardump(buildingData))
    return buildingData.serverData.lBdTrain or {}
end

function _M:setTrainList(buildingId,data)
    -- 自定义唯一id
    data = data or {}
    if not data.queueId then
        data.queueId = data.lID
    end
    local buildingData = self.buildings[buildingId]
    if buildingData.serverData.lBdTrain then

        for i,v in ipairs(buildingData.serverData.lBdTrain) do
            if v.lID == data.queueId then
                buildingData.serverData.lBdTrain[i] = data
                return true
            end
        end
    else
        self.buildings[buildingId].serverData.lBdTrain = {}
    end
    table.insert(self.buildings[buildingId].serverData.lBdTrain,data)
    return true
end

function _M:removeTrainList(queueId, buildingId)

    local buildingData = self.buildings[buildingId]
    if buildingData.serverData.lBdTrain then
        for i,v in ipairs(buildingData.serverData.lBdTrain) do
            if v.lID == queueId then
                table.remove(buildingData.serverData.lBdTrain, i)
                return true
            end
        end
    end
end

--------------------------------城墙设备队列相关-----------------------------------------
function _M:getDeviceList(buildingId)
    local buildingData = self.buildings[buildingId]
    return buildingData.serverData.lBdBuild or {}
end

function _M:setDeviceList(buildingId,data)
    local buildingData = self.buildings[buildingId]
    if buildingData.serverData.lBdBuild then
        for i,v in ipairs(buildingData.serverData.lBdBuild) do
            if v.lID == data.lID then
                buildingData.serverData.lBdBuild[i] = data
                return true
            end
        end
    else
        buildingData.serverData.lBdBuild = {}
    end
    table.insert(buildingData.serverData.lBdBuild,data)
    return true
end

------------------------------------获取所有已经建好的建筑信息--------------------------------------
function _M:getRegistedBuild()
    
    local registerBuild = {}
    for id,v in pairs(self.buildings) do
        if v.serverData.lStatus == 2 then
            table.insert(registerBuild, v)
        end
    end
    return registerBuild
end

------------------------------------资源定时增加处理--------------------------------------
-- function _M:updateRes() 
-- end

-- function _M:stopUpdateResScheduler()
--     if self.m_countDownTimer then
--         gscheduler.unscheduleGlobal(self.m_countDownTimer)
--     end
-- end

------------------------------------建造队列免费时间--------------------------------------
local MIN_FREE_ACCERATE_TIEM = 5*60

function _M:getFreeBuildTime()    
    
    local free = MIN_FREE_ACCERATE_TIEM
    local vipfreetime =  global.vipBuffEffectData:getCurrentVipLevelEffect(3079).quantity or 0
    free = vipfreetime*60 + free
    return free
end

global.cityData = _M
local luaCfg = global.luaCfg

local _M = {}

function _M:init(msg)   
    
    if self.lastEffectData and table.nums(self.lastEffectData) > 0 then
    else
        self.lastEffectData = nil
        self:setRershEffect(self:changeServerData({}))
        self.isFirstData = nil
    end
end

function _M:isFirstInit()
    return (self.isFirstData == nil)
end
function _M:setFirstInit()
    self.isFirstData = {1}
end

function _M:setRershEffect(achiData)
    --第一次进游戏初始化数据
    self.lastEffectData = clone(achiData)
    for _,v in pairs(self.lastEffectData) do
        v.effectFlag = v.serverRound
    end
end

function _M:refershEffectData(msg)

    self:setFirstInit()
    for _,v in pairs(self.lastEffectData) do
        for _,vv in pairs(msg) do
            
            if v.typeId == vv.typeId and vv.serverRound > v.effectFlag then
                vv.effectFlag =  vv.serverRound
                v.effectFlag = vv.effectFlag
                break
            end
        end
    end

end

function _M:getEffectFlag(typeId)
    
    for _,v in pairs(self.lastEffectData) do
        
        if v.typeId == typeId then
            return v.effectFlag
        end
    end
end


function _M:changeServerData(server, isChange)

    -- dump(server, "######>>>>>>>>> server: ")
    if not isChange then
        self:initAcmNum(server or {})
    end

    -- 提取类型中未领取轮次最小
    local serdata = {}
    if server then
        local achi = luaCfg:achievement()
        for i=1,table.nums(achi) do
            
            local tempType = {}
            for _,v in pairs(server) do
                
                local ach = luaCfg:get_achievement_by(v.lID) 
                if i==ach.typeId then
                    v.roundId = ach.roundId
                    table.insert(tempType, v)
                end
            end
            if #tempType > 0 then 
                table.sort( tempType, function(s1, s2) return s1.roundId < s2.roundId end )

                tempType[1].roundId = tempType[#tempType].roundId
                if tempType[#tempType].lState == 0 then
                    tempType[1].roundId = tempType[1].roundId - 1
                end
                table.insert(serdata, tempType[1]) 
            end
        end
    end

    -- dump(serdata, "######>>>>>>>>> serdata: ")

    -- 初始化任务
    local round = {}
    local data = luaCfg:achievement()
    for _,v in pairs(data) do
        if v.roundId == 1 then

            v.lID = v.id
            v.lState = 0
            v.lProgress = 0
            v.serverRound = 0
            v.effectFlag = 0
            table.insert(round, v)
        end
    end

    for _,v in pairs(serdata) do

        local temp = luaCfg:get_achievement_by(v.lID)
        for _,value in pairs(round) do
            
            if temp.typeId == value.typeId then

                value.lID = v.lID
                value.lState = v.lState
                value.lProgress = v.lProgress
                value.serverRound = v.roundId
                value.effectFlag = self:getEffectFlag(temp.typeId)          -- 0 不播放特效
            end
        end
    end
    table.sort( round, function(s1, s2) return s1.lID < s2.lID end )
    return round
end


function _M:setAcieveNum(num)
    self.achieveNum = num
end

function _M:getAcieveNum()
    return self.achieveNum or 0
end

-- 当前是否有完成的成就 
function _M:isFinishAchieve()

    global.taskApi:getAchieveTaskList(function (msg)

        msg.tgTasks = msg.tgTasks or {}
        self:initAcmNum(msg.tgTasks)
    end) 
end

function _M:initAcmNum(tgTasks)

    local count = 0
    for _,v in pairs(tgTasks) do     
        if v.lState == 1 then              
            count = count + 1
        end
    end
    self.achieveNum = count

    -- 完成的成就星星个数
    local completeNum = 0
    local serData =  self:changeServerData(tgTasks, true)
    for i,v in ipairs(serData) do
        if v.serverRound > 0 then
            completeNum = completeNum + v.serverRound
        end
    end
    self.completeNum = completeNum

    gevent:call(global.gameEvent.EV_ON_UI_ACM_UPDATE)
end

function _M:getCurCompleteNum()
    return self.completeNum or 0
end

function _M:addCacheID(id)

    self.cachid = self.cachid or {}
    table.insert( self.cachid , id )
end

function _M:deleteCacheID(id)

    table.removeItem( self.cachid or {} , id )
end 

function _M:checkPanel()

    local  panelName= {"UIWorldPanel" , "UICityPanel" } 

    if table.hasval(panelName , global.panelMgr:getTopPanelName()) then 

        if table.nums(self.cachid or {} ) > 0  and  not global.guideMgr:isPlaying() then 

            local id = self.cachid[1]

            self:deleteCacheID(id)

            local panel =  global.panelMgr:openPanel("UIAchieveRewardPanel")
            panel:setData(id)

        end 

    end 
end 



global.achieveData = _M
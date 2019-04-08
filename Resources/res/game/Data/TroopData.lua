
local _M = {
    isSecondPage = 0,
}

local luaCfg = global.luaCfg
local resMgr = global.resMgr

function _M:resetTb()
    self.soldierData = {}
    self.troopList = {}
    -- self.troop = {}
end

function _M:init(msg, stationTroop)

    self:resetTb()
    -- 自己部队
    if msg ~= nil then
        for _,v in pairs(msg) do
            if v.lID ~= 0 then
                self:addTroop(v)
            end
        end
    end
    -- 其他城驻防部队
    if stationTroop ~= nil then
        for _,v in pairs(stationTroop) do
            if v.lID ~= 0 then
                self:addTroop(v)
            end
        end
    end

    self:initData()

    gevent:call(global.gameEvent.EV_ON_UI_TROOP_REFERSH)
end

function _M:createNewItem()

     -- 新建部队选项
    local soldierData =  {}
    local userId = global.userData:getUserId()
    local  newItem = { lID=0, lUserID=userId, lHeroID={[1]=0},  szName="",  lCityID=0,  lState=0,  lTarget=0, tgWarrior={}}
    soldierData =  clone(global.soldierData:getSoldiers())
    
    for _,v in pairs(soldierData) do
        local tb_temp = {}
        tb_temp.lID =  v.lID
        tb_temp.lCount = 0
        tb_temp.lFrom =  0
        table.insert(newItem.tgWarrior, tb_temp)
    end
    table.insert(self.troopList, newItem)
    self:sortTroopList()
end

function _M:initData()

    --　列兵表
    local  _troop = {
      [1] = { id=1011,  name="攻击步兵",  pic="soldier/targaryen/infantry_atk.png",  perPop=1,  restNum=0, },
      [2] = { id=1012,  name="防御步兵",  pic="soldier/targaryen/infantry_def.png", perPop=1, restNum=25000, },
      [3] = { id=1021,  name="攻击弓兵",  pic="soldier/targaryen/archer_atk.png",  perPop=1,restNum=15500, },
      [4] = { id=1022,  name="防御弓兵",  pic="soldier/targaryen/archer_def.png", perPop=1, restNum=25000, },
      [5] = { id=1031,  name="攻击骑兵",  pic="soldier/targaryen/cavalry_atk.png", perPop=2, restNum=18000, },
      [6] = { id=1032,  name="防御骑兵",  pic="soldier/targaryen/cavalry_def.png",  perPop=3, restNum=40000, },
      [7] = { id=1041,  name="攻击法师",  pic="soldier/targaryen/mage_atk.png", perPop=6, restNum=25000, },
      [8] = { id=1042,  name="防御法师",  pic="soldier/targaryen/mage_def.png",  perPop=5,restNum=35000, },
    }

    -- 整编城市
    local _city = { "凯岩城", "鹰巢城", "奔流城", "黑城堡", }

    -- 校场士兵边界区域
    local _borderPos = {
        [1] = {1989,782,},  -- 左上角
        [2] = {2474,759,},  -- 右上角
        [3] = {2293,840,},  -- 最后部队位置
        [4] = {2264,649,},
    }

    -- 士兵左右间隔
    self.offsetPos = {
        [1] = {x=34, y=19,}, -- 部队
        [2] = {x=31, y=19,}, -- 士兵
    }

    -- 士兵前后间隔
    self.offset = {
        [1] = {x=50, y=25,},
        [2] = {x=25, y=12,},   --　普通士兵
        [3] = {x=55, y=26,},   --　骑兵
    }

    -- 每一行士兵数量
    self.lineNum = {
        [1] = {6, 7, 7, 11,},   -- 部队
        [2] = {4, 6, 8, 8,},    -- 骑兵
        [3] = {6, 8, 8, 8,},    -- 枪兵1，弓箭手2，法师4
    }
    self:resetData()

    self.troopSoldierList = _troop
    self.cityList = _city
    self.borderPos = _borderPos

    if not self.troopSoldier then
        self.troopSoldier = {}
    end    

end


-------------------------------- 新建部队 ----------------------------

function _M:getTroopList()
    local data = {}
    for i,v in pairs(self.troopList) do
        if tonumber(v.lPurpose) == 11 then
        else
            table.insert(data,v)
        end
    end
    return data
end

-- 获取商队
function _M:getShoper()
    for i,v in pairs(self.troopList) do
        if tonumber(v.lPurpose) == 11 then
            return v
        end
    end
    return nil
end

function _M:getShoperTroopId()
    local shoper = self:getShoper()
    if shoper then
        return shoper.lID
    end
    return 0
end

function _M:isShoperIdle()
    local shoper = self:getShoper()
    if shoper then
        local state = tonumber(shoper.lState)
        return (state ~= 1 and state ~= 2)
    end
    return true
end

function _M:isShoper(v)
    return tonumber(v.lPurpose) == 11
end

function _M:getCityList()

   return self.cityList
end

function _M:getTroopNum()
    
    local num = 0
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList) do
        
        if userId == v.lUserID and v.lID ~= 0 and not self:isShoper(v) then
            num = num + 1
        end
    end
    return num
end

function _M:getSoldierWarrior()
    
    local tgWarrior = {}
    local soldierData =  global.soldierData:getSoldiers()
    for _,v in pairs(soldierData) do
        local tb_temp = {}
        tb_temp.lID =  v.lID
        tb_temp.lCount = v.lCount
        tb_temp.lFrom =  0
        table.insert(tgWarrior, tb_temp)
    end
    return tgWarrior
end

-- 获取部队中所有包含该部队id的数量
function _M:getSoldierNumById(soldierId)
    -- body
    local num = 0
    local userId = global.userData:getUserId()
    self.troopList = self.troopList or {} 
    for k,v in pairs(self.troopList) do
        if v.lUserID == userId and v.tgWarrior then
            for k,vv in pairs(v.tgWarrior) do
                if vv.lID == soldierId then
                    num = num + vv.lCount
                end
            end
        end
    end
    return num
end

--- 0中立 1自己 2同盟 3联盟 4敌对

--- lAvator: 当前部队和自己的关系
--- lTargetAvator: 自己和 自己将要占领的城池或占领之后的拥有者 领主的关系
--- lOwnerAvator:  自己和占领城池或者小村庄的领主的关系

function _M:addTroop( msg )

    local funcGame = global.funcGame
    local isExitTroop = self:checkTroop(msg)

    if isExitTroop then

        self:updataTroop(msg)
        return
    end

    if msg.lID ~= 0  and (not isExitTroop)  then

        local tgTroop = {}
        tgTroop.lID = msg.lID 
        if msg.szName==nil or msg.szName=="" then 
            msg.szName=luaCfg:get_local_string(10140) 
        end
        tgTroop.szName = msg.szName 
        tgTroop.lCityID =  msg.lCityID 
        tgTroop.lState = msg.lState
        tgTroop.lTarget = msg.lTarget 
        tgTroop.lCostRes = msg.lCostRes
        tgTroop.lSpeed = msg.lSpeed or 0
        tgTroop.szSrcName = msg.szSrcName or "nil"
        tgTroop.szTargetName = msg.szTargetName or "nil"
        if msg.lHeroID == nil then  msg.lHeroID = {[1]=0}  end
        tgTroop.lHeroID =  msg.lHeroID 
        tgTroop.lAttackStartTime =  msg.lAttackStartTime 
        tgTroop.lAttackEndTime =  msg.lAttackEndTime 
        tgTroop.szUserName =  msg.szUserName or "nil"
        tgTroop.lAvator =  msg.lAvator or 0
        tgTroop.lPurpose = msg.lPurpose or 0
        if msg.lUserID and msg.lUserID ~= 0 then
            tgTroop.lUserID =  msg.lUserID 
        else
            tgTroop.lUserID =  global.userData:getUserId()
        end
        tgTroop.lWildKind = msg.lWildKind or 0
        tgTroop.lTargetAvator = msg.lTargetAvator or 0
        tgTroop.lOwnerAvator = msg.lOwnerAvator or 0
        tgTroop.lAllyName = msg.lAllyName or ""
        tgTroop.lDstType = msg.lDstType or nil
        tgTroop.lSrcType = msg.lSrcType or nil
        tgTroop.lHeroPower = msg.lHeroPower or 0
        tgTroop.lHeroLevel = msg.lHeroLevel 
        tgTroop.lCollectSpeed = msg.lCollectSpeed or nil
        tgTroop.lCollectStart = msg.lCollectStart or nil
        tgTroop.lCollectSurplus = msg.lCollectSurplus or nil
        tgTroop.lCollectCount = msg.lCollectCount or nil            

        tgTroop.szTargetName = funcGame:translateDst(tgTroop.szTargetName, tgTroop.lDstType,tgTroop.lTarget)
        tgTroop.szSrcName = funcGame:translateDst(tgTroop.szSrcName, tgTroop.lSrcType,tgTroop.lCityID)

        tgTroop.tgWarrior = {}
        for _,v in pairs(msg.tgWarrior or {}) do
            local tb_temp = {}
            tb_temp.lID =  v.lID
            tb_temp.lCount =  v.lCount
            tb_temp.lFrom =  v.lFrom
            table.insert(tgTroop.tgWarrior, tb_temp)
        end
        table.insert(self.troopList,tgTroop)
        self:sortTroopList()
    end

end

function _M:checkTroop( troopData )
    
    self.troopList = self.troopList or {} 
    for _,v in pairs(self.troopList) do
        if troopData.lID == v.lID then
            return true
        end
    end
    return false
end

function _M:updataTroop( msg , isNotify)

    if not msg then return end
    
    if msg.lID == 0 then
        return
    end

    self.troopList = self.troopList or {}
    for i,v in pairs(self.troopList) do
        
        local funcGame = global.funcGame
        if v.lID == msg.lID then

            if msg.szName==nil or msg.szName=="" then
                msg.szName=luaCfg:get_local_string(10140)  
            end

            -- 部队状态变更（回城了）
            if v.lState and v.lState ~= msg.lState and msg.lState == 6 then

                local szName = msg.szName
                if msg.lPurpose == 11 then
                    szName = luaCfg:get_local_string(11178)
                end
                local data = {listId=tonumber(4 .. msg.lID), param={id=4, args={szName}}}
                global.finishData:addFinshList(data)
            end

            v.tgWarrior = {}
            v.szName = msg.szName 
            v.lCityID = msg.lCityID 
            v.lState = msg.lState
            v.lTarget = msg.lTarget 
            v.lCostRes = msg.lCostRes
            v.lHeroID =  msg.lHeroID 
            v.lSpeed = msg.lSpeed or 0
            v.szSrcName = msg.szSrcName or "nil"
            v.szTargetName = msg.szTargetName or "nil"
            v.lAttackStartTime =  msg.lAttackStartTime 
            v.lAttackEndTime =  msg.lAttackEndTime 
            v.szUserName =  msg.szUserName
            v.lAvator =  msg.lAvator or 0
            v.lWildKind = msg.lWildKind or 0
            v.lTargetAvator = msg.lTargetAvator or 0
            v.lOwnerAvator = msg.lOwnerAvator or 0
            v.lDstType = msg.lDstType or nil
            v.tgWarrior = msg.tgWarrior or {}
            v.lDstType = msg.lDstType or nil
            v.lSrcType = msg.lSrcType or nil
            v.lHeroPower = msg.lHeroPower or 0
            v.lPurpose = msg.lPurpose or 0
            v.lCollectSpeed = msg.lCollectSpeed or nil
            v.lCollectStart = msg.lCollectStart or nil
            v.lCollectSurplus = msg.lCollectSurplus or nil
            v.lCollectCount = msg.lCollectCount or nil            
            if msg.lHeroLevel and  msg.lHeroLevel ~= 0 then
                v.lHeroLevel = msg.lHeroLevel
            end

            v.szTargetName = funcGame:translateDst(v.szTargetName, v.lDstType,v.lTarget)
            v.szSrcName = funcGame:translateDst(v.szSrcName, v.lSrcType,v.lCityID)
        end
    end
    if self:isShoper(msg) and not self:checkTroop(msg) then
        self:addTroop(msg)
    end
    gevent:call(global.gameEvent.EV_ON_UI_TROOP_REFERSH, isNotify)
    gevent:call(global.gameEvent.EV_ON_SOLDIER_HARVEST)
end

function _M:deleteTroopsById( _troopsId , isNotCallEvent)
    
    for i,v in pairs(self.troopList or {}) do
        if v.lID == _troopsId then

            global.heroData:updataRecruitHeroUseState(v.heroId)
            table.remove(self.troopList, i)
            break
        end
    end
    self:sortTroopList()

    if not isNotCallEvent then
        gevent:call(global.gameEvent.EV_ON_UI_TROOP_REFERSH)    
    end
end

function _M:refershSoldierData()
    
    self:deleteTroopsById(0,true)
    self:createNewItem()

    -- 更新士兵数量以及兵种
    local soldierData = global.soldierData:getSoldiers()
    for _,v in pairs(soldierData) do
        self:updataTroopTgWarrior(v)
    end
end

function _M:updataTroopTgWarrior( soldier )

    local m_tgWarrior = {}
    m_tgWarrior = clone(soldier)
    for _,v in pairs(self.troopList) do
        if v.lID ~= 0 then
            local flag = 0
            for k,soldierTg in pairs(v.tgWarrior) do
                if soldier.lID == soldierTg.lID then
                    flag = 1
                end
            end
            if flag == 0 then
                m_tgWarrior.lCount = 0
                table.insert(v.tgWarrior, m_tgWarrior)
            end
        end
    end
end

function _M:sortTroopList()
    
    local newTroop = {}
    local troopTemp = {}
    local troopTempOther = {}
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {}) do
        if v.lID == 0 then
            table.insert(newTroop, v)
        else
            if userId == v.lUserID then
                table.insert(troopTemp, v)
            else
                table.insert(troopTempOther, v)
            end
        end
    end

    table.sort( troopTemp, function(s1, s2) return s1.lID < s2.lID end )
    table.sort( troopTempOther, function(s1, s2) return s1.lID < s2.lID end )

    self.troopList = {}
    for _,v in pairs(troopTemp) do
         table.insert(self.troopList, v)
    end
    for _,v in pairs(troopTempOther) do
         table.insert(self.troopList, v)
    end
    for _,v in pairs(newTroop) do
         table.insert(self.troopList, v)
    end
end

function _M:getTroopById( _troopId )
    
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then
            return v
        end
    end
end

--speed
function _M:getTroopsSpeed( _troopId )
    
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then         
            if v.tgWarrior then
                local speed = false
                for _,v in pairs(v.tgWarrior) do
                    local sd = luaCfg:get_soldier_property_by(v.lID)
                    
                    if (not speed or speed > sd.speed) and v.lCount > 0 then

                        speed = sd.speed
                    end
                end

                return speed
            end            
        end
    end
    return scaleNum
end


function _M:getTroopsSpeedWithClass( _troopId )
    
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then         
            if v.tgWarrior then
                local speed = false
                local  choose = nil 
                for _,v in pairs(v.tgWarrior) do
                    local sd = luaCfg:get_soldier_property_by(v.lID)
                    
                    if (not speed or speed > sd.speed) and v.lCount > 0 then
                        choose = v 
                        speed = sd.speed
                    end
                end

                if choose  and global.luaCfg:get_soldier_train_by(choose.lID).race ~= 0  then --死灵骑士默认属性
                    return global.funcGame:getSoldierLvup(choose.lLv , choose.lID ,"speed")
                end 

                return speed
            end            
        end
    end
    return scaleNum
end



function _M:getCombat( _troopId )
    
    local scaleNum = 0
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then
            
            scaleNum = v.lHeroPower
            if v.tgWarrior then
                for _,v in pairs(v.tgWarrior) do

                    local config = luaCfg:get_soldier_property_by(v.lID)
                    local soldierPerpop =config .perPop
                    scaleNum = scaleNum + v.lCount*soldierPerpop *config.changeTimes
                end
            end            
        end
    end
    return scaleNum
end

function _M:getTroopsHeroType(troopId)

    for _,v in pairs(self.troopList or {} ) do
        print(v.lID,troopId)
        if v.lID == troopId then
            if v.lHeroID then
                local heroId = v.lHeroID[1]
                local heroData = luaCfg:get_hero_property_by(heroId) or {}
                return heroData.secType or 0
            end         
        end
    end
    return 0
end

function _M:isHeroInAttack(heroId)
            
    for _,v in pairs(self.troopList or {} ) do
        
        if v.lState == 11 then

            if v.lHeroID and v.lHeroID[1] == heroId then

                return true
            end
        end
    end    

    return false
end

function _M:isHeroInCity(heroId)
            
    local worldCityID = global.userData:getWorldCityID()
    if worldCityID == 0 then
        return true
    end

    for _,v in pairs(self.troopList or {} ) do        
        if v.lHeroID and v.lHeroID[1] == heroId then            
            if v.lState == 6 or v.lState == 10 then
                if v.lTarget ~= worldCityID then
                    return false
                end
            else
                if v.lID ~= 0 then
                    return false
                end            
            end
        end
    end

    return true
end

function _M:getTroopSoldierNum( _troopId )
    
    local scaleNum = 0
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then
            
            if v.tgWarrior then
                for _,v in pairs(v.tgWarrior) do
                    scaleNum = scaleNum + v.lCount
                end
            end            
        end
    end    
    return scaleNum
end

---------------------　部队规模　所有兵种占用兵员数量之和 --------------------
function _M:getTroopsScaleById( _troopId )
    
    local scaleNum = 0
    for _,v in pairs(self.troopList) do
        if v.lID == _troopId then
            
            if v.tgWarrior then
                for _,v in pairs(v.tgWarrior) do
                    local soldierPerpop = luaCfg:get_soldier_property_by(v.lID).perPop
                    scaleNum = scaleNum + v.lCount*soldierPerpop
                end
            end            
        end
    end    
    return scaleNum
end

function _M:getTroopsScaleByData( data )
    
    local scaleNum = 0
    for _,v in pairs(data) do
        local soldierPerpop = luaCfg:get_soldier_property_by(v.lID).perPop
        scaleNum = scaleNum + v.lCount*soldierPerpop
    end
    return scaleNum
end

---------------------　部队运载量 ---------------------------
function _M:getTroopsWeightByData( data )
    
    local weightNum = 0
    for _,v in pairs(data) do
        local soldierPerpop = luaCfg:get_soldier_property_by(v.lID).capacity
        weightNum = weightNum + v.lCount*soldierPerpop
    end
    return weightNum
end


function _M:getTroopsClassWeightByData( data )

    local weightNum = 0
    for _,v in pairs(data) do

        local lv = v.lLv
        if not lv then  --如果没有 等级 则认为 是自己士兵
           local id ,dataBuild = global.cityData:getBuildingIdBySoldierId(v.lID)
            if dataBuild.serverData then 
               lv =  dataBuild.serverData.lGrade
            end 
        end 
        local soldierPerpop = global.funcGame:getSoldierLvup(lv, v.lID ,"capacity")

        if  global.luaCfg:get_soldier_train_by(v.lID).race == 0  then --死灵骑士默认属性

            soldierPerpop =luaCfg:get_soldier_property_by(v.lID).capacity
        end 

        weightNum = weightNum + v.lCount*soldierPerpop
    end
    return weightNum
end


function _M:getGarrisonCount()
    local count = 0
    for _,v in pairs(self.troopList or {} ) do
        if v.lState == 10 then

            count = count + 1
        end
    end
    return count
end

---------------------- 刷新军队状态信息 ------------------
function _M:updataTroopsState( _troopId, lState )
    
    for _,v in pairs(self.troopList or {}) do
        if v.lID == _troopId then
            v.lState = lState
        end
    end
end

function _M:getSupply()
    
    local res = 0
    for _,v in pairs(self.troopList or {} ) do    
        -- 排除别人驻防在自己城上的部队消耗
        if v.lUserID and v.lUserID == global.userData:getUserId() then
            res = res + (v.lCostRes or 0)
        end
    end
    return res
end

------------------- 获取所有驻扎在该城池的部队 -------------
function _M:getTroopStateOwn()
    
    for _,v in pairs(self.troopList or {} ) do
        local isOwn = v.lUserID and (v.lUserID == global.userData:getUserId())
        if isOwn and (v.lState==11 or v.lState==1) then
            return true
        end
    end
    return false
end

function _M:getTroopsByCityId( cityId )

    local arr = {}
    for _,v in pairs(self.troopList or {} ) do    

        if (v.lState == 10 or v.lState == 5 or v.lState == 11) and v.lCityID and cityId == v.lCityID then

            table.insert(arr,v)  
        end
    end
    return arr
end

function _M:getOwnTroopsByCityId( cityId )
    
    local arr = {}
    for _,v in pairs(self.troopList or {} ) do    

        if v.lAvator == 1 and (v.lState == 10 or v.lState == 5) and v.lCityID and cityId == v.lCityID then

            table.insert(arr,v)
        end
    end
    return arr
end

function _M:setTargetData(attackMode,forceType,targetCityId,targetCityName)
   
    local attackInfo = {}

    attackInfo.attackMode = attackMode
    attackInfo.forceType = forceType or global.g_worldview.worldPanel.lForce
    attackInfo.targetCityId = targetCityId or global.g_worldview.worldPanel.chooseCityId
    attackInfo.targetCityName = targetCityName or global.g_worldview.worldPanel.chooseCityName
    if attackInfo.targetCityId then
        local sname = luaCfg:get_all_miracle_name_by(attackInfo.targetCityId)
        if sname then
            attackInfo.targetCityName = sname.name
        end

    end
    self.targetInfo = attackInfo

end

function _M:getTargetCombat()
    
    return self.targetCombat or 0
end

function _M:getTargetWarType()
    
    return self.targetWarType
end

function _M:getTargetStr()
    
    local targetData = self:getTargetData()
    if targetData == nil then return "" end

    local lType = targetData.attackMode
    local actionStrId = 10124

    if lType == 1 then
        actionStrId = 10125
    elseif lType == 2 then
        actionStrId = 10124
    elseif lType == 3 then
        actionStrId = 10684 -- 侦查
    elseif lType == 4 then
        actionStrId = 10096 
    elseif lType == 6 then
        actionStrId = 10126
    elseif lType == 7 then
        actionStrId = 10210
    elseif lType == 8 then
        actionStrId = 10903
    end

    return luaCfg:get_local_string(actionStrId)
end

function _M:setTargetCheckData(checkData)
    self.checkConData = checkData
end
function _M:getTargetCheckData()
    return self.checkConData 
end


function _M:setTargetCombat(combat)
    self.targetCombat = combat
end

function _M:setTargetWarType(warType)
    self.targetWarType = warType
end

function _M:cleanTargetCombat()
    
    self.targetCombat = 0
    self.targetWarType = nil
    self.checkConData = nil
end

function _M:resetTargetData()
    self.targetInfo = nil
    self.attackType = nil
end

function _M:setTargetMonsterType(monsterType)
    self.targetInfo.monsterType =  monsterType 
end

function _M:setContentOutId(id)
    if not self.targetInfo then return end
    self.targetInfo.outId = id
end

function _M:getTargetData()
    
    return self.targetInfo
end

function _M:getStayTroop()
    
    local res = {}
    for _,v in pairs(self.troopList or {} ) do   

        if v.lAvator == 1 and (v.lState == 5 or (v.lState == 11 and v.lPurpose == 4)) then
   
            table.insert(res,v)
        end
    end
    return res
end

-- function _M:getCollectTroop(cityId)
--     local count = 0
--     for _,v in pairs(self.troopList or {} ) do    
        
--         if (v.lState == 10 or v.lState == 5) and cityId == v.lTarget and v.lCollectSpeed then
    
--             return v
--         end
--     end
--     return nil
-- end

function _M:getCollectTroop(cityId)
    local count = 0
    for _,v in pairs(self.troopList or {} ) do    
        
        if (v.lState == 10 or v.lState == 5) and cityId == v.lTarget and v.lCollectSpeed then
    
            return v
        end
    end
    return nil
end

function _M:getTroopInCity( cityId )
    
    local count = 0
    for _,v in pairs(self.troopList or {} ) do    
        
        if (v.lState == 10 or v.lState == 5) and cityId == v.lTarget then
    
            count = count + 1
        end
    end
    return count
end

function _M:getOwnTroopInCity( cityId )
    
    local count = 0
    for _,v in pairs(self.troopList or {} ) do    

        
        if v.lAvator == 1 and (v.lState == 10 or v.lState == 5) and cityId == v.lTarget then
   
            count = count + 1
        end
    end
    return count
end

-- 获取占领小村庄的所有驻军信息
function _M:getTroopInVillage( cityId )
    
    local villageTroop = {}
    for _,v in pairs(self.troopList or {} ) do
        
        if v.lCityID == cityId then
            table.insert(villageTroop, v)
        end
    end
    return villageTroop
end

------------------ 判断是不是侦查部队 ---------------------
function _M:checkTroopType(data)

    local isSearchTroop = true

    local troopScale = global.troopData:getTroopsScaleById(data.lID)
    if troopScale == 0 then

        return false
    end

    for _,v in pairs(data.tgWarrior) do
        
        if v.lCount > 0 then

            local soldierType = luaCfg:get_soldier_train_by(v.lID).type
            if soldierType ~= 5 then
                isSearchTroop = false
                return isSearchTroop
            end
        end
    end

    local userId = global.userData:getUserId()
    if data.lUserID and data.lUserID ~= 0 then
    else
        data.lUserID =  userId
    end

    if userId ~= data.lUserID then
        isSearchTroop = false
    end 

    return isSearchTroop
end


function _M:checkTroopTypeByData(data)
    
    if not data.tgSoldiers then data.tgSoldiers = {} end
    local isSearchTroop = true
    for _,v in pairs(data.tgSoldiers) do
        
        if v.lCount > 0 then
            local ltype = 0
            local soldierData = luaCfg:get_soldier_train_by(v.lID)
            if not soldierData  then
                wildData = luaCfg:get_wild_property_by(v.lID) 
                ltype = wildData.type
            else
                ltype = soldierData.type
            end
            if ltype ~= 5 then
                isSearchTroop = false
                return isSearchTroop
            end
        end
    end

    return isSearchTroop
end

--- 修改部队的领主名字信息
function _M:refershLordName()
    
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        local troopScale = self:getTroopsScaleById(v.lID)
        if userId == v.lUserID and troopScale > 0 then
            v.szUserName = global.userData:getUserName()
        end
    end
end

-------------------------------- 校场驻守士兵显示 ----------------------------

function _M:getTroopSoldier()
    
    return self.troopSoldier
end

function _M:getSoldierType()
    
    return self.soldierType
end

-- 获取驻守内城的部队数量
function _M:getCityTroopNum()
   
    local num = 0
    for _,v in pairs(self.troopList or {} ) do
        local troopScale = self:getTroopsScaleById(v.lID) 
        if v.lID ~= 0  and troopScale > 0 then
            if v.lState == 6 or v.lState == 10 then
                num = num + 1
            end
        end
    end
    return num
end

-- 获取自己的所有部队数量
function _M:getMineTroopNum()
   
    local num = 0
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID  and troopScale > 0 then
            num = num + 1
        end
    end
    return num
end

-- 获取自己的待命的数量大于100的部队数目
function _M:getMineTroopNumForGuide()
   
    local num = 0
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        -- local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID then
            if v.lState == 6 and self:getTroopSoldierNum(v.lID) >= 100 then
                num = num + 1
            end
        end
    end
    return num
end


--
function _M:getMineTroopNumForGuideTroopID()
   
    local num = 0
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        -- local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID then
            if v.lState == 6 and self:getTroopSoldierNum(v.lID) >= 100 then
                -- num = num + 1
                return v.lID
            end
        end
    end

    return 0
end


function _M:getMineTroopMaxNumForGuideTroopID()
   
    local num = nil
    local num1 = 0 
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        -- local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID then
            local num2 =  self:getTroopSoldierNum(v.lID)
            if v.lState ~= 0 and num2 >= num1 then
                num = v.lID
                num1 = num2 
            end
        end
    end

    return num
end


-- 获取自己的待命的数量大于100的部队数目
function _M:getMineTroopNumForGuide2()
   
    local num = 0
    local userId = global.userData:getUserId()
    for _,v in pairs(self.troopList or {} ) do
        -- local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID then
            if v.lState == 10  then
                num = num + 1
            end
        end
    end

    for _,v in pairs(self.troopList or {} ) do
        -- local troopScale = self:getTroopsScaleById(v.lID) 
        if userId == v.lUserID then
            if v.lState == 10 or  v.lState == 0  then
            else 
                num = 0
            end 
        end
    end
    return num
end


function _M:resetData()
    
    --　每种士兵的类型和数量  (骑兵3, 枪兵1，弓箭手2，法师4 )
    self.soldierType = {}
    local _soldierType = {
       [1] = {type=3,num=0,pic="animation/city_army_horseman",},
       [2] = {type=1,num=0,pic="animation/city_army_soldiers",}, 
       [3] = {type=2,num=0,pic="animation/city_army_bowman",},
       [4] = {type=4,num=0,pic="animation/city_army_magician",},
    }

    self.soldierType = _soldierType
end

--　获取士兵的数量
function _M:getCitySoldierNum()

    self:resetData()

    local totalNum = 0
    local soldier = global.soldierData:getSoldiers()
  
    for _,v in pairs(soldier) do
        
        local lType = self:getCitySoldierType(v.lID)
        if lType ~= 0 then
            if lType == 3 then
                self.soldierType[1].num = self.soldierType[1].num + v.lCount 
            elseif lType == 1 then
                self.soldierType[2].num = self.soldierType[2].num + v.lCount
            elseif lType == 2 then
                self.soldierType[3].num = self.soldierType[3].num + v.lCount  
            elseif lType == 4 then
                self.soldierType[4].num = self.soldierType[4].num + v.lCount
            end
        end
    end

    for _,v in pairs(self.soldierType) do
        local numScale = luaCfg:get_troop_num_by(v.type).scale
        totalNum = totalNum + math.floor(v.num/numScale)
        self:updateSoldierNum(v.type, math.floor(v.num/numScale))
    end

    return totalNum
end

function _M:updateSoldierNum( _type, num )
    
    for _,v in pairs(self.soldierType) do
        if v.type == _type  then
            v.num = num
        end
    end
end

function _M:getCitySoldierType(id)
   
    local soldier = luaCfg:get_soldier_train_by(id)
    if not soldier then
        return 0
    end
    return soldier.type 
end

function _M:addTroopSoldier( soldierCsb, timeLine ,soldierNode, isPlay )
    
    local nodeTb = {}
    nodeTb.soldierCsb = soldierCsb
    nodeTb.timeLine = timeLine
    nodeTb.soldierNode = soldierNode
    table.insert(self.troopSoldier,nodeTb)
end

function _M:removeTroopSoldier( list )
    for i,v in pairs(list) do
        v.soldierNode:removeFromParent()
    end
    list = {}
end

function _M:removeAllTroop()
    self:removeTroopSoldier(self.troopSoldier)
    self.troopSoldier = {}
end

function _M:updataSoldiersRest( _soldierId, _curNum )
    
    for _,v in pairs(self.troopSoldierList) do
        if v.id == _soldierId then
            v.restNum =  _curNum
        end
    end
end

--是否所有部队都在主城
function _M:isEveryTroopIsInsideCity()
    
    -- dump(self.troopList or {} ,"check troop")

    local worldCityID = global.userData:getWorldCityID()
    if worldCityID == 0 then

        return true
    end

    for _,v in pairs(self.troopList or {} ) do
        
        if v.lUserID == global.userData:getUserId() then
            
            if v.lState == 6 or v.lState == 10 then

                if v.lTarget ~= worldCityID then

                    return false
                end
            else

                if v.lID ~= 0 then
                    return false
                end            
            end
        end
    end

    return true
end

function _M:setNewMonsterId(id)
    
    self.newMonsterId = id
end

function _M:gerNewMonsterId()
    
    return self.newMonsterId
end

function _M:timeStringFormat( time )
    
    local str = ""
    local hour = math.floor(time / 3600) 
    time = time  % 3600
    local min = math.floor(time / 60)
    time = time % 60
    local sec = math.floor(time) 

    str =  luaCfg:get_local_string( 10017 , hour, min, sec ) 
    return str
end

-- optional int32      lDstType    = 23;   //0:村庄 1：城池  2：资源野地 5：怪物 6：奇迹点  9：联盟营地
-- optional int32      lSrcType    = 26;   //0:村庄 1：城池  2：资源野地 5：怪物 6：奇迹点  9：联盟营地
-- 通过目的地和出发地类型获取名称
function _M:getNameByType(lType, id)
    
    -- lType = tonumber(lType)
    -- local idInit = id
    -- id = tonumber(id)
    
    -- local targetStr = "-"
    -- local target = {}
    -- if lType == 1 then
    --     targetStr = idInit
    -- elseif lType == 2 then
    --     target = luaCfg:get_wild_res_by(id)
    -- elseif lType == 5 then
    --     target = luaCfg:get_wild_monster_by(id)
    -- elseif lType == 6 or lType == 9 or lType == 0 then
    --     target = luaCfg:get_world_type_by(id)
    -- end

    -- if target and target.name then 
    --     targetStr =  target.name
    -- end

    return global.funcGame:translateDst(id, lType)
end

-- 是否显示切页模式
function _M:setPageMode(flag)
    self.isSecondPage = flag
end
function _M:getPageMode()
    return self.isSecondPage or 1
end


-- 0其他 1 野地 2城堡 3奇迹 4联盟村庄 5神殿 6小村庄 
function _M:setAttackType(lType) 
    self.attackType = lType
end

function _M:getOrderStr()
    
    local targetData = self:getTargetData()
    if targetData == nil or (not self.attackType) then 
        return "" 
    end

    local lType = targetData.attackMode
    local actionStrId = 10880

    if lType == 1 then      -- 攻城
        
        if self.attackType == 1 then
            actionStrId = 10887
        elseif self.attackType == 2 then
            actionStrId = 10881 
        elseif self.attackType == 3 then
            actionStrId = 10893
        elseif self.attackType == 4 then
            actionStrId = 10894
        elseif self.attackType == 5 then
            actionStrId = 10895
        elseif self.attackType == 6 then
            actionStrId = 10892
        end

    elseif lType == 2 then  -- 攻击
        
        if self.attackType == 1 then
            actionStrId = 10886
        elseif self.attackType == 2 then
            actionStrId = 10880
        elseif self.attackType == 3 then
            actionStrId = 10889
        elseif self.attackType == 4 then
            actionStrId = 10890
        elseif self.attackType == 5 then
            actionStrId = 10891
        elseif self.attackType == 6 then
            actionStrId = 10888
        end

    elseif lType == 3 then
        actionStrId = 10884 -- 侦查
    elseif lType == 4 then
        actionStrId = 10883 -- 驻防 
    elseif lType == 6 then
        actionStrId = 10882 -- 掠夺
    elseif lType == 7 then
        actionStrId = 10885 -- 起义
    elseif lType == 8 then
        actionStrId = 10923 -- 传送
    end

    return luaCfg:get_local_string(actionStrId)
end

function _M:checkBossTroop(lTarget)
    -- body
    for i,v in ipairs(self.troopList or {} ) do
        if v.lTarget and v.lTarget == lTarget then
            return true
        end
    end
    return false
end

-- 检测有没有正在返回中的部队
function _M:checkBackTroop()
    -- body
    for i,v in ipairs(self.troopList or {} ) do
        local isBack = v.lState == 2
        if isBack then
            return true
        end
    end
    return false
end

-- 检测有没有正在行军中的部队
function _M:checkWalkTroop()
    -- body
    for i,v in ipairs(self.troopList or {} ) do
        local isWalking = v.lState == 1 or v.lState == 2
        if isWalking then
            return true
        end
    end
    return false
end


function _M:isEmptyTroop()
    local flag = true     
    for i,v in ipairs(self.troopList or {} ) do
       if(v.lHeroID and v.lHeroID[1] ~= 0 ) then 
            flag = false 
       end 
    end
    return flag
end

global.troopData = _M

--endregion

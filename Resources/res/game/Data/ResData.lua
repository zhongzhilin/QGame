
local luaCfg = global.luaCfg
local propData = global.propData
local cityData = global.cityData
local soldierData = global.soldierData

local _M = {
    occupyMax = {},
}

local resList = {
    WCONST.ITEM.TID.FOOD, --粮食
    WCONST.ITEM.TID.GOLD, --金币
    WCONST.ITEM.TID.WOOD, --木头
    WCONST.ITEM.TID.STONE,--石头
}


local exchangeIToId = {
    [WCONST.ITEM.TID.FOOD ]  =1, --粮食
    [WCONST.ITEM.TID.GOLD ]  =2, --金币
    [WCONST.ITEM.TID.WOOD ]  =3, --木头
    [WCONST.ITEM.TID.STONE]  =4,--石头
    [WCONST.ITEM.TID.SOLDIER]  =10,--兵源
}





--- buildResType：资源建筑id  ( 农田、金矿、伐木场、石矿 )
--- resIcon: 资源总览界面图标
--- resGetIcon： 获取资源界面图标
--- resItemType: 资源道具类型  ( 对应item表typeorder 参数 )
--- bgViewPic: 主界面资源进度条背景
--- ligPic: 主界面资源进度条头部样式

local resType = {
    [1] = { itemId=1,  itemType=101, buildResType=3, resItemType=5, resIcon="ui_surface_icon/res_food_icon.png", resGetIcon="ui_surface_icon/city_res_food.png",    
        bgViewPic="ui_surface_icon/food_loadingbar.png"    ,ligPic="ui_surface_icon/food_loadingtip.png" },
    [2] = { itemId=2,  itemType=101, buildResType=11, resItemType=8, resIcon="ui_surface_icon/res_coin_icon.png", resGetIcon="ui_surface_icon/city_res_coin.png",   
        bgViewPic="ui_surface_icon/coin_loadingbar.png"    ,ligPic="ui_surface_icon/coin_loadingtip.png" },
    [3] = { itemId=3,  itemType=101, buildResType=9, resItemType=6, resIcon="ui_surface_icon/res_wood_icon.png", resGetIcon="ui_surface_icon/city_res_wood.png",    
        bgViewPic="ui_surface_icon/wood_loadingbar.png"    ,ligPic="ui_surface_icon/wood_loadingtip.png" },
    [4] = { itemId=4,  itemType=101, buildResType=10, resItemType=7, resIcon="ui_surface_icon/res_stone_icon.png", resGetIcon="ui_surface_icon/city_res_stone.png", 
        bgViewPic="ui_surface_icon/stone_loadingbar.png"   ,ligPic="ui_surface_icon/stone_loadingtip.png"},
}

local soldierType= { itemId=4,  itemType=101, buildResType=10, resItemType=7, resIcon="ui_surface_icon/res_stone_icon.png", resGetIcon="ui_surface_icon/city_res_stone.png", 
        bgViewPic="ui_surface_icon/man_loadingbar.png"   ,ligPic="ui_surface_icon/stone_loadingtip.png"}



-- localId 资源加成分类(lozation 表)
local resourceAdd = {
    [1] = { id=1, localId=10070, },
    [2] = { id=2, localId=10073, },
    [3] = { id=3, localId=10071, },
    [4] = { id=4, localId=10074, },
    [5] = { id=5, localId=10072, },
    [6] = { id=6, localId=10075, },
    [7] = { id=7, localId=10454, },
    [8] = { id=8, localId=10453, },
    [9] = { id=9, localId=10858, },
    [10] = { id=10, localId=11088, },
}

local resFlag = {
    [1]={id=1, flag=0, },
    [2]={id=2, flag=0, },
    [3]={id=3, flag=0, },
    [4]={id=4, flag=0, },
}
_M.worldWild = {} --占领的野地
_M.worldCity = {} --占领的城池

function _M:init(msg)        
    self.resAll = {}    -- 所有资源信息
    self.resAdd = {}    -- 加成信息

    self:initWorld(msg)
end

function _M:initWorld(msg)   
    if msg and msg.tgOccupyRes then
        --dump(msg.tgOccupyRes, "----------> tgOccupyRes:")
        table.assign(self.worldWild,msg.tgOccupyRes)
    end

    if msg and msg.tgOccupyCity then
        --dump(msg.tgOccupyCity, "----------> tgOccupyCity:")
        table.assign(self.worldCity,msg.tgOccupyCity)
    end
    self:initData()
    
end
--     "tgOccupyRes" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "lFlushTime" = 1492397790
-- [LUA-print] -             "lKind"      = 10051
-- [LUA-print] -             "lOPTime"    = 1492413206
-- [LUA-print] -             "lPosX"      = 50378
-- [LUA-print] -             "lPosY"      = 11025
-- [LUA-print] -             "lReason"    = 0
-- [LUA-print] -             "lResID"     = 700596689
-- [LUA-print] -             "lState"     = 2
-- [LUA-print] -         }
-- [LUA-print] -     }

-- 本地推送
function _M:localNotify()
    dump(self.worldWild,"self.worldWild=========")
    for  _ ,v in pairs(self.worldWild) do 
        local designerData = luaCfg:get_wild_res_by(v.lKind)
        local currSvrTime = global.dataMgr:getServerTime()
        local maxHp =  designerData.waste
        local restTime = maxHp* designerData.consume - (currSvrTime-v.lFlushTime)
        global.ClientStatusData:recordNotifyData(9,restTime,currSvrTime)
    end 
end 

function _M:getWorldWild() 
    return self.worldWild
end

function _M:addWorldWild(tagWildRes)

    -- 神殿处理
    if tagWildRes and tagWildRes.lprotectState then
        return 
    end

    for k,v in pairs(self.worldWild) do
        if v.lResID == tagWildRes.lResID then
            table.assign(self.worldWild[k],tagWildRes)
            return
        end
    end

    table.insert(self.worldWild,tagWildRes)
    self:initData()

end

function _M:addWorldCity(tagCityRes)

    for k,v in pairs(self.worldCity) do
        
        if v.lCityID == tagCityRes.lCityID then
            table.assign(self.worldCity[k],tagCityRes)
            return
        end
    end
    table.insert(self.worldCity,tagCityRes)
    self:initData()
end

function _M:removeWorldCity(tagCity)

    for index,v in ipairs(self.worldCity) do

        local isDelete = (not tagCity.tagCityOwner)
        if tagCity.tagCityOwner then
            isDelete = (global.userData:getUserId() ~= tagCity.tagCityOwner.lUserID)
        end
        if isDelete and (v.lCityID == tagCity.lCityID) then
            table.remove(self.worldCity,index)
            return
        end
    end
    
    self:initData()
end

function _M:removeWorldWild(tagCity)

    -- 神殿处理
    if tagCity and tagCity.lprotectState then
        return 
    end
    
    for index,v in ipairs(self.worldWild) do

        local isDelete = (not tagCity.tagOwner)
        if tagCity.tagOwner then 
            isDelete = (global.userData:getUserId() ~= tagCity.tagOwner.lUserID)
        end
        if isDelete and (v.lResID == tagCity.lResID) then
            table.remove(self.worldWild,index)
            return
        end
    end

    self:initData()
end

-----  {[1]={resId=1,  curRes=100, maxRes=1000, baseRes=100, totalAdd=100, resCost=-100} }
-----  curRes: 当前资源数
-----  maxRes: 资源上限
-----  baseRes: 基础产量
-----  totalAdd：总资源加成
-----　resCost: 资源消耗

function _M:initData()

    -- 初始化资源加成
    self.resAdd = resourceAdd

    local res = {[1]={},[2]={},[3]={},[4]={}}

    self.resAll = res

    -- 当前资源
    for k,v in pairs(resList) do
        local prop = propData:getProp(v)
        res[k].resId = k
        res[k].curRes = prop
    end

    -- 仓库资源上限
    local maxRes = self:getStoreMax()
    for i=1,4 do
        res[i].maxRes = maxRes
        if res[i].curRes and res[i].maxRes  then 
            if res[i].curRes > res[i].maxRes then
                res[i].curRes = res[i].maxRes
            end
        end 
    end
    
    -- 基础产量
    for k,v in pairs(resType) do
        res[k].baseRes = self:getProduce(v.buildResType) 
        if k == 1 then
            res[k].resCost = self:getFoodConsumpWithBuff()
        else
            res[k].resCost = 0
        end
    end

    -- 总资源加成
    for k,v in pairs(resType) do
        local totalAdd = self:getTotalResAdd(v.itemId)
        res[k].totalAdd = totalAdd
    end

    table.sort( self.resAll, function(s1, s2) return s1.resId < s2.resId end )

end

function _M:getPropPer(key)

    self:initData()
    local idx = exchangeIToId[key]
     local curResData = nil
     local currNum = nil
     local maxNum = nil
     local per =  nil 
    if idx == nil then return false end

    if key == WCONST.ITEM.TID.SOLDIER then --兵源接入
        curResData = soldierType
        maxNum =  global.userData:getMaxPopulation() 
        currNum =  global.userData:getUsefulPopulation()
        per = currNum/maxNum*100
    else 
        curResData = resType[idx]
        currNum = global.propData:getProp(key) or 0 
        maxNum = self.resAll[idx].maxRes
        per = currNum/maxNum*100
    end 
    
    return per, curResData, maxNum, currNum
end

function _M:getRes() 
    self:initData()  

    return self.resAll
end

function _M:getResAdd() 
        
    return self.resAdd
end

function _M:updateResAdd()
    -- body
end

-- 获取仓库资源上限
function _M:getStoreMax()
    local storeId = 18
    if not self:getBuildData(storeId) then 
        -- protect  
        return 0 
    end 
    local storeLv = self:getBuildData(storeId).serverData.lGrade
    local resmax = luaCfg:buildings_info()
    for _,v in pairs(resmax) do
        if v.type == storeId and v.level == storeLv then
            return tonumber(v.para1Num) or 0
        end
    end
    return 0
end

function _M:getResById(resId) 
    
    local tempData = self:getRes() 
    for _,v in pairs(tempData) do
        if v.resId == resId then
            return v
        end
    end
end

function _M:getFlag( id )
    for _,v in pairs(resFlag) do
        if v.id == id then
            return v.flag
        end
    end
end
function _M:updataFlag( id, flag )
    
    for _,v in pairs(resFlag) do
        if v.id == id then
            v.flag = flag
        end
    end
end

function _M:getBuildData( buildType )
    
    local registerBuild = cityData:getRegistedBuild()
    for _,v in ipairs(registerBuild) do
        if v.buildingType == buildType then
            return  v
        end
    end
end

function _M:getResTypeById( itemId )
    for _,v in pairs(resType) do
        if v.itemId == itemId then
            return v
        end
    end
end

---------------------------- 每小时产量增减 ----------------
function _M:getResSpeedHour( resId )
    
    local tempRes = self:getRes()   
    for _,v in pairs(tempRes) do
        if v.resId == resId then
            return v.baseRes + v.totalAdd - v.resCost
        end
    end
end

---------------------------- 基础产量 -----------------------
function _M:getProduce( buildType )

    local totlePro = 0
    local registerBuild = cityData:getRegistedBuild()
    for _,v in ipairs(registerBuild) do
        if v.buildingType == buildType then
            local level = v.serverData.lGrade
            local perProduce = self:getPerProduce(level, v.buildingType)
            totlePro = totlePro + perProduce
        end
    end

    return totlePro
end

---------------------------- 粮食消耗 -----------------------
function _M:getFoodConsump()
    
    local totalConump = 0
    local soldier = soldierData:getSoldiers() 
    for _,v in pairs(soldier) do
        
        local num = luaCfg:get_soldier_property_by(v.lID).perRes
        totalConump = totalConump + num*v.lCount
    end

    totalConump = math.ceil(totalConump)
    return totalConump + global.troopData:getSupply()
end


function _M:getFoodConsumpWithBuff()  -- 计算buff 后的粮耗
    
    local totalConump = 0
    local soldier = soldierData:getSoldiers() 
    for _,v in pairs(soldier) do
        
        local num = luaCfg:get_soldier_property_by(v.lID).perRes
        totalConump = totalConump + num*v.lCount
    end

    totalConump = math.ceil(totalConump)
    totalConump = totalConump + global.troopData:getSupply()
    
    local buff_arr  =  {} 
    local datatype={3064}
    for _ ,v in pairs(global.buffData:getBuffs()) do 
        if global.EasyDev:CheckContrains(datatype,v.lID)  then
            table.insert(buff_arr,v)
        end 
    end

    local all_add = 0 

    local loradEquipBuff =  0  --领主装备buff 减粮hao
    global.userData:getLordEquipBuff(3064 , function (val ) 
         loradEquipBuff = val 
    end)

    all_add = all_add + loradEquipBuff

    for _ ,v in pairs(buff_arr) do 
        all_add = all_add  + v.lParam
    end 

    -- dump(all_add,"all_add")
    -- 粮耗=基础粮耗*（1-加成粮耗）
    return math.ceil( totalConump * (1 - all_add / 100 ))
end


------------------------- 获取产量/h ----------------------
function _M:getPerProduce( curLevel, buildType )
    
    local curLvProduce = 0
    local buildRes = luaCfg:buildings_resource()

    for _,v in pairs(buildRes) do
        if v.buildingType == buildType and v.level == curLevel then
            curLvProduce = v.perProduce
            return curLvProduce
        end
    end
    return curLvProduce
end

---------------------------- 资源建筑 -----------------------

function _M:getBuildResByType( buildType )

    local resBuild = {}
    local registerBuild = cityData:getRegistedBuild()
    for i,v in ipairs(registerBuild) do
        if v.buildingType == buildType then
            
            local perProduce = self:getPerProduce(v.serverData.lGrade, v.buildingType)
            local speedAdd = self:getBuildAdd(v.id, v.serverData.lGrade, v.buildingType)
            v.speedAdd = speedAdd + self:getOwnBuildRes(v.buildingType, perProduce)
            table.insert(resBuild, v)
        end
    end

    table.sort( resBuild, function(s1, s2) 
        if s1.serverData.lGrade == s2.serverData.lGrade then
            return s1.speedAdd > s2.speedAdd
        else
            return s1.serverData.lGrade > s2.serverData.lGrade
        end
    end)

    return resBuild
end

-- 自己城池资源容量加成
function _M:getOwnBuildRes(buildingType, perProduce)

    local resId = 0
    local data = luaCfg:buildings_resource()
    for _,v in pairs(data) do
        if v.buildingType == buildingType then
            resId = v.itemId
            break
        end
    end

    local m_addValue = 0
    if self.occupyMax and self.occupyMax.lCitys then
        m_addValue = self:getAddValuePlusInfo(self.occupyMax.lCitys.tagPlusInfo, resId, 2)
    end
    m_addValue = m_addValue*perProduce/100
    return m_addValue
end

--资源野地
function _M:getWildResByType(resType)

    local resBuild = {}
    for i,v in pairs(self.worldWild) do
        local wildRes = luaCfg:get_wild_res_by(v.lKind)
        if wildRes.itemtype == resType then
            local _,speedAdd = self:getWildAdd(resType)
            v.speedAdd = speedAdd or 0
            table.insert(resBuild, v)
        end
    end

    table.sort( resBuild, function(s1, s2) 
        local s1Data = luaCfg:get_wild_res_by(s1.lKind)
        local s2Data = luaCfg:get_wild_res_by(s2.lKind)
        if s1Data.level == s2Data.level then
            return s1.speedAdd > s2.speedAdd
        else
            return s1Data.level > s2Data.level
        end
    end)

    return resBuild
end

-- 占领城池
function _M:getCityResData()

    return self.worldCity
end


------------------------- 总资源加成/h ----------------------
function _M:getTotalResAdd( resId )
    
    local totalAdd = 0
    local wildAdd = self:getWildAdd(resId, true)
    local cityAdd = self:getCityAddByType(resId)
    local petAdd = self:getPetAdd(resId)

    -- 英雄、科技、占卜、增益、vip、道具
    local heroAdd, techAdd, divAdd, cityBuff, itemAdd, vipAdd ,lordBuff= self:getServerBuff(resId)
    totalAdd = itemAdd+wildAdd+cityAdd+vipAdd+techAdd+divAdd+cityBuff+heroAdd+lordBuff+petAdd
    return totalAdd
end

function _M:getServerBuff(resId)
    
    local heroAdd, techAdd, divAdd  = 0, 0, 0
    local cityBuff, itemAdd, vipAdd  = 0, 0, 0
    local lordBuff  = 0 

    self.severResAdd = self.severResAdd or {}
    for _,v in pairs(self.severResAdd) do
        
        if v.lBind == resId then
            heroAdd  = v.heroAdd
            techAdd  = v.techAdd
            divAdd   = v.divAdd
            cityBuff = v.cityBuff
            itemAdd   = v.itemAdd
            vipAdd   = v.vipAdd
            lordBuff = v.lordBuff

        end
    end

    return heroAdd, techAdd, divAdd, cityBuff, itemAdd, vipAdd , lordBuff
end

-- 神兽加成
function _M:getPetAdd(resId)

    local curFightPet = global.petData:getGodAnimalByFighting()
    if curFightPet and curFightPet.type == 3 then -- 内政型

        local add = 0
        local petConfig = global.petData:getPetConfig(curFightPet.type, curFightPet.serverData.lGrade) 
        local propertys = petConfig.propertyValue
        for k,v in pairs(propertys) do
            
            local dataC = global.luaCfg:get_data_type_by(v[1])
            local val = v[2]/100
            local isBaseBuff = dataC.typeId == 1 and dataC.resType == resId     -- 农田加成
            local isAllBuff  = dataC.typeId == 1 and dataC.resType == 0         -- 全资源建筑加成
            if isBaseBuff or isAllBuff then
                add = add + val
            end
        end

        if add > 0 then

            local addVal = 0
            local buildType = resType[resId].buildResType
            local registerBuild = cityData:getRegistedBuild()
            for _,v in ipairs(registerBuild) do
                if v.buildingType == buildType then
                    local level = v.serverData.lGrade
                    local perProduce = self:getPerProduce(level, v.buildingType)
                    addVal = addVal + math.floor(perProduce*add/100)
                end
            end 
            return addVal
        else
            return 0
        end
    end
    return 0
end

function _M:setServerBuff(msg)

    self:setOldBuff(msg)-- 保留一份最近请求的数据  领主装备刷新时不用重新请求。

    self.severResAdd = {}

    -- 类型建筑加成
    local resAddCall = function (addEffect, buildType, addValue)
        
        local add = 0
        local registerBuild = cityData:getRegistedBuild()
        for _,v in ipairs(registerBuild) do
            if v.buildingType == buildType then
                local level = v.serverData.lGrade
                local perProduce = self:getPerProduce(level, v.buildingType)
                if addValue then
                    add = math.floor(add + addValue)
                else
                    add = math.floor(add + perProduce*addEffect)
                end
            end
        end
        return add
    end

    -- 具体某个建筑加成
    local resAddIdCall = function (addEffect, buildId)
        
        local add = 0
        local registerBuild = cityData:getRegistedBuild()
        for _,v in ipairs(registerBuild) do
            if v.id == buildId then
                local level = v.serverData.lGrade
                local perProduce = self:getPerProduce(level, v.buildingType)
                add = math.floor(add + perProduce*addEffect)
            end
        end
        return add
    end

    -- 检测建筑类型
    local checkBuildType = function (ltarget, buildType)     
        local posData = luaCfg:buildings_pos()
        for _,v in pairs(posData) do
            if v.id == ltarget and v.buildingType == buildType then
                return true
            end
        end
        return false
    end

    -- 采集加成处理
    local resCollectAddCall = function (addEffect, curResId)
        local add = 0
        local allWild = self:getWildResByType(curResId)
        for k,v in pairs(allWild) do
            local designerData = global.luaCfg:get_wild_res_by(v.lKind) -- 野地基础采集速度
            add = add + designerData.yield*addEffect
        end
        return add
    end

    -- 采集英雄加成
    local resCollectHeroAdd = function (curResId)

        local heroAdd = 0
        local allWild = self:getWildResByType(curResId)
        for k,v in pairs(allWild) do

            local troopsData = global.troopData:getTroopsByCityId(v.lResID)
            if #troopsData > 0 then
                local heroData = troopsData[1].lHeroID or {}
                if heroData[1] and heroData[1] > 0  then

                    local heroData = global.heroData:getHeroDataById(heroData[1])
                    local gov = global.heroData:getHeroProperty(heroData,3)
                    local totalAdd = math.floor(gov / luaCfg:get_config_by(1).garrisonScale) + 200
                    heroAdd = heroAdd + totalAdd
                end
            end
        end
        return heroAdd
    end

    local callGet = function (data, curResId)
        if not data then return end
        local maxAdd = 0
        for _,v in pairs(data) do
            
            local dataType = luaCfg:get_data_type_by(v.lEffectID)
            local addEffect = v.lVal/(100*dataType.magnification)
            local addValue = 0

            -- 针对具体某个建筑的加成（exp:道具加成）
            if v.lTarget > 0 then
                if checkBuildType(v.lTarget, resType[curResId].buildResType)  then
                    addValue = resAddIdCall(addEffect, v.lTarget)
                end
            else
                -- 英雄驻防特殊处理
                if dataType.extra == "" and  dataType.type == "hero" then
                    addValue = resAddCall(addEffect, resType[curResId].buildResType, v.lVal)
                else
                    if dataType.typeId == 3061 then -- 采集加速
                        addValue = resCollectAddCall(addEffect, curResId)
                    else
                        addValue = resAddCall(addEffect, resType[curResId].buildResType)
                    end
                end
            end
            maxAdd = maxAdd + addValue
        end
        return maxAdd
    end

    for _,v in pairs(msg) do
        
        local temp = {}
        temp.lBind = v.lBind
        temp.heroAdd = callGet(v.serverData.heroBuff, v.lBind) + resCollectHeroAdd(v.lBind)
        temp.techAdd = callGet(v.serverData.techBuff, v.lBind)  
        temp.divAdd = callGet(v.serverData.divineBuff, v.lBind) 
        temp.cityBuff = callGet(v.serverData.cityBuff, v.lBind) 
        temp.itemAdd = callGet(v.serverData.itemBuff, v.lBind)
        temp.vipAdd = callGet(v.serverData.vipBuff, v.lBind) 
        temp.lordBuff = callGet(v.serverData.lordBuff, v.lBind) 
        table.insert(self.severResAdd, temp)
    end

end


function _M:getOldBuff()
    return self.oldMsg
end 

function _M:setOldBuff(msg)
    self.oldMsg = clone(msg)
end 

--野地资源加成
function _M:getWildAdd( itemId, isWildBaseAdd )

    for k,v in pairs(resType) do
        if v.itemId == itemId then
            local totalAdd = self:getWildNum(itemId)
            if isWildBaseAdd then
                totalAdd = self:getWildBaseNum(itemId)
            end
            return totalAdd   
        end
    end
end

--获取英雄加成，英雄加成所有资
function _M:getHeroAddRes(curResId)

    local baseRes = self.resAll[curResId].baseRes
    local buf = global.buffData:getBuffs()    
    local res = 0
    for k,v in pairs(buf) do
        if v.lID == 2001 then
            
            res = res + v.lParam
        end
    end
    
    return math.floor(res * baseRes / 10000)
end

function _M:getWildNum( itemId )

    -- local getGarrisonAdd = function (lResID, wildBase)
    --     -- body
    --     local troopsData = global.troopData:getTroopsByCityId(lResID)
    --     for _,v in ipairs(troopsData) do
    --         v._tempData = {}
    --         local heroId = 0
    --         if v.lHeroID then
    --             heroId = v.lHeroID[1] 
    --         end 
    --         if heroId == 0 then
    --             v._tempData.add = 0        
    --         else
    --             local addVal = global.heroData:getHeroGovAdd(heroId)
    --             v._tempData.add = math.floor(addVal * wildBase) + 200
    --         end        
    --     end
        
    --     if table.nums(troopsData) > 0 then
    --         table.sortBySortList(troopsData,{{"_tempData.add","max"}})
    --         return troopsData[1]._tempData.add
    --     else
    --         return 0
    --     end
    -- end

    local totalAdd = 0
    local registBuild = self:getBuildResByType(buildTypeId)
    for _,v in pairs(self.worldWild) do
        local wildRes = luaCfg:get_wild_res_by(v.lKind)
        local troopsData = global.troopData:getTroopsByCityId(v.lResID)
        if wildRes.itemtype == itemId  and #troopsData > 0 then -- 只有驻防英雄才能有资源加成
            -- totalAdd = totalAdd + wildRes.yield + getGarrisonAdd(v.lResID, wildRes.yield)
            v.lCollectSpeed = v.lCollectSpeed or 0
            totalAdd = totalAdd + v.lCollectSpeed 
        end
    end
    return totalAdd
end

-- 获取占领野地基础加成
function _M:getWildBaseNum( itemId )
    local totalAdd = 0
    local registBuild = self:getBuildResByType(buildTypeId)
    for _,v in pairs(self.worldWild) do
        local wildRes = luaCfg:get_wild_res_by(v.lKind)
        local troopsData = global.troopData:getTroopsByCityId(v.lResID)
        if wildRes.itemtype == itemId  and #troopsData > 0 then -- 只有驻防英雄才能有资源加成
            totalAdd = totalAdd + wildRes.yield  
        end
    end
    return totalAdd
end

function _M:getWildNumByResId(lResID)
    -- body

    -- local getGarrisonAdd = function (lResID, wildBase)
    --     -- body
    --     local troopsData = global.troopData:getTroopsByCityId(lResID)
    --     for _,v in ipairs(troopsData) do
    --         v._tempData = {}
    --         local heroId = 0
    --         if v.lHeroID then
    --             heroId = v.lHeroID[1] 
    --         end 
    --         if heroId == 0 then
    --             v._tempData.add = 0        
    --         else
    --             local addVal = global.heroData:getHeroGovAdd(heroId)
    --             v._tempData.add = math.floor(addVal * wildBase) + 200
    --         end        
    --     end
    --     table.sortBySortList(troopsData,{{"_tempData.add","max"}})
    --     return troopsData[1]._tempData.add
    -- end

    local totalAdd = 0
    local registBuild = self:getBuildResByType(buildTypeId)
    for _,v in pairs(self.worldWild) do
        -- local wildRes = luaCfg:get_wild_res_by(v.lKind)
        -- local troopsData = global.troopData:getTroopsByCityId(v.lResID)
        -- if v.lResID == lResID  and #troopsData > 0  then -- 只有驻防英雄才能有资源加成
        --     totalAdd = totalAdd + wildRes.yield + getGarrisonAdd(v.lResID, wildRes.yield)
        -- end
        v.lCollectSpeed = v.lCollectSpeed or 0
        totalAdd = totalAdd + v.lCollectSpeed 
    end
    return totalAdd

end

--城池特色加成 
function _M:getCityAddByType(resId)

    -- 占领加成
    -- local o_addValue = 0
    -- for _,v in pairs(self.worldCity) do
    --     if v.tagPlusInfo then

    --         o_addValue = self:getAddValuePlusInfo(v.tagPlusInfo, resId)
    --     end
    -- end

    --自己城池加成 (UIResPanel送服务请求数据更新)
    local m_addValue = 0 
    if self.occupyMax and self.occupyMax.lCitys then
        m_addValue = self:getAddValuePlusInfo(self.occupyMax.lCitys.tagPlusInfo, resId, 1)
    end

    local curBuildType = resType[resId].buildResType
    local basePro = self:getProduce(curBuildType)  
    local basResAdd = math.floor(m_addValue*basePro/100)

    return basResAdd
end

function _M:getAddValuePlusInfo(tagPlusInfo, resId, typeId)
    
    local addValue = 0
    for _,pair in pairs(tagPlusInfo) do
                
        local data = luaCfg:get_data_type_by(pair.lID)
        if typeId then
            local isResAdd = data.resType == resId 
            local isResAll = data.resType == 0 --全资源产量加成
            if data and data.typeId == typeId then
                if isResAdd or isResAll then
                    addValue = addValue + pair.lValue
                end
            end
        else
            if data and  data.resType == resId then
                addValue = addValue + pair.lValue
            end
        end      
    end
    return addValue
end

--- 获取资源野地、占领城池当前以及上限值
function _M:updateOccupy()
    local mainCityId = global.userData:getWorldCityID()
    global.worldApi:getCityDetail(mainCityId,function(msg)
        self:setOccupyMaxInfo(msg)
        gevent:call(global.gameEvent.EV_ON_UI_LEISURE)       
    end)
end

function _M:setOccupyMaxInfo(msg)
    
    self.occupyMax = msg
end

function _M:getOccupyMaxInfo()

    return self.occupyMax
end

---------------------------- 加速道具加成 -----------------------
function _M:getSpeedItemAdd( itemId )

    for k,v in pairs(resType) do
        if v.itemId == itemId then
            local curPer, totalAdd = self:getSpeedNum(v.buildResType)
            return curPer, totalAdd   
        end
    end
end

function _M:getSpeedNum( buildTypeId )
    
    local totalAdd, addBuildNum = 0, 0
    local registBuild = self:getBuildResByType(buildTypeId)
    for _,v in pairs(registBuild) do
        
        local buildAdd = self:getBuildAddNoHeroBuff(v.id, v.serverData.lGrade, buildTypeId)
        totalAdd = totalAdd + buildAdd
        if buildAdd ~= 0 then addBuildNum = addBuildNum + 1 end
    end
    local registerBuild = self:getSpeedItemAddMax(buildTypeId)
    local curPer = (addBuildNum/registerBuild)*100
    return curPer, totalAdd
end

function _M:getSpeedItemAddMax( buildTypeId )
    local buildNum = 0
    local registerBuild = cityData:getRegistedBuild()
    for i,v in ipairs(registerBuild) do
        if v.buildingType == buildTypeId then
            buildNum = buildNum + 1
        end
    end
    return buildNum
end
function _M:getBuildAdd( buildId, currentLv, buildTypeId )
    
    local buf = global.buffData:getBuffs()
    local speedAdd = 0
    local allRes = self:getPerProduce(currentLv, buildTypeId)
    for k,v in pairs(buf) do 
        if v.lTarget == buildId and v.lID == 1 then
            speedAdd = speedAdd + allRes
        end

        if v.lID == 2001 then

            speedAdd = speedAdd + math.floor(v.lParam * allRes / 10000)
        end
    end
    return speedAdd
end

function _M:getBuildAddNoHeroBuff( buildId, currentLv, buildTypeId )
    
    local buf = global.buffData:getBuffs()
    local speedAdd = 0
    local allRes = self:getPerProduce(currentLv, buildTypeId)
    for k,v in pairs(buf) do
        -- lID = 1 paraName="产量/小时",
        if v.lTarget == buildId and v.lID == 1 then
            speedAdd = speedAdd + allRes
        end
    end
    return speedAdd
end

-- 每个资源建筑的加速道具加成值
function _M:getBuildAddById( buildTypeId )
    
    local buf = global.buffData:getBuffs()
    local speedAdd = 0
    for k,v in pairs(buf) do
        if v.lTarget == buildTypeId then
            speedAdd = v.lParam
        end
    end
    return speedAdd
end


global.resData = _M
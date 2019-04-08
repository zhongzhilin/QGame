--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global
local luaCfg = global.luaCfg
local gameEvent = global.gameEvent

local _M = {}
local MAX_ID_KEY = 'data_equip_max_gid'

function _M:init(data)
    
    data = data or {}

    for _,v in ipairs(data) do

        self:bindConfData(v)
    end

    self.data = data
    self.historyMaxID = self:getHistoryMaxID()
    -- self:initSign()

end

function _M:getMaxID()
    
    local MaxID = -1
    for _,v in ipairs(self.data) do

        if v.lID > MaxID then

            MaxID = v.lID
        end
    end

    return MaxID
end

function _M:getEquips()
    
    return self.data
end

--返回强化的装备数据
function _M:getStrongEquipsForUI()

    local res = {}
    for _,v in ipairs(self.data) do

        v._tmpData = {isCanSuit = true,isInBagPanel = true}
        v._tmpData.isNew = self:checkSignEquip(v.lID)

        if self:checkCanStrong(v.lID) then 
            table.insert(res,v)                       
        end 
    end     

    self:sortForStrong(res)

    return res
end


function _M:sortForStrong(data)
    -- body
    table.sortBySortList(data,{{'lHeroID','max'},{"_tmpData.isNew","true"},{"_tmpData.isCanSuit","true"},{"lCombat","max"},{"confData.quality","max"},{"lGID","min"}})
end

--判断装备是否达到上限
function _M:isEquipLimit()
    
    return self:getFreeEquipCount() >= global.luaCfg:get_config_by(1).equipLimit
end

--获取装备数量（不包括一穿戴）
function _M:getFreeEquipCount()
    
    local count = 0

    for _,v in ipairs(self.data or {} ) do
        if v.lHeroID == 0 then
            count = count + 1
        end
    end         

    return count
end

--返回背包的装备数据
function _M:getAllEquipsForUI(equips_type)

    local res = {}
    for _,v in ipairs(self.data) do

        if v.lHeroID == 0 then

            local flg = false 

            if equips_type and equips_type == 1 and v.confData and v.confData.itemType == 2000  then --领主装备 
                flg = true 
            end 

            if  equips_type and equips_type ~= 1 and v.confData and v.confData.itemType ~= 2000 then --英雄装备
                flg = true 
            end
            
            if not equips_type  then --返回所有

                flg = true 
            end 

            if flg then 
                v._tmpData = {isCanSuit = true,isInBagPanel = true,isShowLv = true}
                v._tmpData.isNew = self:checkSignEquip(v.lID)
                table.insert(res,v)        
            end 
        end                
    end     

    self:sortEquipsData(res)

    return res
end

--获取空闲的装备by index
function _M:getFreeEquipsByIndex(index,heroId)

    if index == -1 and heroId == -1 then return self:getAllEquipsForUI() end

    local hData = global.heroData:getHeroDataById(heroId)

    local res = {}

    for _,v in ipairs(self.data) do
        if v.lHeroID == 0  then
            local flg =  false 
            if hData.heroId == 1  then 
                if  v.confData.type == index and self:checkLordEquip(hData.heroId , v.confData)  then 
                    flg = true 
                end 
            else
                if v.confData.type == index  and not (v.confData.onlyHero ~= 0 and v.confData.onlyHero ~= heroId) then 
                    flg = true 
                end 
            end 
            if flg then 
                self:checkHeroTarget(hData,v)
                v._tmpData.isNew = self:checkSignEquip(v.lID)
                table.insert(res,v)
            end 
        end                
    end     

    --self:sortEquipsData(res)

    table.sortBySortList(res,{{"_tmpData.isCanSuit","true"},{"_tmpData.isNew","true"},{"lCombat","max"},{"confData.quality","max"},{"lGID","min"}})

    return res
end

function _M:sortEquipsData(data)
    
    --规则 是否是新的 能否装备，战斗力，品质
    table.sortBySortList(data,{{"_tmpData.isNew","true"},{"_tmpData.isCanSuit","true"},{"lCombat","max"},{"confData.quality","max"},{"lGID","min"}})
end


function  _M:checkLordEquip(heroId ,equip ) --是否检测领主装备
    return  ( heroId == 1  and   equip.itemType == 2000 )
end 

function _M:equipNotify(data)

    if not data then return end
    if not self.data then return end
    
    if data.lReason == 0 then

        local eData = data.tagEquip
        self:bindConfData(eData)

        for i,v in ipairs(self.data) do

            if v.lID == eData.lID then

                table.remove(self.data,i)
                break
            end
        end

        table.insert(self.data, eData or {})
    elseif data.lReason == 1 then

        local eData = data.tagEquip
        for i,v in ipairs(self.data) do

            if v.lID == eData.lID then

                table.remove(self.data, i)
                break
            end
        end
    end       
end

--判断英雄是否满足
function _M:checkHeroTarget(hData,v)

    v._tmpData = {}    

    if hData.serverData.lGrade >= v.confData.lv then

        v._tmpData.isCanSuit = true                
    else

        v._tmpData.isCanSuit = false
        v._tmpData.cannotRes = 1
    end    

    v._tmpData.isShowLv = true
end

function _M:getEquipById(id)
    
    for _,v in ipairs(self.data) do

        if v.lID == id then

            return v
        end
    end    

    -- log.error("can not find equip id"..id)
    return nil
end

function _M:bindConfData(data)
        
    local equipment = luaCfg:get_equipment_by(data.lGID)

    if not equipment then 

        equipment = luaCfg:get_lord_equip_by(data.lGID)
    end 

    data.confData = equipment
end

function _M:getDumpList()

    local res = {}
    for _,v in ipairs(self.data) do

        if v.lHeroID == 0 then
            -- if self:checkCanStrong(v.lID) then 
                table.insert(res,v)
                v._tmpData = {isCanSuit = true,isInBagPanel = true}  
                v._tmpData.isNew = self:checkSignEquip(v.lID)      
            -- end 
        end                
    end     

    table.sortBySortList(res,{{"confData.quality","min"},{"lCombat","min"},{"confData.lv","min"}})

    return res
end

--通过heroid和部件index获取装备id
function _M:getHeroEquipByIndex(heroId,index)

    for _,v in ipairs(self.data) do

        if v.lHeroID == heroId and v.confData.type == index then

            return v.lID            
        end
    end

    return -1  
end

--获取英雄的所有装备
function _M:getHeroEquips(heroId)

    local res = {}
    for i = 1,6 do
        
        table.insert(res,self:getHeroEquipByIndex(heroId,i))
    end

    return res    
end

function _M:colNextStrongCombat(data,level)
    
    level = level or data.lStronglv + 1
    
    local res = 0
    local buffPro = luaCfg:get_equip_strengthen_by(level).buffPro

    local att = {}

    for i = 1,4 do

        local key = WCONST.BASE_PROPERTY[i].KEY
        local att = data.tgAttr[i] + math.ceil(data.confData[key] * (buffPro / 100))        

        if i == 4 then
            res = res + math.floor(att / 10)
        else
            res = res + att
        end
    end

    if level == data.lStronglv then

        return data.lCombat
    elseif level < data.lStronglv then

        return res
    elseif level > data.lStronglv then

        return res
    end
    --math.ceil(data.confData.baseCombat * buffPro) 
end

-- 计算一件装备的4个属性
function _M:colServerAtt(level,id)    

    local confData = luaCfg:get_equipment_by(id)

    local res = {}

    if level > 0 then
        for j=1,level do
            for i = 1,4 do
                local key = WCONST.BASE_PROPERTY[i].KEY
                res[i] = res[i] or confData[key]
                local buffPro = luaCfg:get_equip_strengthen_by(j).buffPro / 100
                res[i] = res[i] + math.ceil(confData[key] * buffPro)
            end
        end
    else
        for i = 1,4 do
            local key = WCONST.BASE_PROPERTY[i].KEY            
            res[i] = confData[key]
        end
    end

    return res
end

function _M:colNextStrongPro(data,index,level)
    
    level = level or data.lStronglv + 1

    local key = WCONST.BASE_PROPERTY[index].KEY
    local buffPro = luaCfg:get_equip_strengthen_by(level).buffPro / 100

    if level == data.lStronglv then

        return data.tgAttr[index]-- + math.ceil(data.confData[key] * buffPro)
        -- return data.lCombat-- + res
    elseif level < data.lStronglv then

        return data.tgAttr[index] - math.ceil(data.confData[key] * buffPro)
        -- return data.lCombat - res
    elseif level > data.lStronglv then
    
        return data.tgAttr[index] + math.ceil(data.confData[key] * buffPro)
        -- return data.lCombat + res
    end

    -- return data.tgAttr[index] + math.ceil(data.confData[key] * buffPro)
end

--判断是否有可以穿的战斗力更加好的装备
function _M:isHaveBetterOneCanSuit(heroData,curCombat,index)

    local heroId = heroData.heroId    

    for i,v in ipairs(self.data) do

        if v.lHeroID == 0 then
        
            local confData = v.confData        

            if confData.type == index  then

                if heroData.heroId == 1   then --检测领主

                    if heroData.serverData.lGrade >= confData.lv and v.lCombat > curCombat  and self:checkLordEquip(heroId , confData) then
                        return true
                    end

                else -- 检测英雄
                    
                    if  not  (confData.onlyHero ~= 0 and confData.onlyHero ~= heroId) then 

                        if heroData.serverData.lGrade >= confData.lv and v.lCombat > curCombat then
                            return true
                        end
                    end 
                end 
            end
        end
    end

    return false
end


--查询是否有可以装备的道具 0->没有对应装备 1->有装备但是不能装备 2->有可以装备的装备
function _M:getHeroEquipState(heroData,index)


    local heroId = heroData.heroId
    local isHaveOne = false

    for i,v in ipairs(self.data) do

        if v.lHeroID == 0 then
        
            local confData = v.confData        

            if heroId == 1  then --检测领主

                if  confData.type == index  and  self:checkLordEquip(heroId , confData) then
                    isHaveOne = true
                    if heroData.serverData.lGrade >= confData.lv then

                        return 2
                    end
                end

            else -- 检测英雄

                if confData.type == index and not (confData.onlyHero ~= 0 and confData.onlyHero ~= heroId) then
                    isHaveOne = true
                    if heroData.serverData.lGrade >= confData.lv then

                        return 2
                    end
                end

            end 
        end    
    end

    if isHaveOne then

        return 1
    else

        return 0
    end
end


-- function _M:getSignEquipKey()
    
--     return string.format("data_equip_be_open_%s",id)
-- end

function _M:getHistoryMaxID()
    
    return cc.UserDefault:getInstance():getIntegerForKey(MAX_ID_KEY,0)
end


function _M:signMaxID()
    
    local maxID = self:getMaxID()
    if self.historyMaxID < maxID then
        self.historyMaxID = maxID 
        cc.UserDefault:getInstance():setIntegerForKey(MAX_ID_KEY,self:getMaxID())
    end    
end

-- function _M:signEquipBeOpen(id)
   
--     self.signData[id] = false
--     cc.UserDefault:getInstance():setBoolForKey(self:getSignEquipKey(id),false)
-- end

-- function _M:checkSignEquipByData(id)
    
--     return cc.UserDefault:getInstance():getBoolForKey(self:getSignEquipKey(id),true)
-- end

function _M:checkSignEquip(id)
    
    return id > self.historyMaxID
    -- return self.signData[id]
end

-- function _M:initSign()
    
--     self.signData = {}
--     setmetatable(self.signData, {__index = function(tb,key)
        
--         print(">>check new")
--         tb[key] = self:checkSignEquipByData(key)
--         return tb[key]  
--     end})
-- end

--判断这个装备是否已经被hero装备
function _M:isEquipOnHero(id,heroId)
    
    for _,v in ipairs(self.data) do

        if v.lGID == id and v.lHeroID == heroId then
            return true
        end
    end

    return false
end

--判断这个装备是否已拥有
function _M:isEquipGot(id)
    
    for _,v in ipairs(self.data) do

        if v.lID == id then
            return true
        end
    end

    return false
end

--为其他人的装备计算套装数量
function _M:calculateSuitData(otherEquips)
    
    if not otherEquips then return end
    local euqipTb = {}
    for _,data in ipairs(otherEquips) do
        if data.lGID then
            euqipTb[data.lGID] = true
        end
    end

    for _,data in ipairs(otherEquips) do

        if data.lGID then
            data.isOther = true
            local kind = luaCfg:get_equipment_by(data.lGID).kind
            local otherSuitList = {}
            if kind ~= 0 then

                local suitData = luaCfg:get_equipment_suit_by(kind)
                local allSuit = suitData.equipment

                for index,id in ipairs(allSuit) do

                    otherSuitList[index] = euqipTb[id]
                end

                data.otherSuitList = otherSuitList
            end
        end
    end
end

function _M:checkCanStrong(id) --领主装备不能被分解 和 强化

   for _,v in ipairs(self.data) do

        if v.lID == id then

            return v.confData.itemType ~= 2000
        end
    end

    return true 
end 

-- 检测当前套装是否可以锻造
function _M:checkSuitTypeCanForge(forgeId)

    local forgeSuit = luaCfg:forge_suit()
    for _,v in ipairs(forgeSuit) do
        if v.forgeId == forgeId then
            if v.suitType == 1 then
                for i=1,3 do
                    local curSuitId = v["suit"..i.."Id"]
                    if self:checkSuitCanForge(curSuitId) then
                        return true
                    end
                end
            else
                if self:checkSuitCanForge(v.lordId) then
                    return true
                end
            end
        end
    end
    return false
end

-- 检测领主/英雄套装是否可以锻造
function _M:checkSuitKindCanForge(suitType)

    local forgeSuit = luaCfg:forge_suit()
    for _,v in ipairs(forgeSuit) do
        if v.suitType == suitType then
            if suitType == 1 then
                for i=1,3 do
                    local curSuitId = v["suit"..i.."Id"]
                    if self:checkSuitCanForge(curSuitId) then 
                        return true 
                    end
                end
            else
                if self:checkSuitCanForge(v.lordId) then 
                    return true 
                end
            end
        end
    end
    return false
end

-- 检测当前套装(攻击、防御、内政)是否可以锻造
function _M:checkSuitCanForge(suitId)

    local suitData = luaCfg:get_equipment_suit_by(suitId)
    if suitData then
        for i,v in ipairs(suitData.equipment) do
            if self:checkEquipCanForge(v) then
                return true
            end
        end  
    end
    return false
end

-- 检测当前装备(领主/英雄)是否可以锻造
function _M:checkEquipCanForge(equpeId)
    -- body
    local isResEnougth = true
    local isMaterialEnouth = true

    local forgeEqip = luaCfg:get_forge_equip_by(equpeId)
    if forgeEqip then

        -- 资源是否充足
        local woodEnough =  global.cityData:checkResource(forgeEqip.res1)
        local stoneEnough =  global.cityData:checkResource(forgeEqip.res2)
        isResEnougth = woodEnough and stoneEnough

        -- 材料是否足够
        local checkMaterialEnough = function (data)
            local havCount = global.normalItemData:getItemById(data[1]).count
            if havCount >= data[2] then
                return true
            end
            return false
        end
        for i = 1,6 do
            local balanceData = forgeEqip["material"..i]
            if balanceData and balanceData[1] then
                isMaterialEnouth = isMaterialEnouth and checkMaterialEnough(balanceData)
            end    
        end
        local isCanForge = isMaterialEnouth and isResEnougth
        return isCanForge
    else
        return false
    end
end


global.equipData = _M

--endregion

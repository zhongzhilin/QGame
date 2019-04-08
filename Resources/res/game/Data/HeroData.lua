local _M = {}

local luaCfg = global.luaCfg
local gameEvent = global.gameEvent

function _M:init( msg, tagBuildGarrison )

    -- dump(msg,">>>>>>>>>>>>>>>>hero data init ")

    msg = msg or {}
    if self.serverData and table.nums(self.serverData) > 0 then
        table.assign(self.serverData,msg)
    else
       
        --服务器数据
        self.serverData = msg

        -- 所有英雄数据
        local tb_allHero =  luaCfg:hero_property()
        self._heroData = tb_allHero
    end

    for _,v in pairs(self.serverData) do
        
        if v.lState == 0 then

            self:refershHeroState(v.lID,1)
        elseif v.lState == 1 then

            self:refershHeroState(v.lID,3)
        elseif v.lState == -1 then

            self:refershHeroState(v.lID,2)
        elseif v.lState == 2 then

            self:refershHeroState(v.lID,4)
        end        
    end

    self._normalHeroData = {}   -- 普通英雄
    self._vipHeroData = {}      -- 史诗英雄
    self._recruitHeroData = {}  -- 已招募英雄

    self:sortHeroData()
    self:initHeroData()
    -- self:initPlus(plus)
    self:initImpress()

    -- 英雄驻防信息
    if self.tagBuildGarrison and table.nums(self.tagBuildGarrison) > 0 then
    else
        self.heroGarrisonList = {}
        self.tagBuildGarrison = {}
        self:setBuildGarrison(tagBuildGarrison or {})
        gevent:addListener(global.gameEvent.EV_ON_UI_HERO_FLUSH, function()
            global.heroData:refershBuildGarrison()
        end)
    end

end

function _M:initImpress()
    
    for _,vipHero in ipairs(self._vipHeroData) do

        local sData = self:getServerData(vipHero.heroId)
        if sData then

            vipHero.impress = sData.lImpress
        else

            vipHero.impress = 0
        end
    end
end

function _M:getHeroHeadData()   --获取驻防英雄头像数据
    
    return self:getHeroByGarrisonPos(1) or self:getHeroByGarrisonPos(2)
end

--获取英雄内政加成
function _M:getHeroGovAdd(heroId)
    
    local heroData = self:getHeroDataById(heroId)
    local gov = self:getHeroProperty(heroData,3)
    local add = math.floor(gov / 10) / 10000

    return add
end

function _M:deleteHero(id)
    
    print(">>>>>>function _M:deleteHero(id)",id)

    for _,vipHero in ipairs(self._vipHeroData) do

        if vipHero.heroId == id then
        
            vipHero.state = 0    
            vipHero.serverData = nil
            print(">>>>>delete vip ",id)
        end
    end

    for _,normalHero in ipairs(self._normalHeroData) do

        if normalHero.heroId == id then
        
            normalHero.state = 0    
            vipHero.serverData = nil
            print(">>>>>delete normal ",id)
        end
    end

    gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)
end

function _M:initPersuade(data,isInit)
    
    -- dump(data,">> initPersuade")

    for _,v in ipairs(data or {}) do

        if v.lID == 25 then

            self.persuadeData = v
            self.persuadeTime = v.lStartTime + v.lTotleTime
            gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)
            return
        end
    end

    if isInit then
        self.persuadeData = nil
        self.persuadeTime = 0
    end    
end

function _M:deletePersuade(data)
    for _,v in ipairs(data or {}) do
        if v.lID == 25 then
            print('yes delete persuade time')
            self.persuadeTime = 0
            self.persuadeData = nil
            return
        end
    end
end

--说服的时间
function _M:getPersuadeTime()
    
    return self.persuadeTime or 0
end

function _M:setPersuadeTime(i_a)
    self.persuadeData = nil
    self.persuadeTime = i_a
end

function _M:getPersuadeData()
    
    return self.persuadeData
end

function _M:updateVipHero(hero)

   -- dump(hero,">>check hero")

    --state 0：未结识 1：已拥有 2：已结识 3：正在出征
    
    if self._vipHeroData == nil then return end --在直通车之前的不进行处理

    for _,vipHero in ipairs(self._vipHeroData) do        

        if vipHero.heroId == hero.lID then

            table.copyMode2(hero,vipHero.serverData or {})

            -- dump(hero,">>>>>>>>after hero")

           vipHero.impress = hero.lImpress or 0
           if hero.lState == -1 then

                vipHero.state = 2
                vipHero.serverData = hero

                gevent:call(gameEvent.EV_ON_UI_HERO_KNOW)
           elseif hero.lState == 0 then           

                vipHero.state = 1
                vipHero.serverData = hero
                vipHero.endTime = nil
           elseif hero.lState == 1 then

                vipHero.state = 3
                vipHero.serverData = hero                
           elseif hero.lState == 2 then

                vipHero.state = 4
                vipHero.serverData = hero                
           else

                vipHero.state = 0
                vipHero.serverData = nil
                vipHero.endTime = nil
           end
        end
    end

    for _,normalHero in ipairs(self._normalHeroData) do

        if normalHero.heroId == hero.lID then
            
            table.copyMode2(hero,normalHero.serverData or {})

            --dump(hero,">>>>>>>>after hero")

            if hero.lState == 0 then           

                normalHero.state = 1
                normalHero.serverData = hero                
            elseif hero.lState == 1 then

                normalHero.state = 3                
                normalHero.serverData = hero 
            elseif hero.lState == 2 then

                normalHero.state = 4
                normalHero.serverData = hero                               
            elseif hero.lState == -1 then 

                normalHero.state =  2  
                normalHero.serverData = hero   
            else 

                normalHero.state = 0       
                normalHero.serverData = nil                         
            end

            -- normalHero.serverData = hero
        end
    end

    gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)

    -- 刷新英雄头像  
    global.headData:refershUseState()
    gevent:call(gameEvent.EV_ON_USER_FLUSHUSEMSG)
end

-- function _M:updatePlus(plus)

--     plus = plus or {}
--     local heroPlus = {} --结识剩余时间

--     for _,v in ipairs(plus) do

--         if v.lID == 22 or v.lID == 23 then

--             -- print(">>>>>>>table.insert(self.heroPlus,v)")
--             table.insert(heroPlus,v)
--         end
--     end

--     for _,v in ipairs(heroPlus) do

--         for _,vipHero in ipairs(self._vipHeroData) do

--             if v.lTarget == vipHero.heroId then

--                 if vipHero.state ~= 1 then
                
--                     if v.lID == 22 then
                
--                         vipHero.state = 2 --结识状态
--                         vipHero.endTime = v.lEndTime
--                     elseif v.lID == 23 then

--                         vipHero.persuadeWaitTime = v.lEndTime
--                     end                
--                 end                

--                 -- dump(vipHero,">>>>>>>v.endTime = v.lEndTime")
--             end
--         end
--     end

--     gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)
-- end

function _M:isCanBuy()
    return global.dataMgr:getServerTime() < global.dailyTaskData:getBornTime() + 7 * 86400  , (global.dailyTaskData:getBornTime() + 7 * 86400) -  global.dataMgr:getServerTime()
end

function _M:getHeroProperty(herodata,index)
    if not herodata then return 0 end
    if not herodata.serverData.lbase then return 0 end 
    return herodata.serverData.lbase[index] + herodata.serverData.lextra[index]
end

function _M:getHeroLBase(data)

    local lbase = {}
    local config = luaCfg:get_hero_strengthen_by(data.serverData.lID)
    if config then

        local grow = config["grow"..data.serverData.lStar]
        local growConfig = luaCfg:get_hero_grow_by(grow)

        local heroProConfig = luaCfg:get_hero_property_by(data.serverData.lID)

        local pergrow = math.ceil(heroProConfig.attack*growConfig.proGrow)
        local attackBase = heroProConfig.attack + pergrow*(data.serverData.lGrade-1)
        table.insert(lbase, attackBase)

        pergrow = math.ceil(heroProConfig.defense*growConfig.proGrow)
        local defBase = heroProConfig.defense + pergrow*(data.serverData.lGrade-1)
        table.insert(lbase, defBase)

        pergrow = math.ceil(heroProConfig.interior*growConfig.proGrow)
        local interiorBase = heroProConfig.interior + pergrow*(data.serverData.lGrade-1)
        table.insert(lbase, interiorBase)

        pergrow = growConfig.section1 + (growConfig.section1 + (data.serverData.lGrade - 2) * growConfig.section2)
        local commanderBase = heroProConfig.commander + pergrow * (data.serverData.lGrade - 1) / 2
        table.insert(lbase, commanderBase)

    end

    return lbase

end

function _M:getHeroLCombat(lv, id)
    local config = luaCfg:get_equipment_by(id)
    local attr = global.equipData:colServerAtt(lv, id)
    local baseCombat = config.extraCombat + attr[1] + attr[2] + attr[3] + math.floor(attr[4]/10) 
    return baseCombat
end

-- 获取来访英雄的数据
function _M:getHeroDataInCome()

    local res = {}
    local temp = self:getVipHeroData()
    for _,v in ipairs(temp) do
        if v.serverData then
            if v.state == 2 then
                return v
            end
        end
    end

    temp = self:getNormalHeroData()
    for _,v in ipairs(temp) do
        if v.serverData then
            if v.state == 2 then
                return v
            end
        end    
    end
end

function _M:getCommanderStr(herodata)
    
    -- local tb = {[0] = 10362,[1] = 10363,[2] = 10364,[3] = 10365,[4] = 10366,[6] = 10367}
    local tb = {
    [0] = {[0] = 10362,[1] = 10408,[2] = 10409},
    [1] = {[0] = 10363,[1] = 10396,[2] = 10397},
    [2] = {[0] = 10364,[1] = 10398,[2] = 10399},
    [3] = {[0] = 10365,[1] = 10400,[2] = 10401},
    [4] = {[0] = 10366,[1] = 10402,[2] = 10403},
    [6] = {[0] = 10367,[1] = 10404,[2] = 10405},
    }

    return luaCfg:get_local_string(tb[herodata.commanderType][herodata.secType]) 
end

function _M:getHeroMaxLevel()
    
    self.maxLevel = self.maxLevel or #luaCfg:hero_exp()

    return self.maxLevel
end

--
function _M:isHeroFree()
    
    local time = self:getPersuadeTime()

    for _,v in ipairs(self._vipHeroData) do

        if v.serverData then
            if v.state == 2 and time == 0 then

                return true
            end
        end        
    end

    return false
end

-- function _M:plusDone(plus)
    
--     plus = plus or {}
--     local heroPlus = {} --结识剩余时间

--     for _,v in ipairs(plus) do

--         if v.lID == 22 or v.lID == 23 then
        
--             table.insert(heroPlus,v)
--         end
--     end

--     for _,v in ipairs(heroPlus) do

--         for _,vipHero in ipairs(self._vipHeroData) do

--             if v.lTarget == vipHero.heroId then

--                 if vipHero.state ~= 1 then
                
--                     if v.lID == 22 then
                
--                         --改由hero的statechange来处理

--                         -- vipHero.state = 0 --待结识状态
--                         -- vipHero.endTime = nil
--                     elseif v.lID == 23 then

--                         vipHero.persuadeWaitTime = nil
--                     end                
--                 end                

--                 -- dump(vipHero,">>>>>>>v.endTime = v.lEndTime")
--             end
--         end
--     end

--     gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)
-- end

function _M:checkHeroIsHavaNewEquip(heroData)
    
    local equipData = global.equipData
    local equips = equipData:getHeroEquips(heroData.heroId)

    for i,v in ipairs(equips) do

        if v == -1 then
            
            local state = equipData:getHeroEquipState(heroData,i)
            if state == 2 then

                return true
            end
        end
    end

    return false
end

function _M:checkHeroIsCanUpdateSkill(heroData)

    local skillCount = #heroData.skill

    for _index,v in ipairs(heroData.serverData.lSkill) do

        if _index > skillCount then
            break
        end

        if v ~= 0 then

            local skillConf = luaCfg:get_skill_by(v)
            if skillConf then

                if skillConf.nextId ~= 0 then

                    local nextConf = luaCfg:get_skill_by(v + 1)
                    local isHaveEnouthBook = nextConf.itemNum <= global.normalItemData:getItemById(nextConf.lvupItem).count
                    
                    if isHaveEnouthBook and heroData.serverData.lGrade >= nextConf.heroLv then

                        return true
                    end
                end 
            end
        end
    end

    print("return false")
    return false
end

function _M:checkHeroIsCanUpdateStar(heroData)
    
    local items = luaCfg:item()
    local itemId = nil
    for _,v in pairs(items) do

        if v.itemType == 123 and v.typePara1 == heroData.heroId then

            itemId = v.itemId
            break
        end
    end

    if itemId == nil then return false end
    local hero_strengthen = luaCfg:get_hero_strengthen_by(heroData.heroId)   
    local key = 'item' .. (heroData.serverData.lStar + 1)
    if hero_strengthen[key] and #hero_strengthen[key] == 2 then
        return global.normalItemData:getItemById(itemId).count >= hero_strengthen[key][2]
    else
        return false
    end
end

function _M:isAnyOneCanSuit()

    local gotHeros = self:getGotHeroData()
    for _,v in ipairs(gotHeros) do
        
        if global.userData:getFreeLotteryCount() <= 0 or self:checkHeroIsHavaNewEquip(v) or self:checkHeroIsCanUpdateSkill(v) or self:checkHeroIsCanUpdateStar(v) then

            return true
        end
    end

    return false
end

function _M:isHeroActive(heroId) --获取可以出征的英雄
    
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 1 and v.heroId == heroId then

            return true
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 1 and v.heroId == heroId then
            
            return true
        end
    end

    return false
end

function _M:getActiveHero(heroId) --获取可以出征的英雄
    
    local res = {}
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 1 or v.heroId == heroId then

            table.insert(res,v)
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 1 or v.heroId == heroId then

            table.insert(res,v)
        end
    end

    return res
end

function _M:getGovActiveHero(heroId) --获取可以出征的英雄
    
    local res = {}
    for _,v in ipairs(self._vipHeroData) do

        if (v.state == 1) or v.heroId == heroId then

            table.insert(res,v)
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if (v.state == 1) or v.heroId == heroId then

            table.insert(res,v)
        end
    end

    return res
end

--是否有任意一个已结识的英雄
function _M:isAnyHeroInKnow()
    
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 2 then

            return true
        end
    end

    return false
end

function _M:getHeroByGarrisonPos(index)
        
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 4 and v.serverData.lPos == index then

            return v
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 4 and v.serverData.lPos == index then

            return v
        end
    end

    return nil
end

function _M:isGotHero(heroId)
    
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 then
            
            if heroId == v.heroId then
                return true
            end
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 then

            if heroId == v.heroId then
                return true
            end
        end
    end

    return false
end

function _M:getMaxCombatHeroData()
    
    local maxPower = -1
    local res = nil
    
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 then
            
            if maxPower < v.serverData.lPower then
                maxPower = v.serverData.lPower
                res = v
            end
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 then

            if maxPower < v.serverData.lPower then
                maxPower = v.serverData.lPower
                res = v
            end
        end
    end

    return res
end

function _M:getGotHeroData()
    
    local res = {}
    for _,v in ipairs(self._vipHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 and v.serverData then
            
            table.insert(res,v)
        end
    end

    for _,v in ipairs(self._normalHeroData) do

        if v.state == 1 or v.state == 3 or v.state == 4 and v.serverData then

            table.insert(res,v)
        end
    end

    return res
end

-- function _M:initPlus(plus)
    
--     dump(plus,">>>>>>>>>>>>>>>>plus")

--     plus = plus or {}
--     local heroPlus = {} --结识剩余时间

--     local contentTime = global.dataMgr:getServerTime()

--     self._isNeedShowWarning = false

--     for _,v in ipairs(plus) do

--         if v.lID == 22 or v.lID == 23 then

--             -- print(">>>>>>>table.insert(self.heroPlus,v)")
--             table.insert(heroPlus,v)
--         end
--     end

--     for _,v in ipairs(heroPlus) do

--         for _,vipHero in ipairs(self._vipHeroData) do

--             if v.lTarget == vipHero.heroId then                

--                 if vipHero.state ~= 1 then

--                     if v.lID == 22 then
                    
--                         if ((v.lEndTime - contentTime) / (v.lEndTime - v.lStartTime)) < 0.7 then

--                             self._isNeedShowWarning = true
--                         end

--                         -- vipHero.state = 2 --结识状态
--                         vipHero.endTime = v.lEndTime
--                     elseif v.lID == 23 then

--                         vipHero.persuadeWaitTime = v.lEndTime
--                     end                
--                 end
--                 -- dump(vipHero,">>>>>>>v.endTime = v.lEndTime")
--             end
--         end
--     end

    
-- end

function _M:getHeroAllMeetTime(id)
    -- local item = luaCfg:item()
    -- for _,v in pairs(item) do

    --     if v.itemType == 123 and v.typePara1 == id then

    --         return v.typePara2 * 60
    --     end
    -- end
    return 7 * 86400
end

function _M:isNeedShowWarning()
    
    -- if true then return false end 

    local contentTime = global.dataMgr:getServerTime()
    for _,v in ipairs(self._vipHeroData) do
        if v.state == 2 and v.serverData then

            local times = self:getHeroAllMeetTime(v.heroId)
            if ((v.serverData.lMeetTime - contentTime) / times) < 0.2 then
                
                return true
            end
        end
    end

    return false
    -- local tmp = self._isNeedShowWarning
    -- self._isNeedShowWarning = false
    -- return tmp
end

function _M:getServerData( heroId )
    
    for _,v in pairs(self.serverData) do
        if v.lID == heroId then
            return v
        end
    end
end

function _M:addServerData( heroId )
    
    for _,v in pairs(self._recruitHeroData) do
        if v.heroId == heroId then
            v.serverData = self:getServerData(heroId)
        end
    end
end

function _M:initHeroData()
    
    for _,v in pairs(self._heroData) do
        
        v.state = v.state or 0
        -- v.useState = 0

        if  v.quality == 1 then
            table.insert(self._normalHeroData, v)
            v.serverData = self:getServerData(v.heroId) 
        elseif v.quality == 2 then
            table.insert(self._vipHeroData, v)
            v.serverData = self:getServerData(v.heroId)
        end

        -- if v.state == 1 then
        --     table.insert(self._recruitHeroData, v)
        --     v.serverData = self:getServerData(v.heroId)
        --     -- self:addServerData(v.heroId)
        -- end
    end
   table.sort( self._normalHeroData, function(s1, s2) return s1.serial < s2.serial end )
   table.sort( self._vipHeroData, function(s1, s2) return s1.serial < s2.serial end )
   self:sortNormalHero()
end

function _M:getNormalHeroData()

   return self._normalHeroData
end

function _M:getVipHeroData()
    
    return self._vipHeroData
end

function _M:getRecruitHeroData()
    
    return self._recruitHeroData
end

function _M:updataRecruitHeroUseState( _heroId )
    
    for _,v in pairs(self._recruitHeroData) do
        if v.heroId == _heroId then
            if v.useState == 0 then
                v.useState = 1
            else
                v.useState = 0
            end 
        end
    end
end


 -- 加上科技加成 
function _M:setBuffAddNum(heroBuffAddNum)

    self.heroBuffAddNum = heroBuffAddNum 
end 

 -- 加上科技加成 
function _M:getBuffAddNum()
    
    return self.heroBuffAddNum or 0 
end 


function _M:getMaxHeroNum()

    -- local res = global.cityData:getTopLevelBuild(15)
    -- if res == nil then return 1 + self:getBuffAddNum() end
    -- local level = res.serverData.lGrade


    -- local build_info = luaCfg:buildings_info()
    -- for _,v in pairs(build_info) do

    --     if v.level == level and v.type == 15 then

    --         return tonumber(v.para1Num)+self:getBuffAddNum()
    --     end
    -- end

    -- return 1 +self:getBuffAddNum()

    return 10000

    -- local num = 0
    -- for _,v in pairs(self._heroData) do
        
    --     if  global.cityData:checkTrigger(v.condition) then
    --         num = num + 1
    --     end
    -- end
    -- return num
end

function _M:getMaxRecruitHeroNum()
    
    local maxRecruitNum = 12
    return maxRecruitNum
end

function _M:isCanRecruitHero()
    local  isMaxNum = false
    local  recruitHero = self:getRecruitHeroData()
    local  curRecruitNum = #recruitHero
    local  maxRecruitNum = self:getMaxRecruitHeroNum()

    if  curRecruitNum >= maxRecruitNum then
        isMaxNum = true
    else
        isMaxNum = false
    end
    return isMaxNum
end


---------------------------------- 刷新英雄状态 --------------------------------

function _M:refershHeroState(  _heroId ,state)

    for _,v in pairs(self._heroData) do
        
        if v.heroId == _heroId then         

            v.state = state            
        end
    end

end

function _M:refershNormalHeroState(  _heroId )

    for _,v in pairs(self._normalHeroData) do
        
        if  v.heroId == _heroId then
            if v.state == 0 then 
                v.state = 1
                self:sortNormalHero()
                table.insert(self._recruitHeroData, v)
                self:sortRecruitHero()
            end 
        end
    end
end

function _M:refershVipHeroState(  _heroId )

    for _,v in pairs(self._vipHeroData) do
        
        if  v.heroId == _heroId then
            if v.state == 0 then 
                v.state = 1
                table.insert(self._recruitHeroData, v)
                self:sortRecruitHero()
            end 
        end
    end
end

---------------------------------- 英雄排序 --------------------------------

function _M:sortNormalHero()
    
    function sortFunc(a, b)
        if a.state == b.state then
            return a.serial < b.serial
        else
            return a.state < b.state
        end
    end
    table.sort(self._normalHeroData, sortFunc)
end

function _M:sortRecruitHero()
    
    local allHero = {}
    for _,v in pairs( self._recruitHeroData ) do
        table.insert(allHero, v)
    end

    function sortFunc(a, b)
        if a.quality == b.quality then
            return a.serial < b.serial
        else
            return a.quality > b.quality
        end
    end
    table.sort(allHero,sortFunc)
    self._recruitHeroData = {}
    self._recruitHeroData = clone(allHero)
end

function _M:getHeroTrueMaxLevel()
    return luaCfg:get_config_by(1).heroLvMax * global.userData:getLevel()
end




function _M:sortHeroData()

    local allHero = {}
    for _,v in pairs( self._heroData ) do
        table.insert(allHero, v)
    end

    function sortFunc(a, b)
        if a.quality == b.quality then
            return a.serial < b.serial
        else
            return a.quality > b.quality
        end
    end
    table.sort(allHero,sortFunc)
    self._heroData = {}
    self._heroData = clone(allHero)
end

function _M:isFull()
    
    print(#self:getGotHeroData())
    print(self:getMaxHeroNum())
    return (#self:getGotHeroData()) >= self:getMaxHeroNum()
end

---------------------------------- 读取表英雄属性 --------------------------------
function _M:getHeroPropertyById( _heroId )  

    print(_heroId ,"_heroId // hero ID ")

    local data = luaCfg:hero_property()
    for _,v in pairs(data) do
        if v.heroId == _heroId then
            return v
        end
    end
end

-- 计算英雄属性
function _M:colHeroPro( heroId , level , star )
    
    local hero_str = luaCfg:get_hero_strengthen_by(heroId)    
    local grow = hero_str['grow' .. star]

    print(grow,'...................grow')

    local hero_base_data = luaCfg:get_hero_property_by(heroId)
    local grow_data = luaCfg:get_hero_grow_by(grow)

    local base = {}

    if not grow_data then return base end 

    print(grow_data['proGrow'], level);
    level =level or  1 -- protect 
    local pergrow = math.ceil(hero_base_data['attack'] * grow_data['proGrow'])
    base[1] = hero_base_data['attack'] + pergrow * (level - 1)
    print(pergrow,base[1]);

    pergrow = math.ceil(hero_base_data['defense'] * grow_data['proGrow'])
    base[2] = hero_base_data['defense'] + pergrow * (level - 1)

    print(pergrow,base[2]);

    pergrow = math.ceil(hero_base_data['interior'] * grow_data['proGrow'])
    base[3] = hero_base_data['interior'] + pergrow * (level - 1)

    print(pergrow,base[3]);

    pergrow = grow_data['section1'] + (grow_data['section1'] + (level - 2) * grow_data['section2'])    
    base[4] = hero_base_data['commander'] + pergrow * (level - 1) / 2    

    print(pergrow,base[4]);

    return base
end

function _M:getHeroDataById( _curHeroId )

    if _curHeroId == 1 then --得到领主所对应的英雄
        return  global.userData:getLordHero()
    end 

    if self._vipHeroData == nil then return end --在直通车之前的不进行处理

    for _,v in pairs(self._vipHeroData) do
        
        if v.heroId == _curHeroId then
           
            return v
        end
    end

    for _,v in pairs(self._normalHeroData) do
        if v.heroId == _curHeroId then
           
            return v
        end
    end
end

function _M:getRecruitHero( _curHeroId )
    
    table.sort( self._recruitHeroData, function(s1, s2) return s1.useState < s2.useState end )

    local tempData = {}
    for _,v in pairs(self._recruitHeroData) do
        
        if v.heroId == _curHeroId then
           table.insert(tempData, v)
        end
    end

    for _,v in pairs(self._recruitHeroData) do
        if v.heroId ~= _curHeroId then
           table.insert(tempData, v)
        end
    end

    return tempData
end

function _M:getHeroPicRectAndPosition( _heroId )
    
    local tempData = luaCfg:hero_icon()
    for _,v in pairs(tempData) do
        if v.heroId == _heroId then
            return v
        end
    end
end

-- 当前城内驻防英雄列表
function _M:setHeroGarrisionList(tagGarrisonList)

    self.heroGarrisonList = {}
    for i,v in ipairs(tagGarrisonList) do
        if v.lPos1 and v.lPos1 > 0 then
            table.insert(self.heroGarrisonList, v.lPos1)
        end
        if v.lPos2 and v.lPos2 > 0 then
            table.insert(self.heroGarrisonList, v.lPos2)
        end
    end
end
-- 当前英雄是否在建筑驻防
function _M:isHeroGarrision(heroId)
    for i,v in ipairs(self.heroGarrisonList) do
        if v == heroId then
            return true 
        end
    end
    return false
end

-- 所有驻防英雄信息
function _M:setBuildGarrison(tagBuildGarrison)
    self.tagBuildGarrison = tagBuildGarrison
    self:setHeroGarrisionList(tagBuildGarrison)
end

function _M:getBuildGarrison()
    return self.tagBuildGarrison
end

function _M:refershBuildGarrison()
    -- body
    global.cityApi:getGarrisonList(function (msg)
        self:setBuildGarrison(msg.tagBuildGarrison or {})
        gevent:call(global.gameEvent.EV_ON_GARRISON_GARRISONUI)
    end)
end

-- 获取英雄内政值
function _M:getHeroInterior(heroId)

    local recruitHero = global.heroData:getGotHeroData()
    for _,v in pairs(recruitHero) do
        if v.heroId == heroId then
            local interiorBase = v.serverData.lbase[3] or 0
            local interiorAdd  = v.serverData.lextra[3] or 0
            local toaInterior = interiorBase + interiorAdd
            return toaInterior
        end
    end
    return 0
end

-- 根据id获取当前已经拥有的英雄
function _M:getGotHeroDataById(heroId)
    -- body
    local recruitHero = global.heroData:getGotHeroData()
    for _,v in pairs(recruitHero) do
        if v.heroId == heroId then
            return v
        end
    end
end

function _M:CheckRedPoint(heroId)
    
    if true then return false end --去除小红点

    local itemid =  -1 

    for _ ,v in pairs(global.luaCfg:item()) do 
        if v.typePara1 == heroId then 
            itemid = v.itemId
            break
        end 
    end 

    if itemid == -1 then 
        return false 
    end 

    if global.normalItemData:getItemById(itemid) and global.normalItemData:getItemById(itemid).count > 0 then 

        return true 
    end 

    return false 
end


function _M:getHeroRoyalImpress(heroId)

    if true then return 0 end -- 不加御令

    local itemid =  -1 

    for _ ,v in pairs(global.luaCfg:item()) do 
        if v.typePara1 == heroId then 
            itemid = v.itemId
            break
        end 
    end 

    if itemid == -1 then 
        return 0
    end 

    if global.normalItemData:getItemById(itemid) and global.normalItemData:getItemById(itemid).count > 0 then 

        return global.normalItemData:getItemById(itemid).count * global.funcGame:getItemImpress(itemid)
    end 

    return 0 
end

function _M:getHeroRoyalICount(heroId)

    local itemid =  -1 

    for _ ,v in pairs(global.luaCfg:item()) do 
        if v.typePara1 == heroId then 
            itemid = v.itemId
            break
        end 
    end 

    if itemid == -1 then 
        return 0
    end 

    if global.normalItemData:getItemById(itemid) and global.normalItemData:getItemById(itemid).count > 0 then 
        
        return global.normalItemData:getItemById(itemid).count 
    end 

    return 0 
end 


function _M:getHeroRequest(heroData)
   
   local itemid =  -1 
    for _ ,v in pairs(global.luaCfg:item()) do 
        if v.typePara1 == heroData.heroId then 
            itemid = v.itemId
            break
        end 
    end 
    if itemid == -1 then 
        return false 
    end
    local actionCall = function()
        global.commonApi:heroAction(heroData.heroId, 2, 4, itemid , 1, function(msg)
            if msg.tgHero[1].lState == 0 then --0表示成功
                global.panelMgr:openPanel("UIGotHeroPanel"):setData(heroData)
                global.heroData:updateVipHero(msg.tgHero[1]) -- 更新数据  和 刷 新 界面
            end
        end)
    end
    if global.heroData:isFull() then
        global.tipsMgr:showWarning("207")
    else
        actionCall()
    end

end


function _M:getHeroImpress(heroId) -- 英雄已得到的 经验  +— 御令的经验

    local lImpress = 0 

    if self:getHeroDataById(heroId) and self:getHeroDataById(heroId).serverData and self:getHeroDataById(heroId).serverData.lImpress   then 

        lImpress = self:getHeroDataById(heroId).serverData.lImpress or 0
    end 

     return lImpress + self:getHeroRoyalImpress(heroId)

end 


function _M:isHeroImpressMax(data)

    local impressData = luaCfg:get_hero_property_by(data.heroId)

    print(self:getHeroImpress() ,"self:getHeroImpress()")

    return self:getHeroImpress(data.heroId) >=  impressData.impress
end

function _M:getAllCanContionHero()
    local vipNum  = table.nums(self:getVipHeroData())
    local normalNum = table.nums(self:getNormalHeroData())

    local res = {}
    local temp = self:getVipHeroData()
    for _,v in ipairs(temp) do
        if v.getType == 1 or v.getType == 3 then
            table.insert(res,v)
        end        
    end

    temp = self:getNormalHeroData()
    for _,v in ipairs(temp) do
        if v.getType == 1 or v.getType == 3 then
            table.insert(res,v)
        end        
    end

    table.sortBySortList(res,{{'order','min'}})

    -- dump(res,'...........why?')

    return res
end

function _M:getAllHero()
    local vipNum  = table.nums(self:getVipHeroData())
    local normalNum = table.nums(self:getNormalHeroData())

    local res = {}
    local temp = self:getVipHeroData()
    for _,v in ipairs(temp) do
        table.insert(res,v)
    end

    temp = self:getNormalHeroData()
    for _,v in ipairs(temp) do
        table.insert(res,v)
    end

    table.sortBySortList(res,{{'order','min'}})

    return res
end

-- 获取所有史诗英雄
function _M:getAllEpicHero()
    local vipNum  = table.nums(self:getVipHeroData())
    local normalNum = table.nums(self:getNormalHeroData())

    local res = {}
    local temp = self:getVipHeroData()
    for _,v in ipairs(temp) do
        if v.iconBg == 'ui_surface_icon/hero_kuang0.png' then
            table.insert(res,v)
        end 
    end

    table.sortBySortList(res,{{'order','min'}})

    return res
end

-- 获取所有大史诗英雄
function _M:getAllBigEpicHero()
    local vipNum  = table.nums(self:getVipHeroData())
    local normalNum = table.nums(self:getNormalHeroData())

    local res = {}
    local temp = self:getVipHeroData()
    for _,v in ipairs(temp) do
        if v.iconBg == 'ui_surface_icon/hero_kuang4.png' then
            table.insert(res,v)
        end 
    end

    table.sortBySortList(res,{{'order','min'}})

    return res
end

function _M:getAllNormalHero()
    local normalNum = table.nums(self:getNormalHeroData())

    local res = {}
    temp = self:getNormalHeroData()
    for _,v in ipairs(temp) do
        table.insert(res,v)
    end

    table.sortBySortList(res,{{'order','min'}})

    return res
end

function _M:getAllHeroNumber()

    local vipNum  = table.nums(self:getVipHeroData())
    local normalNum = table.nums(self:getNormalHeroData())

    return vipNum +  normalNum
end 

-- 英雄升级界面和战斗结果errorcode 排队显示
function _M:insertWaitData(data)
    -- body
    self.waitData = self.waitData or {}
    table.insert(self.waitData,data)
end

function _M:insertWaitTipsData(data)
    -- body
    self.waitTipsData = self.waitTipsData or {}
    table.insert(self.waitTipsData,data)
end

function _M:checkWaitPanel(isHero)

    local checkHero = function ()
        -- body
        if self.waitData and (#self.waitData > 0) then
            local data = self.waitData[1]
            global.panelMgr:openPanel("UIHeroLvUp"):setData(data.data,data.preData)
            table.remove(self.waitData, 1)
        else
            gevent:call(global.gameEvent.EV_ON_BATTLEERRORCODE_SHOW)
        end
    end

    local checkBattle = function ()
        -- body
        if self.waitTipsData and (#self.waitTipsData > 0) then
            if table.nums(self.waitTipsData[1].tagItem) > 0 then
                global.panelMgr:openPanel("UIBattleErrorcode"):setData(self.waitTipsData[1])  -- 有奖励
            else
                global.panelMgr:openPanel("UIBattleErrorcodeNo"):setData(self.waitTipsData[1])-- 无奖励
            end
            table.remove(self.waitTipsData, 1)
        end
    end

    if isHero then
        checkHero() 
    else
        checkBattle()
    end
end

function _M:setDisscountHero(data)

    self.disscountHero = data
end 

function _M:setDisscountHeroTime(data)
    self.disscountHeroTime = data
end 

function _M:getDisscountHero()
   return  self.disscountHero or {} 
end 

function _M:getDisscountHeroTime()
   return  self.disscountHeroTime 
end 

function _M:isHeroCanUpStar(heroId)

    local heroData = self:getHeroDataById(heroId)

    local maxStep =global.luaCfg:get_hero_strengthen_by(heroId).maxStep

    if heroData.serverData.lStar < maxStep then 

        local next_start = heroData.serverData.lStar + 1 
        
        local lv = global.luaCfg:get_hero_strengthen_lv_by(next_start).lv 

        return heroData.serverData.lGrade >= lv , lv , next_start
    end 

    return false  , 0 , 0 
end 

function _M:setHeroIconBg(heroId, leftSp, rightSp)

    local heroProConfig = luaCfg:get_hero_property_by(heroId)
    if heroProConfig then

        if not tolua.isnull(leftSp) then
            leftSp:setVisible(true)
            if tolua.type(leftSp) == "cc.Sprite" then
                leftSp:setSpriteFrame('ui_surface_icon/hero_Pokedex08.png')
                if heroProConfig.Strength == 2 then
                    leftSp:setSpriteFrame('ui_surface_icon/hero_Pokedex04.png')
                elseif heroProConfig.Strength == 3 then
                    leftSp:setSpriteFrame('ui_surface_icon/hero_Pokedex03.png')
                end
            elseif tolua.type(leftSp) == "ccui.ImageView" then
                leftSp:loadTexture('ui_surface_icon/hero_Pokedex08.png',ccui.TextureResType.plistType)
                if heroProConfig.Strength == 2 then
                    leftSp:loadTexture('ui_surface_icon/hero_Pokedex04.png',ccui.TextureResType.plistType)
                elseif heroProConfig.Strength == 3 then
                    leftSp:loadTexture('ui_surface_icon/hero_Pokedex03.png',ccui.TextureResType.plistType)
                end
            end
        end
        if not tolua.isnull(rightSp) then
            rightSp:setVisible(true)
            if tolua.type(rightSp) == "cc.Sprite" then
                rightSp:setSpriteFrame('ui_surface_icon/hero_Pokedex08.png')
                if heroProConfig.Strength == 2 then
                    rightSp:setSpriteFrame('ui_surface_icon/hero_Pokedex04.png')
                elseif heroProConfig.Strength == 3 then
                    rightSp:setSpriteFrame('ui_surface_icon/hero_Pokedex03.png')
                end
            elseif tolua.type(leftSp) == "ccui.ImageView" then
                rightSp:loadTexture('ui_surface_icon/hero_Pokedex08.png',ccui.TextureResType.plistType)
                if heroProConfig.Strength == 2 then
                    rightSp:loadTexture('ui_surface_icon/hero_Pokedex04.png',ccui.TextureResType.plistType)
                elseif heroProConfig.Strength == 3 then
                    rightSp:loadTexture('ui_surface_icon/hero_Pokedex03.png',ccui.TextureResType.plistType)
                end
            end
        end
    end
end

global.heroData = _M

--endregion

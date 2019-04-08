--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
 local _M = {}

 local luaCfg = global.luaCfg
    -- required uint32     lUserID = 1; // ID
    -- required uint32     lTimeZone = 2;  // 服务器时区         
    -- required uint32     lCurTime = 3; // 服务器时间
    -- required uint32     lTodayZero = 4; // 今日零时时间
    -- required uint32     lMilliSecond = 5; // 毫秒
    -- required int32      lUserGrade = 6; //主公等级
    -- required string     szLoginName = 7; //角色名称
    -- required int32      lMaxEXP = 8; // 最大经验
    -- required int32      lCurEXP = 9; // 当前经验
    -- required int32      lMaxHP = 10; // 最大行动力
    -- required int32      lCurHP = 11; // 当前行动力
    -- required int32      lVIPGrade = 12; //VIP等级
    -- required int32      lPowerLord = 13; // 主公战力
    -- required int32      lUserPic = 14; // 主公头像
    -- required string     szCityName = 15; // 城池名称
    -- repeated int32      aRes = 16; //石木铁粮金钻
    -- required int32      lStatus = 17; // 玩家状态  
    -- required int32      lMapID = 18; // 地图坐标
    -- required int32      lAvatar = 19; // 城池外观
    -- repeated Build      tgBuilds = 20; //建筑
    -- repeated Task       tgTasks = 21; //
    -- repeated Soldier    tgSoldiers = 22; //士兵
    -- repeated Tech       tgTechs = 23; //科技
    -- repeated Queue      tgQueues = 24;//队列信息
    -- required int32      lMaxPopulation = 25; // 当前可造人口最大值
    -- required int32      lPopulation = 26; // 当前已有人口总数
    -- repeated Task       tgSubTasks = 27; //支线任务
    -- repeated Task       tgDailyTasks = 28; //日常任务
    -- repeated QLock      tgQueueLocked = 29; //队列解锁状态
    -- repeated Item       tgItems = 30;//道具
    -- required int32      lRace = 31;//种族信息
    -- repeated Hero       tgHero = 32;//英雄信息
    -- repeated Plus       tgPlus = 33;//附加状态信息
    -- repeated Troop      tgTroop = 34;//部队信息
    -- repeated Trap       tgTraps = 35;//城防设备
    -- required int32      lMaxDefPop      = 36; //最大城防人口源
    -- required int32      lCurDefPop      = 37; //当前占用人口源
    -- required int32      lDefense        = 38; //城防值 
    -- required int32      lFreeHeal       = 39; //免费治疗次数
    -- required int32      lAllyID = 40;//联盟ID
    -- required int32      lAllyRole = 41;//联盟职位
    -- required int32      lOwnerID = 46; // 占领者userid
    -- required int32      lGateEnergy = 47; //龙潭挑战令

    --不包含repeated的字段
function _M:init(msg)
    msg = msg or {}
    self.tgAllySub = self.tgAllySub or {}

    for k,v in pairs(msg) do
        if type(v) ~= "table" then
            self[k] = v
            -- log.trace(">>>> userData update:k=%s,v=%s,self.%s=%s",k,v,k,self[k])
        end
    end
    
    if msg.tgAllySub then
        table.assign(self.tgAllySub,msg.tgAllySub)
    end

    self:setCityAttackState(msg.lCityState == 1)
    self.tgVIP = msg.tgVIP or self.tgVIP 
    
    if msg.tgQueues then
        self.tgQueues = msg.tgQueues
    end

    if msg.tagRedCount then
        self.tagRedCount = msg.tagRedCount
    end

    if msg.lGuidProgress then
        self.lGuidProgress = msg.lGuidProgress
    end

    if msg.tgVIP then 
        global.vipBuffEffectData:updateVIPData(msg.tgVIP)
    end 

    if msg.tagSumPay then 
         self.tagSumPay = msg.tagSumPay
    end 

    if msg.tagExploitInfo then 
        self.tagExploitInfo = msg.tagExploitInfo
    end

    if msg.tgBuyCount then 
        self.tgBuyCount = msg.tgBuyCount
    end
    
    if msg.tagLotteryInfo then 
        self.tagLotteryInfo = msg.tagLotteryInfo
    end

    if msg.lPopulation then
        gevent:call(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,true)
    end

    if msg.tagNew then
        
        self:setNewPlayBuff(msg.tagNew)

        gevent:call(global.gameEvent.EV_ON_CITY_BUFF_UPDATE)
    end

    
    -- 领主所代表的英雄
    if not  self.lordHero then 
        self.lordHero  = clone( global.luaCfg:hero_property()[8101])
        self.lordHero.heroId = 1 
        self.lordHero.serverData ={}
        self.lordHero.serverData.lGrade = self:getLevel()
    end 
    self.lordHero.serverData.lGrade = self:getLevel()
end

-- function _M:isHaveGuide()
--     return self.isGuide    
-- end

-- function _M:setGuide(state)
--     local guideKey = cc.UserDefault:getInstance():getStringForKey("account") .. "isGuide"
--     cc.UserDefault:getInstance():setBoolForKey(guideKey,state)

--     self.isGuide = state
-- end

-- 检测迁城CD
function _M:checkCD(id,errcode,callback)

    for _,v in ipairs(self.tgQueues or {}) do

        if v.lID == id then

            local cutTime = (v.lStartTime + v.lTotleTime) - global.dataMgr:getServerTime()
            if cutTime > 0 then

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData(errcode, function()
                    global.funcGame:cleanMoveCD(callback)
                end,global.funcGame.formatTimeToHMS(cutTime),global.luaCfg:get_config_by(1).moveCityCost)
              
                return true
            else
                return false    
            end                        
        end
    end

    return false
end

function _M:deleteQueue(data)
    
    -- dump(self.tgQueues,"delete self.tgQueues")

    self.tgQueues = self.tgQueues or {}

    for _,v in ipairs(data) do

        local queuecount = #self.tgQueues
        for i = queuecount,1,-1 do

            local queue = self.tgQueues[i]
            if queue.lID == v.lID then

                table.remove(self.tgQueues,i)
            end
        end    
    end

    -- dump(self.tgQueues,"delete self.tgQueues 1")
end

function _M:updateQueue(data)
    
    -- dump(self.tgQueues,"self.tgQueues")

    self.tgQueues = self.tgQueues or {}

    -- print(">>>userdata update queue")
    for _,v in ipairs(data) do

        local isFind = false
        for i,queue in ipairs(self.tgQueues) do

            if queue.lID == v.lID then

                self.tgQueues[i] = v          
                isFind = true                  
            end
        end    

        if not isFind then

            table.insert(self.tgQueues,v)            
        end
    end

    -- dump(self.tgQueues,"delete self.tgQueues 1")
    -- dump(self.tgQueues,"self.tgQueues")
end

function _M:insertGudieTag(tag)
    
    --如果这个没有进度，则初始化一下
    self.lGuidProgress = self.lGuidProgress or {}
    table.insert(self.lGuidProgress,tag)
end

function _M:isEventGuideDone(step)

    if cc.UserDefault:getInstance():getBoolForKey("skip_event_guide_disabled",false) then
        return true
    end

    for _,v in ipairs(self.lGuidProgress or {}) do
        
        if v == step then
            return true
        end
    end

    return false
end

function _M:signEventGuide(step)
    table.insert(self.lGuidProgress,step)
end

function _M:getGuideStep()
    -- if global.tools:isWindows() then
        -- return  10000000
    -- end
    -- return  101
    return self.lGudieStep
end

function _M:getResLevel()
    
    local cityLevel = global.cityData:getMainCityLevel()    
    local map_unlock = global.luaCfg:map_unlock()
    local maxLevel = 0
    
    print("citylevel",cityLevel)

    for _,v in ipairs(map_unlock) do

        if cityLevel >= v.KeyLv and v.lv > maxLevel then
            maxLevel = v.lv
        end
    end

    return maxLevel
end

function _M:setGuideStep(step)
    
    self.lGudieStep = step
end

function _M:setFreeToMoveCity()
    
    self.lFreeMoveCount = 1
end

function _M:cleanFreeToMoveCity()
    
    self.lFreeMoveCount = 0
end

function _M:isFreeToMoveCity()
    
    self.lFreeMoveCount = self.lFreeMoveCount or 0
    return self.lFreeMoveCount > 0
end

function _M:setAccount(account)
    self.account = account
end

function _M:setCountry(country)
    self.country = country
end

function _M:getCountry()
    return self.country or ''
end

function _M:getAccount()
    return self.account or ""
    -- return "guest3857a1"
end

-- 当天零点时间戳
function _M:getZeroTime()
    return self.lTodayZero 
end

-- 服务器时区
function _M:getServerZone()
    return self.lTimeZone 
end

function _M:setUserId(user_id)
    self.lUserID = user_id
end

function _M:getUserId()
    return self.lUserID or 0
end

function _M:isMine(ID)
    return self.lUserID == ID
end

-- 获取vip等级
function _M:getVipLevel()
    return self.tgVIP.lLV
end

-- 获取vipData
function _M:getVipData()
    return self.tgVIP
end

function _M:setMainCityPos(pos)
    self.mainCityPos = pos
end

function _M:getMainCityPos()
    return self.mainCityPos
end

-- 当前城池占领状态
function _M:getlStatus()
    return self.lStatus or 0
end

function _M:getOwnerId()
    return self.lOwnerID or 0
end

function _M:setUserName(user_name)
    self.szLoginName = user_name
end

function _M:getUserName()
    return self.szLoginName or ""
end

function _M:setlUserPic(picId)
    self.lUserPic = picId
end

function _M:getlUserPic()
    return self.lUserPic or 0
end

function _M:getUsefulPopulation()
    -- return (self:getMaxPopulation() - self:getPopulation())
    return  self:getPopulation()
end

function _M:getUsefulDefPop()
    return (self:getMaxDefPop() - self:getDefPop())
end

function _M:setCurExp(exp)
    self.lCurEXP = exp
end

function _M:getCurExp()
    return self.lCurEXP or 0
end

function _M:getMaxExp()
    return self.lMaxEXP or 0
end

function _M:setCurHp(hp)
    self.lCurHP = hp
end

function _M:getCurHp()
    return self.lCurHP or 0
end

function _M:setGateEnergy(lGateEnergy)
    self.lGateEnergy = lGateEnergy or 0
end
function _M:getGateEnergy()
    return self.lGateEnergy or 0
end

function _M:getMaxHp()
    return self.lMaxHP or 0
end

function _M:setWorldCityID(id)

    self.lCityID = id or self.lCityID
    if not self.lCityID then return end
    if tonumber(self.lCityID) > 0 then
        global.resData:updateOccupy() 
    end
end

function _M:setCityState(state)
        
    self.lCityState = state

    if global.scMgr:isMainScene() then

        if state == 2 then

            global.g_cityView:createFireEffect()
        else

            global.g_cityView:removeFireEffect()
        end        
    end
end

function _M:getCityState()
    
    return self.lCityState
end

function _M:getWorldCityID()
    
    -- print(">>>>>>>>>>get    function _M:setWorldCityID(id)",self.worldCityId)
    return self.lCityID
end

function _M:isSelfCity(cityId)
    if not cityId then return false end
    return self.lCityID == cityId
end

--当前城防值
function _M:setCurDefense(defense)
    self.lDefense = defense
end

function _M:getCurDefense()
    return self.lDefense or 0
end

--当前联盟信息
function _M:setlAllySub(data)
    table.assign(self.tgAllySub,data)
end

function _M:setlAllyID(lAllyID)
    self.tgAllySub.lAllyID = lAllyID or 0
end

function _M:getlAllyID()
    self.tgAllySub = self.tgAllySub or {} 
    return self.tgAllySub.lAllyID or 0
end

function _M:getlAllyRole()
    return self.tgAllySub.lAllyRole or 0
end

function _M:setlAllyRole(lAllyRole)
    self.tgAllySub.lAllyRole = lAllyRole or 0
end

function _M:getlAllyClass()
    return self.tgAllySub.lAllyClass or 0
end

function _M:setlAllyClass(lAllyClass)
    self.tgAllySub.lAllyClass = lAllyClass or 0
end

-- 退出联盟的次数
function _M:setlAllyFirstAdd(lFirstAdd)
    self.lFirstAdd = lFirstAdd
end

function _M:getlAllyFirstAdd()
    return self.lFirstAdd 
end

function _M:islAllyFirstAdd()
    
    local meUnion = global.unionData:getInUnion()
    if not meUnion.lID and self.lFirstAdd == 0 then
        return true
    end
    return false
end

-- 联盟红点
-- //key=1,联盟申请成员个数
-- //key=2，聊天私聊红点数
-- //key=3，联盟外交红点数
-- //key=4，成就红点数
-- //key=5，联盟留言
-- //key=6，联盟动态（value=lastid）
-- //key=7，联盟建设
-- //key=8，联盟任务
function _M:setlAllyRedCount(i_pairs,noShowMsgAndDynamicRed)
    self.tagRedCount=self.tagRedCount or {}
    i_pairs = i_pairs or {}
    table.assign(self.tagRedCount,i_pairs)
    if noShowMsgAndDynamicRed then
        self:setlFirstNoRed()
    end
end

function _M:setlFirstNoRed()
    self.tagRedCount=self.tagRedCount or {}
    for i,v in pairs(self.tagRedCount) do
        if v.lID == 5 then
            cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.UNION_MESSAGE_READ_ID..global.userData:getAccount(),v.lValue)
        elseif v.lID == 6 then
            cc.UserDefault:getInstance():setIntegerForKey(WDEFINE.USERDEFAULT.UNION_DYNAMIC_READ_ID..global.userData:getAccount(),v.lValue)
        else
        end
    end
end
function _M:getlAllyRedCount(data)
    return self.tagRedCount or {}
end
function _M:updatelAllyRedCount(pair)
    self.tagRedCount=self.tagRedCount or {}
    for i,v in pairs(self.tagRedCount) do
        if v.lID == pair.lID then
            table.assign(self.tagRedCount[i],pair)
            return true
        end
    end
    table.insert(self.tagRedCount,pair)
    return true
end
function _M:getlAllyRedCountBy(id)
    self.tagRedCount=self.tagRedCount or {}
    for i,v in pairs(self.tagRedCount) do
        if v.lID == id then
            if v.lID == 5 then
                local u_msg_read_id = cc.UserDefault:getInstance():getIntegerForKey(WDEFINE.USERDEFAULT.UNION_MESSAGE_READ_ID..global.userData:getAccount()) or 0
                local count = (v.lValue or 0)-u_msg_read_id
                return count > 0 and count or 0
            elseif v.lID == 6 then
                local u_dynamic_read_id = cc.UserDefault:getInstance():getIntegerForKey(WDEFINE.USERDEFAULT.UNION_DYNAMIC_READ_ID..global.userData:getAccount()) or 0
                local count = (v.lValue or 0)-u_dynamic_read_id
                return (count > 0) and count or 0
            else
                local count = v.lValue or 0
                return count
            end
        end
    end
    return 0
end
function _M:getTotallAllyRedCount()
    local unionRelation = {1,3,5,6,7,8}
    self.tagRedCount=self.tagRedCount or {}
    local total = 0
    dump(self.tagRedCount,"_M:getTotallAllyRedCount()")
    for i,v in pairs(self.tagRedCount) do
        if table.hasval(unionRelation, v.lID) then
            total = total + self:getlAllyRedCountBy(v.lID)
        end
    end
    return total
end

--更新个人贡献
function _M:setlAllyStrong(lStrong)
    self.tgAllySub.lStrongCur = lStrong
end
function _M:isEnoughlAllyStrong(lStrongCur)
    return self.tgAllySub.lStrongCur >= lStrongCur
end
function _M:getlAllyStrong()
    return self.tgAllySub.lStrongCur or 0
end
function _M:setlAllyDonate(data)
    self.tgAllySub.lStrongCur = data.lStrongCur or 0
    self.tgAllySub.lStrongDaily = data.lStrongDaily or 0
    self.tgAllySub.lStrongWeekly = data.lStrongWeekly or 0
    self.tgAllySub.lStrongTotle = data.lStrongTotle or 0
end
function _M:getlAllyDonate()
    local data = {}
    data.lStrongCur     = self.tgAllySub.lStrongCur
    data.lStrongDaily   = self.tgAllySub.lStrongDaily
    data.lStrongWeekly  = self.tgAllySub.lStrongWeekly
    data.lStrongTotle    = self.tgAllySub.lStrongTotle
    return data
end

-- 累计充值数据
function _M:getSumPay()
    self.tagSumPay = self.tagSumPay or {}
    self.tagSumPay.lMoney = self.tagSumPay.lMoney or 0
    self.tagSumPay.lGet = self.tagSumPay.lGet or 0
    self.tagSumPay.lPickUp = self.tagSumPay.lPickUp or {}
    return self.tagSumPay
end

-- 更改累计充值
function _M:addSumPayPoint(pt)
    if table.hasval(self.tagSumPay.lPickUp,pt) then
    else
        table.insert(self.tagSumPay.lPickUp,pt)
    end
    return true
end
-- 能否首冲
function _M:canFirstPay()
    return self.tagSumPay.bFirst
end

function _M:setFirstPay(s)
    self.tagSumPay.bFirst = s
    global.advertisementData:reMoveFirstRecharge()
    global.ActivityData:checkFirstRechargeActivity()
end

function _M:setOpenFirst(s)
    -- body
    self.isOpenFirst = s
end

function _M:getOpenFirst()
    -- body
    return self.isOpenFirst or true
end

function _M:resetSumPay()
    self.tagSumPay.lGet = 0
    self.tagSumPay.lPickUp = {}
end

--当前人口
function _M:getPopulation()
    return self.lPopulation or 0
end

function _M:setPopulation(pop)
    self.lPopulation = pop
end

--人口上限
function _M:getMaxPopulation()
    local res = self.lMaxPopulation or 0
    res = res == 0 and 300 or res
    return res
end

function _M:setMaxPopulation(pop)
    self.lMaxPopulation = pop
end

function _M:checkPopulation(value)
    local ret = self:getUsefulPopulation() >= value
    return ret
end

function _M:checkPopuhWithColor(value, txtNode)
    local enough = self:getUsefulPopulation() >= value
    if not enough then
        if txtNode then txtNode:setColor(gdisplay.COLOR_RED) end
    else
        if txtNode then txtNode:setColor(gdisplay.COLOR_WHITE) end
    end
    return enough
end

function _M:checkPopuWithTips(value, txtNode)
    local enough = self:getUsefulPopulation() >= value
    if not enough then
        global.tipsMgr:showWarning("NoManpower")
    end
    return enough
end

function _M:checkJoinUnion(lAllyID)
    if lAllyID then
        return self.tgAllySub.lAllyID == lAllyID
    end
    return self.tgAllySub.lAllyID ~= 0
end


--免费次数
function _M:getFreeHeal()
    return self.lFreeHeal or 0
end

function _M:setFreeHeal(s)
    self.lFreeHeal = s
end

--当前占用城防人口源
function _M:getDefPop()
    return self.lCurDefPop or 0
end

function _M:setDefPop(pop)
    self.lCurDefPop = pop
end

--最大城防人口源
function _M:getMaxDefPop()
    self.lMaxDefPop = self.lMaxDefPop or 0   
    return self.lMaxDefPop + math.floor(self.lMaxDefPop*self:getDefPopBuff()/100)
end

function _M:setMaxDefPop(pop)
    self.lMaxDefPop = pop
end

function _M:checkDefPop(value)
    local ret = self:getUsefulDefPop() >= value
    return ret
end

-- 城防空间buff
function _M:setDefPopBuff(value)
    -- body
    self.defPopBuff= value
end
function _M:getDefPopBuff()
    return self.defPopBuff or 0
end


--获取战力
function _M:getPower()
    return self.lPowerLord
end

function _M:getCharId()
    return self.charid
end

function _M:setRace(career)
    self.lRace = career
end

function _M:getRace()
    return self.lRace
end

function _M:setLevel(level)
    self.lUserGrade = level
end

function _M:getLevel()
    return self.lUserGrade or 1
end

function _M:checkLevel(value)
    return self.lUserGrade >= value
end

function _M:setExp(exp)
    self.lCurEXP = exp
end

function _M:getExp()
    return self.lCurEXP
end

function _M:setIsBeAttackCity(isBeAttack)
    self.isBeAttackCity = isBeAttack
end

function _M:isOpenFullMap()
    return self.lOpenLand == 1
end

function _M:getIsBeAttackCity()
    return self.isBeAttackCity
end

function _M:setCityAttackState(isAttack)

    self.isAttack = isAttack

    if isAttack then

        global.panelMgr:openPanel("UIAttackEffect")    
    else

        global.panelMgr:closePanel("UIAttackEffect")    
    end
end

function _M:getCityAttackState()
    return self.isAttack
end

function _M:addExp(exp)
    
    self.lCurEXP = self.lCurEXP + exp
end
--获得当前满级需要总经验
function _M:getFullExp(exp)
    local lordExp = luaCfg:lord_exp()
    local t = 0
    local curr = 0
    for i,v in ipairs(lordExp) do
        if self:checkLevel(i) then
            curr = curr + v.exp
        end
        t = t + v.exp
    end
    curr = curr + self:getExp()
    return curr,t
end

function _M:setCreateRole(status)
    self.is_create_role = status 
end 
function _M:setCreateRoleTime(time)
    self.createRole_time = time 
end 
function _M:getCreateRoleTime()
    return self.createRole_time 
end 

function _M:isCreateRole()
    return  self.is_create_role  
end 
--     "tagNew" = {
-- [LUA-print] -         "lExpire" = 1495801082
-- [LUA-print] -         "lStatus" = 1
-- [LUA-print] -     }

function _M:inNewProtect()
    if self.tagNew and self.tagNew and self.tagNew.lStatus and  self.tagNew.lExpire  then 
        if global.dataMgr:getServerTime() < self.tagNew.lExpire then 
            return self.tagNew.lStatus  == 1 
        end   
    end
    return false 
end 

function _M:setNewPlayBuff(buff)

    self.tagNew = buff
end 

function _M:getNewPlayBuff()
    return self.tagNew
end 


function _M:isInProtect()

    local flg = false 

    flg = self:inNewProtect() -- 是否新手保护

    if not flg then  -- 是否开启战争保护

        for _ ,v in pairs(global.buffData:getBuffs()) do 

            if v.lID == 3065 and  global.dataMgr:getServerTime() < v.lEndTime  then 
                flg = true 
            end 
        end 
    end 

    return flg 
end 



function _M:setIsRegister(state)

    self.is_register =state 
end 

function _M:IsRegister()

    return self.is_register   
end 

function _M:setIsLoginSuccess(state)

    self.isLoginSuccess =state 
end 

function _M:IsLoginSuccess()

    return self.isLoginSuccess   
end 


function _M:getLordHero() --得到领主对应的英雄 
    
    return self.lordHero 
end 


function _M:setSearchFree(time)

     self.freetime = time 
end 

function _M:setSearchCost(time)

     self.searchCost = time 
end 


function _M:getSearchFree()

    return self.freetime 
end 

function _M:getSearchCost()

    return self.searchCost
end 


function _M:getLordEquipBuff(id , call)

    local getBuff = function () 
        local val = 0 
        for _ ,v in pairs(self.lordEquipBuffData) do 
            if  v.lEffectID ==id then 
                val =val +  v.lVal
            end
        end 
        if call then 
            call(val)
        end 
    end 

    if self.lordEquipBuffData then 
       getBuff()
    else 
        self:updateLordEquipBuff()
    end
end 

function _M:updateLordEquipBuff()

    local tgReq = {}
    local temp = {}
    temp.lType = 14
    table.insert(tgReq, temp)

    global.gmApi:effectBuffer(tgReq, function (msg)

            self.lordEquipBuffData = {} -- 这个很关键  不然可能死循环

            if msg.tgEffect and msg.tgEffect[1] and msg.tgEffect[1].tgEffect then 
                self.lordEquipBuffData =  msg.tgEffect[1].tgEffect
            end 

            gevent:call(global.gameEvent.EV_ON_LORDE_EQUIP_BUFF_UPDATE)
    end)
end 

function _M:sendIosToken()
    
    if global.ClientStatusData.deviceTokenData then 

        local platformflat = global.ClientStatusData.deviceTokenData.platformflat
        local token = global.ClientStatusData.deviceTokenData.token
        global.PushInfoAPI:SendClientidReq(platformflat, token , "", function ()


        end)

        global.ClientStatusData.deviceTokenData = nil 
    end 
end 

-- required int32      lLV = 1;        //爵位等级
-- required int32      lCurExploit = 2;        //当前军功值
-- required uint32     lTotalExploit = 3;  //历史总军功值
-- required uint32     lWeekExploit = 4;   //每周获取的军功值
-- required uint32     lDailyGold = 5; //每日领取状态  0.未领取 1.已领取
--爵位信息
function _M:setTagExploit(tagExploitInfo)
    self.tagExploitInfo = tagExploitInfo
end
function _M:getTagExploit()
    return self.tagExploitInfo
end

function _M:getCurrExploit()
    return self.tagExploitInfo.lCurExploit
end

    -- required int32      lID = 1;    //转盘类型
    -- required int32      lCount = 2; //累计次数
    -- required int32      lStart = 3; //起点位子
    -- optional int32      lTurn   = 4;    //论次
    -- optional int32      lEndTime = 5;   //当前论次结束时间
--日长魔晶抽奖购买次数
-- lID:1->付费转盘 2->英雄转盘 3->魔晶转盘
function _M:getDayTurntableTimes(lId)
    self.tagLotteryInfo = self.tagLotteryInfo or {}
    for i,v in pairs(self.tagLotteryInfo) do
        if v.lID == lId then
            return v
        end
    end
    return {}
end

function _M:addDayTurntableTimes(lId)
    self.tagLotteryInfo = self.tagLotteryInfo or {}
    for i,v in pairs(self.tagLotteryInfo) do
        if v.lID == lId then
            v.lCount = v.lCount+1
            return
        end
    end
    self.tagLotteryInfo[lId] = {}
    self.tagLotteryInfo[lId].lCount = 1
    self.tagLotteryInfo[lId].lID = lId
end

function _M:resetTurntableTimes(lId)
    self.tagLotteryInfo = self.tagLotteryInfo or {}
    for i,v in pairs(self.tagLotteryInfo) do
        if v.lID == lId then
            v.lCount = 0
            return
        end
    end
    self.tagLotteryInfo[lId] = {}
    self.tagLotteryInfo[lId].lCount = 0
    self.tagLotteryInfo[lId].lID = lId
end


function _M:updateHeroTurntable(data)
    if not data then return end
    self.tagLotteryInfo = self.tagLotteryInfo or {}
    self.tagLotteryInfo[2] = self.tagLotteryInfo[2] or {}

    self.tagLotteryInfo[2].lTurn = data.lParam
    self.tagLotteryInfo[2].lEndTime = data.szParam
end

-- 英雄转盘免费次数
function _M:updateFreeLotteryCount(i_times)
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lFreeLotteryCount = i_times
    gevent:call(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES)
end

function _M:updateDyFreeLotteryCount(i_times)
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lDyFreeLotteryCount = i_times
    gevent:call(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES)
end

-- 是否第一次玩英雄谕令转盘
function _M:isFirstFreeLotteryCount()
    dump(self.tgBuyCount)
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lGuideLotteryCount = self.tgBuyCount.lGuideLotteryCount or 0
    return self.tgBuyCount.lGuideLotteryCount == 0
end

function _M:isFirstDyFreeLotteryCount()
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lGuideDyLotteryCount = self.tgBuyCount.lGuideDyLotteryCount or 0
    return self.tgBuyCount.lGuideDyLotteryCount == 0
end

function _M:resetFirstDyFreeLotteryCount()
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lGuideDyLotteryCount = 1
end

function _M:resetFirstFreeLotteryCount()
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lGuideLotteryCount = 1
end

function _M:getFreeLotteryCount()
    if not global.cityData:isBuildingExisted(15) then
        -- 没有酒馆的时候，取消红点 显示
        return 1
    end

    local targetId = luaCfg:get_turntable_hero_cfg_by(1).open_lv
    if not global.funcGame:checkTarget(targetId) then
        return 1
    end
    if not self.tgBuyCount then
        return 0
    end
    return self.tgBuyCount.lFreeLotteryCount or 0
end

function _M:getDyFreeLotteryCount()
    if not global.cityData:isBuildingExisted(15) then
        -- 没有酒馆的时候，取消红点 显示
        return 1
    end
    if not self.tgBuyCount then
        return 0
    end
    return self.tgBuyCount.lDyFreeLotteryCount or 0
end

function _M:getlDailyGiftCount()
    if not self.tgBuyCount then
        return 0
    end
    return self.tgBuyCount.lDailyGiftCount or 0
end

function _M:updatelDailyGiftCount(i_times)
    self.tgBuyCount = self.tgBuyCount or {}
    self.tgBuyCount.lDailyGiftCount = i_times
    gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)
end


function _M:getSkinId(level , kind)

    local race_data = luaCfg:race_world_surface()
    local levelData = nil
    for _,v in ipairs(race_data) do
        if level >= v.level then
            levelData = v
        end
    end 
    id = levelData["race"..kind]
    return id 
end

function _M:setHeadFrameRed(count )
    
    self.hreadFrameRed = count  or 0 
end 

function _M:getHeadFrameRed()

   return  self.hreadFrameRed or 0 
end 

-- 军功是否开放
function _M:isOpenExploit()
    -- body
    local opLv = global.luaCfg:get_config_by(1).exploitUnlock
    local curCityLv = global.cityData:getBuildingById(1).serverData.lGrade
    return curCityLv >= opLv 
end


function _M:setPkCount(count)
    self.pkCount =count
end 

function _M:getPkCount()

    return self.pkCount or 0
end 

global.userData = _M

--endregion

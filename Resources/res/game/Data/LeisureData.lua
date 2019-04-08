local luaCfg = global.luaCfg

local _M = {
	leisure = {},
}

function _M:init() 

	if table.nums(self.leisure) > 0 then  
	else
		self.achieveNum = 0
		self:initLeisureAll()
	end
end

function _M:initLeisureAll(isEdit)

	self.leisureAll = {}
	local leisureAll = luaCfg:leisureList()
	local localList = self:getLeisureList()
	local checkLeisure = function (id)
		for _,value in pairs(localList) do
			if value == id then
				return false
			end
		end
		return true
	end
	
	if table.nums(localList) > 0 and (not isEdit) then
		for _,v in pairs(leisureAll) do
			local temp = checkLeisure(v.id)
			if temp then
				table.insert(self.leisureAll, v)
			end
		end	
	else
		self.leisureAll = leisureAll
	end
end

function _M:getLeisure()

	self:initLeisure()

	return self.leisure
end

function _M:initLeisure()

	local initleisure = {}
	local lie1 = {}
	local lie  = {}
	for _,v in pairs(self.leisureAll) do
		v.state, v.parm, v.parm1 =  self[v.stateCall](self, v.position)
		if v.state ~= 0 then	
			if v.id == 1 then --每日任务检测未开启
				if not global.cityData:checkBuildLv(v.unlock_building, v.unlock_lv) then
					v.state = -2
				end 
				table.insert(initleisure, v)
			else
				local isExploit = v.id == 22 and (not global.userData:isOpenExploit())
				local isUnlock = not global.cityData:checkBuildLv(v.unlock_building, v.unlock_lv)
				local isOccWild = v.id == 21 and global.userData:getWorldCityID() == 0
				if isUnlock or isOccWild then
					v.state = -2
					table.insert(lie1, v)
				elseif isExploit then
					v.state = -3
					table.insert(lie1, v)
				else
					table.insert(lie, v)
				end
			end
	 	end
	end

	local sortFunc = function (a, b)

		local aColor = a["color_"..a.state]
		local bColor = b["color_"..b.state]

		if aColor == bColor then
			if a.state == b.state then
            	return a.array < b.array
            else
            	return a.state < b.state
            end
        else
            return aColor > bColor
        end 
	end

	table.sort(lie1, function(s1, s2) return s1.array<s2.array end)
	table.sort(lie,  sortFunc)
	
	for _,v in pairs(lie1) do
		table.insert(lie, v)
	end

	for _,v in pairs(lie) do
		table.insert(initleisure, v)
	end

	self:vipChestOrder(initleisure)

	self.leisure = {}
	self.leisure = initleisure
end

function _M:vipChestOrder(initleisure) --vip 宝箱为绿色 置顶
	local index1 =nil 
	local index2 = nil
	local isAllGreen = true 
	for k ,v in pairs(initleisure) do
		if v.id == 6 and  v["color_"..v.state]==1 then 
			index1 = k 
		end 
		if k~=1 and v["color_"..v.state]~=1 then 
			index2 = index2 or k 
		end

		if k~=1 and v["color_"..v.state] ~=1 then 
			isAllGreen = false 
		end 
	end

	if index1 and (not index2) and (isAllGreen==false) then 
		index2 = 2 --放在 每日任务后面
	end 

	if not index1 then 
		return 
	end 

	if initleisure[index1-1] then 
		local v= initleisure[index1-1] 	
		if v["color_"..v.state]==1 then 
			return 
		end 
	end 

	if index1 and index2 then 
		local temp = initleisure[index1]
		initleisure[index1] = initleisure[index2]
		initleisure[index2] = temp
	end 

end 

-- 每日任务
function _M:dailyTask(target)
	
	local state, parm = 0, 0
	local config = luaCfg:get_config_by(1)
    local isUnlock = global.funcGame:checkTarget(config.daily_task_level)

	--免费刷新次数
	local refershTimes = global.dailyTaskData:getFlushTime()
	local dailyRlush = luaCfg:get_daily_refresh_by(1)
	local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipTaskCount")
    if (refershTimes < dailyRlush.freeTime or vipfreenumber > 0) and isUnlock then
    	state = 1
    else
    	local unGetBox = global.dailyTaskData:unGetStateNum()
    	local unGetTask = global.dailyTaskData:getFinishTask()
    	local isHaveTask, _ = global.dailyTaskData:isHaveTask()    	
    	if unGetTask > 0 or unGetBox > 0 then
    		state = 2
    	elseif isHaveTask then
    		state = 3
    	end
    end
	return state, parm
end




-- 活动大厅
function _M:activity(target)
	
	local state, parm = 0, 0
	local isOpen, lType = global.ActivityData:getActivityStatus()
	if isOpen then
		state = 1
		parm = lType
	end
	return state, parm
end

-- boss
function _M:boss(target)
	
	local state, parm = 0, 0
	local fightBoss = global.bossData:getFightBoss()
	if fightBoss and fightBoss.id > 0  then
	else
		state = 1
	end
	return state, parm
end

-- hero
function _M:hero(target)
	
	local state, parm = 0, 0	 
	if global.heroData:getHeroDataInCome() then
		if global.heroData:getPersuadeTime() > global.dataMgr:getServerTime() then
			parm = global.heroData:getPersuadeTime()
			state = 2
		else
			state = 1
		end
	end
	return state, parm
end

-- 英雄转盘
function _M:heroTurn()
	-- body
	local state, parm = 0, 0
	if not global.cityData:isBuildingExisted(15) then
        return state, parm	
    end
    local targetId = luaCfg:get_turntable_hero_cfg_by(1).open_lv
    if not global.funcGame:checkTarget(targetId) then
        return state, parm	
    end

	local isFreeTimes = global.userData:getFreeLotteryCount() <= 0
	if isFreeTimes then  -- 有免费次数
		state = 1
	else
		state = 2
		parm = global.dailyTaskData:getFreeLotteryTime()
	end
	return state, parm	

end

-- chest
function _M:freeChest(target)
	
	local state, parm = 0, 0
	local freeNum = global.dailyTaskData:getFreeBagNum()
	if freeNum < 0 then freeNum = 0 end
	local freeData = luaCfg:get_free_chest_by(1)
	if freeNum > 0 and freeNum <= freeData.max then
		state = 1
	else
		state = 2
		parm = math.floor(global.dailyTaskData:getRestTime() + global.dataMgr:getServerTime()) 
	end
	return state, parm
end

function _M:vipChest(target)
	
	local state, parm = 0, 0
	local curWild = global.dailyTaskData:getWildTimes()
	local wildData = luaCfg:get_wild_chest_by(2)
	local maxWild = wildData.num
	if curWild >= maxWild then
		state = 1
	else
		if not global.dailyTaskData:checkIsCanWild() then
			state = 2
			parm = math.floor(global.dailyTaskData:getWildRestTime() + wildData.time*60) 
		else
			state = 3
			local now_wildNum = global.dailyTaskData:getWildTimes()
     		if now_wildNum < 0 then now_wildNum = 0 end
     		parm = now_wildNum .. "/" .. maxWild
		end
	end
	return state, parm
end

-- 月卡
function _M:monthCard(target)
	
	local state, parm = 0, 0
	if global.rechargeData:isMonthGet() then
		state = 1
	end
	return state, parm
end

-- 占卜
function _M:divine(target)
	
	local state, parm = 0, 0
	local freeTimes, diamondTimes = global.refershData:getDivTimes()
	local config = luaCfg:get_config_by(1)
    local freeR, freeD = config.divineReset, config.divineCost

    -- 免费占卜
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDivCount")
	if freeTimes[2] < freeD or vipfreenumber> 0 then
		state = 1
	else
	    state = 3
	end
	return state, parm
end

-- 神秘商店
function _M:mistoryShop(target)
	
	local state, parm = 0
	local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipShopCount")
    local basefreenumber= global.MySteriousData:getFreeNumber()
    if (vipfreenumber+basefreenumber) >0 then 
        state = 1
    else
    	state = 2
    end 
	return state, parm
end

-- 炼金池
function _M:salary(target)
	
	local state, parm = 0, 0
	local lFreeTimes, diamondcount = global.refershData:getSalaryFreeCount()
    local cunt_vip_freenumber = global.vipBuffEffectData:getVipLevelEffect(3086).quantity or 0  --
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDiamondCount")

    vipfreenumber = cunt_vip_freenumber-vipfreenumber

    if not global.vipBuffEffectData:isVipEffective() then 
        vipfreenumber = 0
    end

    local getUseFreeCount = function () --已使用的次数=  基础免费  + vip免费  即使vip失效 也需要使用过的次数
	    local lFreeTimes,diamondcount = global.refershData:getSalaryFreeCount()
	    lFreeTimes = global.refershData:getOriginalFreeNumber()-lFreeTimes
	    local  cunt_vip_freenumber= global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDiamondCount")
	    return  lFreeTimes + cunt_vip_freenumber
	end 

	local getSalarylimitcount = function ()
		local lFreeTimes,diamondcount  = global.refershData:getSalaryFreeCount()
		local limit = global.luaCfg:config()[1].salary_limit 
		local viplimit= global.vipBuffEffectData:getCurrentVipLevelEffect(3081).quantity or 0 
		limit= limit+ viplimit
		return limit - (diamondcount+getUseFreeCount())
    end

	local limitcount  = getSalarylimitcount()

    if lFreeTimes + vipfreenumber > 0 and  limitcount > 0  then 
    	state = 1
    else
    	if limitcount > 0 then 
    		state = 2 
    	end  
    end

    parm =  global.cityData:getBuildingById(target)
	return state, parm
end

-- 科技
function _M:science(target)
	
	local state, parm = 0, 0
	if global.techData:isIdle() then
		state = 1
	else
		state = 2
		local tech = global.techData:getQueueByTime()
		if tech and tech[#tech] then
			if tech[#tech].lStartTime then  -- protect 
				parm = tech[#tech].lStartTime + tech[#tech].lRestTime
			end 
		end
	end
	return state, parm
end

-- 成就
function _M:achieve(target)

	local state, parm = 0, 0
	local achCount = global.achieveData:getAcieveNum()
	if achCount > 0 then
		state = 1
	else
		state = 2
	end
	return state, parm
end

-- 英雄驻防
function _M:heroGarrison(target)
	
	local state, parm = 0, 0
	-- local data = global.heroData:getHeroHeadData()
	-- if data and data.nameIcon then 
	-- 	state = 1
	-- end
	return state, parm
end

-- 避难所
function _M:hospital(target)

	local state, parm = 0, 0
	local recruitData = global.soldierData:getAllHealedSoldierArr()
	local cureData = global.soldierData:getAllWoundedSoldierArr()

	-- 可招募
	local isRecruit = recruitData and (#recruitData > 0)
	local isCure = cureData and (#cureData > 0)

	-- 免费治疗
	if global.userData:getFreeHeal() > 0 and isCure then
		state = 0
	else
		if isRecruit then
			state = 2
		else
			if isCure then
				state = 3
			end
		end
	end

	return state, parm
end

-- 训练
function _M:train(target)

	local checkTrain = function (lBdTrain)
		
		local isMonthCard = global.vipBuffEffectData:isTrainMonthCard() == 3 
		local isCanTrain = true
		local trainId = 0
		for _,v in pairs(lBdTrain) do
			if v.lEndTime > global.dataMgr:getServerTime() then
				trainId = trainId + 1
			end
		end
		if isMonthCard then
			if trainId == 2 then
				isCanTrain = false
			end
		else
			if trainId == 1 then
				isCanTrain = false
			end
		end
		return isCanTrain
	end

	local getParm = function (lBdTrain)
		for _,v in pairs(lBdTrain) do
			local cur = global.dataMgr:getServerTime()
			local rest = v.lEndTime - cur
			if rest < 0 then rest = 0 end
			v.rest = rest
		end

		table.sort(lBdTrain, function(s1, s2) return s1.rest<s2.rest end)
		if lBdTrain[1] then
			return lBdTrain[1].lEndTime
		else
			return 0
		end
	end
	
	local state, parm = 0, 0
	local buildData = global.cityData:getBuildingById(target)

	if buildData.serverData and buildData.serverData.lBdTrain then
		if checkTrain(buildData.serverData.lBdTrain) then
			state = 1
		else
			state = 2			
		end
		parm  = getParm(buildData.serverData.lBdTrain)
	else
		state = 1
	end

	return state, parm
end

-- 占领野地
 -- "lFlushTime" = 1496376870
 -- "lKind"      = 40082
 -- "lOPTime"    = 1496381499
 -- "lPosX"      = 62350
 -- "lPosY"      = -12766
 -- "lReason"    = 0
 -- "lResID"     = 640776698
 -- "lState"     = 2
function _M:wildcity()

	local resDisper = {}
	local getDisperTime = function (data)
		local designerData = luaCfg:get_wild_res_by(data.lKind)
		local currSvrTime = global.dataMgr:getServerTime()
    	local maxHp = designerData.waste
    	local restTime = maxHp*designerData.consume - (currSvrTime-data.lFlushTime)
    	return restTime
	end

	local state, parm = 0, {}
	local nowNum, maxNum = 0, 0
    local occupyData = global.resData:getOccupyMaxInfo() 
    if occupyData and occupyData.tagResource then
    	local vip_Resource = global.vipBuffEffectData:getCurrentVipLevelEffect(3078).quantity or 0 
        maxNum = occupyData.tagResource.lMaxOccupy + vip_Resource
    end
    local worldWild = global.resData:getWorldWild()
    nowNum = table.nums(worldWild) 

    if nowNum < maxNum then
    	state = 3
    	parm.nowNum = nowNum
    	parm.maxNum = maxNum
    else
    	state = 2
    	for _,v in pairs(worldWild) do
    		local restTime = getDisperTime(v)
    		local temp = {}
    		temp.data = v
    		temp.rest = restTime
    		table.insert(resDisper, temp)
    	end

    	table.sort(resDisper, function(s1, s2)

    		if not s1.data.lCollectSurplus then
    			return false
    		end

    		if not s2.data.lCollectSurplus then
    			return true
    		end

    		return (s1.data.lCollectSurplus / s1.data.lCollectSpeed) < (s2.data.lCollectSurplus / s2.data.lCollectSpeed)    		
    	end)

    	if table.nums(resDisper) > 0 then
    		parm = resDisper[1].data
    		state = resDisper[1].data.lCollectSurplus and 2 or 1
    	end
    end

	return state, parm
end

-- 军功是否可领取
function _M:exploit()

	local exploitData = global.userData:getTagExploit()
	if exploitData.lDailyGold == 1 then
		return 2
	else
		return 1
	end
end


-- 竞技厂挑战
function _M:HeroPk()

	-- local exploitData = global.userData:getTagExploit()
	-- if exploitData.lDailyGold == 1 then
	-- 	return 2
	-- else
	-- 	return 1
	-- end
	if global.userData:getPkCount()<=0 then 

		return 3   ,  global.advertisementData:getAdOverTime() 
	end 

	return 1 
end


function _M:HeroExpActive()

	local state =0 
	local parm = 0 

  	local flg = false  

    if not flg  then 
    	if global.unionData:canReceiveHeroExp() then 

    		flg =  true
        	state = 3 
    	end 
    end

    if not flg then 
       if not global.unionData:getMyMainExpHero() then 
       		flg = true 
       		state =1 
       end 
    end 

    if not flg then  --进行中
    	if global.unionData:getMySpringHeroOVerTime() then
    		state = 2 
    		parm =global.dataMgr:getServerTime() + global.unionData:getMySpringHeroOVerTime() or 0
    	end
    end 

    return state , parm
end

-- 神兽是否可互动
function _M:petActive()
	-- body
	if global.petData:getPetActNum() > 0 then
		
		local petType = global.petData:getNoCdPet() 
		if petType == 0 then
			local cdTime, petType = global.petData:getPetCd() 
			return 2, cdTime, petType  	  -- cd中
		else
			return 1, 0, petType     	  -- 可互动
		end
	else
		return 3 -- 当前没有激活的神兽
	end
end

-- 获取监听列表
function _M:getEventList()
	
	local eventList = {
		"EV_ON_UI_LEISURE",			  -- 其他
		"EV_ON_UI_HERO_FLUSH",        -- 英雄
		"EV_ON_DAILY_TASK_FLUSH",     -- 每日任务
		"EV_ON_UI_RECHARGE",          -- 月卡
		"EV_ON_UI_TECH_FLUSH", 		  -- 科技
		"EV_ON_SOLDIERS_UPDATE",	  -- 训练
		"EV_ON_UI_ACM_UPDATE",		  -- 成就
		"EV_ON_EXPLOIT_GETREWARD",
		"EV_ON_PET_REFERSH",
	}
	return eventList
end

-- 获取当前红点数
function _M:getLeisureNum()
	
	local num = 0
	local lei = self:getLeisure()
	for _,v in pairs(lei) do
		if v["color_"..v.state] == 1 then  
			num = num + 1
		end
	end
	return num
end


-- 本地存储屏蔽的选项列表
function _M:getLeisureList()

    local list = cc.UserDefault:getInstance():getStringForKey("LEISURELIST"..global.userData:getUserId())
    if list and list ~= "" then
        return self:decodeLeisureList(list)
    else
    	return {}
    end
end

-- 写入(leisure id)
function _M:writeLeisureList(data)

    local list = ""
    for _,v in pairs(data) do
        list = list .. v .. "#"
    end
    cc.UserDefault:getInstance():setStringForKey("LEISURELIST"..global.userData:getUserId(), list)
    cc.UserDefault:getInstance():flush()

    -- 刷新本地数据
    self:initLeisureAll()
end

-- 解析
function _M:decodeLeisureList(list)

    local liesure = {}
    local tempList = string.split(list, "#")
    for _,v in ipairs(tempList) do
        table.insert(liesure, tonumber(v))
    end
    return liesure
end

-- 本地是否有保存
function _M:isExitLocal(id)
	-- body
	local localList = self:getLeisureList() 
	for _,v in pairs(localList) do
		if v == id then
			return true
		end
	end
	return false
end

-- 是否有变化
function _M:isChangeList(list)

	table.sort(list, function(s1, s2) return s1 < s2 end)
	local localList = self:getLeisureList() 
	table.sort(localList, function(s1, s2) return s1 < s2 end)
	local listNum1 = #list
	local listNum2 = #localList
	local num = listNum1 > listNum2 and listNum1 or listNum2
	for i=1,num do
		if list[i] and localList[i] and (list[i] == localList[i]) then
		else
			return true
		end
	end
	return false
end

global.leisureData = _M
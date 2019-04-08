local luaCfg = global.luaCfg

local _M = {
	bosData  = {},
	mapData  = {[1]={}, [2]={}},
	isFirstData = {[1]=0, [2]=0},
	bosMidData={},
	tgGate = {},
}

function _M:init(data)
	
	local msg = data.tgGate
    if self.mapData[1] and table.nums(self.mapData[1]) > 0 then
    	self.tgGate = msg
    else
    	self.roundNum1 = 0 -- 普通boss
    	self.roundNum2 = 0 -- 极限boss
		self:initMap(1)
		self:initMap(2)
		self:initServer(msg) 

		-- 路线特效
		self.lastEffectData = nil
		self:setRershEffect()

		-- 重连监听，刷新表现
		self:reconnectEvent()

		-- 龙潭挑战令购买次数
		self:setGateBuyTime(data.lBuyEnergyCount or 0)
	end
end

function _M:setGateBuyTime(times)
	-- body
	self.gateBuyTimes = times
end
function _M:getGateBuyTime()
	-- body
	return self.gateBuyTimes
end

function _M:reconnectEvent()
	-- body
	gevent:addListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function()
	    
		self.tgGate = self.tgGate or {}
		for _,v in pairs(self.tgGate) do
			self:refersh(v)
		end	
		gevent:call(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, {})
	end)

end

function _M:isFirstInit(index)
	return (self.isFirstData[index] == 0)
end
function _M:setFirstInit(index)
    self.isFirstData[index] = 1
end

function _M:setRershEffect()
	--第一次进游戏初始化数据
	self.lastEffectData = clone(self.bosData)
	for _,v in pairs(self.lastEffectData) do

		for i,value in ipairs(v.data) do

			local isPass = false
		    if value.serverData and value.serverData.lPathTime then 
		        isPass = (value.serverData.lPathTime > 0)
		    end
		    if isPass then
		    	value.effectFlag = 1	-- 已播放
		    else
		    	value.effectFlag = 0    -- 未播放
		    end
		end
	end
end

-- index 1普通boss 2极限boss
function _M:getCurrentShowChest(index)

	if index == 2 then
		return nil
	end

	local chest={}

	local chest_gate =  self:ChestGateList(index) -- 可领取的关卡

	if #chest_gate > 0 then --可领取的关卡

		table.sort(chest_gate,function(A,B) return A.monsterID < B.monsterID end)

		chest.canopen = true 

		chest.dropid = chest_gate[1].drop

		chest.gate =chest_gate[1]

		return  chest

	else -- 显示将要领取的宝箱

		local attacked_gate = self:getAttackedBoss(index)   	-- 攻打过的关卡

		local chest_gate = self:CanGetChestGate()  		-- 有宝箱的关卡

		table.sort(attacked_gate,function(A,B) return A.monsterID > B.monsterID end)

		table.sort(chest_gate,function(A,B) return A.monsterID < B.monsterID end)

		local max_attacked_gate = attacked_gate[1]

		if not max_attacked_gate  then --如果没有攻打过boss 则使用默认解锁 

			-- local unlockboss = self:getUnlockboss()
			-- table.sort(unlockboss,function(A,B)return A.monsterID > B.monsterID end)
			-- chest = chest_gate[1]
			-- return chest
			max_attacked_gate ={}
			max_attacked_gate.monsterID =  -1 
		end 

		for _ , v in pairs(chest_gate) do  

			if  v.monsterID  >  max_attacked_gate.monsterID then 

				chest.canopen = false 

				chest.dropid  = v.drop

				chest.gate  = v 

				return chest 
			end 
		end 
	end

	return false
end

function _M:setGateChestStatus(id , bChest)

	local index = 1 
	local tempBoss = luaCfg:get_gateboss_by(id) 
	if tempBoss then
		index = tempBoss.Elite
	end
	local attacked_gate = self:getAttackedBoss(index)
	for _ ,v in pairs(attacked_gate) do
		if v.id == id then 
			if v.serverData then
				v.serverData.bChest = bChest
				break
			end 
		end 
	end 
end 

function _M:ChestGateList(index)-- 宝箱列表

	local boss ={}
 	local attacked_gate = self:getAttackedBoss(index)
		for _ ,v in pairs(attacked_gate) do
			for _, vv in pairs(self:CanGetChestGate()) do 
				 if vv.monsterID == v.monsterID and v.serverData and v.serverData.bChest == 0 then 
					table.insert(boss,vv)
				 end 
			end 
		end 
	return boss 
end


function _M:CanGetChestGate() -- 可以得到有宝箱的关卡
	local gate ={} 
	local boss = global.luaCfg:gateboss()
	for i,v in pairs(boss) do 
		if v.drop ~= 0  then 
			table.insert(gate,v)
		end
	end 
	return gate 
end


function _M:getUnlockboss()
	local boss = {} 
	for k , value in pairs(self:getBoss()) do
		for _ , v in pairs(value.data) do 
			local data  = v 
		    local isUnlock = false
		    if data.Front == 0 then
		        isUnlock = true
		    else
		        local frontData = global.bossData:getDataById(data.Front)
		        if frontData.serverData and frontData.serverData.lPathTime then 
		            isUnlock = (frontData.serverData.lPathTime > 0)
		        end
		    end
		    if isUnlock then 
		    	table.insert(boss,v)
		    end 
		end 
	end 
	return boss 
end 

function _M:getAttackedBoss(index) -- 获取已攻打过的关卡
	local boss = {} 
	for k, value in pairs(self:getBoss()) do 
		for _, v in  pairs(value.data) do 
		
			if v.serverData and v.Elite == index then
				local starNum = 0
		        local curScale = v.serverData.lPathPower or 0
		        local curPathTime = v.serverData.lDuration or 0
		        local curPassTime = v.serverData.lPathTime or 0

		        if curScale > 0 and curScale <= v.StarsScale then
		            starNum = starNum + 1
		        end
		        if curPathTime > 0 and curPathTime <= v.StarsTime then
		            starNum = starNum + 1
		        end
		        if curPassTime > 0 then
		            starNum = starNum + 1
		        end

		        -- 普通boss
		        if starNum > 0 and index == 1 then 
		        	table.insert(boss, v)
		        end 

		        -- 极限boss
		        if index == 2 and curPathTime > 0 and curPathTime <= v.StarsTime then
		        	table.insert(boss, v)
		        end

		    end 
		end
	end 
	return boss
end


-- 播放完之后改变状态
function _M:setEffectFlagBy(id, effectFlag)

	for _,v in pairs(self.lastEffectData) do
		for i,value in ipairs(v.data) do
			if value.id == id then
				value.effectFlag = effectFlag
			end
		end
	end
end

-- 获取播放状态
function _M:getEffectFlagBy(id)

	for _,v in pairs(self.lastEffectData) do
		for i,value in ipairs(v.data) do
			if value.id == id then
				return value.effectFlag
			end
		end
	end

	return 1
end


-- 服务器数据
function _M:initServer(msg)
	local insertCall = function (server)
		
		for _,v in pairs(self.bosData) do
			for _,value in pairs(v.data) do
				
				if value.id == server.lID then
					value.serverData = server
				end
			end
		end
	end
	
	if msg then
		for _,v in pairs(msg) do
			insertCall(v)
		end
	end

	for i,v in ipairs(self.bosData) do
		if v.lType > 0 then
			table.insert(self.bosMidData, v)
		end
	end

end

-- 最大关卡数
function _M:getBossMaxNum(index)
	-- body
	local id = index == 1 and 1 or 1001
	local fData = luaCfg:get_gateboss_by(id)
	return fData.bossMax
end

-- 初始化基础数据
function _M:initMap(index)

	local data = luaCfg:gateboss()

	-- 起始前三个
    local temp1 = {}
    temp1.lType = -1
    temp1.data = self:getData(1, 3, index)
    table.insert(self.bosData, temp1)

    -- 随机规则
    local ir = 1 
    local randSound = {4,5,5,4,5,4,4}

    local startIdx = 4
    local endIdx = self:getBossMaxNum(index)
    local iValue = startIdx

    -- 循环次数
    local roundNum = 0
    for i=startIdx, endIdx  do

        if i >= iValue+randSound[ir]-1 then

            if ir == (#randSound) then ir = 1 end
            local temp2 = {}
            temp2.lType = randSound[ir]
            temp2.data = self:getData(i-randSound[ir]+1, i, index)
            table.insert(self.bosData, temp2)

            roundNum = roundNum + 1
            iValue = i+1
            ir = ir + 1
        end
    end

    -- 结尾处理
    local leftNum = endIdx - iValue + 1

    if leftNum > 2 then
        roundNum = roundNum + 1
        local temp = {}
		temp.lType = randSound[1]
		temp.data = self:getData(iValue, endIdx, index)
		table.insert(self.bosData, temp)
    else
    	if leftNum > 0 then
	    	local temp = {}
		    temp.lType = -2
		    temp.data = self:getData(iValue, endIdx, index)
		    table.insert(self.bosData, temp)
	    end
    end

    -- 图块
    local randSoundMap = {1,2,3, 2,1,3, 1,3,2}
    local irM = 1

    for i=1,roundNum*3 do
        
        if irM > (#randSoundMap) then 
            irM = 1
        end
        if randSoundMap[irM] then
            table.insert(self.mapData[index], randSoundMap[irM])
            irM = irM + 1
        end
    end

    self["roundNum"..index] = roundNum
   
end

-- index: 1普通 2极限 
function _M:getData(startIdx, endIdx, index)
	
	startIdx = index == 1 and startIdx or (startIdx+1000)
	endIdx 	 = index == 1 and endIdx   or (endIdx+1000)

	local temp = {}
	for i,v in pairs(luaCfg:gateboss()) do
		if (v.id>=startIdx) and (v.id<=endIdx) then
			table.insert(temp, v)
		end
	end
	table.sort(temp, function(s1, s2) return s1.id < s2.id end)
	return temp
end

-- index: 1普通 2极限
function _M:getBosMidData(index)

	local midTemp = {}
	for i,v in ipairs(self.bosMidData) do
		for k,vv in ipairs(v.data) do
			if vv.Elite == index then 
				table.insert(midTemp, v)
				break
			end
		end
	end
	--table.sort(midTemp, function(s1, s2) return s1.data.id < s2.data.id end)
	return midTemp
end

function _M:getMap(index)

	return self.mapData[index]
end

function _M:getBoss()
	
	return self.bosData
end

function _M:getRound(index)
	return self["roundNum"..index]
end

function _M:getDataByType(lType, index)

	local temp = {}
	for _,v in pairs(self.bosData) do
		if v.lType == lType then
			for k,vv in pairs(v.data) do
				if vv.Elite == index then 
					table.insert(temp, vv)
				end
			end
		end
	end
	table.sort(temp, function(s1, s2) return s1.id < s2.id end)
	return temp
end

function _M:getDataById(id)

	for _,v in pairs(self.bosData) do
		for _,value in pairs(v.data) do
			
			if value.id == id then
				return value
			end
		end
	end
	return nil
end

function _M:getFightBoss()

	for _,v in pairs(self.bosData) do
		
		for _,value in pairs(v.data) do
			
			if value.serverData and value.serverData.lDisapperTime then
				local leftTime = value.serverData.lDisapperTime
				local times = leftTime - global.dataMgr:getServerTime()
				if times > 0 then
					return value
				end
		    end
		end
	end
	return nil
end

-- 获取当前解锁boss 
function _M:getCurUnlockBoss(index)

	index = index or 1

	local isUnlockCall = function (data)
        
        if not data then return false  end

        local isUnlock = false
	    if data.Front == 0 then
	        isUnlock = true
	    else
	        -- 普通boss
	        local frontData = global.bossData:getDataById(data.Front)
	        if frontData.serverData and frontData.serverData.lPathTime then -- and data.Elite == 1 then 
	            isUnlock = (frontData.serverData.lPathTime > 0)
	        end
	        -- 极限boss
	        -- if frontData.serverData and frontData.serverData.lDuration and data.Elite == 2 then 
	        --     isUnlock = frontData.serverData.lDuration > 0 and  frontData.serverData.lDuration <= data.StarsTime
	        -- end
	    end

        return isUnlock
    end

	local curUnLockId = 0
    for i,v in ipairs(self.bosData) do
        for _,value in ipairs(v.data) do
            if not value.serverData and index == value.Elite then
                curUnLockId = value.id
                break
            end
        end
        if curUnLockId ~= 0 then break end
    end

    if curUnLockId ~= 0 then
	    local isUnlocked = isUnlockCall(self:getDataById(curUnLockId))
	    if not isUnlocked and curUnLockId > 0 then
	        curUnLockId = curUnLockId - 1
	    end
	else
		curUnLockId = self:getBossMaxNum(index)
	end
    return curUnLockId
end


function _M:getStarNum()
	
	local curStar = 0
	local maxStar = 0

	for _,v in pairs(self.bosData) do
		
		for _,value in pairs(v.data) do
			
			if value.serverData and value.Elite == 1 then

				local curScale = value.serverData.lPathPower or 0
		        local curPathTime = value.serverData.lDuration or 0
		        local curPassTime = value.serverData.lPathTime or 0

		        if curScale > 0 and curScale <= value.StarsScale then
		            curStar = curStar + 1
		        end
		        if curPathTime > 0 and curPathTime <= value.StarsTime then
		            curStar = curStar + 1
		        end
		        if curPassTime > 0 then
		            curStar = curStar + 1
		        end
		    end

		    if value.Elite == 1 then
				maxStar = maxStar + 3
			end
		end
	end

	return curStar, maxStar
end

-- 收到通知刷新数据
function _M:notifyRefersh(msg)
	self:refersh(msg.tgGate) 
	gevent:call(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, {})
end

-- 切入后台（收不到通知重新拉取数据刷新）
function _M:resumeGate()

	local curId = self:getCurUnlockBoss()
	local curTemp = {}
	for i=1,curId do
		table.insert(curTemp, i)
	end

	global.BossChestAPI:gateBoss(curTemp, function(msg)
		msg.tagGate = msg.tagGate or {}
		for _,v in pairs(msg.tagGate) do
			self:refersh(v)
		end	
		gevent:call(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, {})
	end)
end

function _M:refersh(msg)

	local refershCall = function (srcdata, msg)
			
		for _,v in pairs(srcdata) do
			for _,value in pairs(v.data) do				
				if value.id == msg.lID then					
					value.serverData = {}
					value.serverData = msg
				end
			end
		end
	end
	refershCall(self.bosData, msg)
	refershCall(self.bosMidData, msg)
end

function _M:refershBoss(msg, gateId)

	local refershCall = function (srcdata, msg)
			
		for _,v in pairs(srcdata) do
			for _,value in pairs(v.data) do
				
				if value.id == gateId then
				
					if not value.serverData then
						value.serverData = {}
						value.serverData = msg
					else
						value.serverData.lDisapperTime = msg.lDisapperTime
						value.serverData.tagAtkSoldiers = msg.tagAtkSoldiers
						value.serverData.tagDefSoldiers = msg.tagDefSoldiers
						value.serverData.lPosx = msg.lPosx
						value.serverData.lPosy = msg.lPosy
					end
				end
			end
		end
	end
	refershCall(self.bosData, msg)
	refershCall(self.bosMidData, msg)
end

-- boss是否消失
function _M:wildObjNotify(data)

	for _,v in ipairs(data) do
		local isBoss = v.lBelongsType == 3 or v.lBelongsType == 6
		if v.lReason == 1 and isBoss then
			if global.funcGame:checkBelong(v) then
				gevent:call(global.gameEvent.EV_ON_UI_BOSS_MISS)
				v.lDisapperTime = v.lDisapperTime or 0
				local leftTime = v.lDisapperTime - global.dataMgr:getServerTime()
				if leftTime <= 0 then
					global.tipsMgr:showWarning("boss01")
				end
			end
		end
	end
end

-- 极限龙潭条件检测
function _M:checkAttackCondition(bossId, troopId)
	-- body
	if not bossId then return true end

	local gateData = global.luaCfg:get_gateboss_by(bossId or 1)
    local troopData = global.troopData:getTroopById(troopId)
    local heroData =  global.heroData:getHeroDataById(troopData.lHeroID[1])
    if not heroData then return true end

    local checkHeroType = function (herotype)
    	-- body
    	for i,v in ipairs(heroData.priority) do
    		if v == herotype then
    			return true
    		end
    	end
    	return false
    end

    local isHeroTypeTrue = false
   	for i,v in ipairs(gateData.hero) do
   		if checkHeroType(v) then
   			isHeroTypeTrue = true
   			break
   		end
   	end

   	if not isHeroTypeTrue then
   		global.tipsMgr:showWarning("limitBoss03",gateData.herotype) -- 携带英雄类型不对
   		return false
   	else
   		local power = heroData.serverData.lPower
   		if power < gateData.heroPower  then
	        global.tipsMgr:showWarning("heroPowerNotEnough")        -- 英雄战力不足 
	        return false
	    end
   	end
   	return true
end

global.bossData = _M
local luaCfg = global.luaCfg

local _M = {}

function _M:init(msg)   

	-- 线路状态
	self.isFirstData = {0,0,0}
	self.lastEffectData = {[1]={},[2]={},[3]={}}

	self.tech = {}
    self.techQueue = {}
    self.lineData = {}
    self.divine = {}
    self.techBuff = {}

	msg.tgTechs = msg.tgTechs or {}
	msg.tgQueues = msg.tgQueues or {}
	self.tech = clone(luaCfg:science())
	self:initTech(msg.tgTechs or {})
	self:initQueue(msg.tgQueues or {})
	
	-- 重连监听，刷新表现
	self:reconnectEvent()
end

function _M:reconnectEvent()
	-- body
	gevent:addListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function()
	    gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)
	end)
end

function _M:isFirstInit(lType)
	return self.isFirstData[lType]
end
function _M:setFirstInit(lType)
	if not lType then return end
	self.isFirstData = self.isFirstData or {} 
    self.isFirstData[lType] = lType
end

-- 科技加成
function _M:setTechBuff(buffs)
    self.techBuff = buffs
end

function _M:getTechBuff()
    return self.techBuff
end

--   1 = {
-- [LUA-print] -         "lBindID"    = 14000
-- [LUA-print] -         "lID"        = 21
-- [LUA-print] -         "lRestTime"  = 60
-- [LUA-print] -         "lStartTime" = 1492338282
-- [LUA-print] -         "lTotleTime" = 60
-- [LUA-print] -     }

function _M:initQueue(tgQueues)

	-- 正在研究科技队列
	for _,v in pairs(tgQueues) do
		
		if v.lID == 21 or v.lID == 24 then
			table.insert(self.techQueue, v)
		end
	end
	
end

function _M:initTech(tgTech)

	for _,v in pairs(self.tech) do
		v.lGrade = 0
		for _,tech in pairs(tgTech) do		
			if v.id == tech.lID then
            	v.lGrade = tech.lGrade
			end
		end
	end
end

function _M:localNotify()
	-- 本地推送
	for i ,v in pairs(self.techQueue) do 
		if v and v.lTotleTime and  v.lStartTime   then 
			global.ClientStatusData:recordNotifyData(2,v.rest,global.dataMgr:getServerTime())
		end 
	end 
end 

function _M:getQueue()
	
	return self.techQueue
end

function _M:getQueueById(techId)

	for _,v in pairs(self.techQueue) do
		if v.lBindID == techId then
			return v
		end
	end
end

-- 获取时间短的研究队列
function _M:getQueueByTime()

	local curServerTime = global.dataMgr:getServerTime()
	for _,v in pairs(self.techQueue) do
		local rest = 0
		if v.lStartTime and  v.lRestTime then
			rest = math.floor(v.lRestTime - (curServerTime-v.lStartTime))
		end
		v.rest = rest
	end

	table.sort(self.techQueue, function (s1, s2)  return  s1.rest > s2.rest end)

	for i=1,#self.techQueue do
		self.techQueue[i].index = i-1
	end

	return self.techQueue
end


function _M:addDelTechQueue(techQueue) --

	self.delTechQueue = self.delTechQueue or {} 

	table.insert(self.delTechQueue , techQueue)
end

function _M:delDelTechQueue(id) --
	for i,v in ipairs(self:getDelTechQueue()) do
		if v.lBindID == id then
			table.remove(self.delTechQueue or {} , i)
		end 
	end
end

function _M:getDelTechQueue() --

	return self.delTechQueue or {} 
end

function _M:getTech()
	
	return self.tech
end

function _M:getTechByType(lType)
	
	local data = {}
    for _,v in pairs(self.tech) do
        if v.type == lType then
            table.insert(data, v)
        end
    end
    table.sort( data, function(s1, s2) return s1.id < s2.id end )
    return data
end

function _M:getTechById(id)
	
	for _,v in pairs(self.tech) do

        if v.id == id then
            return v
        end
    end
end

-- 当前科技是否正在研究
function _M:isTeching(techId)

	local flag = false
	local checkTech = function (data)
		
		if data.lRestTime and (data.lRestTime > 0) and (techId == data.lBindID) then
			flag = true 
		end
	end

	for _,v in pairs(self.techQueue) do
		checkTech(v)
	end
	return flag
end

-- 当前是否有研究
function _M:isHaveTech()

	local flag = false
	local checkTech = function (data)
		if data.lRestTime and (data.lRestTime > 0)  then
			flag = true
		end
	end
	
	for _,v in pairs(self.techQueue) do
		checkTech(v)
	end

	return flag
end


function _M:cleanTechCD(id , time)

	local queue = nil 
	for _ ,v in ipairs(self.techQueue or {} ) do 
		if v.lID == id then 
			queue = v 
		end 
	end 
	if  queue then 
		-- queue.lTotleTime = queue.lTotleTime - time
		-- queue.lRestTime = queue.lRestTime - time
	 	-- gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)

	 	local lBindID = queue.lBindID
	 	self:reFreshTech()
    	return lBindID
	end 
end 

-- 当前是否处于闲置状态
function _M:isIdle()
	
	local flag = false
	local checkTech = function (data)
		if data.lRestTime and (data.lRestTime > 0)  then
			return 1
		else
			return 0
		end
	end
	
	local i = 0
	for _,v in pairs(self.techQueue) do
		i = i + checkTech(v)
	end

	local isTechMonthCard = self:checkTechMonthCard()
	if isTechMonthCard and i<2 then
		flag = true
	end
	if not isTechMonthCard and i<1 then
		flag = true
	end

	return flag
end

-- 当前是否有科技第二队列月卡
function _M:checkTechMonthCard()
    
    -- local monthCard = global.rechargeData:getMonthByType(4)
    -- if monthCard and monthCard.serverData.lState >= 0 then
    --     return true
    -- else
    --     return false
    -- end
  	return global.rechargeData:getMonthById(87).serverData.lState > -1 
end

-- 研究消CD完成 
function _M:techFinish(tgTechs)

	if tgTechs then
		self.tech = self.tech or {}
		for _,v in pairs(self.tech) do
					
			if v.id == tgTechs.lID then
	           v.lGrade = tgTechs.lGrade
	           self:removeQueue(tgTechs.lID)

	            gevent:call(global.gameEvent.EV_ON_UI_TECH_FINISH)	      
	            local scienceData = luaCfg:get_science_by(tgTechs.lID)
    			-- global.tipsMgr:showWarning(luaCfg:get_local_string(10438, scienceData.name, tgTechs.lGrade))
    			-- 科技研究完成了
    			local data = {listId=tonumber(1 .. scienceData.id), param={id=1, args={scienceData.name}}}
	            global.finishData:addFinshList(data)
			end
		end
	end
end

function _M:removeQueue(techId)
	
	for i,v in ipairs(self.techQueue) do
		
		if v.lBindID == techId  then
			self:addDelTechQueue(self.techQueue[i])
			table.remove(self.techQueue, i)
			break
		end
	end
end

function _M:referQueue(data)

	for i,v in ipairs(self.techQueue) do
		if v.lID == data.lID then
			if data.lRestTime and data.lRestTime > 0 then
				v.lRestTime = data.lRestTime 
				v.lStartTime = data.lSysTime 
			else
				table.remove(self.techQueue, i)
			end
			return
		end
	end

	if data.lRestTime and data.lRestTime > 0 then  
		table.insert(self.techQueue, data)
	end

	-- -- 本地推送
	-- if data and data.lTotleTime and  data.lStartTime   then 
	-- 		global.ClientStatusData:recordNotifyData(2,data.lTotleTime,data.lStartTime)
	-- end 
end

-- 刷新当前研究
function _M:updateTech(tgTechs, tgQueues)
	
	if tgTechs then
		for _,v in pairs(self.tech) do
					
			if v.id == tgTechs.lID then
	           v.lGrade = tgTechs.lGrade
			end
		end
	end

	if tgQueues and table.nums(tgQueues) > 0 then 
		self:referQueue(tgQueues)
	end
	gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)
end

---------------------------------- 线路 --------------------------------

local _LineState = {
	[1] = {id=1, value={1, 2, 3}},
	[2] = {id=2, value={1, 2, 4}},
	[3] = {id=3, value={5, 6, 8}},
    [4] = {id=4, value={9}},
    [5] = {id=5, value={6, 7, 8}},
}

local _Line = {

	["O"] = {{1},},
	["M0"] = {{4, 8}, },
	["M1"] = {{1, 5}, },

	["A10"] = {{6,7}, {5},},
	["A30"] = {{1,6,7},{2,5},{2,8,9},{4,6}, },
	["A50"] = {{2,3,8},{4,6},{1,6,9},{2,3,5},{2,8,9},{4,6},{1,6,9},{2,5},},
	["A70"] = {{2,3,8},{4,6},{1,6,9},{2,3,5},{2,8,9},{4,6},{1,6,9},{2,5},{2,8,9},{4,6},{1,6,9},{2,5},},

	["A11"] = {{2,3}, {4},},
	["A31"] = {{2,3,8},{4,6},{1,6,9},{2,3,5}, },
	["A51"] = {{2,3,8},{4,6},{1,6,9},{2,3,5},{2,8,9},{4,6},{1,6,9},{2,5},},
	["A71"] = {{2,3,8},{4,6},{1,6,9},{2,3,5},{2,8,9},{4,6},{1,6,9},{2,5},{2,8,9},{4,6},{1,6,9},{2,5},},

	["D10"] = {{2,8,9}, {4,6,7}, },
	["D21"] = {{2, 9}, {4}, },

	["B20"] = {{1,6,7},{2,5},},
	["B40"] = {{1,6,7},{2,5},{2,8,9},{4,6},{1,6,9},{2,5},},
	["B60"] = {{1,6,7},{2,5},{2,8,9},{4,6},{1,6,9},{2,5}, {2,8,9},{4,6},{1,6,9},{2,5},},

	["B21"] = {{2,3,8},{4,6},},
	["B41"] = {{2,3,8},{4,6},{1,6,9},{2,5},{2,8,9},{4,6},},
	["B61"] = {{2,3,8},{4,6},{1,6,9},{2,5},{2,8,9},{4,6}, {1,6,9},{2,5},{2,8,9},{4,6},},

	["D11"] = {{1,6,9},{2,3,5},},
	["D20"] = {{6,9},{5},},

	["L1"] = {{2,3,8},{4,6,7},},
	["L2"] = {{2,3,8},{4,6},},
}

function _M:setLineData( data, lType )


	self.lineData = {}
	
	-- 提取所有主干节点
	local mainNode = {}

	-- 添加顺序id
	for i=1,#data do
		data[i].sort = i
		data[i].state = 0	
		if i == 1 then 
			data[i].state = self:getCurTechState(data[i], data) 
			data[i].lockState = self:getLockState(data[i], data)
		end
		if data[i].branch == 0 then
			table.insert(mainNode, data[i])
		end
		-- 标志末尾节点
		if i == (#data) then
			table.insert(mainNode, data[i])
		end
	end

	for i=1,#mainNode-1 do                                                                                                                                                                                                                                                                                                                              

		local preClassLn = -1
		if i > 1 then
			preClassLn = self:getParity(mainNode[i-1], data) 
		end

		local classLn = self:getParity(mainNode[i], data)
		if i == (#mainNode-1) then
			classLn = (mainNode[#mainNode].sort - mainNode[i].sort)/2%2
		end

		if classLn == 1 then
				
			self:setOddClass(preClassLn, mainNode[i], mainNode[i+1] or {})
		else
			
			self:setEvenClass(preClassLn, mainNode[i], mainNode[i+1] or {})
		end
	end

	-- 初始化所有父节点下的字节点线路
	local tempLine = {}
	table.sort(self.lineData, function (s1, s2) return s1.id < s2.id end)

	for i=1,#self.lineData do
		
		for _,v in pairs(self.lineData[i].lineData) do
			table.insert(tempLine, v)
		end
	end

	for i=1,#data do
		if tempLine[i] then
			data[i].line = tempLine[i]
		end
	end

	--- 线路状态
	self:initLineState(data)

	-- 对比上次的显示状态
	self:setEffectFlag(lType)

	return self.tempData
end

function _M:setEffectFlag(lType)

	if #self.lastEffectData[lType] == 0 then return end

	local initFlag = function (id)
		for _,v in pairs(self.lastEffectData[lType]) do
			if v.id == id then
				return v.effectFlag
			end
		end
	end

	for _,v in pairs(self.tempData) do

		for _,vv in pairs(self.lastEffectData[lType]) do
			if v.id == vv.id then
				local temp = {}
				for _,vvv in pairs(vv.effectFlag) do
					table.insert(temp, vvv)
				end
				v.effectFlag = clone(temp)
				break
			end
		end
	end

end

function _M:initEffectFlag(msg, lType)

	for _,v in pairs(msg) do

		v.effectFlag = {0, 0, 0}
		for j=1,#v.line do
            local lineV = v.line[j]
            if lineV > 9  then
                v.effectFlag[j] = 1
            else
            	v.effectFlag[j] = 0
            end
        end
	end
	self.lastEffectData[lType] = clone(msg)
	return msg
end

function _M:refershEffectData(msg, lType)

	if not lType then return end
	local temp = clone(msg)
	for _,v in pairs(temp) do

		v.effectFlag = {0, 0, 0}
		for j=1,#v.line do
            local lineV = v.line[j]
            if lineV > 9  then
                v.effectFlag[j] = 1
            else
            	v.effectFlag[j] = 0
            end
        end
	end

	self.lastEffectData[lType] = {}
	self.lastEffectData[lType] = temp
	-- for _,v in pairs(self.lastEffectData) do
	-- 	for _,vv in pairs(msg) do
			
	-- 		if v.id == vv.id and vv.effectFlag > v.effectFlag then
	-- 			v.effectFlag = vv.effectFlag
	-- 			break
	-- 		end
	-- 	end
	-- end
end

function _M:initLineState( data )
	
	-- 初始化所有item 的解锁状态
	for i=2,#data do
		
		local state = self:getCurTechState(data[i], data)
		data[i].state = state
		data[i].lockState = self:getLockState(data[i], data)
	end

	-- 当前item的入口线路
	self.tempData = clone(data)
	for i=2,#data do
		if data[i].state == 1 then
			self:setLineState(data[i])
		end
		if i==2 or i==3 then
			if self.tempData[i].state == 1 then
				self.tempData[1].line = {11}
			end
		end
	end
end

function _M:setLineState(curSri)
	
	local lineRoad = {} 
	for _,v in pairs(curSri.stateLine) do
		table.insert(lineRoad, _LineState[v])
	end

	local preSort = self:getPreposeTarget(curSri, self.tempData)

	for i=preSort, curSri.sort do

		local tempLine = {}
		local findLine = function (vline)
			
			local temp = vline
			for _,v in pairs(lineRoad) do

				for _,vv in pairs(v.value) do
					if temp == vv and (temp<10) then
						temp = temp+10 
					end
				end
			end
			table.insert(tempLine, temp)
		end

		for _,v in pairs(self.tempData[i].line) do
			findLine(v)
		end
			
		self.tempData[i].line = tempLine
	end

end

function _M:getPreposeTarget(curSri, data)

	local sortNum = {}
	local preposeTarget = self:getCurLvTech(curSri.id, 1).preposeTarget
	for _,v in pairs(preposeTarget) do
		
		local lvData = luaCfg:get_science_lvup_by(v)
		for _,vv in pairs(data) do
			if vv.id == lvData.id then
				table.insert(sortNum, vv.sort)
			end
		end
	end
	table.sort(sortNum, function(s1, s2) return s1 < s2 end )
	return sortNum[1]
end

-- 科技解锁状态
function _M:getLockState(data, dataAll)
	
	local isUnlock = self:getCurTechState(data, dataAll)
	local temp = self:getCurLvTech(data.id, data.lGrade+1)
	-- 满级
	if not temp then 
		return 1
	end

	local unLockTarget = temp.unlockTarget
	local isFlag = true
	for _,v in pairs(unLockTarget) do
		if not global.funcGame:checkTarget(v) then
			isFlag = false
		end
	end
	if not isFlag then isUnlock = 0 end

	return isUnlock
end

-- 线路状态
function _M:getCurTechState(data, dataAll)

	if data.lGrade > 0 then return 1 end

	local temp = self:getCurLvTech(data.id, data.lGrade+1)
	local preposeTarget = temp.preposeTarget

	local isUnlock = 1
	for _,v in pairs(preposeTarget) do
		
		local lvData = luaCfg:get_science_lvup_by(v)
		for _,vv in pairs(dataAll) do
			if vv.id == lvData.id then
				if (vv.lGrade < lvData.lv) then
				 	isUnlock = 0
				 	break
				end
			end
		end
	end

	return isUnlock
end

function _M:getCurLvTech(id, lGrade)

	local scienceData = luaCfg:science_lvup()
	for _,v in pairs(scienceData) do
		if v.id == id and (v.lv == lGrade) then
			return v
		end
	end
end

function _M:inertLine(id, data)

	local line, temp = {}, {}
	line.id = id
	for _,v in pairs(data) do
		table.insert(temp, v)
	end
	line.lineData = clone(temp)
	table.insert(self.lineData, line)
end

function _M:inertData(line, data)
	
	for _,v in pairs(data) do
		table.insert(line, v)
	end
end

function _M:getLine(techId)
	
	for _,v in pairs(self.lineData) do
		
		if v.id == techId then
			return v.lineData
		end
	end
end

function _M:getLastNode()
	
	table.sort(self.lineData, function (s1, s2)  return s1.id < s2.id end)
	local num = #self.lineData
	return  self.lineData[num]
end

--奇数层
function _M:setOddClass(preClassLn, mainNode, nextNode )
	
	local line = {}

	--　起始节点 /首
	if mainNode.sort == 1 then	
		self:inertData(line,  _Line["O"])
		preClassLn = 1
	else
		local lastNode = self:getLastNode() 
		local classLn = (#lastNode.lineData - 1)/2%2
		if lastNode.id ~= 1 and (#lastNode.lineData > 3) then
			if preClassLn == 0 then  preClassLn = 1 
			else preClassLn = 0 end
		end

		self:inertData(line,  _Line["M"..preClassLn])
	end

	if nextNode.branch == 0  then
		-- 中
		local classNum1 = (nextNode.sort - mainNode.sort - 1)/2
		if classNum1 == 1 then
			self:inertData(line, _Line["L"..classNum1]) 
		else
			self:inertData(line, _Line["A"..classNum1..preClassLn])
		end

		-- 尾
		if classNum1 > 1 then
			if preClassLn == 0 then  preClassLn = 1 
			else preClassLn = 0 end
			self:inertData(line,  _Line["D1"..preClassLn])
		end
	else

		-- 中
		local classNum2 = (nextNode.sort - mainNode.sort)/2
		self:inertData(line, _Line["A"..classNum2..preClassLn])
		-- 尾
		if classNum2 > 1 then
			if preClassLn == 0  then 
				self:inertData(line,  _Line["D20"])
			else
				self:inertData(line,  _Line["D21"])
			end
		end
	end
	self:inertLine(mainNode.sort, line)
end

--偶数层
function _M:setEvenClass(preClassLn, mainNode, nextNode )

	local line = {}

	--　起始节点 /首
	if mainNode.sort == 1 then	
		self:inertData(line,  _Line["O"])
		preClassLn = 1
	else
		self:inertData(line,  _Line["M"..preClassLn])
	end

	if nextNode.branch == 0 then

		-- 中
		local classNum1 = (nextNode.sort - mainNode.sort - 1)/2
		self:inertData(line, _Line["B"..classNum1..preClassLn])
		-- 尾
		self:inertData(line,  _Line["D1"..preClassLn])
	else

		-- 中
		local classNum2 = (nextNode.sort - mainNode.sort)/2
		self:inertData(line, _Line["B"..classNum2..preClassLn])
		-- 尾
		if preClassLn == 0 then 
			self:inertData(line,  _Line["D21"])
		else
			self:inertData(line,  _Line["D20"])
		end
	end

	self:inertLine(mainNode.sort, line)

end

-- 获取当前父节点所拥有字节点的奇偶数
function _M:getParity(curSci, data)
	
	local nodeNum = 0
	for i=1,#data do
		
		if curSci.sort < data[i].sort and data[i].branch == 0 then

			nodeNum = (data[i].sort - curSci.sort - 1)/2%2
			break 
		end
	end
	return nodeNum
end

function _M:reFreshTech()

	global.techApi:techScience(2, 0, function (msg)
          
        self.techQueue = {}
        self:initTech(msg.tgTech or {})
    	self:initQueue(msg.tgQueue or {})
        gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)
    end)
end 

-- 切入后台，重新拉取科技数据 
function _M:resumeDeal()
	
	self:reFreshTech()

	-- 联盟未读消息数
    global.chatData:chatResume()

    -- 个人外交关系
    global.unionData:refershApproveCount()

    -- 好友系统刷新
    gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)

    -- 英雄驻防更新
    global.heroData:refershBuildGarrison() 

end

global.techData = _M
local luaCfg = global.luaCfg

local _M = {
	refersh = {}
}

function _M:init(msg)   

	msg = msg or {}
    self.refersh = msg 
    self:initDiv()
  	self:initSalary()       
  	self.freeMoveCityTimes = msg.lAllyFreeMove or 1 
  	self.lAnswerCount = msg.lAnswerCount or 0    
  	                       
end

function _M:setlAnswerCount(times)
	self.lAnswerCount = times
	self:resetQuestionToday(global.dataMgr:getServerTime())
	gevent:call(global.gameEvent.EV_ON_QUESTIONNAIRE)
end

function _M:getlAnswerCount() 
	return self.lAnswerCount or 0
end

function _M:resetQuestionToday(time)
	local tagTime = global.dailyTaskData:getTimestamp() or {} 
    tagTime.lLastAnswerTime = time or 0
    global.dailyTaskData:setTimestamp(tagTime)
    gevent:call(global.gameEvent.EV_ON_QUESTIONNAIRE)
end

function _M:isQuestionToday()
	local answerTime = global.dailyTaskData:getTimestamp().lLastAnswerTime or 0
	if answerTime > 0 and global.dailyTaskData:getCurDay(answerTime) == 0 then
		return true
	end
	return false
end

function _M:setFreeMoveTimes(times)
	self.freeMoveCityTimes = times
end
function _M:isHavFreeMoveTimes()

	if global.userData:getWorldCityID() == 0 then
		return false
	end	
	return self.freeMoveCityTimes == 0
end

-------------------------//- 占卜 -//-----------------------------

function _M:initDiv()
	
	self:setDivTimes(self.refersh)

    self.isFirstDivine = 0
    local isFirst = cc.UserDefault:getInstance():getStringForKey("IsFirstDivine"..global.userData:getUserId())
    if isFirst~="" and (tonumber(isFirst) ~= 0) then
        self.isFirstDivine = tonumber(isFirst)
    end
    self:setDivingState(self:getDivingState())
end

function _M:setDivTimes(msg,flag)
	local freeTimes = msg.lDivFreeCount or {}
	local diamondTimes = msg.lDivDiamondCount or {} 
	if flag and  flag==1  then --如果是点击免费刷新 回调
 		if  global.vipBuffEffectData:isUseVipFreeNumber("lVipDivCount") then 
            global.vipBuffEffectData:useVipDiverseFreeNumber("lVipDivCount",1)
        end
	end  
	self.divFree = freeTimes 
	self.divDiamond = diamondTimes
	self.lState = freeTimes[3] or 0
	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end

function _M:getDivTimes()
	return self.divFree, self.divDiamond
end

function _M:isFirstDiv()
	return self.isFirstDivine
end

function _M:setFirstDivine(value)
	self.isFirstDivine = value
	cc.UserDefault:getInstance():setStringForKey("IsFirstDivine"..global.userData:getUserId(), value)
    cc.UserDefault:getInstance():flush()
end

function _M:setDivState(lState)
	self.lState = lState
	gevent:call(global.gameEvent.EV_ON_UI_HEAD_FLUSH, 25)
end

function _M:getDivState()
	return self.lState 
end

--//  -1 (正在占卜，所有卡牌正面显示)  -2 (正在占卜,只有当前占卜卡牌正面显示）
function _M:setDivingState(lState)

	cc.UserDefault:getInstance():setStringForKey("setDivineingState"..global.userData:getUserId(), lState)
    cc.UserDefault:getInstance():flush()
end

function _M:getDivingState()

	local state = cc.UserDefault:getInstance():getStringForKey("setDivineingState"..global.userData:getUserId())
	if state == "" then
		state = "-2"
	end
    return tonumber(state) 
end

-- 整点重置
function _M:dailyChangeState()
	self:setDivState(0)   
    self:setFirstDivine(0)
end

-------------------------//- 占卜 -//-----------------------------



-------------------------//- 每日工资 -//-----------------------------

function _M:initSalary()

	self.freeTimes = 0
	self.originalFreeNumber = 0
	self.diamondTimes = self.refersh.lDiamondCount or 0
	self:initCount(self.refersh.lFreeCount or 0)
    self:requestDailaySalaryState()
end

function _M:setDailaySalaryState(lFreeCount,lDiamondCount)
    self:setFreeCount(lFreeCount,lDiamondCount)
    gevent:call(global.gameEvent.EV_ON_REFRESH_SALARY)
end

function _M:requestDailaySalaryState()
	global.SalaryAPI:requestSalaryState(function (msg)
		self:setDailaySalaryState(msg.lFreeCount,msg.lDiamondCount)
		self:setSalaryFreshTime(msg.lEndTime)
	end)
end 

function _M:getSalaryFreshTime()
	return self.salaryFreshTime or global.dataMgr:getServerTime()
end 

function _M:setSalaryFreshTime(time)
	self.salaryFreshTime = time 
end 

function _M:initCount(freeUseTimes)

	freeUseTimes = freeUseTimes or 0 

    local build = self:getCurSalaryBuild()
	if build.severPara1 then
		self.originalFreeNumber = build.severPara1 
		local times = build.severPara1 - freeUseTimes
		if times < 0 then times = 0 end
		self.freeTimes = times
	end
	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end

function _M:setFreeCount( freeTimes, diamondTimes )
	
	self.diamondTimes = diamondTimes
	self:initCount(freeTimes)
end

function _M:getSalaryFreeCount()

	self.freeTimes = self.freeTimes or 0
	self.diamondTimes = self.diamondTimes or 0
	return self.freeTimes, self.diamondTimes
end

-- 建筑升级次数变化
function _M:setRefershCount(buildId, curLv)

	local buildingType = global.luaCfg:get_buildings_pos_by(buildId).buildingType
	if buildingType ~= 23 then return end

	local addTimes = 0
	local build = self:getCurSalaryBuild()
	if build.severPara2 then
		addTimes = tonumber(build.severPara2)
	end
	if curLv == 1 and self.freeTimes == 0 then
		self.freeTimes =  build.severPara1
		self.originalFreeNumber  = build.severPara1
	end
	self.originalFreeNumber = self.originalFreeNumber+addTimes
	self.freeTimes = self.freeTimes + addTimes
	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end


function _M:getOriginalFreeNumber()
	return self.originalFreeNumber
end 

function _M:getCurSalaryBuild()
	
	local build = {}
	local buildingType = 23
	local registerBuild = global.cityData:getRegistedBuild()
    for _,v in ipairs(registerBuild) do
        if v.buildingType == buildingType  then

            local buildingData = global.luaCfg:buildings_lvup()
            for _,value in pairs(buildingData) do
            	if value.buildingId == buildingType and v.serverData.lGrade == value.level then
            		
            		build = value
            	end
            end
        end
    end
    return build
end

-------------------------//- 每日工资 -//-----------------------------


---------------------- 兵源购买次数 --------------------------
function _M:setBuyCount( buyTimes )
    self.refersh.lPopCount = buyTimes
end

function _M:getBuyCount()
    return (self.refersh.lPopCount or 0) + 1 
end

global.refershData = _M
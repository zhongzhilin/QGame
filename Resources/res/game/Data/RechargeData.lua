local luaCfg = global.luaCfg

local _M ={}

function _M:init(msg)  

	self.recharge = {}
	self.rechargeDaily = {}
	self.rechargeSlider = {}
	self.monthCard = {}
	self.tagLimitGift = msg.tagLimitGift or {}
	self.tagMagicGift = msg.tagMagicGift or {}

	if self.recharge and table.nums(self.recharge) > 0 then
    else
		self:initCharge()	
		self:initServerCard(msg.tgCards or {})
	end

	-- 充值成功刷新界面。
	gevent:call(global.gameEvent.EV_ON_UI_RECHARGE)
end

-- lState //0，可领取，1已经领取  -1不可领
function _M:initServerCard(msg)

	local initCall = function (id)
		
		for i,v in ipairs(msg) do
			if v.lID == id then
				local curTime = global.dataMgr:getServerTime()
				if not v.lState or (v.lEnd - curTime <= 0) then
					v.lState = -1
				end
				return v
			end
		end
	end

	for _,v in pairs(self.monthCard) do
		v.serverData = initCall(v.id) or {}
		if not v.serverData.lState then
			v.serverData.lState = -1
		end
	end

	-- gevent:call(global.gameEvent.EV_ON_MONTHCARD)

end

function _M:initCharge()
	
	local giftData = luaCfg:gift()
	for _,v in pairs(giftData) do
		if v.switch == 1 then 
			self:getDataByPos(v)
		end 
	end

	table.sort(self.recharge, function(s1, s2) return s1.range < s2.range end)
	table.sort(self.rechargeDaily, function(s1, s2) return s1.range < s2.range end)
	table.sort(self.monthCard, function(s1, s2) return s1.range < s2.range end)
end

function _M:getDataByPos(data)
	
	for _,v in pairs(data.position) do
		if v == 98 then 									-- 充值列表
			table.insert(self.recharge, data)
		elseif v == 101 then                                -- 每日特惠礼包
			table.insert(self.rechargeDaily, data)
		elseif v == 99 then     							-- 月卡
			table.insert(self.monthCard, data)
		elseif v == 7 and (#self.rechargeSlider == 0) then  -- 广告
			table.insert(self.rechargeSlider, data)
		end
	end
end

function _M:getCharge()
	
	return self.recharge
end

function _M:getChargeDaily()
	
	return self.rechargeDaily
end

function _M:getChargeSlider()
	
	return self.rechargeSlider
end

function _M:getMonthCard()
	
	return self.monthCard
end

function _M:initServer(serverMsg)

	local initCall = function (id)
		
		for _,v in pairs(serverMsg) do
			if v.lID == id then
				if not v.lBuyCount then
					v.lBuyCount = 0
				end
				return v
			end
		end
	end

	for _,v in pairs(self.recharge) do
		v.serverData = initCall(v.id) or {}
	end

	for _,v in pairs(self.rechargeDaily) do
		v.serverData = initCall(v.id) or {}
	end

end

function _M:initSliderData(serverData)
	if not serverData then return end
	self.rechargeSlider = {}
	if serverData.lAdID then 
		for _,v in pairs(serverData.lAdID) do
			
			local temp = luaCfg:get_gift_by(v)
			if temp  then
				if serverData.lEndTime then 
					temp.lEndTime = serverData.lEndTime
				end 
				table.insert(self.rechargeSlider, temp)
			end
		end
	else -- 没有id  代表 已售空 
		self.rechargeSlider = {}
	end 

	table.sort(self.rechargeSlider, function(s1, s2) return s1.range < s2.range end)
end

function _M:getChargeById(id)
	
	for _,v in pairs(self.recharge) do
		
		if v.id == id then
			return v
		end
	end
end

function _M:checkChargeCanBuy(giftId)

	local giftData = global.luaCfg:get_gift_by(giftId)
	self.tagLimitGift = self.tagLimitGift or {}
	for k,v in pairs(self.tagLimitGift) do
		if v.lID == giftId and v.lValue >= giftData.limit_time then
			return false
		end
	end
	return true
end

function _M:checkMagicChargeCanBuy(giftId)

	local giftData = global.luaCfg:get_gift_by(giftId)
	self.tagMagicGift = self.tagMagicGift or {}
	for k,v in pairs(self.tagMagicGift) do
		if v == giftId then
			return false
		end
	end
	return true
end

function _M:checkIntegralRefersh()

	local curTime = global.dataMgr:getServerTime()
	if curTime%3600 == 0 then
		self.tagMagicGift = {}
		gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)
	end

end

function _M:getChargeDailyList()

	local data = {}

	-- 每日限购礼包
	for k,v in pairs(self.rechargeDaily) do
    	local temp = clone(v)
    	temp.range = temp.id
    	temp.isDaily = true        
       	if self:checkChargeCanBuy(v.id) then
        	temp.isCanBuy = true
        end
        table.insert(data, temp)
    end

    -- 0元福利礼包
    local temp = clone(luaCfg:get_daily_free_gift_by(1))
    temp.isFreeGift=true
    temp.range = temp.id
    temp.isDaily = true
    if global.userData:getlDailyGiftCount() > 0 then
    	temp.isCanBuy = true
    end
    table.insert(data, temp)  

    -- 每小时刷新礼包
    local magicConfig = luaCfg:magic_gift()
    for k,v in pairs(magicConfig) do
		local temp = clone(v)
    	temp.range = temp.id
    	temp.isMagic = true
    	temp.isDaily = true        
        if self:checkMagicChargeCanBuy(v.id) then 
    		temp.isCanBuy = true
    	end
    	table.insert(data, temp)
    end
  
    table.sort(data, function(s1, s2) return s1.range < s2.range end)
    return data
end

function _M:isHaveAvailableGift()

	local isAvail = false
	local data = {}
	for k,v in pairs(self.rechargeDaily) do
        if self:checkChargeCanBuy(v.id) then
            isAvail = true
            break
        end
    end
    if global.userData:getlDailyGiftCount() > 0 then
    	isAvail = true
    end
    return isAvail
end

function _M:getChargeDailyById(id)
	
	for _,v in pairs(self.rechargeDaily) do
		
		if v.id == id then
			return v
		end
	end
end

function _M:getMonthById(id)
	
	for _,v in pairs(self.monthCard) do
		
		if v.id == id then
			return v
		end
	end
end

-- 超级月卡是否已经购买
function _M:isHadSuperMonthCard()
	local data = self:getMonthById(87)
	dump(data)
	if not data then return false end
	return data.serverData.lState ~= -1
end


-- 刷新充值礼包购买次数
function _M:refershRecharge(id)
	
	for _,v in pairs(self.recharge) do
		
		if v.id == id then

			if v.serverData then
				v.serverData.lBuyCount = v.serverData.lBuyCount + 1
			end
		end
	end
end

-- 刷新充值礼包购买次数
function _M:refershDailyRecharge(id, isMagic)
	
	if isMagic then

		local isBuyed = false
		self.tagMagicGift = self.tagMagicGift or {}
		for k,v in pairs(self.tagMagicGift) do
			if v == id then
				isBuyed = true
				break
			end
		end
		if not isBuyed then
			table.insert(self.tagMagicGift, id)
		end

	else

		for _,v in pairs(self.rechargeDaily) do
			if v.id == id then
				if v.serverData then
					v.serverData.lBuyCount = v.serverData.lBuyCount + 1
				end
			end
		end

		local isBuyed = false
		self.tagLimitGift = self.tagLimitGift or {}
		for k,v in pairs(self.tagLimitGift) do
			if v.lID == id then
				v.lValue = v.lValue + 1
				isBuyed = true
				break
			end
		end
		if not isBuyed then
			local temp = {lID=id, lValue=1}
			table.insert(self.tagLimitGift, temp)
		end
	end

end
function _M:resetDailyRecharge()
	
	for _,v in pairs(self.rechargeDaily) do
		if v.serverData then
			v.serverData.lBuyCount = 0
		end
	end
	gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)
	
end

-- 刷新月卡领取状态
function _M:refershMonthCard(id)
	
	for _,v in pairs(self.monthCard) do
		if v.id == id then
			if v.serverData then
				v.serverData.lState = v.serverData.lState + 1
			end
		end
	end
	gevent:call(global.gameEvent.EV_ON_UI_RECHARGE)
end

-- 当前是否有礼包可领取
function _M:isMonthGet()

	local isGet = false
	for _,v in pairs(self.monthCard) do
		if v.serverData and v.serverData.lState == 0  then
			isGet = true
		end
	end
	return isGet
end

-- 当天有已领取月卡，显示当天倒计时时间
function _M:getIsHaveCard()
	
	for _,v in pairs(self.monthCard) do
		
		if v.serverData.lState == 1 then
			return true
		end
	end
	return false
end

-- 零点刷新月卡状态
function _M:refershZero(isTimeOver)

	local curTime = global.dataMgr:getServerTime()
	for _,v in pairs(self.monthCard or {}) do
		
		-- if (v.type ~= 4 and  v.type ~= 5)  or isTimeOver then
			if v.serverData and v.serverData.lEnd and curTime < v.serverData.lEnd then
				v.serverData.lState = 0
			else
				v.serverData.lState = -1  -- 到截止时间，重置不可领状态-1
			end 
		-- end
	end
end

-- 根据类型获取礼包
function _M:getMonthByType(lType)
	
	for _,v in pairs(self.monthCard) do
		
		if v.type == lType then
			return v
		end
	end
end

function _M:updateMonthCard(msg)
	
	for _,v in pairs(self.monthCard) do
		
		if msg.lID == v.id then
			if v.serverData then
				v.serverData.lEnd = msg.lEndTime
			else
				v.serverData = msg
			end
		end
	end
end

-- 是否开通训练第二队列月卡
-- 1 训练卡剩余时间大于训练结束所需时间
function _M:checkTrainMonthCard(lTotleTime)

    local monthCard =self:getMonthByType(5)
    if monthCard and monthCard.serverData.lState >= 0 then

    	local lCur = global.dataMgr:getServerTime()
    	local lEnd = monthCard.serverData.lEnd
    	if (lEnd - lCur) > lTotleTime then 
    		return 1
    	else
    		return 0
    	end
    end
    return -1
end

-- 是否开通
function _M:isTrainMonthCard()
	local monthCard =self:getMonthByType(5)
    if monthCard and monthCard.serverData.lState >= 0 then
    	return true
    else
    	return false
    end
end

-- message PaySignInfo
-- {
-- 	required int32		lPayCnt		= 1;	//连续-7日一轮完成任务
-- 	required int32		lState		= 2;	//付款领取状态0为领取，1可领取，2已经领取		
-- 	optional int32		lDailyPay		= 3;	//今日已付款
-- }

function _M:setSevenDayRechargeData(msg)

	if msg then --容错处理 

		msg.endTime = global.advertisementData:getAdOverTime() --零点时间戳

		self.sevenDayRechargeData = msg 

	    gevent:call(global.gameEvent.EV_ON_SEVENDAYRECHARGE)

	end 
end 

function _M:getSevenDayRechargeData()

	return self.sevenDayRechargeData
end 

function _M:restSevenDayRechargeData()

	if self.sevenDayRechargeData  then 

		self.sevenDayRechargeData.lPayCnt = self.sevenDayRechargeData.lPayCnt + 1 

		if self.sevenDayRechargeData.lState ~= 0  then 

			if self.sevenDayRechargeData.lPayCnt > 7 then 

				self.sevenDayRechargeData.lPayCnt =  1 
			end 

		else 
				self.sevenDayRechargeData.lPayCnt = 1 
		end 

		self.sevenDayRechargeData.lDailyPay = 0  
		self.sevenDayRechargeData.lState = 0 

		self.sevenDayRechargeData.endTime = global.dataMgr:getServerTime() + ( 24 * 60 * 60 )

	end 

    gevent:call(global.gameEvent.EV_ON_SEVENDAYRECHARGE)
end 

function _M:checkDiamondConsume(oldDiamondNum)

	if self.sevenDayRechargeData and self.sevenDayRechargeData.lDailyPay then
		local curDiamond = global.propData:getProp(WCONST.ITEM.TID.DIAMOND)
		if curDiamond < oldDiamondNum then
			self.sevenDayRechargeData.lDailyPay = self.sevenDayRechargeData.lDailyPay + oldDiamondNum - curDiamond

			local curDayId = self.sevenDayRechargeData.lPayCnt
			local data = global.luaCfg:get_daily_day_by(curDayId)
			local rest = data.mony - self.sevenDayRechargeData.lDailyPay
		    if rest <= 0 and self.sevenDayRechargeData.lState == 0 then 
		        self.sevenDayRechargeData.lState = 1
		    end 
		    gevent:call(global.gameEvent.EV_ON_SEVENDAYRECHARGE)
		end
	end
end

function _M:setSevenDayRechargeState(state)

	if self.sevenDayRechargeData then
		self.sevenDayRechargeData.lState =state 
	    gevent:call(global.gameEvent.EV_ON_SEVENDAYRECHARGE)
	end 
	
end 

function _M:isSevenDayRed()

	if self.sevenDayRechargeData  then 

		return self.sevenDayRechargeData.lState  == 1 
	end 

	return false 
end 

global.rechargeData = _M
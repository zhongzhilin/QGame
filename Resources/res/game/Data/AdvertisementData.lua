local _M = {}
local luaCfg = global.luaCfg
local dailyTaskData = global.dailyTaskData

-- rint] - "广告数据啊99" = {
-- [LUA-print] -     1 = {
-- [LUA-print] -         "ltype"     = 2
-- [LUA-print] -         "tagadvert" = {
-- [LUA-print] -             1 = 17
-- [LUA-print] -         }
-- [LUA-print] -     }

local AD_Type = {2 ,3} --所有广告礼包类型


function _M:init(data,ad_time)

	-- dump(data ,"advertisement Data >>>>>>>> ")

	self.cloneData = data

	if  false  then
	else		
		
		self.Position  = global.EasyDev.AD_PS -- 所有广告位
		self.data = {}
		self.initnumber = 0 
		self.isInited = nil 

		for _ ,v in pairs(data) do 
			local temp ={} 
			local msg = {} -- 模拟单次请求返回 的 msg
			msg.lEndTime =  ad_time or 0 
			if v.tagadvert then 
				msg.lAdID = v.tagadvert
				temp.data = self:getChargeSlider(msg,v.ltype)
				temp.isvalid = true 
			else
				temp.isvalid = false
			end 
			temp.lEndTime = ad_time or 0 
			temp.position = v.ltype
			table.insert(self.data , temp)
			self.ad_overtime = ad_time
		end 
		self:reMoveFirstRecharge()
		self:setHideTimer()
		self:cleanUnLockData(data)
	end

	self:updateUI()--切后台 或者购买 完 刷新界面
end 


 _M.firstRechargeId = 35

function _M:reMoveFirstRecharge()
	local isRemove = false 
	global.userData:getSumPay() --初始化一下 ， 防止报错
	for _ ,v in  pairs(self:getAllAD()) do
		if v.isvalid then 
			for index ,vv in pairs(v.data) do 
				if not  global.userData:canFirstPay()then 
					if vv.id == self.firstRechargeId then 
						isRemove = true 
						table.remove(v.data , index)
					end 
				end
			end 
		end
	end

	if isRemove then 
		self:updateUI()
	end 
end 


function _M:setUnLockData(data)
	self.unLockData = clone(data)
end 

function _M:getUnLockData()

	return self.unLockData
end 

--     "lID"   = 8
-- [LUA-print] -         "lKind" = 1
-- [LUA-print] -     }
-- [LUA-print] -     2 = {
-- [LUA-print] -         "lID"   = 9
-- [LUA-print] -         "lKind" = 1
-- [LUA-print] -     }
-- [LUA-print] -     3 = {

function _M:cleanUnLockData(msg)

	-- dump(self.unLockData ,"清理前")

	for _ ,v1 in ipairs(msg) do 
		for _ ,v2 in ipairs(v1.tagadvert or {} ) do 
			for _ ,v3 in ipairs(self.unLockData or {}) do 
				if v3.lID == v2 then 
					v3.lID = -999
				end 
			end 
		end 
	end 

	-- dump(self.unLockData ,"清理hou")
end 

function _M:isPsLock(ps)

	local ps_data = {} -- 广告位 所有广告


	for _ ,v in ipairs(global.luaCfg:gift()) do 

		if v.switch == 1 and table.hasval(AD_Type , v.type) and table.hasval(v.position ,  ps) then 

			table.insert(ps_data  ,v )
		end  
	end 

	dump(ps_data ,"ps_data............/////")
	dump(self:getUnLockData() ,"self:getUnLockData()")

	for _ ,v in ipairs(ps_data) do 

		local lock = false 

		for _ ,vv in ipairs(self:getUnLockData() or {} ) do 

			if vv.lID == v.id then 
				lock =  true  
			end 
		end

		if not lock then  --找到已解锁AD

			return false 
		end 
	end 

	return true 
end 
 
-- 原价/现价*100
function _M:getGiftScale(gift_id)

	local gift = global.luaCfg:get_gift_by(gift_id)

	if gift then 

		return  string.format("%0.1f",math.floor(gift.cost / gift.price * 100)/10)

	end 

	return  0
end 


function _M:requestAllAdData()

	self:requestDataByPosition1(global.EasyDev.AD_PS, function () 

		gevent:call(global.gameEvent.EV_ON_UI_ADUPDATE)

	end)
end 

 -- 检查广告是否需要更新。 
function _M:CheckADUpdate()

	if self:getAdOverTime() < global.dataMgr:getServerTime() then

		self:requestAllAdData()

	end 
end 


function _M:cleanData() -- 清理数据  isvalid  == false  
	for i = #self.data, 1, -1 do

	   if not self.data[i].isvalid  then 

			table.remove(self.data, i)
		end 

	end
end 

function _M:getAdOverTime()
	-- local time =  global.dataMgr:getServerTime() - 1 
	-- for _ ,v in pairs(self.data)  do 
	-- 	-- if v.isvalid  then 
	-- 		time =v.lEndTime
	-- 		break
	-- 	-- end 
	-- end
	if  not self.ad_overtime then 
		return  global.dataMgr:getServerTime() - 1 
	end 
	return self.ad_overtime
end 


function _M:setInitedCall(call)
	self.InitedCall= call 
	if self.isInited then 
		if  self.InitedCall  then 
			self.InitedCall()
		end 
	end 
end 

function _M:getChargeSlider(msg,position)
    local temp ={}
    for _ , v   in pairs( msg.lAdID)  do 
       local ad = global.luaCfg:get_gift_by(v)
     	function checkposition(data , position)
     		for _ ,v in pairs(data.position) do 
     			if position == v then 
     				return true 
     			end 
     		end 
     		return false
     	end 
       if ad then 
       		--if checkposition(ad,position) then 
       			ad.lEndTime = msg.lEndTime
    	   		table.insert(temp,ad)
    		--end
   		end 
    end 
    table.sort( temp, function ( A,B)
       return A.range < B.range
    end )
    return temp
end 

function _M:insertDataByPosition(data,position)
	for index ,v in pairs(self.data ) do
		if v.position == position then 
			v.data = data  
		end 
	end 
end

function _M:delDataByPosition(position, Ad , call)  -- 删除礼包后 重新再次拉取数据
	
	if not  shoop_data  then return end 

	for index ,v in pairs(self.data ) do  --先删除一个位置的礼包
		if v.position == position then 
			table.remove(self.data, index)
		end 
	end

	for index ,v in pairs(self.data) do  --先删除一个位置的礼包
		local need_update = false 
		if v.isvalid then 
			for i = #v.data, 1, -1 do
				if shoop_data.id == v.data[i].id then 
					table.remove(v.data,i)
					need_update = true 
				end 
			end
		end 
		if need_update then 
			self:requestDataByPosition(v.position, function()
				if call then 
					call()
				end 
				self:ADSoldOutEvent()
			end) -- 更新每个有此礼包 位置 的信息 
		end 
	end

	gevent:call(global.gameEvent.EV_ON_UI_ADUPDATE)

end


function _M:delDataByPosition2(shoop_data) -- 

	self.delete_gift_id = shoop_data.id

	for index ,v in pairs(self.data) do  --先删除一个位置的礼包

		if v.isvalid then 

			for i = #v.data, 1, -1 do

				if shoop_data.id == v.data[i].id then 

					table.remove(v.data,i)

				end 
			end

			if #v.data <= 0 then 
				v.isvalid  = false 
			end 
		end 
	end

	self:ADSoldOutEvent()

	gevent:call(global.gameEvent.EV_ON_UI_ADUPDATE)
end

-- AD 售空通知事件
function _M:ADSoldOutEvent()
	if not  self:isHaveAvailableAD() then 
		gevent:call(global.gameEvent.EV_ON_UI_ADSOLDOUT)
	end
end 

function _M:updateUI()
	gevent:call(global.gameEvent.EV_ON_UI_ADUPDATE)
end 

function _M:getDefaultData()
	local temp ={} 
	local msg = {lAdID ={1,2,3},lEndTime = global.dataMgr:getServerTime()}
	temp.isvalid = true
	temp.data =  self:getChargeSlider(msg)
	return temp 
end 


function _M:getRandomAD()
	if not self.data  then return nil end  
	--dump(self.data)
	local valiad_ps = {}  --有 有效 广告位置
	for _ ,v in pairs(self.data) do 
		if v.isvalid then 
			local hava_other_gift =false --是否有出联盟礼包外其他礼包 
			if not global.chatData:isJoinUnion() then 
				for _ ,vv in pairs(v.data) do
					if vv.type ~= 	global.EasyDev.AD_UNION_TYPE then 								
						hava_other_gift = true 
					end 
				end 
			else
				hava_other_gift = true  -- 如果玩家已加入联盟 联盟礼包可以推送
			end
			if hava_other_gift then
				table.insert(valiad_ps , v.position)
			end 
		end 
	end
	if #valiad_ps <=0 then 
		return nil 
	end 
	--dump(valiad_ps,"valiad_ps")


	local tb = {}
	for _,v in ipairs(global.EasyDev.AD_PS) do
		tb[v] = true
	end

	local res = {}
	for _,v in ipairs(valiad_ps) do
		if tb[v] == true then
			table.insert(res,v)
		end
	end
	-- for _ ,v in ipairs(global.EasyDev.AD_PS) do   1 3 4 5 8
	-- 	local flag = false 
	-- 	for in ,vv in ipairs(valiad_ps) do    2 3
	-- 		if vv ==v  then 
	-- 			flag = true 
	-- 		end 
	-- 	end 
	-- end 
	local ad_data_ps = nil 
	local ad_ps = global.EasyDev:getRandomNumberInArr(res)

	-- 取出 随机选中的礼包
	local ad_daa_arr = nil 
	for _ , v in pairs(self.data) do 
		if v.position == ad_ps and v.isvalid then 
			ad_daa_arr = v.data
		end 
	end 

	if not ad_daa_arr then 
		return nil 
	end 

	local temp_ps = {} --存储礼包位置
	if not global.chatData:isJoinUnion() then 
		for index ,vv in pairs(ad_daa_arr) do
			if vv.type ~= 	global.EasyDev.AD_UNION_TYPE then 
				table.insert(temp_ps,index)						
			end 
		end 
	else
		for index ,vv in pairs(ad_daa_arr) do
			table.insert(temp_ps,index)						
		end 
	end

	--dump(temp_ps,"temp_ps")
	ad_data_ps = global.EasyDev:getRandomNumberInArr(temp_ps)

	if  not ad_daa_arr[ad_data_ps] then 
		return nil 
	end 

	print(ad_data_ps,"ad_data_ps")

	return ad_daa_arr[ad_data_ps]
end



function _M:requestDataByPosition(position ,call)
	
	global.rechargeApi:getAdvertList(position, function (msg,ret)
		 --如果 msg.lAdID 不存在 则说明礼包不存在
		-- 先清理以前数据
		for i = #self.data, 1, -1 do
		   if self.data[i].position  == position then 
				table.remove(self.data, i)
			end 
		end
		if msg and msg.lEndTime and msg.lAdID  then 
			local temp ={} 
			temp.data = self:getChargeSlider(msg,position)
			temp.position = position
			temp.isvalid = true 
			temp.lEndTime = msg.lEndTime
			table.insert(self.data , temp)
		else 
			local temp ={} 
			temp.position = position
			temp.isvalid = false
			temp.lEndTime = msg.lEndTime
			table.insert(self.data , temp)
		end 
		if call then 
			call()
		end 
	end)
end 

local id = {35} 

function _M:setHideTimer()

	for _ , v in pairs(self:getAllAD()) do 
		if v.isvalid then 
			if v .data then 
				for _ ,v in pairs(v.data ) do 
					if  global.EasyDev:CheckContrains(id , v.id) then 
						v.hidetimer  = true 
					end 				
				end 
			end 
		end 		
	end 
end 

function _M:requestDataByPosition1(position ,call)
	
	global.rechargeApi:getAdvertList(position, function (msg,ret)
		 --如果 msg.lAdID 不存在 则说明礼包不存在
		-- 先清理以前数据
	
		for _ ,v in pairs(msg.tagadvertList or {}) do --protect 

			for i = #self.data, 1, -1 do
			   if self.data[i].position  == v.ltype then 
					table.remove(self.data, i)
				end 
			end

			local temp ={} 

			if v.tagadvert then 
				temp.data = self:getChargeSlider({lEndTime=msg.lEndTime ,lAdID=v.tagadvert} , v.ltype)
				temp.isvalid = true 
			else
				temp.isvalid = false
			end 

			temp.lEndTime =  msg.lEndTime
			temp.position = v.ltype
			table.insert(self.data , temp)
			self.ad_overtime =  msg.lEndTime

			-- for key ,vv in ipairs(self.cloneData)  do 
			-- 	if v.ltype == vv.ltype then
			-- 		table.removeItem(self.cloneData , v)
			-- 		table.insert()
			-- 	end 
			-- end 
		end 

		self:setHideTimer()
		self:reMoveFirstRecharge()
		self:cleanUnLockData(msg.tagadvertList or {} )
		if call then 
			call()
		end 
		
	end)
end 

--  }
-- [LUA-print] -     2 = {
-- [LUA-print] -         "ltype"     = 2
-- [LUA-print] -         "tagadvert" = {
-- [LUA-print] -             1 = 56
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] -     3 = {
-- [LUA-print] -         "ltype"     = 3
-- [LUA-print] -         "tagadvert" = {
-- [LUA-print] -             1 = 8
-- [LUA-print] -             2 = 13
-- [LUA-print] -             3 = 15
-- [LUA-print] -             4 = 56
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] -     4 = {
-- [LUA-print] -         "ltype"     = 4
-- [LUA-print] -         "tagadvert" = {
-- [LUA-print] -             1 = 8
-- [LUA-print] -             2 = 13
-- [LUA-print] -             3 = 15
-- [LUA-print] -             4 = 56
-- [LUA-print] -         }

function _M:checkLock(id)  -- 找出所有条件礼包， 检测礼包条件是否成立 

	local ad_ps = {}

	local ADData = {} 

	for _ ,v in ipairs(global.luaCfg:gift()) do 

		if  table.hasval(AD_Type , v.type) and v.switch == 1 and v.target ~= 0 then 

			table.insert(ADData , v) 
		end 		
	end

	local serverData = {} 

	for _ ,v in ipairs(self.cloneData) do 

		for _ ,vv in ipairs(v.tagadvert or {} ) do 
			if not table.hasval(serverData , vv) then 

				table.insert(serverData , vv) 
			end 
		end 
	end

	for _ ,v in ipairs(ADData) do 

		if v.target ~= 0 then 
			-- dump(v ,"123123")
			if (not table.hasval(serverData ,v.id)) and global.funcGame:checkCondition(v.target) and global.luaCfg:get_target_condition_by(v.target).objectId ==id  then 
				-- dump( v.position ," v.position")
				table.insert(ad_ps , v.position)
			end 
		end 	
	end
	
	local request_ps = {} 


	for _ ,v in ipairs(ad_ps) do 
		for _ ,vv  in ipairs(v) do 
			if not table.hasval(request_ps ,vv) then 
				table.insert(request_ps , vv)
			end
		end 
 	end

 	if #request_ps > 0 then

 		-- dump(request_ps ,"AD request_ps ->>>>>>>>>")

 		self:requestDataByPosition1(request_ps, function () 
 			self:updateUI()
 		end)
 	end 
end

function _M:checkGiftTimeLock() --加一个 UserID 

	local key = "availableGiftID"..global.userData:getUserId()

	local str = cc.UserDefault:getInstance():getStringForKey(key)

	local ad_ps = {} -- 请求位置

	local available = {} -- 已解锁礼包ID

	local timegift = {} --倒计时开放礼包

	local cutID ={} --此次解锁的礼包id

	for _ ,v in ipairs(global.luaCfg:gift()) do 

		if  table.hasval(AD_Type , v.type) and v.switch == 1 and v.target ~= 0  and  global.luaCfg:get_target_condition_by(v.target).object =="time" then 

			table.insert(timegift , v) 
		end 		
	end

	if str and str~= "" then --已经解锁的 id

        local id_arr = global.tools:strSplit(str, '|')

       	for key ,v in ipairs(id_arr or {} ) do 

       		if  v~="" then 
       			table.insert(available , tonumber(v))
       		end 
       	end 
    end 

    if #available == #timegift then -- 所有礼包已经解锁
    	----////////////////////////////////////////////////////////
    	return 
    end 

    -- dump(timegift ,"timegift./.....陪标倒计时礼包")

    -- dump(available ,"available")

    for _ ,v in ipairs(timegift) do 

    	if not table.hasval(available , v.id) and global.funcGame:checkCondition(v.target) then 

    		table.insert(ad_ps ,  v.position)
    		table.insert(cutID , v.id)
    	end 
    end 

    -- dump(ad_ps ,"ad_ps///")
    -- dump(cutID ,"cutID////////")

	local request_ps = {} 

	for _ ,v in ipairs(ad_ps) do 
		for _ ,vv  in ipairs(v) do 
			if not table.hasval(request_ps ,vv) then 
				table.insert(request_ps , vv)
			end
		end 
 	end

 	if #request_ps > 0 then

 		local st = ""
 		for _ , v in ipairs(available) do 
 			if st =="" then 
 				st =v 
 			else 
 				st = st.."|"..v
 			end 
 		end

 		for _ ,v in ipairs(cutID)  do 
 			if st =="" then 
 				st =v 
 			else 
 				st = st.."|"..v
 			end 
 		end 

		cc.UserDefault:getInstance():setStringForKey(key , st)

		dump(request_ps ,"TimeGift请求的位置")

		self:requestDataByPosition1(request_ps, function () 
			self:updateUI()
		end)
	end

end 

function _M:getDataByPosition(position)

	local ad_data  = nil 

	for index ,v in pairs(self.data) do

		if v.position == position then 

			ad_data = v  

			break 
		end 
	end


	if ad_data then 

		return ad_data 
	end
	-- return self:getDefaultData()
end 


function _M:getAllAD() --得到所有AD  data 
	return self.data
end


function _M:getLastBuyGiftID() --最后一次购买礼包ID
	return self.delete_gift_id
end 


function _M:isHaveAvailableAD()
	for _ ,v in pairs(self.data) do 
		if v.isvalid then 
			return true 
		end 
	end 
	return false 
end 

function _M:setIsFirstOnEnter(state)
	 self.firstOnEnter = state
end

function _M:getIsFirstOnEnter()
	return self.firstOnEnter
end  
 

global.advertisementData = _M

--endregion

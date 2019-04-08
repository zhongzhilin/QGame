local luaCfg = global.luaCfg

local _M = {
    union = {},
    appRoveCount = 0,
    allyCdTime = 0,
}

function _M:init(msg)   

	msg = msg or {}
	--可用的加入的联盟列表
	self.union = {}--主联盟数据
	self.war = {}--联盟战争
	self.power = {}--联盟权限

	self:resetInUnion(msg)

    self:initWar()
    self:initPower()

    global.unionApi:updateHeroSpring(1) 

end

--初始化联盟权限数据------------------------->>>>
function _M:initPower()
	if not self:isMineUnion(0) then 
	    local function callback(msg)
	        local data = msg.tgAllyRight or {}
	        self:resetPower(data)
	        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_POWER)
	    end
	    global.unionApi:getAllyRight(callback,0)
	else
		self.power = {}
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_POWER)
	end
end

function _M:getPower()
	return self.power
end

function _M:getPowerBy(id)
	for i,v in ipairs(self.power) do
		if v.lID == id then
			return v
		end
	end
end

function _M:resetPower(data)
	table.assign(self.power,data)
end

function _M:isHadPower(id,rLv)
	if not id then return false end
	rLv = rLv or global.userData:getlAllyRole()
	local powers = self:getPowerBy(id)
	if not powers or not powers.lItem then return false end
	for i,v in ipairs(powers.lItem) do
		if v == rLv then
			return true
		end
	end
	return false
end
---------------------------------------------<<<<
--初始化联盟战争数据------------------------->>>>
function _M:initWar(reset)
	if reset or (self.war and #self.war <= 0) and not self:isMineUnion(0) then 
	    local function callback(msg)
	        self.war = msg.tgWarData or {}
			self:setInUnionRed(1,#self.war)
	        gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH)
	    end
	    global.unionApi:getAllyWarInfo(callback,0)
	else
		self:setInUnionRed(1,#self.war)
        gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH)
	end
end

function _M:getWar()
	return self.war
end

function _M:addWar(lMapID)
	if not lMapID then return end
    local function callback(msg)
    	--有可能战争将要结束了来了一个通知，协议返回之后战争已经结束直接return
    	if not msg.tgWarData or not msg.tgWarData[1] then return end

    	if not self.war then --protect
    		self.war = {} 
    	end 

		for i,v in ipairs(self.war) do
			if v.lMapID == lMapID then
				table.assign(self.war[i], msg.tgWarData[1])
				gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH)
				return
			end
		end
		table.insert(self.war,msg.tgWarData[1])
		self:setInUnionRed(1,#self.war)
		gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH)
    end
    global.unionApi:getAllyWarInfo(callback,lMapID)
end
function _M:removeWar(lMapID)
	if not lMapID or not self.war then return end
	for i,v in ipairs(self.war) do
		if v.lMapID == lMapID then
			table.remove(self.war, i)
			self:setInUnionRed(1,#self.war)
			gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH)
			return
		end
	end
end
---------------------------------------------<<<<
 
function _M:resetInUnion(msg)
	--自己已经加入的联盟信息

    self.inUnion = msg or {}
    self.inUnionMembers = {}
    self.inUnionBuilds = {}
    self.inUnion = self.inUnion or {}
    table.assign(self.inUnion,msg)
end

--获取成员等级
function _M:getInUnionMemlRole()
	return global.userData:getlAllyRole()
end

--获取联盟宣言
function _M:getInUnionSzInfo()
	if self.inUnion and self.inUnion.szInfo then
		return self.inUnion.szInfo
	else
		return ""
	end
end

--获取联盟公告
function _M:getInUnionSzNotice()
	if self.inUnion and self.inUnion.szNotice then
		return self.inUnion.szNotice
	else
		return ""
	end
end

--获取联盟语言id
function _M:getInUnionLanId()
	if self.inUnion and self.inUnion.lLanguage then
		return self.inUnion.lLanguage
	else
		return 1
	end
end
function _M:setInUnionLanId(id)
	self.inUnion.lLanguage = id
end

function _M:getInUnionLv()
	if self.inUnion and self.inUnion.lLevel then
		return self.inUnion.lLevel
	else
		return 0
	end
end

function _M:getInUnionName()
	if self.inUnion and self.inUnion.szName then
		return self.inUnion.szName
	else
		return ""
	end
end

function _M:getInUnionShortName()
	if self.inUnion and self.inUnion.szShortName then
		return self.inUnion.szShortName
	else
		return ""
	end
end

function _M:getInUnionRed(id)
	self.tagRedCount = self.tagRedCount or {}
	for i,v in ipairs(self.tagRedCount) do
		if v.lID == id then
			return v.lValue
		end
	end
	return nil
end

function _M:setInUnionRed(id,value)
	self.tagRedCount = self.tagRedCount or {}
	for i,v in ipairs(self.tagRedCount) do
		if v.lID == id then
			v.lValue = value
			gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)
			return
		end
	end
	table.insert(self.tagRedCount,{lID=id,lValue=value})
	gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)
end

function _M:getInUnion()
	return self.inUnion
end

function _M:setInUnion(msg)

	if not msg then return end 
	
	local preAllyId = global.userData:getlAllyID()
    global.userData:setlAllyID(msg.lID)
    table.assign(self.inUnion,msg)

	self:setInUnionRed(4,0)
	self:setInUnionRed(7,0)
    for _,v in ipairs(msg.tagRedCount or {}) do
    	if v.lID == 1 then
    		--联盟外交红点
    		self:setInUnionRed(4,v.lValue)
		elseif v.lID == 2 then
			--联盟任务可领取个数
    		self:setInUnionRed(7,v.lValue)
    	end
    end

    if not self:isMineUnion(preAllyId) then
    	--当前次id和之前不同时再次拉去联盟权限
    	self:initPower()
    end
    --更新大使馆进度条

	gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_BUILD_DOING)
end

function _M:setInUnionStrong(lStrong)
    self.inUnion.lStrong = lStrong
end
function _M:isEnoughInUnionStrong(lStrong)
	return (self:getInUnionStrong()>=lStrong)
end
function _M:getInUnionStrong()
	return self.inUnion.lStrong or 0
end

function _M:getInUnionMaxStrong()
	return self.inUnion.lMaxStrong or 0
end

function _M:setInUnionMembers(msg)
	if self.inUnionMembers and msg then
    	table.assign(self.inUnionMembers,msg)
    end
end

function _M:getInUnionMembers(msg)
	return self.inUnionMembers
end

--设置联盟建设建筑信息------------->>>>
function _M:setInUnionBuilds(msg)
    table.assign(self.inUnionBuilds,(msg or {}))
end
function _M:getInUnionBuilds()
	return self.inUnionBuilds
end

-- 联盟领地等级
function _M:getInUnionCityLv()

	self.inUnionBuilds = self.inUnionBuilds or {}
	for k,v in pairs(self.inUnionBuilds) do
		if v.lID == 25 then
			return v.lLevel
		end
	end
	return 1
end

--获取当前正在研究的建筑
function _M:getInUnionBuildDoing()
	for _,v in ipairs(self.inUnionBuilds) do
		if v.lState == 1 then
			return v
		end
	end
	return nil
end
function _M:getInUnionBuildsBy(id)
	for _,v in ipairs(self.inUnionBuilds) do
		if v.lID == id then
			return v
		end
	end
	return nil
end
--联盟大厅级别是否满足
function _M:isEnoughInUnionBuildsHallLv(lLevel)
	local centerBuilding = self:getInUnionBuildsBy(1)
	--防止异常点击导致的数据丢失
	if not centerBuilding or not centerBuilding.lLevel or not lLevel then 
		return false
	end
	return (centerBuilding.lLevel >= lLevel)
end
--联盟建筑级别是否足够
function _M:isEnoughInUnionBuildsLv(id,lLevel)
	local centerBuilding = self:getInUnionBuildsBy(id)
	--防止异常点击导致的数据丢失
	if not centerBuilding or not centerBuilding.lLevel or not lLevel then 
		return false
	end
	return (centerBuilding.lLevel >= lLevel)
end

function _M:isEnoughInUnionBuildsStudy(id)
    if not self:isHadPower(9) then
    	return false
    end
    if self:getInUnionBuildDoing() then
    	return false
    end
    local data = self:getInUnionBuildsBy(id) or {}
    local lv = data.lLevel or -1
    local buildData = luaCfg:get_union_build_by(id)
    if not buildData or lv>= buildData.Lvmax then
    	return false
    end
    local nextLvData = luaCfg:get_union_build_levle_by(id*1000+lv+1)
    if not nextLvData then
    	return false
    end
    if not self:isEnoughInUnionBuildsHallLv(nextLvData.hallLv) then
    	return false
    end
    if not self:isEnoughInUnionStrong(nextLvData.Boom) then
    	return false
    end
    return true
end
-------------------------------------<<<<

function _M:getUnion()
	for i,v in ipairs(self.union) do
		if self:isMineUnion(v.lID) then
			table.remove(self.union,i)
			break
		end
	end
	return self.union
end

--加载更多联盟信息
function _M:getMore(over,lPage,lLanguage,szKey,errorCall)
	local function callback(data)
		if lPage == 1 then
			self.union = data.tgAlly or {}
		else
			if data.tgAlly then
				table.assign(self.union,data.tgAlly)
			end
			-- table.insertTo(self.union,data.tgAlly)
		end

	    if szKey and #self.union <= 0 then
	    	--传入搜索key 并且没有查找到对应数据
        	global.tipsMgr:showWarning("UnionNon")
	        return
	    end
		if over then over(data) end
	end
	local function m_errorCall(ret)
		self.union = {}
        global.tipsMgr:showWarning("UnionNon")
		if errorCall then errorCall(ret) end
	end
	global.unionApi:getUnionList(callback,lPage,lLanguage,szKey,m_errorCall)
end

function _M:getUnionFlagData(lTotem)
    local flagData = global.luaCfg:get_union_flag_by(lTotem)
    if not flagData then
    	flagData = global.luaCfg:get_union_flag_by(1)
    end
    return flagData
end

function _M:getUnionShortName(name)
	if name and name ~= "" and name ~= "-" then
		local n = string.format("【%s】",name)
		return n
	else
		n = "-"
		return n
	end
end

function _M:getUnionLanguage(lLanguage)
	local lanId = (lLanguage == 0) and 1 or lLanguage
	local lan = global.luaCfg:get_union_languages_by(lanId)
	return lan.name
end

function _M:getUnionLeaderData(leaderId)
	self.inUnionMembers=self.inUnionMembers or {}
	for i,v in pairs(self.inUnionMembers) do
		if v.lID == leaderId then
			return v
		end
	end
	return nil
end

--是否是盟主
function _M:isLeader(otherUnion,userId)
	local userId = userId or global.userData:getUserId()
	local union = otherUnion or self:getInUnion()
	return (union.lLeader == userId)
end

function _M:isMineUnion(unionId)
	return global.userData:getlAllyID() == unionId
end

--根据成员等级获取对应的管理权限
function _M:getMgrBtns(power)
    local data = global.luaCfg:union_btn()
    local rt = {}
    for id,v in ipairs(data) do
    	if v.power < 0 then
    		v.isPower = true
    	else
			v.isPower = self:isHadPower(v.power,power)
    	end
    	if v.id ~= 11 then  -- 国服屏蔽语音
			table.insert(rt,v)
		end
    end
    table.sort( rt, function(a,b)
        -- body
        return a.array < b.array
    end )
    return rt
end

--获取新申请成员数量
function _M:getUnionNewApplyNum(tgMember)
	local count = 0
    for ii,member in ipairs(tgMember) do
        if member.lRole == 0 then
        	count = count + 1
        end
    end
    return count
end

-- 获取成员阶级
function _M:getUnionClass(classLv)
	if not classLv then return nil end
	-- body
	local lv = 0
    local temp = global.luaCfg:union_class_btn()
    for _,v in pairs(temp) do
        if classLv == v.id then 
            lv = v.level
        end
    end
    return global.luaCfg:get_union_class_btn_by(lv) or nil
end

-- 个人外交审批红点数
function _M:setApproveCount(count)
	-- body
	self.appRoveCount = count
end

function _M:getApproveCount(count)
	-- body
	return self.appRoveCount 
end

function _M:refershApproveCount()
	-- body
	global.unionApi:getUserRelationShip(function (msg) 
		msg.tagApplyList = msg.tagApplyList or {}
        self:setApproveCount(table.nums(msg.tagApplyList))
        gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
    end, 2)
end

-- 是否处在退出联盟cd中
function _M:setAllyCdTime(ltime)
	self.allyCdTime = ltime
end

function _M:getAllyCdTime()
	return self.allyCdTime
end


function _M:setNumberBuildState(state)

	self.numberBuildState = state
end 

function _M:getNumberBuildState()

	return self.numberBuildState  
end 


function _M:setHeroExpData(data)

	self.heroExpData = data 
end 

function _M:getMySpingData()

	local data = self:getMyAllSpingData()

	table.sort(data , function (A ,B)  return A.lAddTime > B.lAddTime end)

	return data[1]
end 

function _M:getMyAllSpingData()

	local data = {} 

	for _ ,v in ipairs( self:getAllSpringData() ) do 

		if v.lOwnID == global.userData:getUserId() and v.tagHelps then 

			table.insert(data , v )
		end 
	end 

	return data 
end 


function _M:getMyMainExpHero()

	if self:getMySpingData() then 
		return self:getSpingSitHero(self:getMySpingData() , 0)
	end 
end 


function _M:getMylessExpHero()

	if self:getMySpingData() then 

		return self:getSpingSitHero(self:getMySpingData() , 1)
	end 
end 


function _M:getSpingSitHero(msg  , sit)

	if not msg  or not sit then return end 

	local getSitHero = function (data , sit)
		for _ ,v in ipairs(data.tagHelps or {} ) do 
		    if v.lSit == sit then 
		        return v  
		    end 
		end 
	end 

	return getSitHero(msg  , sit)
end 


function _M:getMyInOtherHeroData()

	if self:getMyInOtherSpringData() then 
		for _ , vv in ipairs(self:getMyInOtherSpringData().tagHelps or {} ) do 
			if vv.lUserID == global.userData:getUserId() then 
				return vv   
			end 
		end 						
	end 
end 


function _M:getMyInOtherSpringData()

	for _ ,v in ipairs( self:getAllSpringData() ) do 

		if v.lOwnID ~= global.userData:getUserId() and v.tagHelps then 
				
			for _ , vv in ipairs(v.tagHelps or {} ) do 

				if vv.lUserID == global.userData:getUserId() then 

					return v   
				end 
			end 						
		end 
	end 
end 

function _M:getMySpringHero() -- 得到所有在泉水里面的英雄ID

	local id = {} 

	if self:getMyInOtherHeroData() then 
		table.insert(id , self:getMyInOtherHeroData().lHeroID)
	end 

	if self:getMyMainExpHero() then 
		table.insert(id , self:getMyMainExpHero().lHeroID)
	end 

	return id
end

-- noself 不包含自己 (联盟列表)
function _M:getActivitySpring(noself)

	local data = {}

    for _ ,v in ipairs(self:getAllSpringData() or {} ) do 

    	if v.lEndTime > global.dataMgr:getServerTime() and v.lAllyID  and self:getSpingSitHero( v, 0) then 
    		if noself  then 
    			if v.lOwnID ~= global.userData:getUserId() then 
		    		table.insert(data , v)
		    	end 
    		else 
		    	table.insert(data , v)
    		end 
    	end 
    end 

    
    table.sort(data , function (A , B) return A.lAddTime > B.lAddTime end )

    return data 
end 


function _M:getCanJoinSpring() -- 得到可加入的泉水

	local data = {} 

	for _ , v in pairs(self:getActivitySpring(true) or {} ) do 

		if not self:getSpingSitHero(v, 1) then 

			table.insert(data , v)
		end 

	end 
	return data 
end 

function _M:getAllSpringData() -- 得到所有泉水信息

	local filterData = {} 

	if self.heroExpData and  self.heroExpData.tagSpring then 

		for _ ,v in ipairs(self.heroExpData.tagSpring) do 

			if v.tagHelps then 

				table.insert(filterData ,v)
			end 
		end 
	end 
	return filterData
end 


function _M:addSpring(spring) -- 得到所有泉水信息

	if not spring or not self.heroExpData or not self.heroExpData.tagSpring then return end 

	local s  = clone(spring)

	local flg = false 

	local chooseSpring = nil 

	for _ ,v in pairs(self.heroExpData.tagSpring) do 
		if v.lID  == spring.lID then 
			flg = true 
			chooseSpring = v 
		end 
	end 

	if not flg then 

		table.insert(self.heroExpData.tagSpring , s)

		dump(self.heroExpData.tagSpring ,"添加泉水"..s.lID)
	else 

		if not chooseSpring then return end 

		chooseSpring.tagHelps = chooseSpring.tagHelps or {} 

		print("添加英雄")

		table.insert(chooseSpring.tagHelps, s.tagHelps[1])

		dump(chooseSpring.tagHelps ,"/////")

	end 
end 

function _M:delSpringHero(springID , heroId) -- 得到所有泉水信息

	if not springID or not heroId then return end 

	print(springID ,heroId ,"->>>")

	self.heroExpData = self.heroExpData or {} 

	for key , v in pairs(self.heroExpData.tagSpring or {} ) do 

		if v.lID  == springID  then 

			dump(v ,"v ->>>>>>>>Data before delete")

			for key ,vv in ipairs(v.tagHelps or {} ) do 

			    if vv.lHeroID == heroId then 

			    	table.remove(v.tagHelps , key)

			    	dump(v.tagHelps ,"removed Data ")

			    	break

			    end 
			end 
		end 
	end 
end 


function _M:canReceiveHeroExp()

	local flg  = false 

	local mainHero = self:getMyMainExpHero()
	local myspring = self:getMySpingData()

	local my_other_hero_data = self:getMyInOtherHeroData()
	local my_other_hero_spring = self:getMyInOtherSpringData()

	if mainHero then 
		 flg =  myspring.lEndTime < global.dataMgr:getServerTime()               
	end 

	if not flg and my_other_hero_data then 
		flg = my_other_hero_spring.lEndTime < global.dataMgr:getServerTime()
	end 

	return flg
end 

function _M:getMySpringHeroOVerTime() --得到洗澡中 最短 倒计时

	local mainHero = self:getMyMainExpHero()
	local myspring = self:getMySpingData()

	local my_other_hero_data = self:getMyInOtherHeroData()
	local my_other_hero_spring = self:getMyInOtherSpringData()

	local time = nil

	if mainHero then 
		if  myspring.lEndTime >  global.dataMgr:getServerTime()  then 
			time =  myspring.lEndTime - global.dataMgr:getServerTime()
		end      
	end 

	if my_other_hero_data then 
		if  my_other_hero_spring.lEndTime >  global.dataMgr:getServerTime()  then 
			if not time then 
				time =  my_other_hero_spring.lEndTime - global.dataMgr:getServerTime()
			else 
				time = math.min(time , my_other_hero_spring.lEndTime - global.dataMgr:getServerTime())
			end  
		end    
	end

	return time
end 

function _M:checkSpringRedPoint() -- 经验之泉 红点

	local redPoint = (#self:getCanJoinSpring())
	local localred = global.unionData:getInUnionRed(11) or 0 


	-- print(redPoint ,"redPoint")

	local my_other_hero_data = self:getMyInOtherHeroData()

	-- dump(my_other_hero_data ,"my_other_hero_data///")
	if my_other_hero_data then -- 如果有已经协助别人 不显示小红点
		redPoint = 0 
	end 
	-- print(redPoint ,"redPoint")

	if self.heroExpData and  redPoint ~= localred then 

		global.unionData:setInUnionRed(11,  redPoint)

       	global.userData:updatelAllyRedCount({lID=13 , lValue = redPoint})
	end 
end



-- 发送联盟试炼内容至聊天
-- parm: 道具id
function _M:sendSpringToChat(parm)
	-- body
	local tagSpl = {}
    tagSpl.lKey = 9
    tagSpl.lValue  = parm 
    tagSpl.szParam = ""
    tagSpl.szInfo = "" 
    tagSpl.lTime  = global.dataMgr:getServerTime()

	global.chatApi:senderMsg(function(msg)
    	-- send success 
    	global.chatData:addChat(3, msg.tagMsg or {})
        global.chatData:setCurLType(3)
        global.chatData:setCurChatPage(3)
    end, 3, "union_spring", global.userData:getUserId(), 0, tagSpl)

end

-- 联盟战争发生地
function _M:getUnionWarTarget(lType, target)
	-- body
	local cityStr = target
	local id = tonumber(target) 

	if lType == 0 or lType == 9  then  --小村庄
		local sData = luaCfg:get_world_type_by(id) or {}
        cityStr = sData.name or "-"
	elseif lType == 2 or lType == 12 then  -- 野地
		local resData = luaCfg:get_wild_res_by(id) or {}
        cityStr = resData.name or "-"
    elseif lType == 5 then  -- 野怪
    	local monsterData = luaCfg:get_wild_monster_by(id)
        if not monsterData then
            monsterData = luaCfg:get_wild_monster_by(id-math.floor(id%10)+1) or luaCfg:get_wild_monster_by(id-math.floor(id%10)+2)
        end
        monsterData = monsterData or {}
        cityStr = monsterData.name or "-"
    elseif lType == 6 or lType == 14 then  -- 奇迹点
        local  sData = luaCfg:get_all_miracle_name_by(id) or {}
        cityStr = sData.name or "-"
    end  

	return cityStr
end

global.unionData = _M
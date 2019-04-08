local luaCfg = global.luaCfg

local _M = {
	godAnimal = {},
	godSkill  = {},
}

function _M:init(tagGodAnimal)   

	if table.nums(self.godAnimal) > 0 then return end
	dump(tagGodAnimal, " ==> tagGodAnimal: ")
	local addServerData = function (lType)
		for i,v in ipairs(tagGodAnimal or {}) do
			if v.lType == lType then
				return v
			end
		end
	end

	self.godAnimal = clone(luaCfg:pet_type())
	for i,v in ipairs(self.godAnimal) do
		v.serverData = addServerData(v.type)
		v.skill = self:getSkillConfig(v)
	end
end

-- 获取技能配置信息
function _M:getSkillConfig(pet)
	-- body
	local temp = {}
	for i=1,2 do
		for i,v in ipairs(pet["skill_type"..i]) do
			local t = {}
			t.config = self:getGodSkillConfigByLv(v, 1)
		 	table.insert(temp, t)
		end
	end
	return temp
end

function _M:getGodAnimal()
	return self.godAnimal
end

function _M:getGodAnimalByType(lType)

	for i,v in ipairs(self.godAnimal) do
		if v.type == lType then
			return v
		end
	end 
end

function _M:getGodAnimalLv(lType)

	for i,v in ipairs(self.godAnimal) do
		if v.type == lType and v.serverData and v.serverData.lGrade then
			return v.serverData.lGrade
		end
	end 
	return 0
end



-- 是否达到满级
function _M:isGodAnimalMaxLv(lType)
	for i,v in ipairs(self.godAnimal) do
		if v.type == lType and v.serverData and v.serverData.lGrade >= v.maxLv then
			return true
		end
	end 
	return false
end

-- 获取当前出战中的神兽
function _M:getGodAnimalByFighting()

	for i,v in ipairs(self.godAnimal) do

		local isFighting = v.serverData and v.serverData.lState == 1 
		local isFy = v.serverData and (v.serverData.lState == 2 or v.serverData.lState == 3)
		if v.serverData and (isFighting or isFy) then 
			return v
		end
	end 
end

-- 获取当前没有处在cd 中神兽
function _M:getNoCdPet()

	local petType = 0
	local checkCd = function (lState)
		
		-- body
		for i,v in ipairs(self.godAnimal) do
			if v.serverData and v.serverData.lState == lState then 
					
				local cdTemp = v.serverData.lMeetTimes
				for i=1,3 do
					if cdTemp[i] and  cdTemp[i] > global.dataMgr:getServerTime() then
					else
						return v.type
					end
				end
			end
		end
		return 0
	end

	petType = checkCd(1)
	if petType == 0 then
		petType = checkCd(0)
	end
	return petType
end

-- 获取当前处于cd中的神兽最小cd
function _M:getPetCd()

	local checkCd = function (lState)
		-- body
		for i,v in ipairs(self.godAnimal) do
			if v.serverData and v.serverData.lState == lState then 
					
				local cdTemp = clone(v.serverData.lMeetTimes)
				cdTemp[4] = -1
				table.sort(cdTemp, function(s1, s2) 
					if s1 >= 0 and s2 >= 0 then
						return s1 < s2 
					else
						return false
					end
				end)
				for i=1,3 do
					if cdTemp[i] and  cdTemp[i] > global.dataMgr:getServerTime() then
						return cdTemp[i], v.type
					end
				end
			end
		end
		return 0, 0
	end

	local cdTime, petType = checkCd(1)
	if cdTime == 0 then
		cdTime, petType = checkCd(0)
	end
	return cdTime, petType
end

function _M:updateGodAnimal(data)

	data.lType = data.lType or 0
	for i,v in ipairs(self.godAnimal) do
		if v.type == data.lType then
			v.serverData = data
			return
		end
	end 
end

function _M:updateGodAnimalImpress(lType, curImpress)

	for i,v in ipairs(self.godAnimal) do
		if v.type == lType then
			v.serverData.lImpress = curImpress
			return
		end
	end 
end

-- 更新神兽出战状态
function _M:resetGodAnimalState()

	for i,v in ipairs(self.godAnimal) do
		if v.serverData and v.serverData.lState == 1 then
			v.serverData.lState = 0
			return
		end
	end 
end

-- 根据神兽等级
function _M:getPetConfig(lType, lv)
	-- body
	for i,v in pairs(luaCfg:pet()) do
		if v.type == lType and v.lv == lv then
			return v
		end
	end
end

function _M:getPetSkillPoint(lType, lvPre, lvCur)
	-- body
	local point = 0
	for i,v in pairs(luaCfg:pet()) do
		if v.type == lType and v.lv > lvPre and v.lv <= lvCur then
			point = point + v.skillPoint
		end
	end
	return point
end

-- 获取当前神兽成长期最低等级
function _M:getPetConfigByGrow(lType, growingPhase)
	-- body
	local temp = {}
	for k,v in pairs(luaCfg:pet()) do
		if v.type == lType and v.growingPhase == growingPhase then
			table.insert(temp, v)
		end 
	end
	table.sort(temp, function(s1, s2) return s1.lv < s2.lv end)
	return temp[1]
end

function _M:getPetGrowMax()

	local maxGrowingPhase = luaCfg:get_pet_activation_by(1).maxGrowingPhase
	return maxGrowingPhase
end

-- 激活神兽个数
function _M:getPetActNum()
	-- body
	local num = 0
	for i,v in ipairs(self.godAnimal) do
		if v.serverData and (v.serverData.lState == 0 or v.serverData.lState == 1) then
			num = num + 1
		end
	end
	return num
end

function _M:setGodSkillByType(lType, skillServer)
	-- body
	local getSkillServer = function (lType)
		for i,v in ipairs(skillServer or {}) do
			if v.lType == lType then
				return v
			end
		end
		return nil
	end

	for i,v in ipairs(self.godAnimal) do
		if v.type == lType then
			for k,vv in pairs(v.skill or {}) do

				if not skillServer then
					v.skill[k].config = self:getGodSkillConfigByLv(vv.config.type, 1) 
				end
				v.skill[k].serverData = nil
				local curServerData = getSkillServer(vv.config.type)
				if curServerData then
					v.skill[k].serverData = getSkillServer(vv.config.type)
					v.skill[k].config = self:getGodSkillConfigByLv(vv.config.type, curServerData.lGrade) 
				end
			end
			return
		end
	end
end

-- lType: 1飞龙 2巨鹰 3独角兽
function _M:getGodSkillByType(lType)
	-- body
	for i,v in ipairs(self.godAnimal) do
		if v.type == lType then
			return v.skill 
		end
	end
end

-- triggerType: 1 主动技能 2 被动技能
function _M:getGodSkillByTriType(lType, triggerType)
	-- body
	local temp = {}
	local pet = luaCfg:get_pet_type_by(lType)
	for i,v in ipairs(pet["skill_type"..triggerType]) do
		if self:getGodSkillByKind(lType, v) then
			table.insert(temp, self:getGodSkillByKind(lType, v))
		end
	end
	return temp
end

-- lkind: 通过技能类型获取当前神兽技能 
-- curSkill = {
--	   1 = {
--         "lGrade" = 1
--         "lID"    = 2201
--         "lState" = 2
--         "lType"  = 22
--         "lkind"  = 2
--     }
--     2 = {
--         "lGrade" = 1
--         "lID"    = 2301
--         "lState" = 2
--         "lType"  = 23
--         "lkind"  = 2
---     }
-- }

function _M:getPetStarClassByLv(lv)
	-- body
	local num = 0
	local curClass = math.ceil(lv/10) 
    for i=1,10 do
        if i==curClass then
            num = lv-10*(i-1)
        end
    end
    return curClass, num
end

function _M:getGodSkillByKind(lType, lkind)
	-- body
	local curSkill = self:getGodSkillByType(lType)
	for i,v in ipairs(curSkill) do
		if v.config and v.config.type == lkind then
			return v
		end
	end
end

-- 通过技能类型和等级获取配置信息
function _M:getGodSkillConfigByLv(lkind, lv)
	-- body
	for k,v in pairs(luaCfg:pet_skill()) do
		if v.type == lkind and v.lv == lv then
			return v
		end
	end
end

-- 更新神兽当前M某个技能
function _M:updateGodSkill(lType, msg)
	-- body
	if not msg or not msg.lType then return end
	for i,v in ipairs(self.godAnimal) do
		if v.type == lType then
		
			for k,vv in ipairs(v.skill or {}) do
				if vv.config.type == msg.lType then
					v.skill[k].config = self:getGodSkillConfigByLv(msg.lType, msg.lGrade) -- vv = msg (直接赋值是不成功的)
					v.skill[k].serverData =  msg
				end
			end
		end
	end
end


-- 刷新主被动技能
function _M:refershActiveSkill()
	-- body
	local curFightPet = self:getGodAnimalByFighting()
	if curFightPet then
	    global.petApi:getSkill(function (msg)
	        if not msg then return end
	        if not msg.tagGodAnimalSkill then return end
	        self:setGodSkillByType(curFightPet.type, msg.tagGodAnimalSkill)
	    end, curFightPet.type, 0)
	end
end

-- 当前主动技能是否可以使用 lType:pet_skill  buff(免费迁城 7001)
function _M:isCanUsePetSkill(buff)
	-- body
	local curFightPet = self:getGodAnimalByFighting()
	if curFightPet then
		local curSkill = self:getGodSkillByBuff(curFightPet.type, buff)
		if  curSkill and curSkill.serverData and curSkill.serverData.lState == 2  then -- 是否解锁
			-- 是否处于冷却时间
			local lCdTime = curSkill.serverData.lCdTime or 0
	    	if lCdTime < global.dataMgr:getServerTime() then
	    		return true
	    	end
		end
	end
	return false
end

function _M:getGodSkillByBuff(lType, buff)
	-- body
	local curSkill = self:getGodSkillByType(lType)
	for i,v in ipairs(curSkill) do
		if v.config and v.config.buff == buff then
			return v
		end
	end
end

-- 润稿处理
function _M:getPetPropertyClient(propertyValueClient)
	-- body
	if type(propertyValueClient) ~= 'table' then return {} end
	local skill = {}
	for i,v in ipairs(propertyValueClient) do
		local property = {}
		local propTextCon = global.luaCfg:get_pet_property_by(v[1]) or {}
		table.insert(property, propTextCon.property or "")
		table.insert(property, v[2] or 0)
		table.insert(skill, property)
	end
	return skill

    -- if type(propertyValueClient) == 'string' then
    -- 	print(" ---> propertyValueClient: "..propertyValueClient)
    --     local temp_f = loadstring("g_temp = ".. propertyValueClient)
    --     temp_f()
    --     skill = g_temp
    -- else
    --     skill = propertyValueClient
    -- end
end

-- 神兽好感cd检测
function _M:checkPetCd()
	-- body
	local curFightPet = global.petData:getGodAnimalByFighting()
    if curFightPet and curFightPet.serverData and curFightPet.serverData.lState == 1 then
    	if global.petData:isGodAnimalMaxLv(curFightPet.type) then return end  -- 满级不显示
        local cdTemp = curFightPet.serverData.lMeetTimes
        for i=1,3 do
            if cdTemp[i] and  cdTemp[i] > global.dataMgr:getServerTime() then
            else
                gevent:call(global.gameEvent.EV_ON_PET_CD)
                return
            end
        end
    end
end

global.petData = _M
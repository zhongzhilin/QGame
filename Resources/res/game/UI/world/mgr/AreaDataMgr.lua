
-- local resMgr = global.resMgr
-- local uiMgr = global.uiMgr

local g_worldview = global.g_worldview

local AreaDataMgr = class("AreaDataMgr")

local AREA_WIDTH = 1280
local AREA_HEIGHT = 1280
local gdisplay = gdisplay
local uiMgr = global.uiMgr
local g_worldview = nil
local userData = global.userData
local resMgr = global.resMgr
local WCONST = WCONST

function AreaDataMgr:ctor(view)

	self.areaDataCache = {}
	setmetatable(self.areaDataCache, {

		__index = function(table,key)

			self.areaDataCache[key] = {}
			return self.areaDataCache[key]		
		end
	})

	g_worldview = global.g_worldview

	self.preLoadTime = 0

	self:initData()
end

function AreaDataMgr:initData()
	
	local WorldCityMgr = require("game.UI.world.mgr.WorldCityMgr")

    local width = WorldCityMgr.CONFIG.TMX_WIDTH

    local mapH = 3

    local mapCache = {}
end

-- 检测是否是非第五大陆之外的大陆
function AreaDataMgr:checkIsOtherLand(i,j)
	
	if global.userData:isOpenFullMap() then return false end

	local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())

	local areaId = self:checkArea(i,j)  

	if areaId == nil then return nil end

	if self.curLandId and areaId ~= self.curLandId and not ((self.curLandId + areaId - 5)  == mainCityLandId) and self.curLandId ~= nil then
		return true
	end

	return false
end

-- isBySkip 标记是否是通过setOffset调用的 因为只有setOffset才能切换大陆
function AreaDataMgr:setContentIAndJ(i,j,isBySkip)
	
    -- local map_width = g_worldview.const.INFO.MAP_WIDTH    

    local luaCfg = global.luaCfg
    local const = global.g_worldview.const

    local tmpAreaId = self.areaId
    local tmpResLevel = self.resLevel

	self.areaId = self:checkArea(i,j) or self.areaId
	self.resLevel = const:converMapIndex2ResLevel(i,j)

	if not isBySkip then
		if self.areaId ~= self.curLandId and self.curLandId ~= nil then
			return
		end
	else		

		-- 如果没有开放全部大陆
		if not global.userData:isOpenFullMap() then 
			
			-- 如果是跳转大陆并且不是从王者大陆或者跳到王者大陆的情况下
			local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())
			if self.areaId ~= self.curLandId and self.curLandId ~= nil and not ((self.curLandId + self.areaId - 5)  == mainCityLandId) then
				print('-- return this regore --')
				return
			end
		end		
	end	

	local resName = luaCfg:get_map_unlock_by(self.resLevel).name
	local landName = "" 
	if global.luaCfg:get_map_region_by(self.areaId) then 
		landName = global.luaCfg:get_map_region_by(self.areaId).name
	end

	if self.areaId == 5 then
		if tmpAreaId ~= self.areaId then

			if tmpAreaId ~= nil then
			
				global.tipsMgr:showWarning('MainlandEnter',landName)
			end
				
			g_worldview.worldPanel.miniMap:setName(landName)
		end
	else
		if tmpAreaId ~= self.areaId then

			if tmpAreaId ~= nil then
			
				global.tipsMgr:showWarning('MainlandEnter',landName .. '\n(' .. resName .. ')')
			end
				
			g_worldview.worldPanel.miniMap:setName(landName .. '\n(' .. resName .. ')')
		elseif not global.g_worldview.isStory then

			if tmpResLevel ~= self.resLevel then

				if tmpResLevel ~= nil then

					global.tipsMgr:showWarning('MainlandEnter',landName .. '\n(' .. resName .. ')')
				end

				g_worldview.worldPanel.miniMap:setName(landName .. '\n(' .. resName .. ')')
			end
		end			
	end	
	-- print("set content area id",self.areaId)

	if isBySkip then

		self.curLandId = self.areaId
	end
end

function AreaDataMgr:getContentAreaId()
	
	return self.curLandId
end

function AreaDataMgr:checkArea(i,j)

	return global.g_worldview.const:convertMapIndex2LandId(i, j)
end

function AreaDataMgr:getCurPlaceAreaID(x,y)

	local width = gdisplay.width
	local height = gdisplay.height

	local rect = cc.rect(x,y,gdisplay.width,gdisplay.height)

	local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH

	local resList = {}

	local insertTable = function(pos)
		
		local i = pos.x
		local j = pos.y

		if i < 0 or i >= map_width or j < 0 or j >= map_width then

			-- print(i,j,"超出了屏幕")
			return
		else

			local areaId = self:checkArea(i,j)
			if self:getContentAreaId() == areaId then
				table.insert(resList,{x = i,y = j})	
			end			
		end
	end

	local floatI = (x + y) / (2048) + map_width / 2
	local floatJ = (x - y) / (2048) + map_width / 2

	local floorI = math.floor(floatI - 0.5)
	local floorJ = math.floor(floatJ - 0.5)
	local ceilI = math.ceil(floatI - 0.5)
	local ceilJ = math.ceil(floatJ - 0.5)

	self.contentIndex = cc.p(math.floor(floatI),math.floor(floatJ))	

	if global.g_worldview.worldPanel:getIsLineMap() then
	
		local i = floorI
		local j = floorJ

		insertTable({x = i,y = j})
		insertTable({x = i - 1,y = j})
		insertTable({x = i,y = j + 1}) 
		insertTable({x = i + 1,y = j})
		insertTable({x = i,y = j - 1})
		insertTable({x = i - 1,y = j - 1})
		insertTable({x = i + 1,y = j + 1})
		insertTable({x = i + 1,y = j - 1})
		insertTable({x = i - 1,y = j + 1})	
	else
		insertTable({x = floorI,y = floorJ})
		insertTable({x = floorI,y = ceilJ})
		insertTable({x = ceilI,y = floorJ})
		insertTable({x = ceilI,y = ceilJ})
	end	
	-- insertTable({x = i - 1,y = j})
	-- insertTable({x = i,y = j + 1}) 
	-- insertTable({x = i + 1,y = j})
	-- insertTable({x = i,y = j - 1})
	-- insertTable({x = i - 1,y = j - 1})
	-- insertTable({x = i + 1,y = j + 1})
	-- insertTable({x = i + 1,y = j - 1})
	-- insertTable({x = i - 1,y = j + 1})

	if #resList == 0 then return resList end

	self.preResList = clone(resList)

	return resList
end

function AreaDataMgr:wildResNotify(data)

	local panel = g_worldview.mapPanel
	local mapInfo = global.g_worldview.mapInfo
	local lReses = data
	for _,v in ipairs(lReses) do
		local wildResCity = nil
		if panel.getWildResById then
			wildResCity = panel:getWildResById(v.lResID)
		end
		if v.lReason == 0 then

			if wildResCity then
				wildResCity:refresh(v)
			else
				local blockId = mapInfo:getBlockIdByUniqueId(v.lResID)
				local areaX,areaY = self:decodeAreaID(blockId)

				if self:isIndexInScreen(areaX,areaY) then
					
					local index = cc.p(areaX,areaY)
					--新增v
					if panel.addWildRes then
						panel:addWildRes(index,v)
					end
				end				
			end
		else
			if wildResCity then 
				local blockId = mapInfo:getBlockIdByUniqueId(v.lResID)
				local areaX,areaY = self:decodeAreaID(blockId)
				local index = cc.p(areaX,areaY)
				panel:removeWildRes(index,wildResCity)
			end
		end
	end
end

function AreaDataMgr:wildObjNotify(data, call)
	local panel = g_worldview.mapPanel
	if tolua.isnull(panel) then return end
	local mapInfo = global.g_worldview.mapInfo
	local lMonsters = data
	for _,v in ipairs(lMonsters) do
		local wildObjCity = nil
		if panel.getWildObjById then
			wildObjCity = panel:getWildObjById(v.lMonsterID)
		end
		if v.lReason == 0 then
			if wildObjCity then
				wildObjCity:refresh(v)
			else
				local blockId = mapInfo:getBlockIdByUniqueId(v.lMonsterID)
				local areaX,areaY = self:decodeAreaID(blockId)
				local index = cc.p(areaX,areaY)
				--新增v
				
				-- dump(v,">>guaiwuluoji")
				local monData = global.luaCfg:get_wild_monster_by(v.lKind) or {}
				if monData.effect and monData.effect == 1  then
				 
					global.troopData:setNewMonsterId(v.lMonsterID)
				end 

				panel:addWildObj(index,v)
			end
		else
			if wildObjCity then 
				local blockId = mapInfo:getBlockIdByUniqueId(v.lMonsterID)
				local areaX,areaY = self:decodeAreaID(blockId)
				local index = cc.p(areaX,areaY)
				panel:removeWildObj(index,wildObjCity)
			end
			if call then call(v) end
		end
	end
end

function AreaDataMgr:cleanArea(index)
	
	-- dump(self.areaDataCache[index.x][index.y])
	self.areaDataCache[index.x][index.y] = nil
end

function AreaDataMgr:getCurrentIndex()
	
	return self.contentIndex
end	

function AreaDataMgr:getAreaIdByPos(x,y)

	return cc.p(math.floor(x / AREA_WIDTH),math.floor(y / AREA_HEIGHT))
end

function AreaDataMgr:isIndexInScreen(i,j)
	
	for _,v in ipairs(self.preResList or {}) do
		
		if v.x == i and v.y == j then

			return true
		end
	end

	dump(self.preResList,"is index in screen")

	return false
end

function AreaDataMgr:flushCurrentScreen(preCall,isClean,isCallByGuide,callback)
	if tolua.isnull(g_worldview.mapPanel) then return end
    if global.guideMgr:isPlaying() and not isCallByGuide then return end
	g_worldview.mapPanel.isStartAddChild = false

	self:getMsg(clone(self.preResList),true,callback,function()
		
		if isClean then
			g_worldview.mapPanel:preFlush()
		end		
		if preCall then preCall() end
	end)
end

function AreaDataMgr:flushMap(x,y,call)	-- true mean need flush

	local resList = self:getCurPlaceAreaID(x, y)

	if tolua.isnull(g_worldview.mapPanel) then return end

	local worldPanel = g_worldview.worldPanel

	g_worldview.mapPanel:loadBuildWithAreaIndex(resList)

	-- self.prePos = self.prePos or cc.p(x,y)
	-- local len = cc.pGetLength(cc.pSub(self.prePos,cc.p(x,y)))
	-- self.prePos = cc.p(x,y)

	for i,v in ipairs(resList) do

		local res = self.areaDataCache[v.x][v.y]

		local isNeedCatch = false
		if type(res) == "boolean" and self.isGetMsg == false then

			isNeedCatch = true
		end

		if res ~= nil and isNeedCatch == false then
			
			-- print("这一个块已经拉取过了",v.x,v.y)
			resList[i] = nil 	--这个index已经拉去过了，不需要在拉
		else
			-- print("开始拉取",v.x,v.y)
			self.areaDataCache[v.x][v.y] = true
		end
	end

	local _resList = {}

	for _,v in pairs(resList) do

		table.insert(_resList,v)
	end

	if #_resList ~= 0 then

		-- self:getMsg(_resList,false,call)
		self:closeSchedule()		

		local cutTime = global.dataMgr:getServerTime() - self.preLoadTime

		if worldPanel:isInGPS() or cutTime > 2 then

			self.preLoadTime = global.dataMgr:getServerTime()
			self:getMsg(_resList,false,call)
		else
				
			self.scheduleListenerId = gscheduler.scheduleGlobal(function()
    	
    			self.preLoadTime = global.dataMgr:getServerTime()    			
	    	    self:getMsg(_resList,false,call)
	    	    self:closeSchedule()
	    	end, 0.2)		
		end
	end

	return _resList
end

function AreaDataMgr:closeSchedule()
	
	if self.scheduleListenerId then

		gscheduler.unscheduleGlobal(self.scheduleListenerId)
	end
end

function AreaDataMgr:getAreaDataByIndex(x,y)
	return self.areaDataCache[x][y]
end

function AreaDataMgr:doorNotify(data)

	self:flushCurrentScreen()
end

function AreaDataMgr:cityNotify(data)
	
	local panel = g_worldview.mapPanel
	local lCitys = data.lCitys
	local flushIndexs = {}
	for _,v in ipairs(lCitys) do

		if v.lBlockID then
			
			local areaX,areaY = self:decodeAreaID(v.lBlockID)
			local res = self.areaDataCache[areaX][areaY]
			setmetatable(v, {__index = v.tagCityUser})

			gevent:call(global.gameEvent.EV_ON_MONSTER_CAMP,v.lCityID)

			if v.lReason == 1 then

				if global.g_worldview.worldPanel.chooseCityId == v.lCityID then

					global.g_worldview.mapPanel:closeChoose(false)
				end
			end

			if v.lReason == 0 then

				local city = panel:getCityById(v.lCityID)

				if city ~= nil and (city:getType() == WCONST.WORLD_CFG.CITY_TYPE.EMPTY_CITY or city:isTown()) then
					
					city:setVisible(false)

					local csb = resMgr:createCsbAction("effect/move_city", "animation0", false, true, function()
						
					end,function()
						
						-- print("do this")
						-- city:setScale(2)
						city:setVisible(true)
					end)


					if global.g_worldview.worldPanel:getIsLineMap() then

						csb:setVisible(false)
					end

    				uiMgr:configUITree(csb)

    				-- csb.Node_1.citySprite:setSpriteFrame(city:getCityIconPath({sData = v}).worldmap)
    				global.panelMgr:setTextureFor(csb.Node_1.citySprite,city:getCityIconPath({sData = v}).worldmap)

					csb:setPosition(cc.p(city:getPosition()))

					panel.effectNode:addChild(csb)
				end			
			end

			if res and type(res) == 'table' then

				for i,vv in ipairs(res) do
			
					if vv.id == v.lCityID then
					
						-- print(vv,"...pre")
						-- vv.sData = v
						table.assign(res[i].sData,v)
						vv.name = v.szCityName
						-- print(vv,"...after")
					end
				end
			end			

			if v.lCityID == g_worldview.worldPanel.mainId and v.lReason == 1 then

				-- print("重置主城ID")
				g_worldview.worldPanel:setMainCityData({lCityID = -1,lPosX = 0,lPosY = 0})
			end 

			if v.lUserID == userData:getUserId() then

				-- print("set main id ",v.lCityID)
				g_worldview.worldPanel:setMainCityData({lCityID = v.lCityID,lPosX = v.lPosX,lPosY = v.lPosY})
				-- print(global.g_worldview.worldPanel.mainId)
			end

			local index = cc.p(areaX,areaY)
			if self:isAreaInScreen(index) then


				local isHava = false
				for _,fiv in ipairs(flushIndexs) do

					if fiv.x == index.x and fiv.y == index.y then

						isHava = true
						break
					end
				end

				if not isHava then				

					table.insert(flushIndexs,index)
				end

				-- panel:createBuildingsByAreaData(index,self.areaDataCache[index.x][index.y],true)	
			end
		end	
	end

	for _,v in ipairs(flushIndexs) do

		if panel and panel.createBuildingsByAreaData then 
			panel:createBuildingsByAreaData(v,self.areaDataCache[v.x][v.y],true)	
		end 
		
	end
end

function AreaDataMgr:isAreaInScreen(index)
	
	if self.preResList == nil then return false end

	for _,v in pairs(self.preResList) do

		if v.x == index.x and v.y == index.y then

			return true
		end
	end

	return false
end

function AreaDataMgr:decodeAreaID(areaId)
	
	-- print(areaId,"areaId")

	areaId = areaId - 1
	local width_height = WCONST.WORLD_CFG.INFO.MAP_WIDTH
	local areaX = math.floor(areaId / width_height)
	local areaY = areaId % width_height
	return areaX,areaY
end

--call 拉取结束的回调， preCall 拉取到就调用的call
function AreaDataMgr:getMsg(resList,isNeedClean,call,preCall)

	-- print(debug.traceback())
	-- print(">>>>>>>>>>>>>flush wolrd",resList)
	-- dump(resList,"flush world data")

	-- if resList or #resList == 0 then return end
	-- dump(resList,">>>>>>>>>> resList")

	if g_worldview.isStory then
		return
	end

	if not global.scMgr:isWorldScene() then

        return
    end

	print(">>>>>>>>>>>>>flush wolrd2222",resList)

	local width_height = WCONST.WORLD_CFG.INFO.MAP_WIDTH
	local res = {}
	for _,v in ipairs(self.preResList or {}) do
		
		table.insert(res,v.x * width_height + v.y + 1)
	end

	local dataRes = {}
	for _,v in ipairs(resList or {}) do
		
		table.insert(dataRes,v.x * width_height + v.y + 1)
	end
	
	local panel = g_worldview.mapPanel
	local worldPanel = g_worldview.worldPanel

	worldPanel:showLoading()

	self.isGetMsg = true
	global.worldApi:flushWorld(res,dataRes, function(msg)

		if not global.scMgr:isWorldScene() then

			return
		end		

		if  worldPanel.hideLoading then 
			worldPanel:hideLoading()
		end 

		self.isGetMsg = false		

		local areaData = msg.lAreas
		-- dump(areaData,"fffffffffff->areaData-->")
	
		if preCall then  
			preCall() 
		end

		if areaData then
			
			for it,v in ipairs(areaData) do

				local res = {}
				res.lBuff = v.lBuff
				local citys = v.lCitys
				local areaX,areaY = self:decodeAreaID(v.lAreaID)			

				for _,cv in ipairs(citys) do

					local _x = cv.lPosX
					local _y = cv.lPosY
					local _szCityName = cv.szCityName
					local _id = cv.lCityID

					table.insert(res,{id = _id,x = _x,y = _y,name = _szCityName, sData = cv})
				end


				v.tagTransfer = v.tagTransfer or {}
				for _,cv in ipairs(v.tagTransfer) do

					local _x = cv.lPosx
					local _y = cv.lPosy
					local _szCityName = cv.szCityName
					local _id = cv.lMapID

					table.insert(res,{id = _id,x = _x,y = _y,name = _szCityName, sData = cv})
				end

				local index = cc.p(areaX,areaY)--resList[it]
				self.areaDataCache[index.x][index.y] = res
			
				if self:isAreaInScreen(index) then
					if panel and panel.createBuildingsByAreaData then
						panel:createBuildingsByAreaData(index,res,isNeedClean)	
					end

					local tagReses = v.tagReses
					if tagReses then
						if panel and panel.createWildReses then --protect 
							panel:createWildReses(index,tagReses,isNeedClean)
						end 
					end

					local tagMonsters = v.tagMonsters
					if tagMonsters and panel.createWildObjs then
						panel:createWildObjs(index,tagMonsters,isNeedClean)
					end
				else

					self.areaDataCache[index.x][index.y] = nil
					-- print("拉到了数据但是已经滑出屏幕了")
				end

				local troops = v.lTroopInfo
				if troops then
					for _ ,v in pairs(troops) do 
				        if v.lUserID ==  global.userData:getUserId()  then 
				            global.ClientStatusData:troopMsg(v)
				        end 
				    end 
					g_worldview.attackMgr:addAttack({tagTroop = troops})
				end
			end
		end
		if call then call() end
		global.g_worldview.mapPanel:refreshLeagueArea()

		-- dump(self.areaDataCache,"-------------------fff")
	end)
end

return AreaDataMgr
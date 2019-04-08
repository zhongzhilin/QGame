--大地图的地图块数据

local MapInfo = class("MapInfo")
local luaCfg = global.luaCfg
local WCONST = WCONST

MapInfo.wildData = {}
MapInfo.pointData = {}
MapInfo.wayData = {}

local ITOUNIQUE = 10000000
local JTOUNIQUE = 10000

function MapInfo:ctor()

	local preWayData = global.g_wayData
	if preWayData then
	
		self.wayData = preWayData.wayData
		self.wayDataIndex = preWayData.wayDataIndex
	else

		self.wayData = table.get2DimensionTable()
		self.wayDataIndex = {}

		local count = luaCfg:get_map_cfg_by(1).number
		local loadPanel = global.panelMgr:getPanel("UIInputAccountPanel")
		local loadIndex = nil
		loadIndex = function(i)
			
			print("deal with tmx index:",i)
			self.wayDataIndex[i] = table.get2DimensionTable()		
			local map = cc.TMXTiledMap:create(string.format("map/map%02d.tmx",i))		
			self:addAreaInfo(map,i)

			local nextIndex = i + 1
			if nextIndex <= count then

				loadPanel:updateMapInfoProgress(i / count * 100)
				global.delayCallFunc(function()
					loadIndex(nextIndex)
				end,nil,1 / 60)
			else
				loadPanel:updateMapInfoProgress(100)
			end
		end

		loadIndex(1)
		-- for i = 1,count do

		-- 	print("deal with tmx index:",i)
		-- 	self.wayDataIndex[i] = table.get2DimensionTable()		
		-- 	local map = cc.TMXTiledMap:create(string.format("map/map%02d.tmx",i))		
		-- 	self:addAreaInfo(map,i)
		-- end

		global.g_wayData = {}

		global.g_wayData.wayData = self.wayData
		global.g_wayData.wayDataIndex = self.wayDataIndex
	end	
end

function MapInfo:getMapPos(i,j)
	
	i = i - WCONST.WORLD_CFG.INFO.MAP_WIDTH / 2
	j = j - WCONST.WORLD_CFG.INFO.MAP_WIDTH / 2

	local width = WCONST.WORLD_CFG.INFO.TMX_WIDTH / 2
	
	return cc.p(i * width + j * width,i * width - j * width - width)
end

function MapInfo:getIndexWayInfo(index)
	
	return self.wayDataIndex[index]
end

function MapInfo:getMapIndex(i,j)

	return ((_j % 3) + (_i % 3) * 3)
end

--根据城池id或者野地id，获取区块id
function MapInfo:getBlockIdByUniqueId(unique)
	local m_nMapHeight = WCONST.WORLD_CFG.INFO.MAP_WIDTH
	local blockId = (math.floor(unique/ITOUNIQUE)) * m_nMapHeight + math.floor((unique % ITOUNIQUE)/JTOUNIQUE) + 1

	return blockId
end

function MapInfo:decodeId(id)
	
	local i = math.floor(id / 10000000)
	id = id % 10000000
	local j = math.floor(id / 10000)
	id = id % 10000

	return i,j,id,((id > 5000) and (id < 6000))
end

function MapInfo:getLastCityId(cityId)
	
	cityId = cityId or global.userData:getWorldCityID()
	local i,j,id = self:decodeId(cityId)
	local res = 0
	for k,v in pairs(self.wayData[id]) do
	
		local resId = i * 10000000 + j * 10000 + k
		local city = global.g_worldview.mapPanel:getCityById(resId)
		if city then
			if city:isEmpty() then

				return resId
			else

				res = resId
			end
		end		
	end

	return res
end

-- 起点cityId,沿途城池点个数cityCount
function MapInfo:addLastCityList(cityId,cityCount)
	
	cityId = cityId or global.userData:getWorldCityID()
	local i,j,id = self:decodeId(cityId)	
	local seekCache = {}
	table.insert(seekCache,id)
	local res = {}
	table.insert(res,id)

	local seekCity = nil
	seekCity = function(_id,_deep)
		
		-- print('start seek id ' .. _id)

		if _deep >= cityCount then
			-- print('deep out of way')
			return
		end

		for k,v in pairs(self.wayData[_id]) do

			if not seekCache[k] then
				
				seekCache[k] = true
				table.insert(res,k)
				return seekCity(k,_deep + 1)
			end
		end

		-- print('no find the more wayData')		
		-- dump(seekCache)
	end

	seekCity(id,0)

	return res
end

function MapInfo:addAreaInfo(map,index)
	local width = WCONST.WORLD_CFG.INFO.TMX_WIDTH

	local playerData = map:getObjectGroup("player"):getObjects()
	for _,v in ipairs(playerData) do

		-- v.y = width - v.y
		v.x = v.x + v.width / 2
		v.y = v.y + v.height / 2
		self.pointData[tonumber(v.bd)] = v
	end
	
	local hideData = map:getObjectGroup("hide"):getObjects()
	for _,v in ipairs(hideData) do

		-- v.y = width - v.y
		if v.ld then
		
			v.x = v.x + v.width / 2
			v.y = v.y + v.height / 2
			self.pointData[tonumber(v.ld)] = v
		end
	end

	local wildData = map:getObjectGroup("wild"):getObjects()
	for _,v in ipairs(wildData) do
		if v.wd then
			v.x = v.x
			v.y = v.y
			self.wildData[tonumber(v.wd)] = v
		end
	end

	local wildData = map:getObjectGroup("transfer"):getObjects()
	for _,v in ipairs(wildData) do
		if v.wd then
			v.x = v.x
			v.y = v.y
			self.wildData[tonumber(v.wd)] = v
		end
	end

	local worldbossObj = map:getObjectGroup("worldboss")
	if worldbossObj then
		local wildData = worldbossObj:getObjects()
		for _,v in ipairs(wildData) do
			if v.wd then
				v.x = v.x
				v.y = v.y
				self.wildData[tonumber(v.wd)] = v
			end
		end
	end

	local waysData = map:getObjectGroup("road"):getObjects()
	for _,v in ipairs(waysData) do

		local b1 = tonumber(v.b1)
		local b2 = tonumber(v.b2)
		local b1Pos = self.pointData[b1]
		local b2Pos = self.pointData[b2]

		local lineCount = #v.polylinePoints

		local lineEndPos = v.polylinePoints[lineCount]

		local reLine = {}

		for i = 1,lineCount do

			local pv = v.polylinePoints[lineCount - i + 1]
			
			table.insert(reLine,cc.p(pv.x - lineEndPos.x + b2Pos.x,(pv.y - lineEndPos.y) * -1 + b2Pos.y))
		end

		self.wayData[b2][b1] = reLine		

		for _,pv in ipairs(v.polylinePoints) do

			pv.x = pv.x + b1Pos.x
			pv.y = pv.y * -1 + b1Pos.y
		end

		self.wayData[b1][b2] = v.polylinePoints
		self.wayDataIndex[index][b2][b1] = v.polylinePoints
	end	
end

return MapInfo
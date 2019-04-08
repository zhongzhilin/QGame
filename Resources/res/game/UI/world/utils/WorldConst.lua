local _M = {}
local WCONST = WCONST

-- --对城池ID解码
-- function _M:decodeId(id)

-- 	local i = math.floor(id / 10000000)
-- 	id = id % 10000000
-- 	local j = math.floor(id / 10000)
-- 	id = id % 10000

-- 	return i,j,id,id > 5000	
-- end

-- --根据城池id或者野地id，获取区块id
-- function _M:convertObjId2BlockId(unique)
-- 	local m_nMapHeight = WCONST.WORLD_CFG.INFO.MAP_WIDTH
-- 	local blockId = (math.floor(unique/ITOUNIQUE)) * m_nMapHeight + math.floor((unique % ITOUNIQUE)/JTOUNIQUE) + 1

-- 	return blockId
-- end

--像素转大陆ID
function _M:convertPix2LandId(pos)
	
	local i,j = self:convertPix2MapIndex(pos)
	return self:convertMapIndex2LandId(i,j)
end

--大陆i，j转块ID
function _M:convertMapIndex2LandId(i,j)
	
	local map_region = global.luaCfg:map_region()
	for id,v in ipairs(map_region) do

		if i >= v.minX and i <= v.maxX and j >= v.minY and j <= v.maxY then

			return id
		end
	end

	return nil
end

-- 大陆i，j转资源带
function _M:converMapIndex2ResLevel(i,j)
	local landId = self:convertMapIndex2LandId(i,j)
    local luaCfg = global.luaCfg

    local map_lv = luaCfg:map_lv()
    local maxLv = 1
    for _,v in ipairs(map_lv) do

        if v.landID == landId then

            local lv = v.lv

            local isOut = false
			if i >= v.minX and i <= v.maxX and j >= v.minY and j <= v.maxY then

				if lv > maxLv then
					maxLv = lv
				end
				-- return  lv
            end
        end
    end

    return maxLv
end

-- 城池ID转资源带level
function _M:convertCityId2ResLevel(id)
	local mapInfo = global.g_worldview.mapInfo	
    local i,j,bd = mapInfo:decodeId(id)
    
    return self:converMapIndex2ResLevel(i,j)
end

--像素转i,j
function _M:convertPix2MapIndex(pos)
	
	local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH	
	local tmx_width = WCONST.WORLD_CFG.INFO.TMX_WIDTH
    local tempX = pos.x * -1
    local tempY = pos.y * -1
    local i = (((tempX) + (tempY)) / (tmx_width) + map_width / 2)
    local j = (((tempX) - (tempY)) / (tmx_width) + map_width / 2)

    i = math.floor(i)
    j = math.floor(j)

    return i,j
end

--城池id转像素
function _M:convertCityId2Pix(id,isWild)

	if global.g_worldview and global.g_worldview.mapInfo then 

	    local mapInfo = global.g_worldview.mapInfo	
	    local i,j,bd = mapInfo:decodeId(id)
	    local mapPos1 = mapInfo:getMapPos(i, j)
	    local confPos = isWild and mapInfo.wildData[bd] or mapInfo.pointData[bd]

	    if not confPos then print("empty point " .. id) end

	    return cc.p(confPos.x + mapPos1.x,confPos.y + mapPos1.y)

	end 
end

--像素转公里
function _M:converPix2Location(pos)
	
	pos = pos or cc.p(0,0)

	local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    pos = cc.pRotateByAngle(pos,cc.p(0,0),135 * 3.14 / 180)
    return cc.p(math.floor(pos.y / 100 + 7.24 * map_width),math.floor(pos.x / 100 + 7.24 * map_width))
end

--公里转像素
function _M:converLocation2Pix(location)
	
	local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH

	local pos = {}
	pos.x = (location.x - 7.24 * map_width) * 100
	pos.y = (location.y - 7.24 * map_width) * 100

	pos = cc.pRotateByAngle(pos,cc.p(0,0),-135 * 3.14 / 180)

	return pos
end

--屏幕位置转大地图位置
function _M:convertScreenPos2Map( pos )
	
	local mapPanel = global.g_worldview.mapPanel
	local truePos = mapPanel.truePos or {x = 0,y = 0}
	local screenPos = cc.p(gdisplay.width / 2,gdisplay.height / 2)

	return cc.p(truePos.x - screenPos.x + pos.x,truePos.y - screenPos.y + pos.y)
end

--大地图位置转屏幕位置
function _M:convertMapPos2Screen(pos)
	
	local mapPanel = global.g_worldview.mapPanel
	local truePos = mapPanel.truePos or {x = 0,y = 0}
	local screenPos = cc.p(gdisplay.width / 2,gdisplay.height / 2)

	return cc.p(pos.x - (truePos.x - screenPos.x),pos.y - (truePos.y - screenPos.y))
end

--根据联盟村庄找到对应的联盟城市
function _M:findLeagueCityByLeagueVillage(city)
	local allLeagueCitys = global.luaCfg:all_miracle_name()
	local srcPixel = self:convertCityId2Pix(city:getId())
	
	local dstCityId = 0
	local currLen = 99999999
	for i,v in pairs(allLeagueCitys) do
		-- dump(v)
		local dstPixel = self:convertCityId2Pix(v.id)
		local len = cc.pGetDistance(srcPixel,dstPixel)
		if currLen >= len then
			currLen = len
			dstCityId = v.id
		end
	end
	return dstCityId
end

return _M
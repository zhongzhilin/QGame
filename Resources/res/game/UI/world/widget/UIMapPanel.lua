--region UIWorldCity.lua
--Author : untory
--Date   : 2016/09/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UIWorldCity = require("game.UI.world.widget.UIWorldCity")
local UIWorldWildObj = require("game.UI.world.widget.UIWorldWildObj")
local UIWorldWildRes = require("game.UI.world.widget.UIWorldWildRes")
local UICityChoose = require("game.UI.world.widget.UICityChoose")
local worldConst = require("game.UI.world.utils.WorldConst")

local screen_width = gdisplay.width
local screen_height = gdisplay.height

local g_worldview = global.g_worldview
local luaCfg = global.luaCfg
local UIMapPanel  = class("UIMapPanel", function() return gdisplay.newWidget() end )

function UIMapPanel:ctor()
  g_worldview = global.g_worldview
end

local Nodes = {"rainNode","upEffectNode","mapObjNode","roadNode","wayNode","attackEffectNode","effectNode","armyNode","battleNode","uiNode"}

function UIMapPanel:onEnter()

	for zorder,key in ipairs(Nodes) do

		local ignore3dNodes = {rainNode = true,roadNode = true,wayNode = true}

		local node = cc.Node:create()
		node:setLocalZOrder(zorder)
		self:addChild(node)

		if not ignore3dNodes[key] then
		
			local tempAddChild = node.addChild
			node.addChild = function(node,child)

				tempAddChild(node,child)

				if WCONST.WORLD_CFG.IS_3D then

					local rotation = child:getRotation3D()
					if not child.isCity then
	    				child:setRotation3D(cc.vec3(25,rotation.y,rotation.z))
					end
				end 
			end
		end		

		self[key] = node
	end

	self:initTouch()
	self:initEffectSound()
	self.choose = nil

	self:initCityArea()

	self.panelTruePos = cc.p(0,0)

	self.scheduleListenerId = gscheduler.scheduleGlobal(function()
    	    
    	
	    self:loopAddChild()		
	end, 0)

	self.roadNode:addChild(g_worldview.worldCityMgr:getRoadNode())

	local tempSetPosition = self.setPosition
    self.setPosition = function(node,pos)
        
        self.roadNode:setPosition(cc.p(-pos.x,-pos.y))
        tempSetPosition(node,pos)
    end	
	-- local draw = cc.DrawNode:create()
	-- draw:setAnchorPoint(cc.p(0,0))
	-- draw:setPosition(cc.p(0,0))
	-- self:addChild(draw,-1)

	-- for i = 0,1000 do
		
	-- 	draw:drawSegment(cc.p(i * 20,0), cc.p(i * 20 + 6,0), 3, {r = 0,g = 1,b = 0, a = 0.2}) 
	-- end
end

function UIMapPanel:initEffectSound()
	
	if global.g_worldview.isStory then
        
        return
    end    

    gsound.playBgm("world_battle",true,false,0)
    -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_battle")    
    -- self.isOpenBattleSound = true
    self.battleSoundValue = 0
    self.taskBattleSoundValue = 0
    gsound.setBgmVolume(0,"world_battle")

    gsound.playBgm("world_fire",true,false,0)
    -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_fire")    
    -- self.isOpenFireSound = true
    self.fireSoundValue = 0
	self.taskFireSoundValue = 0
	gsound.setBgmVolume(0,"world_fire")

    self.soundScheduleListenerId = gscheduler.scheduleGlobal(function()
            
        self:checkSoundValue()
        self:checkSound()
    end, 0.3) 

    self:checkSound()
end

function UIMapPanel:checkSoundValue()
	
	local soundSpeed = 20

	if self.battleSoundValue > self.taskBattleSoundValue then
		self.battleSoundValue = self.battleSoundValue - soundSpeed
		gsound.setBgmVolume(self.battleSoundValue,"world_battle")	
	end

	if self.fireSoundValue > self.taskFireSoundValue then
		self.fireSoundValue = self.fireSoundValue - soundSpeed
		gsound.setBgmVolume(self.fireSoundValue,"world_fire")	
	end

	if self.battleSoundValue < self.taskBattleSoundValue then
		self.battleSoundValue = self.battleSoundValue + soundSpeed
		gsound.setBgmVolume(self.battleSoundValue,"world_battle")	
	end

	if self.fireSoundValue < self.taskFireSoundValue then
		self.fireSoundValue = self.fireSoundValue + soundSpeed
		gsound.setBgmVolume(self.fireSoundValue,"world_fire")	
	end

	-- print(self.battleSoundValue,"self.battleSoundValue",self.taskBattleSoundValue,"self.taskBattleSoundValue")
	-- print(self.fireSoundValue,"self.fireSoundValue",self.taskFireSoundValue,"self.taskFireSoundValue")
end

function UIMapPanel:AnyActiveBossInScreen()
	
	local objs = self.mapObjNode:getChildren()
	local screenRect = cc.rect(-200,-200,gdisplay.width + 200,gdisplay.height + 200)
	local res = {}
	for _,v in ipairs(objs) do
	
		if v.isWildObj and v:isBoss() and v.data.lCurState == 1 then

			local pos = global.g_worldview.const:convertMapPos2Screen(cc.p(v:getPosition()))
		    if CCHgame:isRectContainsPoint(screenRect,pos) then
		    	
				return true
		    end
		end
	end

	return false
end

function UIMapPanel:checkSound()
	
	local screenRect = cc.rect(-200,-200,gdisplay.width + 200,gdisplay.height + 200)
	
	local children = self.battleNode:getChildren()
	local isHavaIn = false

	for _,v in ipairs(children) do

		local pos = global.g_worldview.const:convertMapPos2Screen(cc.p(v:getPosition()))
	    if CCHgame:isRectContainsPoint(screenRect,pos) then
	    	isHavaIn = true
	    	break
	    end
	end

	if isHavaIn or self:AnyActiveBossInScreen() then

		-- gsound.setBgmVolume(100,"world_battle")
		-- self.isOpenBattleSound = true
		self.taskBattleSoundValue = 100
	else

		-- gsound.setBgmVolume(0,"world_battle")
		-- self.isOpenBattleSound = false

		self.taskBattleSoundValue = 0
	end

	isHavaIn = false
	local citys = self:getAllCitys()
	for _,v in ipairs(citys) do

		if v.isInFire then

			local pos = global.g_worldview.const:convertMapPos2Screen(cc.p(v:getPosition()))
			if CCHgame:isRectContainsPoint(screenRect,pos) then
		    	isHavaIn = true
		    	break
		    end
		end
	end

	if isHavaIn then

		-- gsound.setBgmVolume(100,"world_fire")
		-- self.isOpenFireSound = true

		self.taskFireSoundValue = 100
	elseif not isHavaIn then

		-- gsound.setBgmVolume(0,"world_fire")
		-- self.isOpenFireSound = false

		self.taskFireSoundValue = 0
	end
	-- dump({isHavaIn = isHavaIn,isOpenBattleSound = self.isOpenBattleSound})
	-- if isHavaIn == not self.isOpenBattleSound then

	-- 	if isHavaIn then

	-- 		gsound.setEffectVolume("world_battle",1)
	-- 		self.isOpenBattleSound = true
	-- 	else

	-- 		gsound.setEffectVolume("world_battle",0)
	-- 		self.isOpenBattleSound = false
	-- 	end
	-- end
end

function UIMapPanel:getAllObj()
	
	return self.mapObjNode:getChildren()
end

function UIMapPanel:onExit()

	local citys = self:getAllObj()
	for _,v in ipairs(citys) do
		v:release()
		-- v:autorelease()
	end

	self:cleanSchedule()
end

function UIMapPanel:cleanSchedule()
	if self.scheduleListenerId then

		gscheduler.unscheduleGlobal(self.scheduleListenerId)
		self.scheduleListenerId = nil
	end

	if self.scheduleListenerId1 then

		gscheduler.unscheduleGlobal(self.scheduleListenerId1)
		self.scheduleListenerId = nil
	end	

	if self.soundScheduleListenerId then

        gscheduler.unscheduleGlobal(self.soundScheduleListenerId)
    end
end

function UIMapPanel:initCityArea()
	self.cityArea = {}
	setmetatable(self.cityArea, {

		__index = function(table,key)

			table[key] = {}

			setmetatable(table[key], {

				__index = function(tableChild,keyChild)

					tableChild[keyChild] = {}
					return tableChild[keyChild]		
				end
			})

			return table[key]		
		end
	})

	self.waitChildList = {}
	setmetatable(self.waitChildList, {

		__index = function(table,key)

			table[key] = {}

			setmetatable(table[key], {

				__index = function(tableChild,keyChild)

					tableChild[keyChild] = {}
					return tableChild[keyChild]		
				end
			})

			return table[key]		
		end
	})
end


function UIMapPanel:getMainCityPos(panelX,panelY)

	-- if self.mainCity == nil then return cc.p(0,0) end

	local scale = g_worldview.worldPanel.m_scrollView:getZoomScale()

	local mainCityPos = g_worldview.worldPanel.mainCityPos

	if mainCityPos == nil or (mainCityPos.x == 0 and mainCityPos.y == 0) then return 
		cc.p(0,0) 
	end

	return cc.p((mainCityPos.x - panelX) * scale + screen_width / 2,
		(mainCityPos.y - panelY) * scale + screen_height / 2)
end

--更新
function UIMapPanel:createBuildingsByAreaData(index,data,isNeedClean)

	-- log.debug(self.cityArea)
	-- print("start load ",index.x,indexy)

	local miniMap = g_worldview.worldPanel.miniMap
	self.cityArea[index.x][index.y].city = self.cityArea[index.x][index.y].city or {}
	local contentArea = self.cityArea[index.x][index.y].city

	if #contentArea ~= 0 then

		for i,v in ipairs(contentArea) do

			if v:isRandomDoor() then

				table.remove(contentArea,i)
				g_worldview.worldCityMgr:removeCity(v)
			end
		end

		for i,v in ipairs(data) do

			if v.sData.lTarget ~= nil then

				self:startAddChild(index.x, index.y, self.mapObjNode, v,contentArea,"cityNode")
			end
		end

		if isNeedClean then

			for _,v in ipairs(contentArea) do

				if not v:isRandomDoor() then
				
					for _,dv in ipairs(data) do
			
						if v.data.id == dv.id then
							v:setData(dv)
							v:getPointSprite():setSpriteFrame(miniMap:getSpriteFrameByType(v:getType()).minimap)	
							local color = miniMap:getMapColorByAvatar(v:getAvatarType(),v:isEmpty())
							if color then --protect 
								v:getPointSprite():setColor(color)
							end 
						end
					end								
				end							
			end
			
			return
		else

			return
		end
	end

	-- self.cityArea[index.x][index.y] = {}  
	if type(data) ~= 'table' then return end
	for _,v in ipairs(data) do
		
		-- if v.id == global.userData:getWorldCityID() then
		-- 	print(global.guideMgr:getCurStep(),global.luaCfg:get_guide_stage_by(5).Key,">>>>>>>>>>>>>>>>>>>>>adw")			
		-- end		

		if v.id == global.userData:getWorldCityID() and global.guideMgr:getCurStep() == global.luaCfg:get_guide_stage_by(5).Key then

			global.guideMgr:setTempData(v)

			local id = v.id
			local cv = {
	            lBlockID = 3,
	            lCityID = id,
	            lKind = 1,
	            lReason = 1,
	            lBaseInfo = 0,
	            lType = 0,
	            tagWildInfo = {
	                lCurHp = 400,
	                lCurRound = 0,
	                lMaxHp = 400,
	                lStatus = 0,
	            },   
	            tagPlusInfo = {
	                [1] = {
	                    lID = 24,
	                    lValue = 100,
	                },
	            },
	        }

	        local pos = global.g_worldview.const:convertCityId2Pix(id)
	        local _x = pos.x
	        local _y = pos.y
	        local _szCityName = cv.szCityName
	        local _id = cv.lCityID

	        local res = {id = _id,x = _x,y = _y,name = _szCityName, sData = cv}

			self:startAddChild(index.x, index.y, self.mapObjNode, res,contentArea,"cityNode")
			-- global.guideMgr:getHandler():autoAddEmpty({ids = {global.userData:getWorldCityID()}})
		else
			self:startAddChild(index.x, index.y, self.mapObjNode, v,contentArea,"cityNode")		
		end		
	end
end

function UIMapPanel:getCityOrMiracleById(id)
	
	local children = self:getAllCitysAndMiracle()
	for _,v in ipairs(children) do
		
		if v:getId() == id then

			return v
		end
	end

	return nil
end

function UIMapPanel:getCityById(id)
	
	local children = self:getAllCitys()
	for _,v in ipairs(children) do
		
		if v:getId() == id then

			return v
		end
	end

	return nil
end

function UIMapPanel:preFlush()
	
	for _,v in ipairs(self.preResList or {}) do
			
		for nk,nv in pairs(self.cityArea[v.x][v.y]) do
			-- g_worldview.worldCityMgr:getPoint(v.cityType)
			if nk == "city" then
				for _,nnv in ipairs(nv) do
					g_worldview.worldCityMgr:removeCity(nnv)
				end
			elseif nk == "wildRes" then
				for _,nnv in ipairs(nv) do
					g_worldview.worldCityMgr:removeWildRes(nnv)
				end
			elseif nk == "wildObj" then
				for _,nnv in ipairs(nv) do
					g_worldview.worldCityMgr:removeWildObj(nnv)
				end
			end
		end

		self.waitChildList[v.x][v.y] = nil
		self.cityArea[v.x][v.y] = nil

		g_worldview.areaDataMgr:cleanArea(v)
	end

	-- self.preResList = {}
end

--创建
function UIMapPanel:loadBuildWithAreaIndex(resList)

	-- dump(resList)

	if self.preResList ~= nil then
		
		for _,v in ipairs(self.preResList) do
			
			local isOutScreen = true
			for _,ev in ipairs(resList) do
						
				if v.x == ev.x and v.y == ev.y then

					isOutScreen = false
				end
			end

			if isOutScreen then

				for nk,nv in pairs(self.cityArea[v.x][v.y]) do
					-- g_worldview.worldCityMgr:getPoint(v.cityType)
					if nk == "city" then
						for _,nnv in ipairs(nv) do
							g_worldview.worldCityMgr:removeCity(nnv)
						end
					elseif nk == "wildRes" then
						for _,nnv in ipairs(nv) do
							g_worldview.worldCityMgr:removeWildRes(nnv)
						end
					elseif nk == "wildObj" then
						for _,nnv in ipairs(nv) do
							g_worldview.worldCityMgr:removeWildObj(nnv)
						end
					end
				end

				self.waitChildList[v.x][v.y] = nil
				self.cityArea[v.x][v.y] = nil

				print("g_worldview.areaDataMgr:cleanArea(v)")
				-- dump(v)
				g_worldview.areaDataMgr:cleanArea(v)
			end
		end
	end

	self.preResList = clone(resList)

	-- for _,v in ipairs(resList) do

	-- 	local data = g_worldview.areaDataMgr:getAreaDataByIndex(v.x, v.y)
	-- 	if data ~= nil and type(data) == "table" and #data ~= 0 then
	-- 		self:createBuildingsByAreaData(v,data)   
	-- 	end
	-- end
end

function UIMapPanel:flushPanel(panelX,panelY)

	if panelX == nil then

		panelX = self.truePos.x
		panelY = self.truePos.y
	end

	self.truePos = cc.p(panelX,panelY)

	self:cleanBuildOutScreen(panelX, panelY)
	self:checkDirector(panelX, panelY)
	self:checkLocation(panelX, panelY)
	self:checkMinimap(panelX, panelY)
	self:checkLine()
end

function UIMapPanel:checkLine()
	
	local lineViewMgr = g_worldview.lineViewMgr
	local maps = self.mapNode:getChildren()
	for _,v in ipairs(maps) do

		local index = v.index
		lineViewMgr:flushLineView(index)
	end
end

function UIMapPanel:getTruePos()

	return self.truePos
end

function UIMapPanel:createWildReses(index,data,isNeedClean)
	--print("#############UIMapPanel:createWildReses(index,data,isNeedClean)  "..vardump(index))
	self.cityArea[index.x][index.y].wildRes = self.cityArea[index.x][index.y].wildRes or {}
	local contentArea = self.cityArea[index.x][index.y].wildRes

	-- dump(data)

	if #contentArea ~= 0 then

		if isNeedClean then

			for _,v in ipairs(contentArea) do
				for _,dv in ipairs(data) do
					-- log.debug(v.id .. " " .. dv.id)
					if v.data.lResID == dv.lResID then
						v:setData(dv)
					end
				end								
			end

			return
		else

			return
		end
	end

	for _,v in ipairs(data) do
		--------------
		-- local city = g_worldview.worldCityMgr:getWildRes()		
		-- city:setData(v)
		-- self.wildResNode:addChild(city)
		-- table.insert(contentArea,city)
		--print("lResID="..v.lResID)

		self:startAddChild(index.x, index.y, self.mapObjNode, v,contentArea,"wildResNode")
		----------
	end
end

function UIMapPanel:addWildRes(index,data)
	self.cityArea[index.x][index.y].wildRes = self.cityArea[index.x][index.y].wildRes or {}
	local contentArea = self.cityArea[index.x][index.y].wildRes

	--------------
	local city = g_worldview.worldCityMgr:getWildRes()		
	city:setData(data)
	self.mapObjNode:addChild(city)
	table.insert(contentArea,city)
	----------
	return city
end

function UIMapPanel:removeWildRes(index,city)
	local contentArea = self.cityArea[index.x][index.y].wildRes or {}
	--------------
	for i,v in ipairs(contentArea) do
		if v:isMe(city:getId()) then
			table.remove(contentArea,i)
			break
		end
	end
	g_worldview.worldCityMgr:removeWildRes(city)
	----------
end

--检测有没有要插队的成员（120，119）
function UIMapPanel:checkNeedAddImmediately(areaX,areaY,lTargetId)
	-- if 1 then return end	
	local areas = self.waitChildList[areaX][areaY] or {}
	local index = -1
	local insertData = nil
	for i,waitData in ipairs(areas) do
		if self:getCityIdByWaitMode(waitData) == lTargetId then
					
			index = i
			insertData = waitData
		end
	end
	if index <= 0 then
		return false
	end

	table.remove(self.waitChildList[areaX][areaY],index)
	table.insert(self.waitChildList[areaX][areaY],1,insertData)
	self:loopAddChild()
	return true
end

function UIMapPanel:startAddChild(areaX,areaY,parent,data,areaCache,waitType)

	self.isStartAddChild = true
	local waitInfo = {parent = parent,data = data,areaCache = areaCache,waitType = waitType}
	table.insert(self.waitChildList[areaX][areaY],waitInfo)
end


local lastActiveCsdName = ""
local lastCityId = 0
function UIMapPanel:refreshLeagueArea()
	g_worldview.worldCityMgr:hideAllLeagueBoundryEffect()
	lastActiveCsdName = ""
	lastCityId = 0
	local children = self:getAllCitys()
	for _,v in ipairs(children) do
		self:checkShowLeagueBoundry(v)
	end
end


function UIMapPanel:checkShowLeagueBoundry(city)
	local dstCityId = nil
	if not city:isHaveLeagueBuff() then
		return
	end
	if city:isLeagueVillage() then
		dstCityId = worldConst:findLeagueCityByLeagueVillage(city)
	elseif city:isLeagueCity() then
		dstCityId = city:getId()
	else
		dstCityId = worldConst:findLeagueCityByLeagueVillage(city)
	end

	--print("------------------》dstCityId")
	--print(dstCityId)
	-- local i,j = worldConst:convertPix2MapIndex(dstCityId)
	-- local index = g_worldview.worldCityMgr:getCityIndex(cc.p(i,j))
	local data = global.luaCfg:get_all_miracle_name_by(dstCityId)
	if not data then return end
	local csdName = data.csdname
	if dstCityId == lastCityId or dstCityId == 0 then
		--print("------------------dstCityId == lastCityId")
		--print(dstCityId)
		return
	end
	--print("------------------》lastActiveCsdName")
	--print(lastActiveCsdName)
	local nodes = g_worldview.worldCityMgr:getLeagueBoundryNode(csdName,lastActiveCsdName)
	local pixel = worldConst:convertCityId2Pix(dstCityId)

	local parent = self.upEffectNode
	if lastActiveCsdName == csdName or csdName == "" then
		parent = nil
	end
	g_worldview.worldCityMgr:updateNodePos(nodes,pixel,parent)
	lastActiveCsdName = csdName
	lastCityId = dstCityId
end

function UIMapPanel:addMapObj(data)


	local worldCityMgr = g_worldview.worldCityMgr
	
	local city = nil

	global.funcGame:printContentTime("startAdd")

	if data.waitType == "cityNode" then

		city = worldCityMgr:getCity()		
		city:setData(data.data)

		local point = g_worldview.worldCityMgr:getPoint(city:getType(),city:getAvatarType(),city:isEmpty())
		local miniMap = g_worldview.worldPanel.miniMap
		city:bindPointSprite(point)		
		
		point:setPosition(cc.p(city:getPositionX() * miniMap:getMinimapScale(),city:getPositionY() * miniMap:getMinimapScale()))
		miniMap:getParentNode():addChild(point)

		self:checkShowLeagueBoundry(city)
	elseif data.waitType == "wildObjNode" then
	
		local designerData = luaCfg:get_wild_monster_by(data.lKind)
		local surfaceData = {}
		if designerData then
			surfaceData = luaCfg:get_world_surface_by(designerData.file) or {}
		end
		city = worldCityMgr:getWildObj(surfaceData.worldmap)
		city:setData(data.data)
	elseif data.waitType == "wildResNode" then							

		city = worldCityMgr:getWildRes()
		city:setData(data.data)

		if city:isMiracle() then

			local point = g_worldview.worldCityMgr:getPoint(city:getType(),city:getAvatarType(),false)
			local miniMap = g_worldview.worldPanel.miniMap
			city:bindPointSprite(point)		
			
			point:setPosition(cc.p(city:getPositionX() * miniMap:getMinimapScale(),city:getPositionY() * miniMap:getMinimapScale()))
			miniMap:getParentNode():addChild(point)
		end
	end

	if city then

		data.parent = data.parent or self.mapObjNode
		data.parent:addChild(city)

		if data.areaCache then
			table.insert(data.areaCache,city)					
		end	
		

		global.funcGame:printContentTime("startAdd end")

		return city
	end	
end

function UIMapPanel:loopAddChild()

	if not self.preResList then return end --如果没有预加载队列，则退出

	-- local childrens = self:getAllCitys()
	-- for _,v in ipairs(childrens) do

	-- 	local pos = global.g_worldview.const:convertMapPos2Screen(cc.p(v:getPosition()))
	-- 	print(v:getName(),pos.x,pos.y)
	-- end

	local isAdded = false
	for _,v in ipairs(self.preResList) do

		local list = self.waitChildList[v.x][v.y]
		
		if #list ~= 0 then

			isAdded = true
			local min = math.min(#list,1)
			for i = 1,min do

				local waitInfo = list[1]

				local contentTime = global.dataMgr:getServerTime()	 
	
				self:addMapObj(waitInfo)

				table.remove(list,1)
			end
		end		
	end

	if self.isStartAddChild and not isAdded then
		
		-- print(">>>done start add child")
			
		gevent:call(global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE)

		self.isStartAddChild = false

		local worldPanel = g_worldview.worldPanel

		if worldPanel.loadDoneCallBack then 
			worldPanel:loadDoneCallBack()
			worldPanel.loadDoneCallBack = nil
		end

		if worldPanel:getIsLineMap() then
			g_worldview.worldPanel:drawMap()
		end
	end 	
end

function UIMapPanel:stopAddChild( areaX,areaY )
	
	local list = self.waitChildList[v.x][v.y]
	local worldCityMgr = g_worldview.worldCityMgr
	for _,v in ipairs(list) do

		worldCityMgr:removeCityWithNoParent(v.child)		
	end
end

--联网获取city数据以获取city
function UIMapPanel:waitGPSCity(cityID,callBack)
	

end

function UIMapPanel:createWildObjs(index,data,isNeedClean)
	--print("#############UIMapPanel:createWildObjs(index,data,isNeedClean)"..vardump(index))
	self.cityArea[index.x][index.y].wildObj = self.cityArea[index.x][index.y].wildObj or {}
	local contentArea = self.cityArea[index.x][index.y].wildObj

	if #contentArea ~= 0 then

		if isNeedClean then

			for _,v in ipairs(contentArea) do
				for _,dv in ipairs(data) do
					-- log.debug(v.id .. " " .. dv.id)
					if v.data.lMonsterID == dv.lMonsterID then
						v:setData(dv)
					end
				end								
			end

			return
		else

			return
		end
	end
	
	for _,v in ipairs(data) do
		--------------
		-- local city = g_worldview.worldCityMgr:getWildObj()		
		-- city:setData(v)
		-- self.wildObjNode:addChild(city)
		-- table.insert(contentArea,city)
		--print("lMonsterID="..v.lMonsterID)
		self:startAddChild(index.x, index.y, self.mapObjNode, v,contentArea,"wildObjNode")
		----------
	end
end

function UIMapPanel:addWildObj(index,data)
	self.cityArea[index.x][index.y].wildObj = self.cityArea[index.x][index.y].wildObj or {}
	local contentArea = self.cityArea[index.x][index.y].wildObj

	--------------
	local city = g_worldview.worldCityMgr:getWildObj()		
	city:setData(data)
	self.mapObjNode:addChild(city)
	table.insert(contentArea,city)
	----------
	return city
end

function UIMapPanel:removeWildObj(index,city)
	local contentArea = self.cityArea[index.x][index.y].wildObj or {}
	--------------
	for i,v in ipairs(contentArea) do
		if v:isMe(city:getId()) then
			table.remove(contentArea,i)
			break
		end
	end
	g_worldview.worldCityMgr:removeWildObj(city)
	----------
end

function UIMapPanel:getCityIdByWaitMode(data)
	
	if data.waitType == "wildResNode" then

		return data.data.lResID
	elseif data.waitType == "cityNode" then

		return data.data.id
	elseif data.waitType == "wildObjNode" then	

		return data.data.lMonsterID
	end
end

function UIMapPanel:getCityId(data)
	local lCityId = data.lCityId
    if data.lWildKind and lWildKind == 1 then
    	lCityId = data.lResID
    elseif data.lWildKind and lWildKind == 2 then
    	lCityId = data.lMonsterID
    end

    return lCityId
end

function UIMapPanel:getCityByIdForAll(lCityId,lWildKind)
	
	print(lCityId,lWildKind,">>>>>>>>>>>>>function UIMapPanel:getCityByIdForAll(lCityId,lWildKind)")
	local city = nil
	if not lWildKind or lWildKind <= 0 then
		city = self:getCityById(lCityId)
	else
		if lWildKind == 1 then
			city = self:getWildResById(lCityId)
		else
			city = self:getWildObjById(lCityId)
		end
	end
	return city
end

-- function UIMapPanel:getAllCitys()
-- 	local citys = self.cityNode:getChildren()
-- 	return citys
-- end

function UIMapPanel:getAllCitysAndMiracle()
	
	local objs = self.mapObjNode:getChildren()
	local res = {}
	for _,v in ipairs(objs) do
	
		if v.isCity then

			table.insert(res,v)
		end

		if v.isWildRes and v:isMiracle() then
			
			table.insert(res,v)
		end
	end

	return res
end

function UIMapPanel:getFarestVillage()
	
	local allCitys = self:getAllCitys()
	local mainCityPos = global.userData:getMainCityPos()
	local maxDis = -1
	local resId = allCitys[1]:getId()

	for _,v in ipairs(allCitys) do

		local pos = cc.p(v:getPosition())
		local dis = cc.pGetDistance(mainCityPos,pos)

		if v:getType() == 0 then
			if maxDis == -1 or dis > maxDis then

				maxDis = dis
				resId = v:getId()
			end
		end
	end

	return resId
end

function UIMapPanel:getAllCitys()
	
	local objs = self.mapObjNode:getChildren()
	local res = {}
	for _,v in ipairs(objs) do
	
		if v.isCity then

			table.insert(res,v)
		end
	end

	return res
end

function UIMapPanel:getAllWildRes()

	local objs = self.mapObjNode:getChildren()
	local res = {}
	for _,v in ipairs(objs) do
	
		if v.isWildRes then

			table.insert(res,v)
		end
	end

	return res	
end

function UIMapPanel:getAllWildObj()

	local objs = self.mapObjNode:getChildren()
	local res = {}
	for _,v in ipairs(objs) do
	
		if v.isWildObj then

			table.insert(res,v)
		end
	end

	return res	
end

function UIMapPanel:getCityByTag(tag)
	
	local children = self:getAllCitysAndMiracle()
	for _,v in ipairs(children) do
		
		if v:getTag() == tag then

			return v
		end
	end

	return nil
end

function UIMapPanel:getWildResById(lResID)
	
	local i,j = global.g_worldview.mapInfo:decodeId(lResID)
	self:checkNeedAddImmediately(i,j,lResID)

	local citys = self:getAllWildRes()
	for i,v in ipairs(citys) do

		if v:isMe(lResID) then
			return v
		end
	end
	return nil
end

function UIMapPanel:getWildObjById(lMonsterID)
	
	local i,j = global.g_worldview.mapInfo:decodeId(lMonsterID)
	self:checkNeedAddImmediately(i,j,lMonsterID)

	local citys = self:getAllWildObj()
	for i,v in ipairs(citys) do
		if v:isMe(lMonsterID) then
			return v
		end
	end
	return nil
end

function UIMapPanel:getDirectorPos(mainCityPos)

	-- dump(mainCityPos)

	local top = 100
	local buttom = 145

	if mainCityPos.x == 0 and mainCityPos.y == 0 then

		return false
	end

	if g_worldview.worldPanel:getIsLineMap() then

		top = 0
		buttom = 0
	end

	local getPoint = function(p1,p2)
	
		local point = cc.pGetIntersectPoint(p1,p2,cc.p(screen_width / 2,screen_height / 2),mainCityPos)
		if cc.pIsSegmentIntersect(p1,p2,cc.p(screen_width / 2,screen_height / 2),mainCityPos) then

			return point
		end

		return false
	end

	local point = getPoint(cc.p(0,buttom),cc.p(screen_width,buttom))
	if point ~= false then

		return point
	end

	local point = getPoint(cc.p(screen_width,buttom),cc.p(screen_width,screen_height - top))
	if point ~= false then

		return point
	end

	local point = getPoint(cc.p(screen_width,screen_height - top),cc.p(0,screen_height - top))
	if point ~= false then

		return point
	end

	local point = getPoint(cc.p(0,screen_height - top),cc.p(0,buttom))
	if point ~= false then

		return point
	end

	return false
end

function UIMapPanel:initTouch()

    local  listener = cc.EventListenerTouchOneByOne:create()

    -- listener:setEnabled(false)

    local touchNode = cc.Node:create()
    touchNode:setLocalZOrder(0)
    self:addChild(touchNode)

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.touchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.touchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self.touchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
	
end

function UIMapPanel:touchBegan(touch,event)
	
	if g_worldview.worldPanel then 
	    g_worldview.worldPanel.gpsTarget = nil
    end

	self.isMoved = false
	return true
end

function UIMapPanel:touchMoved(touch,event)
	
	self.isMoved = true
end

function UIMapPanel:closeChoose(isInEnd)

	if tolua.isnull(self.choose) then
		self.choose = nil
	end
	
	if self.choose ~= nil then

		self.choose:close(isInEnd)
		self.choose = nil
	end	
end

function UIMapPanel:isCityInBattle(cityId)
	
	local armyChild = self.battleNode:getChildren()
	for _,v in ipairs(armyChild) do

		if v.data.lTarget == cityId and not v.isRemove then

			print("----------if v.data.lTarget == cityId and not v.isRemove then")
			return true
		end
	end

	return false
end

function UIMapPanel:getAttackEffectNodeByTroopId(id)
	
	local armyChild = self.battleNode:getChildren()
	for _,v in ipairs(armyChild) do

		if v:getTag() == id then

			return v
			-- v:runAction(cc.RemoveSelf:create())
		end
	end
end

function UIMapPanel:getTroop(id)
	
	local armyChild = self.armyNode:getChildren()
	for _,v in ipairs(armyChild) do

		if v:getTag() == id and v.isSoldier and not v.isRemove then

			return v
		end
	end
end

function UIMapPanel:removeAllLine()
	
	local aboutLinesNode = {"armyNode","wayNode","attackEffectNode","battleNode"}

	for _,v in ipairs(aboutLinesNode) do

		local childs = self[v]:getChildren()
		for _,v in ipairs(childs) do

			if v:getTag() == troopId then

				v.isRemove = true
				v:runAction(cc.RemoveSelf:create())
				-- v:removeFromParent()
			end
		end	
	end

end

function UIMapPanel:removeLine(troopId)
	
	local aboutLinesNode = {"armyNode","wayNode","attackEffectNode","battleNode"}

	local isGPS = false
	local isLineVisiable = false	
	local gpsTarget = g_worldview.worldPanel.gpsTarget

	for _,v in ipairs(aboutLinesNode) do

		local childs = self[v]:getChildren()
		for _,v in ipairs(childs) do

			if v:getTag() == troopId then

				if v == gpsTarget then

					isGPS = true				
				end

				if v.isSoldier then
					if not tolua.isnull(v.line) then
						isLineVisiable = v.line:isVisible()
					end
				end

				v.isRemove = true

				v:runAction(cc.RemoveSelf:create())				
			end
		end	
	end

	return isGPS,isLineVisiable

	-- local armyChild = self.armyNode:getChildren()
	-- for _,v in ipairs(armyChild) do

	-- 	if v:getTag() == troopId then

	-- 		v:runAction(cc.RemoveSelf:create())
	-- 	end
	-- end

	-- local wayChild = self.wayNode:getChildren()
	-- for _,v in ipairs(wayChild) do

	-- 	if v:getTag() == troopId then

	-- 		v:runAction(cc.RemoveSelf:create())
	-- 	end
	-- end

	-- self.armyNode:removeChildByTag(troopId)
	-- self.wayNode:removeChildByTag(troopId)
end

function UIMapPanel:isTroopLive(troopId)
	
	local res = self.armyNode:getChildByTag(troopId) ~= nil
	return res
end

-- function UIMapPanel:attack(line,startTime,endTime,troopId)
    
-- 	local sp = UISoldiersLine.new()

-- 	local contentTime = global.dataMgr:getServerTime()
-- 	local time = endTime - contentTime	

-- 	local allLen = g_worldview.attackMgr:getLineLength(line)

-- 	local goLen = (contentTime - startTime) / (endTime - startTime) * allLen

-- 	sp:setPosition(line[1])
-- 	sp:setTag(troopId)
-- 	self.armyNode:addChild(sp)

-- 	local lineMove = LineMoveControl.new():startMove(sp,line,endTime,allLen,goLen)
-- 	lineMove:setTag(troopId)
-- 	self.wayNode:addChild(lineMove)

-- 	local isCalled = false

-- 	return sp
-- end

function UIMapPanel:touchEnded(touch,event)

	if g_worldview.worldPanel:getIsLineMap() then

		return
	end

	if global.disableButton then
		return
	end

	if self.isMoved then

		local dis = cc.pGetDistance(touch:getStartLocation(), touch:getLocation())

		if dis > 20 then
			self:closeChoose()
			return
		end
	end

	local scale = global.panelMgr:getPanel("UIWorldPanel").m_scrollView:getZoomScale()

	local panelX = -self.panelTruePos.x + screen_width / 2
	local panelY = -self.panelTruePos.y + screen_height / 2

	local touchPos = touch:getLocation()	
	local moveLen = cc.pGetLength(cc.pSub(touch:getStartLocation(),touchPos))

	-- if g_worldview.is3d then

	-- 	local afterPos = touchPos--g_worldview.worldPanel.m_scrollView:convertToNodeSpace(touchPos)

	-- 	if afterPos.y > screen_height / 2 then

	-- 		afterPos.y = (afterPos.y - screen_height / 2) * 1.35 + screen_height / 2		
	-- 	else

	-- 		afterPos.y = (afterPos.y - screen_height / 2) * 0.9 + screen_height / 2		
	-- 		-- afterPos.y = (afterPos.y - screen_height / 2) * 1.35 + screen_height / 2		
	-- 	end		

	-- 	if false then

	-- 		 local touchSp = cc.Sprite:create()
	-- 		touchSp:setSpriteFrame("ui_surface_icon/mini_b.png")
	-- 		self.effectNode:addChild(touchSp)

	-- 		touchSp:setPosition(g_worldview.const:convertScreenPos2Map(afterPos)) 
	-- 	end
	-- end	

	if moveLen > 20 then

		return
	end	

	-- local touchNodes = {"armyNode","cityNode","wildResNode","wildObjNode"}
	local touchNodes = {"armyNode","mapObjNode"}

	local minZ = nil
	local minTag = nil

	for _,v in ipairs(touchNodes) do

		local children = self[v]:getChildren()

		for k, city in ipairs(children) do						

			if CCHgame:isNodeBeTouch(city,city:getRect(),touchPos) then

				if global.guideMgr:isPlaying() then

					local curStep = global.guideMgr:getCurStep()		
					
					if curStep == luaCfg:get_guide_stage_by(8).Key or curStep == luaCfg:get_guide_stage_by(7).Key then

						-- print(global.guideMgr:getStepArg(),city:getId())
						if global.guideMgr:getStepArg() == city:getId() then

							minZ = 999998
							minTag = city							
						end
					else

						if minZ == nil or city:getLocalZOrder() > minZ then

							minZ = city:getLocalZOrder()
							minTag = city
						end
					end
				else

					if minZ == nil or city:getLocalZOrder() > minZ then

						minZ = city:getLocalZOrder()
						minTag = city
					end	
				end				
			end

			-- if cc.rectContainsPoint(city:getTouchRect(panelX,panelY),touchPos) then			

				
			-- end
		end
	end	

	if minTag then
		
		local city = minTag

		if city.isResType and city:isResType() then

			if city:getType() > 100 then
				self:chooseObject(city)
			else
				city:openPanel()
				self:closeChoose()
			end			
		elseif city.isObjType and city:isObjType() then
			city:openPanel()
			self:closeChoose()
		else
			self:chooseObject(city)
		end

		self.contentChooseName = city:getName()

		return
	end

	self:closeChoose()
end

function UIMapPanel:getContentChooseName()
	
	return self.contentChooseName
end

function UIMapPanel:chooseObject(obj,isHideSound)

	print(">>>>>>>>>>>>>.function UIMapPanel:chooseObject(obj)")

	if not UICityChoose.checkIsHavaBtn(obj) then -- which mean this is a 村庄,temp 处理

		

		-- global.worldApi:getMonsterTownInf(obj:getId(),function(msg)
			
		-- 	dump(msg)
		-- end)
		-- global.tipsMgr:showWarning("NotOpen")
		return
	end



	if self.preChooseCity == obj then 

		self.preChooseCity = nil
		self:closeChoose()
		return
	else

		self.preChooseCity = nil
		self:closeChoose(true)
	end

	self.choose = UICityChoose.new(obj)	
	if not tolua.isnull(self.choose) then

		self.uiNode:addChild(self.choose)
		self.choose:setCity(obj,isHideSound)
		self.choose:setPosition(obj:getPosition())
		if not obj.isSoldier then
			self.choose:checkOutScreen(self)
		end
	end

	self.preChooseCity = obj
end

function UIMapPanel:checkDirector(panelX,panelY)
	
	local mainCityPos = self:getMainCityPos(panelX, panelY)
	local directorPos = self:getDirectorPos(mainCityPos)

	local dtPos = cc.pSub(mainCityPos,cc.p(screen_width / 2,screen_height / 2))
	local angle = cc.pToAngleSelf(dtPos) / 3.14 * -180
	local len = cc.pGetLength(dtPos)

	local worldPanel = global.panelMgr:getPanel("UIWorldPanel")

	if worldPanel then

		worldPanel.directorButton:setDirectorPosAndAngle(directorPos,angle,len,worldPanel:getIsLineMap())
	end
end

function UIMapPanel:checkMinimap(panelX,panelY)
	
	local worldPanel = global.panelMgr:getPanel("UIWorldPanel")

	if worldPanel then
		worldPanel.miniMap:setPos(cc.p(panelX,panelY))
	end
end

function UIMapPanel:checkLocation(panelX,panelY)
	
	local worldPanel = global.panelMgr:getPanel("UIWorldPanel")

	if worldPanel then
		worldPanel.locationInfo:setPos(cc.p(panelX,panelY))
	end
end

function UIMapPanel:cleanBuildOutScreen(panelX,panelY)

	self.panelTruePos = cc.p(panelX,panelY)

	-- print("start check build")

	-- local screenRect = cc.rect(-200,-200,gdisplay.width + 200,gdisplay.height + 200)
	-- if self.preResList then
		
	-- 	for _,v in ipairs(self.preResList) do

	-- 		local list = self.waitChildList[v.x][v.y]
			
	-- 		for _,v in ipairs(list) do

	-- 			local pos = cc.p(v.data.lPosX or v.data.x,v.data.lPosY or v.data.y)
	-- 			local screenPos = global.g_worldview.const:convertMapPos2Screen(pos)
	-- 			if CCHgame:isRectContainsPoint(screenRect,screenPos) then
			    	
	-- 		    	print("this one is in screen")
	-- 		    	break
	-- 		    end
	-- 		end
	-- 	end
	-- end	

	-- local children = self.cityNode:getChildren()

	-- log.debug(#children)


	-- for k, city in ipairs(children) do

	-- 	city:setScreenPos(cc.p(-panelX + screen_width / 2,-panelY + screen_height / 2))
 --    end

 --    local city = self.mainCity

	-- city:setScreenPos(cc.p(-panelX + screen_width / 2,-panelY + screen_height / 2))
end

return UIMapPanel

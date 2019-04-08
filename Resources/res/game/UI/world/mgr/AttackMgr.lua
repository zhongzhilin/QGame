

-- local resMgr = global.resMgr

-- local uiMgr = global.uiMgr

local g_worldview = global.g_worldview
local AttackMgr = class("AttackMgr")
local UIBagItem =  require("game.UI.bag.UIBagItem")
local UISoldiersLine = require("game.UI.world.widget.UISoldiersLine")
local LineMoveControl = require("game.UI.world.utils.LineMoveControl")
local g_worldview = nil
local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr

AttackMgr.CONST = {

	HOLD_STATE = 10,
	ON_ATTACK = 11,
	GOTO_ATTACK = 1,
	BACK_CITY = 2,
	ARRIVE_CITY = 99,
	STAY_STATE = 6,
	HELP_STATE = 5,
	REVOLT_STATE = 12,
}

AttackMgr.ATTACK_TYPE = {

	ATTACK_CITY =  1,--攻城
	NORMAL_ATTACK = 2,--进攻
	LOOK_ATTACK = 3,
	LUEDUO_ATTACK = 6,
	HELP_ATTACK = 4,--驻防
	REVOLT_ATTACK = 7,
	TRANSFER_RES_ATTACK = 11,--运输资源
}

AttackMgr.ATT_TROOP_INFO = {

	[AttackMgr.CONST.GOTO_ATTACK] = {

		[AttackMgr.ATTACK_TYPE.NORMAL_ATTACK] = 1,
		[AttackMgr.ATTACK_TYPE.LUEDUO_ATTACK] = 2,
		[AttackMgr.ATTACK_TYPE.ATTACK_CITY] = 3,
		[AttackMgr.ATTACK_TYPE.HELP_ATTACK] = 4,
		[AttackMgr.ATTACK_TYPE.LOOK_ATTACK] = 5,
		[AttackMgr.ATTACK_TYPE.TRANSFER_RES_ATTACK] = 23,
	},

	[AttackMgr.CONST.ON_ATTACK] = {

		[AttackMgr.ATTACK_TYPE.NORMAL_ATTACK] = 6,
		[AttackMgr.ATTACK_TYPE.LUEDUO_ATTACK] = 7,
		[AttackMgr.ATTACK_TYPE.ATTACK_CITY] = 8,
		[AttackMgr.ATTACK_TYPE.REVOLT_ATTACK] = 20,
	},
	[AttackMgr.CONST.BACK_CITY] = {},
	[AttackMgr.CONST.REVOLT_STATE] = {},
	[AttackMgr.CONST.HOLD_STATE] = {
		[AttackMgr.ATTACK_TYPE.HELP_ATTACK] = 4,
	}
}

setmetatable(AttackMgr.ATT_TROOP_INFO[AttackMgr.CONST.BACK_CITY],{__index = function(t,k)
	
	return 18
end})

setmetatable(AttackMgr.ATT_TROOP_INFO[AttackMgr.CONST.REVOLT_STATE],{__index = function(t,k)
	
	return 19
end})

AttackMgr.DEF_TROOP_INFO = {
	
	[AttackMgr.CONST.GOTO_ATTACK] = {

		[AttackMgr.ATTACK_TYPE.NORMAL_ATTACK] = 10,
		[AttackMgr.ATTACK_TYPE.LUEDUO_ATTACK] = 11,
		[AttackMgr.ATTACK_TYPE.ATTACK_CITY] = 12,
		[AttackMgr.ATTACK_TYPE.HELP_ATTACK] = 13,
		[AttackMgr.ATTACK_TYPE.LOOK_ATTACK] = 14,
	},
	[AttackMgr.CONST.ON_ATTACK] = {

		[AttackMgr.ATTACK_TYPE.NORMAL_ATTACK] = 15,
		[AttackMgr.ATTACK_TYPE.LUEDUO_ATTACK] = 16,
		[AttackMgr.ATTACK_TYPE.ATTACK_CITY] = 17,
		[AttackMgr.ATTACK_TYPE.REVOLT_ATTACK] = 22,
	},

	[AttackMgr.CONST.BACK_CITY] = {},
	[AttackMgr.CONST.REVOLT_STATE] = {},
}

setmetatable(AttackMgr.DEF_TROOP_INFO[AttackMgr.CONST.BACK_CITY],{__index = function(t,k)
	return 18
end})

setmetatable(AttackMgr.DEF_TROOP_INFO[AttackMgr.CONST.REVOLT_STATE],{__index = function(t,k)
	return 21
end})

function AttackMgr.showRes( data )

-- 	message NotifyFightResult

-- {

-- 	required int32		lParty 	= 1;	//0：进攻方  1：防御方

-- 	required int32		lPurpose	= 2;	//

-- 	required int32		lResult 	= 3;	//1：进攻方胜利  2：防御方胜利

-- 	optional string		szDstName	= 4;	//目标名字

-- }



	local pur_strs = {

		[AttackMgr.ATTACK_TYPE.NORMAL_ATTACK] = 10124,
		[AttackMgr.ATTACK_TYPE.LUEDUO_ATTACK] = 10126,
		[AttackMgr.ATTACK_TYPE.ATTACK_CITY] = 10125,
		[AttackMgr.ATTACK_TYPE.HELP_ATTACK] = 10096,
		[AttackMgr.ATTACK_TYPE.LOOK_ATTACK] = 10229,
		[AttackMgr.ATTACK_TYPE.REVOLT_ATTACK] = 10210,
	}

	local funcGame = global.funcGame
	data.szDstName = funcGame:translateDst(data.szDstName, data.lDstType, data.lTarget)

	local purStr = luaCfg:get_local_string(pur_strs[data.lPurpose])
	if data.lParty == 1 then
		purStr = luaCfg:get_local_string(10127)
	end
	local isWin = (data.lParty == 0) == (data.lResult == 1)
	local winStr = "nil"
	local res = ''
	if data.lDstType == 13 then
		isWin = false
		res = string.format(luaCfg:get_errorcode_by("worldBoss04").text, data.szDstName)
	else
		if isWin then winStr = luaCfg:get_local_string(10227) else winStr = luaCfg:get_local_string(10228) end
		res = string.format(luaCfg:get_errorcode_by("BattleEnd").text, data.szDstName,purStr,winStr)	
	end	

	local curStep = global.guideMgr:getCurStep() or 0
	-- local isSpGuide = global.guideMgr:isPlaying() and (curStep <= 901)
	-- local isQGuide  = global.guideMgr:isPlaying() and (global.guideMgr:getCurGuideType() == 1)

	print("  ===> show result curStep： " .. curStep)
	print(global.guideMgr:isPlaying())

	local isNotShow = global.guideMgr:isPlaying() and (curStep ~= 1001)
	if isNotShow or (global.guideMgr:isPlaying() and global.guideMgr:getCurGuideType() ~= 0) then
	else

		print(global.guideMgr:getCurGuideType())
		-- 战斗errorcode显示 
		if data.szFightID and data.szFightID ~= "" then

			dump(data, "=========> battle errorcode: ")
			data.tagItems = data.tagItems or {}
			local tempItem = {}
			for _,v in pairs(data.tagItems) do
				local temp = {[1]=0, [2]=0}
				temp[1] = v.lID
				temp[2] = v.lCount
				table.insert(tempItem, temp)
			end

			if global.panelMgr:getTopPanelName() == 'UIWorldPanel' and isWin then
				local winEffect = WidgetExtend.extend(resMgr:createCsbAction('effect/battle_win_fail', 'animation0', false))			
				winEffect:setPosition(cc.p(gdisplay.width / 2,gdisplay.height / 2 + 200))
	   			global.scMgr:CurScene():addChild(winEffect, 31)

	   			winEffect:setNodeEventEnabled(true)
	   			winEffect:addEventListener(global.gameEvent.EV_ON_PANEL_OPEN,function(_,name)
        			print('...panel opend name:',name)
        			if name ~= 'UIBattleErrorcodeNo' and name ~= 'UIBattleErrorcode' and name ~= 'UIGuidePanel' and name ~= 'ConnectingPanel' then
        				winEffect:setVisible(false)
        			end        			
			    end)
			end			

			global.tipsMgr:showBattleErrorcode({titleStr=res, reportId=data.szFightID, tagItem=tempItem})			
		else
			global.tipsMgr:showWarningText(res)
		end
	end
end

function AttackMgr:ctor()

	g_worldview = global.g_worldview
	self.scheduleListenerId = gscheduler.scheduleGlobal(function()

	    self:troopCheck()
	    self:troopDataCache()
	end, 0.2)

	self.troopCheckList = {}
	self.troopDataQuery = {}
	self.troopSpeedUp = {}
end

--由于一个个查询部队数据在部队很多的时候会有很大的网络压力，所以弄一个缓存池
function AttackMgr:troopDataCache()

	if #self.troopDataQuery > 0 then

		-- print(">>> self troop data quert")
		global.worldApi:getTroopsData(self.troopDataQuery, function(msg)

			-- print(">>> self troop data quert end")	
			msg.lTroopInfo = msg.lTroopInfo or {}
			for _,v in ipairs(msg.lTroopInfo) do

				self:showAttackLine(v)
			end			
		end)

		self.troopDataQuery = {}
	end
end

--由于超出屏幕的troop不会拿到状态变更的推送，所以现在一旦超出屏幕则释放该部队
function AttackMgr:troopCheck()

	local contentTime = global.dataMgr:getServerTime()
	local mapPanel = g_worldview.mapPanel

	for id,v in pairs(self.troopCheckList) do

		if v + 1 < contentTime then

			self:removeTroop(id)
		end
	end
end

function AttackMgr:addAttack(data)

    local troopInfo = data.tagTroop    
    for _,v in ipairs(troopInfo) do

    	self:dealAttack(v)
    end
end

function AttackMgr:closeSchedule()
	
	if self.scheduleListenerId then
		gscheduler.unscheduleGlobal(self.scheduleListenerId)
	end
end

function AttackMgr:removeTroop(id)
	--print(debug.traceback())

	local mapPanel = g_worldview.mapPanel
	local lineViewMgr = g_worldview.lineViewMgr

	self.troopCheckList[id] = nil
	lineViewMgr:removeLine(id)
	mapPanel:removeLine(id)
end

function AttackMgr:showAttackLine(v)

	--当部队不处于当前屏幕时，只加载路线
	-- dump(v,'show attack line')

	if v.lID == nil then return end
	if v.lWildKind ~= 0 then return end

	local worldPanel = g_worldview.worldPanel
    local _lID = v.lID
	local lineViewMgr = g_worldview.lineViewMgr

    self.troopCheckList[_lID] = v.lAttackEndTime

    if v.lCityUniqueId then

		v.lCityUniqueId = table.reverse(v.lCityUniqueId)
	end

    local lRes = v.lCityUniqueId

	local cityId = v.lTarget

    if not cityId or state == AttackMgr.CONST.HOLD_STATE or state == AttackMgr.CONST.STAY_STATE or state == AttackMgr.CONST.HELP_STATE then return end 
    local mainId = worldPanel.mainId	

    local isWild = false
    if v.lWildKind and v.lWildKind > 0 then
    	isWild = true
    end

    if mainId == cityId or v.lUserID == global.userData:getUserId() or isWild then
    	isNeedCare = true
    end

    if not(not lRes or #lRes <= 1) then
        lineViewMgr:addLine(lRes, isNeedCare, _lID)
    end 
end

function AttackMgr:decodeLine(v)

    local lRes = v.lCityUniqueId
    if not lRes or #lRes <= 1 then

        return {}
    end 

    local lWildKind = v.lWildKind
    local line = {}
    local mapInfo = g_worldview.mapInfo

    for i = 1, #lRes - 1 do

        local i1,j1,bd1,isLink1 = mapInfo:decodeId(lRes[i])
        local i2,j2,bd2,isLink2 = mapInfo:decodeId(lRes[i + 1])
        if isLink1 then
            i1 = i2
            j1 = j2
        end

        local mapPos1 = mapInfo:getMapPos(i1, j1)

        --野地资源据点队列路径直线处理
        local polylinePoints = {}

        if lWildKind and lWildKind > 0 then

            -- log.debug("###############i1=%s, j1=%s,bd1=%s,isLink1=%s, i2=%s, j2=%s,bd2=%s,isLink2=%s",i1, j1,bd1,isLink1,i2, j2,bd2,isLink2)
            local mapPos1 = mapInfo:getMapPos(i1, j1)
            local mapPos2 = mapInfo:getMapPos(i2, j2)
            --先取wildData的数据，如果取不到，则认为不是野地据点，则去pointdata中取

            local tmxPos2 = mapInfo.wildData[bd2] or mapInfo.pointData[bd2]
            local tmxPos1 = mapInfo.wildData[bd1] or mapInfo.pointData[bd1]            

            -- print("##############"..vardump(mapInfo.pointData[bd1]))
            table.insert(line,cc.p(tmxPos2.x + mapPos2.x,tmxPos2.y + mapPos2.y))
            table.insert(line,cc.p(tmxPos1.x + mapPos1.x,tmxPos1.y + mapPos1.y))
            -- dump(line,"line")

            local tempP = cc.pSub(line[2],line[1])
            local len = cc.pGetLength(tempP)
            local allLine = math.floor(len / 1300)
            if allLine < 10 then
            	allLine = math.floor(len / 100)
            end

            local resLine = {}
            for i = 0,allLine do
                local pen = i / allLine
                local penPos = cc.p(tempP.x * pen + line[1].x,tempP.y * pen + line[1].y)
                table.insert(resLine,penPos)
            end
            -- dump(resLine,"resLine")
            line = resLine
        else

            polylinePoints = mapInfo.wayData[bd1][bd2]
            for _,vv in ipairs(polylinePoints) do
                table.insert(line,cc.p(vv.x + mapPos1.x,vv.y + mapPos1.y))
            end    
        end
    end

    return line
end

function AttackMgr:dealAttack(v)
	--print(debug.traceback())
	--dump(v,"a###############")

	if v.lID == nil then return end

	local worldPanel = g_worldview.worldPanel or {}
	local mapPanel = g_worldview.mapPanel  or {}           
    local mainId = worldPanel.mainId	

	local lAttackType = v.lAttackType
	local lWildKind = v.lWildKind
    local speed = v.lSpeed
    local state = v.lState

    local _lAttackStartTime = v.lAttackStartTime
    local _lAttackEndTime = v.lAttackEndTime
    local _lID = v.lID
    local contentTime = global.dataMgr:getServerTime()
    local isNeedCare = false
	local cityId = v.lTarget
	local lineViewMgr = g_worldview.lineViewMgr

	if v.lCityUniqueId then
		v.lCityUniqueId = table.reverse(v.lCityUniqueId)
	end

    local lRes = v.lCityUniqueId
    if not mapPanel.removeLine then 
    	-- protect 
    	return 
    end 
    local isGPS,isLineVisiable = mapPanel:removeLine(_lID)
    local isWild = lWildKind and lWildKind > 0

    g_worldview.lineViewMgr:removeLine(_lID)
    self.troopCheckList[_lID] = nil

	if mainId == cityId or v.lUserID == global.userData:getUserId() or isWild then
    	isNeedCare = true
    end --如果被攻击城市或者部队是自己的

    if not cityId or state == AttackMgr.CONST.HOLD_STATE or state == AttackMgr.CONST.STAY_STATE or state == AttackMgr.CONST.HELP_STATE then return end 
    self.troopCheckList[_lID] = _lAttackEndTime

	local city = g_worldview.mapPanel:getCityByIdForAll(cityId,lWildKind)--目标点
	local sorceCity = g_worldview.mapPanel:getCityByIdForAll(v.lCityID,lWildKind) --出发点 
	v.szTargetName = v.szTargetName or "未知"

    if state == AttackMgr.CONST.ON_ATTACK then --如果是正在战斗，则进入这个逻辑
		

		if not city then

    		--解决切后台无法创建城池之前，播放攻击动画的bug
    		local mapInfo = global.g_worldview.mapInfo
			local blockId = mapInfo:getBlockIdByUniqueId(cityId)
			local areaX,areaY = global.g_worldview.areaDataMgr:decodeAreaID(blockId)
    		if g_worldview.mapPanel:checkNeedAddImmediately(areaX,areaY,cityId) then

    			city = g_worldview.mapPanel:getCityByIdForAll(cityId,lWildKind)--目标点
    		else
				return
    		end
		end

		if city and city.isWildObj and city:isBoss() then
			return
		end

    	if not g_worldview.mapPanel:isCityInBattle(cityId) then
    		local battleNode = nil
    		if lWildKind and lWildKind > 0 then
    			battleNode = require("game.UI.world.widget.UIBattleNode").new()
    			local isMonster = (lWildKind == 2)
				if isMonster then
					if city and city.changeAttackState then --protect 
						city:changeAttackState()
					end 
				end
    		else

    			battleNode = require("game.UI.world.widget.UIBattleNode").new()
    		end

        	battleNode:setPosition(cc.p(city:getPosition()))
        	battleNode:setTag(_lID)
			g_worldview.mapPanel.battleNode:addChild(battleNode)        	
			battleNode:setData(v)				
    	end	
    	return
    end

    if state == AttackMgr.CONST.ARRIVE_CITY then 
    	return
    end

    local line = self:decodeLine(v)
    if #line <= 1 then return end
    local allLen = self:getLineLength(line)
    local time = _lAttackEndTime - _lAttackStartTime
    local speed = allLen / time / 60
    local attackTime = _lAttackEndTime - contentTime
    local goLen = (contentTime - _lAttackStartTime) / (_lAttackEndTime - _lAttackStartTime) * allLen
	local sp = UISoldiersLine.new(v.isMonster)
	local targetSprite = cc.Sprite:create()

	targetSprite:setSpriteFrame("ui_surface_icon/in_attack.png")
	targetSprite:setPosition(cc.p(line[#line]))
	targetSprite:setTag(_lID)
	mapPanel.attackEffectNode:addChild(targetSprite)
	sp.targetSprite = targetSprite
	targetSprite:setVisible(isNeedCare)
	sp:setPosition(line[1])

	sp:setTag(_lID)
	sp:setData(v)

	sp:setIsNeedCare(isNeedCare)
	mapPanel.armyNode:addChild(sp)
	local lineMove = LineMoveControl.new():startMove(sp,line,_lAttackEndTime,allLen,goLen,isNeedCare,state == AttackMgr.CONST.GOTO_ATTACK,v.lAvator,isWild)
	lineMove:setTag(_lID)

	mapPanel.wayNode:addChild(lineMove)
	if isWild then
		sp.line = lineMove
	else
		-- if not global.isCurveLineShader then
			sp.line = lineViewMgr:addLine(lRes,isNeedCare,_lID)
		-- else
		-- 	sp.line = lineMove
		-- end
	end	
	if isLineVisiable then
		-- print("isLineVisiable true")
	end

	if isGPS then
		worldPanel:chooseSoldier(_lID,nil,true)
		sp:closeChooseOpenAction()
	end

	if isNeedCare == false then

		sp.line:setVisible(isLineVisiable)
		targetSprite:setVisible(isLineVisiable)
	end
end

function AttackMgr:checkIsAttack(data)

	local lPurpose = data.lPurpose
	local state = data.lStatus	

	if (state == AttackMgr.CONST.ON_ATTACK and lPurpose ~= AttackMgr.ATTACK_TYPE.HELP_ATTACK) or state == AttackMgr.CONST.GOTO_ATTACK or state == AttackMgr.CONST.BACK_CITY or state == AttackMgr.CONST.REVOLT_STATE then

		return true
	end 

	return false
end

function AttackMgr:isTroopAleadySpeedUp(id)

	return self.troopSpeedUp[id] ~= 0
end

function AttackMgr:dealAttackBoard(data)
	--dump(data,"#######AttackMgr:dealAttackBoard(data)")

    global.panelMgr:closePanel("UISeeking")
	local mapPanel = g_worldview.mapPanel  
	local worldPanel = g_worldview.worldPanel 
	worldPanel.attactInfoBoard:removeAttactBoard(data.lTroopID,data.lParty)
	if data.lReason == 1 then

		if not worldPanel.attactInfoBoard:isTroopExist(data.lTroopID) then
			self:removeTroop(data.lTroopID)
		end

		return
	end --删除	

	local contentTime = global.dataMgr:getServerTime()
	local attackTime = data.lArrived - data.lStart
	local lPurpose = data.lPurpose
	local state = data.lStatus
	local lWildKind = data.lWildKind
	local attackBoardType = nil
	local funcGame = global.funcGame
	data.szDstName = funcGame:translateDst(data.szDstName, data.lDstType, data.lTarget)
	data.szSrcName = funcGame:translateDst(data.szSrcName, data.lSrcType, data.lCityID)

	self.troopSpeedUp[data.lTroopID] = data.lSpeedUp
	local insertInfo = function(attackType)
		local troop_info_id = nil
		if attackType and  attackType == "attack" then
			troop_info_id = AttackMgr.ATT_TROOP_INFO[state][lPurpose]
		else
			troop_info_id = AttackMgr.DEF_TROOP_INFO[state][lPurpose]
		end
		if troop_info_id then
			-- print("troop_info_id",troop_info_id)
			troop_info = luaCfg:get_troops_info_by(troop_info_id)
			local title_str = string.format(luaCfg:get_local_string(troop_info.txt),data.szDstName or "")
			-- print(title_str,">>>>>>>>>>>>>>>>>title_str",lWildKind)
			worldPanel.attactInfoBoard:insertAttactBoard({
				startTime = data.lStart,
				attackTime = attackTime,
				troopId = data.lTroopID,	
				troopData = data,		
				uiInfo = {title_str = title_str, lWildKind=lWildKind,icon_path = troop_info.worldmap,is_show_speed = (state ~= AttackMgr.CONST.ON_ATTACK) and (state ~= AttackMgr.CONST.REVOLT_STATE) and attackType ~= "def",cityId = data.lDst}
			},attackType)
		end	
	end	

	if data.lParty == 1 then
		insertInfo("attack")
	else
		insertInfo("def")
	end
	self:flushTroops(data.lUserID, data.lTroopID)
end

function AttackMgr:flushTroop(userId,id,callback,isNeedAdd)

	global.worldApi:getTroopData(userId, id, function(msg)

		dump(msg,'flush troop msg')
		
		local preEndTime = self.troopCheckList[id] or 0
		if msg.lTroopInfo and (msg.lTroopInfo[1].lAttackEndTime > preEndTime or isNeedAdd)then			
			self:showAttackLine(msg.lTroopInfo[1])			
			if callback then
				callback()
			end
		end    	
	end)
end

function AttackMgr:flushTroopInstance(userId,id,callback)
	global.worldApi:getTroopData(userId, id, function(msg)
		local preEndTime = self.troopCheckList[id] or 0
		if msg and msg.lTroopInfo then
			local attackTimeOver = (msg.lTroopInfo[1].lAttackEndTime > preEndTime)
			self:dealAttack(msg.lTroopInfo[1])
		end
		if callback then
			callback()
		end    	
	end)
end

function AttackMgr:flushTroops(userId,id)

	table.insert(self.troopDataQuery,userId)
	table.insert(self.troopDataQuery,id)
end

function AttackMgr:addGiftBox(data)

	if not data.tagItems then return end
	local pos = cc.p(data.lX,data.lY)
	local worldPanel = g_worldview.worldPanel
	local mapPanel = g_worldview.mapPanel
	local box = nil
	local boxCall = function(box)

		box.call:setEnabled(false)
    	box.call:setVisible(false)
    	box:stopActionByTag(998)
    	box.timeLine:play("animation2",false)
		box.timeLine:setLastFrameCallFunc(function()
        	box:removeFromParent()
        end)

		gevent:call(gsound.EV_ON_PLAYSOUND,"patch_new_2")

		local allCount = #data.tagItems
        for i,v in ipairs(data.tagItems) do
     	  	
     	  	local id = v.lID
        	local count = v.lCount
        	local itemUI = UIBagItem.new()--resMgr:createWidget("bag/bag_item")
        	itemUI:setData({id = id,count = count})
        	itemUI:setPosition(g_worldview.const:convertMapPos2Screen(pos))
        	itemUI:setLocalZOrder(998)
        	itemUI:setScale(0)
        	worldPanel:addChild(itemUI)

        	itemUI:runAction(cc.Sequence:create(cc.DelayTime:create(0.3 * i),cc.CallFunc:create(function ()
        		
        		gevent:call(gsound.EV_ON_PLAYSOUND,"patch_new_4")

				itemUI:runAction(cc.ScaleTo:create(0.3,1))
	    		itemUI:runAction(cc.EaseIn:create(cc.MoveBy:create(0.3,cc.p(math.random(200) - 200,math.random(80))),2))		
	    		itemUI:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ()

	    			itemUI:runAction(cc.ScaleTo:create(0.5,0))
	    			itemUI:runAction(cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(169,26)),cc.CallFunc:create(function ()

		        		if i == 1 then
		        			worldPanel.bot_ui:PlayBagEffect(0)
		        		end

		        		if i == allCount then
		        			worldPanel.bot_ui:PlayBagEffect(1)
		        		end
		        	end),cc.RemoveSelf:create()))
	    		end)))        		
        	end)))  
        end    	
    end

	box = resMgr:createCsbAction("effect/bigworld_baoxiang", "animation0", false, false, nil, function()
		local delayTime = 6
		local guideData = luaCfg:get_guide_stage_by(6)
		if guideData.Key == global.userData:getGuideStep() then
			delayTime = guideData.data1
		end

		local fadeOutAction = cc.Sequence:create(cc.DelayTime:create(delayTime),cc.CallFunc:create(function()
			boxCall(box)			
		end))

		fadeOutAction:setTag(998)
		box:runAction(fadeOutAction)
		box.timeLine:play("animation1",true)
		box.timeLine:setLastFrameCallFunc(function()               

        end)
	end)

    uiMgr:configUITree(box)    
    uiMgr:addWidgetTouchHandler(box.call, function(sender, eventType)
	    boxCall(box)	
	end)

	box:setPosition(pos)
	if mapPanel and mapPanel.uiNode then 
		mapPanel.uiNode:addChild(box)
	end 
end

function AttackMgr:getLineLength(line)

	local allLen = 0
	for i = 1,#line-1 do
		local p1 = line[i]
		local p2 = line[i + 1]
		local len = cc.pGetLength(cc.p(p1.x - p2.x,p1.y - p2.y))
		allLen = allLen + len
	end

	return allLen
end

return AttackMgr
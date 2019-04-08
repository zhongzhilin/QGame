--region UINotice.lua
--Author : untory
--Date   : 2017/02/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local gameEvent = global.gameEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINotice  = class("UINotice", function() return gdisplay.newWidget() end )

function UINotice:ctor()
    
    
end

function UINotice:CreateUI()
    local root = resMgr:createWidget("common/publice_notice_node")
    self:initUI(root)    
end

function UINotice:onExit()
	
	global.noticeList = self.noticeList

end

function UINotice:testGetNotice(data)
	
	table.insert(self.noticeList,data)
	self:showNext(true)
end

function UINotice:onEnter()

	self.battleInfo = table.get2DimensionTable()

	self.noticeList = global.noticeList or {}		

	self:showNext()

	self:addEventListener(gameEvent.EV_ON_UI_NOTICE_FLUSH,function(event,data)
		if not data.lMapID then 
			-- protect
			return 
		end 
		print(">>>data.lMapID",data.lMapID)
		local noticeData = luaCfg:get_public_notice_by(data.lMapID) or {}
		local times = noticeData.time or 0
		for i = 1,times do
			table.insert(self.noticeList, data)
		end
		
		self:showNext(true)
    end)

    self:addEventListener(gameEvent.EV_ON_GAME_RESUME,function()

    	self:cleanNotice()
    end)
end

function UINotice:cleanNotice()
	
	self.noticeList = {}
	self.notice:stopAllActions()
	self:setScaleY(0)
	self:stopAllActions()
	self.isInShow = false
end

function UINotice:showNext(isInsert)

	if #self.noticeList == 0 then

		self:runAction(cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)))			
	else		

		if not self.isInShow then
		
			if isInsert then
		
				self:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.3,1,1)))			
			end
		
			local noticeData = self.noticeList[1]
			table.remove(self.noticeList,1)

			self:showNoticeText(noticeData)
		end		
	end
end

function UINotice:formatNotice(data)
	
	local noticeData = luaCfg:get_public_notice_by(data.lMapID)
	if not noticeData then return true end

	local worldConst = require("game.UI.world.utils.WorldConst")
	local arg = {}

	dump(data,'>>notice data')

	local typeId = noticeData.typeId
	if typeId == 1 then

		local heroName = luaCfg:get_hero_property_by(tonumber(data.szParams[3])).name
		arg.name = data.szParams[1]
		arg.num = data.szParams[2]
		arg.heroName = heroName
	elseif typeId == 2 then
	elseif typeId == 3 then
		
		local sType = luaCfg:get_all_miracle_name_by(tonumber(data.szParams[4])).name

		arg.union = string.format("【%s】%s",data.szParams[1],data.szParams[2])
		arg.name = data.szParams[3]
		arg.sType = sType	--TODO
	elseif typeId == 4 then
		arg.name = data.szParams[1]
		arg.union = string.format("【%s】%s",data.szParams[2],data.szParams[3])
	elseif typeId == 5 then
		arg.name = data.szParams[1]
		arg.level = data.szParams[2]
	elseif typeId == 6 then
		arg.name = data.szParams[1]
		arg.num = data.szParams[2]
	elseif typeId == 7 then
		
		local count = tonumber(data.szParams[4])
		if count > 100000 then 
			count = 100000
		elseif count > 50000 then
			count = 50000
		else
			count = 10000
		end
		
		if self.battleInfo[tonumber(data.szParams[5])][count] == true then
		
			return false
		else

			self.battleInfo[tonumber(data.szParams[5])][count] = true
		end

		local truePos = worldConst:converPix2Location(cc.p(data.szParams[1],data.szParams[2]))

		arg.castleName = data.szParams[3]
		arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)		
		arg.num = count		
	elseif typeId == 8 then

		arg.Union1Name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
		arg.Union2Name = string.format("【%s】%s",data.szParams[3],data.szParams[4])
	elseif typeId == 9 then

		arg.Union1Name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
		arg.Union2Name = string.format("【%s】%s",data.szParams[3],data.szParams[4])
	elseif typeId == 10 then	

		data.szParams[1] = data.szParams[1] or 0
		local actData = luaCfg:get_activity_by(tonumber(data.szParams[1])) or {}
		arg.activity_name = actData.name or ""
	elseif typeId == 11 then
		
		arg.activity_name = luaCfg:get_activity_by(tonumber(data.szParams[1])).name
	elseif typeId == 12 then

		local sType = luaCfg:get_all_miracle_name_by(tonumber(data.szParams[1])).name
		local truePos = worldConst:converPix2Location(cc.p(data.szParams[2],data.szParams[3]))

		arg.miracleName = sType
		arg.unionName = string.format("【%s】%s",data.szParams[4],data.szParams[5])
		arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)		
		arg.num = data.szParams[6]	--TODO	
	elseif typeId == 26 then

		local count = tonumber(data.szParams[4])
		if count > 100000 then 
			count = 100000
		elseif count > 50000 then
			count = 50000
		else
			count = 10000
		end
		
		if self.battleInfo[tonumber(data.szParams[5])][count] == true then
		
			return false
		else

			self.battleInfo[tonumber(data.szParams[5])][count] = true
		end

		local truePos = worldConst:converPix2Location(cc.p(data.szParams[1],data.szParams[2]))
		local worldType = luaCfg:get_world_type_by(tonumber(data.szParams[3]))
		if not worldType then
			worldType = luaCfg:get_all_miracle_name_by(tonumber(data.szParams[3]))
		end
		arg.castleName = worldType.name or ""
		arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)		
		arg.num = count	
	elseif typeId == 38 then

		arg.activity_name = luaCfg:get_activity_by(tonumber(data.szParams[1])).name
		arg.time = data.szParams[2]

	elseif typeId == 39 then
		--todo	
		arg.activity_name = luaCfg:get_activity_by(tonumber(data.szParams[1])).name

	elseif typeId >= 30 and typeId <= 34 then

		arg.name = data.szParams[1]
		arg.equip = luaCfg:get_equipment_by(tonumber(data.szParams[2])).name
		arg.lv = data.szParams[3] 

	elseif typeId == 28 or typeId == 29 then

		arg.name = data.szParams[1]
		arg.equip = luaCfg:get_equipment_by(tonumber(data.szParams[2])).name

	elseif typeId == 35 then

		arg.name = data.szParams[1]
		local itemData = luaCfg:get_item_by(tonumber(data.szParams[2])) or luaCfg:get_equipment_by(data.szParams[1])
		arg.item = itemData.itemName or itemData.name

	elseif typeId == 36 then

		arg.name = data.szParams[1]
		arg.type = luaCfg:get_divine_by(tonumber(data.szParams[2])).name

	elseif typeId == 37 then

		arg.name = data.szParams[1]
		arg.num = data.szParams[2]
		local shopData = luaCfg:get_random_shop_by(tonumber(data.szParams[3]))
		arg.itme =  shopData.name

	elseif typeId == 40 then

		arg.name1 = data.szParams[1] or ""
		arg.name2 = data.szParams[2] or ""

	elseif typeId == 41 or typeId == 43 then

		arg.name = data.szParams[1] or ""
		arg.num = data.szParams[2] or ""

	elseif typeId == 42 then

		local shortName = luaCfg:get_local_string(10333, data.szParams[1] or "")
		arg.union = shortName ..  (data.szParams[2] or "")
		arg.num = data.szParams[3] or ""
		
	elseif typeId == 44 then
		arg.name = data.szParams[1] or ""
	elseif typeId == 46 then
		
		if #data.szParams == 2 then

			arg.name = data.szParams[1]
			local wild = tonumber(data.szParams[2])
			arg.temple = luaCfg:get_wild_res_by(wild).name
		else

			arg.name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
			local wild = tonumber(data.szParams[3])
			arg.temple = luaCfg:get_wild_res_by(wild).name
		end		
	elseif typeId == 47 then

		if #data.szParams == 5 then

			local landId = tonumber(data.szParams[2])

			arg.name = data.szParams[1]
			arg.land = luaCfg:get_map_region_by(landId).name
			arg.num = data.szParams[4]
		else
				
			local landId = tonumber(data.szParams[3])

			arg.name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
			arg.land = luaCfg:get_map_region_by(landId).name
			arg.num = data.szParams[5]
		end		
	elseif typeId == 48 then

		local truePos = worldConst:converPix2Location(cc.p(data.szParams[4],data.szParams[5]))
		local wild = tonumber(data.szParams[3])
		
		arg.union = string.format("【%s】%s",data.szParams[1],data.szParams[2])
		arg.land = string.format("%s(%s,%s)",luaCfg:get_wild_res_by(wild).name,truePos.x,truePos.y)
	elseif typeId == 50 then

		local landId = tonumber(data.szParams[1])
		arg.landname = luaCfg:get_map_region_by(landId).name
		local officalId = tonumber(data.szParams[2])
		arg.postname1 = luaCfg:get_official_post_by(officalId).typeName		
		arg.lordname1 = data.szParams[3]
		arg.lordname2 = data.szParams[4]
		officalId = tonumber(data.szParams[5])
		arg.postname2 = luaCfg:get_official_post_by(officalId).typeName		
	elseif typeId >= 51 and typeId <= 53 then

		arg.name = data.szParams[1]
		arg.hero = luaCfg:get_hero_property_by(tonumber(data.szParams[2])).name
		arg.lv = data.szParams[3]
	elseif typeId == 57 then
		arg.name = data.szParams[1]
		arg.title = luaCfg:get_exploit_lv_by(tonumber(data.szParams[2])).exploitName
	elseif typeId == 58 then

		local getMirByType = function (lType)
			-- body
			for i,v in ipairs(luaCfg:world_miracle()) do
				if v.type == lType then
					return v.name
				end
			end
		end
		arg.name = getMirByType(tonumber(data.szParams[1]))
	elseif typeId == 59 then

		local getCampByType = function (lType)
			-- body
			for i,v in ipairs(luaCfg:world_camp()) do
				if v.type == lType then
					return v.name
				end
			end
		end
		arg.name = getCampByType(tonumber(data.szParams[1]))
	elseif typeId == 60 then

		local sType = luaCfg:get_all_miracle_name_by(tonumber(data.szParams[4])).name

		arg.key_1 = data.szParams[1]
		arg.key_2 = data.szParams[2]
		arg.key_4 = data.szParams[3]
		arg.key_3 = sType
	elseif typeId == 61 then

		arg.activity = luaCfg:get_activity_by(tonumber(data.szParams[1])).name
		arg.name1 = data.szParams[2] or '-'
		arg.name2 = data.szParams[3] or '-'
		arg.name3 = data.szParams[4] or '-'

	elseif typeId == 75 then

		if data.szParams then 
			arg.key_1 = data.szParams[1] or '-'
			arg.key_2 = data.szParams[2] or '-'
			arg.key_3 = data.szParams[3] or '-'
		else 
			arg.key_1 =  '-'
			arg.key_2 =  '-'
			arg.key_3 =  '-'
		end 

	elseif typeId == 62 then

		arg.name = luaCfg:get_worldboss_by(tonumber(data.szParams[1])).trueName
		arg.lv = data.szParams[2]

	elseif typeId == 77 or typeId == 78 then

		local heroName = luaCfg:get_hero_property_by(tonumber(data.szParams[2])).name
		arg.name = data.szParams[1] or "-"
		arg.heroName = heroName

	elseif typeId == 79 then

		if data.szParams then
			arg.key_1 = data.szParams[1] or "-"
		end
	end

	dump(arg,'arg')

	global.uiMgr:setRichText(self,"notice",noticeData.desId,arg)	

	return true
end

function UINotice:showNoticeText(data)	

	self.isInShow = true

	if not self:formatNotice(data) then

		self.isInShow = false
		self:showNext()
		return
	end

	local move1Width = self.clipWidth
	local move2Width = self.notice:getContentSize().width 
	local speed = 1 / 800 * 7

	self.notice:setPositionX(self.clipWidth)

	if move1Width > move2Width then

		local newMove1 = move1Width / 2 + move2Width / 2		
		self.notice:runAction(cc.Sequence:create(cc.MoveBy:create(newMove1 * speed,cc.p(-newMove1,0)),cc.DelayTime:create(1),cc.MoveBy:create(newMove1 * speed,cc.p(-newMove1,0)),cc.CallFunc:create(function()
			
			self.isInShow = false
			self:showNext()
		end)))
	else
		
		self.notice:runAction(cc.Sequence:create(cc.MoveBy:create(move1Width * speed,cc.p(-move1Width,0)),cc.DelayTime:create(1),
			cc.MoveBy:create(move2Width * speed,cc.p(-move2Width,0)),cc.CallFunc:create(function()

			self.isInShow = false
			self:showNext()		
		end)))
	end	
end

function UINotice:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/publice_notice_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.clip = self.root.public_notice_bg.clip_export
    self.notice = self.root.public_notice_bg.clip_export.notice_export

--EXPORT_NODE_END

	self.clipWidth = self.clip:getContentSize().width
	self:setScaleY(0)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UINotice

--endregion


--region UIWorldCity.lua
--Author : untory
--Date   : 2016/09/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local WCONST = WCONST
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local mailData = global.mailData
local LineMoveControl = require("game.UI.world.utils.LineMoveControl")
local UICommonStars = require("game.UI.world.widget.UICommonStars")

local g_worldview = global.g_worldview

local UIWorldCity  = class("UIWorldCity", function() return gdisplay.newWidget() end )

UIWorldCity.CITY_TYPE = {
	
	EMPTY_CITY = 0,
	OWN_CITY = 1,
	ENEMY_CITY = 2,
}

UIWorldCity.WILD_TYPE = {
	
	NORMAL = 0,
	MAGIC = 1,
	TOWN = 2,
}

function UIWorldCity:ctor()
  
	self:CreateUI()  
end

local CITY_HIDE_NODES = {"townNode","tips_node","cityEffectNode","effectNode","fireNode","protect_1","icon_city_go","protect_time","protect_2","garrison_state","randomDoorEffect","doorEffect","stop"}

function UIWorldCity:changeToLineMap(isCreate)
	
	if isCreate then
	
		self.cityName:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.5,2),2))
		self.root.Sprite_1:setOpacity(0)
		self.line_point:setOpacity(255)
		if not tolua.isnull(self.tips_node) then
			self.tips_node:setOpacity(0)
		end
	else

		self.cityName:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.5,2),2))
		self.root.Sprite_1:runAction(cc.FadeOut:create(0.3))
		self.line_point:runAction(cc.FadeIn:create(0.3))
		if not tolua.isnull(self.tips_node) then
			self.tips_node:runAction(cc.FadeOut:create(0.3))
		end
	end	

    for _,v in ipairs(CITY_HIDE_NODES) do
    	if self[v] then 
    		self[v].isTrueVisible = self[v]:isVisible() or self[v].isTrueVisible
    		self[v]:setVisible(false)
    	end 
    end

    if WCONST.WORLD_CFG.IS_3D then
    
        local rotation = self:getRotation3D()
        
        if isCreate then

        	print("function UIWorldCity:changeToLineMap(isCreate)")

        	self:setRotation3D(cc.vec3(0,rotation.y,rotation.z))
        else        	
        	self:stopAllActions()
			self:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(0,rotation.y,rotation.z)),2))
        end        
    end    
end

function UIWorldCity:setFlag(flagNode,flagId)
	-- flagSprite:setSpriteFrame(luaCfg:get_union_flag_by(flagId).cityicon)
	if flagId == nil then 
		flagNode:setVisible(false) 
		return 
	end

	if flagId == 0 then
		flagId = 1
	end
	
	local flagData = luaCfg:get_union_flag_by(flagId)
	if flagData and flagData.flag ~= '' then
		flagNode.unionFlag:setVisible(true)
		global.panelMgr:setTextureFor(flagNode.unionFlag, flagData.flag)
	else
		flagNode.unionFlag:setVisible(false)
	end	

	if flagData and flagData.national ~= '' then
		flagNode.unionFlagNation:setVisible(true)
		global.panelMgr:setTextureFor(flagNode.unionFlagNation, flagData.national)
	else
		flagNode.unionFlagNation:setVisible(false)
	end
end

function UIWorldCity:changeToNormalMap(isCreate)
	
	if isCreate then

		self.cityName:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.5,1),2))
		self.root.Sprite_1:setOpacity(255)
		self.line_point:setOpacity(0)
		if not tolua.isnull(self.tips_node) then
			self.tips_node:setOpacity(255)
		end
	else

		self.cityName:runAction(cc.EaseInOut:create(cc.ScaleTo:create(0.5,1),2))
		self.root.Sprite_1:runAction(cc.FadeIn:create(0.3))
		self.line_point:runAction(cc.FadeOut:create(0.3))
		if not tolua.isnull(self.tips_node) then
			self.tips_node:runAction(cc.FadeIn:create(0.3))
		end
	end	

    for _,v in ipairs(CITY_HIDE_NODES) do
    	if self[v] then 
	    	self[v]:setVisible(self[v].isTrueVisible)
	    	self[v].isTrueVisible = nil    	
	    end 
    end

    if WCONST.WORLD_CFG.IS_3D then
    
        local rotation = self:getRotation3D()
        -- self:setRotation3D(cc.vec3(25,rotation.y,rotation.z))

        if isCreate then
        	self:setRotation3D(cc.vec3(25,rotation.y,rotation.z))
        else        	
        	self:stopAllActions()
			self:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(25,rotation.y,rotation.z)),2))
        end 

    end    
end

function UIWorldCity:cantSkillMoveCity()
	return not self:canSkillMoveCity()
end

function UIWorldCity:canSkillMoveCity()
	return global.petData:isCanUsePetSkill(7001)
end

function UIWorldCity:CreateUI()
    local root = resMgr:createWidget("world/worldCity")
    self:initUI(root)
end

function UIWorldCity:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/worldCity")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN    
    self.garrison_state = self.root.garrison_state_export
    self.target = self.root.target_export
    self.cityName = self.root.cityName_export
    self.union_node1 = self.root.cityName_export.union_node1_export
    self.line_point = self.root.line_point_export

--EXPORT_NODE_END

	self:setName(mailData:getRandomName())
	self.target:setVisible(false)
	
	self.fireNode = cc.Node:create()
	self:addChild(self.fireNode)
	
	self.cityEffectNode = cc.Node:create()	
	self.root.Sprite_1:addChild(self.cityEffectNode)	

	self.effectNode = cc.Node:create()
	self:addChild(self.effectNode)

	self.doorEffect = cc.Node:create()
	self:addChild(self.doorEffect)
	self.randomDoorEffect = cc.Node:create()
	self:addChild(self.randomDoorEffect)

	self.line_point:setOpacity(0)

	-- if global.g_worldview.is3d then

	-- 	local rotation = self:getRotation3D()
 --    	self:setRotation3D(cc.vec3(rotation.x+25,rotation.y,rotation.z))
	-- end

	self.isCity = true

	-- self.union_node2:setVisible(false)
	-- self.union_node1:setVisible(false)

	self.root.Sprite_1:setLocalZOrder(2)
	self.garrison_state:setLocalZOrder(4)
	self.target:setLocalZOrder(5)
	self.cityName:setLocalZOrder(7)
	self.line_point:setLocalZOrder(8)

end

function UIWorldCity:addMainCityStateListenner()
	
	local refershCall = function()

		if not global.g_worldview.isStory then
		    self:refreshState()
		end            
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end

function UIWorldCity:isTown()
	
	local cityType = self:getType()
	local data = luaCfg:get_world_type_by(cityType)
	
	local wildType = 0
	if data then wildType = data.wildtype end


	return wildType == 1
end

function UIWorldCity:is_un_jingjie()
	return not self:getIsWarnning()
end

function UIWorldCity:is_jingjie()
	return self:getIsWarnning()
end

function UIWorldCity:isMagic()
	local cityType = self:getType()
	local data = luaCfg:get_world_type_by(cityType)
	
	local wildType = 0
	if data then wildType = data.wildtype end


	return wildType == 2
end

function UIWorldCity:isVillage()
	local cityType = self:getType()
	local data = luaCfg:get_world_type_by(cityType)
	
	local wildType = 0
	if data then wildType = data.wildtype end
	
	return wildType == 0
end

function UIWorldCity:isLeagueCity()
	local cityType = self:getType()
	local data = luaCfg:get_world_type_by(cityType)
	
	local wildType = 0
	if data then wildType = data.wildtype end
	
	return (wildType == 2) or (wildType == 5)
end

function UIWorldCity:canInviteFriend()
	if not self:be_self_occupy() then
		return false
	end
	if self:isLeagueVillage() then
		return (self.data.sData.tagWildInfo.lInvite == 1)
	else
		return false
	end
end

function UIWorldCity:isLeagueVillage()
	local cityType = self:getType()
	local data = luaCfg:get_world_type_by(cityType)
	
	local wildType = 0
	if data then wildType = data.wildtype end
	
	return wildType == 1
end

local worldConst = require("game.UI.world.utils.WorldConst")
function UIWorldCity:isHaveLeagueBuff()
	local i,j =  global.g_worldview.mapInfo:decodeId(self:getId())
	local resData = global.g_worldview.areaDataMgr:getAreaDataByIndex(i,j)
	-- local data = {a = 3}
	dump(data,string.format("----》i=%s,j=%s",i,j))
	print(resData)
	if not resData or type(resData) ~= "table" then
		return false
	end
	return (resData.lBuff == 1)
end

function UIWorldCity:be_self_occupy()
	
	if self:isOccupire() then

		if self.data.sData.tagCityOwner.lUserID == global.userData:getUserId() then

			return true 
		end
	end

	return false
end

function UIWorldCity:getOccupyUserId()
	
	if self:isOccupire() then
		return self.data.sData.tagCityOwner.lUserID
	else
		return self:getUserId()
	end
end

function UIWorldCity:isRandomDoor()
	local surfaceType = self.surfaceType
	return surfaceType == 5002 or surfaceType == 5003 or surfaceType == 5004 or surfaceType == 5005
end

function UIWorldCity:isOldDoor()
	local surfaceType = self.surfaceType
	return surfaceType == 701 or surfaceType == 702 or surfaceType == 703 or surfaceType == 704
end

function UIWorldCity:isDoor()
	
	local surfaceType = self.surfaceType
	return surfaceType == 131 or surfaceType == 231 or surfaceType == 331 or surfaceType == 431
end

function UIWorldCity:getDoorEndTime()
	
	return self.data.sData.lEndTime
end

function UIWorldCity:getDoorTarget()
	
	return self.data.sData.lTarget
end

function UIWorldCity:isInProtect()

	
    if global.g_worldview.isStory then return false end

	local openServerTime = global.dailyTaskData:getOpenServerTime() or 0
	local serverTime = global.dataMgr:getServerTime()
	if self:isLeagueVillage() then
		local world_camp_data = self:getWorldCamp(self.data.sData.lType)
    	if world_camp_data then

			if not tolua.isnull(self.protect_1) then
				self.protect_1:setState1()
				self.protect_1:setScale(0.8)
			end

			if not tolua.isnull(self.protect_2) then
				self.protect_2:setState1()
				self.protect_2:setScale(0.8)
			end

    		self.protectEndTime = openServerTime + world_camp_data.time * 3600
    		return math.floor((serverTime - openServerTime)/3600) < world_camp_data.time 
    	else
    		return false
    	end
	elseif self:isLeagueCity() then
    	local world_camp_data = self:getWorldMiracle(self.data.sData.lType)
    	if world_camp_data then

			if not tolua.isnull(self.protect_1) then
				self.protect_1:setState1()
				self.protect_1:setScale(1.3)
			end

			if not tolua.isnull(self.protect_2) then
				self.protect_2:setState1()
				self.protect_2:setScale(1.3)
			end			

    		self.protectEndTime = openServerTime + world_camp_data.time * 3600
    		return math.floor((serverTime - openServerTime)/3600) < world_camp_data.time 
    	else
    		return false
    	end
	else

		if not tolua.isnull(self.protect_1) then
			self.protect_1:setState2()
			self.protect_1:setScale(1)
		end

		if not tolua.isnull(self.protect_2) then
			self.protect_2:setState2()
			self.protect_2:setScale(1)
		end

		return self.data.sData.lProtect ~= 0 and self.data.sData.lProtect
	end
end

function UIWorldCity:getWorldMiracle(campType)
    
    local world_miracle = luaCfg:world_miracle()

    for _,v in ipairs(world_miracle) do

        if v.type == campType then

            return v
        end
    end
end

function UIWorldCity:getWorldCamp(campType)
    
    local world_camp = luaCfg:world_camp()

    for _,v in ipairs(world_camp) do

        if v.type == campType then

            return v
        end
    end
end

function UIWorldCity:isPlayer()

	local surfaceType = self.surfaceType
	return surfaceType >=50 and surfaceType <= 54
end

function UIWorldCity:isOwner()
	return self.data.cityType == WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY
end

function UIWorldCity:getLevel()
	
	return self.level
end

function UIWorldCity:isOther()
	return self.data.cityType ~= WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY
end

function UIWorldCity:isEmpty()
	
	return self.data.cityType == WCONST.WORLD_CFG.CITY_TYPE.EMPTY_CITY
end

function UIWorldCity:getType()
	
	-- print(self.surfaceType,">>>>>>>>>>>function UIWorldCity:getType")
	return self.surfaceType
end

function UIWorldCity:getName()
	
	if not self.data.name then return self.surfaceData.name end

	return self.data.name
end

function UIWorldCity:isMainCity()
	
	return self.data.cityType == WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY
end

function UIWorldCity:setMainCity()
	
	self.data.cityType = WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY
	self:setData(self.data)
end

function UIWorldCity:getId()
	
	return self.data.id
end

function UIWorldCity:getRect()

	return cc.rect(- 100, - 100,200,200)
end

function UIWorldCity:getTouchRect(panelX,panelY)

	-- local size = self.root.Sprite_1:getContentSize()
	local pos = cc.p(self:getPositionX(),self:getPositionY())

	-- return cc.rect(pos.x + panelX - size.width*0.5,pos.y + panelY - size.height*0.5,size.width,size.height)
	return cc.rect(pos.x + panelX - 100,pos.y + panelY - 100,200,200)
end

function UIWorldCity:beChoose()
	if self:isEmpty() then
    	gevent:call(gsound.EV_ON_PLAYSOUND,"world_village")
	elseif self:isRandomDoor() then

		gevent:call(gsound.EV_ON_PLAYSOUND,"world_transfer_2")
	elseif self:isDoor() then

		gevent:call(gsound.EV_ON_PLAYSOUND,"world_transfer_1")
	else
    	gevent:call(gsound.EV_ON_PLAYSOUND,"world_city")
	end
	self.target:setVisible(true)
end

function UIWorldCity:beUnChoose()
	
	self.target:setVisible(false)
end

function UIWorldCity:getScreenPos()

	return self.screenPos
end

function UIWorldCity:isInAttack()
	
	print("----------function UIWorldCity:isInAttack()")
	return global.g_worldview.mapPanel:isCityInBattle(self:getId())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldCity:choose(sender, eventType)

	self.attack_btn:setVisible(not self.attack_btn:isVisible())
end

function UIWorldCity:isNeedDraw()
	
	--如果是联盟野地或者是奇迹，那么被人占领的话则需要显示
	if self:isTown() or self:isMagic() then

		return self:getLevel() ~= 0
	--如果是村庄，被人占领显示
	elseif self:isEmpty() then

		return self:isOccupire()
	else
	 	
	 	return true 
	end
end

function UIWorldCity:getAvatarType()
	
	if self:isOwner() then return 1 end

	return self.avatarType
end

function UIWorldCity:getIconById(id)

	return luaCfg:get_world_city_image_by(id)
end

function UIWorldCity:getCityIconPath(data)

	data = data or self.data
	if data.sData.tagCityUser and data.sData.lBaseInfo then

		local id = 1

		-- data.sData.tagCityUser.lSkinID = 20

		if data.sData.tagCityUser.lSkinID == nil or data.sData.tagCityUser.lSkinID == 0 then
			local race_data = luaCfg:race_world_surface()
			local kind = data.sData.tagCityUser.lKind
			local level = data.sData.lBaseInfo
			local levelData = nil
			for _,v in ipairs(race_data) do

				if level >= v.level then

					levelData = v
				end
			end

			id = levelData["race"..kind]
		else

			id = data.sData.tagCityUser.lSkinID
		end				

		return self:getIconById(id)
	else

		return nil
	end
end

function UIWorldCity:setData(data)

	-- dump(data,">>>chck city data")

	self:setDataType(data)		 
	self.data = data

	self:setPosition(data)

	self:setLocalZOrder(-data.y)

	self.cityName:setString(data.name)	

	self:setTag(self.data.id)	

	self.avatarType = nil

	self.fireNode:removeAllChildren()
	self.fireNode:setVisible(true)
	self.cityEffectNode:removeAllChildren()
	self.cityEffectNode:setVisible(true)
	self.doorEffect:removeAllChildren()
	self.randomDoorEffect:removeAllChildren()
	self.effectNode:removeAllChildren()

	self.isInFire = false
	if data.sData.lState == 2 then

		local fire = resMgr:createCsbAction("effect/bigworld_ruin_city", "animation0", true, false)
		self.fireNode:addChild(fire)
		self.isInFire = true
	end


	self:initLevel()

	if not self:isInProtect() then

		if not tolua.isnull(self.protect_1) then
			self.protect_1:setVisible(false)
		end
		if not tolua.isnull(self.protect_2) then
			self.protect_2:setVisible(false)
		end
		if not tolua.isnull(self.protect_time) then
			self.protect_time:setVisible(false)
		end
	else

		if not self.protect_1 then

			self.protect_1 = require("game.UI.world.widget.UIWorldCityProtect1").new()
			self.protect_1:setPosition(cc.p(0,0))
			self.root:addChild(self.protect_1)
			self.protect_1:setLocalZOrder(1)
		end
		self.protect_1:setVisible(true)

		if not self.protect_2 then

			self.protect_2 = require("game.UI.world.widget.UIWorldCityProtect").new()
			self.protect_2:setPosition(cc.p(0,0))
			self.root:addChild(self.protect_2)
			self.protect_2:setLocalZOrder(6)
		end
		self.protect_2:setVisible(true)

		if not self.protect_time then
			self.protect_time = ccui.Text:create() 
			self.protect_time:setPosition(cc.p(150, 42))
			self.protect_time:setFontSize(20)
			self.protect_time:setFontName('fonts/normal.ttf')
			self.protect_time:setTextColor(cc.c3b(255,255,255))
			self.protect_time:enableOutline(cc.c4b(0,0,0,255),2)
			self.cityName:addChild(self.protect_time)
		end
		self.protect_time:setVisible(true)

		self:startCheckTimeForProtect()
		self.protectEndTime = self.data.sData.lProtectArrived or self.protectEndTime
		self:checkTimeForProtect()

	end
	if not tolua.isnull(self.icon_city_go) then
		self.icon_city_go:setVisible(false)
	end
	self.userId = nil
	self.beFightName = nil


	if data.sData.tagCityOwner then

		dump(data.sData.tagCityOwner,"data.sData.tagCityOwner")
		
		if not self.playerName then
			self.playerName = ccui.Text:create() 
			self.playerName:setPosition(cc.p(150, 42))
			self.playerName:setFontSize(20)
			self.playerName:setFontName('fonts/normal.ttf')
			self.playerName:setTextColor(cc.c3b(255,255,255))
			self.playerName:enableOutline(cc.c4b(0,0,0,255),2)
			self.cityName:addChild(self.playerName)
		end
		self.playerName:setVisible(true)
		
		self.playerName:setString("["..data.sData.tagCityOwner.szUserName.."]")
		
		if data.sData.tagCityOwner.szAllyName then

			self.playerName:setString('【'..data.sData.tagCityOwner.szAllyName..'】['..data.sData.tagCityOwner.szUserName .. ']')			
		end		

		self.playerName:setTextColor(self:getColorByAvatar(data.sData.tagCityOwner.lAvatar))
		
		self.avatarType = data.sData.tagCityOwner.lAvatar
		self.userId = data.sData.tagCityOwner.lUserID
		self.beFightName = data.sData.tagCityOwner.szUserName

		if not self.union_node2 then
            self.union_node2 = require("game.UI.union.widget.UIUnionFlagWidget").new()
            self.union_node2:CreateUI()      
            self.union_node2:setScale(0.15)
            self.cityName:addChild(self.union_node2)                
        end
		self.union_node2:setVisible(true)
		self.union_node2:setPositionY(38.5)
		self.union_node2:setData(data.sData.tagCityOwner.lTotem)

	else
		if not tolua.isnull(self.union_node2) then
			self.union_node2:setVisible(false)
		end
		if not tolua.isnull(self.playerName) then
			self.playerName:setVisible(false)
		end
	end


	if data.sData.tagCityUser and data.sData.tagCityUser.lAvatar then

		self.cityName:setTextColor(self:getColorByAvatar(data.sData.tagCityUser.lAvatar))

		self.surfaceType = 50 + data.sData.tagCityUser.lAvatar

		self.avatarType = self.avatarType or data.sData.tagCityUser.lAvatar
		self.userId = self.userId or data.sData.tagCityUser.lUserID
		self.beFightName = self.beFightName or data.sData.tagCityUser.szUserName
		self.union_node1:setVisible(true)
		self:setFlag(self.union_node1,data.sData.tagCityUser.lTotem)
	else

		self.union_node1:setVisible(false)
		self.cityName:setTextColor(self:getColorByAvatar(-1))	
	end


	if self.surfaceType >= 21 and self.surfaceType <= 25 and self:getLevel() == 0 then
		self.avatarType = 4
	end

	if self.surfaceType >= 11 and self.surfaceType <= 15 and self:getLevel() == 0 then
		self.avatarType = 0
	end

	self:initSurface(self.surfaceType)
	
	if not tolua.isnull(self.stop) then
		self.stop:setVisible(false)
	end	
	self.garrison_state:setPosition(cc.p(self.surfaceData.GarrisonX,self.surfaceData.GarrisonY))

	local  flag = self:getRelationFlag()
	-- print("@@@@@@@@@@@@@@@@ ########### @@@@@@@@@@@@@@@@@@ :getRelationFlag(): "..flag)
	if not flag then flag = 0 end

	if flag == 2 then
	
		self.massEndTime = self.data.sData.lConfusetime
		
		if not self.icon_city_go then
			self.icon_city_go = cc.Sprite:create()
			self.icon_city_go:setSpriteFrame("ui_surface_icon/city_go.png")
			self.icon_city_go:setPosition(cc.p(60, 90))
			self.root:addChild(self.icon_city_go)
		end
		self.icon_city_go:setVisible(true)
		if not self.time then
			self.time = ccui.Text:create() 
			self.time:setPosition(cc.p(30, -4))
			self.time:setFontSize(18)
			self.time:setFontName('fonts/normal.ttf')
			self.time:setTextColor(cc.c3b(255,255,255))
			self.time:enableOutline(cc.c4b(0,0,0,255),2)
			self.icon_city_go:addChild(self.time)
		end

		self:startCheckTime()

	elseif self:getAvatarType() == 4 or  flag == 0 then 
		if not tolua.isnull(self.stop) then
			self.stop:setVisible(false)
		end
	else
		if not self.stop then
			self.stop = cc.Sprite:create()
			self.stop:setSpriteFrame("ui_surface_icon/city_stop.png")
			self.stop:setPosition(cc.p(63, -5))
			self.root:addChild(self.stop)
			self.stop:setLocalZOrder(3)
		end
		self.stop:setVisible(true)
	end

	if self.data.sData.tagSticker then
		
		if not self.tips_node then
			self.tips_node = require("game.UI.world.widget.UIWorldCityTips").new()
			self.tips_node:setPosition(cc.p(150,78))
			self.cityName:addChild(self.tips_node)
		end
		local data = {}
		data.str = self.data.sData.tagSticker.szContent
		data.color = cc.c3b(unpack((luaCfg:get_stickers_color_by(self.data.sData.tagSticker.lColor) or luaCfg:get_stickers_color_by(1)).color))
		self.tips_node:setData(data)
		self.tips_node:setVisible(true)

	else
		if not tolua.isnull(self.tips_node) then
			self.tips_node:setVisible(false)
		end
	end

	local isPlayNameVis = false
	if not tolua.isnull(self.playerName) then
		isPlayNameVis = self.playerName:isVisible()
	end
	self.cityName:setVisible(isPlayNameVis or self.surfaceData.seename == 1)
	self.garrison_state:setVisible(false)

	-- dump(data)
	-- print("self.surfaceType="..self.surfaceType)

	if data.cityType == WCONST.WORLD_CFG.CITY_TYPE.ENEMY_CITY then			

		self:addMainCityStateListenner()

		if data.sData.tagCityUser then

			if data.sData.tagCityUser.szAllyName then

				self.cityName:setString('【'..data.sData.tagCityUser.szAllyName..'】'..data.name)			
			end		
		end
	elseif data.cityType == WCONST.WORLD_CFG.CITY_TYPE.EMPTY_CITY then

		self.cityName:setString(self.surfaceData.name)		
		self:addMainCityStateListenner()

		if self.surfaceType >= 21 and self.surfaceType <= 25 and self:getLevel() == 0 then
			self.cityName:setTextColor(cc.c3b(255,0,0))
		end


		if self.surfaceType >= 11 and self.surfaceType <= 15 and self:getLevel() == 0 then
			self.cityName:setTextColor(cc.c3b(255,243,45))
		end
		
	elseif data.cityType == WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY then

		local worldPanel = global.g_worldview.worldPanel

		worldPanel._isMainCityProtect = self:isInProtect()
		worldPanel._mainCityProtectEndTime = self.protectEndTime

		self.cityName:setString(self.surfaceData.name)
		self:addMainCityStateListenner()

    	global.userData:setMainCityPos(data)
	end


	if self.data.sData.lType >= 11 and self.data.sData.lType <= 14 then
		-- 奇迹
		local sname = luaCfg:get_all_miracle_name_by(self.data.sData.lCityID)
		if sname then
			self.cityName:setString(sname.name)
		end
	end

	local path = self:getCityIconPath()
	if path then

		self.iconPath = path.worldmap
		-- self.root.Sprite_1:setSpriteFrame(self.iconPath)
		global.panelMgr:setTextureFor(self.root.Sprite_1,self.iconPath)
		self.cityName:setPositionY(path.Ynamedev)

		if path.worldeffect and path.worldeffect ~= "" then
			
			local contentSize = self.root.Sprite_1:getContentSize()
			self.cityEffectNode:setPosition(0.5 * contentSize.width,0.3 * contentSize.height)

			local effect = resMgr:createCsbAction(path.worldeffect, "animation0", true, false)
			self.cityEffectNode:addChild(effect)
		end
	else

		self.iconPath = self.surfaceData.worldmap
		-- self.root.Sprite_1:setSpriteFrame(self.iconPath)
		global.panelMgr:setTextureFor(self.root.Sprite_1,self.iconPath)
		self.cityName:setPositionY(self.surfaceData.Ynamedev)
	end	

	-- self.cityName:setContentSize(cc.size(400,27))
	-- self.cityName:setString(string.format("%s,(%s,%s),%s",self.cityName:getString(),self.data.x,self.data.y,self.data.sData.lCityID))


	self.line_point:setSpriteFrame(self.surfaceData.roadmap)
	self.line_point:setColor(self:getMapColorByAvatar(self:getAvatarType()))

	self:refreshState()    	
		

	if self:isTown() and self:getLevel() == 0 then

		self.townNode = self:getNode("townNode")

		self.townNode:setVisible(true)
		self.townNode:setData(self.data.sData.tagWildInfo)		
	elseif self:isMagic() and self:getLevel() == 0 then

		self.townNode = self:getNode("townNode")

		self.townNode:setVisible(true)
		self.townNode:setData(self.data.sData.tagWildInfo)			
	else

		self:hideNode("townNode")
		-- self.townNode:setVisible(false)
	end

	if self:isMagic() then
		local magicType = data.sData.lType
		local lv = data.sData.tagWildInfo.lCityLv
		local rewards = luaCfg:miracle_upgrade()

		local stars = UICommonStars.new(true)
		self.effectNode:addChild(stars)
		stars:setScale(0.7)
		stars:setData(lv)
		stars:setPositionX(-70)
		stars:setPositionY(self.surfaceData.Ynamedev - 33)

	    for  _,v in ipairs(rewards) do
	        if v.type == magicType and lv == v.lv then
	            
	            local look = v.pic
				global.panelMgr:setTextureFor(self.root.Sprite_1,look)

	        end
	    end
	end

	for _,v in ipairs(CITY_HIDE_NODES) do
    	if self[v] then 
    		self[v].isTrueVisible = self[v]:isVisible()    	
    	end 
    end

	if global.g_worldview.worldPanel:getIsLineMap() then

		self:changeToLineMap(true)
	else

		self:changeToNormalMap(true)
	end

	self:checkChoose()

	self:setDoorEffect()
	self:setRandomDoorEffect()
	self:setOldDoorEffect()

	self.root.Sprite_1:setName("worldcity" .. self:getId())
	self.cityName:setName("worldcityName" .. self:getId())

	self.union_node1:setPositionX(self.cityName:getAutoRenderSize().width / 2 + 142)
	if not tolua.isnull(self.union_node2) then
		self.union_node2:setPositionX(self.playerName:getAutoRenderSize().width / 2 + 175)	
	end
end

--是否是真的朋友
function UIWorldCity:isTrueFirend()
	
	if self.data.sData.tagCityUser and self.data.sData.tagCityUser.lAvatar then
		
		return self.data.sData.tagCityUser.lAvatar == 2
	else
		return false
	end
end


function UIWorldCity:getNode(key)
	if not self[key] then 
		if key == "townNode" then 
			self[key]= require("game.UI.world.widget.UITownTopInfo").new()
			self.cityName:addChild(self[key])
			self[key]:setPositionX(150)
			self[key]:setPositionY(30)
		end 
	end 
	
	return self[key]
end

function UIWorldCity:hideNode(node)

	if node and  self[node] and (not tolua.isnull(self[node])) then 
		self[node]:setVisible(false)		
	end 
end


function UIWorldCity:getIconPath()
	
	return self.iconPath
end

function UIWorldCity:getBeFightName()
	
	return self.beFightName
end

function UIWorldCity:isRandomDoor()
	
	return self:getDoorTarget() ~= nil
end

function UIWorldCity:initLevel()
	
	self.level = 1

	if self:isTown() or self:isMagic() then

		if self.data.sData.tagWildInfo == nil or self.data.sData.tagWildInfo.lStatus == 1 then

			self.level = 1
		else

			self.level = 0
		end
	end
end

-- function UIWorldCity:checkIsTownSuccess()
	
-- 	if self:isTown() then

-- 		local data = self.data.sData.tagWildInfo
-- 		if data.lCurHp == data.lMaxHp then

-- 			return 1
-- 		else if data.lCurHp == 0 then
			
-- 		end
-- 	end
-- end

function UIWorldCity:setDoorEffect()
	
	if self:isDoor() then

		local fire = resMgr:createCsbAction("effect/Transfer_door", "animation0", true, false)
		self.doorEffect:addChild(fire)
	end
end

function UIWorldCity:setRandomDoorEffect()
	
	if self:isRandomDoor() then

		local fire = resMgr:createCsbAction("effect/Transfer_door2", "animation0", true, false)
		self.randomDoorEffect:addChild(fire)
	end
end

function UIWorldCity:setOldDoorEffect()
	
	if self:isOldDoor() then

		print(">>>>ye s is si odl")
		local fire = resMgr:createCsbAction("effect/qiji_4swish", "animation0", true, false)
		self.randomDoorEffect:addChild(fire)
	end
end

function UIWorldCity:checkChoose()
	
	local worldPanel = global.g_worldview.worldPanel
	if worldPanel.gpsCityId == self:getId() then

		print("............chooseself")
		worldPanel.gpsCityId = nil
		worldPanel.mapPanel:chooseObject(self)
	end
end

function UIWorldCity:be_occupy()
	
	return self:isOccupire()
end

function UIWorldCity:tir_garrison()
	
	return self:getAvatarType() == 1 or self.garrison_state:isVisible()
end

function UIWorldCity:getUserId()
	
	return self.userId
end

function UIWorldCity:startCheckTime()
	
	if self.scheduleListenerId then

		gscheduler.unscheduleGlobal(self.scheduleListenerId)
	end

	self.scheduleListenerId = gscheduler.scheduleGlobal(function()
    	    
	    self:checkTime()
	end, 1)	
end

function UIWorldCity:startCheckTimeForProtect()
	
	if self.scheduleListenerIdProtect then

		gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
	end

	self.scheduleListenerIdProtect = gscheduler.scheduleGlobal(function()
    	    
	    self:checkTimeForProtect()
	end, 1)	
end

function UIWorldCity:checkTimeForProtect()
	
	local contentTime = self.protectEndTime - global.dataMgr:getServerTime()
	if contentTime < 0 then contentTime = 0 end

	if contentTime == 0 then

		if not tolua.isnull(self.protect_time) then
			self.protect_time:setVisible(false)
		end
		if not tolua.isnull(self.protect_2) then
			self.protect_2:setVisible(false)
		end
		if not tolua.isnull(self.protect_1) then
			self.protect_1:setVisible(false)
		end
		return
	end

	local str = global.troopData:timeStringFormat(contentTime)
	if not tolua.isnull(self.protect_time) then
		self.protect_time:setString(str)
	end
end

function UIWorldCity:checkTime()
	
	local contentTime = self.massEndTime - global.dataMgr:getServerTime()
	if contentTime < 0 then 
		contentTime = 0 
		if not tolua.isnull(self.icon_city_go) then
			self.icon_city_go:setVisible(false) 
		end
		return 
	end

	local str = global.troopData:timeStringFormat(contentTime)
	if not tolua.isnull(self.time) then
		self.time:setString(str)
	end
end

function UIWorldCity:onExit()


    for _,v in ipairs(CITY_HIDE_NODES) do
    	if self[v] then 
    		self[v].isTrueVisible = nil    	
    	end 
    end
	
	if self.scheduleListenerIdProtect then

		gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
	end

	if self.scheduleListenerId then

		gscheduler.unscheduleGlobal(self.scheduleListenerId)
	end
end

function UIWorldCity:getMapColorByAvatar( avatarType )
    
    --0 中立 1 自己 2 同盟 3 联盟 4 敌对
    if avatarType == 0 then --中立

        return cc.c3b(255,243,45)
    elseif avatarType == 1 then --

        return cc.c3b(4,194,255)
    elseif avatarType == 2 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 3 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 4 then --

        return cc.c3b(192,10,10)
    else
        
    	if self:isEmpty() then
    		return cc.c3b(255,243,255)
    	else
    		return cc.c3b(255,243,45)
    	end        
        -- return cc.c3b(255,255,255)
    end
end

function UIWorldCity:getColorByAvatar( avatarType )
	
	--0 中立 1 自己 2 同盟 3 联盟 4 敌对
	if avatarType == 0 then --中立

		return cc.c3b(255,213,45)
	elseif avatarType == 1 then --

		return cc.c3b(14,201,255)
	elseif avatarType == 2 then --

		return cc.c3b(55,255,17)
	elseif avatarType == 3 then --

		return cc.c3b(55,255,17)
	elseif avatarType == 4 then --

		return cc.c3b(255,30,7)
	else
		
		return cc.c3b(255,255,255)
	end
end

function UIWorldCity:gpsCIty()
	
	local cityData = global.g_worldview.worldPanel.gpsCityData
	if cityData and  cityData.cityId ~= 0  then

		local eType = luaCfg:get_world_surface_by(cityData.mapId).LocationType
	    if eType == 1 then

	    	local lastCity = global.g_worldview.mapPanel.preChooseCity
	    	local city = global.g_worldview.mapPanel:getCityById(cityData.cityId)
	    	if not lastCity then
	            global.g_worldview.mapPanel:chooseObject(city)
	        else
	            global.g_worldview.mapPanel.preChooseCity = nil
	            global.g_worldview.mapPanel:chooseObject(city)
	        end
	    else
	    end
	end
end

--领主主堡等级
function UIWorldCity:getCastleLv()
	--判空处理	
	if not self.data.sData.lBaseInfo then return 1 end
	return math.floor(self.data.sData.lBaseInfo)
end

--领主信息
function UIWorldCity:getLordData()
	return self.data.sData.tagCityUser
end

--特色信息
function UIWorldCity:getPlusData()

	dump(self.data.sData)

	return self.data.sData.tagPlusInfo
end

--获取联盟城市范围内的同盟城堡数量
function UIWorldCity:getAllyCastleNum()
	if self:isLeagueCity() then
		return self.data.sData.tagWildInfo.lInvite or 0
	end
	return 0
end

--　当前警戒状态
function UIWorldCity:getRelationFlag()
	return self.data.sData.lRelationFlag
end

function UIWorldCity:getWorldPos()
	return self.data.sData.lPosX,self.data.sData.lPosY
end

function UIWorldCity:getNewScreenPos()
	return self:convertToWorldSpace(cc.p(0,0))
end


--占领者信息
function UIWorldCity:getOccupierData()
	return self.data.sData.tagCityOwner
end

function UIWorldCity:getCityOwnerAllyId()
	if not self.data.sData.tagCityOwner then
		return 0
	else
		return self.data.sData.tagCityOwner.lAllyID
	end
end

function UIWorldCity:isOccupire()
	
	return self.data.sData.tagCityOwner ~= nil
end

--领主种族
function UIWorldCity:getRaceName(raceId)
	local raceData = luaCfg:get_race_by(raceId)
	return raceData.name
end

function UIWorldCity:getLordAllyName()
	return self.data.sData.szAllyFlag
end

function UIWorldCity:setDataType(data)

	local worldPanel = global.g_worldview.worldPanel
	
	local _type = 0	--这个是标记村庄。城池等大标记
	local surfaceType = 0	--这个用户读表的标记

	if data.id == worldPanel.mainId and data.name ~= nil then

		_type = WCONST.WORLD_CFG.CITY_TYPE.OWN_CITY
		surfaceType = _type
		worldPanel.mainCity = self
	elseif data.name == nil then
		
		_type = WCONST.WORLD_CFG.CITY_TYPE.EMPTY_CITY
		surfaceType = data.sData.lType
	else

		_type = WCONST.WORLD_CFG.CITY_TYPE.ENEMY_CITY		
		surfaceType = _type
	end

	data.cityType = _type
	self.surfaceType = surfaceType
end

function UIWorldCity:bindPointSprite(sprite)
	
	self.pointSprite = sprite
end

function UIWorldCity:refreshState()
	
	local count = 0
	if self:be_self_occupy() or self:isOwner() then
		
		count = global.troopData:getTroopInCity(self:getId())
	else

		count = global.troopData:getOwnTroopInCity(self:getId())		
	end

	if self:isOther() then

		if count == 1 then
			self.garrison_state:setVisible(true)
			self.garrison_state:setSpriteFrame("ui_surface_icon/city_garrison_01.png")
		elseif count >1 then
			self.garrison_state:setVisible(true)
			self.garrison_state:setSpriteFrame("ui_surface_icon/city_garrison_02.png")
		elseif count <= 0 then
			self.garrison_state:setVisible(false)
		end  
	elseif self:isOwner() then
		
		if self:be_occupy() then

			self.garrison_state:setVisible(false)
		else

			if count == 1 then
				self.garrison_state:setVisible(true)
				self.garrison_state:setSpriteFrame("ui_surface_icon/city_garrison_01.png")
			elseif count >1 then
				self.garrison_state:setVisible(true)
				self.garrison_state:setSpriteFrame("ui_surface_icon/city_garrison_02.png")
			elseif count <= 0 then
				self.garrison_state:setVisible(false)
			end
		end


	end

	if global.g_worldview.worldPanel:getIsLineMap() then

		self.garrison_state.isTrueVisible = self.garrison_state:isVisible()
		self.garrison_state:setVisible(false)
	end	
end

function UIWorldCity:getPointSprite()
	
	return self.pointSprite
end

function UIWorldCity:initSurface(_type)
	
    local surface = luaCfg:world_surface()    

    for _,i in pairs(surface) do

        if _type == i.type then

            self.surfaceData = i
            return
        end
    end	
end

function UIWorldCity:getIsWarnning()
	
	if tolua.isnull(self.stop) then
		return false
	end
	return self.stop:isVisible()
end

function UIWorldCity:getSurfaceData()
	
	return self.surfaceData
end

function UIWorldCity:attack_call(sender, eventType)

	-- self.attack_btn:setVisible(false)

	local sp = cc.Sprite:create()
	sp:setSpriteFrame("a020_0_NW_move_0.png")	
	sp:setPosition(self:getPosition())
	g_worldview.mapPanel:addChild(sp)
	LineMoveControl.new():startMove(sp,nil,1)
end
--CALLBACKS_FUNCS_END


function UIWorldCity:setRadius(r)
	self.m_radius = r or 0
end

function UIWorldCity:getRadius(r)
	return self.m_radius or 0
end

return UIWorldCity

--endregion

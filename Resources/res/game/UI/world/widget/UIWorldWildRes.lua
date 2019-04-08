
--region UIWorldWildRes.lua
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

local g_worldview = global.g_worldview

local UIWorldWildRes  = class("UIWorldWildRes", function() return gdisplay.newWidget() end )
local UIHeroGarrisonEffect = require("game.UI.commonUI.widget.UIHeroGarrisonEffect")

local worldConst = require("game.UI.world.utils.WorldConst")

function UIWorldWildRes:ctor()
  
	self:CreateUI()  
end

function UIWorldWildRes:CreateUI()
    local root = resMgr:createWidget("world/worldWildRes")
    self:initUI(root)
end

function UIWorldWildRes:getLevel()
	
	return 1
end

function UIWorldWildRes:changeToLineMap(isCreate)

	print("-------------------------------------势力地图");	
	self.effectNode:setVisible(false)
	self.icon:setVisible(false)
	self.name:setVisible(false)
	self.wild_mini:setVisible(true)
	if not tolua.isnull(self.hero_garrison) then
		self.hero_garrison:setVisible(false)
	end

   	--清除3d旋转效果
     if WCONST.WORLD_CFG.IS_3D then
        local rotation = self:getRotation3D()
        if isCreate then
        	self:setRotation3D(cc.vec3(0,rotation.y,rotation.z))
        else        	
        	self:stopAllActions()
			self:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(0,rotation.y,rotation.z)),2))
        end        
    end    
 
end

function UIWorldWildRes:changeToNormalMap(isCreate)
 	-- self:setVisible(true) 
 	self.effectNode:setVisible(true)
	self.name:setVisible(true)
	self.icon:setVisible(true)
	self.wild_mini:setVisible(false)
	self:setState()

	if WCONST.WORLD_CFG.IS_3D then
        local rotation = self:getRotation3D()
        if isCreate then
        	self:setRotation3D(cc.vec3(25,rotation.y,rotation.z))
        else        	
        	self:stopAllActions()
			self:runAction(cc.EaseInOut:create(cc.RotateTo:create(0.5,cc.vec3(25,rotation.y,rotation.z)),2))
        end        
    end    
end

function UIWorldWildRes:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/worldWildRes")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.target = self.root.target_export
    self.garrison_state = self.root.garrison_state_export
    self.name = self.root.name_export
    self.owenr_name = self.root.name_export.owenr_name_export
    self.protect_time = self.root.name_export.protect_time_export
    self.wild_mini = self.root.wild_mini_export

--EXPORT_NODE_END

	self.effectNode = cc.Node:create()
	self:addChild(self.effectNode)

	self.isWildRes = true	
	-- if global.g_worldview.is3d then

	-- 	local rotation = self:getRotation3D()
 --    	self:setRotation3D(cc.vec3(rotation.x+25,rotation.y,rotation.z))
	-- end
end

function UIWorldWildRes:addMainCityStateListenner()
	
	local refershCall = function()

        self:refreshState()
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end

function UIWorldWildRes:getName()
	return self.name:getString()
end

function UIWorldWildRes:isMe(id)
	
	print(self.data.lResID,id)
	return self.data.lResID == id
end

function UIWorldWildRes:be_occupy()
	return self:isOccupire()
end

function UIWorldWildRes:not_be_occupy()
	return not self:isOccupire()
end

function UIWorldWildRes:be_self_occupy()
	if self:be_occupy() then
		return self.data.tagOwner.lUserID == global.userData:getUserId()	
	else
		return false
	end		
end

function UIWorldWildRes:have_garrison()
	return global.troopData:getTroopInCity(self:getId()) > 0
end

function UIWorldWildRes:be_self_occupy_and_no_garrison()
	return self:be_self_occupy() and not self:have_garrison()
end

function UIWorldWildRes:be_self_occupy_and_have_garrison()
	return self:be_self_occupy() and self:have_garrison()
end

function UIWorldWildRes:isOccupire()
	
	return self.data.tagOwner ~= nil
end

function UIWorldWildRes:getId()
	
	return self.data.lResID
end

function UIWorldWildRes:setType(ctype)
	self.data.cityType = ctype
end

function UIWorldWildRes:getType()
	
	if not self.designerData then return 0 end
	self.designerData.type = self.designerData.type or 0

	if self.designerData.type > 100 then return self.designerData.type end
	return 101
end

function UIWorldWildRes:getDesignerData()
	
	return self.designerData
end

function UIWorldWildRes:isResType()
	return true
end                                                                      


function UIWorldWildRes:getRect()
	
	local x = self:getPositionX()
	local y = self:getPositionY()

	if self:getType() == 600 then
		return cc.rect(- 150,- 70,300,500)
	elseif self:getType() >= 500 then
		return cc.rect(- 150,- 70,300,140)
	else
		return cc.rect(- 35,- 10,70,70)
	end	
end

function UIWorldWildRes:getTouchRect(panelX,panelY)
	
	local pos = cc.p(self:getPositionX(),self:getPositionY())

	return cc.rect(pos.x + panelX - 35,pos.y + panelY - 10,70,70)
end

function UIWorldWildRes:beChoose()
	
	if self:isMiracle() then

    	gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")
    else
    	
    	gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.surfaceData.id)
	end

	self.target:setVisible(true)
end

function UIWorldWildRes:beUnChoose()
	
	self.target:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIWorldWildRes:setData(data)
	
	self.data = data

	print(data.lKind,'lKind.')

	self.designerData = luaCfg:get_wild_res_by(data.lKind)

	self.name:setName("wildresName" .. self:getId())
	self.icon:setName("wildres" .. self:getId())
	self:initSurface(self.designerData.file)

	self:setType(WCONST.WORLD_CFG.CITY_TYPE.WILD_RES)

	self.name:setPositionY(self.surfaceData.Ynamedev)

	self.name:setString(self.designerData.name)
	-- self.icon:setSpriteFrame(self.surfaceData.worldmap)
	global.panelMgr:setTextureFor(self.icon,self.surfaceData.worldmap)
	self:setPosition(cc.p(data.lPosX,data.lPosY))
	self:setLocalZOrder(-data.lPosY)
	self:beUnChoose()

	---test
	--self.name:setContentSize(cc.size(400,27))
	--self.name:setString(string.format("%s,(%s,%s),%s",self.name:getString(),self.data.lPosX,self.data.lPosY,self.data.lResID))

	self.avatarType = nil

	self.userId = nil
	self.beFightName = self:getName()

	if self.data.tagOwner then
		--有占领者的情况下
		self.owenr_name:setString(string.format("[%s]",self.data.tagOwner.szUserName))
		
		if self.data.tagOwner.szAllyName then
			self.owenr_name:setString(string.format("【%s】[%s]",self.data.tagOwner.szAllyName,self.data.tagOwner.szUserName))	
		end

		self.owenr_name:setTextColor(self:getColorByAvatar(self.data.tagOwner.lAvatar))
		self.avatarType = self.data.tagOwner.lAvatar

		self.userId = self.data.tagOwner.lUserID
		self.beFightName = self.data.tagOwner.szUserName

		if not self.union_node then
            self.union_node = require("game.UI.union.widget.UIUnionFlagWidget").new()
            self.union_node:CreateUI()      
            self.union_node:setScale(0.15)
            self.name:addChild(self.union_node)                
        end
		self.union_node:setVisible(true)
		self.union_node:setPositionY(42)
		self.union_node:setData(self.data.tagOwner.lTotem)
	
	else
		self.owenr_name:setString("")
		if not tolua.isnull(self.union_node) then
			self.union_node:setVisible(false)
		end
	end

	self:addMainCityStateListenner()
	self:refreshState()
	self:checkChoose()
	
	self.wild_mini:setColor(self:getColorByAvatar(self.avatarType))
	self.wild_mini:setSpriteFrame(self.surfaceData.roadmap)

	if global.g_worldview.worldPanel:getIsLineMap() then

		self:changeToLineMap(true)
	else

		self:changeToNormalMap(true)
	end


	self.effectNode:removeAllChildren()

	print(self:getType(),"self:getType()")

	-- self.icon:setScale(0.54)
	self.icon:setScale(self.designerData.size)

	self.protect_time:setVisible(false)

	if self:getType() == 600 then

		-- self.icon:setScale(1)

		local fire = resMgr:createCsbAction("effect/qiji_sword", "animation0", true, false)
		self.effectNode:addChild(fire)

		fire = resMgr:createCsbAction("animation/ani_woldboss_jzb", "animation2", true, false)
		self.effectNode:addChild(fire)

        local countText = ccui.Text:create()
        countText:setString(luaCfg:get_local_string(10836))
        countText:setFontName(self.name:getFontName())
		countText:enableOutline(cc.c4b(0,0,0,255),2)
        countText:setFontSize(21)
        countText:setPosition(cc.p(0,470))
        countText:setScaleX(-1)
        fire:addChild(countText)

		fire:setScaleX(-1)
		fire:setPositionX(-500)

		fire = resMgr:createCsbAction("animation/ani_woldboss_5tl", "animation2", true, false)
		self.effectNode:addChild(fire)

		countText = ccui.Text:create()
        countText:setString(luaCfg:get_local_string(10835))
        countText:setFontName(self.name:getFontName())
		countText:enableOutline(cc.c4b(0,0,0,255),2)
        countText:setFontSize(21)
        countText:setPosition(cc.p(0,400))
        fire:addChild(countText)

		fire:setPositionX(500)
	elseif self:getType() > 500 then		

		if self:getType() < 800 then
			local fire = resMgr:createCsbAction("effect/qiji_strong_eff", "animation0", true, false)
			self.effectNode:addChild(fire)
		end		
		
		if self.data.lprotectState == 0 and self.data.lFlushTime then

			local fire = resMgr:createCsbAction("effect/qiji_protect", "animation0", true, false)
			self.effectNode:addChild(fire)

			self.protect_time:setVisible(true)

			self:startCheckTimeForProtect()
			self.protectEndTime = self.data.lFlushTime
			self:checkTimeForProtect()

			self.protect_time:setPositionY(self:isOccupire() and 75 or 42)
		end		
	end

	if self.data.lCollectSpeed then
		local fire = resMgr:createCsbAction("animation/caiji_act", "animation0", true, false)
		fire:setScale(0.5)
		self.effectNode:addChild(fire)

		if self.data.lIsUseSpeed == 1  then

			fire = resMgr:createCsbAction("effect/bigworld_res_eff", "animation0", true, false)			
			self.effectNode:addChild(fire)	
		end
	end

	self.pointSprite = nil

	self:setState()

	if not tolua.isnull(self.union_node) then
		self.union_node:setPositionX(self.owenr_name:getAutoRenderSize().width / 2 + 175)
	end
end


function UIWorldWildRes:setState()
	
	if  global.luaCfg:get_hero_property_by(self.data.lDefHero) then 

		if not self.hero_garrison then
			self.hero_garrison = UIHeroGarrisonEffect.new()
			self.hero_garrison:CreateUI()
			self.root:addChild(self.hero_garrison)
		end
		self.hero_garrison:setVisible(true)
		self.hero_garrison:setData(self.data.lDefHero)

		self.hero_garrison:setPositionX(0)
		if self.data.tagOwner then
			self.hero_garrison:setPositionY(self.surfaceData.Ynamedev - 60 - 3 )
		else
			self.hero_garrison:setPositionY(-33)
		end
		
	else
		if not tolua.isnull(self.hero_garrison) then
			self.hero_garrison:setVisible(false)
		end
	end  

end 


function UIWorldWildRes:isInProtect()
	return self.data.lprotectState and self.data.lprotectState == 0 and self.data.lFlushTime
end

function UIWorldWildRes:startCheckTimeForProtect()
	
	if self.scheduleListenerIdProtect then

		gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
	end

	self.scheduleListenerIdProtect = gscheduler.scheduleGlobal(function()
    	    
	    self:checkTimeForProtect()
	end, 1)	
end

function UIWorldWildRes:timeStringFormat( time )
    
    local str = ""

    local day = math.floor(time / 86400)
    time = time % 86400
    local hour = math.floor(time / 3600) 
    time = time  % 3600
    local min = math.floor(time / 60)
    time = time % 60
    local sec = math.floor(time) 

    if day == 0 then
    	str =  luaCfg:get_local_string( "%02d:%02d:%02d" ,hour, min, sec ) 
    else
    	str =  luaCfg:get_local_string( "%s days %02d:%02d:%02d" ,day,hour, min, sec ) 
    end

    return str
end

function UIWorldWildRes:checkTimeForProtect()
	
	local contentTime = self.protectEndTime - global.dataMgr:getServerTime()
	if contentTime < 0 then contentTime = 0 end

	if contentTime == 0 then

		self.protect_time:setVisible(false)
		return
	end

	local str = self:timeStringFormat(contentTime)
	self.protect_time:setString(str)
end

function UIWorldWildRes:getBeFightName()
	
	return self.beFightName
end

function UIWorldWildRes:onExit()

	if self.scheduleListenerIdProtect then

		gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
	end
end

function UIWorldWildRes:isNeedDraw()
	
	return true
end

function UIWorldWildRes:isMiracle()
	
	local self_type = self:getType()
	return self_type == 600 or self_type == 801 or self_type == 802 or self_type == 803 or  self_type == 804 or self_type == 501 or self_type == 502 or self_type == 503 or self_type == 504
end

function UIWorldWildRes:bindPointSprite(sprite)
	self.pointSprite = sprite
end

function UIWorldWildRes:getPointSprite()
	return self.pointSprite
end

function UIWorldWildRes:checkChoose()


	local worldPanel = global.g_worldview.worldPanel
	if worldPanel.gpsCityId == self:getId() then

		worldPanel.gpsCityId = nil
		self:openPanel()
	end
end

function UIWorldWildRes:getUserId()
	
	return self.userId
end

function UIWorldWildRes:isOwner() --只是为了让attackboard访问，代表是不是自己的城?
	
	return false
end

function UIWorldWildRes:isEmpty() --只是为了让attackboard访问，代表是不是村庄
	
	return true
end

function UIWorldWildRes:getIsWarnning() --只是为了让attackboard访问，代表有没有设置警戒
	
	return false
end

function UIWorldWildRes:getAvatarType()
	
	return self.avatarType
end

function UIWorldWildRes:refreshState()

	local count = global.troopData:getTroopInCity(self:getId())
	if not self:isMiracle() then
		count = count - 1
	end

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

function UIWorldWildRes:getColorByAvatar(lAvatar)
	--0 中立 1 自己 2 同盟 3 联盟 4 敌对
	lAvatar = lAvatar or 0
	local color = nil

	if lAvatar == 0 then --中立

		color = luaCfg:get_textcolor_by(4).color
	elseif lAvatar == 1 then --

		color = luaCfg:get_textcolor_by(2).color
	elseif lAvatar == 2 then --

		color = luaCfg:get_textcolor_by(3).color
	elseif lAvatar == 3 then --

		color = luaCfg:get_textcolor_by(3).color
	elseif lAvatar == 4 then --

		color = luaCfg:get_textcolor_by(5).color
	else
		color = luaCfg:get_textcolor_by(1).color
	end
	return cc.c3b(color[1],color[2],color[3])
end

function UIWorldWildRes:openPanel()
	--打开界面
    -- global.tipsMgr:showWarning("FuncNotFinish")

  --   if self:isMiracle() then
  --       global.g_worldview.mapPanel:chooseObject(self)
  --   else
  --   	gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.surfaceData.id)
	 --    if self.data.lState == 1 or self.data.lState == 4 then
	 --    	--中立??
		--     local panel = global.panelMgr:openPanel("UIWildResOwnerPanel")
		--     panel:setData(self.data)
		--     panel:setObj(self)
		-- elseif self.data.lState == 2 and self.data.tagOwner then
		-- 	--占领??
		-- 	if self.data.tagOwner.lAvatar == 1 then
		-- 		--占领者打开
		-- 	    local panel = global.panelMgr:openPanel("UIWildSoldierPanel") 
		-- 	    panel:setData(self.data)
		-- 	    panel:setObj(self)
		-- 	else
		-- 		--非占领者打开
		-- 	    local panel = global.panelMgr:openPanel("UIWildResInfoPanel")
		-- 	    panel:setData(self.data)
		-- 	    panel:setObj(self)
		-- 	end
		-- elseif self.data.lState == 3 then
		-- 	--战斗??
		--     local panel = global.panelMgr:openPanel("UIWildResOwnerPanel")
		--     panel:setData(self.data)
		--     panel:setObj(self)
	 --    else
	 --    end	
  --   end

  	-- global.g_worldview.mapPanel:getCityByIdForAll(self:getId(),1)
end

function UIWorldWildRes:getWorldPos()
	return self.data.sData.lPosX,self.data.sData.lPosY
end

function UIWorldWildRes:getNewScreenPos()
	return self:convertToWorldSpace(cc.p(0,0))
end

--能否驻防操作
function UIWorldWildRes:canStay(isHideTips)

	-- 占领??
	if self.data.lState == 2 and self.data.tagOwner then

		local avatar = self.data.tagOwner.lAvatar
		if self:isMiracle() then
			if avatar == 1 or avatar == 2 then
				return true
			else
				
				if not isHideTips then
					global.tipsMgr:showWarning("Temple01")
				end

				return false
			end
		else
			if avatar == 1 then
				return true
			else
				
				if not isHideTips then
					global.tipsMgr:showWarning("CantGarrisonOthers")
				end

				return false
			end
		end
	else
		if not isHideTips then
			if self:isMiracle() then					
				global.tipsMgr:showWarning("Temple03")
			else
				global.tipsMgr:showWarning("WildGarrison")
			end
		end

		return false
	end

	-- --占领状态，并且是自己的城池
	-- if self.data.lState == 2 and self.data.tagOwner and self.data.tagOwner.lAvatar == 1 then
	-- 	return true
	-- else
	-- 	if self.data.lState == 2 and self.data.tagOwner and self.data.tagOwner.lAvatar ~= 1 then
	-- 		--不能驻防别人的野?
	-- 		if not isHideTips then
	-- 			if self:isMiracle() then					
	-- 				global.tipsMgr:showWarning("Temple01")
	-- 			else
	-- 				global.tipsMgr:showWarning("CantGarrisonOthers")
	-- 			end				
	-- 		end
	-- 	else
			
	-- 		if not isHideTips then
	-- 			if self:isMiracle() then					
	-- 				global.tipsMgr:showWarning("Temple03")
	-- 			else
	-- 				global.tipsMgr:showWarning("WildGarrison")
	-- 			end
	-- 		end
	-- 	end
	-- 	return false
	-- end
end

--占领者信?
function UIWorldWildRes:getOccupierData()
	return self.data.sData.tagCityOwner
end

--领主种族
function UIWorldWildRes:getRaceName(raceId)
	local raceData = luaCfg:get_race_by(raceId)
	return raceData.name
end

function UIWorldWildRes:getLordAllyName()
	return self.data.sData.szAllyFlag
end

--获取神殿范围内的同盟城堡数量
function UIWorldWildRes:getAllyCastleNum()
	if self:isMiracle() then
		return self.data.lCollectCount or 0
	end
	return 0
end

function UIWorldWildRes:getPointSprite()
	
	return self.pointSprite
end

function UIWorldWildRes:initSurface(i_type)
	print('init surface ' .. i_type)
    self.surfaceData = luaCfg:get_world_surface_by(i_type)
end

function UIWorldWildRes:getSurfaceData()
	
	return self.surfaceData
end

function UIWorldWildRes:refresh(data)
	local newData = data or self.data
	self:setData(newData)
end

--CALLBACKS_FUNCS_END


function UIWorldWildRes:setRadius(r)
	self.m_radius = r or 0
end

function UIWorldWildRes:getRadius(r)
	return self.m_radius or 0
end

return UIWorldWildRes

--endregion

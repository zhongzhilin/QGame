
--region UIWorldWildObj.lua
--Author : wuwx
--Date   : 2016/11/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local WCONST  = WCONST
local UIBattleNode = require("game.UI.world.widget.UIBattleNode")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local mailData = global.mailData
local LineMoveControl = require("game.UI.world.utils.LineMoveControl")
local UIBossHead = require("game.UI.world.widget.UIBossHead")

local g_worldview = global.g_worldview

local UIWorldWildObj  = class("UIWorldWildObj", function() return gdisplay.newWidget() end )

local worldConst = require("game.UI.world.utils.WorldConst")

function UIWorldWildObj:ctor()
  
	self:CreateUI()  
end

function UIWorldWildObj:CreateUI()
    local root = resMgr:createWidget("world/worldWildObj")
    self:initUI(root)
end

function UIWorldWildObj:getLevel()
	
	return 1
end

function UIWorldWildObj:changeToLineMap(isCreate)
	
	self:setVisible(false)
end

function UIWorldWildObj:changeToNormalMap(isCreate)
	
	self:setVisible(true)
end


function UIWorldWildObj:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/worldWildObj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.name_export
    self.iconType = self.root.name_export.iconType_export
    self.target = self.root.target_export
    self.monster_node = self.root.monster_node_export
    self.owenr_name = self.root.monster_node_export.owenr_name_export

--EXPORT_NODE_END

	self.isWildObj = true

	self.effectNode = cc.Node:create()
	self:addChild(self.effectNode)
	-- self.owenr_name:setVisible(true)
	-- if global.g_worldview.is3d then

	-- 	local rotation = self:getRotation3D()
 --    	self:setRotation3D(cc.vec3(rotation.x+25,rotation.y,rotation.z))
	-- end
end

function UIWorldWildObj:addMainCityStateListenner()
	
	local refershCall = function()

        -- self:refreshState()
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end

function UIWorldWildObj:getName()
	return self.name:getString()
end

function UIWorldWildObj:isOccupire()
	
	return false
end

function UIWorldWildObj:isBoss()
	
	return self.data.lBossId
end

function UIWorldWildObj:isMe(id)
	
	return self.data.lMonsterID == id
end

function UIWorldWildObj:getId()
	
	return self.data.lMonsterID
end

function UIWorldWildObj:setType(ctype)
	self.data.cityType = ctype
end

function UIWorldWildObj:getType()
	
	return self.data.cityType
end

function UIWorldWildObj:isObjType()
	return true
end

function UIWorldWildObj:getRect()
	
	if tolua.isnull(self.m_monster) then return end
	local size = self.m_monster.size_export:getContentSize()
	local nodePos = cc.p(self.m_monster.size_export:getPosition())

	local x = self:getPositionX()
	local y = self:getPositionY()

	return cc.rect(nodePos.x * self.designerData.size,nodePos.y * self.designerData.size,size.width * self.designerData.size,size.height * self.designerData.size)
end

function UIWorldWildObj:getTouchRect(panelX,panelY)

	local pos = cc.p(self:getPositionX(),self:getPositionY())

	local rect = cc.rect(pos.x + panelX - 40,pos.y + panelY,80,80)

	return rect
end

function UIWorldWildObj:beChoose()
	
	self.target:setVisible(true)
end

function UIWorldWildObj:beUnChoose()
	
	self.target:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldWildObj:choose(sender, eventType)
	self.attack_btn:setVisible(not self.attack_btn:isVisible())
end

local paths = {'ui_surface_icon/train_soldier_def.png','ui_surface_icon/train_soldier_atk.png','ui_surface_icon/train_soldier_hun.png'}

function UIWorldWildObj:setData(data)

	-- dump(data,"check monster data")

	self.effectNode:removeAllChildren()

	self.data = data
	self.designerData = luaCfg:get_wild_monster_by(data.lKind)
	if not self.designerData then return end

	-- if not self.designerData then
	-- 	-- global.tipsMgr:showWarning("#error"..vardump(data))
	-- 	return
	-- end

	self:initSurface(self.designerData.file)

	self:setType(WCONST.WORLD_CFG.CITY_TYPE.WILD_OBJ)

	if self.designerData.normal == 1 then
		self.name:setString('Lv.' .. self.designerData.level)	
		self.iconType:setVisible(true)
	else
		self.name:setString(self.designerData.name)	
		self.iconType:setVisible(false)
	end	

	self.iconType:setSpriteFrame(paths[self.designerData.wartype])

	-- self.icon:setSpriteFrame(self.surfaceData.worldmap)
	self:setPosition(cc.p(data.lPosX,data.lPosY))
	self:setLocalZOrder(-data.lPosY)
	self:beUnChoose()

	self.owenr_name:setString(data.szOwnName and "[" .. data.szOwnName .. "]" or "")

	self.name:setPositionY(self.surfaceData.Ynamedev * self.designerData.size)
	self.owenr_name:setPositionY(27 + self.surfaceData.Ynamedev * self.designerData.size)

	--test
--	self.name:setContentSize(cc.size(400,27))
	--self.name:setString(string.format("%s,(%s,%s),%s",self.name:getString(),self.data.lPosX,self.data.lPosY,self.data.lMonsterID))
	
	local randFrame = math.random(40)
	
	if global.g_worldview.isStory then
		randFrame = 30
	end


	-- body

	if self.inAction and not tolua.isnull(self.inAction) then
		self.inAction:removeFromParent()
		self.inAction = nil
	end

	local node = nil
	local animation = randFrame*5
	if self.data.lBossId then	

		-- 0 = 沉默
		if self.data.lCurState == 0 then
			animation = 'animation3'
		else
			animation = 'animation2'	

			local battle = UIBattleNode.new()
			self.effectNode:addChild(battle)
			battle:setBoss(self)
		end
		
		local bossHead = UIBossHead.new()
		bossHead:setData(self.data.lNextTime,self.data.lCurState,self.name:getString())
		self.effectNode:addChild(bossHead)
		bossHead:setPositionY(self.name:getPositionY())
		self.name:setString('')
	end

	if self.m_monster then
		node = self.m_monster
	else
		local t = 0 
		node = resMgr:createCsbAction(self.surfaceData.worldmap,animation,true , nil , function (frame,node , name)
			if nil == frame then
				return
			end
			local str = frame:getEvent()
			if str == "guidePlaySound" then
				if global.g_worldview.isStory and self.data.lKind == 5040013 and t == 0  then
					gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_3205")
					t = 1
				end	
			end
		end)
		self.monster_node:addChild(node)
		self.m_monster = node
		uiMgr:configUITree(node)
	end

	node:setScale(self.designerData.size)


	self:changeNormalState()

	-- if self.data.tagCityOwner then
	-- 	--有占领者的情况下
	-- 	self.owenr_name:setString(string.format("[%s]",self.data.tagCityOwner.szUserName))
	-- 	self.owenr_name:setTextColor(self:getColorByAvatar(self.data.tagOwner.lAvatar))
	-- else
	-- 	self.owenr_name:setString("")
	-- end	

	if global.g_worldview.worldPanel:getIsLineMap() then

		self:changeToLineMap(true)		
	else

		self:changeToNormalMap(true)
		self:checkChoose()
	end

	self.name:setName("monsterObjName"..data.lMonsterID)
	self.m_monster.size_export:setName("monsterObj"..data.lMonsterID)
	self.m_monster.size_export.getGuideScale = function()
		return self.m_monster:getScale()
	end
end

function UIWorldWildObj:checkChoose()
	
	local worldPanel = global.g_worldview.worldPanel
	
	if self:getId() == global.troopData:gerNewMonsterId() or (self:isBoss() and self.isLvUp) then
		
		if true or global.userData:getGuideStep() == luaCfg:get_guide_stage_by(7).key then
			global.guideMgr:setStepArg(self:getId())
		end

	 	self.inAction = resMgr:createCsbAction("effect/guai_xian", "animation0", false, true)
	 	self:addChild(self.inAction)

	 	if not global.g_worldview.isStory then
	 		gevent:call(gsound.EV_ON_PLAYSOUND,"world_call")
	 	end	 	

	 	global.troopData:setNewMonsterId(0)

		self.m_monster:setVisible(false)
		self.m_monster:runAction(cc.Sequence:create(cc.DelayTime:create(0.9),cc.CallFunc:create(function()			

			global.troopData:setNewMonsterId(0)

			if not global.g_worldview.isStory then
	 			gevent:call(gsound.EV_ON_PLAYSOUND,"wild_begin_"..self.surfaceData.id)	
	 		end	 	
			
		end),cc.Show:create(), cc.DelayTime:create(2.5),  cc.CallFunc:create(function ()
			-- body
			-- if global.g_worldview.isStory and self.data.lKind == 5040013 then
			-- 	gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_3205")
			-- end	
		end) ))
	
		if worldPanel.gpsCityId == self:getId() then

			worldPanel.gpsCityId = nil
		end

		local size = self.m_monster.size_export:getContentSize()
		self.inAction:setScale(size.width / 120 * self.designerData.size)
 
		return
	end

	if worldPanel.gpsCityId == self:getId() then

		worldPanel.gpsCityId = nil
		self:openPanel()
	end
end

--更改野怪动作
function UIWorldWildObj:changeAttackState()
	self.m_monster:setVisible(false)
	
	if self.m_monster_attack then
		self.m_monster_attack:removeFromParent()
		self.m_monster_attack = nil
	end
	local node = resMgr:createCsbAction(self.surfaceData.worldmap,"animation1",true)
	node:setScale(self.designerData.size)
	self.monster_node:addChild(node)
	self.m_monster_attack = node
end

function UIWorldWildObj:changeNormalState()
	self.m_monster:setVisible(true)
	if self.m_monster_attack then
		self.m_monster_attack:removeFromParent()
		self.m_monster_attack = nil
	end
end

function UIWorldWildObj:getColorByAvatar(lAvatar)
	--0 中立 1 自己 2 同盟 3 联盟 4 敌对
	lAvatar = lAvatar or 0
	local color = luaCfg:get_textcolor_by(lAvatar+1).color
	return cc.c3b(color[1],color[2],color[3])
end

function UIWorldWildObj:openPanel()
	--打开界面
    --global.tipsMgr:showWarning("FuncNotFinish")
	gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.surfaceData.id)

	-- boss
	-- lBelongsType:  3 普通boss 6 极限boss
	if self.data.lBelongsType == 3 or self.data.lBelongsType == 6 then
		local bosMonPanel = global.panelMgr:openPanel("UIBosMonstPanel")
		bosMonPanel:setData({}, self.data)
	else 
		-- 普通野怪

		if self.designerData.sort == 7 then
			global.panelMgr:openPanel('UIWorldBossPanel'):setData(self.data,self.surfaceData,self.designerData)
		else
			local monsterPanel = global.panelMgr:openPanel("UIWildMonsterPanel")
			monsterPanel:setData(self.data)	
		end		
	end

    -- local worldPanel = global.g_worldview.worldPanel

    -- local troopId = 67088
    -- global.worldApi:attackCity(worldPanel.mainId,self.data.lResID,7,troopId,function(msg)
    -- end)
end

function UIWorldWildObj:getWorldPos()
	return self.data.sData.lPosX,self.data.sData.lPosY
end

function UIWorldWildObj:getNewScreenPos()
	return self:convertToWorldSpace(cc.p(0,0))
end

--占领者信息
function UIWorldWildObj:getOccupierData()
	return self.data.sData.tagCityOwner
end

--领主种族
function UIWorldWildObj:getRaceName(raceId)
	local raceData = luaCfg:get_race_by(raceId)
	return raceData.name
end

function UIWorldWildObj:getLordAllyName()
	return self.data.sData.szAllyFlag
end

function UIWorldWildObj:getDesignData()
	return self.designerData
end

function UIWorldWildObj:getDesignDataScale()
	return self.designerData.scale
end

function UIWorldWildObj:getPointSprite()
	
	return self.pointSprite
end

function UIWorldWildObj:initSurface(i_type)
    self.surfaceData = luaCfg:get_world_surface_by(i_type)
end

function UIWorldWildObj:getSurfaceData()
	
	return self.surfaceData
end


function UIWorldWildObj:getWorldMap()
	if self.surfaceData then
		return self.surfaceData.worldmap
	else
		return nil
	end
end

function UIWorldWildObj:refresh(data)
	local newData = data or self.data	
	if self.data and self.data.lBossId then
		self.isLvUp = (newData.lBossId ~= self.data.lBossId)
	end
	self:setData(newData)
	self.isLvUp = false
end

--CALLBACKS_FUNCS_END


function UIWorldWildObj:setRadius(r)
	self.m_radius = r or 0
end

function UIWorldWildObj:getRadius(r)
	return self.m_radius or 0
end

return UIWorldWildObj

--endregion

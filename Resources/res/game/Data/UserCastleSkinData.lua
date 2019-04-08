
local _M = {}

local luaCfg = global.luaCfg
local gameEvent = global.gameEvent

gameEvent.EV_ON_CASTLE_SKILL_UPDATE ="EV_ON_CASTLE_SKILL_UPDATE"
gameEvent.EV_ON_CASTLE_SKILL_CLICK ="EV_ON_CASTLE_SKILL_CLICK"

_M.STATE = {ON = 1 , OFF=2 } 

function _M:init(selectid, canUseData)

	dump(selectid , "selectid")
	dump(canUseData , "canUseData")

	local default = {lSkinID = self:getDefaultId() }

	if selectid == 0  or  selectid== nil   then 

		selectid = default.lSkinID
	end 

	canUseData= canUseData or {}

	table.insert(canUseData , default)

	local  temp = {} 

	for _ ,v in  pairs(global.luaCfg:world_city_image()) do 

		if v.avatar  == 1 then 
			table.insert(temp , v)
		end 
	end 

	table.insert(temp , global.luaCfg:get_world_city_image_by(default.lSkinID))

    self.data = clone(temp)

    for _ ,v in pairs(self.data ) do 

    	v.state = self.STATE.OFF
    end 

	for _ ,v in pairs(self.data) do 

		for  _ ,vv in pairs(canUseData) do 

			if vv.lSkinID == v.id then 

				v.state = self.STATE.ON
				v.serverData = vv 
			end 
		end 
	end

	self:setCrutSkinNoUpdateUI(selectid)

	if self:getPanelIndex() == 1 then 

		global.userCastleSkinData:setClickSkinNoUpdateUI(global.userCastleSkinData:getDefaulSelectId())

	elseif  self:getPanelIndex() == 2  then 

	    global.userCastleSkinData:setClickSkinNoUpdateUI(global.userCastleSkinData:getCrutSkin().id)

	end 

end

function _M:updateInfo()
	global.loginApi:getUserCastleSkin(function (msg ) 
		if not msg.lBackId then return end 
		self:init(msg.lBackId, msg.tagAvatarSkin)
		self:updateUi()
	end ) 
end 



function _M:getDefaultId()

	local race_data = luaCfg:race_world_surface()
	local kind =  global.userData:getRace()
	local level =  global.cityData:getBuildingById(1).serverData.lGrade
	local levelData = nil
	for _,v in ipairs(race_data) do
		if level >= v.level then

			levelData = v
		end
	end 

	id = levelData["race"..kind]

	return id 
end



function _M:getSkinData()

	return self.data 
end 


function _M:deblockingSkin(tagAvatarSkin) -- 解锁头像

	for _ ,v  in pairs(self.data) do 
		if v.id == tagAvatarSkin.lSkinID then 
			v.state = self.STATE.ON
			v.serverData = tagAvatarSkin
		end 
	end

	self:updateUi()
end


function _M:updateUi()

 	gevent:call(gameEvent.EV_ON_CASTLE_SKILL_UPDATE)
end 

function _M:getUnlockSkill()

	local temp = {} 
		
	for _ ,v in pairs(self.data) do 

		if v.state == self.STATE.ON then 
			table.insert(temp , v)
		end 
	end 

	return temp 
end 


function _M:getClickSkin()

	for _ ,v  in pairs(self.data) do 

		if v.click then 

			return v 
		end  
	end

end


function _M:setClickSkinNoUpdateUI(id)

	for _ ,v in pairs(self.data) do 
		v.click  = false 
	end 

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.click = true 
		end 
	end
end



function _M:setCrutSkinNoUpdateUI(id)


	for _ ,v in pairs(self.data) do 
		v.select  = false 
	end 

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.select = true 
		end 
	end

end 




function _M:getAllCanBuykin()
	local skin = {} 

	for _ ,v in pairs(self.data) do 
		if v.avatar  == 1 then 
			table.insert(skin , v)
		end 
	end 
	return skin 
end 


function _M:setClickSkin(id)


	for _ ,v in pairs(self.data) do 
		v.click  = false 
	end 

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.click = true 
		end 
	end




	self:updateUi()
end 



function _M:getCrutSkin()

	for _ ,v  in pairs(self.data) do 

		if v.select then 

			return v 
		end  
	end

end


function _M:setCrutSkin(id)


	for _ ,v in pairs(self.data) do 
		v.select  = false 
	end 

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.select = true 
		end 
	end

	self:updateUi()
end 


function _M:getDefaulSelectId()

	for _ ,v in  pairs(global.luaCfg:world_city_image()) do 

		if v.default  == 1 then 

			return v.id
		end 
	end 
end 

function _M:setPanelIndex(index)

	self.panelIndex =  index 

end 


function _M:getPanelIndex()

	return self.panelIndex	
end 


global.userCastleSkinData = _M

--endregion

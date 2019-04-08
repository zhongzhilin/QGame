--region UITop.lua
--Author : anlitop
--Date   : 2017/06/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITop  = class("UITop", function() return gdisplay.newWidget() end )


local UITopHero = require("game.UI.replay.view.UITopHero")
local UISoldier = require("game.UI.replay.view.UISoldier")
local actionManger  =require("game.UI.replay.excute.actionManger")

function UITop:ctor()
    self:CreateUI()
end

function UITop:CreateUI()
    local root = resMgr:createWidget("player/node/top")
    self:initUI(root)
end

function UITop:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/top")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_scrollview = self.root.hero_scrollview_export
    self.soldier_scrollview = self.root.soldier_scrollview_export
    self.add_soldier_ps = self.root.soldier_scrollview_export.add_soldier_ps_export
    self.mode = self.root.soldier_scrollview_export.mode_export

--EXPORT_NODE_END
	self.soldier_scrollview:setLocalZOrder(9)
    self.hero_scrollview:setLocalZOrder(10)

	self.soldier_ps ={}
 	self.soldier_ps.x,self.soldier_ps.y=  self.add_soldier_ps:getPosition()

end


local  showSoldierNumber =  6

local  showHeroNumber= 5 

local  hero_width = 131

local  solider_width = 110

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITop:OnSlideEvent(sender, eventType)
	print(eventType,"eventType")
	dump(self.hero_scrollview:getPositionPercent(),"dsfs")

end

function UITop:onSoldierSlideEvent(sender, eventType)

	-- print(eventType,"eventType")
	self.soldier_scrollview:getInnerContainer()
	dump(self.soldier_scrollview:getInnerContainerPosition(),"sdfasdf123")
	dump(self.soldier_scrollview:getPositionPercent(),"sdf")

end
--CALLBACKS_FUNCS_END

function UITop:setData()

end 

function UITop:onEnter()

	self.add_soldier_ps:removeFromParent()

	self.soldier_scrollview:setSwallowTouches(false)
	-- self.hero_scrollview:setSwallowTouches(false)
end 


function UITop:showSelf()
     actionManger.getInstance():createTimeline(self.root  ,"top" , true , true)
end 

function UITop:hideSelf()
    -- actionManger.getInstance():createAction(self, "top1" , true)
end 

function UITop:showHero()
	
	for _ ,v in pairs(self.hero_scrollview:getChildren())do
		v:setVisible(true)
	end 
end 

function UITop:hideHero()
	
	for _ ,v in pairs(self.hero_scrollview:getChildren())do
		v:setVisible(false)
	end 

end 

function UITop:hideSoliderlight()
	local temp = self:getValidSoldierChildern()

	for _, v in pairs(temp) do 
		if v.hideLight then 
			-- print("UITop","uitop  隐藏光")
			v:hideLight()		
		end 
	end 
end 

function UITop:showSoldier()

	local temp = self:getValidSoldierChildern()

	table.sort(temp , function(A  ,B) return A.index < B.index end)

	for i = 1, #temp do 
		local v = temp[i]
		local call = nil 
		if i-1 == showSoldierNumber then 
			-- v:setVisible(true)
			call = function ()   
				v:hideLight()
			end 
		else 
			call  = function () 
				v:setVisible(true)
				v:showAction1()
			end 
		end
		local dealy = cc.DelayTime:create(i * 0.2) 
		local a1 = cc.Sequence:create(dealy , cc.CallFunc:create(call))
		actionManger.getInstance():createAction(self, a1 , true)
	end 
end 

function UITop:hideSoldier()
	for _ ,v in pairs(self:getValidSoldierChildern())do
		v:hideSelfNoAction()
	end 
end 



function UITop:getValidSoldierChildern()
	local temp = self.soldier_scrollview:getChildren()

	for i = #temp, 1, -1 do
	   if not temp[i].isvalid then 
	   		table.remove(temp, i)
	 	end 
	end

	return temp 
end


function UITop:getSoldierChildern()
	local temp = self.soldier_scrollview:getChildren()
	return temp
end


function UITop:setSoldierData(soldierData)

	local cache =  self:getSoldierChildern()

	self:cleanSolider()

	local soldierUI = {} 

	for _ , v in pairs(soldierData) do 

		local isExits = false 
		-- for _ ,vv in pairs(cache) do 
		-- 	if v.soldierId  == vv.data.soldierId then 
		-- 		isExits = true 
		-- 		vv:cleanTips()
		-- 		vv:updateCount(v)
		-- 		vv.isCache = true 
		-- 		table.insert(soldierUI , vv)
		-- 	end 
		-- end 

		for i = #cache, 1, -1 do

			if v.soldierId  == cache[i].data.soldierId then 
				isExits = true 
				cache[i]:cleanTips()
				cache[i]:updateCount(v)
				cache[i].isCache = true 
				table.insert(soldierUI , cache[i])
				table.remove(cache  ,  i )
				break
			end 

		end


		if not isExits then 
			local Soldier = UISoldier.new()
			Soldier:setData(v)
			table.insert(soldierUI , Soldier)
		end 
	end 

 	for i= 1 ,#soldierUI do 

 		soldierUI[i].index =  i 
 	end 

 	self.soldieroMaxIndex = showSoldierNumber

	self:addsoldier(soldierUI)
end 


function UITop:setHeroData(heroData)


	-- dump(heroData , "/sdf/sDataf/asdfasdf")

	-- self.hero_scrollview:removeAllChildren()
	self:cleanHero()

	local heroUI = {} 

	for _ , v in pairs(heroData) do 

		local hero = UITopHero.new()

		hero:setData(v)

		table.insert(heroUI , hero)
	end 
 	
 	for i= 1 ,#heroUI do 

 		heroUI[i].index =  i 
 	end 

 	self.heroMaxIndex = showHeroNumber
 	
	self:addHero(heroUI)
end 


function UITop:addsoldier(soldierUI) 

	local width=  solider_width * #soldierUI
	
	if width < self.soldier_scrollview:getContentSize().width then 
		width = self.soldier_scrollview:getContentSize().width
	end 

	self.soldier_scrollview:setInnerContainerSize(cc.size(width, self.soldier_scrollview:getContentSize().height))

	for i = 1, #soldierUI do

  		if soldierUI[i].isCache then 
		else 
  			self.soldier_scrollview:addChild(soldierUI[i])
  		end 

  		print(self.soldier_ps.y,"self.soldier_ps.y//////////////")

  		soldierUI[i]:setPositionX((i-1) * solider_width)
		soldierUI[i]:setPositionY(self.soldier_ps.y)
  		soldierUI[i].isvalid = true 
	end

end 



function UITop:cleanSolider()

	for _  ,v in pairs(self:getValidSoldierChildern()) do 
		-- print("UItop 士兵从容器中异常。//////////")
		v:hideSelfNoAction()
		v.isvalid = false 
	end 
end 


function UITop:cleanHero()

	for _  ,v in pairs(self.hero_scrollview:getChildren()) do 
		v:removeFromParent()
	end 
end 



function UITop:addHero(herodUI)

	local width=  hero_width * #herodUI

	self.hero_scrollview:setInnerContainerSize(cc.size(width, self.hero_scrollview:getContentSize().height))
	
	for i = 1, #herodUI do

		herodUI[i]:setPositionX((i-1) * hero_width)

  		self.hero_scrollview:addChild(herodUI[i])
	end

end 


function UITop:updateHero(data)


	-- dump(data , "what the  fuck ////////////")

	for  _ ,v in pairs(data)  do 
		for _ ,vv  in pairs(self.hero_scrollview:getChildren()) do 

			if vv.data.lTroopID == v.lTroopID then 

				vv:updateCount(v)
			end 
		end 
	end 
end 


function UITop:chooseHero(station)

	if not station then return end 

	local status , step , direction  =  self:HeroMove(station)

	-- print("攻击方=====",station , "station" , status , "status" , step , "step" , direction, "direction")

	if status then 

	    local container = self.hero_scrollview:getInnerContainer()

	    local x = 0

	    if direction  == 1 then 

	    	x = step * hero_width

	    	self.heroMaxIndex  =self.heroMaxIndex - step

	    else 
	    	x = -step * hero_width

	    	self.heroMaxIndex  = station
	    end  

		local moveAction = cc.MoveBy:create(0.2, cc.p(x, self.hero_scrollview:getInnerContainerPosition().y))

		actionManger.getInstance():createAction(container, moveAction , true)
	end 
end

function UITop:chooseSolider(station)

	if not station then return end 

	local status , step , direction  =  self:soldierMove(station)

	-- print("UITop 士兵chooseSolider==>" ,station , "选择士兵的位置station" , status , "是否移动status" , step , "移动步数step" , direction, "方向direction")

	if status then 

	    local container = self.soldier_scrollview:getInnerContainer()

	    local x = 0

	    if direction  == 1 then 

	    	x = step * solider_width

	    	self.soldieroMaxIndex  =self.soldieroMaxIndex - step

	    else 
	    	x = -step * solider_width

	    	self.soldieroMaxIndex  = station
	    end  

		local moveAction = cc.MoveBy:create(0.2, cc.p(x, self.soldier_scrollview:getInnerContainerPosition().y))

		actionManger.getInstance():createAction(container, moveAction , true)
	end 
end


function UITop:chooseSolider2(station)

	if not station then return end 

	local out_x =  self:setSoldieroMaxIndex()

	local x = 0

	 print(out_x , "out_x m ===========")

	local status , step , direction  =  self:soldierMove(station)

	-- print("UITop 士兵chooseSolider==>" ,station , "选择士兵的位置station" , status , "是否移动status" , step , "移动步数step" , direction, "方向direction")
	
	local container = self.soldier_scrollview:getInnerContainer()

	if status then 

	    if direction  == 1 then 

	    	x = step * solider_width

	    	self.soldieroMaxIndex  =self.soldieroMaxIndex - step

	    else 
	    	x = -step * solider_width

	    	self.soldieroMaxIndex  = station
	    end  
	end 
	print( x, "移动 x ======")

	local moveAction = cc.MoveBy:create(0.2, cc.p(out_x + x, self.soldier_scrollview:getInnerContainerPosition().y))
	actionManger.getInstance():createAction(container, moveAction , true)
end


function UITop:chooseHero2(station)

	if not station then return end 

	local out_x =  self:setHeroMaxIndex()

	local x = 0

	 print(out_x , "chooseHero2 UITop  out_x m ===========")

	local status , step , direction  =  self:HeroMove(station)

	-- print("UITop 士兵chooseSolider==>" ,station , "选择士兵的位置station" , status , "是否移动status" , step , "移动步数step" , direction, "方向direction")
	
	local container = self.hero_scrollview:getInnerContainer()

	if status then 

	    if direction  == 1 then 

	    	x = step * hero_width

	    	self.heroMaxIndex  =self.heroMaxIndex - step

	    else 
	    	x = -step * hero_width

	    	self.heroMaxIndex  = station
	    end  
	end 
	print( x, "chooseHero2 UITop 移动 x ======")

	print("为什么不移动？？",out_x + x)

	local moveAction = cc.MoveBy:create(0.2, cc.p(out_x + x, self.hero_scrollview:getInnerContainerPosition().y))
	actionManger.getInstance():createAction(container, moveAction , true)
end


function UITop:setHeroMaxIndex()

	local x  = math.abs(self.hero_scrollview:getInnerContainerPosition().x)

	local out_x = x % hero_width

	local move_number = (x - out_x) / hero_width  
	
	if move_number < 0  then move_number = 0  end  

	self.heroMaxIndex = showHeroNumber + move_number

	return  out_x
end


function UITop:setSoldieroMaxIndex()

	local x  = math.abs(self.soldier_scrollview:getInnerContainerPosition().x)

	local out_x = x % solider_width

	local move_number = (x - out_x) / solider_width  
	
	if move_number < 0  then move_number = 0  end  

	self.soldieroMaxIndex = showSoldierNumber + move_number

	return  out_x
end

function UITop:HeroMove(station) 	-- 记录边界值


	-- print("检测 ---》",	self.heroMaxIndex  , station)

	if station > self.heroMaxIndex  then 

		return true  , station - self.heroMaxIndex   ,  2 
	end 

	if station <= self.heroMaxIndex - showHeroNumber then 

		return true  , self.heroMaxIndex - showHeroNumber - station + 1  , 1 
	end 

	return false 

end

function UITop:soldierMove(station) -- 记录边界值

	if station > self.soldieroMaxIndex  then 

		return true  , station - self.soldieroMaxIndex   ,  2 
	end 

	if station <= self.soldieroMaxIndex - showSoldierNumber then 

		return true  , self.soldieroMaxIndex - showSoldierNumber - station + 1 , 1 
	end 

	return false 
end


function UITop:showHerolight(station)
	for _ ,v in pairs( self.hero_scrollview:getChildren()) do 
	 	if v.index  == station then 
	 		v:showAction0()
	 		return 
	 	end 
	 end 
end 



function UITop:showSoldierlight(station)
	for _ ,v in pairs( self:getValidSoldierChildern()) do 
	 	if v.index  == station then 
	 		v:showAction()
	 		return 
	 	end 
	 end 
end 


function UITop:hideHeroLight()
	for _ ,v in pairs( self.hero_scrollview:getChildren()) do 
		v:hideHeroLight()
	end 
end 

function UITop:updateSoldierData( crunt_attack_solder )

	for  _ ,v in pairs(crunt_attack_solder) do 

		for _ ,vv in pairs(self:getValidSoldierChildern())  do 

			if v.lIndex == vv.data.lIndex then 

				vv:updateCount(v,true)
			end 
		end	
	end 
end

function UITop:setSelectSoldierStation(station)
	for _ ,v in pairs( self:getValidSoldierChildern()) do 
	 	if v.index  == station then 
	 		self.selectSoldierStation = v:convertToWorldSpace(cc.p(0,0))
	 		return 
	 	end 
	end 
end 

function UITop:getSelectSoldierStation()

	return self.selectSoldierStation
end 


return UITop

--endregion

--region UIBottom.lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local config = global.EasyDev
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBottom  = class("UIBottom", function() return gdisplay.newWidget() end )

-- 
local bottomControl  =require("game.UI.replay.control.bottomControl")

local UIBottomHero = require("game.UI.replay.view.UIBottomHero")
local UISoldier = require("game.UI.replay.view.UISoldier")

local actionManger  =require("game.UI.replay.excute.actionManger")


local  showSoldierNumber =  6

local  showHeroNumber= 5 

local  hero_width = 132

local  solider_width =110


function UIBottom:ctor()
    self:CreateUI()
end

function UIBottom:CreateUI()
    local root = resMgr:createWidget("player/node/bottom")
    self:initUI(root)
end

function UIBottom:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/bottom")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_scrollview = self.root.hero_scrollview_export
    self.soldier_scrollview = self.root.soldier_scrollview_export
    self.add_soldier_ps = self.root.soldier_scrollview_export.add_soldier_ps_export

--EXPORT_NODE_END
	self.soldier_ps ={}
 	self.soldier_ps.x,self.soldier_ps.y=  self.add_soldier_ps:getPosition()

    uiMgr:addWidgetTouchHandler(self.hero_scrollview, function(sender, eventType) self:OnSlideEvent(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.soldier_scrollview, function(sender, eventType) self:onSoldierSlideEvent(sender, eventType) end, true)

     -- self.mode:setTag(999)
    -- self.soldier_scrollview:setSwallowTouches(false)
    self.soldier_scrollview:setLocalZOrder(9)
    self.hero_scrollview:setLocalZOrder(10)
end


function UIBottom:onEnter()
  -- local control  = bottomControl.new()
  -- control:setData(self)

	self.add_soldier_ps:removeFromParent()
	self.soldier_scrollview:setSwallowTouches(false)
	-- self.hero_scrollview:setSwallowTouches(false)
end 




function UIBottom:setData()

end 

function UIBottom:showSelf()

     actionManger.getInstance():createTimeline(self.root,"bottom" , true , true)
end 

function UIBottom:hideSelf()

    -- actionManger.getInstance():createAction(self, "top1" , true)

end 


function UIBottom:OnSlideEvent(sender, eventType)
	print(eventType,"eventType")
	dump(self.hero_scrollview:getPositionPercent(),"dsfs")

end

function UIBottom:onSoldierSlideEvent(sender, eventType)

	-- print(eventType,"eventType")
	self.soldier_scrollview:getInnerContainer()
	dump(self.soldier_scrollview:getInnerContainerPosition(),"sdfasdf123")
	dump(self.soldier_scrollview:getPositionPercent(),"sdf")

end


function UIBottom:hideSoliderlight()

	-- print("隐藏 bottom  光回掉。")
	local temp = self:getValidSoldierChildern()

	-- print(#temp , "bottom 数量///////////")

	for _, v in pairs(temp) do 
		if v.hideLight then 
			-- print("UIBottom","UIBottom  隐藏光")
			v:hideLight()		
		end 
	end 
end 

	
function UIBottom:showHero()
	
	for _ ,v in pairs(self:getHeroChildern())do

		v:setVisible(true)
	end 

end 


function UIBottom:updateSoldierData( crunt_def_solder )

	for  _ ,v in pairs(crunt_def_solder) do 

		for _ ,vv in pairs(self:getValidSoldierChildern())  do 

			if v.lIndex == vv.data.lIndex then 

				vv:updateCount(v , true)
			end 
		end	
	end 
end


function UIBottom:getValidSoldierChildern()
	local temp = self.soldier_scrollview:getChildren()

	for i = #temp, 1, -1 do
	   if not temp[i].isvalid then 
	   		table.remove(temp, i)
	 	end 
	end

	return temp 
end


function UIBottom:getSoldierChildern()
	local temp = self.soldier_scrollview:getChildren()
	return temp
end

function UIBottom:getHeroChildern()

	local temp = self.hero_scrollview:getChildren()

	return temp 
end 



function UIBottom:hideHero()
	
	for _ ,v in pairs(self:getHeroChildern())do
		v:setVisible(false)
	end 

end 
function UIBottom:showSoldier()

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

function UIBottom:hideSoldier()
	
	for _ ,v in pairs(self:getSoldierChildern())do
		v:hideSelfNoAction()
	end 

end 


function UIBottom:setSoldierData(soldierData)

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

	local temp = {}

	for i = #soldierUI, 1, -1 do       -- bottom 倒序

		table.insert(temp , soldierUI[i])
	end

 	self.soldieroMaxIndex = showSoldierNumber

	self:addsoldier(temp)
end 


function UIBottom:updateHero(data)

	for  _ ,v in pairs(data)  do 

		for _ ,vv  in pairs(self:getHeroChildern()) do 

			if vv.data.lTroopID == v.lTroopID then 

				vv:updateCount(v)
			end 
		end 
	end 

end


function UIBottom:setHeroData(heroData) --传进来的数据 是正序的

	self:cleanHero()

	local heroUI = {}

	for _ , v in pairs(heroData) do 

		local hero = UIBottomHero.new()

		hero:setData(v)

		table.insert(heroUI , hero)
	end 

 	for i= 1 ,#heroUI do 
 		heroUI[i].index =  i 
 	end 

	local temp = {}

	for i = #heroUI, 1, -1 do       -- bottom 倒序

		table.insert(temp , heroUI[i])

	end
 	
 	self.heroMaxIndex = showHeroNumber
	self:addHero(temp)
end 


function UIBottom:addsoldier(soldierUI) 

	local width=  solider_width * #soldierUI

	local height = self.soldier_scrollview:getContentSize().height

	if width < self.soldier_scrollview:getContentSize().width then 
		width = self.soldier_scrollview:getContentSize().width
	end 

	self.soldier_scrollview:setInnerContainerSize(cc.size(width, height))

	for i = 1, #soldierUI do
		soldierUI[i]:setPositionX(width-(#soldierUI-i+1)*solider_width)
		soldierUI[i]:setPositionY(self.soldier_ps.y)
		if soldierUI[i].isCache then 
		else 
  			self.soldier_scrollview:addChild(soldierUI[i])
  		end 
  		soldierUI[i].isvalid = true 
	end

	self.soldier_scrollview:scrollToPercentHorizontal(100 , 0 , false)
end 


function UIBottom:addHero(herodUI)


	local width=  hero_width * #herodUI

	local height = 100

	if width < self.hero_scrollview:getContentSize().width then 

		width = self.hero_scrollview:getContentSize().width
	end 

	self.hero_scrollview:setInnerContainerSize(cc.size(width, height))
	
	for i = 1, #herodUI do

		herodUI[i]:setPositionX(width-(#herodUI-i+1)*hero_width)
  		self.hero_scrollview:addChild(herodUI[i] ,1)
	end

	self.hero_scrollview:scrollToPercentHorizontal(100 , 0 , false)
end 



function UIBottom:cleanSolider()

	for _  ,v in pairs(self:getValidSoldierChildern()) do 
		v:hideSelfNoAction()
		v.isvalid = false 
	end 
end 


function UIBottom:cleanHero()

	for _  ,v in pairs(self:getHeroChildern()) do 
		v:removeFromParent()
	end 
end 



function UIBottom:chooseHero(station)

	if not station then return end 

	local status , step , direction  =  self:HeroMove(station)

	print(station , "station" , status , "status" , step , "step" , direction, "direction")

	if status then 

	    local container = self.hero_scrollview:getInnerContainer()

	    local x = 0

	    if direction  == 1 then 

	    	x = step * hero_width

	    	self.heroMaxIndex  = station
	    else 
	    	x = -step * hero_width

	    	self.heroMaxIndex  =self.heroMaxIndex - step
	    end  

		local moveAction = cc.MoveBy:create(0.3, cc.p(x, self.hero_scrollview:getInnerContainerPosition().y))

		actionManger.getInstance():createAction(container, moveAction , true)
	end 
end

function UIBottom:chooseSolider(station)

	if not station then return end 

	local status , step , direction  =  self:soldierMove(station)

	-- print("士兵chooseSolider==>" ,station , "station" , status , "status" , step , "step" , direction, "direction")
	if status then 

	    local container = self.soldier_scrollview:getInnerContainer()

	    local x = 0

	    if direction  == 1 then 

	    	x = step * solider_width

	    	self.soldieroMaxIndex  = station
	    else 
	    	x = -step * solider_width

	    	self.soldieroMaxIndex  =self.soldieroMaxIndex - step
	    end  

		local moveAction = cc.MoveBy:create(0.3, cc.p(x, self.soldier_scrollview:getInnerContainerPosition().y))

		actionManger.getInstance():createAction(container, moveAction , true)
	end 
end


function UIBottom:chooseSolider2(station)

	if not station then return end 

	local out_x =  self:setSoldieroMaxIndex()

	local x = 0

	print(out_x , "UIBottom out_x m ===========")

	local status , step , direction  =  self:soldierMove(station)
	
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

	print( x, "UIBottom  移动 x ======")

	local moveAction = cc.MoveBy:create(0.2, cc.p(-out_x + x, self.soldier_scrollview:getInnerContainerPosition().y))

	actionManger.getInstance():createAction(container, moveAction , true)
end


function UIBottom:chooseHero2(station)

	if not station then return end 

	local out_x =  self:setHeroMaxIndex()

	print( out_x, "UIBottom  chooseHero2 移动 out_x ======")

	local status , step , direction  =  self:HeroMove(station)

	print(station , "station" , status , "status" , step , "step" , direction, "direction")

	local container = self.hero_scrollview:getInnerContainer()

	local x = 0

	if status then 

	    if direction  == 1 then 

	    	x = step * hero_width

	    	self.heroMaxIndex  = station
	    else 
	    	x = -step * hero_width

	    	self.heroMaxIndex  =self.heroMaxIndex - step
	    end  

	end
		
	print( x, "UIBottom  chooseHero2 移动 x ======")

	local moveAction = cc.MoveBy:create(0.2, cc.p(-out_x + x, self.hero_scrollview:getInnerContainerPosition().y))

	actionManger.getInstance():createAction(container, moveAction , true)
end

function UIBottom:setSoldieroMaxIndex()

	local width = self.soldier_scrollview:getInnerContainer():getContentSize().width
	-- print(width , "容器大小 ////////")
	-- print(self.soldier_scrollview:getInnerContainerPosition().x , "getInnerContainerPosition  X ////////")

	width = width - solider_width  * showSoldierNumber

	local x  = width - math.abs(self.soldier_scrollview:getInnerContainerPosition().x)

	local out_x = x % solider_width

	local move_number = (x - out_x) / solider_width  

	if move_number < 0  then

		 move_number = 0
		 out_x = 0
	end  

	self.soldieroMaxIndex = showSoldierNumber + move_number

	return  out_x
end

function UIBottom:setHeroMaxIndex()

	local width = self.hero_scrollview:getInnerContainer():getContentSize().width
 
	width = width - hero_width  * showHeroNumber

	local x  = width - math.abs(self.hero_scrollview:getInnerContainerPosition().x)

	local out_x = x % hero_width

	local move_number = (x - out_x) / hero_width  

	if move_number < 0  then
		 move_number = 0
		 out_x = 0
	end  

	self.heroMaxIndex = showHeroNumber + move_number

	return  out_x
end


function UIBottom:HeroMove(station) 	-- 记录边界值

	print("UIBottom 检测 ---》",	self.heroMaxIndex  , station)

	if station > self.heroMaxIndex  then 

		return true  , station - self.heroMaxIndex   ,  1
	end 

	if station <= self.heroMaxIndex - showHeroNumber then 

		return true  , self.heroMaxIndex - showHeroNumber - station + 1  , 2 
	end 

	return false 

end

function UIBottom:soldierMove(station) -- 记录边界值

	if station > self.soldieroMaxIndex  then 

		return true  , station - self.soldieroMaxIndex   ,  1 
	end 

	if station <= self.soldieroMaxIndex - showSoldierNumber then 

		return true  , self.soldieroMaxIndex - showSoldierNumber - station + 1 , 2 
	end 

	return false 
end


function UIBottom:Heroslide()

	local container = self.scrollviewPanel:getInnerContainer()
	local  isEnoughOneItem, scroX, sW  =  self:checkEnoughOneItem(1)
	if isEnoughOneItem > 1 then
		local moveAction = cc.MoveTo:create(0.3, cc.p(scroX-sW, self.scrollviewPanel:getInnerContainerPosition().y))
		container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
		self.leftBtn:setEnabled(true)
	else
		self.scrollviewPanel:scrollToPercentHorizontal(100, 1, true)
		self.rightBtn:setEnabled(false)
	end
end 



function UIBottom:showHerolight(station)

	for _ ,v in pairs( self:getHeroChildern()) do 
	 	if v.index  == station then 
	 		v:showAction0()
	 		return 
	 	end 
	 end 

end 



function UIBottom:showSoldierlight(station)
	for _ ,v in pairs( self:getValidSoldierChildern()) do 
	 	if v.index  == station then 
	 		v:showAction()
	 		return 
	 	end 
	 end 
end 


function UIBottom:hideHeroLight()
	for _ ,v in pairs( self:getHeroChildern()) do 
		v:hideHeroLight()
	end 
end


function UIBottom:setSelectSoldierStation(station)
	for _ ,v in pairs( self:getValidSoldierChildern()) do 
	 	if v.index  == station then 
	 		self.selectSoldierStation = v:convertToWorldSpace(cc.p(0,0))
			return 
	 	end 
	end 
end 

function UIBottom:getSelectSoldierStation()

	return self.selectSoldierStation
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBottom

--endregion

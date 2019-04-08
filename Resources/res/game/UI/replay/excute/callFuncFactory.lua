--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local callFuncFactory = class("callFuncFactory")


function callFuncFactory:setData(coreAnalyze , view)

	self.coreAnalyze = coreAnalyze

	self.view = view 
end


function callFuncFactory:hideTopSolider()
	local fc = function () 
		if  self.isChooseTopHero then 
			self.view:hideTopSolider()
		end 
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:hideBottomSolider()
	local fc = function () 
		if  self.isChooseBottomHero then 
			self.view:hideBottomSolider()
		end 
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:cleanTopSoliderLight()
	local fc = function () 
		self.view:hideTopSoliderlight()
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:cleanBottomSoliderLight()
	local fc = function () 
		self.view:hideBottomSoliderlight()
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:cleanTopSolider()
	local fc = function () 
		if self.isChooseTopHero then 
			self.view:cleanTopSolider()
		end 
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:cleanBottomSolider()
	local fc = function () 
		if self.isChooseBottomHero then 
			self.view:cleanBottomSolider()
		end 
	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:updateProgress()
	local fc = function () 

		self.view:setRoundData()

		self.view:updateProgress()
	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:showTitle()

	local fc = function () 

		if  self.isShowTitle then 

			self.view:setTitleData()

			self.view:showTitle()
		end 

	end 
	return self:createCallFunc(fc)
end 


function callFuncFactory:hideTitle()
	local fc = function () 

		if self.isShowTitle then 

			self.view:hideTitleWithAction()
		end 

	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:chooseHero()
	local fc = function () 

		if  self.isChooseTopHero then 

			self.view:chooseTopHero()
		end

		if  self.isChooseBottomHero then 

			self.view:chooseBottomHero()
		end
	end 
	return self:createCallFunc(fc)
end





function callFuncFactory:showHeroLight()
	local fc = function () 
		
		if  self.isChooseTopHero then

			self.view:hideTopHeroLight()

			self.view:showTopHerolight()
		end 

		if  self.isChooseBottomHero then 

			self.view:hideBottomHeroLight()

			self.view:showBottomHerolight()
		end 

	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showSolider()
	local fc = function () 
		
		if self.isChooseTopHero then 
			self.view:setAttack_SoldierData()
	 		self.view:showTopSolider()
		end 

		if self.isChooseBottomHero then 
			self.view:setDef_SoldierData()
			self.view:showBottomSolider()
		end 

	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:chooseSolider()
	local fc = function () 
		self.view:chooseSolider()
	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showSoliderlight()
	local fc = function () 

		self.view:setSoldierWorldPS()

		-- self.view:showSoliderlight()
	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showCapacity()
	local fc = function () 

		self.view:setCapacity()

		self.view:showCapacity()

	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showPKSolider() -- 不使用了////// 1.0
	local fc = function () 

		self.view:setCruntPkLeftSolderData()

		self.view:setCruntPkRightSolderData()
		
		self.view:showPKSoliderNoAction()

		self.view:showPKSoliderAction()
	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:showAttAckPKSolider()
	local fc = function () 

		self.view:setCruntPkLeftSolderData()
		self.view:setCruntPkRightSolderData()

		-- self.view:showPKSoliderNoAction()

		self.view:showAttackSoliderlight()

		self.view:showAttAckPKSolider()
	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showDefPKSolider()
	local fc = function () 

		self.view:showDefSoliderlight()

		self.view:showDefPKSolider()
	end 
	return self:createCallFunc(fc)
end



function callFuncFactory:showVS()
	local fc = function () 
		self.view:showVs()
	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:hideVS()
	local fc = function () 
		self.view:hideVsWithAction()
	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:showpk()
	local fc = function () 
		self.view:showpk()
	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:showRestrain()

	local fc = function () 
		self.view:showRestrain()
	end 
	return self:createCallFunc(fc)

end 

function callFuncFactory:showHurt()
	local fc = function () 
		self.view:showHurt()
	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:showRoundRsult()
	local fc = function () 
		self.view:showRoundRsult()

	end 
	return self:createCallFunc(fc)
end

function callFuncFactory:updateCapacity()
	local fc = function () 

		self.view:updatePKSolderCount()

		self.view:updateSoldierData()
		-- self.view:updateCapacity()
		self.view:updateCapacity2()

		self.view:updateHeroData()

	end 
	return self:createCallFunc(fc)
end
 

function callFuncFactory:hidePKSolider()
	local fc = function () 
		if self.view:havaNextRound() then 
			self.view:hidePKSolider()
			-- self.view:hideRoundResult()
		end 
	end 
	return self:createCallFunc(fc)
end 

function callFuncFactory:END()
	local fc = function () 

		if self.view:havaNextRound() then 
			self.view.Player:next()
			self.view:start()
		else
			 gevent:call(global.gameEvent.EV_ON_UI_FIGHTEND)
		end  
	end 
	return self:createCallFunc(fc)
end


function callFuncFactory:createCallFunc(function1)

	return cc.CallFunc:create(function1)
end


function callFuncFactory:getAction()

	self:setConfigData()

	local timetable = self:configTime()

	local s1 = cc.Sequence:create(

		self:hideTopSolider(),

		self:hideBottomSolider(),

		self:cleanTopSolider(),

		self:cleanBottomSolider(),

		self:cleanBottomSoliderLight(),

		self:cleanTopSoliderLight(),

		self:updateProgress(),
		cc.DelayTime:create(timetable.updateProgress),

		self:showTitle(),
		cc.DelayTime:create(timetable.showTitle),

	 	self:hideTitle(),
		cc.DelayTime:create(timetable.hideTitle),
	 	self:chooseHero(),
		cc.DelayTime:create(timetable.chooseHero),
	 	self:showHeroLight(),
		cc.DelayTime:create(timetable.showHeroLight),
		self:showSolider(),
		cc.DelayTime:create(timetable.showSolider),
		self:chooseSolider(),
		cc.DelayTime:create(timetable.chooseSolider),
		self:showSoliderlight(),
		cc.DelayTime:create(timetable.showSoliderlight),
		self:showCapacity(),
		cc.DelayTime:create(timetable.showCapacity),

		-- self:showPKSolider(),
		-- cc.DelayTime:create(timetable.showPKSolider),

		self:showAttAckPKSolider(),
		cc.DelayTime:create(timetable.showAttAckPKSolider),

		self:showDefPKSolider(),
		cc.DelayTime:create(timetable.showDefPKSolider),

		self:showVS(),
		cc.DelayTime:create(timetable.showVS),
		self:hideVS(),
		cc.DelayTime:create(timetable.hideVS),
		self:showpk(),
		cc.DelayTime:create(timetable.showpk),
		self:showRestrain() ,
		cc.DelayTime:create(timetable.showRestrain),
		self:showHurt(),
		cc.DelayTime:create(timetable.showHurt),
		self:showRoundRsult() , 
		cc.DelayTime:create(timetable.showRoundRsult),
		self:updateCapacity(),
		cc.DelayTime:create(timetable.updateCapacity),
		self:hidePKSolider(),
		cc.DelayTime:create(timetable.hidePKSolider),
		self:END())


	return s1  
end  


local speed =0.8

function callFuncFactory:configTime()

	local timetable = {}

	timetable.updateProgress= speed * 0.3

	timetable.showTitle= speed * 1.2

	timetable.hideTitle= speed * 0.4

	timetable.chooseHero= speed * 1 

	timetable.showHeroLight= speed * 1

	timetable.showSolider= speed * 1.5
	
	timetable.chooseSolider= speed * 0.5

	timetable.showSoliderlight= speed * 0.1

	timetable.showpk= speed * 0.65

	timetable.showRestrain= speed * 0.65

	timetable.updateCapacity= speed * 1.5

	timetable.showHurt= speed *  0.2

	timetable.showRoundRsult= speed *  1.5

	timetable.hideVS= speed *  0.5

	timetable.showVS= speed *  1

	-- timetable.showPKSolider= speed * 1

	timetable.showAttAckPKSolider= speed * 0.8

	timetable.showDefPKSolider= speed * 0.8

	timetable.showCapacity= speed *  0 

	timetable.showHerolight= speed * 1

	timetable.hidePKSolider= speed * 0.5



	if not self.isShowTitle  then 
		timetable.showTitle=   0
		timetable.hideTitle=   0
	end 


	--showSolider  士兵列表放大动画

 	if self.topSoldierCount > 5   or self.bottomSoldierCount > 5  then 

 		timetable.showSolider = 2

 	end 


	if not self.isChooseTopHero  and not self.isChooseBottomHero then

		timetable.updateProgress= 0 

		timetable.chooseHero =  0 

		timetable.showHeroLight= 0 

		timetable.showSolider=  0 
		
	end 



	return timetable
end

function callFuncFactory:setConfigData()

	self.isChooseTopHero = self.coreAnalyze:isNeedChooseTopHero()

	print(self.isChooseTopHero,"self.isChooseTopHero///////////////////")

	self.isChooseBottomHero =self.coreAnalyze:isNeedChooseBottomHero()

	self.isShowTitle = self.coreAnalyze:getTitleStatus() --如果不一样返回 true

	self.topSoldierCount = self.coreAnalyze:getTopSoldierCount()

	self.bottomSoldierCount = self.coreAnalyze:getBottomSoldierCount()



end


function callFuncFactory.getInstance()

	if not global.callFuncFactory then 
		global.callFuncFactory=callFuncFactory.new()
	end 

	return global.callFuncFactory
end 

return callFuncFactory

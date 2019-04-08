

local baseControl  =require("game.UI.replay.control.baseControl")

local mainControl = class("mainControl" ,function () return  baseControl.new() end)



local UITop = require("game.UI.replay.view.UITop")
local UICenter = require("game.UI.replay.view.UICenter")
local UIBottom = require("game.UI.replay.view.UIBottom")
local UIResult = require("game.UI.replay.view.UIResult")
local UISilder = require("game.UI.replay.view.UISilder")


local callFuncFactory = require("game.UI.replay.excute.callFuncFactory")
local skipCallFun = require("game.UI.replay.excute.skipCallFun")


local speed =  1
local speed2 = 0 

function mainControl:initWidget()

	local uitop = UITop.new()
self.view.top_ps:addChild(uitop)
	-- uitop:setPosition(self.view.top_ps:getPosition())

local uicenter = UICenter.new()
	-- self.view:addChild(uicenter)
	self.view.center_ps:addChild(uicenter)

	local uibottom = UIBottom.new()
	self.view.bottom_ps:addChild(uibottom)
	-- uibottom:setPosition(self.view.bottom_ps:getPosition())

	-- local uiresult = UIResult.new()
	-- self.view:addChild(uiresult)
	-- uiresult:setPosition(self.view.result_ps:getPosition())

	-- local uisilder = UISilder.new()
	-- self.view:addChild(uisilder)
	-- uisilder:setPosition(self.view.silder_ps:getPosition())


	print("why 46")


	self.view.uicenter = uicenter
	self.view.uibottom = uibottom
	self.view.uitop = uitop
	-- self.view.uisilder = uisilder
	-- self.view.uiresult = uiresult
	table.insert(self.WidgetTable, uicenter)
	-- table.insert(self.WidgetTable, uisilder)
	table.insert(self.WidgetTable, uitop)
	table.insert(self.WidgetTable, uibottom)
	-- table.insert(self.WidgetTable, uiresult)

end 

-- ׼???׶??ʾӢ?  ?ʾ???
function mainControl:prepare()

	self:initWidget()

	self:setBottomHeroData()
	self:setTopHeroData()

	self:hideResumeButton()

	self:preRoadAllRace()

	self:hideRoundResult()

	self:hidePKSoliderNoAction()

	self:hideComatNoAction()

	self:setCapacity2()

	local s1 = cc.Sequence:create(

		cc.DelayTime:create(speed),

		cc.CallFunc:create(function()



			self:showTop()

			self:showBottom()

			self:showComatWithAction()

		end ),

		cc.DelayTime:create(speed*0.5),

		cc.CallFunc:create(function()

			if self:CheckWarRound() then 

				gevent:call(global.gameEvent.EV_ON_UI_FIGHTEND)
				
			 else 

			 	gevent:call(global.gameEvent.EV_ON_UI_PREPAREED)
			 end 

		end))
 
	self.actionManger:createAction(self.view, s1, true)
end

function mainControl:CheckWarRound()
	local all_round = self.coreAnalyze:get_all_round()

	return all_round == 0 
end 


function mainControl:hideComatNoAction()

	self.view.uicenter:hideComatNoAction()
end 

function mainControl:start(test)
		

	local action = nil 

	if 	global.mainControl_skip then 


		local call = skipCallFun.getInstance()

		call:setData(self.coreAnalyze , self)

		action = skipCallFun.getInstance():getAction()

	else 

		local call = callFuncFactory.getInstance()

		call:setData(self.coreAnalyze , self)

		 action = callFuncFactory.getInstance():getAction()

	end 

	global.mainControl_skip  = false

	self.actionManger:createAction(self.view, action, true)
end


function mainControl:beskip()

	self.actionManger:cleanup()

	self:cleanSolider()

	self:hidePKSoliderNoAction()

	self:hideVsNoAction()

	self:cleanResult()

	self:hideRoundResult()

	self:hideTitleNoAction()

	self:hideShowSoliderLight()

	self:hideHurtNoAction()

	self:hideRestrain()

end 


function mainControl:skip()

	global.mainControl_skip = true 
	self:start()

end


function mainControl:showRightRestrain()

	self.view.uicenter:showRightRestrain()

end 


function mainControl:showLeftRestrain()

	self.view.uicenter:showLeftRestrain()

end 


function mainControl:showRestrain()

	if not self.coreAnalyze.isShowRestrain then return end
	local isshow , direction = self.coreAnalyze:isShowRestrain()

	print(isshow ,"isshow")
	print(direction ,"direction")

	if isshow then 
		if direction == 1 then 
			self:showLeftRestrain()
		else 
			self:showRightRestrain()
		end 
	end

end 

function mainControl:hideRestrain()

	self.view.uicenter:hideRestrain()

end 


function mainControl:hideHurtNoAction()
	self.view.uicenter:hideHurtNoAction()
end 

function mainControl:hideShowSoliderLight()

	self.view.uicenter:hideShowSoliderLight()

end 

function mainControl:setSoldierWorldPS()

	self:setTopSoldierWorldPS()

	self:setBottomSoldierWorldPS()
end


function mainControl:setTopSoldierWorldPS()

	local top_solider = self.coreAnalyze:getTopSoliderStation()


	print(top_solider,"top_solider///")

	self.view.uitop:setSelectSoldierStation(top_solider)
end 

function mainControl:setBottomSoldierWorldPS()
	
	local bot_solider = self.coreAnalyze:getBottomSoliderStation()

	print(bot_solider,"bot_solider///")

	self.view.uibottom:setSelectSoldierStation(bot_solider)
end 



function mainControl:showCapacity()

	self.view.uicenter:showCapacity()

end 

function mainControl:hideCapacity()
	
	self.view.uicenter:hideCapacity()

end 

function mainControl:showresult()

	local s1 = cc.Sequence:create(

		cc.CallFunc:create(function()

			self:showResult()
			table.insert(self.WidgetTable , self.view.victory_effect)
			table.insert(self.WidgetTable , self.view.faile_effect)
		end),

		cc.DelayTime:create(speed) ,

		cc.CallFunc:create(function()
			self.Player:finish()
		end))

	self.actionManger:createAction(self.view, s1, true)
end


function mainControl:showRoundRsult()

	local getName = function (id) 

		if id ==70 then  --???
			return global.luaCfg:get_soldier_property_by(3).name
	    elseif id ==71 then  --j???
			return  global.luaCfg:get_soldier_train_by(8071).name
	    elseif id ==72 then  --??
	    	return global.luaCfg:get_soldier_train_by(8072).name
	    end

        local info =  global.luaCfg:get_soldier_train_by(id)
        if not info then 
            info  =  global.luaCfg:get_wild_property_by(id)
        end 
       return info.name
	end 

	local right_solder = self.coreAnalyze:get_crunt_pk_right_solder()
	
	dump(right_solder,"right_solder data 257 ")

	local left_solder = self.coreAnalyze:get_crunt_pk_left_solder()

	dump(left_solder,"left_solder data 261 ")
	
	local str = global.luaCfg:get_local_string(10739) 

	local attack_name = "" 

	local def_name = ""

	local  def_hurt=  "" 

	local attack_hurt = ""

	if self.coreAnalyze:CheckisFanGong() then 
		attack_name = getName(right_solder.soldierId)
		def_name = getName(left_solder.soldierId)
		attack_hurt= self.coreAnalyze:getRightPKSoliderHurt()
		def_hurt = self.coreAnalyze:getLeftPKSoliderHurt()
	else 
		attack_name = getName(left_solder.soldierId)
		def_name = getName(right_solder.soldierId)
		def_hurt= self.coreAnalyze:getRightPKSoliderHurt()
		attack_hurt = self.coreAnalyze:getLeftPKSoliderHurt()
	end 

	str = string.format(str,attack_name, def_name, def_hurt , attack_hurt)
	self.view.uicenter:showResult({attack_name, def_name, def_hurt , attack_hurt})	
end

function mainControl:hideRoundResult()

	self.view.uicenter:hideRoundResult()	

end

function mainControl:showComatWithAction()

	self.view.uicenter:showComatWithAction()	
end 

function mainControl:cleanResult()

	if self.view.victory_effect  then 
		
		self.view.victory_effect:setVisible(false)
	end

	if self.view.faile_effect  then 
		self.view.faile_effect:setVisible(false)
	end  
end 

function mainControl:updateSoldierData()

	self:updateTopSoldierData()

	self:updateBottomSoldierData()

end 




function mainControl:removeRoadRace()
    if true then return end
    local raceId = global.userData:getRace()
    for _,id in pairs(self.raceIds) do
        if id ~= raceId then
            gdisplay.removeSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
        end
    end
end

function mainControl:preRoadAllRace()

	local data =  self.coreAnalyze:getAllSoldierID()

	dump(data  , "??ʿ??id")

    local raceIds = {}

    local checkRaceId = function (id)
        for _,v in pairs(raceIds) do
            if v == id then
                return true
            end
        end
        return false
    end

    for _,v in pairs(data) do

    	local temp = global.luaCfg:get_soldier_property_by(v)
    	if  temp then 
	   		local raceId =temp.race
	        if not checkRaceId(raceId) then
	            table.insert(raceIds, raceId)
	        end
    	end 
    end

    for _,id in ipairs(raceIds) do
        gdisplay.loadSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
    end

    self.raceIds = raceIds
end

function mainControl:updateTopSoldierData()

	local crunt_attack_solder = self.coreAnalyze:get_crunt_attack_solder()

	self.view.uitop:updateSoldierData(crunt_attack_solder)
end 

function mainControl:updateBottomSoldierData()

	local crunt_def_solder = self.coreAnalyze:get_crunt_def_solder()

	self.view.uibottom:updateSoldierData(crunt_def_solder)

end


function mainControl:setCapacity() -- ??ս????

	local left = self.coreAnalyze:get_old_cur_atk_capacity()
	local rigt = self.coreAnalyze:get_old_cur_df_capacity()

	self.view.uicenter:updateLeftCapacity(left , false)
	self.view.uicenter:updateRightCapacity(rigt , false )
end 


function mainControl:updateCapacity() -- ???ս????

	local left = self.coreAnalyze:get_cur_atk_capacity()
	local rigt = self.coreAnalyze:get_cur_df_capacity()

	self.view.uicenter:updateLeftCapacity(left, true )
	self.view.uicenter:updateRightCapacity(rigt, true)
end


function mainControl:setCapacity2() --  

	local left = {}
	local rigt = {}


	left.original = self.coreAnalyze:getOriginalAttackComat()
	left.last = self.coreAnalyze:getOriginalAttackComat()
	left.new = self.coreAnalyze:getOriginalAttackComat()

	rigt.original = self.coreAnalyze:getOriginalDefComat()
	rigt.last = self.coreAnalyze:getOriginalDefComat()
	rigt.new = self.coreAnalyze:getOriginalDefComat()

	self.view.uicenter:updateCapacity({left, rigt}, false )
end 


function mainControl:updateCapacity2() --

	local left = {}
	local rigt = {}


	left.original = self.coreAnalyze:getOriginalAttackComat()
	left.last = self.coreAnalyze:getLastAttackComat()
	left.new = self.coreAnalyze:getCruntAttackComat()

	rigt.original = self.coreAnalyze:getOriginalDefComat()
	rigt.last = self.coreAnalyze:getLastDefComat()
	rigt.new = self.coreAnalyze:getCruntDefComat()

	self.view.uicenter:updateCapacity({left, rigt}, true )
end



function mainControl:updateCapacityNoAction() --

	local left = {}
	local rigt = {}


	left.original = self.coreAnalyze:getOriginalAttackComat()
	left.last = self.coreAnalyze:getLastAttackComat()
	left.new = self.coreAnalyze:getLastAttackComat()

	rigt.original = self.coreAnalyze:getOriginalDefComat()
	rigt.last = self.coreAnalyze:getLastDefComat()
	rigt.new =  self.coreAnalyze:getLastDefComat()


	dump(left, "left")
	dump(rigt, "rigt")

	self.view.uicenter:updateCapacity({left, rigt}, false )
end



function mainControl:updatePKCount()

end 


function mainControl:updateCruntPkSolderData()

	self:updateCruntPkLeftSolderData()
	self:updateCruntPkRightSolderData()
end 

function mainControl:updateProgress()

	local pren = self.coreAnalyze:getFightProgress()
	self.view.uicenter:updateProgress(pren)
end 


function mainControl:hideHeroLight()
	self.view.uitop:hideHeroLight()		
	self.view.uibottom:hideHeroLight()		
end


function mainControl:hideTopHeroLight()
	self.view.uitop:hideHeroLight()		
end


function mainControl:hideBottomHeroLight()
	self.view.uibottom:hideHeroLight()		
end



function mainControl:showResult()
	local ressult = self.coreAnalyze:get_war_result()
	self.view:showResult(ressult)
end 

function mainControl:cleanSolider()
	self:cleanTopSolider()
	self:cleanBottomSolider()
end 

function mainControl:cleanTopSolider()
	self.view.uitop:cleanSolider()
end 


function mainControl:cleanBottomSolider()
	self.view.uibottom:cleanSolider()
end 



function mainControl:havaNextRound()
	local havaNextRound = self.coreAnalyze:havaNextRound()
	return  havaNextRound
end

function mainControl:showHurt()

	self:showRightPKSoliderHurt()
	self:showLeftPKSoliderHurt()
end

function mainControl:showRightPKSoliderHurt()

	local hurt = self.coreAnalyze:getRightPKSoliderHurt()

	self.view.uicenter:showRightPKSoliderHurt(hurt)
end 

function mainControl:showLeftPKSoliderHurt()

	local hurt = self.coreAnalyze:getLeftPKSoliderHurt()

	self.view.uicenter:showLeftPKSoliderHurt(hurt)

end 

function mainControl:showpk()
	local station = self.coreAnalyze:getAttackerStation()
	self.view.uicenter:showpk(station)
end

function mainControl:showVs()
	self.view.uicenter:showVs()
end 


function mainControl:hideVsNoAction()
	self.view.uicenter:hideVs()
end 


function mainControl:hideVsWithAction()
	self.view.uicenter:hideVsWithAction()
end 


function mainControl:showSoliderlight()

	self:showTopSoliderlight()

	self:showBottomSoliderlight()

end

function mainControl:hideSoliderlight()

	self:hideTopSoliderlight()

	self:hideBottomSoliderlight()
end

function mainControl:hideTopSoliderlight()
	self.view.uitop:hideSoliderlight()
end

function mainControl:hideBottomSoliderlight()
	self.view.uibottom:hideSoliderlight()
end


function mainControl:showAttackSoliderlight()
	if self.coreAnalyze:CheckisFanGong() then 

		self:showBottomSoliderlight()
	else

		self:showTopSoliderlight()
	end 
end 

function mainControl:showDefSoliderlight()
	if self.coreAnalyze:CheckisFanGong() then 
		
		self:showTopSoliderlight()
	else 
		self:showBottomSoliderlight()
	end 
end 

function mainControl:showTopSoliderlight()

	local station = self.coreAnalyze:getTopSoliderStation()

	self.view.uitop:showSoldierlight(station)
end 

function mainControl:showBottomSoliderlight()

	local station = self.coreAnalyze:getBottomSoliderStation()

	self.view.uibottom:showSoldierlight(station)
end 


function mainControl:showHerolight()
	self:showTopHerolight()
	self:showBottomHerolight()
end 

function mainControl:showTopHerolight()

	local topHeroIndex = self.coreAnalyze:getTopHeroStation()

	self.view.uitop:showHerolight(topHeroIndex)
end 

function mainControl:showBottomHerolight()

	local bottomHeroIndex = self.coreAnalyze:getBottomHeroStation()

	self.view.uibottom:showHerolight(bottomHeroIndex)
end 

function mainControl:chooseHero()

	self:chooseBottomHero()
	self:chooseTopHero()
end 

function mainControl:chooseSolider()
	self:chooseBottomSolider()
	self:chooseTopSolider()
end 

function mainControl:showAttAckPKSolider()

	if  self.coreAnalyze:CheckisFanGong() then 

		self.view.uicenter:showRightPkSoliderNoAction()

		self.view.uicenter:setLeftPKSoliderVisible(false)

		self:showRightPKSoliderAction()

	else 
		self.view.uicenter:showLeftPkSoliderNoAction()

		self:showLeftPKSoliderAction()	

		self.view.uicenter:setRightPKSoliderVisible(false)

	end
end

function mainControl:showDefPKSolider()

	self.view.uicenter:setRightPKSoliderVisible(true)
	self.view.uicenter:setLeftPKSoliderVisible(true)

	if  self.coreAnalyze:CheckisFanGong() then 

		self.view.uicenter:showLeftPkSoliderNoAction()

		self:showLeftPKSoliderAction()	
	else 
		
		self.view.uicenter:showRightPkSoliderNoAction()
		self:showRightPKSoliderAction()
	end 
end

function mainControl:chooseTopHero()


	local topHeroIndex = self.coreAnalyze:getTopHeroStation()

	print(topHeroIndex,"topHeroIndex///////")

	self.view.uitop:chooseHero2(topHeroIndex)

end 

function mainControl:chooseBottomHero()



	local HeroIndex = self.coreAnalyze:getBottomHeroStation()

	self.view.uibottom:chooseHero2(HeroIndex)
end 

function mainControl:chooseTopSolider()

	local top_solider = self.coreAnalyze:getTopSoliderStation()

	self.view.uitop:chooseSolider2(top_solider)

end 

function mainControl:chooseBottomSolider()

	local bot_solider = self.coreAnalyze:getBottomSoliderStation()

	self.view.uibottom:chooseSolider2(bot_solider)
end 


function mainControl:setRoundData()

	local round_data = self.coreAnalyze:get_crunt_round()

	self.view.uicenter:setRoundData(round_data)

end 


function mainControl:showRound()
	self.view.uicenter:showRound()
end 

function mainControl:hideRound()
	self.view.uicenter:hideRound()
end 


function mainControl:showTitle()

	self.view.uicenter:showTitle()
end 

 
function mainControl:hideTitleNoAction()

	self.view.uicenter:hideTitleNoAction()
end 

function mainControl:hideTitleWithAction()
    
	self.view.uicenter:hideTitleWithAction()
end 


function mainControl:hideSolider()

	self:hideTopSolider()
	self:hideBottomSolider()

end


function mainControl:showSolider()

	self:showTopSolider()

	self:showBottomSolider()

end

function mainControl:hideTopSolider()
	self.view.uitop:hideSoldier()

end 

function mainControl:hideBottomSolider()
	self.view.uibottom:hideSoldier()
	
end 

function mainControl:showTopSolider()

	self.view.uitop:showSoldier()
end 


function mainControl:showBottomSolider()

	self.view.uibottom:showSoldier()
end 

function mainControl:hidePKSolider()

	self.view.uicenter:hidePKSolider()
end 

function mainControl:hideLeftPKSolider()
	self.view.uicenter:hideLefPKSolider()

end 

function mainControl:hideRightPKSolider()
	self.view.uicenter:hideRightPKSolider()

end 

function mainControl:showPKSoliderNoAction() --?????ζ??? ֱ???? ʿ??

	self.view.uicenter:showPKSoliderNoAction()

end


function mainControl:showLeftPkSoliderNoAction() -- 

	self.view.uicenter:showLeftPkSoliderNoAction()

end

function mainControl:showRightPkSoliderNoAction() --  

	self.view.uicenter:showRightPkSoliderNoAction()

end


function mainControl:hidePKSoliderNoAction() --?????ζ??? ֱ???? ʿ??

	self.view.uicenter:hidePKSoliderNoAction()

end

function mainControl:showPKSoliderAction()

	self:showLeftPKSoliderAction()

	self:showRightPKSoliderAction()
end


function mainControl:showLeftPKSoliderAction()

	local startps= self.view.uitop:getSelectSoldierStation()  
	local endps= self.view.uicenter:getLeftPKPS()  
	
	self.view.uicenter:showLeftPKSolider(startps , endps)
end 

function mainControl:showRightPKSoliderAction()

	local startps= self.view.uibottom:getSelectSoldierStation()  

	local endps= self.view.uicenter:getRightPKPS() 

	self.view.uicenter:showRightPKSolider(startps , endps)
end 

function mainControl:setCruntPkLeftSolderData()

	local pk_data = self.coreAnalyze:get_old_crunt_pk_left_solder()

	self.view.uicenter:setLeftSoldierData(pk_data ,1 )
end 

function mainControl:setCruntPkRightSolderData()

	local pk_data = self.coreAnalyze:get_old_crunt_pk_right_solder()

	self.view.uicenter:setRightSoldierData(pk_data ,  2 )
end



function mainControl:updateCruntPkLeftSolderData()

	local pk_data = self.coreAnalyze:get_crunt_pk_left_solder()

	self.view.uicenter:setLeftSoldierData(pk_data ,1 , true)
end 


function mainControl:updateCruntPkRightSolderData()

	local pk_data = self.coreAnalyze:get_crunt_pk_right_solder()

	self.view.uicenter:setRightSoldierData(pk_data ,  2 , true)
end 

function mainControl:updatePKSolderCount()

	self:updateCruntPkRightSolderCount()

	self:updateCruntPkLeftSolderCount()
end 


function mainControl:updateCruntPkRightSolderCount()
	local pk_data = self.coreAnalyze:get_crunt_pk_right_solder()
	self.view.uicenter:updateRightCount(pk_data.lcount,true)
end 

function mainControl:updateCruntPkLeftSolderCount()

	local pk_data = self.coreAnalyze:get_crunt_pk_left_solder()
	self.view.uicenter:updateLeftCount(pk_data.lcount,true)
end 



function mainControl:setAttack_SoldierData()

	local attack_data = self.coreAnalyze:get_old_crunt_attack_solder()
	self.view.uitop:setSoldierData(attack_data)
end


function mainControl:setDef_SoldierData()

	local def_data = self.coreAnalyze:get_old_crunt_def_solder()
	self.view.uibottom:setSoldierData(def_data)

end 


function mainControl:setTitleData()

	local titledata = self.coreAnalyze:getTitle()
	self.view.uicenter:setTitleData(titledata)

end 


function mainControl:setComat()

end

function mainControl:updateComat()
	
end 


function mainControl:setTopHeroData()
	local attack_herodata = self.coreAnalyze:get_last_attack_Hero()
	
	self.view.uitop:setHeroData(attack_herodata)
end

function mainControl:setBottomHeroData()

	local df_herodata = self.coreAnalyze:get_last_def_hero() 
	self.view.uibottom:setHeroData(df_herodata)

end


function mainControl:setSkipHeroData() -- 

	local attack_herodata = self.coreAnalyze:get_last_attack_Hero()
	self.view.uitop:updateHero(attack_herodata)

	local df_herodata = self.coreAnalyze:get_last_def_hero() 
	self.view.uibottom:updateHero(df_herodata)

end



function mainControl:updateHeroData()

	local attack_herodata = self.coreAnalyze:get_attack_hero()

	self.view.uitop:updateHero(attack_herodata)

	local df_herodata = self.coreAnalyze:get_df_hero()

	self.view.uibottom:updateHero(df_herodata)
end 


function mainControl:showAll()
	self:showTop()
	self:showCenter()
	self:showBottom()
end 

function mainControl:hideAll()
	self:hideTop()
	self:hideCenter()
	self:hideBottom()
end 


function mainControl:showTop()
	self.view.uitop:showSelf()
end 

function mainControl:showCenter()
	self.view.uicenter:showSelf()
end 

function mainControl:showBottom()
	self.view.uibottom:showSelf()
end 


function mainControl:hideTop()
	self.view.uitop:hideSelf()
end 


function mainControl:hideCenter()
	self.view.uicenter:hideSelf()
end 


function mainControl:hideBottom()
	self.view.uibottom:hideSelf()
end 


function mainControl:pause()

	print(global.dataMgr:getServerTime())

	self.actionManger:pause()

	self:showResumeButton()
end 


function mainControl:showResumeButton()
	self.view.uicenter:showResumeButton()
end


function mainControl:hideResumeButton()
	self.view.uicenter:hideResumeButton()
end


function mainControl:cleanwidget()

	self.actionManger:cleanup()

	baseControl.cleanwidget(self)

	self:removeRoadRace()
end

function mainControl:resume()
	self:hideResumeButton()
	self.actionManger:resume()
end 

return mainControl

--endregion

--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local actionManger = class("actionManger")

local coreAnalyze  =require("game.UI.replay.excute.coreAnalyze")


function actionManger:ctor()

	self.timeLineTable={}
	self.actionNodeTable={}
	self.index = 1 
end 

 

function actionManger.getInstance()

	if not global.actionManger then 
		global.actionManger=actionManger.new()
	end 

	return global.actionManger
end



function actionManger:getUniqueId()

	self.index = self.index + 1 

	return self.index 
end 


function actionManger:createAction(node , action ,  run)

	local key  = self:getUniqueId()

	local action = cc.Sequence:create(action , cc.CallFunc:create(function ()

			self.actionNodeTable[key]  = nil 
			
	 end))

	if run then 
		node:runAction(action)
	end 

	self.actionNodeTable[key] = node

	return action 
end


function actionManger:pause()

	print(#self.actionNodeTable)

	for _ ,v in pairs(self.actionNodeTable) do 
		v:pause()
	end


	for _ ,v in pairs(self.timeLineTable) do 
		v:pause()
	end

end


function actionManger:resume()

	for _ ,v in pairs(self.actionNodeTable) do 
		v:resume()
	end 

	for _ ,v in pairs(self.timeLineTable) do 
		v:resume()
	end 
end 


function actionManger:cleanup()

	for _ ,v in pairs(self.timeLineTable) do 
		if v and not tolua.isnull(v) then 
			v:pause()
		end 
	end
	
	for _ ,v in pairs(self.actionNodeTable) do 
		v:stopAllActions()
	end


	self.timeLineTable={}
	self.actionNodeTable={}
	self.index = 1 

end 


local timeLineConfig ={

	soldier = {"player/node/player_soldier" , "animation0" , "Player_SoldiersList"} , 
	soldier1={ "player/node/player_soldier" , "animation1",  "Player_Soldiers"} , 
	title ={"player/node/title" , "animation0" ,"Player_Start"} , 
	hideTitle= {"player/node/title" , "animation1"} , 
	top = { "player/node/top" , "animation0", "Player_Initial"} , 
	bottom ={ "player/node/bottom" , "animation0"} , 
	bottomHero={ "player/node/player_bottom_hero" , "animation0" , "Player_Troops"} , 
	bottomHero1= { "player/node/player_bottom_hero" , "animation1"} ,  
	topHero ={ "player/node/player_top_hero" , "animation0" , "Player_Troops" }, 
	topHero1 ={ "player/node/player_top_hero" , "animation1"} , 
	showVsAction = { "player/node/vs" , "animation0","Player_VS"} , 
	hideVsAction ={"player/node/vs" , "animation1"} , 
	hideVs ={ "player/node/vs" , "animation2"} , 
	centerpk ={ "player/node/center" , "animation0" ,"Player_SoldiersPK"}, 
	centerpk1 ={"player/node/center" , "animation1" ,"Player_SoldiersPK"} , 
	main ={ "player/player_bj" , "animation0" }, 
	pKSoldier ={ "player/node/player_pk1" , "animation0"} , 
	UIfail ={ "player/node/win_or_fail2" , "animation0" ,"Player_Over" } , 
	UIwin ={"player/node/win_or_fail1" , "animation0"} , 
	soldier2 ={ "player/node/player_soldier" , "animation2"} , 
	soldier3 ={"player/node/player_soldier" , "animation3"} , 
	hidePkAction ={ "player/node/center" , "animation2"} , 
	showPkNOAction ={ "player/node/center" , "animation4"} , 
	hidePkNOAction ={"player/node/center" , "animation3"} , 
	showLeftPkSoliderNoAction ={ "player/node/center" , "animation6"} , 
	showRightPkSoliderNoAction ={ "player/node/center" , "animation5"} , 
	hideTitleNoAction ={"player/node/title" , "animation2"} , 
	showTopChooseSoliderEffect ={ "effect/light_zdhf" , "animation1" , "Player_SoldiersGo"} , 
	showBottomChooseSoliderEffect ={ "effect/light_zdhf" , "animation0" ,"Player_SoldiersGo"} , 
	scrollResultAction={ "player/node/result" , "animation0"} , 
	hideChooseSoliderEffect ={ "effect/light_zdhf" , "animation2"} , 
	showComatWithAction= { "player/node/comat" , "animation0"} , 
	hideHurtNoAction ={ "player/node/player_pk1" , "animation2"} ,
	hidesoldier ={ "player/node/player_soldier" , "animation3"} , 
	hideComatNoAction= { "player/node/comat" , "animation1"} , 
	showRightRestrain= { "player/node/player_Gicon" , "animation1"} , 
	showLeftRestrain= { "player/node/player_Gicon" , "animation2"} , 
	hideRestrain = { "player/node/player_Gicon" , "animation3"} , 
}


function actionManger:createTimeline(root ,name ,isOne ,isPlayer ,call)

	local nodeTimeLine = nil

	local animation = ""

	local timeLineData =  timeLineConfig[name]

	if not timeLineData then return end 

	nodeTimeLine =global.resMgr:createTimeline(timeLineData[1])

	animation = timeLineData[2]

	if not nodeTimeLine then 
		print("nodeTimeLine////////////nil")		
		return 
	end 

	local key  = tostring( self:getUniqueId())

	self.timeLineTable[key]  = nodeTimeLine

	root:runAction(nodeTimeLine)

	self.timeLineTable[key].name = name 

	if isPlayer  then 
		nodeTimeLine:play(animation,not isOne)
	end 

	if  timeLineData[3] then 
		gevent:call(gsound.EV_ON_PLAYSOUND, timeLineData[3])
	end 

	nodeTimeLine:setLastFrameCallFunc(function()
		if call then 
			call()
		end 
		if name == "topHero" then 
		end 
		self.timeLineTable[key] = nil

	end)
	return  nodeTimeLine
end 


return actionManger

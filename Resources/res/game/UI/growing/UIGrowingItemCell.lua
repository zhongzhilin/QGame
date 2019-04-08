local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIGrowingItemCell  = class("UIGrowingItemCell", function() return cc.TableViewCell:create() end )
local UILeisureItem = require("game.UI.growing.UIGrowingItem")

function UIGrowingItemCell:ctor()
    self:CreateUI()
end

function UIGrowingItemCell:CreateUI()

    self.item = UILeisureItem.new() 
    self:addChild(self.item)
end


local delayTime = 0.5

local notcheckBuildID = {
	0 ,
	1 ,
} 


function UIGrowingItemCell:onClick()

    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

	local  recruitHero = global.heroData:getGotHeroData()

	global.panelMgr:closeTopPanel()

	local t = self.data.targrt

	if not table.hasval(notcheckBuildID,self.data.targetBuild) and not global.funcGame:checkBuildAndBuildLV(self.data.targetBuild)  then 

		return  
	end 

	local canOpen = function () 

		local curStep = global.guideMgr:getCurStep() or 0

		print(global.guideMgr:isPlaying() ,"global.guideMgr:isPlaying() ")
		
		print(curStep ,"curStep->>>>>>")

		return	not global.guideMgr:isPlaying() or  (curStep ~= 40004)
	end 


	if t == "UIHeroPanel1" then 

		  local panel =  global.panelMgr:openPanel("UIHeroPanel"):setMode4()

	elseif  t =="UIHeroPanel3" then --检测经验是否满了

		local panel =  global.panelMgr:openPanel("UIHeroPanel")
		for _ ,v in pairs(recruitHero) do 
			if v.serverData and  v.serverData.lGrade < global.heroData:getHeroTrueMaxLevel() then 
				panel.chooseHeroData = v 
				break
			end 
		end 

		panel:setMode1()
		global.delayCallFunc(function()

			local v = panel.chooseHeroData
			if v and  v.serverData and  v.serverData.lGrade < global.heroData:getHeroTrueMaxLevel() and canOpen() then 
				panel.expNode:addEnergy_click()
			end 
		end , nil , delayTime)

	elseif  t =="UIHeroPanel2" then --检测是否满街

		local panel =  global.panelMgr:openPanel("UIHeroPanel")
		for _ ,v in pairs(recruitHero) do 
			if v.serverData and v.serverData.lStar < luaCfg:get_hero_strengthen_by(v.heroId).maxStep  then 
				panel.chooseHeroData = v 
				break
			end 
		end 
		panel:setMode1()
		global.delayCallFunc(function()

			local v = panel.chooseHeroData
			if   v and  v.serverData and v.serverData.lStar < luaCfg:get_hero_strengthen_by(v.heroId).maxStep  and canOpen() then 
				panel.FileNode_1:onHelp()
			end 
		end , nil , delayTime)

	elseif  t =="TrainPanel" then 

		global.funcGame.gpsBuildAndTrain(2)

	elseif  t =="UpgradePanel" then 

		global.funcGame.gpsCityBuildingAndPopUpgradePanel(1,true)
	
	elseif  t =="UIPetPanel" then  --判断是否激活神兽
		if global.petData:getPetActNum() > 0 then 
			global.panelMgr:openPanel(t)
		else 
			global.tipsMgr:showWarning("petNotAlive")
		end  
	else
		global.panelMgr:openPanel(t)
	end 

end

function UIGrowingItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIGrowingItemCell:updateUI()
    self.item:setData(self.data)
end

return UIGrowingItemCell
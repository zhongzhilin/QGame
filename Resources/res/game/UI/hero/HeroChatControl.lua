
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local HeroChatControl = class("HeroChatControl")
local UITalkTextControl = require("game.UI.common.UITalkTextControl")

function HeroChatControl:ctor()

end


local state= {"begin" , "taking" ,"end" , "stop" } 

function HeroChatControl:setData(p1 , p2  , heroid , randomCount)

	-- if not  hero or  hero.id == 1 then    global.showWarning("HeroChatControl  36 ") return end  

	self.person= {

		[1] = p1  , 
		[2] = p2 
	} 

	self.chatData={

		[1] ={} ,
		[2] ={}
	}


	self.lastChatDataIndex ={
		[1] = nil  , 
		[2] =  nil 
	}

	for _ ,v in  ipairs( luaCfg:chat_dialogue()) do 
			
		if v.hero_id == 1 then 

			table.insert(self.chatData[1] ,v )

		elseif v.hero_id == heroid then 

			table.insert(self.chatData[2] ,v )
		end

	end

	self._talk_round  = 0
	self.randomCount = randomCount --总回合书

	self:setCruntPerson(self.person[1])

	self:stop()

	for _ ,v in pairs(self.person) do 
		v.old_ps= {}  
		v.old_ps.x = v:getPositionX()
		v.old_ps.y = v:getPositionY()
	end 

	self.test = 1 

end

local Text_width = 154


function HeroChatControl:setMaxTalkRound(max)
	self.randomCount = max 
end 


function HeroChatControl:setEndCall(call)

	self.endCall = call 
end 


function HeroChatControl:reset()

	self._talk_round  = 0 

	self:setCruntPerson(self.person[1])

end 


function HeroChatControl:excute()

	if self._talk_round > self.randomCount then 

		if self.endCall  then 

			self.endCall()

		end 
		self:finish()
		return 
	end 

	local time = 6

	local crunt_person = self:getCrutPerson() 

	crunt_person:getParent():getParent():setVisible(true)
	crunt_person:getParent():getParent():runAction(cc.FadeIn:create(0.1))


	local next_person = self:getNextPerson()

	local chaStr = self:getChatStr()

	local len = string.utf8len(chaStr)
	crunt_person:setPositionY(crunt_person.old_ps.y)

	self:setCruntPerson(next_person)

	self._talk_round = self._talk_round or 0 

	self._talk_round  = self._talk_round + 1 

	if not crunt_person then global.tipsMgr:showWarning("fuck /////////")   return end 

	self.test =	self.test + 1

	local temp = self.test 

	UITalkTextControl.startScroll(crunt_person ,chaStr , nil , function()
		self.timer = gscheduler.performWithDelayGlobal(function()

				if temp ~=  self.test then return end  -- 确保多次说话不会

				crunt_person:getParent():getParent():runAction(cc.FadeOut:create(0.4))
				if self.excute then 
					self:excute()
				end 
		end, 0.3)
	end , time)

end 


function HeroChatControl:getChatStr()

	for key , v in pairs(self.person)  do 
		if v == self:getCrutPerson() then 
			random = math.random(1,#self.chatData[key])
			return self.chatData[key][random].dialogue or "" 
		end 
	end 

	return ""
end

function HeroChatControl:setState(state)

	self._state = state

	self[self._state](self)

end

function HeroChatControl:begin()

	self:stop()
	self:excute()
end


function HeroChatControl:setCruntPerson(person)

	self._crunt_p =  person 
end

function HeroChatControl:getCrutPerson()

	return self._crunt_p 
end 

function HeroChatControl:getNextPerson()

	for _  , v in pairs(self.person)  do 

		if self:getCrutPerson() ~= v then 

			return v 
		end 
	end 
end 

function HeroChatControl:finish()
	if self.timer then
		gscheduler.unscheduleGlobal(self.timer)
		self.timer = nil
	end
end


function HeroChatControl:stop()

	 self:finish()

	self.person[1]:setString("")
	self.person[2]:setString("")


	self.person[1]:getParent():getParent():setVisible(false)
	self.person[2]:getParent():getParent():setVisible(false)
	

	self.person[1]:getParent():getParent():stopAllActions()
	self.person[2]:getParent():getParent():stopAllActions()

	for _ ,v in pairs(self.person) do 
		if v.old_ps then 
			v:setPositionY(v.old_ps.y)
		end 
		v:stopAllActions()
	end 

end


return HeroChatControl
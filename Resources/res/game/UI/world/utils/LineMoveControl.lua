--region LineMoveControl.lua
--Author : untory
--Date   : 2016/09/16

local LineMoveControl = class("LineMoveControl",function() return gdisplay.newWidget() end)

function LineMoveControl:ctor()
		
	self.g_worldview = global.g_worldview
end

local color_type = {
	
	[0] = {r = 1,g = 243 / 255,b = 45 / 255, a = 1},
	[1] = {r = 4 / 255,g = 194 / 255,b = 255 / 255, a = 1},
	[2] = {r = 20 / 255,g = 198 / 255,b = 10 / 255, a = 1},
	[3] = {r = 20 / 255,g = 198 / 255,b = 10 / 255, a = 1},
	[4] = {r = 243 / 255,g = 45 / 255,b = 45 / 255, a = 1},	
}

setmetatable(color_type, {__index = function(t,k)
	
	return {r = 1,g = 243 / 255,b = 45 / 255, a = 1}
end})

function LineMoveControl:drawLine(line,isAttack)

	line = clone(line)

	local draw = cc.DrawNode:create()
	draw:setAnchorPoint(cc.p(0,0))	
	self:addChild(draw)

	draw:setLineWidth(5)

	local polylinePoints = line
	if not isAttack then polylinePoints = table.reverse(line) end

	local firstPoint = polylinePoints[1]
	for i,v in ipairs(polylinePoints) do
		polylinePoints[i] = cc.pSub(polylinePoints[i],firstPoint)
	end
	draw:setPosition(firstPoint)

	local prePoint = polylinePoints[1]
	local LINE_LEN = 20
	
	local preCutLine = 0
	for i,pv in ipairs(polylinePoints) do
                  
		local tempP = cc.pSub(prePoint,pv)
		local len = cc.pGetLength(tempP)
		local allLine = len / LINE_LEN

		local floorAllLine = math.floor(allLine) 

		for i = 0,floorAllLine do

			local endPos
			local endPos2
			
			-- print("i",i,"allLen",allLine)

			if i == floorAllLine then
				endPos = cc.pMul(tempP,(i / allLine))				
				if i / allLine + 6 / len > 1 then
					endPos2 = cc.pMul(tempP,1)
				else				
					endPos2 = cc.pMul(tempP,i / allLine + (6 / len))
				end 
			else
				endPos = cc.pMul(tempP,i / allLine)
				endPos2 = cc.pMul(tempP,i / allLine + (6 / len))
			end                    

			-- draw:drawDot(cc.pSub(prePoint,endPos),2,color_type[self.soldiers_type])
			-- draw:drawLine(cc.pSub(prePoint,endPos), cc.pSub(prePoint,endPos2),color_type[self.soldiers_type])
			draw:drawSegment(cc.pSub(prePoint,endPos), cc.pSub(prePoint,endPos2), 2, color_type[self.soldiers_type]) 
		end

		preCutLine = allLine - floorAllLine
		prePoint = pv
	end
	
end

function LineMoveControl:onExit()
	
	if self.scheduleListenerId ~= nil then
        -- self.node:removeFromParent()
		gscheduler.unscheduleGlobal(self.scheduleListenerId)
	end
end

-- 直线线路
function LineMoveControl:addStraightLine(lineData,isAttack)

	local polylinePoints = clone(lineData)

	local firstPoint = polylinePoints[1]
	local endPoint = polylinePoints[#polylinePoints]

	local ang = cc.pToAngleSelf(cc.pSub(firstPoint,endPoint)) / math.pi * -180
	local len = cc.pGetDistance(firstPoint,endPoint)

	-- shader 线路
	local line = cc.Sprite:create()
	line:setAnchorPoint(cc.p(1,0.5))
	self:addChild(line)
	CCHgame:setLineShader(line)
	global.panelMgr:setTextureFor(line,'shader/line' .. self.soldiers_type .. '.png')
	line:getTexture():setTexParameters(9729, 9729, 10497, 10497)
	line:setPosition(firstPoint)
 	line:setRotation(ang)
	line:setContentSize(cc.size(len,64))
	line:getGLProgramState():setUniformFloat('u_len', len)
	line:setColor(cc.c3b(255,255,0))

end

-- 曲线线路
function LineMoveControl:addCurveLine(lineData,isAttack)

    local polylinePoints = lineData
    local prePoint = polylinePoints[1]    
    for i,pv in ipairs(polylinePoints) do            

		local ang = cc.pToAngleSelf(cc.pSub(prePoint,pv)) / math.pi * -180
		local len = cc.pGetDistance(prePoint,pv)
	
		-- shader 线路
		local line = cc.Sprite:create()
		line:setAnchorPoint(cc.p(1,0.5))
		self:addChild(line)
		CCHgame:setLineShader(line)

		global.panelMgr:setTextureFor(line,'shader/line' .. self.soldiers_type .. '.png')
		line:getTexture():setTexParameters(9729, 9729, 10497, 10497)
		line:setPosition(prePoint)
	 	line:setRotation(ang)
		line:setContentSize(cc.size(len,64))
		line:getGLProgramState():setUniformFloat('u_len', len)
		line:setColor(cc.c3b(255,255,0))

	  	prePoint = pv
	  	
    end

end

function LineMoveControl:startMove(node,line,endTime,allLen,goLen,isNeedCare,isAttack,soldiers_type,isWild)

	self.endTime = endTime
	self.allLen = allLen
	self.node = node
	self.line = line
	self.speed = speed
	self.soldiers_type = soldiers_type or 1


	if isWild then
		--if global.isStraightLineShader then
			self:addCurveLine(line,isAttack)
		-- else
		-- 	self:drawLine(line,isAttack)
		-- end
	end	

	if not isNeedCare then
		
		self:setVisible(false)
	end

	self.node:setPosition(line[1])
	self.stepIndex = 1
	self.posDt = self:getPosDt(self.line[1], self.line[2])

	-- goLen = 200

	self:startGoLen(goLen)

	self.scheduleListenerId = gscheduler.scheduleGlobal(function(dt)

		-- if dt > 1 then print("这个延时是有效的") end

		local contentTime = global.dataMgr:getServerTime()
		local lessTime = self.endTime - contentTime

		if lessTime < 0 then lessTime = 0 end

		-- print("----------------------------------")

		-- print("allLen",self.allLen)
		-- print("lessTime",lessTime)

		self.speed = self.allLen / lessTime / (1 / dt)

		-- print("speed",self.speed)

        self:updateMove(self.speed)

        self.node:afterMove()
    end, 0)

    return self
end

function LineMoveControl:startGoLen(goLen)
	
	local lessLen = goLen
	local pointCount = #self.line
	local resIndex = 1
	for i = 1,pointCount - 1 do

		local p1 = self.line[i]
		local p2 = self.line[i + 1]
		local dis = cc.pGetDistance(p1,p2)

		if lessLen < dis then

			self.node:setPosition(p1)
			self.stepIndex = i
			break
		else

			lessLen =  lessLen - dis
			self.allLen = self.allLen - dis
		end
	end
end

function LineMoveControl:updateMove(stepLen)

	local nextStepPos = self.line[self.stepIndex]
	local curPos = cc.p(self.node:getPositionX(),self.node:getPositionY())

	local len = cc.pGetDistance(nextStepPos,curPos)
	local nextPos = {}

	local tempPosDt = cc.p(self.posDt.x * stepLen,self.posDt.y * stepLen)

	local tempNextPos = cc.pAdd(curPos,tempPosDt)	
	local tempLen = cc.pGetDistance(nextStepPos,tempNextPos) 

	if tempLen > len and stepLen > 0 then
		nextPos = nextStepPos
		stepLen = stepLen - len
		self.stepIndex = self.stepIndex +  1
		
		if self.stepIndex > #self.line then

           	-- self.node:removeFromParent()
			gscheduler.unscheduleGlobal(self.scheduleListenerId)
			self.scheduleListenerId = nil

			-- self:removeFromParent()

			return
		else

			-- log.debug(self.stepIndex .. " " .. #self.line .. " " .. stepLen)
			self.posDt = self:getPosDt(nextStepPos, self.line[self.stepIndex])
			self:updateMove(stepLen)

			return
		end
	else

		-- print(stepLen)
		-- self.allLen = self.allLen - stepLen

		nextPos = tempNextPos--cc.pAdd(curPos,self.posDt)
	end

	self.allLen = self.allLen - cc.pGetDistance(cc.p(self.node:getPosition()),nextPos)
	self.node:setPosition(nextPos)
end

function LineMoveControl:getPosDt(curPos,taskPos)

	local ang = cc.pToAngleSelf(cc.pSub(taskPos,curPos))
	local res = cc.pMul(cc.pForAngle(ang),1)

	ang = ang / 3.14 * 180

	self.node:checkSide(ang,self.speed)

	return res
end

return LineMoveControl
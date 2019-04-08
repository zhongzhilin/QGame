local global = global
local luaCfg = global.luaCfg

local _M = {
}

function _M:init(data)
    self.m_openGuideRect = false

    self.lCurrStep = cc.UserDefault:getInstance():getIntegerForKey(WDEFINE.USERDEFAULT.GUIDE_STEP)
    self.lCurrStep = self.lCurrStep or 1
    self.lCurrStep = self.lCurrStep > 0 and self.lCurrStep or 1
    self.guideConf = luaCfg:guide()
    self.targetList = {}

    log.trace("###guidedata init(): self.lCurrStep=%s",self.lCurrStep)
    if self:isJumpTask(self.lCurrStep) then
        self.lCurrStep = self:getNextTaskStep()
    else
        self.lCurrStep = self:getBackStep()
    end
end

function _M:setStep(step)
    self.lCurrStep = step or 1
end

function _M:getStep()
    return self.lCurrStep
end

function _M:getNextStep()
    return self.lCurrStep+1
end

function _M:getBackStep()
    return self.lCurrStep-self:getCurrConf().tempStep+1
end

function _M:getNextTaskStep()
    local currConf = self:getCurrConf()
    local nextConf = self:getNextConf()
    if not nextConf then
        --找不到下一步，强制任务结束
        return self.lCurrStep+1
    end
    if currConf.stepId == nextConf.stepId then
        self.lCurrStep = self.lCurrStep+1
        return self:getNextTaskStep()
    else
        return self:getNextStep()
    end
end

function _M:getCurrConf()
    return self.guideConf[self.lCurrStep]
end

function _M:getNextConf()
    return self.guideConf[self:getNextStep()]
end

--根据关键步骤的前后选择是否跳过任务
function _M:isJumpTask(step)
    local temp = step or self:getStep()
    local cruxStep = self:getCruxStep(self.guideConf[temp].stepId)
    if not cruxStep then
        return false
    end
    log.trace("@GuideData:isJumpTask step:%s,self.guideConf:%s",temp,vardump(self.guideConf))
    return temp > cruxStep
end

--获取关键步
function _M:getCruxStep(stepId)
    for _step,v in ipairs(self.guideConf) do
        if stepId == v.stepId and v.cruxStep == 1 then
            return _step
        end
    end
end

function _M:isCruxStep(step)
    local step = step or self.lCurrStep
    return self.guideConf[step].cruxStep == 1
end

function _M:resetTargetList()
    self.targetList = {}
end

function _M:addTargetList(part,name,node)
    self.targetList = self.targetList or {}
	self.targetList[part] = self.targetList[part] or {}
	self.targetList[part][name] = node
end

function _M:getTarget(part,name)
    if not part or not name then
        log.error("####guideData:getTarget can not get! part=%s,name=%s",part,name)
        return nil
    end
    if not self.targetList[part] then
        log.error("####guideData:getTarget can not get! part=%s,self.targetList=%s",part,vardump(self.targetList))
        return nil
    end
    if not self.targetList[part][name] then
        log.error("####guideData:getTarget can not get! part=%s,name=%s,self.targetList=%s",part,vardump(self.targetList[part]))
        return nil
    end
	return self.targetList[part][name]
end

function _M:checkStepOver(index)
	local currStep = index or self.lCurrStep
	if currStep > #luaCfg:guide() then
		return true
	else
		return false
	end
end

function _M:setGuideRect()
    self.m_openGuideRect = not self.m_openGuideRect
end

function _M:getGuideRect()
    return self.m_openGuideRect
end

global.guideData = _M
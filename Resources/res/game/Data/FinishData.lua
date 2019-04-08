local luaCfg = global.luaCfg

local _M = {
	finishList = {},
	specList = {},
}

function _M:init()   
end

function _M:checkFinish()
	-- body
	-- 士兵训练完成
	global.cityData:checkFinishCamp()
	-- 资源已满
	global.cityData:checkFinishFarm()

	-- 检测是否有可播放的队列
	self:showFinishTips()
end

function _M:showFinishTips()
	-- body
	if self.finishList and table.nums(self.finishList) > 0 then
		gevent:call(global.gameEvent.EV_ON_FINISHTIP, self.finishList[1])
	end
end

-- 完成的队列cd
-- lTipState 0 未播放 1 已播放
function _M:addFinshList(msg)
	-- body
	if not self:checkFinishList(msg.listId) then
		table.insert(self.finishList, msg)
	end
end

function _M:checkFinishList(listId)
	-- body
	for i,v in ipairs(self.finishList) do
		if tonumber(v.listId) == tonumber(listId) then 
			return true
		end
	end
	return false
end

function _M:removeFinishList(listId)
	-- body
	for i,v in ipairs(self.finishList) do
		if tonumber(v.listId) == tonumber(listId) then 
			table.remove(self.finishList, i)
			break	
		end
	end
end



--------------------- 训练和收获队列处理 ---------------------------
function _M:checkSpecList(buildId)
	-- body
	for i,v in ipairs(self.specList) do
		if tonumber(v) == tonumber(buildId) then 
			return true
		end
	end
	return false
end
function _M:addSpecList(buildId)
	-- body
	if not self:checkSpecList(buildId) then
		table.insert(self.specList, buildId)
	end
end
function _M:removeSpecList(buildId)
	-- body
	for i,v in ipairs(self.specList) do
		if tonumber(v) == tonumber(buildId)  then 
			table.remove(self.specList, i)
			self:removeFinishList(buildId)
			break	
		end
	end
end



global.finishData = _M
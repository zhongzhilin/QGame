local luaCfg = global.luaCfg

local _M = {
    collect = {},
}

function _M:init()   

	-- lType: (0中立，1友方，2敌方)    3 表示占领  	
	global.worldApi:getBookMark(function (msg)
      	
      	self.collect = {}
    	msg.tgBookmarks = msg.tgBookmarks or {}
    	for _,v in pairs(msg.tgBookmarks) do
    		if v.lType < 3 then  
    			table.insert(self.collect, v)
    		end
    	end
    end)
    
    if self.posX and self.posX ~= 0 then
    else
    	self.posX = 0
    end
    if self.posY and self.posY ~= 0 then
    else
    	self.posY = 0
    end
	-- end
end

function _M:getCollect()
	
	return self.collect
end

function _M:getCollectByKind( lType )

	local tempData = {}
	for _,v in pairs(self.collect) do
		
		if v.lType == lType then
			table.insert(tempData, v)
		end
	end
	return tempData
end

function _M:addCollect(msg)
	
	msg.lCityID = msg.lCityID or 0
	if self:checkCollect(msg.lCityID) then
		table.insert(self.collect, msg)
	else
		print("collect error")
	end
end

function _M:deleteCollect( lID )
	
	for i,v in pairs(self.collect) do
		if v.lID == lID then			
			table.remove(self.collect, i)
		end
	end
end

function _M:updateCollect(msg)
	
	for _,v in pairs(self.collect) do
		
		if v.lID == msg.lID then
			v.szName = msg.szName
			v.lType = msg.lType
		end
	end
end

function _M:checkCollect(lCityID)

	for _,v in pairs(self.collect) do	
		if v.lCityID == lCityID then
			return false
		end
	end
	return true
end

function _M:getCellSize()
	local cellSize = 138
	return cellSize
end

function _M:setCurPos(x, y)
	self.posX = x
    self.posY = y
end
function _M:getCurPos()
	
    return self.posX, self.posY
end

global.collectData = _M
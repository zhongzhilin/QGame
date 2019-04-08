local luaCfg = global.luaCfg
local gameEvent = global.gameEvent

local _M = {
    occupy = {},
    collect = {} , 
}

function _M:init()   

	print(">>>>>>>>>>>>>occupy init")
	global.worldApi:getOccupyBook(function (msg)
      
      	print(">>>>>>>>>>>>>occupy success")
        self.collect = msg.tgData or {}
    end)
end

function _M:getList()
	
	return self.collect
end

function _M:addOccupy(data)
	if not data then return end
	table.insert(self.collect,data)
	gevent:call(gameEvent.EV_ON_UI_OCCUPY_FLUSH)
end

function _M:removeOccupy(id)
		
	for i,v in ipairs(self.collect) do

		if v.lID == id then

			table.remove(self.collect,i)
			return
		end
	end

	gevent:call(gameEvent.EV_ON_UI_OCCUPY_FLUSH)
end

global.occupyData = _M
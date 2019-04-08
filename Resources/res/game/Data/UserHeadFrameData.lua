
local _M = {}

local luaCfg = global.luaCfg
local gameEvent = global.gameEvent


_M.STATE = {ON = 1 , OFF=2 } 

function _M:init(selectid, can_use_id)


	print(selectid,"selectid////////////////用户选择的头像框")
	-- dump(can_use_id,"selectid////////////////用户j解锁的头像框")


    self.data =clone(global.luaCfg:role_frame())

    table.sort(self.data , function(A ,B ) return A.order < B.order end )

    for _ ,v in pairs(self.data ) do 

    	v.state = self.STATE.OFF
    end 

    self.serverData =can_use_id or {1}

	for _ ,v in pairs(self.data) do 

		for  _ ,vv in pairs(self.serverData) do 

			if vv == v.id then 

				v.state = self.STATE.ON
			end 
		end 
	end

	self:setCrutFrame(selectid or 1 )
end

function _M:updateInfo()

	global.loginApi:getUserHeadFrameInfo(function (msg ) 

		-- dump(msg,"//////////////////////////////////////头像信息////////////////")

		self:init(msg.lBackId, msg.tagUnlocked)
	end ) 
end 

function _M:getFrameData()

	return self.data 
end 

function _M:deblockingHeadFrame(id) -- 解锁头像

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.state = self.STATE.ON
		end 
	end

	self:updateUi()
end


function _M:updateUi()

 	gevent:call(gameEvent.EV_ON_HEAMFREAM_UPDATE)
end 


function _M:getCrutFrame()
	-- dump(self.data)
	for _ ,v  in pairs(self.data) do 

		if v.select then 

			return v 
		end  
	end
	
	return global.luaCfg:get_role_frame_by(1)
end


function _M:setCrutFrame(id)

	for _ ,v in pairs(self.data) do 
		v.select  = false 
	end 

	for _ ,v  in pairs(self.data) do 
		if v.id == id then 
			v.select = true 
		end 
	end

	self:updateUi()
end 

global.userheadframedata = _M

--endregion

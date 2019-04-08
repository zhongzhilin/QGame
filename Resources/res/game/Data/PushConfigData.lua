--
-- Author: Your Name
-- Date: 2017-04-16 12:50:44
--
--
local _M = {}
function _M:init()
	self:initByLocalData()
end

function _M:getConfigData()
	return self.config_data
end 

 function _M:requestUpdateLocalDate(call)
    local callback = call or function (ret,msg) end  
    global.PushInfoAPI:getConfigureList(0,0,function(ret,msg)
        callback(ret,msg)
        -- dump(ret)
        -- dump(msg)
        if ret.retcode ==0 then 
            if msg then 
                self:initByServerData(msg.tagPushInfo)
            end 
        end 
    end)
 end 

function _M:initByLocalData()
    self.config_data =  global.luaCfg:push_type()
    for _, v in pairs(self.config_data) do
        if v.status==nil then 
          v.status = true
        end 
    end
end

function _M:initByServerData(msg)
    if not msg then return end 
    for _  ,v  in pairs(msg)do 
        for _, vv in pairs(self.config_data) do
            if vv.id == v.lType then
                vv.status = (v.lstate==1)
                break
            end 
        end 
    end
end 

function _M:ChangeStateByID(id , state)
  	for _, vv in pairs(self.config_data) do
        if vv.id ==id then
        	vv.status = state
            break
        end 
    end 
end
 
global.PushConfigData = _M
--endregion

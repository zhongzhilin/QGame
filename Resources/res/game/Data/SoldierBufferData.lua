--
-- Author: Your Name
-- Date: 2017-04-16 12:50:44
--
--
local _M = {}
local luaCfg = global.luaCfg

function _M:init()

	self.data = {} 	

end


function _M:updateBuff(msg)

	if msg ==  nil then return end 

	local flag = nil 

	for  i , v in pairs(self.data) do 

 		if v.lBind  == msg.id then 

 			self.data[i] = msg 
 			flag = true 
 		end 
	end 

	if  flag == nil  then 

		table.insert(self.data , msg )

	end 

end 

_M.SOLDIER_PROPERTY = 
{
    "atk",
    "dPower",
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
    "speed",
    "capacity",
    "alldef",
}

local def = {
        "iftDef",
        "cvlDef",
        "acrDef",
        "magDef",
    }

-- 标准的用法
function _M:getBuffByID(data,call)
	
	local check_val = function(msg)

		local temp  ={}
	    for _ ,v in pairs(msg) do 

	        if not global.EasyDev:CheckContrains(temp , v.lEffectID) then 
	            table.insert(temp , v.lEffectID)
	        end 
	    end
	    local effect_arr = {} 
	    for _ ,v in  pairs(temp) do 

	        local effect ={} 
	        effect.lEffectID = v
	        effect.lVal = 0 
	        effect.effect_data = luaCfg:get_data_type_by(effect.lEffectID)

	        for _ ,vv in pairs(msg)  do 

	            if vv.lEffectID  == v then 

	                effect.lVal = effect.lVal + vv.lVal
	            end 
	        end 
	        table.insert(effect_arr , effect)
	    end

	    local res = {}
	    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 
	        res[v] = 0         
	    end 

    	local property = luaCfg:get_soldier_property_by(data.id)
	    for _ ,v in pairs(effect_arr) do 

	        if data.type == v.effect_data.soldierType  or v.effect_data.soldierType == 99    then 

	            if  v.effect_data.natureType == 9 then -- 全防  

	                for _ , vv  in pairs(def)  do 

	                    if v.effect_data.extra == "%" then 

	                        res[vv] = res[vv] + math.ceil(property[vv] * (1 +  v.lVal  / 100 ))
	                    else 
	                        res[vv] = res[vv] + v.lVal
	                    end 
	                end

	            else

	            	local natureType = self.SOLDIER_PROPERTY[v.effect_data.natureType]

	                if v.effect_data.extra == "%" then 

	                	print(property[natureType],'property[natureType]')

	                    res[natureType] = res[natureType] + math.ceil(property[natureType] * (1 + v.lVal / 100))
	                else
	                    res[natureType] = v.lVal
	                end  
	            end 

	        end 

	    end

	  	return res
	end

    local tips_data2 = self:getBUffByID(data.id,function()
         	
    	local tips_data2 = self:getBUffByID(data.id)
    	if tips_data2 then
    		call(check_val(tips_data2.tgEffect or {}))
    	else
    		call(false)
    	end    	
    end)

    if tips_data2 then
    	call(check_val(tips_data2.tgEffect or {}))
    end
end

function _M:getBUffByID(id  , call )

	local buff_data = nil 

	for _ ,v in pairs(self.data) do 

		if v.lBind  == id then 

			buff_data 	=  v 
		end 
	end 

	if buff_data and  global.dataMgr:getServerTime() - buff_data.last_time > 5   then 
		self:requestBUffByID(call) 
	end 

	if   buff_data == nil then 
		self:requestBUffByID(call) 
	end 

	return buff_data
end 


function _M:requestBUffByID(call)

	local request_arr = {} 
	
	local pro  = global.luaCfg:soldier_property()

	for _ ,v in pairs(pro) do 

		if global.userData:getRace() == v.race or v.race == 0  then 

			table.insert(request_arr , {lType =7,lBind =v.id})
			
		end 
	end 

	global.gmApi:effectBuffer(request_arr,function(msg )

		if msg.tgEffect then 
			for _ ,v in pairs(msg.tgEffect) do 
				v.last_time = global.dataMgr:getServerTime()
				self:updateBuff(v)
			end 
		end 
		
		if call then 
			call()
		end 		

    end)

end 



function _M:setReplayData(data)
  
	self.commonData  =  data.tagcommonBuff or {} 

	self.privateData  = data.tagHeroBuff or {}
end 


function _M:getSoldierBuffByID(userid , ltroopid)

	print("userid",userid)
	print("ltroopid",ltroopid)

	local  commonBuff =  {} 
	local  privateBuff = {} 
	local  allBuff = {}  

	for _ ,v in pairs(self.commonData) do 

		if v.lid  == userid then 

			commonBuff =  v  
		end 
	end

	for _ ,v in pairs(self.privateData) do 
		if v.lid  == ltroopid then 
			privateBuff = v 
		end 
	end 


	dump(commonBuff,"commonBuff")

	dump(privateBuff,"privateBuff")


	--1   先把所有buff 整合 , 相同id 的buff  值相加 

	if  commonBuff.tagBuffDetail  then 

		allBuff = clone(commonBuff.tagBuffDetail)

		for _ ,v in pairs(privateBuff.tagBuffDetail or {} ) do 

			local isExits = false

			local temp = clone(v)

			for _ ,vv in pairs(commonBuff.tagBuffDetail or {} )   do 

				if vv.lBuffid == temp.lBuffid then 

					temp.lValue  = temp.lValue +  vv. lValue
					isExits = true 
				end 
			end 

			if isExits then 
				for key ,  v in pairs(allBuff)  do 
					if v.lBuffid   == temp.lBuffid  then 
						allBuff[key]  = temp 
					end 
				end 
			else 
				table.insert(allBuff , temp)
			end 
		end

	else 

		if  privateBuff.tagBuffDetail  then 

			allBuff = clone(privateBuff.tagBuffDetail)
		end 

	end 

	return allBuff 	
end


_M:init()

global.SoldierBufferData = _M
--endregion

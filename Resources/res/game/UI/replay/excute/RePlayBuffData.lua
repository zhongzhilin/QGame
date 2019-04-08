--
-- Author: Your Name
-- Date: 2017-04-16 12:50:44
--
--
local _M = {}

	--先加公共资源

function _M:setData(commonData, privateData)

	self.commonData  =  commonData

	self.privateData  =  privateData

end


local soldier_property = 
{
   [1] = "atk",
   [2]= "dPower",
   [3]= "iftDef",
   [4]= "cvlDef",
   [5]= "acrDef",
   [6]= "magDef",
   [7]= "speed",
   [8]= "capacity",
   [9]= "alldef",
}


local def = {
        "iftDef",
        "cvlDef",
        "acrDef",
        "magDef",
   }


function _M:getSoldierBuffByID(userid , ltroopid, soldierId)

	local  commonBuff =  {} 
	local  privateBuff = {} 
	local  allBuff = {} 

	for _ ,v in pairs(self.commonData) do 

		if v.lUid  == userid then 

			commonBuff =  v  
		end 
	end

	for _ ,v in pairs(self.privateData) do 
		if v.lUid  == ltroopid then 
			privateBuff = v 
		end 
	end 

	allBuff = clone(commonBuff)

	--1   先把所有buff 整合 , 相同id 的buff  值相加 

	for _ ,v in pairs(privateBuff) do 

		local isExits = false

		local temp = clone(v)

		for _ ,vv in pairs(commonBuff)   do 

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

  -- 2 根据士兵 id 
    local property 	= luaCfg:get_soldier_property_by( soldierId )
	-- for _ ,v in pairs(allBuff) do 
	-- end 	

end

--    }
-- [LUA-print] -                     "tagBuffCore" = {
-- [LUA-print] -                         1 = {
-- [LUA-print] -                             "lUid"          = 4000153
-- [LUA-print] -                             "tagBuffDetail" = {
-- [LUA-print] -                                 1 = {
-- [LUA-print] -                                     "lBuffid" = 3001
-- [LUA-print] -                                     "lValue"  = 15
-- [LUA-print] -                                 }
-- [LUA-print] -                                 2 = {
-- [LUA-print] -                                     "lBuffid" = 3015
-- [LUA-print] -                                     "lValue"  = 5
-- [LUA-print] -                                 }
-- [LUA-print] -                                 3 = {
-- [LUA-print] -                                     "lBuffid" = 3003
-- [LUA-print] -                                     "lValue"  = 1
-- [LUA-print] -                                 }
-- [LUA-print] -                                 4 = {
-- [LUA-print] -                                     "lBuffid" = 3017
-- [LUA-print] -                                     "lValue"  = 1
-- [LUA-print] -                                 }
-- [LUA-print] -                                 5 = {
-- [LUA-print] -                                     "lBuffid" = 3002
-- [LUA-print] -                                     "lValue"  = 2
-- [LUA-print] -                                 }
-- [LUA-print] -                                 6 = {
-- [LUA-print] -                                     "lBuffid" = 3016
-- [LUA-print] -                                     "lValue"  = 1
-- [LUA-print] -                                 }
-- [LUA-print] -                                 7 = {
-- [LUA-print] -                                     "lBuffid" = 3004
-- [LUA-print] -                                     "lValue"  =


global.RePlayBuffData = _M
--endregion

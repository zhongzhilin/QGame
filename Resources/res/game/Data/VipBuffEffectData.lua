--
-- Author: Your Name
-- Date: 2017-03-28 14:01:43
--
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
 local _M = {}

local luaCfg = global.luaCfg
  
-- optional int32		lPopCount = 1;//兵源购买次数
-- 	optional int32		lTaskCount = 2;//每日任务刷新次数	
-- 	optional int32		lBuyLord = 3;//购买体力次数
-- 	optional int32		lFreeCount = 4;//每日工资免费领取次数
-- 	optional int32		lDiamondCount = 5;//每日工资魔金使用次数
-- 	optional int32		lCritMultiple = 6;//每日工资资源的暴击倍率
-- 	repeated int32		lDivFreeCount = 7;//占卜免费使用次数 (1重置 2占卜 3状态)
-- 	repeated int32		lDivDiamondCount = 8;//占卜魔晶使用次数
-- 	optional int32		lSecretShopCount = 9;//神秘商店的刷新次数
-- 	optional int32		lVipLordCount = 10;//vip购买体力次数
-- 	optional int32		lVipDivCount = 11;//vip占卜免费使用次数
-- 	optional int32		lVipShopCount = 12;//vip神秘商店的刷新次数
-- 	optional int32		lVipTaskCount = 13;//vip任务刷新次数
-- 	optional int32		lVipDiamondCount = 14;//vip炼金次数
-- 	optional int32		lVipOpenCount = 15;//vip宝箱次数

_M.vipdiverseFreeNumberData = {} 
_M.vipdiverseFreeNumberData = {} 
	
function _M:init(tgBuyCount,notify )

	-- dump(tgBuyCount,"vip数据//////////////////")
	self:setVipDiverseFreeNumber("lVipShopCount",tgBuyCount.lVipShopCount)
	self:setVipDiverseFreeNumber("lVipDivCount",tgBuyCount.lVipDivCount)
	self:setVipDiverseFreeNumber("lVipOpenCount",tgBuyCount.lVipOpenCount)
	self:setVipDiverseFreeNumber("lVipTaskCount",tgBuyCount.lVipTaskCount)
	self:setVipDiverseFreeNumber("lVipDiamondCount",tgBuyCount.lVipDiamondCount) --  这是字段是是使用过的次数  其他的是 剩余的次数  要注意
	self:setVipDiverseFreeNumber("lVipLordCount",tgBuyCount.lVipLordCount)



end 


function _M:getDayTime(time)

    local dayTime = time - time  % (24*60*60) -- 余数
    local remnantTime = time % (24*60*60)
    local day  = dayTime / (24*60*60)

    return luaCfg:get_local_string(10675,day,global.funcGame.formatTimeToHMS(remnantTime))
end 

function _M:updateVIPData(vipdata)

	self.vipdata =vipdata
	self:init(vipdata,true)
	self:updateVipInfo()
	gevent:call(global.gameEvent.EV_ON_UI_VIPUPDATE)

end

function _M:checkEquiment(data , level)
     for _ ,v in ipairs(global.luaCfg:vip_effect()) do 
        if v.data_type ==  data[1] then 
            if v["vip_"..level] and v["vip_"..level] == 2 then 
                return true 
            end 
        end 
    end 

    return  false 
end 


local tips_apart_time = 1   -- 小时 (提前多少个小时 提示  vip 失效 )

function _M:localNotify()
	
	--本地推送
	if self:isVipEffective() then 
		global.ClientStatusData:recordNotifyData(16,self:getVipSurplusTime(), global.dataMgr:getServerTime())
	end 

	--即将到期推送
	if self:isVipEffective() then 
		local time  = self:getVipSurplusTime()  -  tips_apart_time * 60 * 60 
		if time > 0 then 
			global.ClientStatusData:recordNotifyData(30, time , global.dataMgr:getServerTime())
		end 
	end 

end 

function _M:reset()

	if self:isVipEffective() then

		self:setVipDiverseFreeNumber("lVipShopCount",self:getVipLevelEffect(3085).quantity or 0 )
		self:setVipDiverseFreeNumber("lVipDivCount",self:getVipLevelEffect(3082).quantity  or 0 )
		self:setVipDiverseFreeNumber("lVipOpenCount",self:getVipLevelEffect(3083).quantity or 0 )
		self:setVipDiverseFreeNumber("lVipTaskCount",self:getVipLevelEffect(3084).quantity or 0 )
		self:setVipDiverseFreeNumber("lVipDiamondCount",0) --  这是字段是是使用过的次数  其他的是 剩余的次数  要注意
		self:setVipDiverseFreeNumber("lVipLordCount",self:getVipLevelEffect(3080).quantity or 0 )

	else 
		for key ,v in pairs(self.vipdiverseFreeNumberData) do 
			self.vipdiverseFreeNumberData[key] =  0
		end 
	end

	gevent:call(global.gameEvent.EV_ON_UI_USER_UPDATE)	
end 

function _M:getVIPData()
	return self.vipdata
end 

function _M:getVipLevel()
	self.vipdata = self.vipdata or {}
	return self.vipdata.lLV or 1
end 

function _M:isVipEffective() --vip 是否有效

	if self.vipdata then 
		if self.vipdata.lState then 
			return self.vipdata.lState  ==  1 
		end 
	    if  self.vipdata.lEndTime - global.dataMgr:getServerTime()>=1 then 
	    	return true
	    end
	end 

    return false
end

function _M:getVipSurplusTime() --得到 vip 剩余时间
	local time = 0 
	if self:isVipEffective() then 
	 	time = self.vipdata.lEndTime - global.dataMgr:getServerTime()
	else 
		time =  0 
	end 
	if time <=1 then time = 0 end 
	return  time
end 

function _M:updateVipInfo() -- 根据 服务器所给的vip 等级 初始化 vip 所对应的效果
	self.vipEffectData = {} 
	for _ , v in pairs(global.luaCfg:vip_func()) do 
		if v.lv == self.vipdata.lLV  then 
			for _ , vv in pairs(v.buffID) do 
				local effect ={}
				if vv[2]> 0 then  -- 有的buff 对应的数值 为 0 忽略 
					effect.id  = vv[1] 
					effect.unit =global.luaCfg:get_data_type_by(vv[1]).extra
					effect.quantity = vv[2]
					table.insert(self.vipEffectData,effect)
				end 
			end 
		end 	
	end
end 


function _M:getVipLevelEffect(key, checkEffecit)-- 得到当前vip 对应效果  checkEffecit  vip 是否需要激活
 	if checkEffecit then 
	 	if self:isVipEffective() then 
			for _ ,v in pairs(self.vipEffectData) do 
				if v.id == key then 
					return v
				end
			end 
		end
	else
		for _ ,v in pairs(self.vipEffectData) do 
			if v.id == key then 
				return v
			end
		end 
	end 
	return {}
end

function _M:getCurrentVipLevelEffect(key,checkEffecit)--得到当前激活vip对应效果  
 	if self:isVipEffective() then 
		for _ ,v in pairs(self.vipEffectData) do 
			if v.id == key then 
				return v
			end
		end 
	end
	return {}
end

function _M:setVipDiverseFreeNumber(key,value) -- 设置 已使用 或 剩余 的vip 次数
	print("key----------",key , value)
	self.vipdiverseFreeNumberData[key] =value or 0 
end 

function _M:getVipDiverseFreeNumber(key) -- 得到  剩余 或 已使用 的vip 次数
 	local freenumber =self.vipdiverseFreeNumberData[key] 
	if freenumber and  freenumber>=0 then 
		return freenumber
	end 
	return 0
end 

function _M:setDiverseFreeNumber(key,value) -- 设置 已使用 或 剩余 的基础  次数
	self.diverseFreeNumberData[key] =value or 0 
end 

function _M:getDiverseFreeNumber(key) --设置 已使用 或 剩余 的基础 次数
	print('getDiverseFreeNumber------------',key,freenumber)
	local freenumber =self.diverseFreeNumberData[key] 
	if freenumber and  freenumber >=0 then 
		return freenumber
	end 
	return 0
end 

function _M:useDiverseFreeNumber(key , number) -- 更新 基础次数
	 self.diverseFreeNumberData[key] = self.diverseFreeNumberData[key] - number 
end 

function _M:useVipDiverseFreeNumber(key , number) ---- 更新 vip次数 炼金次数特殊处理 qaq
	-- if "lVipDiamondCount" == key then 
	-- 	self.vipdiverseFreeNumberData[key] = self.vipdiverseFreeNumberData[key] + number 
	-- 	return 
	-- end 
	self.vipdiverseFreeNumberData[key] = self.vipdiverseFreeNumberData[key] - number 
	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end 
 
function _M:isUseVipFreeNumber(key) --是否使用vip 次数  -- vip次数 大于 0 时 则使用 vip 次数  炼金特殊处理qaq
	if not self:isVipEffective() then 
		return false
	end
	local freenumber = self:getVipDiverseFreeNumber(key) 

	-- if "lVipDiamondCount" == key then 
	-- 	local  diamondcount =self:getVipLevelEffect(3086).quantity or 0  
	-- 	if freenumber < diamondcount then 
	-- 		return true 
	-- 	end
	-- 	return false 
	-- end 

	if not  freenumber or  freenumber <=0 then 
	 	return false 
	end 
	return true 
end


function _M:getMaxVIPLevel()
    local max =0 
    for _ ,v in pairs(global.luaCfg:vip_func()) do 
        if max < v.lv then 
            max = v.lv 
        end 
    end 
    return max  
end 



-- 先判断等级 ， 在判断 激活  ， 时间 

function _M:isTrainMonthCard(time) -- 0:等级不够高 1: 等级够高 未激活 2:  等级够高 激活 时间不够 3: 可用

	local state = 0 

	if self:getVipLevelEffect(3207).quantity then 

		if self:isVipEffective()  then 

			if time and  self:getVipSurplusTime() < time then 

				state = 2 
			else 
				state =  3 

			end 
		else

			state = 1  
		end 

	else
		state =  0 
	end 

	return  state
end 


-- 基础免费
--Mysterious 神秘商店
--Dailytask   每日任务
global.vipBuffEffectData = _M

--endregion

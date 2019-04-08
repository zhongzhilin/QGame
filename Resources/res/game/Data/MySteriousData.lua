--
-- Author: Your Name
-- Date: 2017-04-05 17:52:43
--
--
-- Author: Your Name
-- Date: 2017-03-28 14:01:43
--
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local _M = {}

function _M:init(msg)

	self.data ={}
	self.data.buycount = 0 

	--直通车 设置神秘商店购买 数据
	self:setBuyCount(msg.lSecretShopCount or 0 ) 

	self:setRandomShopMoney()
end 

function _M:setData(msg)


	self:setTagData(msg)

	if msg.tgBuyCount and msg.tgBuyCount.lSecretShopCount then 
		self:setBuyCount(msg.tgBuyCount.lSecretShopCount)
	else
		self:setBuyCount(0)
	end  

	self:setBuyList(msg.tgSecret)

	self:setEndTime(msg.lEndTime)

	self:setRandomShopMoney()

end 

function _M:localNotify() -- 
	if self.tag then 
		if self.tag.lEndTime then
			global.ClientStatusData:recordNotifyData(32 , self.tag.lEndTime - global.dataMgr:getServerTime() , global.dataMgr:getServerTime())
		end 
	end 
end 

function _M:getTagData()
	return self.tag 
end

function _M:setTagData(tag)
	self.tag = tag 
end 

function _M:setBuyList(goodslist)
	self.data.goodslist = goodslist
end 

function _M:getBuyList()
	return self.data.goodslist 
end 

function _M:setBuyCount(buycount)
	self.data.buycount = buycount
end 

function _M:getBuyCount()
	return self.data.buycount
end 

function _M:setEndTime(endtime)
	self.data.endtime = endtime
end 

function _M:getEndTime()
	return self.data.endtime
end 


function _M:setRandomShopMoney()

	local count = self:getBuyCount() 

	if not count then return end 

	local currentRefreashNumber = count + 1

  	local allrandom_shop = global.luaCfg:random_shop_money()

    if currentRefreashNumber > #allrandom_shop then 

        currentRefreashNumber =   #allrandom_shop
    end

    if currentRefreashNumber < 0 then 

        currentRefreashNumber = 0
    end

   	self.random_shop_money =global.luaCfg:get_random_shop_money_by(currentRefreashNumber) -- 服务其下标从0开始

   	gevent:call(global.gameEvent.EV_ON_UI_LEISURE)

end 

function _M:GetFreeRefreashNumber() -- 得到免费神秘商店免费次数。
    local count =   0 
    for _ ,k  in pairs( global.luaCfg:random_shop_money() )do 
        if k.cost  == 0 then 
            count =count+1
        end  
    end 
    return count
end 

function _M:getFreeNumber() 

	if not  self.random_shop_money then return 0 end 

    if self.random_shop_money.cost ~= 0 then 
        return 0 
    end 
    return self:GetFreeRefreashNumber() + 1 - self.random_shop_money.moneyID 
end 


global.MySteriousData = _M

--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global

local _M = {
    prop = {},
}

local ExchangeCfg = 
{
    [WCONST.PROP_INDEX.FOOD] = WCONST.ITEM.TID.FOOD,    
    [WCONST.PROP_INDEX.GOLD] = WCONST.ITEM.TID.GOLD,
    [WCONST.PROP_INDEX.DIAMOND] = WCONST.ITEM.TID.DIAMOND,
    [WCONST.PROP_INDEX.WOOD] = WCONST.ITEM.TID.WOOD,
    [WCONST.PROP_INDEX.STONE] = WCONST.ITEM.TID.STONE,
}

local errorcodeIds = 
{
    [WCONST.ITEM.TID.FOOD]      = "ItemUseFood",
    [WCONST.ITEM.TID.GOLD]      = "ItemUseCoin",
    [WCONST.ITEM.TID.DIAMOND]   = "ItemUseDiamond",
    [WCONST.ITEM.TID.WOOD]      = "ItemUseWood",
    [WCONST.ITEM.TID.STONE]     = "ItemUseStone",
    [WCONST.ITEM.TID.EXPLOIT]     = "turntable01",
}


function _M:init(msg)
    local props = msg.aRes
    if not props then return end
    for k, v in pairs(ExchangeCfg) do
        self.prop[v] = props[k]
    end
    -- log.debug("#########propData init :%s",vardump(self.prop))
    -- self.prop[ExchangeCfg[WCONST.PROP_INDEX.FOOD]] = 10000
    -- self.prop[ExchangeCfg[WCONST.PROP_INDEX.GOLD]] = 10000
    -- self.prop[ExchangeCfg[WCONST.PROP_INDEX.DIAMOND]] = 10000
    -- self.prop[ExchangeCfg[WCONST.PROP_INDEX.WOOD]] = 10000
    -- self.prop[ExchangeCfg[WCONST.PROP_INDEX.STONE]] = 10000

    -- 魔晶库和基金
    if msg and msg.tagBankInfo then
        self:initDiamond(msg) 
    end
end

--

function _M:getShowProp(key,gap)
    -- log.debug("##propData:getShowProp--->key=%s,props=%s",key,vardump(self.prop))
    local str = self:getShowStr(math.floor(self.prop[key] or 0), gap)

    return str
end

function _M:getShowStr(num,gap)   

    local floorV = tostring(num)
    -- log.debug("##propData:getShowProp--->floorV=%s",floorV)
    local len = #floorV
    local str = ""
    for i = 1,len do
        str = string.sub(floorV,len-i+1,len-i+1)..str
        if i%3 == 0 and i < len then
            if gap then
                str = gap..str
            else
                str = "/"..str
            end
        end
    end
    -- log.debug("##propData:getShowProp--->floorV=%s,len=%s,str=%s",floorV,len,str)
    return floorV
end

function _M:getProp(key)
    return self.prop[key]
end

function _M:setProp(key, value, isScroll)

    if value == nil then
        log.debug("!Error PropData:SetProp value is nil!")
    end
    if value < 0 then
        value = 0
    end
    self.prop[key] = value

    gevent:call(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,isScroll)
end

function _M:addProp(key,value,isScroll)
  
    log.debug("===>增加了货币"..key.."数量"..value)

    -- body
    if value == nil then
        log.debug("!Error PropData:SetProp value is nil!")
    end

    -- if value < 0 then
    --     value = 0
    -- end

    self:setProp(key,self.prop[key] + value,isScroll)
end

function _M:checkEnoughWithColor(key, value, txtNode)
    local enough = false

    if key == WCONST.ITEM.TID.EXPLOIT then
        local curExploit = global.userData:getTagExploit()
        enough = curExploit.lCurExploit >= value
    else
        enough = self.prop[key] >= value
    end
    
    if not enough then
        if txtNode then txtNode:setColor(gdisplay.COLOR_RED) end
    else
        if txtNode then txtNode:setColor(cc.c3b(255, 226, 165)) end
    end
    return enough
end

function _M:checkEnoughWithTips(key, value, txtNode)

    local enough = false
    if key == WCONST.ITEM.TID.EXPLOIT then
        local curExploit = global.userData:getTagExploit()
        enough = curExploit.lCurExploit >= value
    else
        enough = self.prop[key] >= value
    end
    
    if not enough then
        if errorcodeIds[key] then
            self:showResNotEnoughTip(key)
        end
    end
    return enough
end

function _M:showResNotEnoughTip(key)
    global.tipsMgr:showWarning(errorcodeIds[key])
end

function _M:checkEnough(key, value)
    if self.prop and self.prop[key] and value then --protect 
        return self.prop[key] >= value,(self.prop[key] - value)
    end 
end

function _M:getMoney()
    return self:getProp(WCONST.ITEM.TID.NOTE)
end   

function _M:getGold()
    return self:getProp(WCONST.ITEM.TID.GOLD)
end    

function _M:getFood()
    return self:getProp(WCONST.ITEM.TID.FOOD)
end

function _M:getExp()
    return self:getProp(WCONST.ITEM.TID.EXP)
end

function _M:checkMoneyEnough(value)
    return self:checkEnough(WCONST.ITEM.TID.NOTE, value)
end

function _M:checkGoldEnough(value)
    return self:checkEnough(WCONST.ITEM.TID.GOLD, value)
end

function _M:checkFoodEnough(value)
    return self:checkEnough(WCONST.ITEM.TID.FOOD, value)
end

function _M:checkDiamondEnough(value)
    return self:checkEnough(WCONST.ITEM.TID.DIAMOND, value)
end

function _M:initDiamond(msg)
    -- body
    self.tagBankInfo  = msg.tagBankInfo or {}  -- 银行利率
    self.tagMoneySave = msg.tagMoneySave or {} -- 用户存款
    self.tagFundInfo  = msg.tagFundInfo or {} 
    gevent:call(global.gameEvent.BANKUPDATE)
end

function _M:getBankInfo()
    return self.tagBankInfo
end

function _M:getMoneySave()
    return self.tagMoneySave
end

function _M:getFundInfo()
    return self.tagFundInfo
end

function _M:checkFull(key , value)

    print(self:getProp(key) ,"self:getProp(key)")

    return self:getProp(key) + value >  global.resData:getStoreMax()
end 

-- 当前魔晶库档位信息
function _M:getBankInfoById(id)
    -- body
    self.tagBankInfo = self.tagBankInfo or {}
    for i,v in ipairs(self.tagBankInfo) do
        if v.lID == id then
            return v
        end
    end
end

-- 当前是否有存款可以领取
function _M:curBankCanGet()

    self.tagMoneySave = self.tagMoneySave or {}
    for i,v in ipairs(self.tagMoneySave) do
        if v.lEndTime < global.dataMgr:getServerTime() then
            return true
        end
    end
    return false
end

-- 获取当前档位已经存款数量
function _M:getCurBankSave(lType)

    self.tagMoneySave = self.tagMoneySave or {}
    local curSave = 0
    for i,v in ipairs(self.tagMoneySave) do
        if lType == v.lType then
            curSave = curSave + v.lValue
        end
    end
    return curSave
end

function _M:getFundState(id)
    for _ , v in ipairs(self:getFundInfo().tagUserFund or {} )  do 
        if v.lID == id then 
            return v.lValue
        end         
    end     

    -- for _ , v in ipairs(self:getFundInfo().tagSvrFund or {} )  do 
    --     if v.lID == id then 
    --         return v.lValue
    --     end         
    -- end

    return 0 
end


global.propData = _M
--endregion

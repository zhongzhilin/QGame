local datetime = require "datetime"

local global = global
local userData = global.userData
local propData = global.propData
local itemData = global.itemData
local questData = global.questData
local cityData = global.cityData
local taskData = global.taskData
local speedData = global.speedData
local troopData = global.troopData
local soldierData = global.soldierData
local dailyTaskData = global.dailyTaskData
local normalItemData = global.normalItemData
local guideData = global.guideData
local buffData = global.buffData
local resData = global.resData
local heroData = global.heroData
local refershData = global.refershData
local unionData = global.unionData
local headData = global.headData
local chatData = global.chatData
local equipData = global.equipData
local collectData = global.collectData
local luaCfg = global.luaCfg
local occupyData = global.occupyData 
local rankData = global.rankData
local techData = global.techData 
local achieveData = global.achieveData 
local bossData = global.bossData
local rechargeData = global.rechargeData
local gameEvent = global.gameEvent
local vipBuffEffectData = global.vipBuffEffectData
local MySteriousData = global.MySteriousData
local PushConfigData = global.PushConfigData
local AdvertisementData = global.advertisementData 
local EasyDevData = global.EasyDev 
local loginData = global.loginData
local activitydata = global.ActivityData 
local leisureData = global.leisureData 
local mailData = global.mailData
local ShopData = global.ShopData
local userheadframedata = global.userheadframedata
local userCastleSkinData = global.userCastleSkinData
local petData = global.petData
local finishData = global.finishData

local _M = {}

function _M:clear()
    
end

local isDataInit = false
function _M:init(msg)
    global.OPENGUIDE = cc.UserDefault:getInstance():getBoolForKey(WDEFINE.USERDEFAULT.OPEN_GUIDE)
    -- self.resVersion = msg.res_version
    PushConfigData:init()
    self:setServerTime(msg.lCurTime)
    -- self:setServerTime()
    userData:init(msg)
    userData:setWorldCityID(msg.lCityID)
    propData:init(msg)
    -- questData:init(msg.userdata.quest)
    cityData:init(msg.tgBuilds)
    cityData:initBuilders(msg.tgQueues)    
    cityData:initQueue(msg.tgQueueLocked)
    soldierData:init(msg.tgSoldiers)
    soldierData:initTrap(msg.tgTraps)
    troopData:init(msg.tgTroop, msg.tgReinforceTroop)
    unionData:init(msg.tgAlly)
    equipData:init(msg.tgEquip)
    collectData:init()
    occupyData:init()
    rankData:init()

    taskData:init(msg.tgTasks,msg.tgSubTasks)

    speedData:init()
    dailyTaskData:init(msg)
    normalItemData:init(msg.tgItems)
    guideData:init()
    buffData:init(msg.tgPlus)
    refershData:init(msg.tgBuyCount)
    heroData:init(msg.tgHero, msg.tagBuildGarrison)
    heroData:initPersuade(msg.tgQueues,true)
    resData:init(msg)
    headData:init(msg.szCustomIco)
    headData:setlCustomIcoCount(msg.tgBuyCount.lCustomIcoCount)
    chatData:init()
    techData:init(msg)
    achieveData:init()
    bossData:init(msg)
    rechargeData:init(msg)

    vipBuffEffectData:init(msg.tgBuyCount)
    MySteriousData:init(msg.tgBuyCount)
    EasyDevData:init(isDataInit)
    AdvertisementData:init(msg.tagadvertList,msg.lAdRetsetEndTime or msg.lTodayZero)
    loginData:init(msg)
    activitydata:init(msg.tagAct, msg.tagSevenHeroUpgrade, msg.tagHeroUpgrade)
    leisureData:init()
    mailData:init({})
    ShopData:init()
    userheadframedata:init(msg.lBackId,msg.lUnlockedBack)
    userCastleSkinData:init(msg.lSkinId, msg.tagAvatarSkin)
    rechargeData:setSevenDayRechargeData(msg.tagPaySignInfo)
    petData:init(msg.tagGodAnimal)

    heroData:setDisscountHero(msg.lHeroCut)
    heroData:setDisscountHeroTime(msg.tagTime.lHeroCutTime)

    EasyDevData:setADIntervalTime(msg.lTodayZero)
    AdvertisementData:setUnLockData(msg.tagLocked)

    userData:setPkCount(msg.tgBuyCount.lGeneralPKCount or 0 )

    global.guideMgr:loadScript()
    finishData:init()

    isDataInit = true
end

function _M:isDataMgrInitSuccess()
    return isDataInit
end

function _M:getServerTime()
    global.m_startTime = global.m_startTime or datetime.now().secs
    global.m_serverTime = global.m_serverTime or datetime.now().secs
    return math.floor(global.m_serverTime - global.m_startTime + datetime.now().secs )
end

--获取零时区的时间偏移
function _M:getServerTimeZoneAdd()
    if not self.addZone then
        local now = os.time()
        self.addZone = os.difftime(now, os.time(os.date("!*t", now)))
    end
    return self.addZone
end

function _M:setClientStartTime()
    global.m_startTime = datetime.now().secs
end

function _M:setServerTime(time)
    
    global.m_startTime = global.m_startTime or datetime.now().secs
    local ntpTime = datetime.now().secs - global.m_startTime
    print(ntpTime,'ntpTime')

    time = time or datetime.now().secs
    if time then  --protect 
        global.m_serverTime = time - ntpTime / 2
    end 

    local now = os.time()
    self.addZone = os.difftime(now, os.time(os.date("!*t", now)))
end

--data get
--mprop
function _M:getProp(itemid)
    local itemConfig = global.luaCfg:get_itemtable_by(itemid)
    if itemConfig.item_type == WCONST.ITEM.KIND.PROP then
        return propData:GetProp(itemid)
    else
        return itemData:GetItemNumByTID(itemid)
    end
end

function _M:updateItems(dropItems)

    local tipStr = ""

    local isItemUpdate = false

    for _,v in ipairs(dropItems) do

        local itemId = v[1]
        local itemNum = v[2]

        if itemId == WCONST.ITEM.TID.EXP then
            
            userData:addExp(itemNum)
        elseif itemId < 100 then

            propData:addProp(itemId,itemNum)
        else

            normalItemData:addItem(itemId,itemNum)
            isItemUpdate = true
        end        

        local itemData = luaCfg:get_item_by(itemId)
        local itemName = itemData.itemName
     
        if itemNum > 0 then
            tipStr = tipStr .. itemName .. "+" .. itemNum .. " "
        end
    end

    if isItemUpdate then gevent:call(gameEvent.EV_ON_ITEM_UPDATE,data) end

    return tipStr
end

global.dataMgr = _M
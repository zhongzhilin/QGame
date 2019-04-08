
---@classdef LogicNotify
local LogicNotify = {
    
}
local global = global

local gameEvent = global.gameEvent
local gevent = gevent

local itemData = global.itemData
local userData = global.userData
local chatData = global.chatData

local pbpack = require("pbpack")

------------------------------WGAME--------------------------------------------

-- ntf propchg 
-- 用户属性变更
function LogicNotify:tagRes(prop)    
    
    print(">>>>>>>>tag res")

    local oldDiamond = global.propData:getProp(WCONST.ITEM.TID.DIAMOND)

    global.propData:init(prop)
    
    local isNotify = true
    gevent:call(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,isNotify)

    global.rechargeData:checkDiamondConsume(oldDiamond)

end

function LogicNotify:tagTask(data)

    print("############## LogicNotify:tagTask(data) : ##################### ")
    dump(data)

    local lCurScore = data.lCurScore

    data = data.tagTask

    ---- 每日任务
    local firstTaskId = 100001
    local dailyTask = {}
    for _,v in pairs(data) do
        if v.lID >= firstTaskId then
            table.insert(dailyTask, v)
        end
    end
    if #dailyTask > 0 then
        local isRefresh = false
        if #dailyTask > 1 then
            global.dailyTaskData:refershTask(dailyTask)
            isRefresh = true
        else
            global.dailyTaskData:updateTask(dailyTask[1], lCurScore)
            isRefresh = false
        end
        gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH, isRefresh)
        gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
    end


    if #data == 2 then -- mean this is a compelete
        
        local nextMission = data[2]
        
        global.taskData:updateCurrentMainTask({sort = 1,id = nextMission.lID,state = nextMission.lState,progress = nextMission.lProgress}) 
        
        -- gevent:call(gameEvent.EV_ON_TASK_COMPELETE,data[1])
    end

    local contentMission = data[1]

    global.taskData:updateMainTask({sort = 1,id = contentMission.lID,state = contentMission.lState,progress = contentMission.lProgress}) 

    if data[1].lState == 1 then

        gevent:call(gameEvent.EV_ON_TASK_COMPELETE,data[1])
    end
end

-- ntf user
-- 角色信息
function LogicNotify:tagUser(data)    
    local userData = global.userData
    local oldLv = userData:getLevel()
    userData:init(data)
    gevent:call(global.gameEvent.EV_ON_UI_USER_UPDATE)
    gevent:call(global.gameEvent.EV_ON_UI_HP_UPDATE)

    if oldLv ~= userData:getLevel() then
        global.EasyDev:updateRoleInfoWith()
    end

    -- local oldData = {level = userData:GetLevel()}
    -- userData:SetLevel(data.level)
    -- userData:SetExp(data.exp)

    --global.flagData:addFlagToUser(FLAG_CONST.USER.LEVEL_UP, oldData)
    -- gevent:call(gameEvent.EV_ON_LEVELUP)

    dump(data, ">>>>>>>>>>>> LogicNotify:tagUser(data):"..global.dataMgr:getServerTime())
    -- 七日签到
    if data.tgLoginSign then
        global.dailyTaskData:setTagSignInfo(data.tgLoginSign)
        gevent:call(gameEvent.EV_ON_DAILY_REGISTER)
    end
    
end

function LogicNotify:tagTroopSituation(data1)

    for _,data in ipairs(data1.tgData) do

        data.lReason = data1.lReason
        if global.scMgr:isWorldScene() then

            if global.g_worldview.isInit then

                global.g_worldview.attackMgr:dealAttackBoard(data)

                if global.panelMgr:isPanelOpened('UISpeedPanel') then
                    
                    local speedPanel = global.panelMgr:getPanel("UISpeedPanel")
                    if speedPanel then 
                        speedPanel:exit()
                    end
                end
            end            
        end

        if global.scMgr:isWorldScene() or global.scMgr:isMainScene() then
            global.worldApi:dealAttackEffectCommon(data)
        end        
    end    
end

function LogicNotify:tagQueue(data)
    
    if data.lReason ~= 1 then
        global.heroData:initPersuade(data.tgQueues)
        global.userData:updateQueue(data.tgQueues)
    else
        global.userData:deleteQueue(data.tgQueues)
        global.heroData:deletePersuade(data.tgQueues)
    end    
end

function LogicNotify:tagTroop(data)

    print("#################  LogicNotify:tagTroop(data) ")
    -- dump(data)
    

    local userId = global.userData:getUserId()

    local troopInfo = data.tagTroop
    for _,v in ipairs(troopInfo) do

        if v.lUserID == userId then

            -- lreason = 1 部队解散
            if data.lReason == 1 then
                global.troopData:deleteTroopsById(v.lID)
            else
                global.troopData:updataTroop(v, true)
            end
        end        
    end
    -- gevent:call(global.gameEvent.EV_ON_UI_TROOP_REFERSH)
end

function LogicNotify:tagMonsterCamp(data)
    
    dump(data,">>>>>>>tagMonsterCamp")

    if data.lCurHp == 0 then

        global.tipsMgr:showWarning("WildSuccess")
    elseif data.lCurHp == data.lMaxHp then

        global.tipsMgr:showWarning("WildFailed")
    end

    -- local id = data.lMapID

    -- gevent:call(global.gameEvent.EV_ON_MONSTER_CAMP,id)
end

function LogicNotify:tagMiracleInfo(data)
    
    dump(data,">>>>>>>tagMiracleInfo")

    if data.lCurHp == 0 then

        global.tipsMgr:showWarning("WildSuccess")
        
    elseif data.lCurHp == data.lMaxHp then

        global.tipsMgr:showWarning("WildFailed")
    end

    -- gevent:call(global.gameEvent.EV_ON_MONSTER_CAMP,id)
end

function LogicNotify:tagTrap(data)
    global.soldierData:initTrap(data.tagTraps or {})
end

function LogicNotify:tagLoopNews(data)
    
    if gevent_is_back() then return end
    gevent:call(global.gameEvent.EV_ON_UI_NOTICE_FLUSH,data)
end

function LogicNotify:tagReinForce(data)
    
    -- print(" ################# LogicNotify:tagReinForce(data):")
    -- dump(data)

    for _,v in pairs(data.tagTroop) do

        -- 别人驻防在我城上
        if data.lReason == 0 then
            global.troopData:addTroop(v)
        else
            local m_useId = global.userData:getUserId()
            if  v.lUserID ~= m_useId then
                global.troopData:deleteTroopsById(v.lID)
            end
        end
    end
    gevent:call(global.gameEvent.EV_ON_UI_TROOP_REFERSH)

end


function LogicNotify:tagItem(data)
-- nt] - "物品更新了" = {
-- [LUA-print] -     "lReason" = 201
-- [LUA-print] -     "tagItem" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "lCount" = 1
-- [LUA-print] -             "lID"    = 12513
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] - }
    local old_data = {}
    for _,v in ipairs( global.normalItemData._items) do
        for _ ,vv in  pairs( data.tagItem or {}) do 
            if v.id == vv.lID then
                table.insert(old_data , clone(v))
                break
            end
        end 
    end
    local items = data.tagItem or {}
    local res = {}
    local arr_item  = {} 
    for _,v in ipairs(items) do
        local item = {id = v.lID,count = v.lCount}
        table.insert(arr_item,item)
        table.insert(res,{id = v.lID,count = v.lCount})
    end
    global.normalItemData:updateItems(res)
    gevent:call(gameEvent.EV_ON_ITEM_UPDATE,res,1)

    if data.lReason ==219 then   -- 炼金池 额外掉落物品
        for _ ,v in pairs(arr_item) do 
            for _ , vv in  pairs(old_data) do 
                if v.id  == vv.id  then 
                    v.count = v.count - vv.count
                end 
                break 
            end 
        end 
        if # arr_item > 0  then
            local panel  = global.panelMgr:openPanel("UIReceivePanel")
            panel:setReceiveData(arr_item)
        end
    end 
end

function LogicNotify:tagSoldier(data)
    
    global.soldierData:addSoldiersBy(data.tagSoldier or {})

    gevent:call(gameEvent.EV_ON_SOLDIERS_UPDATE)

    if global.scMgr:isMainScene() and global.g_cityView then
        global.g_cityView:getSoldierMgr():refershSoldier()  -- 刷新校场士兵显示
    end
end

function LogicNotify:tagDailyChange(data)
    
    dump(data, "############LogicNotify:tagDailyChange(data)  整点通知 : ".. global.dataMgr:getServerTime())

    --零点通知
    if data.lType == 1 then

        global.EasyDev:setADIntervalTime(global.dataMgr:getServerTime()) -- 广告小红点
        gevent:call(global.gameEvent.EV_ON_UNION_ADREDPOINT)
        
        global.dailyTaskData:initTaskData()  -- 每日任务
        global.vipBuffEffectData:reset()
        global.rechargeData:refershZero()    -- 月卡零点刷新
        global.dailyTaskData:reSertCostCount()
        global.rechargeData:restSevenDayRechargeData()
        global.bossData:setGateBuyTime(0)    -- 龙潭挑战令购买次数重置

        global.userData:setPkCount(global.luaCfg:get_hero_arena_by(1).para)

        gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH, true)
        gevent:call(gameEvent.EV_ON_DAILY_REGISTER)

        -- 答题次数重置
        global.refershData:resetQuestionToday()

        -- 每日限购礼包和福利礼包重置
        global.userData:updatelDailyGiftCount(1)
        global.rechargeData:resetDailyRecharge()


    elseif data.lType == 2 then
        --免费治疗刷新
        global.userData:setFreeHeal(data.lParams[1])
        gevent:call(gameEvent.EV_ON_SOLDIERS_FREE_RECRUIT_UPDATE)
    elseif data.lType == 3 then
        -- 固定时间兵源恢复
        local tagTime = global.dailyTaskData:getTimestamp() or {} 
        tagTime.lDailyPopTime = data.lParams[1] or 0
        global.dailyTaskData:setTimestamp(tagTime)
        gevent:call(gameEvent.EV_ON_SOLDIER_GET)

    elseif data.lType == 11 then -- 广告刷新时间通知

        global.advertisementData:requestAllAdData()
    elseif data.lType == 8 then 
        -- 占卜重置
        global.refershData:dailyChangeState()   
        gevent:call(gameEvent.EV_ON_DAILY_REGISTER)
    elseif data.lType == 12 then 
        -- 炼金重置
        global.refershData:requestDailaySalaryState()   
        gevent:call(gameEvent.EV_ON_DAILY_REGISTER)
    elseif data.lType == 13 then
        --兵源购买次数重置
        global.refershData:setBuyCount(0)
        local tagTime = global.dailyTaskData:getTimestamp()
        tagTime.lPopTime = data.lParams[1] or 0
        global.dailyTaskData:setTimestamp(tagTime)
        gevent:call(gameEvent.EV_ON_SOURCE_BUYCOST_UPDATE)
    elseif data.lType == 14 then
        -- 每周军功累计值倒计时
        local tagTime = global.dailyTaskData:getTimestamp()
        tagTime.lExploitTime = data.lParams[1] or 0
        global.dailyTaskData:setTimestamp(tagTime)
        gevent:call(gameEvent.EV_ON_UI_USER_UPDATE)

    elseif data.lType == 15 then -- 打折英雄
        local day = 24 * 60 * 60
        dump(data ,"大致通知")
        global.heroData:setDisscountHeroTime(global.dataMgr:getServerTime() + (7*day))
        global.heroData:setDisscountHero(data.lParams)
        gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH)

    elseif data.lType == 16 then -- 英雄转盘

        local day = 24 * 60 * 60
        local tagTime = global.dailyTaskData:getTimestamp()
        tagTime.lFreeLotteryTime = global.dataMgr:getServerTime() + day
        global.dailyTaskData:setTimestamp(tagTime)
        gevent:call(gameEvent.EV_ON_HERO_TURNTABLE_CHANGE)
        gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
        
    end 

    self:tagCommon({lType = 1})
end

function LogicNotify:tagHero(data)
    
    dump(data,">>>>>>>>tagHero:")
    for _,v in ipairs(data.tagHero or {}) do
        global.heroData:updateVipHero(v)
    end 
end

function LogicNotify:tagGeneralInfo(data)
    
    dump(data,">>>>>>>>tagGeneralInfo")

    local preHeroData = nil
    local isUpdate = false

    if data.lReason == 1 then
        data.tgHero.lState = -2
    else

        preHeroData = clone(global.heroData:getHeroDataById(data.tgHero.lID))
        if preHeroData and preHeroData.serverData and preHeroData.serverData.lGrade then
            if data.tgHero.lGrade > preHeroData.serverData.lGrade then
    
                isUpdate = true                    
            end
        end        
    end    

    global.heroData:updateVipHero(data.tgHero)

    if isUpdate then
    
        local heroPanel = global.panelMgr:getPanel("UIHeroLvUp")
        if heroPanel.isShow then
            global.heroData:insertWaitData({data = global.heroData:getHeroDataById(data.tgHero.lID),preData = preHeroData})
        else
            if not global.guideMgr:isPlaying() then
                global.panelMgr:openPanel("UIHeroLvUp"):setData(global.heroData:getHeroDataById(data.tgHero.lID),preHeroData)
            end
            gevent:call(global.gameEvent.EV_ON_BATTLEERRORCODE_SHOW)
        end        
    end    
end

-- 0发送所以全部，1为增加/更改、2为删除
function LogicNotify:tagPlus(data)

    local buffData = global.buffData
    if data.lReason == 0 then
        buffData:init(data.tagPlus)
    elseif data.lReason == 1 then
        buffData:updateBuffer(data.tagPlus)
    elseif data.lReason == 2 then
        buffData:deleteBuffer(data.tagPlus)
    end 

    gevent:call(gameEvent.EV_ON_CITY_BUFF_UPDATE)
end

function LogicNotify:tagMail(data)

    -- dump(data, "=============== LogicNotify:tagMail(data) =====================: ")
    global.mailData:init(data.tagMail)
    global.mailData:isFirstLogic()
end

function LogicNotify:tagMailCount(data)

    -- dump(data, "LogicNotify tagMailCount: ")
    global.mailData:setMailUnReadNum(data.tagPair or {})
    gevent:call(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM)
end

function LogicNotify:tagFightBase(data)
     
    print("############# LogicNotify:tagFightBase(data)")
    gevent:call(gameEvent.EV_ON_FIGHT_CHANGE)    
end

function LogicNotify:tagTroopArea( data )
    
    if global.scMgr:isWorldScene() then
        global.g_worldview.attackMgr:flushTroopInstance(data.lUserID,data.lTroopID,nil)
        -- if global.g_worldview.worldPanel.mainCity then
        --     global.g_worldview.worldPanel.mainCity.refreshState()
        -- end
    end
end

function LogicNotify:tagEquip(data)
    
    for _,equip in ipairs(data.tagEquip or {}) do

        local v = {}
        v.lReason = data.lReason
        v.tagEquip = equip
        global.equipData:equipNotify(v)
    end    

    gevent:call(gameEvent.EV_ON_UI_EQUIP_FLUSH)
    gevent:call(gameEvent.EV_ON_UI_HERO_FLUSH) 
end

function LogicNotify:tagMapTroop( data )

    for _ ,v in pairs(data.tagTroop) do 
        if v.lUserID ==  global.userData:getUserId()  then 
            global.ClientStatusData:troopMsg(v)
         end 
    end 
    
    if global.scMgr:isWorldScene() then
        global.g_worldview.attackMgr:addAttack(data)
        -- if global.g_worldview.worldPanel.mainCity then
        --     global.g_worldview.worldPanel.mainCity.refreshState()
        -- end
    end
end

------------------------------->>>>note:@@@@@Abandoned API
function LogicNotify:tagFireFinish(data)
    -- d
    print(">>>>>>>>>function LogicNotify:tagFireFinish(data)")

    if global.panelMgr:isPanelOpened("UICastleInfoPanel") then
    
        local panel = global.panelMgr:getPanel("UICastleInfoPanel")
        if panel then
            panel:exitPanel()
        end
    end

    if global.scMgr:isWorldScene() then

        global.userData:setCityState(3)
        global.scMgr:gotoMainSceneWithAnimation()
       return
    end

    gevent:call(gameEvent.EV_ON_CITY_BURNED)
    
    global.panelMgr:openPanel("FireFinish")

    if global.scMgr:isWorldScene() then

        local mainCityData = {

            lPosX = data.lX,
            lPosY = data.lY,
            lCityID = data.lCityId,
        }

        global.g_worldview.worldPanel:setMainCityData(mainCityData,true)
        -- global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-city.lPosX,-city.lPosY),true)
    end
end

function LogicNotify:tagTransfer(data)
    
    print(">>>>>>>>>function LogicNotify:tagTransfer(data)")
    if global.scMgr:isWorldScene() then
        global.g_worldview.areaDataMgr:doorNotify(data)
    end     
end

function LogicNotify:tagAttackFinish(data)
    
    -- dump(data,">>>>>>>>>>>>>>function LogicNotify:tagAttackFinish(data)")
    if global.scMgr:isWorldScene() and global.g_worldview and global.g_worldview.attackMgr then
        global.g_worldview.attackMgr:addGiftBox(data)
    end   
end

function LogicNotify:tagWorldNeedFlush( data )
    
    if global.scMgr:isWorldScene() then
        global.g_worldview.areaDataMgr:flushCurrentScreen(nil,nil,nil,function()
            -- body
            -- global.g_worldview.mapPanel:refreshLeagueArea()
        end)
    end    
end

function LogicNotify:tagCity(data)
     
    if global.scMgr:isWorldScene() then

        global.g_worldview.areaDataMgr:cityNotify(data)
    end

    if data.lCitys then
        for _,v in ipairs(data.lCitys) do
            if v.tagCityOwner and global.userData:getUserId() == v.tagCityOwner.lUserID and v.lKind == 1 then
                global.resData:addWorldCity(v)
            end

            --检测是否之前占领了这个城池
            global.resData:removeWorldCity(v)
            gevent:call(global.gameEvent.EV_ON_RES_WIDELIST)
        end
    end

end

function LogicNotify:tagCityBase(data)
    
    -- dump(data,">>>>>>>>>>>function LogicNotify:tagCityBase(data)")
    global.userData:setCityState(data.lState)

    if data.lState == 3 then

        if global.panelMgr:isPanelOpened("UICastleInfoPanel") then
        
            local panel = global.panelMgr:getPanel("UICastleInfoPanel")
            if panel then
                panel:exitPanel()
            end
        end

        if global.scMgr:isWorldScene() then

            global.userData:setCityState(3)
           global.scMgr:gotoMainSceneWithAnimation()
           return
        end

        gevent:call(gameEvent.EV_ON_CITY_BURNED)
        
        global.panelMgr:openPanel("FireFinish")
    end
end


function LogicNotify:tagWorldDef(data)
    if data and data.lCityID <= 0 then
        gevent:call(gameEvent.EV_ON_CITY_BURNED)
    end
end

function LogicNotify:tagWild(data)

    dump(data, "##########> LogicNotify:tagWild(: ")

    if data.tagWildRes then
        if global.scMgr:isWorldScene() and global.g_worldview.areaDataMgr then
            global.g_worldview.areaDataMgr:wildResNotify(data.tagWildRes)
        end
        for _,v in ipairs(data.tagWildRes) do
            if v.tagOwner and global.userData:getUserId() == v.tagOwner.lUserID then
                global.resData:addWorldWild(v)
            end
            global.resData:removeWorldWild(v)
            gevent:call(global.gameEvent.EV_ON_WILD_REFRESH,v)                       
        end
        gevent:call(global.gameEvent.EV_ON_RES_WIDELIST)        
    end

    if data.tagWildMonster then
        if global.scMgr:isWorldScene() then
            -- boss 消失的回调
            local call = function (data)
                local isBoss = data.lBelongsType == 3 or data.lBelongsType == 6
                if isBoss and global.funcGame:checkBelong(data) then
                    gevent:call(global.gameEvent.EV_ON_UI_BOSS_MISS)   -- 龙潭boss
                elseif data.lBelongsType == 2 and global.funcGame:checkBelong(data) then
                    gevent:call(global.gameEvent.EV_ON_UNIONBOSS_MISS) -- 联盟boss
                end
            end

            if  global.g_worldview.areaDataMgr then --protect  
                
                global.g_worldview.areaDataMgr:wildObjNotify(data.tagWildMonster, call)
            end 
        else
            global.bossData:wildObjNotify(data.tagWildMonster)
        end

        --- 宝箱任务
        for _,v in pairs(data.tagWildMonster) do
            
            if v.lKilled and (v.lKilled == global.userData:getUserId()) and global.dailyTaskData:checkIsCanWild() and v.lBelongsType ~= 3 and v.lBelongsType ~= 2 and v.lBelongsType ~= 6 then

                local curTimes = global.dailyTaskData:getWildTimes()
                global.dailyTaskData:setWildTimes(curTimes+1)
                
                gevent:call(global.gameEvent.EV_ON_UICHESTPANEL_UPDATE)
            end
        end
    end
    gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
end

function LogicNotify:tagFightResult( data )
    


    require("game.UI.world.mgr.AttackMgr").showRes(data)
    gevent:call(global.gameEvent.EV_ON_ATTACK_FINISH)
    -- global.g_worldview.attackMgr:showRes(data)
    -- global.tipsMgr:showWarning("185")
end

function LogicNotify:tagInFindPath( data ) -- 开始寻路&&寻路失败
    
    if data.lResult == 0 then

        global.panelMgr:openPanel("UISeeking"):setTroopId(data.lTroopID)
    else

        if data.lResult == 1 then
            global.tipsMgr:showWarning("177")
        end        
        
        global.panelMgr:closePanel("UISeeking")
    end
end

function LogicNotify:tagPathTime( data ) -- 获得寻路数据

    global.funcGame:showPathTimePanel(data)
end

function LogicNotify:tagAlly( data ) -- 联盟数据更改通知
    local lastAllyId = global.userData:getlAllyID()
    global.userData:setlAllyID(data.lAllyID)
    if data.lAllyID == 0 then
        global.userData:setlAllyDonate({})
        global.unionData:resetInUnion({})

        if lastAllyId ~= data.lAllyID then
            global.panelMgr:closeAllUnionPanel()
        end
    else
        global.unionData:setInUnion(data.tagAlly)
        global.userData:setlAllySub(data.tagSub)
        if lastAllyId ~= data.lAllyID then
            global.panelMgr:closeAllUnionPanel()
            -- global.panelMgr:openPanel("UIHadUnionPanel")
            global.unionApi:getRedCount(function() end,nil,true)
            global.unionData:initPower()
            global.unionData:initWar(true)
            return
        end
    end

    global.unionApi:getRedCount(function() end,nil)
end

function LogicNotify:tagMessage( data ) -- 发送邮件通知

    dump(data,">>>>>>>>>>> LogicNotify:tagMessage >>>>>>>>>>>>>>")
    
    ---- 最新消息加入缓存
    local newMsg = data.tagCTMsg[1]
    if not newMsg.lType then return end
    local curKey = global.chatData:getChatId(newMsg)

    -- 接收
    local isGetMessage = newMsg.lFrom ~= global.userData:getUserId()
    -- 服务自动发送
    local isMine = newMsg.lFrom == global.userData:getUserId()
    local specKey = {10, 12}
    local isSpecKey = function (key)
        for k,v in pairs(specKey) do
            if v == key then
                return true
            end
        end
        return false
    end
    local isSpecMessage = newMsg.tagSpl and newMsg.tagSpl.lKey and isSpecKey(newMsg.tagSpl.lKey) -- 联盟礼包
    local isSpecMsg = isMine and isSpecMessage
    if isGetMessage or isSpecMsg then

        print(" ==== isSpecMessage")
        print(isSpecMessage)
        local isPublic = (newMsg.lType ~= 1) and (not global.chatData:getFirstPush(curKey))
        local isPrivate = (newMsg.lType == 1) and (not chatData:isShieldUser(curKey))
        if isPublic or isPrivate then
            chatData:addChat(curKey, newMsg)
            -- 系统维护公告
            local isNotice = newMsg.tagSpl and newMsg.tagSpl.lKey and newMsg.tagSpl.lKey == 6
            local isSystem = newMsg.lFrom == 0
            if isNotice and isSystem then
                chatData:addChat(4, newMsg)
            end

            gevent:call(gameEvent.EV_ON_NEW_CHAT, newMsg)

            -- 联盟招募置顶
            if newMsg.tagSpl and newMsg.tagSpl.lKey == 7 then
                chatData:setChatRecruitMsg(newMsg)
                gevent:call(global.gameEvent.EV_ON_CHATTOP_UNIONRECRUIT, true)
            end
        end

        -- 联盟未读数 
        local topPanel = global.panelMgr:getTopPanelName()
        local isUnionChat = (topPanel == "UIChatPanel") and (global.chatData:getCurChatPage() == 3)
        if curKey == 3 and (not isUnionChat) then
            chatData:setUnionUnRead(chatData:getUnionUnRead() + 1)
        end

        -- 私聊未读数
        if isPrivate then
            global.mailData:addCurPriUnReadNum()
            gevent:call(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM)
        end

        -- 联盟礼包
        if newMsg.tagSpl and newMsg.tagSpl.lKey and newMsg.tagSpl.lKey == 10 then
            local szPara = global.tools:strSplit(newMsg.tagSpl.szParam, '+')
            local giftId = tonumber(szPara[1] or "0")
            local totalNum = tonumber(szPara[3] or "0")
            local data = {
                lID = giftId,
                lAddTime = newMsg.lTime+global.luaCfg:get_config_by(1).packetTime,
                lFaceID = newMsg.lFaceID,
                lBackID = newMsg.lBackID,
                lUserID = newMsg.lFrom,
                szName  = newMsg.lType .. "|" .. totalNum .. "|" .. newMsg.szFrom,
            }
            global.chatData:addUnionGiftLog(data)
            -- print(" ----------------------------------- getServerTime -------------------- 11111>> " .. global.dataMgr:getServerTime())
        end

    end
    
    gevent:call(gameEvent.EV_ON_CHAT_NEWMESSAGE, newMsg)

end

function LogicNotify:tagBookTag(data)
    
    print(">>>>>>>function LogicNotify:tagBookTag(data)")
    -- dump(data)

    if data.lReason == 0 then

        global.occupyData:addOccupy(data)
    else

        global.occupyData:removeOccupy(data.lID)
    end    
end

function LogicNotify:tagCount( data ) -- 进入游戏，当前未读消息数
   
   dump(data, "--------> LogicNotify:tagCount ")
   -- 私聊未读
    global.userData:updatelAllyRedCount(data.tagCount)
    local isRefreshUnion = true
    if data.tagCount.lID == 1 then
        -- 联盟申请成员个数
    elseif data.tagCount.lID == 2 then
        -- 聊天私聊红点数
        global.mailData:setCurPriUnReadNum(data.tagCount.lValue)
        isRefreshUnion = false
    elseif data.tagCount.lID == 3 then
        -- 联盟外交红点数
    elseif data.tagCount.lID == 4 then
        -- 成就红点数
        global.achieveData:isFinishAchieve()
        isRefreshUnion = false
    elseif data.tagCount.lID == 5 then
        -- 联盟留言
    elseif data.tagCount.lID == 6 then
        -- 联盟动态
    elseif data.tagCount.lID == 7 then
        -- 联盟建设
    elseif data.tagCount.lID == 8 then
        -- 联盟任务
    elseif data.tagCount.lID == 9 then
        -- 个人外交
        global.unionData:setApproveCount(data.tagCount.lValue)
        gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)

    elseif data.tagCount.lID == 10 then
        -- 七日霸主
        global.ActivityData:setSevenDayNotifyRedCount(data.tagCount.lValue)
        gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE)

    elseif data.tagCount.lID ==11  then 
        global.userData:setHeadFrameRed(data.tagCount.lValue)
    end 
    if isRefreshUnion then
        gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
    end
    
    gevent:call(global.gameEvent.EV_ON_LOGIC_NOTIFY_RED_POINT)
end

-- 联盟战争相关数据通知
function LogicNotify:tagAllyUserWar( data ) 
    if data.lReason == 0 then
        global.unionData:addWar(data.lMapID)
    else
        global.unionData:removeWar(data.lMapID)
    end
end

--联盟任务
function LogicNotify:tagAllyTask( data ) 
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK)
end

--联盟数据更新通知
function LogicNotify:tagFreshAlly( data )
    if data.lType == 1 then
        --联盟建设刷新
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_BUILD_DOING)

    elseif data.lType == 2 then
        --联盟权限修改通知
        global.unionData:initPower()
    end
    global.unionApi:getRedCount(function() end,nil)
end

-- boss刷新通知
function LogicNotify:tagGate( data )

    global.bossData:notifyRefersh(data)
end

function LogicNotify:tagRecharge(data)
    -- dump(data, " >>>>>>>>>>>>>>>>>>>>> LogicNotify:tagRecharge: ")
    -- global.rechargeData:updateMonthCard(data)
    -- gevent:call(global.gameEvent.EV_ON_UI_RECHARGE_SUCCESS,data)
    
    global.loginApi:getLoginDetail(function(ret, msg)
        --刷新魔晶数量
        if ret.retcode == WCODE.OK then
            -- global.guideMgr:init()
            global.dataMgr:init(msg)
        end
    end)

    if global.sdkBridge.m_alipay_finish_call then
        global.uiMgr:removeSceneModal(109010)
        global.sdkBridge.m_alipay_finish_call()
        global.sdkBridge.m_alipay_finish_call=nil
    end

    if global.sdkBridge.m_appstore_pay_finish_call then
        global.uiMgr:removeSceneModal(109010)
        global.sdkBridge.m_appstore_pay_finish_call()
        global.sdkBridge.m_appstore_pay_finish_call=nil
    end

    if global.sdkBridge.payLingshiFinishCall then
        global.uiMgr:removeSceneModal(109010)
        global.sdkBridge.payLingshiFinishCall()
        global.sdkBridge.payLingshiFinishCall=nil
    end

    gevent:call(global.gameEvent.EV_ON_DAILY_GIFT)

end

function LogicNotify:tagTech(data)

    dump(data, " >>>>>>>>>>>>>>>>>>>>> LogicNotify:tagTech ........ : ")
    global.techData:techFinish(data.tgTech)
    gevent:call(global.gameEvent.EV_ON_UI_TECH_FLUSH)
    global.heroData:refershBuildGarrison() -- 驻防英雄建筑信息更新

end

 --活动数据刷新
function LogicNotify:tagActStatus(data)
    -- dump(data,"tagActStatus++++++++++++++活动数据刷新+++++++++++++++++++")
    global.ActivityData:notifyUpdate(data)
end

 --客户端通用更新接口
function LogicNotify:tagCommon(data)


    dump(data,"++++++++++++++LogicNotify:tagCommon(data)+++++++++++++++++++")
    
    if data and data.lType == 1 then
        -- 掠夺之后拉取最新建筑信息
        global.cityApi:updateBuildingsByIds(nil,{3,103,203,303,9,109,209,309,10,110,210,310,11,111,211,311})
    end

    if data and data.lType == 2  then
        if  data.lParam then 
            local skin =  global.luaCfg:get_world_city_image_by(data.lParam)
            if skin then 
                global.tipsMgr:showWarning("avaatr03",skin.name)  
            end 
         end 

        global.userCastleSkinData:updateInfo()
    end
    
    -- 好友状态
    if data and data.lType == 3  then
        gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
    end

    -- 联盟cd刷新
    if data and data.lType == 4  then
        global.unionData:setAllyCdTime(tonumber(data.lParam or 0))
    end

    if data and data.lType ==  6  then
        global.achieveData:addCacheID(data.lParam)
    end 

    -- 烧城之后， 建筑等级降低
    if data and data.lType ==  7  then
        
        -- 被降等级的所有建筑id
        local downbuildings = global.tools:strSplit(data.szParam, '|') 
        for _,v in pairs(downbuildings) do
            local curBuildId = tonumber(v)
            local buildData = global.cityData:getBuildingById(curBuildId)
            if buildData then
                local curBuildIv = buildData.serverData.lGrade
                global.cityData:setBuildingLvById(curBuildId, curBuildIv-1)
            end
        end
    end

    if data and data.lType == 8 then

        if global.scMgr:isWorldScene() then

            global.g_worldview.attackMgr:removeTroop(data.lParam)
        end
    end

    -- 自己占领的城池被烧毁之后
    if data and data.lType == 9 then
        global.resData:removeWorldCity({lCityID=data.lParam or 0})
        gevent:call(global.gameEvent.EV_ON_RES_WIDELIST)
    end

    -- 英雄大转盘数据刷新
    if data and data.lType == 10 then
        global.userData:updateHeroTurntable(data)
        gevent:call(global.gameEvent.EV_ON_HERO_TURNTABLE_CHANGE)
    end

    -- 聊天联盟招募置顶
    local curRecuMsg = global.chatData:getChatRecruitMsg()
    if data and data.lType == 11 and curRecuMsg then

        local tbParm = global.tools:strSplit(data.szParam, '@') 
        curRecuMsg.tagSpl.szParam = data.szParam or ""
        curRecuMsg.tagSpl.szInfo = tbParm[6] or ""
        global.chatData:setChatRecruitMsg(curRecuMsg)
        gevent:call(global.gameEvent.EV_ON_CHATTOP_UNIONRECRUIT, nil)
    end

    if data and data.lType == 12 then --有人发起联盟帮助

        if global.panelMgr:getTopPanelName() =="UIUnionHelpPanel" then 
            global.panelMgr:getTopPanel():reFresh(true)            
        end

        local st = global.tools:strSplit(data.szParam, '|')

        global.userData:updatelAllyRedCount({lID=12 , lValue =tonumber(st[1])})

        global.unionData:setInUnionRed(10, tonumber(st[1]))

        gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)


        global.unionData:setNumberBuildState(tonumber(st[1]) > 0 )
    end

    if data and data.lType ==  13  then --被人帮助

        self:cleanCD(data)

    end

   if  data and data.lType == 14 then 

        local st = global.tools:strSplit(data.szParam, '|')

        if global.panelMgr:getTopPanelName() =="UIUnionHelpPanel" then 
            global.panelMgr:getTopPanel():reFresh(true)       
        end

        global.unionData:setInUnionRed(10, tonumber(st[3]))
        global.userData:updatelAllyRedCount({lID=12 , lValue =tonumber(st[3])})
        global.unionData:setNumberBuildState(tonumber(st[3]) > 0 )

        gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
   end  

   if data and data.lType == 15 or data.lType == 16 then  --只有在界面上更新数据 

        local topPanel = {
            "UIHeroExpPanel" , 
            "UIHeroExpListPanel" ,
         }
         local toptopPanem = {
            "UISelectHeroPanel",
            "ConnectingPanel" , 
            "UISpeedPanel" , 
            "UIHeroLvUp" , 
        } 

        local st = global.tools:strSplit(data.szParam, '|')

        if table.hasval(topPanel , global.panelMgr:getTopPanelName()) then 
            global.unionApi:updateHeroSpring()
        elseif table.hasval(toptopPanem , global.panelMgr:getTopPanelName()) then 
           if table.hasval(topPanel , global.panelMgr:getIndexPanelName(2)) then 
                global.unionApi:updateHeroSpring()
           end 
        elseif data.lType == 15 then 

            st[6] = st[6] or global.dataMgr:getServerTime() + 3600

            local temp = {

                lAddTime = global.dataMgr:getServerTime(),
                lAllyID =  global.userData:getlAllyID() ,
                lEndTime = tonumber(st[6]),
                lHeroID = tonumber(st[3]),
                lID = tonumber(st[1]),
                lOwnID = tonumber(st[2]),
                lToolID = 13510,
                szName = global.userData:getUserName(),
                tagHelps = {
                    [1] = {
                        lAddTime = global.dataMgr:getServerTime(),
                        lHeroID = tonumber(st[3]),
                        lLevel = 2,
                        lSit = tonumber(st[4]),
                        lSpeed = 2160,
                        lUserID =  tonumber(st[2]) ,
                        szName = "AdhemarNeil",
                        szParams = "1",
                    },
                },
            }

            global.unionData:addSpring(temp)

        elseif data.lType == 16  then 

            global.unionData:delSpringHero(tonumber(st[4]),tonumber(st[2]))
        end 

        if data.lType == 16 then 

            global.unionData:setInUnionRed(11, tonumber(st[3]))
            global.userData:updatelAllyRedCount({lID=13 , lValue =tonumber(st[3])})
        else 

            global.unionData:setInUnionRed(11, tonumber(st[5]))
            global.userData:updatelAllyRedCount({lID=13 , lValue =tonumber(st[5])})
        end 
        
   end 

   if data.lType == 17 then
        -- print(data.lParam,'data.lParam')
        if global.scMgr:isWorldScene() then
            local pos = global.g_worldview.const:convertCityId2Pix(data.lParam)
            global.g_worldview.worldPanel:setMainCityData({lPosX = pos.x,lPosY = pos.y,lCityID = data.lParam})
        end        
   end

    -- 自己参与的战斗中，有敌军/友军新部队加入时
    if data and data.lType == 18 then

        local temp = global.tools:strSplit(data.szParam or "", '|')
        local finData = {} 
        local rwData = global.mailData:getDataByType(tonumber(temp[3] or ""), temp[1] or "") or {} --战争发生地
        local destName = rwData.name or "-"
        local isFirend = temp[2] and tonumber(temp[2]) == 0
        if isFirend then
            finData = {listId=tonumber(8 .. global.dataMgr:getServerTime()), param={id=8, args={destName}}}
        else
            finData = {listId=tonumber(7 .. global.dataMgr:getServerTime()), param={id=7, args={destName}}}
        end
        global.finishData:addFinshList(finData)
    end

    -- 七天活动红点未领取状态
    if data and data.lType == 19 then
        
        if data.lParam and data.lParam > 0 then
            local d2Data = {}
            local d2Table = global.tools:d2b(data.lParam) -- 二进制
            for i=32,0,-1 do
                table.insert(d2Data, d2Table[i])
            end
            global.ActivityData:setActivityRed(d2Data)
        end
    end

    -- 当前联盟礼包已经领完
    if data and data.lType == 20 then
        local giftId = tonumber(data.szParam or "0")
        global.chatData:removeUnionGiftLog(giftId)
    end

end


local CLEANTYPE= {
     TECH  = "TECH"  ,
     BUILD  = "BUILD" ,  
}

function LogicNotify:cleanCD(data)

    local setDuiLie = function (str)

        local st = global.tools:strSplit(str, '|')

        if global.userData:getUserId() == tonumber(st[8]) then --收到通知 如果是自己 则 清除 CD 

            local clean_type  = "" 
            local clean_time =  0

            if tonumber(st[1]) <=3 then -- 队列加速
                global.cityData:cleanBuidersCD(tonumber(st[1]), tonumber(st[2]))
                local  name = st[3]
                local tips = string.format("%s%s", name ,global.luaCfg:get_local_string(10971)) 
                -- global.tipsMgr:showWarning(tips) 
                -- 被帮助队列加速
                local data = {listId=tonumber(6 .. global.dataMgr:getServerTime()), param={id=6, args={name}}}
                global.finishData:addFinshList(data)

                clean_type  = CLEANTYPE.BUILD
                clean_time  = tonumber(st[2])
            else
                global.techData:cleanTechCD(tonumber(st[1]), tonumber(st[2]))
                local id = tonumber(st[4])
                local lv = tonumber(st[5])
                local s  = global.luaCfg:get_translate_string(10977, lv , global.luaCfg:get_science_by(id).name)
                local tips =  st[3] ..s
                -- global.tipsMgr:showWarning(tips)
                -- 被帮助科技
                local data = {listId=tonumber(5 .. global.dataMgr:getServerTime()), param={id=5, args={st[3], lv, global.luaCfg:get_science_by(id).name}}}
                global.finishData:addFinshList(data)

                clean_type  = CLEANTYPE.TECH
                clean_time  = tonumber(st[2])
            end

            gevent:call(global.gameEvent.EV_ON_UNION_CLEANCD ,clean_type ,clean_time)
        end 

        if global.panelMgr:getTopPanelName() =="UIUnionHelpPanel" then 
            global.panelMgr:getTopPanel():reFresh(true)            
        end

        if st[9] then 
            global.unionData:setInUnionRed(10, tonumber(st[9]))
            global.userData:updatelAllyRedCount({lID=12 , tonumber(st[9])})
            global.unionData:setNumberBuildState(tonumber(st[9]) > 0 )
        end 

        gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)
    end
    
    setDuiLie(data.szParam)
end 

function LogicNotify:tagFiredLog(data)
    dump(data,"++++++++++++++LogicNotify:tagFiredLog(data)+++++++++++++++++++")
    gevent:call(global.gameEvent.EV_ON_FIRECODE_UPDATE, data)
end

-- 收藏邮件
function LogicNotify:tagMailHold(data)

    dump(data, "=============== LogicNotify:tagMailHold(data) =====================: ")
    global.mailData:initMailHold(data.tagMail)
end

-- 神兽解除封印
function LogicNotify:tagGodAnimal(data)

    dump(data, "=============== LogicNotify:tagGodAnimal(data) =====================: ")

    -- 显示神兽升级页面
    if data.tagGodAnimal and data.tagGodAnimal.lType then
        local oldPetLv = global.petData:getGodAnimalLv(data.tagGodAnimal.lType)
        local curPetLv = data.tagGodAnimal.lGrade
        if curPetLv > oldPetLv then
            global.petData:updateGodAnimal(data.tagGodAnimal or {})
            global.panelMgr:openPanel("UIPetLvUp"):setData(global.petData:getGodAnimalByType(data.tagGodAnimal.lType), oldPetLv)
        end
    end

    global.petData:updateGodAnimal(data.tagGodAnimal or {})
    gevent:call(global.gameEvent.EV_ON_PET_UNLOCK)
    gevent:call(global.gameEvent.EV_ON_PET_REFERSH)

end

return LogicNotify
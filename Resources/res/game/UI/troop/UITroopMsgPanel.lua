--region UITroopMsgPanel.lua
--Author : yyt
--Date   : 2016/09/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UISoldierIconItem = require("game.UI.troop.UISoldierIconItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UITroopMsgPanel  = class("UITroopMsgPanel", function() return gdisplay.newWidget() end )

function UITroopMsgPanel:ctor()
    self:CreateUI()
end
 
function UITroopMsgPanel:CreateUI()
    local root = resMgr:createWidget("troop/troops_details_bg")
    self:initUI(root)
end

function UITroopMsgPanel:initUI(root) 
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/troops_details_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.nameTitle = self.root.Node_export.Node_details.txt.nameTitle_mlan_5_export
    self.name = self.root.Node_export.Node_details.txt.nameTitle_mlan_5_export.name_export
    self.go_src = self.root.Node_export.Node_details.txt.start_mlan_5.go_src_export
    self.start = self.root.Node_export.Node_details.txt.start_mlan_5.start_export
    self.go_target = self.root.Node_export.Node_details.txt.target_mlan_5.go_target_export
    self.target = self.root.Node_export.Node_details.txt.target_mlan_5.target_export
    self.scale = self.root.Node_export.Node_details.txt.scale_mlan_5.scale_export
    self.type = self.root.Node_export.Node_details.txt.type_mlan_5.type_export
    self.go_station = self.root.Node_export.Node_details.txt.type_mlan_5.go_station_export
    self.time = self.root.Node_export.Node_details.txt.time_mlan_5.time_export
    self.capacity = self.root.Node_export.Node_details.txt.capacity_mlan_5.capacity_export
    self.speed = self.root.Node_export.Node_details.txt.speed_mlan_5.speed_export
    self.landIndex = self.root.Node_export.Node_details.txt.land_mlan_5.landIndex_export
    self.troops_icon = self.root.Node_export.Node_details.troops_icon_export
    self.hero_icon = self.root.Node_export.Node_details.troops_icon_export.hero_icon_export
    self.heroLv = self.root.Node_export.Node_details.troops_icon_export.heroLv_export
    self.hero_name = self.root.Node_export.Node_details.troops_icon_export.hero_k.hero_name_export
    self.right = self.root.Node_export.Node_details.troops_icon_export.right_export
    self.left = self.root.Node_export.Node_details.troops_icon_export.left_export
    self.starlist = UIHeroStarList.new()
    uiMgr:configNestClass(self.starlist, self.root.Node_export.Node_details.troops_icon_export.starlist)
    self.Panel_soldier = self.root.Node_export.Node_details.troops_icon_export.Panel_soldier_export
    self.ScrollView = self.root.Node_export.Node_details.troops_icon_export.ScrollView_export
    self.supply = self.root.Node_export.Node_details.troops_icon_export.supply_mlan_5.supply_export
    self.heroAdd = self.root.Node_export.Node_details.troops_icon_export.supply_City_mlan_8.heroAdd_export
    self.at_city_bg = self.root.Node_export.Node_details.troops_icon_export.supply_City_mlan_8.at_city_bg_export
    self.city1 = self.root.Node_export.Node_details.troops_icon_export.supply_City_mlan_8.at_city_bg_export.city1_export
    self.chose_bg = self.root.Node_export.Node_details.troops_icon_export.supply_City_mlan_8.chose_bg_export
    self.city2 = self.root.Node_export.Node_details.troops_icon_export.supply_City_mlan_8.chose_bg_export.city2_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_src, function(sender, eventType) self:go_src_handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:go_target_handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_station, function(sender, eventType) self:station_click(sender, eventType) end)
--EXPORT_NODE_END
    self.starlist:setCascadeOpacityEnabled(true)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITroopMsgPanel:onEnter()
    
    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime()
    end, 1)

    self:checkTime()
end

function UITroopMsgPanel:onExit()
    
    gscheduler.unscheduleGlobal(self.scheduleListenerId)
end


-- [LUA-print] dump from: [string "res/game/UI/troop/UITroopMsgPanel.lua"]:97: in function 'setData'
-- [LUA-print] - "-------mmmmmmmmmmm" = {
-- [LUA-print] -     "lAllyName"        = "xxx"
-- [LUA-print] -     "lAttackEndTime"   = 1525683147
-- [LUA-print] -     "lAttackStartTime" = 1525682281
-- [LUA-print] -     "lAttackType"      = 11
-- [LUA-print] -     "lAvator"          = 1
-- [LUA-print] -     "lCityID"          = 10140900
-- [LUA-print] -     "lCityUniqueId" = {
-- [LUA-print] -         1 = 30020780
-- [LUA-print] -         2 = 10140900
-- [LUA-print] -     }
-- [LUA-print] -     "lCostRes"         = 0
-- [LUA-print] -     "lDstType"         = 1
-- [LUA-print] -     "lHeroPower"       = 0
-- [LUA-print] -     "lID"              = 64
-- [LUA-print] -     "lKind"            = 8
-- [LUA-print] -     "lPurpose"         = 11
-- [LUA-print] -     "lSpeed"           = 700
-- [LUA-print] -     "lSrcType"         = 1
-- [LUA-print] -     "lState"           = 1
-- [LUA-print] -     "lTarget"          = 30020780
-- [LUA-print] -     "lTargetAvator"    = 2
-- [LUA-print] -     "lUserID"          = 8000038
-- [LUA-print] -     "lWildKind"        = 1
-- [LUA-print] -     "szName"           = ""
-- [LUA-print] -     "szSrcName"        = ""
-- [LUA-print] -     "szTargetName"     = "8000014"
-- [LUA-print] -     "szUserName"       = "8000038"
-- [LUA-print] - }
function UITroopMsgPanel:setData( data, flag,  lHeroStar)
  
    if data == nil then return end
    self.data = data
    dump(data,"-------mmmmmmmmmmm")

    if data.tgWarrior then
        -- 进入加载其他种族兵种图片
        self:preRoadAllRace(data.tgWarrior)
        self:initSoldierIconList(data.tgWarrior, flag)
    end
    local heroId = 0
    self.heroAdd:setString("-")
    if global.troopData:isShoper(data) then
        if self.data.szSrcName == "" then
            self.data.szSrcName = self.data.szUserName
        end
        if self.data.szTargetName == "" then
            self.data.szTargetName = self.data.szUserName
        end

        self.isVisCapacity = false
        if flag == 1 then
            self:checkTroopWorld() 
        else
            self:checkTroopState()
        end
        self.troops_icon:setVisible(false)
        self.scale:getParent():setVisible(false)
        self.capacity:getParent():setVisible(false)
    else
        if data.lHeroID and data.lHeroID[1] ~= 0 then 

            local heroData = global.heroData:getHeroPropertyById(data.lHeroID[1])
            -- self.hero_icon:loadTexture(heroData.nameIcon, ccui.TextureResType.plistType)
            global.panelMgr:setTextureFor(self.hero_icon,heroData.nameIcon)
            self.hero_name:setString(heroData.name)
            self.heroAdd:setString(data.lHeroPower + global.troopData:getTroopsScaleByData(self.data.tgWarrior))
            -- self.hero_quality:setVisible(heroData.quality == 2)
            self.starlist:setVisible(true)
            self.left:setVisible(true)
            self.right:setVisible(true)
            self.starlist:setData(data.lHeroID[1],  lHeroStar)
            global.funcGame:dealHeroRect(self,heroData)
            self.heroLv:setString("")
            heroId = data.lHeroID[1]
        else
            self.hero_icon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
            self.hero_name:setString("")
            self.starlist:setVisible(false)
            self.left:setVisible(false)
            self.right:setVisible(false)
            -- self.hero_quality:setVisible(false)
            self.heroLv:setString("")
            self.heroAdd:setString(global.troopData:getTroopsScaleByData(self.data.tgWarrior))
        end 
        self.isVisCapacity = true
        if flag == 1 then
            self:checkTroopWorld() 
        else
            self:checkTroopState()
        end
        
        -- buff(部队速度、粮耗、承载)
        self.sbuffs  = {speed=0, supply=0, carry=0}
        self.hbuffs  = {speed=0, supply=0, carry=0}
        self:soldierBuff()
        self:heroBuff(heroId)
        self:refershBuff()
        self.troops_icon:setVisible(true)
        self.scale:getParent():setVisible(true)
        self.capacity:getParent():setVisible(true)
    end


    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.name:getParent(),self.name)
    global.tools:adjustNodePosForFather(self.start:getParent(),self.start)
    global.tools:adjustNodePosForFather(self.target:getParent(),self.target)
    global.tools:adjustNodePosForFather(self.scale:getParent(),self.scale)
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
    global.tools:adjustNodePosForFather(self.speed:getParent(),self.speed)
    global.tools:adjustNodePosForFather(self.landIndex:getParent(),self.landIndex)
    global.tools:adjustNodePosForFather(self.capacity:getParent(),self.capacity)
    global.tools:adjustNodePosForFather(self.supply:getParent(),self.supply)
    global.tools:adjustNodePosForFather(self.heroAdd:getParent(),self.heroAdd)

end

-- 部队buff
function UITroopMsgPanel:soldierBuff()

    global.gmApi:effectBuffer({{lType = 7, lBind = 0}},function(msg)

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

        self.sbuffs  = {speed=0, supply=0, carry=0}
        local buffs = buffData.tgEffect or {} 
        for _,v in pairs(buffs) do
            if v.lEffectID == 3064 then -- 士兵粮耗减少
                self.sbuffs.supply = self.sbuffs.supply+v.lVal/100
            elseif v.lEffectID == 3009 then -- 行军速度加成
                self.sbuffs.speed = self.sbuffs.speed+v.lVal/100
            elseif v.lEffectID == 3010 then -- 部队负重加成
                self.sbuffs.carry =  self.sbuffs.carry+v.lVal/100
            end
        end
        if self.refershBuff then 
            self:refershBuff()
        end 
    end)
end

-- 英雄buff
function UITroopMsgPanel:heroBuff(heroId)

    if heroId == 0 then
        return
    end
    
    global.gmApi:effectBuffer({{lType =12, lBind = heroId}},function(msg)

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

        self.hbuffs  = {speed=0, supply=0, carry=0}
        local buffs = buffData.tgEffect or {} 
        for _,v in pairs(buffs) do
            if v.lEffectID == 3064 then -- 士兵粮耗减少
                self.hbuffs.supply = self.hbuffs.supply + v.lVal/100
            elseif v.lEffectID == 3009 then -- 行军速度加成
                self.hbuffs.speed = self.hbuffs.speed + v.lVal/100
            elseif v.lEffectID == 3010 then -- 部队负重加成
                self.hbuffs.carry = self.hbuffs.carry + v.lVal/100
            end
        end
        if self.refershBuff then 
            self:refershBuff()
        end 
    end)

end

function UITroopMsgPanel:refershBuff()
    -- body 
    local speedVal = self.sbuffs.speed   + self.hbuffs.speed
    local supplyVal = self.sbuffs.supply + self.hbuffs.supply
    local carryVal = self.sbuffs.carry   + self.hbuffs.carry

    local curSpeed = global.troopData:getTroopsSpeedWithClass(self.data.lID) or 0
    local curSupply= self.data.lCostRes or 0
    local curCapacity = global.troopData:getTroopsClassWeightByData(self.data.tgWarrior) or 0
        

    if self.isVisCapacity  then
        if self.data.lCollectCount then
            self.capacity:setString(self.data.lCollectCount .. '/' .. math.ceil(curCapacity*(1+carryVal)))
        else
            self.capacity:setString(math.ceil(curCapacity*(1+carryVal)))            
        end        
        self.speed:setString(math.ceil(curSpeed*(1+speedVal)))
    else
        self.capacity:setString("-")
        self.speed:setString("-")
    end
    
    if self.data.lCostRes then
        local cosume = curSupply*(1-supplyVal)
        self.supply:setString(math.ceil(cosume) .. luaCfg:get_local_string(10076))
    else
        self.supply:setString("-")
    end
end

function UITroopMsgPanel:checkTroopWorld()

    self.go_station:setVisible(false)
    
    --lState: 1攻城、2攻击、3侦查、4驻守、6掠夺
    local actionStrId = 0
    local lType = self.data.lAttackType

    if lType == 1 then
        actionStrId = 10125
    elseif lType == 2 then
        actionStrId = 10124
    elseif lType == 3 then
        actionStrId = 10684 -- 侦查
    elseif lType == 4 then
        actionStrId = 10096 
    elseif lType == 6 then
        actionStrId = 10126
    elseif lType == 11 then --商队运输
        actionStrId = 11158
    end
    if self.data.lState and self.data.lState == 2 then
        actionStrId = 10121
    end

    local actionStr = luaCfg:get_local_string(actionStrId)
    self.type:setString(actionStr)

    self:refershTimeAndTarget()
end

function UITroopMsgPanel:checkTroopState()

    self.go_station:setVisible(false)

    --lState: 10驻守、6待命、11战斗、1行军、2返回
    local actionStrId = 0
    local lState = self.data.lState
   
    if lState == 10 then
        actionStrId = 10098
    elseif lState == 6 then
        actionStrId = 10099
    elseif lState == 11 then
        actionStrId = 10119
    elseif lState == 5 then
        actionStrId = 10096
        self.go_station:setVisible(true)
    elseif lState == 1 then
        actionStrId = 10120
    elseif lState == 2 then
        actionStrId = 10121
    end

    local actionStr = luaCfg:get_local_string(actionStrId)
    self.type:setString(actionStr)

    self:refershTimeAndTarget()
end

-- optional int32      lDstType    = 23;   //0:村庄 1：城池  2：资源野地 5：怪物 6：奇迹点  9：联盟营地
-- optional int32      lSrcType    = 26;   //0:村庄 1：城池  2：资源野地 5：怪物 6：奇迹点  9：联盟营地

function UITroopMsgPanel:refershTimeAndTarget()

    local goStationStr = "-"
    local endStationStr = "-"
    self.isHavaTime = false
    
    local lState = self.data.lState
    if lState == 1 then
        goStationStr = self.data.szSrcName
        endStationStr = self.data.szTargetName
        self.isHavaTime = true
    elseif lState == 2 then
        goStationStr = self.data.szSrcName
        endStationStr = self.data.szTargetName
        self.isHavaTime = true
    end
    self.time:setString("-")

    self.start:setString(global.funcGame:translateDst(goStationStr,self.data.lSrcType,self.data.lCityID))
    self.target:setString(global.funcGame:translateDst(endStationStr,self.data.lDstType,self.data.lTarget))

    local id,name = global.worldApi:decodeLandId(self.data.lTarget)
    self.landIndex:setString(name)

    if goStationStr == "-" or endStationStr == "-" then
        self.go_src:setVisible(false)
        self.go_target:setVisible(false)
    else
        self.go_src:setVisible(true)
        self.go_target:setVisible(true)
    end

    -- 部队信息状态显示
    local userId = global.userData:getUserId()
    if userId == self.data.lUserID then
        self:checkTroopOwner(0)
    else

        if self.data.lAvator == 1 or self.data.lAvator == 2 then
            self:checkTroopOwner(0)
        else
            self:checkTroopOwner(1)
        end
    end

    self:checkTime()
end

function UITroopMsgPanel:checkTroopOwner(state)
    
    -- state: 0 自己、同盟的部队   1 攻打自己、同盟的部队

    if self.data.tgWarrior then
        self.scale:setString(global.troopData:getTroopsScaleByData(self.data.tgWarrior))
        self.capacity:setString(global.troopData:getTroopsWeightByData(self.data.tgWarrior))
        -- self.supply:setString(self.data.lCostRes)
    end

    local ownerName = ""
    local ownerId = 0
    if state == 0 then
        ownerId = 10183
        if self.data.szName and self.data.szName ~= "" then
            ownerName = self.data.szName
        else
            ownerName = luaCfg:get_local_string(10140)
        end

        self.troops_icon:setVisible(true)
    else
        ownerId = 10182
        ownerName = self.data.szUserName
        self.scale:setString("-")
        self.capacity:setString("-")
        self.isVisCapacity = false
        -- self.supply:setString("-")
        self.troops_icon:setVisible(false)
    end

    self.nameTitle:setString(luaCfg:get_local_string(ownerId))
    self.name:setString(ownerName)

    self.supply:setString(self.data.lCostRes .. luaCfg:get_local_string(10076))
    --  if global.g_worldview then
    --     local worldPanel = global.g_worldview.worldPanel
    --     local myCityId = worldPanel.mainId
    --     if self.data.lAttackType ~= 4 then
    --         if self.data.lTarget == myCityId then
    --             self.scale:setString("-") 
    --         end
    --         if self.data.lTarget ~= myCityId and self.data.lTargetAvator == 2 then
    --             self.scale:setString("-") 
    --         end 
    --     end
    -- end


end

function UITroopMsgPanel:checkTime()
    
    if not self.isHavaTime then return end

    local cutTime = self.data.lAttackEndTime - global.dataMgr:getServerTime()

    if cutTime < 0 then cutTime = 0 end

    local str = global.troopData:timeStringFormat(cutTime)
    self.time:setString(str)
end

function UITroopMsgPanel:initSoldierIconList( soldierData, flag )
    
    self.ScrollView:removeAllChildren()

    local sW = self.Panel_soldier:getContentSize().width + 5
    local i = 0
    for _,v in pairs(soldierData) do
        if v.lCount > 0 then
            local item = UISoldierIconItem.new()
            item:setCascadeOpacityEnabled(true)
            item:setAnchorPoint(cc.p(0, 0))
            item:setPosition(cc.p(sW*i, 0))
            item:setData(v, flag)
            self.ScrollView:addChild(item)
            i = i + 1
        end
    end

    local contentSize = self.ScrollView:getContentSize().width
    
    local containerSize = i*sW
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView:setInnerContainerSize(cc.size(containerSize, self.ScrollView:getContentSize().height))

    self.ScrollView:jumpToTop()
end

function UITroopMsgPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UITroopMsgPanel")
    -- 退出删除资源
    self:removeRoadRace()
end

function UITroopMsgPanel:station_click(sender, eventType)
    self:gpsCIty()
end

function UITroopMsgPanel:gpsCIty()
    -- global.worldApi:getCityPos(self.data.lCityID,function(msg)
    
    --     local g_worldview = global.g_worldview   
    --     if g_worldview then
    --         local worldPanel = g_worldview.worldPanel
    --         if g_worldview.worldPanel.m_scrollView then
    --             g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-msg.lPosx,-msg.lPosy))
    --             g_worldview.worldPanel:cancelGpsSoldier()
    --             -- worldPanel:chooseCityByAttackTroopId(id)
    --             worldPanel:chooseCityById(self.data.lCityID)
    --             self:exit_call()

    --             local troopPanel = global.panelMgr:getPanel("UITroopPanel")
    --             if troopPanel then
    --                 global.panelMgr:closePanel("UITroopPanel") 
    --             end
    --         end
    --     else

    --         global.funcGame:gpsWorldCity(self.data.lCityID)
    --     end

    -- end)

    self:exit_call()
    global.panelMgr:closePanel("UITroopPanel")
    if self.data and self.data.lCityID then
        global.funcGame:gpsWorldCity(self.data.lCityID)
    end
end

function UITroopMsgPanel:go_src_handler(sender, eventType)
    self:gpsCIty()
end

function UITroopMsgPanel:go_target_handler(sender, eventType)
    -- global.worldApi:getCityPos(self.data.lTarget,function(msg)
        
    --     local g_worldview = global.g_worldview   
    --     if g_worldview then
    --         local worldPanel = g_worldview.worldPanel
    --         if  g_worldview.worldPanel.m_scrollView then
    --             g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-msg.lPosx,-msg.lPosy))
    --             g_worldview.worldPanel:cancelGpsSoldier()
    --             worldPanel:chooseCityById(self.data.lTarget)
    --             self:exit_call()

    --             local troopPanel = global.panelMgr:getPanel("UITroopPanel")
    --             if troopPanel then
    --                 global.panelMgr:closePanel("UITroopPanel") 
    --             end
    --         end

    --     else

    --         global.funcGame:gpsWorldCity(self.data.lCityID)
    --     end
    -- end)

    self:exit_call()
    global.panelMgr:closePanel("UITroopPanel")
    global.funcGame:gpsWorldCity(self.data.lTarget)
end

function UITroopMsgPanel:preRoadAllRace(tgWarrior)

    local raceIds = {}

    local checkRaceId = function (id)
        for _,v in pairs(raceIds) do
            if v == id then
                return true
            end
        end
        return false
    end
 
    for _,v in pairs(tgWarrior) do
        local raceId = luaCfg:get_soldier_property_by(v.lID).race
        if not checkRaceId(raceId) then
            table.insert(raceIds, raceId)
        end
    end

    for _,id in ipairs(raceIds) do
        gdisplay.loadSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
    end

    self.raceIds = raceIds
end

function UITroopMsgPanel:removeRoadRace()
    if true then return end
    local raceId = global.userData:getRace()
    for _,id in pairs(self.raceIds) do
        if id ~= raceId and id~=0 then
            gdisplay.removeSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
        end
    end
end


--CALLBACKS_FUNCS_END

return UITroopMsgPanel

--endregion

--region UITroopDetailPanel.lua
--Author : yyt
--Date   : 2016/09/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UISoldierItem = require("game.UI.troop.UISoldierItem")
local UISelectItem = require("game.UI.troop.UISelectItem")
local UIDownList = require("game.UI.commonUI.unit.UIDownList")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDownList = require("game.UI.commonUI.unit.UIDownList")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UITroopDetailPanel  = class("UITroopDetailPanel", function() return gdisplay.newWidget() end )

function UITroopDetailPanel:ctor()
    self:CreateUI()
end

function UITroopDetailPanel:CreateUI()
    local root = resMgr:createWidget("troop/troops_new_bg")
    self:initUI(root)
end

function UITroopDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/troops_new_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.troops_title = self.root.common_title.troops_title_fnt_mlan_15_export
    self.text_add = self.root.troops_show_bg.btn_hero.pic_add.text_add_mlan_5_export
    self.hero_icon = self.root.troops_show_bg.btn_hero.hero_panel.Node_hero.hero_icon_export
    self.soldier_layout = self.root.troops_show_bg.soldier_layout_export
    self.ScrollView_Soilder = self.root.troops_show_bg.ScrollView_Soilder_export
    self.troops_name = self.root.troops_show_bg.Node_1.troops_name_mlan_5_export
    self.TextField_name = self.root.troops_show_bg.Node_1.troops_name_mlan_5_export.TextField_name_export
    self.TextField_name = UIInputBox.new()
    uiMgr:configNestClass(self.TextField_name, self.root.troops_show_bg.Node_1.troops_name_mlan_5_export.TextField_name_export)
    self.btn_edit = self.root.troops_show_bg.Node_1.btn_edit_export
    self.troops_scale = self.root.troops_show_bg.Node_1.troops_scale_mlan_5.troops_scale_export
    self.troops_resource = self.root.troops_show_bg.Node_1.troops_resource_mlan_4.troops_resource_export
    self.troops_supply_city = self.root.troops_show_bg.Node_1.troops_supply_city_export
    self.troops_supply_add_city = self.root.troops_show_bg.Node_1.troops_supply_city_export.troops_supply_add_city_export
    self.ml_troops_supply_city = self.root.troops_show_bg.Node_1.troops_supply_city_export.ml_troops_supply_city_mlan_6_export
    self.troops_troops_city = self.root.troops_show_bg.Node_1.troops_troops_ciyt_mlan_10.troops_troops_city_export
    self.city1 = self.root.troops_show_bg.Node_1.troops_troops_ciyt_mlan_10.at_city_bg.city1_export
    self.chose_bg = self.root.troops_show_bg.Node_1.troops_troops_ciyt_mlan_10.chose_bg_export
    self.city2 = self.root.troops_show_bg.Node_1.troops_troops_ciyt_mlan_10.chose_bg_export.city2_export
    self.troops_type = self.root.troops_show_bg.Node_1.troops_type_mlan_5.troops_type_export
    self.troops_hero = self.root.troops_show_bg.Node_1.troops_hero_mlan_5.troops_hero_export
    self.SoliderItem_layout = self.root.SoliderItem_layout_export
    self.ScroList = self.root.ScroList_export
    self.Top_layout = self.root.Top_layout_export
    self.city_downList = self.root.Node_troops_source.city_downList_export
    self.city_downList = UIDownList.new()
    uiMgr:configNestClass(self.city_downList, self.root.Node_troops_source.city_downList_export)
    self.troopsBottom = self.root.troopsBottom_export
    self.Button_cancel = self.root.troopsBottom_export.Button_cancel_export
    self.Button_confirm = self.root.troopsBottom_export.Button_confirm_export
    self.Button_Auto = self.root.troopsBottom_export.Button_Auto_export
    self.guide = self.root.guide_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.troops_show_bg.btn_hero, function(sender, eventType) self:select_hero(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_edit, function(sender, eventType) self:nameEditHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.troops_show_bg.Node_1.info_btn_node.info_btn, function(sender, eventType) self:onInfoClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_cancel, function(sender, eventType) self:cancel_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_confirm, function(sender, eventType) self:confirm_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_Auto, function(sender, eventType) self:autoConfirm(sender, eventType) end)
--EXPORT_NODE_END

    self.btn_edit:setSwallowTouches(false)
    self.titleNode = self.root.common_title

    self.troopsId = 0
    self.heroId = 0
    self.id = 0

    self.troopPanel = global.panelMgr:getPanel("UITroopPanel")
    self.troops_name_bg = self.troops_name.troops_name_bg
    -- self.TextField_name:addEventListener(handler(self, self.nameEdit_click))

    self.text_add:getVirtualRenderer():setLineBreakWithoutSpace(false)
    self.text_add:getVirtualRenderer():setOverflow(2)
    self.titleNode.esc:setVisible(false)

    global.m_troopPanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITroopDetailPanel:onEnter()
   
    self.ScroList:jumpToTop()
    self.guide:setVisible(false)
    self.TextField_name:addEventListener(handler(self, self.nameEditCall))

    self.curBase = {speed=0, supply=0, carry=0}
    self.sbuffs  = {speed=0, supply=0, carry=0}
    self.hbuffs  = {speed=0, supply=0, carry=0}

    self:addEventListener(global.gameEvent.EV_ON_HEROHEADLIST, function ()
        self:refershChief()
    end)

    self.noEffect = true 
end

function UITroopDetailPanel:sortSoldierItem(list)

    if not list then return end
    if table.nums(list) == 0 then return end

    table.sort(list, function(item1, item2) 
        if item1.data.isChief == item2.data.isChief then
            if item1.data.isHeroType == item2.data.isHeroType then
                return item1.data.lID < item2.data.lID
            else
                return item1.data.isHeroType > item2.data.isHeroType
            end
        else
            return item1.data.isChief > item2.data.isChief 
        end
    end)

end

-- 刷新统帅
function UITroopDetailPanel:refershChief()

    if not self.itemHeadList then return end
    local heroMsg = self:getHeroData()
    for _,v in pairs(self.itemHeadList) do
        v.data.isChief = self:isChief(v.data.lID)
        v.data.isHeroType = self:isHeroType(v.data.lID)
        if not heroMsg then
            v.chief:setVisible(false)
        end
    end
    for _,v in pairs(self.itemSoldier) do
        v.data.isChief = self:isChief(v.data.lID)
        v.data.isHeroType = self:isHeroType(v.data.lID)
        if not heroMsg then
            v:setChief(false)
        end
    end
    if not heroMsg then 
        return 
    end

    -- 顶部士兵
    self:sortSoldierItem(self.itemHeadList)
    
    local i = 0
    local sW = self.soldier_layout:getContentSize().width
    for _,v in ipairs(self.itemHeadList) do

        v:setTag((1070+v.data.lID)*10)
        v.chief:setVisible(self:isChief(v.data.lID) == 1)
        if v.curNumber > 0 then
            local taskX = 49.50 + sW*i
            v.soldier_bg:setPosition(taskX, v.soldier_bg:getPositionY())
            v.soldier_bg:setTag(sW*i)
            i = i + 1
        end
    end

    -- 底部士兵
    if not self.itemSoldier then return end

    -- 引导中防御步兵置最前面 特殊处理
    -- if global.guideMgr:isPlaying() and global.userData:getGuideStep() == 801 then
    --     if #self.itemSoldier > 0 then
    --         table.sort(self.itemSoldier, function(s1, s2) return s1.index < s2.index end)
    --     end
    -- else
        self:sortSoldierItem(self.itemSoldier)
    --end

    local sW1 = self.SoliderItem_layout:getContentSize().height
    local containerSize = self.ScroList:getInnerContainerSize().height
    local pY =  containerSize - sW1/2
    
    
    local i = 0
    for _,v in ipairs(self.itemSoldier) do

        v:setTag(1070+v.data.lID)
        v:setPosition(cc.p(gdisplay.width/2, pY - (sW1+3)*i))
        v:setChief(self:isChief(v.data.lID) == 1)
        i = i + 1
    end

end

function UITroopDetailPanel:setData( data )

    -- dump(data,">>>>detail data") 

    self.root.troops_show_bg.btn_hero.Image_14:setVisible(true)
    self.data = data
    self.detailData = {}
    self.troopsId = data.lID

    -- 进入加载其他种族兵种图片
    self.raceIds = {}

    self.isHavSoldier = true
    if data.tgWarrior and table.nums(data.tgWarrior) > 0 then
        self:preRoadAllRace(data.tgWarrior)
    end

    self.TextField_name:setString(data.szName)

    -- 是否是新建部队
    local isNotBuildNew = data.lHeroID and data.lHeroID[1] and data.lHeroID[1] ~= 0
    self.isNotBuildNew = isNotBuildNew
    if isNotBuildNew then
        self.heroMsg = global.heroData:getHeroDataById(data.lHeroID[1])
        self.id = data.lHeroID[1]
    else
        self.heroMsg = self:defaultSelectHero() 
        self.id = self.heroMsg ~= nil and self.heroMsg.heroId or 0
    end

    self:setHeroIcon(self.heroMsg, isNotBuildNew)
    self.troops_troops_city:setString(data.lTarget)

    local UIscaleNum =self:getTroopsScaleById(data.lID)
    local scaleNum =global.troopData:getTroopsScaleById(data.lID)
    self.troops_size = scaleNum
    self.troops_power = self.troops_size
    self.troops_supply_city:setString(UIscaleNum)

    local isOverMaxSize = false
    if self.heroMsg then
        local commanderScaleMax = self.heroMsg.serverData.lbase[4] + self.heroMsg.serverData.lextra[4]
        self.troops_scale:setString(scaleNum .. "/" .. commanderScaleMax)
        isOverMaxSize = self.troops_size > commanderScaleMax
    else
        self.troops_scale:setString("-")
        self.root.troops_show_bg.btn_hero.Image_14:setVisible(false)
    end
    
    local soldierTgWarrior = self:checkTgwarrior(data.tgWarrior)
    self:initSoldierList(soldierTgWarrior)
    self:initHeadList(soldierTgWarrior)
    
    self:flushCommanderValue(self.heroMsg) 
    self.curBase.speed  = global.troopData:getTroopsSpeedWithClass(data.lID) or 0
    self.curBase.supply = data.lCostRes or 0
    self.curBase.carry  = global.troopData:getTroopsClassWeightByData(data.tgWarrior) or 0


    -- buff(部队速度、粮耗、承载)
    self:soldierBuff()
    self:heroBuff(self.id)
    self:refershBuff()

    global.tools:adjustNodePosForFather(self.troops_scale:getParent(),self.troops_scale)
    global.tools:adjustNodePosForFather(self.troops_type:getParent(),self.troops_type)
    global.tools:adjustNodePosForFather(self.troops_resource:getParent(),self.troops_resource)
    global.tools:adjustNodePosForFather(self.troops_hero:getParent(),self.troops_hero)


    -- 没有英雄，则士兵数量都处于0位置
    local iscondit1= self.id ~= 0 and (not isNotBuildNew) 
    local iscondit2 = isOverMaxSize -- 线上超过规模限制兼容处理
    if iscondit1 or iscondit2 then
        self:defaultSelectSoldier()
        self.noEffect = false 
    end

    -- 编辑部队
    self.Button_cancel:setPositionX(gdisplay.width/4)
    self.Button_confirm:setPositionX(gdisplay.width/4*3)
    self.Button_Auto:setVisible(false)
    if isNotBuildNew and self.isHavSoldier then
        self.Button_Auto:setVisible(true)
        self.Button_cancel:setPositionX(gdisplay.width/4-40)
        self.Button_confirm:setPositionX(gdisplay.width/4*3+40)
    end

end

-- 新建部队，默认选中英雄列表第一个英雄
function UITroopDetailPanel:defaultSelectHero()

    local  recruitHero = global.heroData:getActiveHero(0)
    if table.nums(recruitHero) > 0 then
        return recruitHero[1]
    end
    return nil
end

-- 新建部队/编辑部队更换英雄，默认选取满规模士兵数量(加成士兵优先)
function UITroopDetailPanel:defaultSelectSoldier()
    -- body
    print(self.noEffect ,"self.noEffect -")

    if not self.itemSoldier then return end
    if not self.heroMsg then return end

    local tgWarrior = clone(self:checkTgwarrior(self.data.tgWarrior))

    local refershTgWarrior = function (lID, lCount)
        for i,v in ipairs(tgWarrior) do
            if v.lID == lID then
                v.lCount = lCount
                break
            end
        end
    end

    -- 选取数量重置
    for _,v in ipairs(self.itemSoldier) do
        v:setHeadListData(self.noEffect)
        v.sliderControl:changeCount(0)
        refershTgWarrior(v.data.lID, 0)
    end

    -- 规模上限
    local commanderScaleMax = self.heroMsg.serverData.lbase[4] + self.heroMsg.serverData.lextra[4]
    for i,v in ipairs(self.itemSoldier) do

        local perScale = luaCfg:get_soldier_property_by(v.data.lID).perPop
        local maxCount = math.floor(commanderScaleMax/perScale)
        local curMaxCount = v:getCurMaxCount()

        print(" --> curMaxCount: "..curMaxCount)
        print(" maxCount: "..maxCount)
        print("commanderScaleMax: "..commanderScaleMax)

        v:setHeadListData(self.noEffect)

        if curMaxCount < maxCount then
            v.sliderControl:changeCount(curMaxCount)
            v.curInitCount = curMaxCount
            commanderScaleMax = commanderScaleMax - curMaxCount*perScale
            refershTgWarrior(v.data.lID, curMaxCount)
        else
            v.sliderControl:changeCount(maxCount)
            v.curInitCount = maxCount
            refershTgWarrior(v.data.lID, maxCount)
            if commanderScaleMax == 0 or i == (#self.itemSoldier) then
                break
            else
                commanderScaleMax = commanderScaleMax - maxCount*perScale
            end
        end
    end

    self.curBase.carry  = global.troopData:getTroopsClassWeightByData(tgWarrior) or 0
    self:refershBuff()
end

-- 检测当前部队是否满编
-- function UITroopDetailPanel:checkCondition()

--     local curSelctCount = 0
--     for _,v in pairs(self.itemSoldier) do        
--         curSelctCount = curSelctCount + v.perPop*v.sliderControl:getCurCount()
--     end
--     local commanderScaleMax = self.heroMsg.serverData.lbase[4] + self.heroMsg.serverData.lextra[4]
--     return curSelctCount <= commanderScaleMax
-- end

function UITroopDetailPanel:nameEditCall(eventType)
   
    if eventType == "return" then
        self.lastName = self.TextField_name:getString()
        self:checkNameStr(self.lastName)
    end
end

function UITroopDetailPanel:checkNameStr(str)

    global.unionApi:checkNameStr(str, function(msg)
        self.lastName = msg.szName
        self.TextField_name:setString(self.lastName)
    end)
end

function UITroopDetailPanel:preRoadAllRace(tgWarrior)

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

function UITroopDetailPanel:removeRoadRace()
    if true then return end
    local raceId = global.userData:getRace()
    for _,id in pairs(self.raceIds) do
        if id ~= raceId and id ~= 0 then
            gdisplay.removeSpriteFrames(string.format("race%s.plist",id),string.format("race%s.png",id))
        end
    end
end

-- 部队buff
function UITroopDetailPanel:soldierBuff()

    global.gmApi:effectBuffer({{lType = 7, lBind = 0}},function(msg)

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

        self.sbuffs = {speed=0, supply=0, carry=0}
        
        local buffs = buffData.tgEffect or {} 
        for _,v in pairs(buffs) do
            if v.lEffectID == 3064 then -- 士兵粮耗减少
                self.sbuffs.supply = self.sbuffs.supply + v.lVal/100
            elseif v.lEffectID == 3009 then -- 行军速度加成
                self.sbuffs.speed = self.sbuffs.speed + v.lVal/100
            elseif v.lEffectID == 3010 then -- 部队负重加成
                self.sbuffs.carry = self.sbuffs.carry + v.lVal/100
            end
        end
        if self.refershBuff then 
            self:refershBuff()
        end 
    end)
end

-- 英雄buff
function UITroopDetailPanel:heroBuff(heroId)

    self.hbuffs = {speed=0, supply=0, carry=0}
    if heroId == 0 then
        self:refershBuff()
        return
    end
    
    global.gmApi:effectBuffer({{lType =12, lBind = heroId}},function(msg)

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

        self.hbuffs = {speed=0, supply=0, carry=0}
        
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
        if self.refershBuff  then 
            self:refershBuff()
        end 
    end)

end

function UITroopDetailPanel:refershBuff()
    -- body 
    local speedVal = self.sbuffs.speed   + self.hbuffs.speed
    local supplyVal = self.sbuffs.supply + self.hbuffs.supply
    local carryVal = self.sbuffs.carry   + self.hbuffs.carry

    self.detailData.troops_speed = string.format(luaCfg:get_local_string(10025),  math.ceil(self.curBase.speed*(1+speedVal)))
    self.detailData.troops_carry = math.ceil(self.curBase.carry*(1+carryVal))
    self.troops_resource:setString(math.ceil(self.curBase.carry*(1+carryVal)))
    if self.data.lCostRes then
        local cosume = self.curBase.supply*(1-supplyVal)
        self.detailData.troops_supply = math.ceil(cosume) .. luaCfg:get_local_string(10076)
    else
        self.detailData.troops_supply = "-"
    end

    -- 引导中防御步兵置最前面 特殊处理
    -- if self.curSold and global.guideMgr:isPlaying() and global.userData:getGuideStep() == 801 then
    --     local count = self.curSold.lCount
    --     local soldierData = luaCfg:get_soldier_property_by(self.curSold.lID)
    --     local scaleNum =  count*soldierData.perPop
    --     local restNum = count*soldierData.perRes
    --     local powerNum = count*soldierData.combat
    --     self.troops_size = scaleNum
    --     self.detailData.troops_supply = restNum .. luaCfg:get_local_string(10076)

    --     local commanderScaleMax = self.heroMsg.serverData.lbase[4] + self.heroMsg.serverData.lextra[4]
    --     self.troops_scale:setString(self.troops_size .. "/" .. commanderScaleMax)
    -- end

end

function UITroopDetailPanel:flushCommanderValue(heroData)

    if not self.itemSoldier then return end
    heroData = heroData or self.heroMsg

    if heroData == nil then
        self.troops_hero:setString("-")
        return
    end

    local allCount = 0
    local commanderType = heroData.commanderType
    local attType = heroData.secType
    local commander = heroData.serverData.lbase[4] + heroData.serverData.lextra[4]
    local allScale = 0

    for _,v in pairs(self.itemSoldier) do
        if not tolua.isnull(v) then
            local id = v.soldierID
            local count = tonumber(v.cur:getString()) or 0         
            local soldierData = luaCfg:get_soldier_property_by(id)
            if (soldierData.type == commanderType and (soldierData.skill == attType or attType == 0)) or commanderType == 0 then
                allScale = allScale + count * soldierData.perPop
            end     
        end   
    end

    allCount = allScale
    if allScale > commander then allCount = commander end
    
    -- if heroData.serverData.lCurHP <= 0 then
    --     self.troops_supply_add_city:setVisible(false)
    --     self.troops_hero:setString("-")
    -- else        

        local combat = ((allCount/10) * ((heroData.serverData.lbase[1] + heroData.serverData.lbase[2] + heroData.serverData.lextra[1] + heroData.serverData.lextra[2])/ 50))  ---allScale + math.floor(heroData.serverData.lPower * (allCount / commander))
        combat = math.ceil(combat)
        self.troops_supply_add_city:setString("+" .. combat)
        self.troops_power = self.troops_size+combat
        self.troops_supply_add_city:setVisible(combat ~= 0)
        self.troops_hero:setString(allCount .. "/" .. commander)
    -- end    
    global.tools:adjustNodePosForFather(self.troops_supply_add_city:getParent(),self.troops_supply_add_city)
end



function UITroopDetailPanel:getTroopsScaleById( _troopId )
    
    local scaleNum = 0
    for _,v in pairs(global.troopData.troopList) do
        if v.lID == _troopId then
            if v.tgWarrior then
                for _,v in pairs(v.tgWarrior) do
                    local config = luaCfg:get_soldier_property_by(v.lID)
                    local soldierPerpop =config.perPop
                    scaleNum = scaleNum + v.lCount*soldierPerpop * config.changeTimes
                end
            end            
        end
    end    

    return scaleNum
end

function UITroopDetailPanel:checkTgwarrior(tgWarrior)
    
    local temp = {}
    for _,v in pairs(tgWarrior) do

        local soldiers = global.soldierData:getSoldiersBy(v.lID) or {}
        local num = (soldiers.lCount or 0) + v.lCount
        if num > 0 then
            v.isChief = self:isChief(v.lID)
            v.isHeroType = self:isHeroType(v.lID)
            table.insert(temp, v)
        end
    end

    if table.nums(temp) > 0 then
        table.sort(temp, function(s1, s2) 
            if s1.isChief == s2.isChief  then
                if s1.isHeroType == s2.isHeroType then
                    return s1.lID < s2.lID
                else
                    return s1.isHeroType > s2.isHeroType 
                end
            else
                return s1.isChief > s2.isChief 
            end
        end)
    end
    return temp
end

-- 1 统帅 0 非统帅
function UITroopDetailPanel:isChief(lID)
    -- body
    local soldier_data = luaCfg:get_soldier_train_by(lID)
    local heroMsg = self:getHeroData()
    if heroMsg then 

        local comType = heroMsg.commanderType
        local skillType = heroMsg.secType

        local isCommand = 1
        if comType ~= soldier_data.type then
            isCommand = 0
        end
        if skillType ~= 0 and (skillType ~= soldier_data.skill) then
            isCommand = 0
        end
        return isCommand
    else
        return 0
    end

end

-- 进攻英雄携带进攻兵种
function UITroopDetailPanel:isHeroType(lID)

    if not self.heroMsg then return 0 end
    local isHeroCom = 0
    local curHeroConfig = luaCfg:get_hero_property_by(self.heroMsg.heroId)
    local soldierConfig = luaCfg:get_soldier_property_by(lID)     
    if soldierConfig.type == 6 then -- 冲车和投石车
        return -1
    end
    if soldierConfig.type == 5 then -- 侦察兵
        return 0
    end

    if curHeroConfig.secType == soldierConfig.skill then          -- 进攻类型
        isHeroCom = 2
        if curHeroConfig.commanderType == soldierConfig.type then 
            isHeroCom = 3  
        end
    elseif curHeroConfig.commanderType == soldierConfig.type then -- 兵种类型
        isHeroCom = 1
    end
    return isHeroCom
end

function UITroopDetailPanel:initCityData()
    
    local cityList = global.troopData:getCityList()
    self.city_downList:setData(cityList)
end

function UITroopDetailPanel:setHeroIcon( heroMsg, isSet )
    
    if heroMsg == nil then
        
        self.hero_icon:setVisible(false)
        self.troops_hero:setString("-")
        self.troops_type:setString("-")

        self.troops_supply_add_city:setString("")
        self.heroId = 0

        self.heroMsg = nil
    else
        self.hero_icon:setVisible(true)
        self.troops_hero:setString(heroMsg.serverData.lbase[4] or 0 + heroMsg.serverData.lextra[4] or 0)
        self.heroId = heroMsg.heroId
        -- self.troops_supply_city:setString(heroMsg.serverData.lPower)
        self.troops_type:setString(global.heroData:getCommanderStr(heroMsg))

        local posData = global.heroData:getHeroPicRectAndPosition(heroMsg.heroId)
        if posData then
            self.hero_icon:setPosition(cc.p(posData.X, posData.Y))
            self.hero_icon:setScale(posData.scale/100)
        end
        -- self.hero_icon:loadTexture(heroMsg.nameIcon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.hero_icon,heroMsg.nameIcon)
        self.hero_icon:setAnchorPoint(cc.p(0.5, 0.5))
        self:flushCommanderValue(heroMsg) 
        self.heroMsg = heroMsg

        if not isSet then
            self.TextField_name:setString(global.heroData:getCommanderStr(self.heroMsg))
        end

        if self.troops_size and self.troops_size == 0 and self.heroMsg.serverData and  self.heroMsg.serverData.lbase then
            local commanderScaleMax = self.heroMsg.serverData.lbase[4] + self.heroMsg.serverData.lextra[4]
            self.troops_scale:setString(self.troops_size .. "/" .. commanderScaleMax)
        end

    end
    self:heroBuff(self.heroId)
    gevent:call(global.gameEvent.EV_ON_HEROHEADLIST)  -- 刷新统帅

    -- 当前不是新建部队不默认全选， 或者玩家没有英雄，则士兵数量都处于0位置
    self:defaultSelectSoldier()
    
end


function UITroopDetailPanel:getHeroData()
    return self.heroMsg
end

function UITroopDetailPanel:initSoldierList( soldierData )

    self.itemSoldier = {}
    self.ScroList:removeAllChildren()

    local contentSize = gdisplay.height -  self.Top_layout:getContentSize().height  - self.troopsBottom:getContentSize().height
    local sW = self.SoliderItem_layout:getContentSize().height
    local containerSize = (#soldierData)*(sW+3) - 5
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScroList:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScroList:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    local pY =  containerSize - sW/2


    -- 引导中防御步兵置最前面 特殊处理
    -- if global.guideMgr:isPlaying() and global.userData:getGuideStep() == 801 then

    --     local temp1 = {}
    --     local curSoldierId = 0
    --     for i,v in ipairs(soldierData) do
    --         local soldier_data = luaCfg:get_soldier_train_by(v.lID) 
    --         if soldier_data and soldier_data.type == 1 and soldier_data.skill == 2 then
    --             table.insert(temp1, v)
    --             curSoldierId = v.lID
    --             break
    --         end
    --     end

    --     for i,v in ipairs(soldierData) do
    --         if v.lID ~= curSoldierId then
    --             table.insert(temp1, v)
    --         end
    --     end
    --     soldierData = temp1
    -- end

    for i,v in ipairs(soldierData) do
        
        local soldiers = global.soldierData:getSoldiersBy(v.lID) or {}
        local num = (soldiers.lCount or 0) + v.lCount
        if num > 0 then
            local item = UISoldierItem.new()
            item:setDelegate(self)

            item:setAnchorPoint(cc.p(0, 1))
            item:setPosition(cc.p(gdisplay.width / 2, pY - (sW+3)*(i-1)))
            v.tips_panel = self
            
            -- 引导特殊处理
            -- if global.guideMgr:isPlaying() and global.userData:getGuideStep() == 801 and i==1 then
            --     v.lCount = num > 200 and 200 or num
            --     self.curSold = clone(v)
            -- end
            item:setData(v, i)
            self.ScroList:addChild(item)
            item:setTag(1070+v.lID)
            item.index = i
            table.insert(self.itemSoldier, item)
        end

    end

    if #soldierData == 0 then
        self.Button_confirm:setEnabled(false)
        self.isHavSoldier = false
    else
        self.Button_confirm:setEnabled(true)
    end

    self.ScroList:jumpToTop()
end

function UITroopDetailPanel:initHeadList(soldierData)

    self.itemHeadList = {}
    self.ScrollView_Soilder:removeAllChildren()

    local sW = self.soldier_layout:getContentSize().width 

    local i = 0
    for _,v in pairs(soldierData) do
        local item = UISelectItem.new()
            v.tips_panel = self
            item:setData(v)
            self.ScrollView_Soilder:addChild(item)
            item:setTag((1070+v.lID)*10)
            table.insert(self.itemHeadList, item)
            i = i + 1
    end
    self:refershPosition(0)
end

function UITroopDetailPanel:refershPosition( _non )

    local sW = self.soldier_layout:getContentSize().width
    local i = 0
    for _,v in pairs(self.itemHeadList) do
        if v.curNumber > 0 then
            v:setVisible(true)

            if v.soldier_bg:getTag() ~= sW*i then

                v.soldier_bg:stopActionByTag(1024)
                local taskX = 49.50 + sW*i 
                local moveAction = cc.EaseExponentialOut:create(cc.MoveTo:create(0.2,  cc.p(taskX, v.soldier_bg:getPositionY())))
                moveAction:setTag(1024)
                v.soldier_bg:runAction(moveAction)
                v.soldier_bg:setTag(sW*i)
            end
            i = i + 1
        else
            v:setVisible(false)
        end 
    end
    self.ScrollView_Soilder:setInnerContainerSize(cc.size(i*sW, self.ScrollView_Soilder:getContentSize().height))
end

function UITroopDetailPanel:select_hero(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UISelectHeroPanel")
    panel:setData(self.id, self.heroId)
    panel:setTarget(self)
    panel:setExitCall(function()
        gevent:call(global.gameEvent.EV_ON_GUIDE_FIRST_CHANGE_HERO_IN_EDIT_SELECT_CONFRIM)
    end)
end

function UITroopDetailPanel:confirm_click(sender, eventType)

    local strName = self.TextField_name:getString() 
    if string.isEmoji(strName) then        
        global.tipsMgr:showWarning("13")
        return    
    end

    if self.heroId and self.heroId ~= 0 then
    else
        global.tipsMgr:showWarning("TroopsHero")
        self:select_hero()
        return
    end

    print(":;;;;;;;;;;;---self.troops_size="..self.troops_size)
    local scaleNum = tonumber(self.troops_size) 
    if scaleNum > 0 then
        local serverData = self:getServerTroopData() 
        if self.troopsId == 0 then          
            serverData.lState = 6
            self:buildNewTroop(serverData, true)    --　新建部队
        else
            self:updateTroop(serverData)            --　更新部队
        end
    else
        global.tipsMgr:showWarning("TroopsConfirm")
    end
end

-- 部队编辑结束 直接出征
function UITroopDetailPanel:buildCallMove(curTroop, isNew)
    
    self:exit_call()
    if not isNew then return end
    local targetInfo = global.troopData:getTargetData()
    if targetInfo and (targetInfo.attackMode == -1 or targetInfo.attackMode == -2) then
        return
    end
    global.panelMgr:closePanel("UITroopDetailPanel")
    global.panelMgr:getPanel("UITroopPanel"):outTroop(curTroop)
end

function UITroopDetailPanel:buildNewTroop(serverData, isNew)
    
    global.cityApi:troopManager(0, serverData, function(msg)
        if msg.tgTroop.tgWarrior ~= nil then
            
            global.troopData:addTroop(msg.tgTroop)
            self:updataSoldierNum()

            if global.troopData:checkTroopType(msg.tgTroop) then
                global.tipsMgr:showWarning("SetupScout")
            end
            self:buildCallMove(msg.tgTroop, isNew)
        end
    end)
end

function UITroopDetailPanel:updateTroop(serverData, isNew)

    global.cityApi:troopManager(1, serverData, function(msg)

        global.troopData:updataTroop(msg.tgTroop)
        self:updataSoldierNum()
        if global.troopData:checkTroopType(msg.tgTroop) then
            global.tipsMgr:showWarning("SetupScout")
        end
        self:buildCallMove(msg.tgTroop, isNew)
    end)
end

function UITroopDetailPanel:updataSoldierNum()
    
    for _,v in pairs(self.itemSoldier) do
        if v.max  and  v.cur then -- protect  
            local maxCount = tonumber(v.max:getString()) 
            global.soldierData:updateSoldiersNum(v.soldierID, maxCount - tonumber(v.cur:getString()) )
        end 
    end
end

function UITroopDetailPanel:getServerTroopData()
    
    local tgTroop = {}
    tgTroop.lID = self.troopsId

    tgTroop.lHeroID = {[1]=self.heroId}
    if self.id ~= self.heroId then
        global.heroData:updataRecruitHeroUseState(self.id)
        global.heroData:updataRecruitHeroUseState(self.heroId)
    end
    
    local strName = self.TextField_name:getString() 
    if strName and strName ~= "" then
    elseif self.heroMsg then
        strName = global.heroData:getCommanderStr(self.heroMsg)
    else
        strName = luaCfg:get_local_string(10140)
    end
    tgTroop.szName = strName
    tgTroop.lCityID = 0 -- self.troops_troops_city:getString()
    tgTroop.lState = global.troopData:getTroopById(self.troopsId).lState
    tgTroop.lTarget = 0 -- self.troops_size:getString()

    local tgWarrior = {}
    for _,v in pairs(self.itemSoldier or {}) do

        local temp = {}
        temp.lID = v.soldierID
        temp.lCount = tonumber(v.cur:getString()) 
        temp.lFrom = 0
        table.insert(tgWarrior, temp)
    end
    tgTroop.tgWarrior = tgWarrior
    return tgTroop
end

function UITroopDetailPanel:exit_call()

    global.panelMgr:closePanelForBtn("UITroopDetailPanel") 
    global.panelMgr:getPanel("UITroopPanel"):setData()
    self:removeRoadRace() -- 退出删除预加载资源
end

function UITroopDetailPanel:cancel_click(sender, eventType)

    self.noEffect = false 
    self:exit_call()
end

function UITroopDetailPanel:nameEditHandler(sender, eventType)
    self.TextField_name:touchDownAction()
end

function UITroopDetailPanel:onInfoClick(sender, eventType)
    local panel = global.panelMgr:openPanel("UITroopCombinDetailPanel")
    local data = self.detailData
    data.troop_size = self.troops_scale:getString() 
    data.troop_power = self.troops_power
    data.troop_type_str = self.troops_type:getString()
    data.troop_hero_str = self.troops_hero:getString()
    data.troop_resource_str = self.troops_resource:getString()
    data.szName = self.data.szName
    panel:setData(data)
end

function UITroopDetailPanel:autoConfirm(sender, eventType)
    self.noEffect = false 
    self:defaultSelectSoldier()
end
--CALLBACKS_FUNCS_END

return UITroopDetailPanel

--endregion

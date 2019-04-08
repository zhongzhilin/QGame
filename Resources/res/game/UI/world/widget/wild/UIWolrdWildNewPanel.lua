--region UIWolrdWildNewPanel.lua
--Author : Untory
--Date   : 2017/12/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UITableView = require("game.UI.common.UITableView")
local UISoldierIconItem = require("game.UI.troop.UISoldierIconItem")
local UIWolrdWildNewDropItemCell = require("game.UI.world.widget.wild.UIWolrdWildNewDropItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIWolrdWildNewPanel  = class("UIWolrdWildNewPanel", function() return gdisplay.newWidget() end )

function UIWolrdWildNewPanel:ctor()
    self:CreateUI()
end

function UIWolrdWildNewPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_info")
    self:initUI(root)
end

function UIWolrdWildNewPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.board = self.root.Node_export.board_export
    self.nodes = self.root.Node_export.nodes_export
    self.name = self.root.Node_export.nodes_export.name_export
    self.close_node = self.root.Node_export.nodes_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.nodes_export.close_node_export)
    self.type_icon = self.root.Node_export.nodes_export.type_bj.type_icon_export
    self.lv = self.root.Node_export.nodes_export.lv_mlan_5.lv_export
    self.type = self.root.Node_export.nodes_export.type_mlan_5.type_export
    self.hp = self.root.Node_export.nodes_export.hp_mlan_5.hp_export
    self.player = self.root.Node_export.nodes_export.player_mlan_5.player_export
    self.union = self.root.Node_export.nodes_export.union_mlan_5.union_export
    self.speed = self.root.Node_export.nodes_export.speed_mlan_5.speed_export
    self.ready = self.root.Node_export.nodes_export.ready_mlan_4.ready_export
    self.time = self.root.Node_export.nodes_export.time_mlan_5.time_export
    self.energy = self.root.Node_export.nodes_export.energy_mlan_5.energy_export
    self.hero = self.root.Node_export.nodes_export.hero_mlan_5.hero_export
    self.resgo_title = self.root.Node_export.nodes_export.resgo_title_export
    self.hero_icon = self.root.Node_export.nodes_export.resgo_title_export.hero_icon_export
    self.heroLv = self.root.Node_export.nodes_export.resgo_title_export.heroLv_export
    self.hero_name = self.root.Node_export.nodes_export.resgo_title_export.hero_k.hero_name_export
    self.right = self.root.Node_export.nodes_export.resgo_title_export.right_export
    self.left = self.root.Node_export.nodes_export.resgo_title_export.left_export
    self.starlist = UIHeroStarList.new()
    uiMgr:configNestClass(self.starlist, self.root.Node_export.nodes_export.resgo_title_export.starlist)
    self.Panel_soldier = self.root.Node_export.nodes_export.resgo_title_export.Panel_soldier_export
    self.ScrollView = self.root.Node_export.nodes_export.resgo_title_export.ScrollView_export
    self.resgo = self.root.Node_export.nodes_export.resgo_title_export.resgo_mlan_4.resgo_export
    self.drop_title = self.root.Node_export.nodes_export.drop_title_export
    self.tb_size = self.root.Node_export.nodes_export.drop_title_export.tb_size_export
    self.it_size = self.root.Node_export.nodes_export.drop_title_export.it_size_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onClose(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tb_size:getContentSize())
        :setCellSize(self.it_size:getContentSize())
        :setCellTemplate(UIWolrdWildNewDropItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_size:addChild(self.tableView)

    self.close_node:setData(function()
        self:onClose()
    end)


    global.funcGame:initBigNumber(self.hp , 1 )

end


function UIWolrdWildNewPanel:onEnter()
    self.canExit = false
end 

function UIWolrdWildNewPanel:setData(data)
    -- self.data = data
    local troopData = global.troopData:getCollectTroop(data.lResID)  
    local designerData = luaCfg:get_wild_res_by(data.lKind)
    local surface = luaCfg:get_world_surface_by(designerData.file)
    local pos = global.g_worldview.const:converPix2Location(cc.p(data.lPosX, data.lPosY))

    data.lPlusRes = data.lPlusRes or 0

    self.data = data
    self.designerData = designerData
    self.troopData = troopData

    self.energy:setString(designerData.energy)
    self.lv:setString(designerData.level)
    self.name:setString(string.format("%s(%s,%s)",designerData.name,pos.x,pos.y))
    self.type:setString(surface.name)   
    -- self.hp:setString(designerData.allres - data.lCollectCount)
    -- self.ready:setString(data.lCollectCount)
    -- self.speed:setString(designerData.yield)

    -- 如果没有被人占领时，显示配表速度，特殊处理
    self:setYield(designerData.yield,data.lCollectSpeed and data.lCollectSpeed - designerData.yield or 0)

    global.panelMgr:setTextureFor(self.type_icon,surface.worldmap)
    self.type_icon:setScale(surface.iconSize)
    
    if data.tagOwner then
        self.player:setString(data.tagOwner.szUserName)
        self.union:setString(global.unionData:getUnionShortName(data.tagOwner.szAllyName))
    else
        self.player:setString("--")
        self.union:setString("--")
    end

    self:addEventListener(global.gameEvent.EV_ON_WILD_REFRESH,function(event,data)

        if data.lResID == self.data.lResID then
            self:stopSchedule()
            self:setData(data)
        end 
    end)


    -- 如果正在采集的话
    if self.data.lCollectSpeed then

        if not self.data.lSpeedEndTime then
            self.time:setString('--:--:--')
        end

        self:startCheckTime()
    else
        local hp = designerData.allres - data.lCollectCount        
        if hp < 0 then
            self:stopSchedule()
            global.tipsMgr:showWarning('ResVillageDis')
            global.panelMgr:closePanel('UIWolrdWildNewPanel')
            return
        end

        self.hp:setString(hp)
        self.ready:setString(data.lCollectCount)
        self.time:setString('--:--:--')
    end

    if troopData then
        if troopData.tgWarrior then
            self:preRoadAllRace(troopData.tgWarrior)
            self:initSoldierIconList(troopData.tgWarrior)
        end        

        if troopData.lHeroID and troopData.lHeroID[1] ~= 0 then 

            local heroData = global.heroData:getHeroDataById(troopData.lHeroID[1]) --global.heroData:getHeroPropertyById(troopData.lHeroID[1])
            -- self.hero_icon:loadTexture(herotroopData.nameIcon, ccui.TextureResType.plistType)
            

            dump(heroData,'....heroData')

            global.panelMgr:setTextureFor(self.hero_icon,heroData.nameIcon)
            self.hero_name:setString(heroData.name)
            -- self.heroAdd:setString(troopData.lHeroPower + global.troopData:getTroopsScaleByData(troopData.tgWarrior))
            -- self.hero_quality:setVisible(heroData.quality == 2)
            self.starlist:setVisible(true)
            self.left:setVisible(true)
            self.right:setVisible(true)
            self.starlist:setData(troopData.lHeroID[1],  heroData.serverData.lStar)
            global.funcGame:dealHeroRect(self,heroData)
            self.heroLv:setString("")
            heroId = troopData.lHeroID[1]

            self.sbuffs  = {speed=0, supply=0, carry=0}
            self.hbuffs  = {speed=0, supply=0, carry=0}
            self:soldierBuff()
            self:heroBuff(heroId)
            self:refershBuff()

            local gov = global.heroData:getHeroProperty(heroData,3)
            local totalAdd = math.floor(gov / luaCfg:get_config_by(1).garrisonScale) + 200
            if totalAdd > 0 then
                local str = totalAdd ..luaCfg:get_local_string(10076)
                self.hero:setString(luaCfg:get_local_string(10692, str))
            else
                self.hero:setString('--')
            end            
        else
            self.hero_icon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
            self.hero_name:setString("")
            self.starlist:setVisible(false)
            self.left:setVisible(false)
            self.right:setVisible(false)
            -- self.hero_quality:setVisible(false)
            self.hero:setString('--')
            self.heroLv:setString("")
            -- self.heroAdd:setString(global.troopData:getTroopsScaleByData(troopData.tgWarrior))
        end

        self.drop_title:setPositionY(-210)
        self.board:setContentSize(cc.size(709,960))
        self.nodes:setPositionY(0)
        self.resgo_title:setVisible(true)
    else
        self.ScrollView:removeAllChildren()
        self.hero_icon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
        self.hero_name:setString("")
        self.starlist:setVisible(false)
        self.hero:setString("--")
        self.left:setVisible(false)
        self.right:setVisible(false)
        self.resgo:setString('--')
        self.heroLv:setString("")

        self.drop_title:setPositionY(30)
        self.nodes:setPositionY(-120)
        self.resgo_title:setVisible(false)
        self.board:setContentSize(cc.size(709,720))
    end

    -- self:startCheckTime()
    self:checkDrop()

    global.tools:adjustNodePosForFather(self.resgo:getParent(), self.resgo)
    global.tools:adjustNodePosForFather(self.lv:getParent(), self.lv)
    global.tools:adjustNodePosForFather(self.type:getParent(), self.type)
    global.tools:adjustNodePosForFather(self.hp:getParent(), self.hp)
    global.tools:adjustNodePosForFather(self.speed:getParent(), self.speed)
    global.tools:adjustNodePosForFather(self.hero:getParent(), self.hero)
    global.tools:adjustNodePosForFather(self.player:getParent(), self.player)
    global.tools:adjustNodePosForFather(self.union:getParent(), self.union)
    global.tools:adjustNodePosForFather(self.time:getParent(), self.time)
    global.tools:adjustNodePosForFather(self.energy:getParent(),self.energy)
end

function UIWolrdWildNewPanel:checkDrop()
    
    self.tableView:setData({})    
    global.worldApi:ResourceDrop(self.data.lResID,function(msg)    
        if not tolua.isnull(self.tableView) then
            self.tableView:setData(msg.tagResDorpLog)
        end
    end)
end

function UIWolrdWildNewPanel:preRoadAllRace(tgWarrior)

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

function UIWolrdWildNewPanel:initSoldierIconList( soldierData )
    
    self.ScrollView:removeAllChildren()

    local sW = self.Panel_soldier:getContentSize().width + 5
    local i = 0
    for _,v in pairs(soldierData) do
        if v.lCount > 0 then
            local item = UISoldierIconItem.new()
            item:setAnchorPoint(cc.p(0, 0))
            item:setPosition(cc.p(sW*i, 0))
            item:setData(v)
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

-- 英雄buff
function UIWolrdWildNewPanel:heroBuff(heroId)

    if heroId == 0 then
        return
    end
    
    global.gmApi:effectBuffer({{lType =12, lBind = heroId}},function(msg)

        self.hbuffs  = self.hbuffs or {speed=0, supply=0, carry=0}

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

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

        self.canExit = true 
        self:refershBuff()
    end)

end

-- 英雄buff
function UIWolrdWildNewPanel:soldierBuff()

    global.gmApi:effectBuffer({{lType = 7, lBind = 0}},function(msg)

        self.sbuffs  = self.sbuffs or {speed=0, supply=0, carry=0}

        msg.tgEffect = msg.tgEffect or {}
        local buffData = msg.tgEffect[1]
        if not  buffData then return end

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
        self:refershBuff()
    end)
end

function UIWolrdWildNewPanel:refershBuff()
    -- body 
    if not self.troopData then
        return
    end
    local carryVal = self.sbuffs.carry   + self.hbuffs.carry
    local curCapacity = global.troopData:getTroopsClassWeightByData(self.troopData.tgWarrior) or 0
    self.curCapacity = math.ceil(curCapacity*(1+carryVal))
    -- self.resgo:setString('-')
end

function UIWolrdWildNewPanel:stopSchedule()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UIWolrdWildNewPanel:startCheckTime()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheStartTime = global.dataMgr:getServerTime()
    self.scheduleListenerId = gscheduler.scheduleGlobal(function(dt)
        
        self:checkTime(dt)
    end, 1 / 10) 

    self:checkTime(0)
end

function UIWolrdWildNewPanel:onExit()

    self:stopSchedule()
end

function UIWolrdWildNewPanel:checkTime(dt)

    -- dump(self.data ,"self.data->>")

    local speed = self.data.lCollectSpeed / 3600
    self.scheStartTime = self.scheStartTime + dt --global.dataMgr:getServerTime()
    local cutTime = self.scheStartTime - self.data.lCollectStart
    local alreadyGet = speed * cutTime + self.data.lPlusRes
    
    if self.data.lSpeedEndTime then
        local buffLeastTime = self.data.lSpeedEndTime - self.scheStartTime
        self.time:setString(global.funcGame.formatTimeToHMS(buffLeastTime))
    end    

    local leastHp = math.ceil(self.designerData.allres - alreadyGet - self.data.lCollectCount)
    local ready = math.ceil(alreadyGet + self.data.lCollectCount)

    self.hp:setString(leastHp)
    self.ready:setString(ready) 
    
    if self.curCapacity and self.canExit then

        if alreadyGet > self.curCapacity then
            self:stopSchedule()
            global.panelMgr:closePanel('UIWolrdWildNewPanel')
            return
        end
        
        self.resgo:setString(math.ceil(alreadyGet) .. '/' .. self.curCapacity)
    end    

    if leastHp < 0 then

        self:stopSchedule()
        global.tipsMgr:showWarning('ResVillageDis')
        global.panelMgr:closePanel('UIWolrdWildNewPanel')
    end
end

function UIWolrdWildNewPanel:setYield(base,add)
    
    if add == 0 then
        add = ""
    else
        add = " +" .. add
    end 

    dump({basics = base,addnum = add},'{basics = base,addnum = add}')

    global.uiMgr:setRichText(self, "speed", 50249, {basics = base,addnum = add})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWolrdWildNewPanel:onClose(sender, eventType)
    
    global.panelMgr:closePanelForBtn('UIWolrdWildNewPanel')
end
--CALLBACKS_FUNCS_END

return UIWolrdWildNewPanel

--endregion

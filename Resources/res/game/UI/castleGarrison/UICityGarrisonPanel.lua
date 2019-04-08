--region UICityGarrisonPanel.lua
--Author : yyt
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICityGarrisonPanel  = class("UICityGarrisonPanel", function() return gdisplay.newWidget() end )
local TabControl = require("game.UI.common.UITabControl")
local UITableView = require("game.UI.common.UITableView")
local UIGarrisonCell = require("game.UI.castleGarrison.UIGarrisonCell")
local UIGarrisonEffectCell = require("game.UI.castleGarrison.UIGarrisonEffectCell")

function UICityGarrisonPanel:ctor()
    self:CreateUI()
end

function UICityGarrisonPanel:CreateUI()
    local root = resMgr:createWidget("castle_garrison/castle_garrison_panel")
    self:initUI(root)
end

function UICityGarrisonPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/castle_garrison_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.TabNode = self.root.TabNode_export
    self.tabNode = self.root.tabNode_export
    self.title = self.root.title_export
    self.eTop = self.root.effect_bg.eTop_export
    self.eBot = self.root.effect_bg.eBot_export
    self.eTabSize = self.root.effect_bg.eTabSize_export
    self.eCellSize = self.root.effect_bg.eCellSize_export
    self.no_garrison = self.root.effect_bg.no_garrison_mlan_57_export
    self.eTabNode = self.root.effect_bg.eTabNode_export
    self.garrisonStateBtn1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export
    self.garrisonState1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export
    self.pic1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.pic1_export
    self.lockBg1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.lockBg1_export
    self.hero_name1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.hero_name1_export
    self.lock1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.lock1_export
    self.giveup1Btn = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.giveup1Btn_export
    self.hero_quality1 = self.root.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.hero_quality1_export
    self.selectState1 = self.root.choose_node.choose_hero1.selectState1_export
    self.addBtn1 = self.root.choose_node.choose_hero1.selectState1_export.addBtn1_export
    self.Image_bg1 = self.root.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export
    self.unLockGray1 = self.root.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export.unLockGray1_export
    self.addBtnS1 = self.root.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export.addBtnS1_export
    self.garrisonStateBtn2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export
    self.garrisonState2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export
    self.pic2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.pic2_export
    self.lockBg2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.lockBg2_export
    self.hero_name2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.hero_name2_export
    self.lock2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.lock2_export
    self.giveup2Btn = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.giveup2Btn_export_0
    self.hero_quality2 = self.root.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.hero_quality2_export
    self.selectState2 = self.root.choose_node.choose_hero2.selectState2_export
    self.addBtn2 = self.root.choose_node.choose_hero2.selectState2_export.addBtn2_export
    self.Image_bg2 = self.root.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export
    self.unLockGray2 = self.root.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export.unLockGray2_export
    self.addBtnS2 = self.root.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export.addBtnS2_export
    self.total = self.root.choose_node.total_export
    self.CellSize = self.root.CellSize_export
    self.TabSize = self.root.TabSize_export
    self.Bot = self.root.Bot_export
    self.Top = self.root.Top_export
    self.intro_btn = self.root.intro_btn_export

    uiMgr:addWidgetTouchHandler(self.garrisonStateBtn1, function(sender, eventType) self:selectHero1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.giveup1Btn, function(sender, eventType) self:giveUpHero1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.addBtn1, function(sender, eventType) self:selectHero1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.garrisonStateBtn2, function(sender, eventType) self:selectHero2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.giveup2Btn, function(sender, eventType) self:giveUpHero2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.addBtn2, function(sender, eventType) self:selectHero2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:confirmHandler(sender, eventType) end)

    self.tabControl = TabControl.new(self.tabNode, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.tableView = UITableView.new()
        :setSize(self.TabSize:getContentSize(), self.Top, self.Bot)
        :setCellSize(self.CellSize:getContentSize())
        :setCellTemplate(UIGarrisonCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.TabNode:addChild(self.tableView)
    self.tableView:setName("GarrisonTableView")

    self.eTableView = UITableView.new()
        :setSize(self.eTabSize:getContentSize(), self.eTop, self.eBot)
        :setCellSize(self.eCellSize:getContentSize())
        :setCellTemplate(UIGarrisonEffectCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.eTabNode:addChild(self.eTableView)

    global.garrPanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICityGarrisonPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UICityGarrisonPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UICityGarrisonPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UICityGarrisonPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UICityGarrisonPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UICityGarrisonPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UICityGarrisonPanel:setBuildId(buildId)
    self.buildId = buildId
end

function UICityGarrisonPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_GARRISON_BUILD,function ()
        if self.refersh then
            self:refersh()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GARRISON_GARRISONUI,function ()
        if self.initData then
            self:initData(false, true)
        end
    end)

    self.isOnEnter = true
    self.isPageMove = false
    self:registerMove()
end

function UICityGarrisonPanel:refersh()

    global.cityApi:getGarrisonList(function (msg)
        global.heroData:setBuildGarrison(msg.tagBuildGarrison or {})
        self:initData(false, true)
    end)
end

function UICityGarrisonPanel:initData(isOnEnter, isNoReset)

    self:initSerData(global.heroData:getBuildGarrison())
    self:setData(isOnEnter, isNoReset)
    if isOnEnter then
        self:showHandGudie()
        self.isOnEnter = false
    end
end

function UICityGarrisonPanel:showHandGudie()
    -- body
    local tableData = self.tableView:getData()
    for index,v in ipairs(tableData) do
        if v.building_id == self.buildId then
            self.tableView:jumpToCellYByIdx(#tableData-index+1, true)

            self:adjustps(self.buildId)
            break
        end
    end

    -- global.uiMgr:addSceneModel(1)
    -- global.guideMgr.getHandler():autoGuide(
    --     {
    --         isSpecial = true,
    --         panelName = "UICityGarrisonPanel",
    --         tableViewName = "GarrisonTableView",
    --         dataCatch = {building_id = self.buildId},
    --         isShowLight = true,
    --         scaleY = 1
    --     }
    -- )

end

function UICityGarrisonPanel:adjustps(buildId)

    for k , v in pairs(self.tableView:getCells()) do 
        
        if v.tv_target and v.tv_target.item and v.tv_target.item.data  and  v.tv_target.item.data.building_id == buildId  then 

           local world_y =  v.tv_target.item:convertToWorldSpace((cc.p(0,0))).y 
         
            local yy =  self:getFixedPosition() - world_y - self.tableView.__cellSize.height / 2  +self.tableView:getContentOffset().y -- 离定位的偏差

            if yy  > 0 then 
                yy = 0 
            end 

            if yy < -(self.tableView:getContentSize().height - self:getTablewContent()) then 
                yy=  -(self.tableView:getContentSize().height - self:getTablewContent())
            end 

            self.tableView:setContentOffset(cc.p(0, yy))
        end
    end

end


function UICityGarrisonPanel:getTablewContent()

    return self.Top:getPositionY() -  self.Bot:getPositionY()
end


function UICityGarrisonPanel:getFixedPosition()

    return self.Bot:getPositionY() + self:getTablewContent() /2 
end 


function UICityGarrisonPanel:initSerData(serverData)

    local getSerData = function (buildId)
        -- body
        if not serverData then return nil end
        for _,v in ipairs(serverData) do
            if v.lBuild == buildId then
                return v
            end
        end
        return nil
    end

    local garConfig = clone(luaCfg:garrison_effect())
    for i,v in ipairs(garConfig) do 
        v.serData = getSerData(v.building_id)
    end
    self.data = garConfig
end

function UICityGarrisonPanel:getGarrisonData(buildId)
    -- body
    if not self.data then return end
    for _,v in ipairs(self.data) do
        if v.building_id == buildId then
            return v
        end
    end
    return false
end

function UICityGarrisonPanel:getTypeData(lType)
    -- body
    local data = {}
    for i,v in ipairs(self.data) do
        if v.garrison_type == lType then
            table.insert(data, v)
        end
    end
    return data
end

-- 1内政 2军事
function UICityGarrisonPanel:onTabButtonChanged(index, isNoReset)
    self.tableView:stopScrolling()
    if isNoReset then
        index = self.tabControl:getSelectedIdx()        
    end
    self.tabControl:setSelectedIdx(index)
    self.tableView:setData(self:getTypeData(index), isNoReset)
end 
    
function UICityGarrisonPanel:setData(isOnEnter, isNoReset)

    if isOnEnter then
        local curIndex = self:getGarrisonData(self.buildId).garrison_type
        if curIndex == 0 then curIndex = 1 end
        self:onTabButtonChanged(curIndex, isNoReset)
    else
        self:onTabButtonChanged(1, isNoReset)
    end

    -- 主城
    local cityData = self:getGarrisonData(1)
    self.cityData = cityData
    
    local serData = cityData.serData
    if serData then
        
        if serData.tagBuffDetail then 
            self.no_garrison:setVisible(false)

            for i=1,2 do
                local curHeroId = serData["lPos"..i]
                self:setHeroSkillAdd(curHeroId)
            end
            self.eTableView:setData(self.cityData.serData.tagBuffDetail)
        else
            self.no_garrison:setVisible(true)
            self.no_garrison:setString(self:getBuffDetail())
            self.eTableView:setData({})
        end

        self.total:setString(luaCfg:get_translate_string(10826,  self:getInterior(serData)))
        for i=1,2 do

            self["garrisonState"..i]:setVisible(false)
            self["selectState"..i]:setVisible(false)
            local curHeroId = serData["lPos"..i]
            if curHeroId then
                self["garrisonState"..i]:setVisible(true)
                self:setGarrisonHero(serData, i)
            else
                self["selectState"..i]:setVisible(true)
                local isUnlock =  global.funcGame:checkTarget(cityData["unlock_level_"..i])
                self["unLockGray"..i]:setVisible(not isUnlock)
                self["addBtnS"..i]:setVisible(isUnlock)
                global.colorUtils.turnGray(self["Image_bg"..i],not isUnlock)
            end
        end
    end
end

-- 获取英雄技能加成
function UICityGarrisonPanel:setHeroSkillAdd(heroId)
    -- body

    local skillBuffs = {}
    local recruitHero = global.heroData:getGotHeroData()
    local otherBuffList = {}
    for _,v in pairs(recruitHero) do
        
        if v.heroId == heroId then
            local skills = v.serverData.lSkill
            for _,vv in ipairs(skills) do

                if vv ~= 0 then                  
                    local skillData = luaCfg:get_skill_by(vv)
                    if skillData.garrison == 1 then
                        local buffId = skillData.buff[1]
                        local buffValue = skillData.value[1]
                        otherBuffList[buffId] = otherBuffList[buffId] or 1
                        otherBuffList[buffId] =  (1 - buffValue/100)*otherBuffList[buffId]
                    end
                end                
            end
        end
    end

    for k,v in pairs(otherBuffList) do
        local temp = {}
        temp.lBuffid = k
        temp.lValue = (1-v)*100
        table.insert(skillBuffs, temp)
    end

    for i,v in ipairs(skillBuffs) do
        table.insert(self.cityData.serData.tagBuffDetail, v)
    end

end

function UICityGarrisonPanel:getBuffDetail()

    local data = self:getGarrisonData(1)
    local parStr1, parStr2, str = "", "", ""
    local num = 0
    if data.effect_1 and data.effect_1 ~= 0 then
        local typeData1 = luaCfg:get_data_type_by(data.effect_1)
        parStr1 = typeData1.paraName
        num = num + 1
    end

    if data.effect_2 and data.effect_2 ~= 0 then
        local typeData2 = luaCfg:get_data_type_by(data.effect_2)
        parStr2 = typeData2.paraName
        num = num + 1
    end

    if num == 1 then
        str = luaCfg:get_translate_string(10834, data.name, parStr1)
    else
        str = luaCfg:get_translate_string(10833, data.name, parStr1, parStr2)
    end
    return str
end

function UICityGarrisonPanel:setGarrisonHero(cityData, i)
    -- body
    local heroData = luaCfg:get_hero_property_by(cityData["lPos"..i])
    global.panelMgr:setTextureFor(self["pic"..i], heroData.nameIcon)
    self["hero_name"..i]:setString(heroData.name)
    self["lock"..i]:setVisible(cityData.lstate == 1)
    self["lockBg"..i]:setVisible(cityData.lstate == 1)
    self["giveup"..i.."Btn"]:setVisible(cityData.lstate ~= 1)
    self["hero_quality"..i]:setVisible(heroData.Strength == 3)
end

-- 获取总内政值
function UICityGarrisonPanel:getInterior(data)

    local totalInter = 0
    for i=1,2 do
        if data["lPos"..i] then
            totalInter = totalInter + global.heroData:getHeroInterior(data["lPos"..i])
        end
    end
    return totalInter
end

function UICityGarrisonPanel:confirmHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UICityGarrisonPanel")
end

function UICityGarrisonPanel:selectHero1Handler(sender, eventType)
    
    local targetId = self.cityData.unlock_level_1
    local isUnlock = global.funcGame:checkTarget(targetId)
    if not isUnlock then
        local triggerData = luaCfg:get_target_condition_by(targetId)
        local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
        global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
        return
    else
        global.panelMgr:openPanel("UIGarrisonSelectPanel"):setData(self.cityData, 1)
    end
end

function UICityGarrisonPanel:selectHero2Handler(sender, eventType)
    
    local targetId = self.cityData.unlock_level_2
    local isUnlock = global.funcGame:checkTarget(targetId)
    if not isUnlock then
        local triggerData = luaCfg:get_target_condition_by(targetId)
        local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
        global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
        return
    else
        global.panelMgr:openPanel("UIGarrisonSelectPanel"):setData(self.cityData, 2)
    end
end

function UICityGarrisonPanel:giveUpHero1Handler(sender, eventType)

    local curHeroId = self.cityData.serData.lPos1
    global.commonApi:heroAction(curHeroId, 5, 1, 0, 0, function(msg)
        global.tipsMgr:showWarning("fireSuccessful")
        global.heroData:updateVipHero(msg.tgHero[1])
        gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)
    end)
end

function UICityGarrisonPanel:giveUpHero2Handler(sender, eventType)
    
    local curHeroId = self.cityData.serData.lPos2
    global.commonApi:heroAction(curHeroId, 5, 2, 0, 0, function(msg)
        global.tipsMgr:showWarning("fireSuccessful")
        global.heroData:updateVipHero(msg.tgHero[1])
        gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)
    end)
end

function UICityGarrisonPanel:infoCall(sender, eventType)

    local data = luaCfg:get_introduction_by(23)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UICityGarrisonPanel:chooseHero(sender, eventType)

end

function UICityGarrisonPanel:chooseHero(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UICityGarrisonPanel

--endregion

--region UIGarrisonItem.lua
--Author : yyt
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonItem  = class("UIGarrisonItem", function() return gdisplay.newWidget() end )
local UIGarrisonEffect = require("game.UI.castleGarrison.UIGarrisonEffect")

function UIGarrisonItem:ctor()
    self:CreateUI()
end

function UIGarrisonItem:CreateUI()
    local root = resMgr:createWidget("castle_garrison/castle_garrison_node")
    self:initUI(root)
end

function UIGarrisonItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/castle_garrison_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.garrisonStateBtn1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export
    self.garrisonState1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export
    self.pic1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.pic1_export
    self.lockBg1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.lockBg1_export
    self.hero_name1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.hero_name1_export
    self.lock1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.lock1_export
    self.giveup1Btn = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.giveup1Btn_export
    self.hero_quality1 = self.root.Node_17.choose_node.choose_hero1.garrisonStateBtn1_export.garrisonState1_export.hero_quality1_export
    self.selectState1 = self.root.Node_17.choose_node.choose_hero1.selectState1_export
    self.addBtn1 = self.root.Node_17.choose_node.choose_hero1.selectState1_export.addBtn1_export
    self.Image_bg1 = self.root.Node_17.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export
    self.unLockGray1 = self.root.Node_17.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export.unLockGray1_export
    self.addBtnS1 = self.root.Node_17.choose_node.choose_hero1.selectState1_export.addBtn1_export.Image_bg1_export.addBtnS1_export
    self.garrisonStateBtn2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export
    self.garrisonState2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export
    self.pic2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.pic2_export
    self.lockBg2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.lockBg2_export
    self.hero_name2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.hero_name2_export
    self.lock2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.lock2_export
    self.giveup2Btn = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.giveup2Btn_export_0
    self.hero_quality2 = self.root.Node_17.choose_node.choose_hero2.garrisonStateBtn2_export.garrisonState2_export.hero_quality2_export
    self.selectState2 = self.root.Node_17.choose_node.choose_hero2.selectState2_export
    self.addBtn2 = self.root.Node_17.choose_node.choose_hero2.selectState2_export.addBtn2_export
    self.Image_bg2 = self.root.Node_17.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export
    self.unLockGray2 = self.root.Node_17.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export.unLockGray2_export
    self.addBtnS2 = self.root.Node_17.choose_node.choose_hero2.selectState2_export.addBtn2_export.Image_bg2_export.addBtnS2_export
    self.total = self.root.Node_17.choose_node.total_export
    self.name = self.root.Node_17.build_icon_bg.name_export
    self.icon = self.root.Node_17.build_icon_bg.icon_export
    self.no_garrison = self.root.Node_17.effect_bg.no_garrison_export
    self.effectNode = self.root.Node_17.effectNode_export
    self.effect = self.root.effect_export
    self.top = self.root.effect_export.top_export
    self.bottom = self.root.effect_export.bottom_export

    uiMgr:addWidgetTouchHandler(self.garrisonStateBtn1, function(sender, eventType) self:selectHero1Handler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.giveup1Btn, function(sender, eventType) self:giveUpHero1Handler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.addBtn1, function(sender, eventType) self:selectHero1Handler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.garrisonStateBtn2, function(sender, eventType) self:selectHero2Handler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.giveup2Btn, function(sender, eventType) self:giveUpHero2Handler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.addBtn2, function(sender, eventType) self:selectHero2Handler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.addBtn1:setSwallowTouches(false)
    self.addBtn2:setSwallowTouches(false)
   -- self.giveup1Btn:setSwallowTouches(false)
   -- self.giveup2Btn:setSwallowTouches(false)
    self.garrisonStateBtn1:setSwallowTouches(false)
    self.garrisonStateBtn2:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonItem:onEnter()

    local nodeTimeLine = resMgr:createTimeline("castle_garrison/castle_garrison_node")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        self.effect:setVisible(false)
    end)
    self.root:runAction(nodeTimeLine)

end

function UIGarrisonItem:setData(data)
    -- body
    self.data = data
    local serData = data.serData
    global.panelMgr:setTextureFor(self.icon, data.pic)
    self.name:setString(data.name)
    self.no_garrison:setVisible(false)

    self.effect:setVisible(false)
    if global.garrPanel.buildId == data.building_id and global.garrPanel.isOnEnter then
        self.effect:setVisible(true)
    end

    local num = 0
    self.effectNode:removeAllChildren()

    -- 初始化驻防数据
    if serData then
        
        if serData.tagBuffDetail then
            for i=1,2 do
                local buffs = serData.tagBuffDetail[i]
                if buffs then
                    local effectItem = UIGarrisonEffect.new()
                    effectItem:setPosition(25, -25*(i-1) - 10)
                    effectItem:setData(buffs)
                    self.effectNode:addChild(effectItem)
                    self["effectItem"..i]  = effectItem
                    num = i
                end
            end
            if num == 1 then
                self.effectItem1:setPositionY(-15)
            end
        else
            self.no_garrison:setVisible(true)
            self.no_garrison:setString(self:getBuffDetail())
        end

        self.total:setString(luaCfg:get_translate_string(10826, global.garrPanel:getInterior(serData)))
   
        for i=1,2 do

            self["garrisonState"..i]:setVisible(false)
            self["selectState"..i]:setVisible(false)
            local curHeroId = serData["lPos"..i]
            if curHeroId then
                self["garrisonState"..i]:setVisible(true)
                self:setGarrisonHero(serData, i)
            else
                self["selectState"..i]:setVisible(true)
                local isUnlock =  global.funcGame:checkTarget(data["unlock_level_"..i])
                self["unLockGray"..i]:setVisible(not isUnlock)
                self["addBtnS"..i]:setVisible(isUnlock)
                global.colorUtils.turnGray(self["Image_bg"..i], not isUnlock)
            end
        end
    end

end

function UIGarrisonItem:getBuffDetail()

    local parStr1,  parStr2, str = "", "", ""
    local num = 0
    if self.data.effect_1 and self.data.effect_1 ~= 0 then
        local typeData1 = luaCfg:get_data_type_by(self.data.effect_1)
        parStr1 = typeData1.paraName
        num = num + 1
    end

    if self.data.effect_2 and self.data.effect_2 ~= 0 then
        local typeData2 = luaCfg:get_data_type_by(self.data.effect_2)
        parStr2 = typeData2.paraName
        num = num + 1
    end

    if num == 1 then
        str = luaCfg:get_translate_string(10834, self.data.name, parStr1)
    else
        str = luaCfg:get_translate_string(10833, self.data.name, parStr1, parStr2)
    end
    return str

end

function UIGarrisonItem:setGarrisonHero(cityData, i)
    -- body
    local heroData = luaCfg:get_hero_property_by(cityData["lPos"..i])
    global.panelMgr:setTextureFor(self["pic"..i], heroData.nameIcon)
    self["hero_name"..i]:setString(heroData.name)
    self["lock"..i]:setVisible(cityData.lstate == 1)
    self["lockBg"..i]:setVisible(cityData.lstate == 1)
    self["giveup"..i.."Btn"]:setVisible(cityData.lstate ~= 1)
    self["hero_quality"..i]:setVisible(heroData.Strength == 3)
end

function UIGarrisonItem:selectHero1Handler(sender, eventType)

    
    local sPanel = global.panelMgr:getPanel("UICityGarrisonPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
        -- gsound.stopEffect("city_click")
    end
    if eventType == ccui.TouchEventType.ended then
        if sPanel.isPageMove then 
            return
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        local targetId = self.data.unlock_level_1
        local isUnlock = global.funcGame:checkTarget(targetId)
        if not isUnlock then
            local triggerData = luaCfg:get_target_condition_by(targetId)
            local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
            global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
            return
        else
            global.panelMgr:openPanel("UIGarrisonSelectPanel"):setData(self.data, 1)
        end

    end
end

function UIGarrisonItem:selectHero2Handler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UICityGarrisonPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
         -- gsound.stopEffect("city_click")
        if sPanel.isPageMove then 
            return
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        local targetId = self.data.unlock_level_2
        local isUnlock = global.funcGame:checkTarget(targetId)
        if not isUnlock then
            local triggerData = luaCfg:get_target_condition_by(targetId)
            local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
            global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
            return
        else
            global.panelMgr:openPanel("UIGarrisonSelectPanel"):setData(self.data, 2)
        end
    end
end


function UIGarrisonItem:giveUpHero1Handler(sender, eventType)


    local sPanel = global.panelMgr:getPanel("UICityGarrisonPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        -- gsound.stopEffect("city_click")
        if sPanel.isPageMove then 
            return
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        global.cityApi:setGarrison(function (msg)
        -- body
            global.tipsMgr:showWarning("fireSuccessful")
            global.heroData:updateVipHero(msg.tgHero[1])
            gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)

        end, self.data.building_id, 0, 1)

    end

end


function UIGarrisonItem:giveUpHero2Handler(sender, eventType)
    

    local sPanel = global.panelMgr:getPanel("UICityGarrisonPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        -- gsound.stopEffect("city_click")
        if sPanel.isPageMove then 
            return
        end
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        global.cityApi:setGarrison(function (msg)
        -- body
            global.tipsMgr:showWarning("fireSuccessful")
            global.heroData:updateVipHero(msg.tgHero[1])
            gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)

        end, self.data.building_id, 0, 2)

    end

end


function UIGarrisonItem:chooseHero(sender, eventType)

end

function UIGarrisonItem:chooseHero(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIGarrisonItem

--endregion

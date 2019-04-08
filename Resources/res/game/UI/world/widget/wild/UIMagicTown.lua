--region UIMagicTown.lua
--Author : untory
--Date   : 2016/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIMagicTownPro = require("game.UI.world.widget.wild.UIMagicTownPro")
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
local UIWildSoldier = require("game.UI.world.widget.wild.UIWildSoldier")
--REQUIRE_CLASS_END

local UIMagicTown  = class("UIMagicTown", function() return gdisplay.newWidget() end )

function UIMagicTown:ctor()
    self:CreateUI()
end

function UIMagicTown:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_bg")
    self:initUI(root)
end

function UIMagicTown:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)
    self.name = self.root.Node_export.name_export
    self.FileNode_1 = UIMagicTownPro.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.reward_hero_node = self.root.Node_export.recruit_title.reward_hero_node_export
    self.gift_icon = self.root.Node_export.recruit_title.reward_hero_node_export.gift_icon_export
    self.gift_icon = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_icon, self.root.Node_export.recruit_title.reward_hero_node_export.gift_icon_export)
    self.diamond_icon_sprite = self.root.Node_export.recruit_title.diamond_icon_sprite_export
    self.diaCurNum = self.root.Node_export.recruit_title.diaCurNum_export
    self.reward3 = self.root.Node_export.recruit_title.reward3_export
    self.reward_card = self.root.Node_export.recruit_title_0.reward_card_export
    self.a1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.reward4 = self.root.Node_export.recruit_title_0.reward4_export
    self.level = self.root.Node_export.level_mlan_8.level_export
    self.attack = self.root.Node_export.attack_export
    self.tp = self.root.Node_export.tp_export
    self.reward = self.root.Node_export.reward_export
    self.attack_detail = self.root.Node_export.attack_detail_export
    self.collection = self.root.Node_export.collection_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.tp, function(sender, eventType) self:tpHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.reward, function(sender, eventType) self:rewardHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    self.gift_icon:hideName()
    self.gift_icon:openLongTipsControl()
    --uiMgr:addWidgetTouchHandler(self.close_node.close_btn_export, function(sender, eventType) self:close_call(sender, eventType) end)
      self.close_node:setData(function ()
        global.panelMgr:closePanel("UIMagicTown")
    end)
end

function  UIMagicTown:close_call(sender, eventType)
    global.panelMgr:closePanel("UIMagicTown")
end

function UIMagicTown:getWorldCamp(campType)
    
    local world_camp = luaCfg:world_miracle()

    for _,v in ipairs(world_camp) do

        if v.type == campType then

            return v
        end
    end
end

function UIMagicTown:setData( data , city , isNeedCheckClose )
    
     
    self.city = city
    self.data = data

    local g_worldview = global.g_worldview
    local world_camp_data = self:getWorldCamp(data.lType) or {}
    self.world_camp_data = world_camp_data
    local meter = g_worldview.const:converPix2Location(cc.p(data.lPosx,data.lPosy))

    local sname = global.luaCfg:get_all_miracle_name_by(data.lMapID)
    self.sname = sname
    if sname then
        self.name:setString(string.format("%s(%s,%s)",sname.name,meter.x,meter.y))
    else
        self.name:setString(string.format("%s(%s,%s)",world_camp_data.name,meter.x,meter.y))
    end
    self.FileNode_1:setData(world_camp_data,data,self.city:getSurfaceData(),self.city)
    self.level:getParent():setVisible(false)
    self.level:setString(world_camp_data.reqLv)

    self.level:getParent():setLocalZOrder(1)

    if isNeedCheckClose then

        if data.lCurHp == world_camp_data.hp then

            
            global.panelMgr:closePanel("UIMagicTown")
        elseif data.lCurHp == 0 then

            
            global.panelMgr:closePanel("UIMagicTown")
        end
    end

    global.tools:adjustNodePosForFather(self.level:getParent(),self.level)


    self:setType(self.data.lType,self.sname)
end


function UIMagicTown:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end

function UIMagicTown:setType(magicType,sname)
    
    self.magicType = magicType

    local cfgData = self:getRewardData(magicType) or {} 
    local league1 = cfgData.league1
    local league1Cfg = luaCfg:get_data_type_by(league1[1])
    local league1count = league1[2]


    -- uiMgr:setRichText(self, "first_reward", 50101, {num = cfgData.firstOccupy})
    self.diaCurNum:setString(cfgData.firstOccupy)
    -- uiMgr:setRichText(self, "card_reward", 50214, {num = cfgData.maxReward})

    -- self.reward1:setString(string.format("%s+%s%s",league1Cfg.paraName,league1count,league1Cfg.str))
    -- self.reward1:setString(string.format("%s: +%s%s",league1Cfg.paraName,league1count,league1Cfg.extra))
    self.reward3:setString(string.format("+%s/h",league1count))

    local league2 = cfgData.league2
    local league2Cfg = luaCfg:get_data_type_by(league2[1])
    local league2count = league2[2]

    -- self.reward2:setString(string.format("%s: +%s%s",league2Cfg.paraName,league2count,league2Cfg.extra))
    self.reward_card:setString(string.format("+%s/24h",cfgData.maxReward))
    self.reward4:setString(string.format("+%s/h",league2count))

    local person = cfgData.person
    local itemData = luaCfg:get_item_by(person)
    local soldierId = itemData.typePara1
    local soldierData = luaCfg:get_soldier_property_by(soldierId)    

    if #sname.reward == 1 then

        self.gift_icon:setId(sname.reward[1][1],sname.reward[1][2])
        self.reward_hero_node:setVisible(true)
    else
        self.reward_hero_node:setVisible(false)
    end

    self.a1:setDataNotWild(soldierId)
    self.a1:showName(false)

    -- self.atk_num:setString(soldierData.atk)
    -- self.dPower_num:setString(soldierData.dPower)
    -- self.itfDef_num:setString(soldierData.iftDef)
    -- self.acrDef_num:setString(soldierData.acrDef)
    -- self.cvlDef_num:setString(soldierData.cvlDef)
    -- self.magDef_num:setString(soldierData.magDef)
    -- self.speed_num:setString(soldierData.speed)
    -- self.perPop_num:setString(soldierData.perPop)
    -- self.capacity_num:setString(soldierData.capacity)
    -- self.perRes_num:setString(soldierData.perRes)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIMagicTown:flushContent()
    
    global.worldApi:getMagicTownInfo(self.data.lMapID,function(msg)
        
        msg.lType = self.data.lType
        self:setData(msg,self.city,true)
    end)
end

function UIMagicTown:onEnter()
    
    local callBB = function(event,id)

        if self.data.lMapID == id then
        
            self:flushContent()
        end        
    end

    self:addEventListener(gameEvent.EV_ON_MONSTER_CAMP,callBB)
end

function UIMagicTown:collectionHandler(sender, eventType)

    local cityId = self.city:getId()
    if global.collectData:checkCollect(cityId) then

        local surfaceData = self.city:getSurfaceData()
        local szName = self.city:getName()
        local x, y = self.city:getPosition()
        local lMapID = surfaceData.id

        local tempData = {}
        tempData.lMapID = lMapID
        tempData.lPosX = x
        tempData.lPosY = y
        tempData.szName = szName

        local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
        collectPanel:setData( cityId, tempData)        
    else
        global.tipsMgr:showWarning("Collectionend")
    end
end

function UIMagicTown:militaryHandler(sender, eventType)
    
    if global.unionData:isMineUnion(0) then

        global.tipsMgr:showWarning("57")
        return
    end

    if self.city:isInProtect() then
        global.tipsMgr:showWarning("ProtectNot")
        return
    end


    local mainCityLv = global.cityData:getTopLevelBuild(1).serverData.lGrade or 0
    self.world_camp_data.reqLv = self.world_camp_data.reqLv or 0
    
    if mainCityLv < self.world_camp_data.reqLv then
        global.tipsMgr:showWarning("64")
        return
    end

    local afterCheckOccupyCall = function()

        global.troopData:setTargetData(2)           
        global.panelMgr:openPanel("UITroopPanel")
    end

    global.worldApi:checkOccupy(self.city, function(msg)
        if msg.lStatus == 0 then

            afterCheckOccupyCall()
        else
           
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("MaxOccupy",  afterCheckOccupyCall)
            panel:setCancelLabel(10948):setCancelCall(function()
                global.panelMgr:openPanel("UIUnionMiraclePanel")
            end) 
        end
    end)

        
end

function UIMagicTown:rewardHandler(sender, eventType)

    global.panelMgr:openPanel("UIMagicRewardPanel"):setData(self.data,self.world_camp_data,self.world_camp_data)
end

function UIMagicTown:exitCall(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIMagicTown")
end

function UIMagicTown:infoCall(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UIIntroducePanel")
    panel:setData(luaCfg:get_introduction_by(8))
end

function UIMagicTown:tpHandler(sender, eventType)
    if tolua.isnull(self.city) then return end
    if not global.unionData:isMineUnion(self.city:getCityOwnerAllyId()) then

        global.tipsMgr:showWarning("607")
        return
    end

    global.troopData:setTargetData(8)           
    global.panelMgr:openPanel("UITroopPanel")    
end

function UIMagicTown:shareHandler(sender, eventType)

    local x, y = self.city:getPosition()
    local posXY = global.g_worldview.const:converPix2Location(cc.p(x, y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)
    local lWildKind = self.city:getSurfaceData().mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.city:getName(), posX = x,posY = y,cityId = self.city:getId(),wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl) 
end
--CALLBACKS_FUNCS_END

return UIMagicTown

--endregion

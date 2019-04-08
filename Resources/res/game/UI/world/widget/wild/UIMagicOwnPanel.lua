local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMagicOwnPro = require("game.UI.world.widget.wild.UIMagicOwnPro")
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
local UIWildSoldier = require("game.UI.world.widget.wild.UIWildSoldier")
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIMagicOwnPanel  = class("UIMagicOwnPanel", function() return gdisplay.newWidget() end )

function UIMagicOwnPanel:ctor()
    self:CreateUI()
end

function UIMagicOwnPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_occupy_bg")
    self:initUI(root)
end

function UIMagicOwnPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_occupy_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_export
    self.FileNode_1 = UIMagicOwnPro.new()
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
    self.collection = self.root.Node_export.collection_export
    self.giveup = self.root.Node_export.giveup_export
    self.attack = self.root.Node_export.attack_export
    self.tp = self.root.Node_export.tp_export
    self.garrison = self.root.Node_export.garrison_export
    self.reward = self.root.Node_export.reward_export
    self.attack_detail = self.root.Node_export.attack_detail_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)
    self.collectionnew = self.root.Node_export.collectionnew_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.giveup, function(sender, eventType) self:giveUpCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.tp, function(sender, eventType) self:tpHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.garrison, function(sender, eventType) self:garCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.reward, function(sender, eventType) self:rewardHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collectionnew, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END
    
    self.gift_icon:hideName()
    self.gift_icon:openLongTipsControl()
     --uiMgr:addWidgetTouchHandler(self.close_node.close_btn_export, function(sender, eventType) self:close_call(sender, eventType) end)
    self.close_node:setData(function ()
        global.panelMgr:closePanel("UIMagicOwnPanel")
    end)
end

function  UIMagicOwnPanel:close_call(sender, eventType)
    global.panelMgr:closePanel("UIMagicOwnPanel")
end


function UIMagicOwnPanel:getWorldCamp(campType)
    
    local world_camp = luaCfg:world_miracle()

    for _,v in ipairs(world_camp) do

        if v.type == campType then

            return v
        end
    end
end

function UIMagicOwnPanel:setData(data,city)
    
--     [LUA-print] - ">>>>>>>>>>>>> ddd" = {
-- [LUA-print] -     "lAllyLv"      = 0
-- [LUA-print] -     "lAllyMember"  = 2
-- [LUA-print] -     "lMapID"       = 550812186
-- [LUA-print] -     "lPosx"        = 38515
-- [LUA-print] -     "lPosy"        = -26985
-- [LUA-print] -     "szAllyLeader" = "testleader"
-- [LUA-print] -     "szAllyName"   = "联盟3"
-- [LUA-print] -     "szOccupyName" = "穆得莉海伍德"
-- [LUA-print] - }


    self.city = city
    self.data = data

    -- if self.city.be_self_occupy and self.city:be_self_occupy() then

    --     self.giveup:setVisible(true)
    -- else

    --     self.giveup:setVisible(false)
    -- end

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
    self.FileNode_1:setData(world_camp_data,data,self.city)

    self:setType(self.data.lType,self.sname)
end

function UIMagicOwnPanel:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end

function UIMagicOwnPanel:upStar()
    self.FileNode_1:upStar()
    local plus = self.FileNode_1:getPlus()
    local cfgData = self.cfgData
    
    local league1 = cfgData.league1
    local league1Cfg = luaCfg:get_data_type_by(league1[1])
    local league1count = league1[2]

    local league2 = cfgData.league2
    local league2Cfg = luaCfg:get_data_type_by(league2[1])
    local league2count = league2[2]

    self.reward3:setString(string.format("+%s/h",league1count * plus))
    self.reward_card:setString(string.format("+%s/24h",cfgData.maxReward* plus))
    self.reward4:setString(string.format("+%s/h",league2count* plus))
end

function UIMagicOwnPanel:setType(magicType,sname)
    
    self.magicType = magicType

    local cfgData = self:getRewardData(magicType)
    if not cfgData then return end
    
    self.cfgData = cfgData

    local league1 = cfgData.league1
    local league1Cfg = luaCfg:get_data_type_by(league1[1])
    local league1count = league1[2]


    -- uiMgr:setRichText(self, "first_reward", 50101, {num = cfgData.firstOccupy})
    self.diaCurNum:setString(cfgData.firstOccupy)
    -- uiMgr:setRichText(self, "card_reward", 50214, {num = cfgData.maxReward})

    -- self.reward1:setString(string.format("%s+%s%s",league1Cfg.paraName,league1count,league1Cfg.str))
    -- self.reward1:setString(string.format("%s: +%s%s",league1Cfg.paraName,league1count,league1Cfg.extra))
    local plus = self.FileNode_1:getPlus()
    self.reward3:setString(string.format("+%s/h",league1count * plus))

    local league2 = cfgData.league2
    local league2Cfg = luaCfg:get_data_type_by(league2[1])
    local league2count = league2[2]

    -- self.reward2:setString(string.format("%s: +%s%s",league2Cfg.paraName,league2count,league2Cfg.extra))
    self.reward_card:setString(string.format("+%s/24h",cfgData.maxReward* plus))
    self.reward4:setString(string.format("+%s/h",league2count* plus))

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

function UIMagicOwnPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMagicOwnPanel:collectionHandler(sender, eventType)

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

function UIMagicOwnPanel:militaryHandler(sender, eventType)
    if self.city and self.city.isInProtect and self.city:isInProtect() then
        global.tipsMgr:showWarning("ProtectNot")
        return
    end

    if global.unionData:isMineUnion(0) and not ((self.city.be_self_occupy and self.city:be_self_occupy())) then

        global.tipsMgr:showWarning("57")
        return
    end
    
    local openCall = function()
        local attackBoard = UIAttackBoard.new()
        attackBoard:changeSharpPos(false,true)
        attackBoard:setCity(self.city)
        self.attack_detail:addChild(attackBoard)
        self.attack_detail:setLocalZOrder(2)
        self.attackBoard = attackBoard
    end

    local isSelfProect,endTime = global.g_worldview.worldPanel:isMainCityProtect()

    if isSelfProect then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        local str = global.troopData:timeStringFormat(endTime - global.dataMgr:getServerTime())
        panel:setData("ProtectPrompt", function()
                
            global.worldApi:removeProtection(function(msg)
                    
                openCall()
            end)
        end,str,global.luaCfg:get_config_by(1).protectCD / 60)
    else

        openCall()
    end
end

function UIMagicOwnPanel:rewardHandler(sender, eventType)

    global.panelMgr:openPanel("UIMagicRewardPanel"):setData(self.data,self.world_camp_data)
end

function UIMagicOwnPanel:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn("UIMagicOwnPanel")
end

function UIMagicOwnPanel:infoCall(sender, eventType)

    local panel = global.panelMgr:openPanel("UIIntroducePanel")
    panel:setData(luaCfg:get_introduction_by(8))
end

function UIMagicOwnPanel:giveUpCall(sender, eventType)

    if not (self.city.be_self_occupy and self.city:be_self_occupy()) then

        global.tipsMgr:showWarning('garrisonGiveUp')
        return
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("GiveUpOppucy", function()
        
        global.worldApi:giveupOcc(self.city:getId(),function()
                    
            global.panelMgr:closePanel("UIMagicOwnPanel")
            global.tipsMgr:showWarning("GiveUpMiracle")
        end)    
    end)
end

function UIMagicOwnPanel:tpHandler(sender, eventType)
    if tolua.isnull(self.city) then return end
    if not global.unionData:isMineUnion(self.city:getCityOwnerAllyId()) then

        global.tipsMgr:showWarning("607")
        return
    end

    global.troopData:setTargetData(8)           
    global.panelMgr:openPanel("UITroopPanel")    
end

function UIMagicOwnPanel:shareHandler(sender, eventType)
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

function UIMagicOwnPanel:garCall(sender, eventType)
    
    if self.city.tir_garrison and self.city:tir_garrison() then
        global.worldApi:villageTroop(self.city:getId(), function(msg)

            local garrPanel = global.panelMgr:openPanel("UIGarrisonPanel") 
            garrPanel:setData(self.city:getId(), msg.tgTroop) 
            if self.close then 
                self:close()
            end 
        end)
    else
        global.tipsMgr:showWarning('troopsAll02')
    end    
end
--CALLBACKS_FUNCS_END

return UIMagicOwnPanel

--endregion

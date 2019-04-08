--region UIWildMonsterPanel.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIWildItem = require("game.UI.world.widget.wild.UIWildItem")
--REQUIRE_CLASS_END

local UILongTipsControl = require("game.UI.common.UILongTipsControl")

local UIWildMonsterPanel  = class("UIWildMonsterPanel", function() return gdisplay.newWidget() end )

function UIWildMonsterPanel:ctor()
    self:CreateUI()
end

function UIWildMonsterPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_monster")
    self:initUI(root)
end

function UIWildMonsterPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_monster")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.content.Node_5.name_export
    self.attack = self.root.Node_export.content.Node_5.attack_export
    self.time_node = self.root.Node_export.content.Node_5.time_node_mlan_5_export
    self.time = self.root.Node_export.content.Node_5.time_node_mlan_5_export.time_export
    self.Battle = self.root.Node_export.content.Battle_mlan_6.Battle_export
    self.type = self.root.Node_export.content.type_mlan_5.type_mlan_3_export
    self.exp = self.root.Node_export.content.exp_mlan_5.exp_export
    self.consume = self.root.Node_export.content.consume_mlan_5.consume_export
    self.itemNode1 = self.root.Node_export.content.city_bj_new_2.itemNode1_export
    self.itemNode1 = UIWildItem.new()
    uiMgr:configNestClass(self.itemNode1, self.root.Node_export.content.city_bj_new_2.itemNode1_export)
    self.itemNode2 = self.root.Node_export.content.city_bj_new_2.itemNode2_export
    self.itemNode2 = UIWildItem.new()
    uiMgr:configNestClass(self.itemNode2, self.root.Node_export.content.city_bj_new_2.itemNode2_export)
    self.itemNode3 = self.root.Node_export.content.city_bj_new_2.itemNode3_export
    self.itemNode3 = UIWildItem.new()
    uiMgr:configNestClass(self.itemNode3, self.root.Node_export.content.city_bj_new_2.itemNode3_export)
    self.itemNode4 = self.root.Node_export.content.city_bj_new_2.itemNode4_export
    self.itemNode4 = UIWildItem.new()
    uiMgr:configNestClass(self.itemNode4, self.root.Node_export.content.city_bj_new_2.itemNode4_export)
    self.txt = self.root.Node_export.content.city_bj_new_2.txt_mlan_8_export
    self.txtnew = self.root.Node_export.content.city_bj_new_2.txtnew_mlan_30_export
    self.text = self.root.Node_export.content.city_bj_new_2.text_export
    self.arms = self.root.Node_export.content.arms_mlan_5.arms_export
    self.combat = self.root.Node_export.content.combat_mlan_10.combat_export
    self.Image = self.root.Node_export.content.Image_export
    self.collection = self.root.Node_export.content.collection_export
    self.attack_detail = self.root.Node_export.attack_detail_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:attack_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.tipsControl = UILongTipsControl.new(self.Image,WCONST.LONG_TIPS_PANEL.WILD_OBJ)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWildMonsterPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UNIONBOSS_MISS, function ()
        if self.onCloseHandler and self.data and self.data.lBelongsType == 2 then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if not global.guideMgr:isPlaying() then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.onCloseHandler then
            self:onCloseHandler()
        end
    end)
end

function UIWildMonsterPanel:setData(data)

    if not data then return end        

    self.data = data
    local wildData = luaCfg:get_wild_monster_by(data.lKind)
    self.wildData = wildData

    self.tipsControl:setData({kindType = data.lKind})    

    self.Battle:setString(self:getBattleInfo(data))
    self.type:setString(wildData.typename)
    self.exp:setString(wildData.exp)
    self.consume:setString(wildData.energy)
    self.combat:setString(wildData.combat)

    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))
    self.name:setString(string.format("%s(%s,%s)",wildData.name,pos.x,pos.y))

    local surfaceData = luaCfg:get_world_surface_by(wildData.file)
    -- self.Image:setSpriteFrame(surfaceData.uimap)
    global.panelMgr:setTextureFor(self.Image,surfaceData.uimap)
    self.Image:setScale(surfaceData.UISize)

    self.arms:setString(luaCfg:get_local_string(wildData.wartype + 10684))

    if wildData.sort==2 then
        for i=1,4 do
            self["itemNode"..i]:setVisible(false)
        end
        self.txt:setVisible(false)
        self.txtnew:setVisible(true)
        self.text:setVisible(true)

        self.text:setString(global.luaCfg:get_local_string(wildData.text))
        self.txtnew:setString(global.luaCfg:get_local_string(10639,wildData.scale))
    else
        self.txt:setVisible(true)
        self.txtnew:setVisible(false)
        self.text:setVisible(false)
        for i=1,4 do
            self["itemNode"..i]:setVisible(true)
            if wildData.seeitem[i] then
                local itemData = luaCfg:get_item_by(wildData.seeitem[i]) or luaCfg:get_equipment_by(wildData.seeitem[i])
                -- self["itemNode"..i].icon:setSpriteFrame(itemData.itemIcon or itemData.icon)
                -- self["itemNode"..i].quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
                
                global.panelMgr:setTextureFor(self["itemNode"..i].icon,itemData.itemIcon or itemData.icon)
                global.panelMgr:setTextureFor(self["itemNode"..i].quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))
                self["itemNode"..i].itemName:setString(itemData.itemName or itemData.name)
                local tempdata ={information= itemData}
                tempdata.tips_node = self.tips_node
                self["itemNode"..i]:setData(tempdata)
            end
        end
    end

    global.g_worldview.worldPanel.chooseCityId = self.data.lMonsterID
    global.g_worldview.worldPanel.chooseCityName = self.wildData.name

    if data.lDisapperTime then
        self.time_node:setVisible(true)
        self.collection:setVisible(false)
    else
        self.time_node:setVisible(false)
        self.collection:setVisible(true)
    end    

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime() 
    end, 1)

    self:checkTime()


    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.Battle:getParent(),self.Battle)
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.exp:getParent(),self.exp)
    global.tools:adjustNodePosForFather(self.consume:getParent(),self.consume)
    global.tools:adjustNodePosForFather(self.combat:getParent(),self.combat)
    --global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
    global.tools:adjustNodePosForFather(self.arms:getParent(),self.arms)
    
    -- self.m_TipsControl2:setdata(self.Image,surfaceData,self.Image)
end
 

function UIWildMonsterPanel:checkTime()
   
    if self.data.lDisapperTime then
        local times = self.data.lDisapperTime - global.dataMgr:getServerTime()
        if times < 0 then times = 0 end
        self.time:setString(global.funcGame.formatTimeToHMS(times))
    end    
end

function UIWildMonsterPanel:onExit()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)        
    end
end

function UIWildMonsterPanel:getBattleInfo(data)
    
    local num = 0
    if data.tagAtkSoldiers then
        for _,v in pairs(data.tagAtkSoldiers) do
            
            local soldierData = luaCfg:get_wild_property_by(v.lID)
            if soldierData then
                num = num + soldierData.combat*v.lValue
            end
        end
    end 
    if data.tagDefSoldiers then
         for _,v in pairs(data.tagDefSoldiers) do 
            
            local soldierData = luaCfg:get_wild_property_by(v.lID)
            if soldierData then
                num = num + soldierData.combat*v.lValue
            end
        end
    end 
    return num
end

function UIWildMonsterPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIWildMonsterPanel")
end

function UIWildMonsterPanel:checkEnergy()
    
    if self.wildData.energy > global.userData:getCurHp() then
        return false
    else
        return true
    end
end

function UIWildMonsterPanel:attack_click(sender, eventType)

    if global.cityData:getMainCityLevel() + 1 < self.wildData.level then

        global.tipsMgr:showWarning('600',global.cityData:getMainCityLevel() + 1)
        return
    end

    local attackHandle = function()
        -- 检查体力
        if not self:checkEnergy() then
            global.panelMgr:openPanel("UIBuyEnergyPanel"):setData(handler(self, self.checkEnergy), true)
            return
        end
        if not global.funcGame:checkBelong(self.data) then

            if self.data.lBelongsType then

                if self.data.lBelongsType == 1 or self.data.lBelongsType == 3 or self.data.lBelongsType == 6 then

                    global.tipsMgr:showWarning("wildNoAttack")
                elseif self.data.lBelongsType == 2 then
                    
                    global.tipsMgr:showWarning("Uniontask05")
                end 
            end
            
            return
        end

        global.troopData:setTargetCombat(self.wildData.combat) 
        global.troopData:setTargetWarType(self.wildData.wartype)

        global.troopData:setTargetData(2) 

        global.troopData:setTargetMonsterType(luaCfg:get_wild_monster_by(self.data.lKind).type)

        global.panelMgr:openPanel("UITroopPanel") 
    end

    if luaCfg:get_wild_monster_by(self.data.lKind).type == 401 then  -- 经验之泉 

       global.ActivityAPI:ActivityListReq({2001},function(ret ,msg)

            if msg and msg.tagAct and msg.tagAct[1] and  msg.tagAct[1].lStatus == 1 and msg.tagAct[1].lParam  then --如果攻打 经验之泉次数 大于 配置的数量 则 弹出提示。 

                local attacked_count =  msg.tagAct[1].lParam 

                local attack_count = luaCfg:get_wild_cfg_by(8).cfg

                local surplus_count = attack_count - attacked_count

                if  surplus_count <= 0 then 

                    local panel = global.panelMgr:openPanel("UIPromptPanel")

                    panel:setData("exp_spring_atk",attackHandle)
                else

                    attackHandle()
                end 
            else 
                attackHandle()
            end 
        end)
    else
        attackHandle()
    end 
end

function UIWildMonsterPanel:collect_click(sender, eventType)

    local cityId = self.data.lMonsterID
    if global.collectData:checkCollect(cityId) then

        local tempData = {}
        tempData.lMapID = self.wildData.file
        tempData.lPosX = self.data.lPosX
        tempData.lPosY = self.data.lPosY
        tempData.szName = self.wildData.name

        local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
        collectPanel:setData( cityId, tempData)
    else
        global.tipsMgr:showWarning("Collectionwild")
    end
end

function UIWildMonsterPanel:infoCall(sender, eventType)
    
    local data = luaCfg:get_introduction_by(30)
    if self.wildData.file == 6002 then --英魂祭坛
        data = luaCfg:get_introduction_by(32)
    end
    
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIWildMonsterPanel:shareHandler(sender, eventType)
    local x = self.data.lPosX
    local y = self.data.lPosY
    local posXY = global.g_worldview.const:converPix2Location(cc.p(x, y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)

    local surfaceData = luaCfg:get_world_surface_by(self.wildData.file) 
    local lWildKind = surfaceData.mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.wildData.name, posX = x,posY = y,cityId = self.data.lMonsterID,wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl) 
end
--CALLBACKS_FUNCS_END

return UIWildMonsterPanel

--endregion

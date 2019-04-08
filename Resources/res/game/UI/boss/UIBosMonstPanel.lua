--region UIBosMonstPanel.lua
--Author : yyt
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIWildItem = require("game.UI.world.widget.wild.UIWildItem")
--REQUIRE_CLASS_END
local UILongTipsControl = require("game.UI.common.UILongTipsControl")

local UIBosMonstPanel  = class("UIBosMonstPanel", function() return gdisplay.newWidget() end )

function UIBosMonstPanel:ctor()
    self:CreateUI()
end

function UIBosMonstPanel:CreateUI()
    local root = resMgr:createWidget("boss/boss_monster")
    self:initUI(root)
end

function UIBosMonstPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_monster")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.content.Node_5.name_export
    self.attack = self.root.Node_export.content.Node_5.attack_export
    self.time_node = self.root.Node_export.content.Node_5.time_node_mlan_4_export
    self.time = self.root.Node_export.content.Node_5.time_node_mlan_4_export.time_export
    self.Refresh = self.root.Node_export.content.Node_5.Refresh_export
    self.Battle = self.root.Node_export.content.Battle_mlan_6.Battle_export
    self.type = self.root.Node_export.content.type_mlan_5.type_export
    self.exp = self.root.Node_export.content.exp_mlan_5.exp_export
    self.armsT = self.root.Node_export.content.armsT_mlan_5_export
    self.arms = self.root.Node_export.content.armsT_mlan_5_export.arms_export
    self.armsLimT = self.root.Node_export.content.armsLimT_mlan_5_export
    self.armsLim = self.root.Node_export.content.armsLimT_mlan_5_export.armsLim_export
    self.consume = self.root.Node_export.content.consume_mlan_6.consume_export
    self.Node_Normal1 = self.root.Node_export.content.Node_Normal1_export
    self.itme = self.root.Node_export.content.Node_Normal1_export.itme_mlan_5.itme_export
    self.star2 = self.root.Node_export.content.Node_Normal1_export.itme_mlan_5.star2_export
    self.warTitle = self.root.Node_export.content.Node_Normal1_export.warTitle_mlan_5_export
    self.war = self.root.Node_export.content.Node_Normal1_export.warTitle_mlan_5_export.war_export
    self.star1 = self.root.Node_export.content.Node_Normal1_export.warTitle_mlan_5_export.star1_export
    self.Node_Normal2 = self.root.Node_export.content.Node_Normal2_export
    self.scale = self.root.Node_export.content.Node_Normal2_export.scale_mlan_5_export
    self.scaleNum = self.root.Node_export.content.Node_Normal2_export.scale_mlan_5_export.scaleNum_export
    self.heroPower = self.root.Node_export.content.Node_Normal2_export.heroPower_mlan_5_export
    self.heroPower = self.root.Node_export.content.Node_Normal2_export.heroPower_mlan_5_export.heroPower_export
    self.troopNumT = self.root.Node_export.content.Node_Normal2_export.troopNumT_mlan_7_export
    self.troopNum = self.root.Node_export.content.Node_Normal2_export.troopNumT_mlan_7_export.troopNum_export
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
    self.txt = self.root.Node_export.content.city_bj_new_2.txt_mlan_10_export
    self.txtnew = self.root.Node_export.content.city_bj_new_2.txtnew_mlan_30_export
    self.text = self.root.Node_export.content.city_bj_new_2.text_export
    self.Image = self.root.Node_export.content.Image_export
    self.killStar = self.root.Node_export.content.killStar_export
    self.star3 = self.root.Node_export.content.killStar_export.star3_export
    self.attack_detail = self.root.Node_export.attack_detail_export
    self.tips_text = self.root.Node_export.tips_text_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:attack_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Refresh, function(sender, eventType) self:refershHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.timeNodePosX = self.time_node:getPositionX()
    self.tipsControl = UILongTipsControl.new(self.Image,WCONST.LONG_TIPS_PANEL.WILD_OBJ)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBosMonstPanel:onEnter()

    self.isBossItem = false
    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_MISS, function ()
        if not global.guideMgr:isPlaying() then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if not global.guideMgr:isPlaying() then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if not global.guideMgr:isPlaying() then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, function (event, msg)
        if self.setData then
            local data = global.bossData:getDataById(self.data.id or 0)
            self:setData(data or {})
        end
    end)

end

function UIBosMonstPanel:setData(data, worldData, isLock)

    -- 当前关卡是否解锁
    self.isLock = isLock

    if data then 
        dump(data, " --->　UIBosMonstPanel data: ")
    end

    if worldData then 
        dump(worldData, "　---> UIBosMonstPanel worldData: ")
        global.g_worldview.worldPanel.chooseCityId = worldData.lMonsterID
    end

    self.data = data or {}
    self.worldData = worldData 
    if not self.data.id and worldData then 
        self.data.id = worldData.lBind or 1
    end
    local gateData = luaCfg:get_gateboss_by(self.data.id) 
    if not gateData then return end

    self.armsT:setVisible(gateData.Elite == 1)
    self.armsLimT:setVisible(gateData.Elite ~= 1)
    self.Node_Normal1:setVisible(gateData.Elite == 1)
    self.Node_Normal2:setVisible(gateData.Elite ~= 1)
    self.troopNum:setString(gateData.troops or 0)

    self.warTitle:setString(luaCfg:get_local_string(gateData.Elite + 10994))
    self.armsLim:setString(gateData.herotype)
    self.heroPower:setString(gateData.heroPower)

    self.gateData = gateData 
    local wildData = luaCfg:get_wild_monster_by(gateData.monsterID)

    self.tipsControl:setData({kindType = gateData.monsterID})    

    self.wildData = wildData
    self.scaleNum:setString(gateData.StarsScale)
    self.war:setString(gateData.StarsScale)
    self.itme:setString(global.funcGame.formatTimeToHMS(gateData.StarsTime))
    self.type:setString(wildData.typename)
    self.exp:setString(wildData.exp)
    self.name:setString(wildData.name)
    self.Battle:setString(self:getBattleInfo())
    self.consume:setString(wildData.bossCost)

    local surfaceData = luaCfg:get_world_surface_by(wildData.file)
    global.panelMgr:setTextureFor(self.Image,surfaceData.uimap)

    self.Image:setScale(surfaceData.UISize)
    self.arms:setString(gateData.intro) 
    
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
                local itemData = luaCfg:get_item_by(wildData.seeitem[i]) 
                if not itemData then
                    itemData = luaCfg:get_equipment_by(wildData.seeitem[i])
                end
                global.panelMgr:setTextureFor(self["itemNode"..i].quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))
                global.panelMgr:setTextureFor(self["itemNode"..i].icon,itemData.itemIcon or itemData.icon)
                self["itemNode"..i].itemName:setString(itemData.itemName or itemData.name)
                 local tempdata ={information= itemData}
                tempdata.tips_node = self.tips_node
                self["itemNode"..i]:setData(tempdata, gateData.monsterID)
            end
        end
    end

    -- boss消失时间
    self.lDisapperTime = -1
    if worldData then
        self.lDisapperTime = worldData.lDisapperTime or -1
    elseif data.serverData then
        self.lDisapperTime = data.serverData.lDisapperTime or -1
    end

    if self.lDisapperTime > 0 and (not self.isLock) then
        self.time_node:setVisible(true)
        if not self.scheduleListenerId then
            self.scheduleListenerId = gscheduler.scheduleGlobal(function()
                if self.checkTime then
                    self:checkTime() 
                end
            end, 1)
        end
        self:checkTime()
    else
        self.time_node:setVisible(false)
        
        if self.scheduleListenerId then
            gscheduler.unscheduleGlobal(self.scheduleListenerId) 
            self.scheduleListenerId = nil      
        end
    end    

    -- 按钮状态
    self:currBtnState()

    -- boss 过关星级
    self:starPass(data, gateData)


    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.Battle:getParent(),self.Battle)
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.exp:getParent(),self.exp)
    global.tools:adjustNodePosForFather(self.consume:getParent(),self.consume)
    global.tools:adjustNodePosForFather(self.war:getParent(),self.war)
    global.tools:adjustNodePosForFather(self.scaleNum:getParent(),self.scaleNum)
    global.tools:adjustNodePosForFather(self.heroPower:getParent(),self.heroPower)
    global.tools:adjustNodePosForFather(self.itme:getParent(),self.itme)
    global.tools:adjustNodePosForFather(self.arms:getParent(),self.arms)
    global.tools:adjustNodePosForFather(self.armsLim:getParent(),self.armsLim)
    
end

function UIBosMonstPanel:starPass(data, gateData)
    
    self.killStar:setVisible(false)
    self.star1:setVisible(false)
    self.star2:setVisible(false)

    if self.isBossItem and self.gateData.Elite == 1 then
        
        
        self.star1:setVisible(true)
        self.star2:setVisible(true)
        local curScale    = 0
        local curPathTime = 0
        local curPassTime = 0
        if data.serverData then
            curScale = data.serverData.lPathPower or 0
            curPathTime = data.serverData.lDuration or 0
            curPassTime = data.serverData.lPathTime or 0
        end

        if curScale > 0 and curScale <= gateData.StarsScale then
            global.colorUtils.turnGray(self.star1, false)
        else
            global.colorUtils.turnGray(self.star1, true)
        end
        if curPathTime > 0 and curPathTime <= gateData.StarsTime then
            global.colorUtils.turnGray(self.star2, false)
        else
            global.colorUtils.turnGray(self.star2, true)
        end
        if curPassTime > 0 then
            self.killStar:setVisible(true)
        end
    end

end

function UIBosMonstPanel:currBtnState()
    
    if self.worldData then
        self.time_node:setAnchorPoint(cc.p(0.8, 0.5))
        self.time_node:setPositionX(self.timeNodePosX)
        self.attack:setVisible(not self.isLock) 
        self.Refresh:setVisible(false)
    else
        self.time_node:setAnchorPoint(cc.p(1, 0.5))
        self.time_node:setPositionX(gdisplay.width/2)
        self.attack:setVisible(false)
        if self.data.serverData and self.lDisapperTime > 0 then
            self.Refresh:setVisible(false)
        else
            self.Refresh:setVisible(not self.isLock)
        end
    end

    self.tips_text:setString(global.luaCfg:get_errorcode_by("225").text)
    self.tips_text:setVisible(self.isLock)
    self.time_node:setString(luaCfg:get_local_string(10545))
end

function UIBosMonstPanel:checkTime()
   
    local times = self.lDisapperTime - global.dataMgr:getServerTime()
    if times < 0 then 

        if self.scheduleListenerId then
            gscheduler.unscheduleGlobal(self.scheduleListenerId) 
            self.scheduleListenerId = nil      
        end

        if global.g_worldview and global.g_worldview.mapPanel then

            -- 如果怪物还在战斗中
            if self.worldData and global.g_worldview.mapPanel:getWildObjById(self.worldData.lMonsterID) ~= nil then
                self.time_node:setString(luaCfg:get_local_string(10100))
                self.time:setString("")
            else     
                gevent:call(global.gameEvent.EV_ON_UI_BOSS_MISS)
            end
        else

            if global.g_cityView:getBossMgr():isExitBoss() then
                self.time_node:setString(luaCfg:get_local_string(10100))
                self.time:setString("")
            end
        end
        return
    end
    self.time:setString(global.funcGame.formatTimeToHMS(times))    
end

function UIBosMonstPanel:checkBossCost()
    
    if not self.wildData then 
         -- protect 
        return
    end
    
    if self.wildData.bossCost > global.userData:getGateEnergy() then
        return false
    else
        return true
    end
end

function UIBosMonstPanel:attack_click(sender, eventType)

    -- 检查挑战令
    if not self:checkBossCost() then
        global.panelMgr:openPanel("UIBossEnergyPanel"):setData(handler(self, self.checkBossCost))
        return
    end
 
    if not global.funcGame:checkBelong(self.worldData) then

        if self.worldData.lBelongsType then
            if self.worldData.lBelongsType == 1 or self.worldData.lBelongsType == 3 or self.worldData.lBelongsType == 6 then

                global.tipsMgr:showWarning("wildNoAttack")
            elseif self.worldData.lBelongsType == 2 then
                
                global.tipsMgr:showWarning("Uniontask05")
            end 
        end
        return
    end

    if global.troopData:checkBossTroop(self.worldData.lMonsterID) and self.gateData.Elite ~= 1 then
        return global.tipsMgr:showWarning("troopMaxGateBoss") -- 极限boss判断是否已达到部队上限
    end

    local gateData = luaCfg:get_gateboss_by(self.worldData.lBind)
    local wildData = luaCfg:get_wild_monster_by(gateData.monsterID) or {}
    global.troopData:setTargetData(2, 0, self.worldData.lMonsterID, wildData.name or "")      
    global.troopData:setTargetWarType(self.wildData.wartype)
    if self.gateData.Elite ~= 1 then
        global.troopData:setTargetCheckData({checkType=1, checkData=self.worldData.lBind})
    end
    global.panelMgr:openPanel("UITroopPanel")

end

function UIBosMonstPanel:refershHandler(sender, eventType)
  
    if not self.data then
        -- 防止报错 -- 保护处理
        return
    end 
    
    global.worldApi:bossRefersh(self.data.id, function (msg)
    
        global.troopData:setNewMonsterId(msg.lMapID)
        global.funcGame:gpsWorldPos(cc.p(msg.lPosx, msg.lPosy))
        global.bossData:refershBoss(msg, self.data.id)
        gevent:call(global.gameEvent.EV_ON_UI_BOSS_FLUSH)
    end)    
end

function UIBosMonstPanel:getBattleInfo()
    
    local attackData = nil
    if self.worldData then
        attackData = self.worldData
    elseif self.data.serverData then
        attackData = self.data.serverData
    end

    local num = 0
    if attackData and attackData.tagAtkSoldiers then
        for _,v in pairs(attackData.tagAtkSoldiers) do
            
            local soldierData = luaCfg:get_wild_property_by(v.lID)
            if soldierData then
                num = num + soldierData.combat*v.lValue
            end
        end
    end 
    if attackData and attackData.tagDefSoldiers then
         for _,v in pairs(attackData.tagDefSoldiers) do 
            
            local soldierData = luaCfg:get_wild_property_by(v.lID)
            if soldierData then
                num = num + soldierData.combat*v.lValue
            end
        end
    end 

    -- 如果初始值没有守卫战斗力数值
    if num == 0 then
        num = self:getInitCombat()
    end

    return num
end

function UIBosMonstPanel:getInitCombat()
    
    local soldier = {}

    local gateData = luaCfg:get_gateboss_by(self.data.id)
    local wildData = luaCfg:get_wild_monster_by(gateData.monsterID)

    local soldierData = {}
    local insertCall = function (soldierIdData, soldierNumData, key)

        for i,v in ipairs(soldierIdData) do
            
            local temp = {}
            temp.k = i+key
            temp.lID = v
            temp.num = 0
            table.insert(soldierData, temp)
        end
        for i,v in ipairs(soldierNumData) do
            
            if (i+key) == soldierData[i+key].k then
                soldierData[i+key].num = v
            end
        end
    end

    insertCall(wildData.defensesoldier or {}, wildData.defensesoldiernum or {}, 0)
    insertCall(wildData.attacksoldier or {}, wildData.attacksoldiernum or {}, (#wildData.defensesoldier))

    local num = 0
    for _,v in pairs(soldierData) do 
        
        local wildPro = luaCfg:get_wild_property_by(v.lID)
        if wildPro then
            num = num + wildPro.combat*v.num
        end
    end
   
    return num
end

function UIBosMonstPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIBosMonstPanel")
end

function UIBosMonstPanel:onExit()
    
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId) 
        self.scheduleListenerId = nil      
    end
end
--CALLBACKS_FUNCS_END

return UIBosMonstPanel

--endregion

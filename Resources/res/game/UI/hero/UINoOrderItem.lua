--region UINoOrderItem.lua
--Author : yyt
--Date   : 2017/06/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINoOrderItem  = class("UINoOrderItem", function() return gdisplay.newWidget() end )

function UINoOrderItem:ctor()
    self:CreateUI()
end

function UINoOrderItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_NoOrder")
    self:initUI(root)
end

function UINoOrderItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_NoOrder")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.NodeAll = self.root.NodeAll_export
    self.icon = self.root.NodeAll_export.icon_export
    self.name = self.root.NodeAll_export.name_export
    self.Button_1 = self.root.NodeAll_export.Button_1_export
    self.grayBg = self.root.NodeAll_export.Button_1_export.grayBg_export
    self.des = self.root.NodeAll_export.Button_1_export.des_export
    self.buy = self.root.NodeAll_export.buy_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:jump_call(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.buy, function(sender, eventType) self:jump_call(sender, eventType) end, true)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UINoOrderItem:setData(data)
    -- body
    self.data = data
    
    self.isUnlock = true
    self.icon:setOpacity(255)
    global.colorUtils.turnGray(self.grayBg, false)
    self.icon:setScale(0.88)

    self.des:setString(gls(10014))

    self.Button_1:setVisible(true)
    self.buy:setVisible(false)

    local forgeData = global.noOrderPanel.forgeData
    self.enterWay   = global.noOrderPanel.enterWay
    self.heroWay   = global.noOrderPanel.heroWay

    if self.heroWay then 

        self.icon:setScale(self.data.scale or 1 )

        global.panelMgr:setTextureFor(self.icon, self.data.pic)
        self.name:setString(self.data.type)

    elseif forgeData and not self.enterWay then

        if type(self.data) =="table" then  -- 商城购买

            self.des:setString(gls(11103))

            self.Button_1:setVisible(false)
            self.buy:setVisible(true)

            global.panelMgr:setTextureFor(self.icon,data.pic)
            self.name:setString(data.type)

        else 

            self.forgeData = forgeData
            local bossData = luaCfg:get_gateboss_by(data)
            local wild = luaCfg:get_wild_monster_by(bossData.monsterID)
            local wildData = luaCfg:get_world_surface_by(wild.file)
            self.wildData = wildData
            global.panelMgr:setTextureFor(self.icon, wildData.uimap)
            self.name:setString(luaCfg:get_local_string(10749 ,data))
            self:checkPass(data)
            self.icon:setScale(0.7)

        end 
    elseif not self.enterWay then
        global.panelMgr:setTextureFor(self.icon,data.pic)
        self.name:setString(data.type)
        if data.id < 0 then
            self:checkPass(data.id+10000)
        end
    elseif self.enterWay and self.enterWay == 1 then
        global.panelMgr:setTextureFor(self.icon,data.pic)
        self.name:setString(data.type)
    end

end

function UINoOrderItem:checkPass(id)

    self.icon:setScale(0.68)
    local gateData = luaCfg:get_gateboss_by(id)
    local curFinishId = global.bossData:getCurUnlockBoss(gateData.Elite)

    self.isUnOpen = false
    if gateData.Elite == 2 then

        local curStar, maxStar = global.bossData:getStarNum()
        local openNeedStar = luaCfg:get_config_by(1).EliteBossStar
        if curStar < openNeedStar then
            self.isUnOpen = true
        end
    end

    if curFinishId < id or self.isUnOpen then
        self.isUnlock = false
        self.icon:setOpacity(180)
        global.colorUtils.turnGray(self.grayBg, true)
    end
end

--    [1] = { 1,  "普通招募",  "icon/task/icon_hero_get2.png",  },
--    [2] = { 2,  "来访招募",  "icon/task/icon_hero_get1.png",  },
--    [3] = { 3,  "转盘招募",  "icon/item/icon_diamond_8.png",  },
--    [4] = { 4,  "购买招募",  "icon/task/icon_hero_get3.png",  },
--    [5] = { 5,  "首充招募",  "icon/item/icon_diamond_8.png",  },

local targetPanel = {

    [3] ="UITurntableHeroPanel" , --英雄转盘
    [4] ="UIBuyHeroPanel" , --英雄购买
    [6] ="UITurntableHalfPanel" , --魔晶转盘

} 

function UINoOrderItem:heroCall()

    -- global.panelMgr:closePanel
    global.panelMgr:closePanel("UIHeroNoOrder")


    if self.data.id == 1 then --普通招募

        local panel = global.panelMgr:openPanel("UIHeroPanel")
        panel:setMode4()

    elseif self.data.id == 2 then --来访招募

        if global.panelMgr:isPanelExist("UIHeroComePool") then
            global.panelMgr:closePanel("UIHeroComePool")
        end

        local panel = global.panelMgr:openPanel("UIHeroPanel")
        panel.tabControl2:setSelectedIdx(4)
        panel:onTabButtonChanged(4)

    elseif self.data.id == 4 then --英雄购买
        
        local st  , t =  global.heroData:isCanBuy()
        if not st then 
            global.tipsMgr:showWarning("HeroBuyErr")
        else 
            global.panelMgr:openPanel(targetPanel[self.data.id])
        end

    elseif self.data.id == 5 then --首冲

   
            local panel = global.panelMgr:openPanel("UIFirRechargePanel")
            panel:setData()
   
    else
        global.panelMgr:openPanel(targetPanel[self.data.id])
    end 

end 

function UINoOrderItem:jump_call(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIHeroNoOrder")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        if self.heroWay  then 

            self:heroCall()

        elseif type(self.data) =="table" and self.data.id == 28 then -- 商城购买
    
            -- local panel = global.panelMgr:openPanel(self.data.targetName)

            -- panel:GpsItem(global.gpsStroeItemID)
            global.panelMgr:closePanel("UIHeroNoOrder")

            global.ShopData:buyShop(global.gpsStroeItemID, function()  end)

        elseif self.forgeData and not self.enterWay then

            if self.isUnlock then
                global.panelMgr:openPanel("UIBossPanel"):gpsAndOpenItem(self.data)
            else
                if self.isUnOpen then
                    local openNeedStar = luaCfg:get_config_by(1).EliteBossStar
                    global.tipsMgr:showWarning("limitBoss01", openNeedStar)
                else
                    global.tipsMgr:showWarning("NotUnlockGate")
                end
            end

        elseif not self.enterWay then

            local closeHeroCall = function ()
                -- body
                global.panelMgr:closePanel("UIHeroNoOrder")
                if global.panelMgr:isPanelExist("UIDetailPanel") then
                    global.panelMgr:closePanel("UIDetailPanel")
                end
                if global.panelMgr:isPanelExist("UIHeroPanel") then
                    global.panelMgr:closePanel("UIHeroPanel")
                end
            end

            -- 活动来源
            if self.data.targetName == "activity" then
                local isExitActivity = global.ActivityData:gotoActivityPanelById(self.data.building) 
                if isExitActivity then 
                    closeHeroCall()
                end
                return
            end

            local data = clone(self.data)
            if self.data.targetName == "-1" then -- 联盟城市前往

                closeHeroCall()
                global.funcGame:gpsWorldCity(tonumber(data.building), 1, true, function ()
                end)
                return
            elseif self.data.targetName == "-2" then -- 前往世界boss
                
                closeHeroCall()
                global.funcGame:gpsWorldCity(tonumber(data.building), false, true,function()

                    local widgetName = 'monsterObj' .. tonumber(data.building)
                    global.guideMgr:setStepArg(widgetName)
                    gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)
                end)
                return
            end

            -- 建筑开启条件
            local checkTrigger = function ()
                if self.data.building == 0 then return true end
                local buildData = luaCfg:get_buildings_pos_by(self.data.building)
                if global.cityData:checkTrigger(buildData.triggerId[1]) then
                    return true
                else
                    local triggerData = luaCfg:get_triggers_id_by(buildData.triggerId[1])
                    local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
                    local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,buildData.buildsName)
                    global.tipsMgr:showWarning(str)
                    return false
                end
            end

            if not checkTrigger() then
                return 
            end

            if self.data.id<0 and not self.isUnlock then -- 龙潭关卡解锁
                if self.isUnOpen then
                    local openNeedStar = luaCfg:get_config_by(1).EliteBossStar
                    global.tipsMgr:showWarning("limitBoss01", openNeedStar)
                else
                    global.tipsMgr:showWarning("NotUnlockGate")
                end
                return
            else
                closeHeroCall()
            end
            
            if self.data.targetName =="UIChestPanel" then
                   local panel = global.panelMgr:openPanel(self.data.targetName)  
                   panel:setData()
                return 
            end 

            -- 前往野地
            if self.data.id == 2 or self.data.id == 3 then
                if global.scMgr:isMainScene() then
                    global.scMgr:gotoWorldSceneWithAnimation()        
                else
                    global.funcGame:returnMainCity()
                end
                return
            end

            
            local data = clone(self.data)
            -- 直接在大地图可以打开的界面(龙潭)
            local isWorldOpen = (data.id<0)
            if global.scMgr:isWorldScene() and (not isWorldOpen) then
                global.g_worldview.mapPanel:cleanSchedule()
                global.scMgr:setMainSceneCall(function()              
                    global.panelMgr:openPanel(data.targetName)
                end)
                global.scMgr:gotoMainSceneWithAnimation()
            else

                if data.targetName == "UIStorePanel" then

                    global.uiMgr:addSceneModel(1)
                    global.panelMgr:openPanel(data.targetName):changeToOther()
                    global.guideMgr.getHandler():autoGuide(
                            {
                                isSpecial = true,
                                panelName = "UIStorePanel",
                                tableViewName = "TableViewforsmallitem",
                                dataCatch = {itemId = 10714},
                                isShowLight = true,
                                scaleY = 1
                            }
                        )
                elseif data.id<0 then
                    global.panelMgr:openPanel("UIBossPanel"):gpsAndOpenItem(data.id+10000)
                else
                    global.panelMgr:openPanel(data.targetName)  
                end                        
            end
        
        elseif self.enterWay and  self.enterWay == 1 then  -- 获取资源途径

            local closeCall = function ()

                global.panelMgr:closePanel("UIHeroNoOrder")
                if global.panelMgr:isPanelExist("UIResGetPanel") then
                    global.panelMgr:closePanel("UIResGetPanel")
                end
                if global.panelMgr:isPanelExist("UIResPanel") then
                    global.panelMgr:closePanel("UIResPanel")
                end
            end

            if self.data.id == 1 then

                closeCall()
                local panel = global.panelMgr:openPanel("UISevenDays")
                panel:setData(global.ActivityData:getActivityById(19001))

            elseif self.data.id == 2 or self.data.id == 6 then

                closeCall()
                if global.scMgr:isMainScene() then
                    global.scMgr:gotoWorldSceneWithAnimation()        
                else
                    global.funcGame:returnMainCity()
                end

            elseif self.data.id == 3 then

                closeCall()
                global.panelMgr:openPanel("TaskPanel")

            elseif self.data.id == 4 then

                local opLv = luaCfg:get_config_by(1).dailyTaskLv
                if global.funcGame:checkBuildLv(1, opLv) then
                    closeCall()
                    global.panelMgr:openPanel("UIDailyTaskPanel"):setData()
                end
                
            elseif self.data.id == 5 then

                local buildingData = global.cityData:getBuildingById(23)
                if buildingData and buildingData.serverData and buildingData.serverData.lStatus ~= 0 then
                    closeCall()
                    global.panelMgr:openPanel("UISalaryPanel"):setData(buildingData)
                else
                    global.tipsMgr:showWarning("NotBuild")
                end

            end

        end

    end

end
--CALLBACKS_FUNCS_END

return UINoOrderItem

--endregion

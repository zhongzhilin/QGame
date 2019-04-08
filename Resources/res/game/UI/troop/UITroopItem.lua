--region UITroopItem.lua
--Author : yyt
--Date   : 2016/09/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local stateEvent = global.stateEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UITroopItem  = class("UITroopItem", function() return gdisplay.newWidget() end )

function UITroopItem:ctor()
    
    self:CreateUI()
end

function UITroopItem:CreateUI()
    local root = resMgr:createWidget("troop/troops_list_node")
    self:initUI(root)
end

function UITroopItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/troops_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ItemBg = self.root.ItemBg_export
    self.troop_operation = self.root.ItemBg_export.troop_operation_export
    self.btn_dissolution = self.root.ItemBg_export.troop_operation_export.btn_dissolution_export
    self.btn_details = self.root.ItemBg_export.troop_operation_export.btn_details_export
    self.btn_edit = self.root.ItemBg_export.troop_operation_export.btn_edit_export
    self.btn_Battle = self.root.ItemBg_export.troop_operation_export.btn_Battle_export
    self.textTroopsState = self.root.ItemBg_export.troop_operation_export.btn_Battle_export.textTroopsState_export_4
    self.troops_list = self.root.ItemBg_export.troops_list_export
    self.no_hero = self.root.ItemBg_export.troops_list_export.no_hero_export
    self.selectBg = self.root.ItemBg_export.troops_list_export.no_hero_export.selectBg_export
    self.itemClickEffect = self.root.ItemBg_export.troops_list_export.no_hero_export.itemClickEffect_export
    self.btn_list_add = self.root.ItemBg_export.troops_list_export.no_hero_export.btn_list_add_export
    self.list_name = self.root.ItemBg_export.troops_list_export.no_hero_export.list_name_export
    self.list_place = self.root.ItemBg_export.troops_list_export.no_hero_export.list_place_export
    self.list_relation = self.root.ItemBg_export.troops_list_export.no_hero_export.list_relation_export
    self.list_state = self.root.ItemBg_export.troops_list_export.no_hero_export.list_state_export
    self.list_scale = self.root.ItemBg_export.troops_list_export.no_hero_export.list_scale_export
    self.buff_scale = self.root.ItemBg_export.troops_list_export.no_hero_export.buff_scale_export
    self.player_name = self.root.ItemBg_export.troops_list_export.no_hero_export.player_name_export
    self.jiantou = self.root.ItemBg_export.troops_list_export.no_hero_export.jiantou_export
    self.player_relation = self.root.ItemBg_export.troops_list_export.no_hero_export.player_relation_export
    self.searchTroopSp = self.root.ItemBg_export.troops_list_export.no_hero_export.searchTroopSp_export
    self.empty1 = self.root.ItemBg_export.troops_list_export.no_hero_export.empty1_export
    self.empty2 = self.root.ItemBg_export.troops_list_export.no_hero_export.empty2_export
    self.new1 = self.root.ItemBg_export.troops_list_export.no_hero_export.new1_mlan_6_export
    self.new2 = self.root.ItemBg_export.troops_list_export.no_hero_export.new2_mlan_17_export
    self.node_killed = self.root.ItemBg_export.troops_list_export.node_killed_export
    self.troops_hero = self.root.ItemBg_export.troops_list_export.troops_hero_export
    self.hero_bg = self.root.ItemBg_export.troops_list_export.hero_bg_export
    self.nameBg = self.root.ItemBg_export.troops_list_export.nameBg_export
    self.nameBg1 = self.root.ItemBg_export.troops_list_export.nameBg1_export
    self.heroName = self.root.ItemBg_export.troops_list_export.heroName_export
    self.heroLv = self.root.ItemBg_export.troops_list_export.heroLv_export
    self.starlist = UIHeroStarList.new()
    uiMgr:configNestClass(self.starlist, self.root.ItemBg_export.troops_list_export.starlist)
    self.left = self.root.ItemBg_export.troops_list_export.left_export
    self.right = self.root.ItemBg_export.troops_list_export.right_export
    self.sort_btn = self.root.sort_btn_export

    uiMgr:addWidgetTouchHandler(self.btn_dissolution, function(sender, eventType) self:fireTroop_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_details, function(sender, eventType) self:detail_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_edit, function(sender, eventType) self:editTroop_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_Battle, function(sender, eventType) self:battle_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.selectBg, function(sender, eventType) self:item_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_list_add, function(sender, eventType) self:item_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.sort_btn, function(sender, eventType) self:sort_event(sender, eventType) end, true)
--EXPORT_NODE_END
    self:initUIData()

end

function UITroopItem:initUIData()
    self.selectBg:setSwallowTouches(false)
    self.btn_list_add:setSwallowTouches(true)

    self.isTroopCityState = self:getTroopCityState()   -- 0自己城、1非自己城、2目标城
    self.curBtnState = 0        -- 0待命、1驻防、2召回、3出征、4定位
    self.isCanEdit = false

    self.relationX = self.list_place:getPositionX() 
    self:initTextColor()        -- 字体颜色

    -- self.hero_quality:setVisible(false)
    self.starlist:setVisible(false)
    self.left:setVisible(false)
    self.right:setVisible(false)

    --
    self.troops_list_bg1 = self.root.ItemBg_export.troops_list_export.no_hero_export.troops_list_bg1
end

function UITroopItem:initTextColor()
    
    self.COLOR_OWNCOLOR = cc.c3b(255, 226, 165)  -- 浅黄色  (自己)
    self.COLOR_GREEN = cc.c3b(87, 213, 63)       -- 浅绿色  (同盟/联盟  、行军中)
    self.COLOR_YELLOW = cc.c3b(255, 208, 65)     -- 黄色    (中立)
    self.COLOR_RED = cc.c3b(180, 29, 11)         -- 红色    (敌对)
    self.COLOR_BLUE = cc.c3b(36, 108, 198)       -- 深蓝色  (驻守城内)
    self.COLOR_ORANGE = cc.c3b(255, 119, 57)     -- 橙色    (驻守城外)
end

function UITroopItem:getTroopCityState()
    
    local isSelfCity = 0
    local targetData = global.troopData:getTargetData()
    --有目的就显示出征

    dump(targetData,'>>>targetData')

    if not targetData or (global.userData:getWorldCityID()==targetData.targetCityId) then
        isSelfCity  = 0
    else
        isSelfCity = 2
    end

    return isSelfCity
end

function UITroopItem:initStateMachine(initial_state)
    self.fsm:setupState({
        initial = initial_state,
        events = {
            {name = stateEvent.TROOP.EVENT.STATION, from = "*", to = stateEvent.TROOP.STATE.STATION},
            {name = stateEvent.TROOP.EVENT.WAITORDER, from = "*", to = stateEvent.TROOP.STATE.WAITORDER},
            {name = stateEvent.TROOP.EVENT.FIGHT, from = "*", to = stateEvent.TROOP.STATE.FIGHT},
            {name = stateEvent.TROOP.EVENT.WALK, from = "*", to = stateEvent.TROOP.STATE.WALK},
            {name = stateEvent.TROOP.EVENT.BACK, from = "*", to = stateEvent.TROOP.STATE.BACK},
            {name = stateEvent.TROOP.EVENT.STATION_OTHER, from = "*", to = stateEvent.TROOP.STATE.STATION_OTHER},            
            {name = stateEvent.TROOP.EVENT.REVOLT, from = "*", to = stateEvent.TROOP.STATE.REVOLT},            
        },
        callbacks = {
            ["onenter"..stateEvent.TROOP.STATE.STATION] = function(event)
               
                print(event.name.."驻守中")
                self.list_state:setString(luaCfg:get_local_string(10098))   
                self.list_state:setTextColor(self.COLOR_BLUE)



                if self.troopPanel:isRevolt() then

                    self.textTroopsState:setString(luaCfg:get_local_string(10210))
                    self.curBtnState = 6
                else

                    if self.isTroopCityState == 0 then
                        
                        if global.userData:getOwnerId() ~= 0 then
                            self.textTroopsState:setString(luaCfg:get_local_string(10210))
                            self.curBtnState = 6        
                        else
                            self.textTroopsState:setString(luaCfg:get_local_string(10095))
                            self.curBtnState = 0
                        end                        
                    elseif self.isTroopCityState == 1 then
                        self.textTroopsState:setString(luaCfg:get_local_string(10024))
                        self.curBtnState = 2
                    elseif self.isTroopCityState == 2 then
                        print(">>>3")
                        self.textTroopsState:setString(luaCfg:get_local_string(10023))
                        self.curBtnState = 3
                    end

                end


                local targetData = global.troopData:getTargetData()
                if global.userData:isMine(self.data.lUserID) then
                    if targetData and targetData.attackMode == 8 then
                        -- 奇迹传送
                        self.textTroopsState:setString(luaCfg:get_local_string(10903))
                        self.curBtnState=8
                    end
                end

                self:setPlaceString()
                       

                self.isCanEdit = true
            end,
            ["onenter"..stateEvent.TROOP.STATE.WAITORDER] = function(event)
         
                print(event.name.."待命中") 
                if global.userData:getIsBeAttackCity() then
                    self.list_state:setString(luaCfg:get_local_string(11086))
                    self.list_state:setTextColor(self.COLOR_RED)
                else
                    self.list_state:setString(luaCfg:get_local_string(10099))
                    self.list_state:setTextColor(self.COLOR_GREEN)
                end
                

                if self.troopPanel:isRevolt() then

                    self.textTroopsState:setString(luaCfg:get_local_string(10210))
                    self.curBtnState = 6

                else

                    if self.isTroopCityState == 0 then                        

                        if global.userData:getOwnerId() ~= 0 then
                            self.textTroopsState:setString(luaCfg:get_local_string(10210))
                            self.curBtnState = 6        
                        else
                            self.textTroopsState:setString(luaCfg:get_local_string(10096))
                            self.curBtnState = 1
                        end   

                    elseif self.isTroopCityState == 2 then
                        print(">>>2")
                        self.textTroopsState:setString(luaCfg:get_local_string(10023))
                        self.curBtnState = 3
                    end                     

                end

                local targetData = global.troopData:getTargetData()
                if global.userData:isMine(self.data.lUserID) then
                    if targetData and targetData.attackMode == 8 then
                        -- 奇迹传送
                        self.textTroopsState:setString(luaCfg:get_local_string(10903))
                        self.curBtnState=8
                    end
                end

                if self.data then

                    print("self.list_place:setString(self.data.szSrcName)")
                    -- self.list_place:setString(self.data.szSrcName)
                    
                    local sname = global.luaCfg:get_all_miracle_name_by(self.data.lTarget)
                    if sname then
                        self.list_place:setString(sname.name)
                    else
                        self.list_place:setString(self.data.szSrcName)
                    end
                end                

                self.isCanEdit = true
            end,
            ["onenter"..stateEvent.TROOP.STATE.REVOLT] = function(event)

                print(event.name.."战斗中")     
                self.list_state:setString(luaCfg:get_local_string(10210))
                self.list_state:setTextColor(self.COLOR_RED)
                self.textTroopsState:setString(luaCfg:get_local_string(10215))
                self.curBtnState = 7

                self:setPlaceString()

                self.isCanEdit = false
            end,
            ["onenter"..stateEvent.TROOP.STATE.FIGHT] = function(event)

                print(event.name.."起义中")     
                self.list_state:setString(luaCfg:get_local_string(10100))
                self.list_state:setTextColor(self.COLOR_RED)
                self.textTroopsState:setString(luaCfg:get_local_string(10097))
                self.curBtnState = 4

                self:setPlaceString()

                self.isCanEdit = false
            end,
            ["onenter"..stateEvent.TROOP.STATE.WALK] = function(event)

                print(event.name.."行军中")
                self.list_state:setString(luaCfg:get_local_string(10101))
                self.list_state:setTextColor(self.COLOR_RED)
                self.textTroopsState:setString(luaCfg:get_local_string(10097))   
                self.curBtnState = 4 

                self:setPlaceString()

                self.isCanEdit = false              
            end,
            ["onenter"..stateEvent.TROOP.STATE.BACK] = function(event)

                print(event.name.."返回中")
                self.list_state:setString(luaCfg:get_local_string(10102))
                self.list_state:setTextColor(self.COLOR_RED)
                self.textTroopsState:setString(luaCfg:get_local_string(10097))
                self.curBtnState = 4

                self:setPlaceString()

                self.isCanEdit = false              
            end,
            ["onenter"..stateEvent.TROOP.STATE.STATION_OTHER] = function(event)


                print(event.name.."驻守在其他城市")

                self:setPlaceString()

                -- 别人部队驻守在自己城
                local userId = global.userData:getUserId()
                if userId ~= self.data.lUserID then

                    self.textTroopsState:setString(luaCfg:get_local_string(10144))   
                    self.curBtnState = 5
                else
                    self.isCanEdit = false
                    if self.data.lCollectSpeed then
                        self.list_state:setString(luaCfg:get_local_string(10984))   
                    else
                        self.list_state:setString(luaCfg:get_local_string(10098))   
                    end                    
                    self.list_state:setTextColor(self.COLOR_BLUE)
                    self.list_relation:setVisible(true)

                    local textColor = self.COLOR_OWNCOLOR
                    local lAvatorId = 0                       --  0中立 1自己 2同盟 3联盟 4敌对

                    -- dump(self.data, "-------> troopData: ")
                    local curState = 0
                    self.data.lDstType = self.data.lDstType or 0
                    if self.data.lDstType == 1 then
                        curState = self.data.lTargetAvator  -- 与驻防目标地关系 
                    else
                        curState = self.data.lOwnerAvator   -- 与驻防小村庄、营地奇迹等拥有者关系 
                    end
                   
                    -- print("############ curState: "..curState)
                    if curState == 0 then
                        lAvatorId = 10142
                        textColor = self.COLOR_YELLOW 
                    elseif curState == 1 then
                        lAvatorId = 1                 -- 自己
                    elseif curState == 2 or curState == 3 then
                        lAvatorId = 10141
                        textColor = self.COLOR_GREEN
                    elseif curState == 4 then
                        lAvatorId = 10143
                        textColor = self.COLOR_RED 
                    end

                    local str = ""
                    
                    -- print(self.data.lDstType,">>>>>>>>>self.data.lDstType")

                    if (self.data.lWildKind and self.data.lWildKind == 1) or (lAvatorId == 1) then
                    else
                        str = luaCfg:get_local_string(lAvatorId) 
                    end

                    if self.data.lDstType ~= 10 then
                    
                        self.list_relation:setString(str)
                        self.list_relation:setTextColor(textColor)
                        local posX = self.list_place:getAutoRenderSize().width/2 + self.relationX
                        local listW = self.list_relation:getContentSize().width / 2
                        -- self.list_relation:setPositionX(posX - listW)
                        -- self.list_place:setPositionX(self.relationX - listW)
                    end                    

                    if global.scMgr:isWorldScene() then

                        local targetData = global.troopData:getTargetData()
                        if not targetData then return end
                        local chooseCityId = targetData.targetCityId
                        local mainId = global.userData:getWorldCityID()

                        local attackMode = targetData.attackMode

                        print(attackMode,"check attack mode")

                        if attackMode == -1 then
                            --大地图部队管理界面进来的
                            --返回主城

                            self.textTroopsState:setString(luaCfg:get_local_string(10136))   
                            self.curBtnState = 2
                        else

                            if mainId == chooseCityId then
                                --主城的军事行动进来的                           
                                --出征

                                -- 如果是起义入口进来的话，则显示返回主城
                                if self.troopPanel:isRevolt() then
                                    self.textTroopsState:setString(luaCfg:get_local_string(10136))   
                                    self.curBtnState = 2
                                else
                                    self.textTroopsState:setString(luaCfg:get_local_string(10023))
                                    self.curBtnState = 3
                                end                                
                            else
                                --不是主城的军事行动进来的
                                --如果是 驻防城

                                self.textTroopsState:setString(luaCfg:get_local_string(10023))
                                self.curBtnState = 3
                            end
                        end 
                        if global.userData:isMine(self.data.lUserID) then
                            if attackMode == 8 then
                                -- 奇迹传送
                                self.textTroopsState:setString(luaCfg:get_local_string(10903))
                                self.curBtnState=8
                            end
                        end             
                    else
                        self.textTroopsState:setString(luaCfg:get_local_string(10136))   
                        self.curBtnState = 2
                    end 
                end              
            end,              
        }
    })
end

function UITroopItem:setPlaceString()
   
    self.data.lDstType = self.data.lDstType or 0
    self.data.lTarget = self.data.lTarget or 0

    if self.data.lDstType == 10 then

        local id,name = global.worldApi:decodeLandId(self.data.lTarget)
        local sname = global.luaCfg:get_all_miracle_name_by(self.data.lTarget)
        if sname then
            self.list_place:setString(sname.name)
        else
            self.list_place:setString(name)
        end

        self.list_relation:setString("("..luaCfg:get_local_string(10302)..")")
        self.list_relation:setTextColor(self.COLOR_YELLOW )
        local posX = self.list_place:getAutoRenderSize().width/2 + self.relationX
        local listW = self.list_relation:getContentSize().width / 2
        -- self.list_relation:setPositionX(posX - listW)
        -- self.list_place:setPositionX(self.relationX - listW)

        self.list_relation:setVisible(true)
    else
        local sname = global.luaCfg:get_all_miracle_name_by(self.data.lTarget)
        if sname then
            self.list_place:setString(sname.name)
        else
            self.list_place:setString(self.data.szTargetName)
        end
    end
end

function UITroopItem:setData( data )

    self.troopPanel = global.panelMgr:getPanel("UITroopPanel")

    self.data = data
    self.fsm = global.stateMachine.new()
    self:initStateMachine(stateEvent.TROOP.STATE.STATION)

    self.itemClickEffect:setVisible(false)
    self.jiantou:setVisible(false)
    self.btn_list_add:setVisible(false)

    self.new1:setVisible(false)
    self.new2:setVisible(false)
    self.player_name:setScale(1)

    self.selectBg:setName("GuideChoosePanel"..data.lID)
    self:setName("GuideChoosePanel2"..data.lID)
    
    -- 引导
    if self.data.lState ~= 0 then

        local allCount =  global.troopData:getTroopsScaleByData( self.data.tgWarrior )
        if allCount >= 100 then
            self.troops_list_bg1:setName("troops_list_bg" .. self.data.lState)  
            self.btn_edit:setName("btn_edit_export" .. self.data.lState)  
            self.btn_Battle:setName("btn_Battle_export" .. self.data.lState)  

            else
            self.troops_list_bg1:setName("troops_list_bg1") 
            self.btn_edit:setName("btn_edit_export")  
            self.btn_Battle:setName("btn_Battle_export")  
        end 

    else
    self.troops_list_bg1:setName("troops_list_bg1")   
    end

    

    if data.lHeroID == nil then data.lHeroID = {[1]=0} end
    if data.lHeroID[1] ~= 0 then 
        local heroData = global.heroData:getHeroDataById(data.lHeroID[1]) or global.heroData:getHeroDataById(1)
        -- self.troops_hero:loadTexture(heroData.nameIcon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.troops_hero,heroData.nameIcon)
        self.heroLv:setVisible(true)
        self.heroName:setVisible(true)
        heroData.serverData = heroData.serverData or {}

        if data.lUserID ~= global.userData:getUserId() then
            self.heroLv:setString(luaCfg:get_local_string(10643, data.lHeroLevel or 0))
        else
            self.heroLv:setString(luaCfg:get_local_string(10643, heroData.serverData.lGrade or 0))
        end

        self.heroName:setString(heroData.name)
        self.nameBg1:setVisible(true)
        self.nameBg:setVisible(true)

        self.starlist:setVisible(true)
        self.left:setVisible(true)
        self.right:setVisible(true)
        self.starlist:setData(heroData.heroId,heroData.serverData.lStar or 1)
        global.funcGame:dealHeroRect(self,heroData)
        -- self.hero_quality:setVisible(heroData.quality == 2)
    else
        -- self.hero_quality:setVisible(false)
        self.starlist:setVisible(false)
        self.nameBg1:setVisible(false)
        self.nameBg:setVisible(false)
        self.heroLv:setVisible(false)
        self.heroName:setVisible(false)
        self.left:setVisible(false)
        self.right:setVisible(false)
        self.troops_hero:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
    end

    self.list_name:setString(data.szName)
    self.list_name:setTextColor(self.COLOR_OWNCOLOR)
    self.list_scale:setString(global.troopData:getCombat(data.lID))
    self.list_place:setTextColor(self.COLOR_OWNCOLOR)
    
    self:setLordName(data)
    self:refershTroopsState( data.lState )

    local heroData = global.heroData:getHeroDataById(data.lHeroID[1]) or global.heroData:getHeroDataById(1)
    self:flushCommanderValue(heroData)
    
    if global.troopData:checkTroopType(data) then
        self.searchTroopSp:setVisible(true)
        self.buff_scale:setPositionY(91.5)
    else
        self.searchTroopSp:setVisible(false)
        self.buff_scale:setPositionY(66.5)
    end

end

-- 获取部队加成规模
function UITroopItem:getAddScale(tgWarrior, commanderType, attType)
    -- body
    local allScale = 0
    for _,v in pairs(tgWarrior) do
            
        local soldierData = luaCfg:get_soldier_property_by(v.lID)
        if (soldierData.type == commanderType and (soldierData.skill == attType or attType == 0)) or commanderType == 0 then
            allScale = allScale + v.lCount * soldierData.perPop
        end     
    end
    return allScale
end

function UITroopItem:flushCommanderValue(heroData)
    if heroData == nil then
        self.troops_hero:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
        return
    end

    
    local commanderType = heroData.commanderType
    local attType = heroData.secType

    local commander = 0 
    if heroData.serverData and heroData.serverData.lbase then
        commander = heroData.serverData.lbase[4] + heroData.serverData.lextra[4]
    end

    local allCount =  global.troopData:getTroopsScaleByData( self.data.tgWarrior ) --self:getAddScale(self.data.tgWarrior, commanderType, attType) -- 
    local allScale = allCount
    if allScale > commander then allCount = commander end
    if commander == 0 then
        self.buff_scale:setString("-")
    else
        self.buff_scale:setString(allCount .. "/" .. commander)
    end
end

function UITroopItem:setLordName(data)
    
    local textColor = gdisplay.COLOR_WHITE
    -- local posY = 0
    if data.szUserName ~= "nil" then
        self.player_name:setString(data.szUserName)
        if data.lUserID ~= global.userData:getUserId() then

            local curState = data.lAvator
            if curState == 0 then
                lAvatorId = 10142
                textColor = self.COLOR_YELLOW 
            elseif curState == 2 or curState == 3 then
                lAvatorId = 10141
                textColor = self.COLOR_GREEN 
            elseif curState == 4 then
                lAvatorId = 10143
                textColor = self.COLOR_RED 
            end
            self.player_relation:setVisible(true)
            self.player_relation:setString(luaCfg:get_local_string(lAvatorId))
            self.player_relation:setTextColor(textColor)
            -- posY = 78.5
        else
            textColor = self.COLOR_OWNCOLOR
            self.player_relation:setVisible(false)
            -- posY = 66.5
        end
        self.player_name:setTextColor(textColor)
    else
        -- posY = 66.5
        self.player_name:setString("-")
    end
    -- self.player_name:setPositionY(posY)
end

-- 刷新军队状态
function UITroopItem:refershTroopsState( lState )

    self.list_relation:setVisible(false)
    -- self.list_place:setPositionX(self.relationX)

    --lState: 10驻守、6待命、11战斗、1行军、2返回、5驻守在其他城池
    if lState == 10 then
        self:doEvent(stateEvent.TROOP.EVENT.STATION)
    elseif lState == 6 then
        self:doEvent(stateEvent.TROOP.EVENT.WAITORDER)
    elseif lState == 11 then
        self:doEvent(stateEvent.TROOP.EVENT.FIGHT)
    elseif lState == 1 then
        self:doEvent(stateEvent.TROOP.EVENT.WALK)
    elseif lState == 2 then
        self:doEvent(stateEvent.TROOP.EVENT.BACK)
    elseif lState == 5 then
        self:doEvent(stateEvent.TROOP.EVENT.STATION_OTHER)
    elseif lState == 12 then
        self:doEvent(stateEvent.TROOP.EVENT.REVOLT)
    end
end

function UITroopItem:doEvent(event_name)
    if self.fsm and self.fsm:canDoEvent(event_name) then
        self.fsm:doEvent(event_name)
    end
end

function UITroopItem:flushTroopState( lState, troopStation )
    
    self.isTroopCityState = troopStation
    self:refershTroopsState( lState )
    global.troopData:updataTroopsState(self.troopPanel.curTroops.lID, lState)
end

function UITroopItem:setDieState(isDie)
    
    self.isDie = isDie

    self.node_killed:setVisible(isDie)    
    global.colorUtils.turnGray(self.no_hero,isDie)            

    self.list_place:setVisible(not isDie and self.list_place:isVisible())
    self.list_relation:setVisible(not isDie and self.list_relation:isVisible())
    self.list_state:setVisible(not isDie and self.list_state:isVisible())  
    self.list_scale:setVisible(not isDie and self.list_scale:isVisible())  
    self.empty1:setVisible(isDie)
    self.empty2:setVisible(isDie)

    self.new1:setVisible(false)
    self.new2:setVisible(false)
    self.player_name:setScale(1)
end

function UITroopItem:setLastAdd(data)

    self.troopPanel = global.panelMgr:getPanel("UITroopPanel")
    self.data = data
    self.isEditItem = true
    self.itemClickEffect:setVisible(false)
    self.jiantou:setVisible(false)
    self.troops_hero:setVisible(false)
    self.hero_bg:setVisible(false)
    self.list_place:setVisible(false)
    self.list_state:setVisible(false)
    self.list_name:setVisible(false) 
    self.searchTroopSp:setVisible(false)
    self.list_relation:setVisible(false)
    self.player_relation:setVisible(false)
    self.new1:setVisible(true)
    self.new2:setVisible(true)
    self.player_name:setScale(1.3)
    self.player_name:setString(string.format(luaCfg:get_local_string(10021)))
    -- self.player_name:setPositionY(66.5)
    self.player_name:setTextColor(gdisplay.COLOR_WHITE)
    

    self.heroLv:setVisible(false)
    self.heroName:setVisible(false)
    self.nameBg1:setVisible(false)
    self.nameBg:setVisible(false)
    self.node_killed:setVisible(false)        
    self.empty1:setVisible(false)
    self.empty2:setVisible(false)
    self.buff_scale:setVisible(false)

    local num = global.troopData:getTroopNum()
    local canNewTroop = luaCfg:get_troop_max_by(global.userData:getLevel())
    if canNewTroop then
        self.list_scale:setString(num.."/"..canNewTroop.num)
    end
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITroopItem:item_click(sender, eventType)

    if self.troopPanel.isMove then return end
    if self.isEdit then return end

    for i,v in pairs(self.troopPanel.itemSwitch) do

        if v.selectBg:getTag() == sender:getTag() then

            self:itemClickCall(v)
        else
            v.itemClickEffect:setVisible(false)
        end

    end
end

function UITroopItem:itemClickCall(v)
    

    local canNewTroopNum = luaCfg:get_troop_max_by(global.userData:getLevel()).num

    v.itemClickEffect:setVisible(true)
    self.troopPanel.curTroops = v.data
    self:refershTroopsState( v.data.lState )

    global.debugTroop = v.data

    if v.selectBg:getTag() == 40100 then
        self.troopPanel.TROOP_STATE = 0   -- 新建部队

        local num = global.troopData:getTroopNum()
        if num < canNewTroopNum then
            self:interDetailPanel()
        else
            
            local vItem = self:checkItem(self.troopPanel.curItemTag) 
            if vItem then
                if vItem.troop_operation:isVisible() then
                    vItem.itemClickEffect:setVisible(true)
                else
                    vItem.itemClickEffect:setVisible(false)
                end
                self.troopPanel.curTroops = vItem.data
            end

            v.itemClickEffect:setVisible(false)
            global.tipsMgr:showWarning(self:getNextLvTroopMaxTips())
            return
        end
    else
        self.troopPanel.TROOP_STATE = 1

        if (self.troopPanel.curItemTag ~= v.selectBg:getTag()) and (not self.troopPanel.BTN_FIRST) then
            
            local vItem = self:checkItem(self.troopPanel.curItemTag) 
            vItem.itemClickEffect:setVisible(false)
            vItem.jiantou:setVisible(false)
            self:hideActionBack( vItem ) 

            self:showActionGo(v)
            self.troopPanel.curItemTag = v.selectBg:getTag()
            self.troopPanel.BTN_FIRST = false
            return
        end

        if self.troopPanel.BTN_FIRST then
            self:showActionGo(v)
            v.itemClickEffect:setVisible(true)
            self.troopPanel.BTN_FIRST = false
        else
            self:hideActionBack(v)
            v.itemClickEffect:setVisible(false)
            self.troopPanel.BTN_FIRST = true
        end
        self.troopPanel.curItemTag = v.selectBg:getTag()
    end

end

function UITroopItem:getNextLvTroopMaxTips()
    
    local str = ""
    local nextLv, nextMaxNum = 0, 0
    local curMaxNum = luaCfg:get_troop_max_by(global.userData:getLevel()).num
    local maxData = luaCfg:troop_max()

    for i=1, #maxData do
        if curMaxNum < maxData[i].num then
            nextLv = maxData[i].lv
            nextMaxNum = maxData[i].num
            break
        end
    end

    if nextLv ~= 0 then
        str = luaCfg:get_local_string(10050, nextLv, nextMaxNum)
    else
        str = luaCfg:get_local_string(10220)
    end

    return str
end

function UITroopItem:checkItem( _tag )
    
    for _,v in pairs(self.troopPanel.itemSwitch) do
        
        if _tag == v.selectBg:getTag() then
            return v
        end
    end
end

function UITroopItem:showActionGo( _item )
    
    _item.jiantou:setVisible(true)
    _item.troop_operation:setVisible(true)
    _item.troop_operation:runAction(cc.FadeIn:create(0.5))
    
    self:refershPosition( _item, false )
end

function UITroopItem:hideActionBack(_item)
    
    _item.jiantou:setVisible(false)
    _item.troop_operation:setVisible(false)
    _item.troop_operation:runAction(cc.FadeOut:create(0.5))
    
    self:refershPosition( _item, true )
end

function UITroopItem:readyForSort(isEdit)
    
    self.isEdit = isEdit

    if self.jiantou:isVisible() then
        self:itemClickCall(self)
    end

    self.root:stopAllActions()
    self.root:runAction(cc.MoveTo:create(0.25,cc.p(isEdit and 44 or 0,0)))
end

function UITroopItem:refershPosition( item,  isBack)

    local _curItemTag = item.selectBg:getTag()
    local scroX = self.troopPanel.ScrollView_1:getInnerContainerPosition().y

    local temp = 0
    local sH = self.troopPanel.troopItem_layout:getContentSize().height

    local i = 0
    for _,v in pairs(self.troopPanel.itemSwitch) do
        if v.selectBg:getTag() > _curItemTag then

            local taskY = 0 
            if isBack then
                temp = 0
                taskY = v.ItemBg:getPositionY() + sH + 7
            else
                temp = 1
                taskY = v.ItemBg:getPositionY() - sH - 7
            end
            
            v.ItemBg:setPosition(cc.p( v.ItemBg:getPositionX(), taskY ))
            i = i+1
        end 
    end

    local innerY = self.troopPanel.ScrollView_1:getInnerContainerPosition().y

    local numItem = (#self.troopPanel.itemSwitch) 
    local innerH = (numItem+temp)*(sH+3)
    self.troopPanel.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, innerH ))

    innerH = self.troopPanel.ScrollView_1:getInnerContainerSize().height
    local contentH =  self.troopPanel.ScrollView_1:getContentSize().height 
  
   if innerH - contentH < sH + 3 then
        local dH = innerH - contentH
        if self.troopPanel.m_lastState and self.troopPanel.m_lastState ~= dH then
            dH = self.troopPanel.m_lastState
        end
        self:resetPosition(dH,  isBack, scroX, item)
        if not isBack then
            self.troopPanel.m_lastState = dH
        else
            self.troopPanel.m_lastState = nil
        end
    else
        local dH = sH+3
        if self.troopPanel.m_lastState and self.troopPanel.m_lastState ~= dH then
            dH = self.troopPanel.m_lastState
        end
        self:resetPosition(dH,  isBack, scroX, item)
        if not isBack then
            self.troopPanel.m_lastState = dH
        else
            self.troopPanel.m_lastState = nil
        end
    end
end

function UITroopItem:resetPosition(sH, isBack, scroX, item)

    for _,v in pairs(self.troopPanel.itemSwitch) do
        local taskY = 0
        if isBack then 
            taskY = v.ItemBg:getPositionY() - sH
        else
            taskY = v.ItemBg:getPositionY() + sH
        end 
        v.ItemBg:setPosition(cc.p( v.ItemBg:getPositionX(), taskY ))
    end
    
    if not isBack then
        local x,y = item.troop_operation:getPosition()
        local posItem = self:convertToWorldSpace(cc.p(0, 0))
        self.troopPanel.ScrollView_1:setInnerContainerPosition(cc.p(0, scroX-sH))
    else
        self.troopPanel.ScrollView_1:setInnerContainerPosition(cc.p(0, scroX+sH))
    end
  
end

function UITroopItem:editTroop_click(sender, eventType)

    if self.curBtnState == 5 then
        
        global.tipsMgr:showWarning("TroopsEditlutionOther")
    else
        local lState = self.troopPanel.curTroops.lState
        if self.isCanEdit then
            self:interDetailPanel()
        else

            if self.data.lState == 5 then
                global.tipsMgr:showWarning("TroopsBtnMa")
            else
                global.tipsMgr:showWarning("TroopsEditlution")
            end    
        end
    end
end

function UITroopItem:interDetailPanel()
    
    local detailPanel = global.panelMgr:openPanel("UITroopDetailPanel")
    detailPanel:setData(self.troopPanel.curTroops)
end


function UITroopItem:fireTroop_click(sender, eventType)

    if self.curBtnState == 5 then
        
        global.tipsMgr:showWarning("TroopsDissolutionOther")
    else
        local lState = self.troopPanel.curTroops.lState
        if self.isCanEdit then
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("TroopsBtn", handler(self, self.fireTroopBack))
        else

            if self.data.lState == 5 then
                global.tipsMgr:showWarning("TroopsBtnEd")
            else
                global.tipsMgr:showWarning("TroopsDissolution")
            end
        end
    end
end

function UITroopItem:fireTroopBack()

    local tgTroop = {}
    tgTroop.lID = self.troopPanel.curTroops.lID

    local heroTb = {}
    heroTb[1] = 0
    tgTroop.lHeroID = heroTb
    tgTroop.tgWarrior = {}

    global.cityApi:troopManager(2, tgTroop, function(msg)

        if tolua.isnull(self.troopPanel) then
            return 
        end
        if self.troopPanel.curTroops.lHeroID ~= nil and  self.troopPanel.curTroops.lHeroID[1] ~= 0 then
            global.heroData:updataRecruitHeroUseState(self.troopPanel.curTroops.lHeroID[1])
        end
        global.troopData:deleteTroopsById(self.troopPanel.curTroops.lID)
        -- self.troopPanel:setData()
    end)
end

function UITroopItem:detail_click(sender, eventType)
    
    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end

    local panel = global.panelMgr:openPanel("UITroopMsgPanel")
    local lStar = 1
    if self.troopPanel.curTroops.lHeroID and self.troopPanel.curTroops.lHeroID[1] ~= 0 then
        local heroDa = global.heroData:getHeroDataById(self.troopPanel.curTroops.lHeroID[1]) 
        if heroDa and heroDa.serverData then
            lStar = heroDa.serverData.lStar or 1
        end
    end
    panel:setData( self.troopPanel.curTroops, 0, lStar)
end

function UITroopItem:battle_click(sender, eventType)
    
    local lState = self.curBtnState

    if lState == 0 then
        self:waitOrder()
    elseif lState == 1 then
        self:station()
    elseif lState == 2 then
        self:callBackTroop()
    elseif lState == 3 then
        self:outTroop()
    elseif lState == 4 then
        self:gpsTroop()
    elseif lState == 5 then
        self:orderBack()
    elseif lState == 6 then
        self:revolt()
    elseif lState == 7 then
        self:cancelQiyi()
    elseif lState == 8 then
        self:execTeleport()
    end
end

function UITroopItem:revolt(  )
    
    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end

    if self.troopPanel then 
         
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("Qiyi01", function ()            
            global.worldApi:revolt({self.troopPanel.curTroops.lID},function()
                
                if global.scMgr:isWorldScene() then
                    global.panelMgr:closePanel("UITroopPanel")
                    global.g_worldview.mapPanel:closeChoose()
                end                
            end)
        end)
    end 
end

--- 遣返
function UITroopItem:orderBack()
    
    if not self.troopPanel then 
        -- protect 
        return 
    end  

    if self.troopPanel.curTroops.lAvator == 4 then
    
        global.tipsMgr:showWarning("OccupantCantRepatriate")
        return
    end

    global.worldApi:callStayBack(global.userData:getWorldCityID(),self.troopPanel.curTroops.lID,function()
        
        global.panelMgr:closePanel("UITroopPanel")
    end)
end

--- 待命
function UITroopItem:waitOrder()
    
    if not self.troopPanel then return end
    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("TroopsGarrison02", function ()
        global.cityApi:troopGarrison(self.troopPanel.curTroops.lID,6,function()
        end)
    end)
   
end
--- 召回
function UITroopItem:callBackTroop()
    
    local troopLandId = global.worldApi:decodeLandId(self.data.lTarget)
    local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())
    local errorcodeKey = 'TroopsBack'

    -- print('check land id',troopLandId,mainCityLandId)

    if troopLandId ~= mainCityLandId then
        errorcodeKey = 'TransmissionNo'
    end

    if self.data.lCollectSpeed then
        errorcodeKey = 'troopsAll03'
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorcodeKey,function () 
        if self.callBackCallBack then 
            self:callBackCallBack(true)  
        end 
    end)
end

function UITroopItem:cancelQiyi()
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("cancelQiyi", handler(self, self.cancelQiyiCallBack))
end

function UITroopItem:cancelQiyiCallBack()
    
    global.worldApi:callBackTroop(self.troopPanel.curTroops.lID,0,function()
        
        global.panelMgr:closePanel("UITroopPanel")
    end)
end

-- 奇迹传送
function UITroopItem:execTeleport()

    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end
    
    local targetData = global.troopData:getTargetData()
    if not targetData then return end
    local cityName = targetData.targetCityName
    local troopName = self.troopPanel.curTroops.szName
    local sname = luaCfg:get_all_miracle_name_by(targetData.targetCityId)
    if sname then
        cityName = sname.name
    else
        if global.userData:getWorldCityID()==targetData.targetCityId then
            cityName = luaCfg:get_local_string(10579)
        end
    end
    local tips =luaCfg:get_local_string(10908, troopName, cityName, luaCfg:get_local_string(10923))
    
    local cityId = targetData.targetCityId
    local fromId = self.troopPanel.curTroops.lCityID

    local pos1 = global.g_worldview.const:convertCityId2Pix(cityId)
    local pos2 = global.g_worldview.const:convertCityId2Pix(fromId)
    local len = cc.pGetDistance(pos1,pos2)
    local config = luaCfg:get_config_by(1)
    local cost = math.ceil(config.tpBaseCost + (len * config.tpDisPro / 10000))

    global.panelMgr:openPanel('UITpSpend'):setData({key_1 = troopName,key_2 = cityName,key_3 = math.ceil(len / 100),key_4 = cost},luaCfg:get_local_string(10903),cost,function()

        local chooseCityId = targetData.targetCityId
        local cityId = chooseCityId
        local areaId = 0
        local troopId = 0 
        if self.troopPanel then 
            troopId =  self.troopPanel.curTroops.lID
        end 
        global.worldApi:passTroop(cityId, areaId, troopId, function()
            global.tipsMgr:showWarning("PortOk")
            global.panelMgr:closePanel('UITpSpend')
        end,2)
    end)
end

function UITroopItem:callBackCallBack(notClose) 
    

    global.worldApi:callBackTroop(self.troopPanel.curTroops.lID,1,function()
        
        if not notClose then 
            global.panelMgr:closePanel("UITroopPanel")
        end 
    end)

    -- self:updataState()
end

--- 出征
function UITroopItem:outTroop()

    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end

    local outCall = function()
        
        if self.troopPanel:isRevolt() then

            global.tipsMgr:showWarning("JustCityTroops")  
            return
        end    

        local targetData = global.troopData:getTargetData() or {} --protect

        global.troopData:setContentOutId(self.troopPanel.curTroops.lID)

        -- 只有侦查部队才能侦查
        if targetData.attackMode == 3 then
            if not global.troopData:checkTroopType(self.troopPanel.curTroops) then
                global.tipsMgr:showWarning("NotScout")
                return
            end
        end

        if targetData.targetCityId == self.troopPanel.curTroops.lTarget then

            --CityTroopsOk

            if targetData.attackMode == 4 then
                global.tipsMgr:showWarning("CityTroopsOk")
            else
                global.tipsMgr:showWarning("GarrisonNotPK")
            end
            return
        end

        if global.scMgr:isWorldScene() then
        
            local city = global.g_worldview.mapPanel:getCityById(targetData.targetCityId)
            if city then
                if city:getRelationFlag() ==  1 and  city:getAvatarType() == 0 and targetData.attackMode == 4 then
                    global.tipsMgr:showWarning("NeutralCantGarrison")
                    return
                end
            end
        end   


        local pathTimeCall = function()
            global.worldApi:pathTime(global.userData:getWorldCityID(),targetData.targetCityId,self.troopPanel.curTroops.lID,targetData.attackMode,targetData.forceType,function(msg)
                
                local cutTime = msg.lRoadTime or 0

                if cutTime == 0 then
                    
                else
                    local hour = math.floor(cutTime / 3600) 
                    cutTime = cutTime  % 3600
                    local min = math.floor(cutTime / 60)
                    cutTime = cutTime % 60
                    local sec = math.floor(cutTime)

                    dump(targetData)
                    local cityName = targetData.targetCityName
                    local sname = luaCfg:get_all_miracle_name_by(targetData.targetCityId)
                    if sname then
                        cityName = sname.name
                    end
                    local troopName = "" 
                    if self.troopPanel and self.troopPanel.curTroops.szName then
                        troopName = self.troopPanel.curTroops.szName
                    end
                    if cityName==nil then cityName = "-" end
                    if troopName=="" then troopName = luaCfg:get_local_string(10140) end
                   
                    if  targetData.monsterType and  targetData.monsterType == 401 then -- 经验之泉 
                        global.ActivityAPI:ActivityListReq({2001},function(ret ,msg)
               
                            local panel = global.panelMgr:openPanel("UIPromptPanel")
                            panel:setData("TroopsBtn", handler(self, self.confirmCallBack))
                            if msg and msg.tagAct and msg.tagAct[1] and msg.tagAct[1].lParam then 
                                local attacked_count =  msg.tagAct[1].lParam 
                                local attack_count = luaCfg:get_wild_cfg_by(8).cfg
                                local surplus_count = attack_count - attacked_count
                                local tips =""
                                if surplus_count > 0  then
                                    tips =string.format(luaCfg:get_local_string(10660), troopName, global.troopData:getTargetStr(),cityName,hour,min,sec,surplus_count)
                                else                                     
                                    tips = string.format(luaCfg:get_local_string(10020), troopName, global.troopData:getTargetStr(),cityName,hour,min,sec, global.troopData:getOrderStr())
                                end  

                                panel.text:setString(tips)
                            else                                
                                panel.text:setString(string.format(luaCfg:get_local_string(10020), troopName,global.troopData:getTargetStr(), cityName,hour,min,sec, global.troopData:getOrderStr()))
                            end 
               
                            gevent:call(global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN)

                        end)
                    else 

                        local panel = global.panelMgr:openPanel("UIPromptPanel")
                        panel:setData("TroopsBtn", handler(self, self.confirmCallBack))                        
                        panel.text:setString(string.format(luaCfg:get_local_string(10020), troopName, global.troopData:getTargetStr(),cityName,hour,min,sec, global.troopData:getOrderStr()))                        

                        gevent:call(global.gameEvent.EV_ON_GUIDE_CHECK_ATTACK_BOARD_OPEN)
                    end 
                end
            end)
        end

        -- if self.troopPanel.curTroops.lHeroID then
        --     local curHeroId = self.troopPanel.curTroops.lHeroID[1]
        --     local heroData = global.heroData:getHeroDataById(curHeroId)
        --     if heroData and heroData.serverData and heroData.serverData.lCurHP <= 0 then
        --         local panel = global.panelMgr:openPanel("UIPromptPanel")
        --         panel:setData("HeroHpZero", pathTimeCall)
        --         return
        --     end    
        -- end

        pathTimeCall()
    end


    
    -- global.tipsMgr:showWarning(global.troopData:getTargetWarType() or 'never set target war type')

    local outCall2 = function()
        if global.troopData:getTargetCombat() > global.troopData:getCombat(self.troopPanel.curTroops.lID) then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("combat_insufficient", function ()
                outCall()
            end)
        else
            outCall()
        end
    end    
   
    local checkData = global.troopData:getTargetCheckData() 
    if checkData then
        -- 极限龙潭条件判断
        if checkData.checkType and checkData.checkType == 1 then
            if not global.bossData:checkAttackCondition(checkData.checkData, self.troopPanel.curTroops.lID) then
                return 
            end
        end
    end

    if global.troopData:getTargetWarType() then
        local warType = global.troopData:getTargetWarType()
        local secType = global.troopData:getTroopsHeroType(self.troopPanel.curTroops.lID)
        if warType ~= secType and warType ~= 3 then
            local errors = {'restraint02','restraint01'}
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData(errors[warType], function ()
                outCall2()
            end)
        else
            outCall2()
        end
    else
        outCall2()
    end
end

--- 驻防
function UITroopItem:station()

    if self.isDie then
        global.tipsMgr:showWarning("70")      
        return          
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("TroopsGarrison01", function ()
        global.cityApi:troopGarrison(self.troopPanel.curTroops.lID,10,function(msg)
        end)
    end)
end
--- 定位
function UITroopItem:gpsTroop()
    
    local id = self.troopPanel.curTroops.lID
    local userId = self.troopPanel.curTroops.lUserID
    if self.troopPanel then
        if self.troopPanel.curTroops.lState == 11 then

            global.funcGame:gpsWorldCity(self.troopPanel.curTroops.lTarget,self.troopPanel.curTroops.lWildKind)     
        else

            global.funcGame:gpsWorldTroop(id,userId)
        end 
    end
end

 -- 修改部队驻守行军状态
function UITroopItem:updataState()
    
    local troopId, lState = self.troopPanel.curTroops.lID, self.troopPanel.curTroops.lState
    self:refershTroopsState(lState)
    global.troopData:updataTroopsState(troopId, lState)
    
    local serverData = global.troopData:getTroopById(troopId)
    global.cityApi:troopManager(1, serverData, function(msg)
    end)
end

function UITroopItem:confirmCallBack()
    if not self.troopPanel then return end

    local targetData = global.troopData:getTargetData()

    local outID = self.troopPanel.curTroops.lID

    if targetData  then --protect 

        global.worldApi:attackCity(global.userData:getWorldCityID(),targetData.targetCityId,targetData.attackMode,outID,targetData.forceType,function(msg)
            
            global.panelMgr:closePanel("UITroopPanel")
            global.panelMgr:closePanelShowWorld() 

            if global.scMgr:isWorldScene() then
            
                if global.guideMgr:isPlaying() then

                    local worldPanel = global.g_worldview.worldPanel
                    if worldPanel.mapPanel.choose and worldPanel.mapPanel.choose.close then
                        worldPanel.mapPanel.choose:close()
                    end
                else
                    
                    global.g_worldview.worldPanel:chooseSoldier(outID,global.userData:getUserId())
                end            
            end        
        end)

    end 
end

function UITroopItem:onExit()
    
    self.troopPanel.BTN_FIRST = true
end


function UITroopItem:sort_event(sender, eventType)

    if not self.isEdit then
        return
    end

    if eventType == ccui.TouchEventType.began then
        self.touchBeginY = sender:getTouchBeganPosition().y
        self:setLocalZOrder(2)
        self.root:setOpacity(200)
        self.isMove = true
    elseif eventType == ccui.TouchEventType.moved then  
        local touchPosY = sender:getTouchMovePosition().y;        
        local offsetY = touchPosY - self.touchBeginY
        self.touchBeginY = touchPosY
        self:setPositionY(self:getPositionY() + offsetY)
        self.troopPanel:checkListPos(self:getPositionY() + offsetY,self)        
    elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
        self:setLocalZOrder(1)
        self.isMove = false
        self.troopPanel:checkListPos()
        self.root:setOpacity(255)
    end
end
--CALLBACKS_FUNCS_END

return UITroopItem

--endregion

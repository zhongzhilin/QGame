--region UITroopNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local stateEvent = global.stateEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITroopNode  = class("UITroopNode", function() return gdisplay.newWidget() end )

function UITroopNode:ctor()
    self:CreateUI()
end

function UITroopNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_troop_node")
    self:initUI(root)
end

function UITroopNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_troop_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ItemBg = self.root.ItemBg_export
    self.troops_list = self.root.ItemBg_export.troops_list_export
    self.no_hero = self.root.ItemBg_export.troops_list_export.no_hero_export
    self.list_name = self.root.ItemBg_export.troops_list_export.no_hero_export.list_name_export
    self.list_place = self.root.ItemBg_export.troops_list_export.no_hero_export.list_place_export
    self.list_relation = self.root.ItemBg_export.troops_list_export.no_hero_export.list_relation_export
    self.list_state = self.root.ItemBg_export.troops_list_export.no_hero_export.list_state_export
    self.list_scale = self.root.ItemBg_export.troops_list_export.no_hero_export.list_scale_export
    self.player_name = self.root.ItemBg_export.troops_list_export.no_hero_export.player_name_export
    self.player_relation = self.root.ItemBg_export.troops_list_export.no_hero_export.player_relation_export
    self.searchTroopSp = self.root.ItemBg_export.troops_list_export.no_hero_export.searchTroopSp_export
    self.empty1 = self.root.ItemBg_export.troops_list_export.no_hero_export.empty1_export
    self.empty2 = self.root.ItemBg_export.troops_list_export.no_hero_export.empty2_export
    self.node_killed = self.root.ItemBg_export.troops_list_export.node_killed_export
    self.troops_hero = self.root.ItemBg_export.troops_list_export.troops_hero_export
    self.hero_bg = self.root.ItemBg_export.troops_list_export.hero_bg_export
    self.nameBg = self.root.ItemBg_export.troops_list_export.nameBg_export
    self.nameBg1 = self.root.ItemBg_export.troops_list_export.nameBg1_export
    self.heroName = self.root.ItemBg_export.troops_list_export.heroName_export
    self.heroLv = self.root.ItemBg_export.troops_list_export.heroLv_export
    self.right = self.root.right_export
    self.left = self.root.left_export

--EXPORT_NODE_END
    self:initTextColor()        -- 字体颜色
    self.relationX = self.list_place:getPositionX() 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITroopNode:initTextColor()
    
    self.COLOR_OWNCOLOR = cc.c3b(255, 226, 165)  -- 浅黄色  (自己)
    self.COLOR_GREEN = cc.c3b(87, 213, 63)       -- 浅绿色  (同盟/联盟  、行军中)
    self.COLOR_YELLOW = cc.c3b(255, 208, 65)     -- 黄色    (中立)
    self.COLOR_RED = cc.c3b(180, 29, 11)         -- 红色    (敌对)
    self.COLOR_BLUE = cc.c3b(36, 108, 198)       -- 深蓝色  (驻守城内)
    self.COLOR_ORANGE = cc.c3b(255, 119, 57)     -- 橙色    (驻守城外)
end

function UITroopNode:setData(cellData)

    local data = cellData.cdata
    self.data = data
    self.fsm = global.stateMachine.new()
    self:initStateMachine(stateEvent.TROOP.STATE.STATION)
    self.left:setVisible(false)
    self.right:setVisible(false)
   
    if data.lHeroID == nil then data.lHeroID = {[1]=0} end
    if data.lHeroID[1] ~= 0 then 
        local heroData = global.heroData:getHeroDataById(data.lHeroID[1])
        global.panelMgr:setTextureFor(self.troops_hero,heroData.nameIcon)
        self.heroLv:setVisible(true)
        self.heroName:setVisible(true)
        heroData.serverData = heroData.serverData or {}
        self.heroLv:setString(luaCfg:get_local_string(10643, heroData.serverData.lGrade or 0))
        self.heroName:setString(heroData.name)
        self.nameBg1:setVisible(true)
        self.nameBg:setVisible(true)
        global.heroData:setHeroIconBg(data.lHeroID[1], self.left, self.right)

    else
        self.nameBg1:setVisible(false)
        self.nameBg:setVisible(false)
        self.heroLv:setVisible(false)
        self.heroName:setVisible(false)
        self.troops_hero:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
    end

    self.list_name:setString(data.szName)
    self.list_name:setTextColor(self.COLOR_OWNCOLOR)
    self.list_scale:setString(global.troopData:getCombat(data.lID))
    self.list_place:setTextColor(self.COLOR_OWNCOLOR)
    
    self:setLordName(data)
    self:refershTroopsState(data.lState)
    
    -- 是否是侦查部队
    if global.troopData:checkTroopType(data) then
        self.searchTroopSp:setVisible(true)
        self.list_name:setPositionY(91.5)
    else
        self.searchTroopSp:setVisible(false)
        self.list_name:setPositionY(66.5)
    end

    -- 是否死亡
    self:setDieState(data.troopScale == 0)
end

-- 军队状态
function UITroopNode:refershTroopsState( lState )

    self.list_relation:setVisible(false)
    self.list_place:setPositionX(self.relationX)

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

function UITroopNode:doEvent(event_name)
    if self.fsm and self.fsm:canDoEvent(event_name) then
        self.fsm:doEvent(event_name)
    end
end

function UITroopNode:setDieState(isDie)
    
    self.isDie = isDie
    self.node_killed:setVisible(isDie)    
    global.colorUtils.turnGray(self.no_hero,isDie)            

    self.list_place:setVisible(not isDie and self.list_place:isVisible())
    self.list_relation:setVisible(not isDie and self.list_relation:isVisible())
    self.list_state:setVisible(not isDie and self.list_state:isVisible())  
    self.list_scale:setVisible(not isDie and self.list_scale:isVisible())  
    self.empty1:setVisible(isDie)
    self.empty2:setVisible(isDie)
end

function UITroopNode:setPlaceString()
   
    self.data.lDstType = self.data.lDstType or 0
    self.data.lTarget = self.data.lTarget or 0
    if self.data.lDstType == 10 then

        local id,name = global.worldApi:decodeLandId(self.data.lTarget)
        self.list_place:setString(name)

        self.list_relation:setString("("..luaCfg:get_local_string(10302)..")")
        self.list_relation:setTextColor(self.COLOR_YELLOW )
        local posX = self.list_place:getAutoRenderSize().width/2 + self.relationX
        local listW = self.list_relation:getContentSize().width / 2
        self.list_relation:setPositionX(posX - listW)
        self.list_place:setPositionX(self.relationX - listW)
        self.list_relation:setVisible(true)
    else
        self.list_place:setString(self.data.szTargetName)
    end
end

function UITroopNode:initStateMachine(initial_state)
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
                self:setPlaceString()
    
            end,
            ["onenter"..stateEvent.TROOP.STATE.WAITORDER] = function(event)
         
                print(event.name.."待命中") 
                self.list_state:setString(luaCfg:get_local_string(10099))
                self.list_state:setTextColor(self.COLOR_GREEN)
                if self.data then
                    self.list_place:setString(self.data.szSrcName)
                end                

            end,
            ["onenter"..stateEvent.TROOP.STATE.REVOLT] = function(event)

                print(event.name.."战斗中")     
                self.list_state:setString(luaCfg:get_local_string(10210))
                self.list_state:setTextColor(self.COLOR_RED)
                self:setPlaceString()

            end,
            ["onenter"..stateEvent.TROOP.STATE.FIGHT] = function(event)

                print(event.name.."起义中")     
                self.list_state:setString(luaCfg:get_local_string(10100))
                self.list_state:setTextColor(self.COLOR_RED)
                self:setPlaceString()

            end,
            ["onenter"..stateEvent.TROOP.STATE.WALK] = function(event)

                print(event.name.."行军中")
                self.list_state:setString(luaCfg:get_local_string(10101))
                self.list_state:setTextColor(self.COLOR_RED)
                self:setPlaceString()
             
            end,
            ["onenter"..stateEvent.TROOP.STATE.BACK] = function(event)

                print(event.name.."返回中")
                self.list_state:setString(luaCfg:get_local_string(10102))
                self.list_state:setTextColor(self.COLOR_RED)
                self:setPlaceString()
              
            end,
            ["onenter"..stateEvent.TROOP.STATE.STATION_OTHER] = function(event)

                print(event.name.."驻守在其他城市")
                self:setPlaceString()
                local userId = global.userData:getUserId()
                if userId == self.data.lUserID then

                    self.list_state:setString(luaCfg:get_local_string(10098))   
                    self.list_state:setTextColor(self.COLOR_BLUE)
                    self.list_relation:setVisible(true)

                    local textColor = self.COLOR_OWNCOLOR
                    local lAvatorId = 0                     --  0中立 1自己 2同盟 3联盟 4敌对
                    local curState = 0
                    self.data.lDstType = self.data.lDstType or 0
                    if self.data.lDstType == 1 then
                        curState = self.data.lTargetAvator  -- 与驻防目标地关系 
                    else
                        curState = self.data.lOwnerAvator   -- 与驻防小村庄、营地奇迹等拥有者关系 
                    end

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
                    if (self.data.lWildKind and self.data.lWildKind == 1) or (lAvatorId == 1) then
                    else
                        str = luaCfg:get_local_string(lAvatorId) 
                    end

                    if self.data.lDstType ~= 10 then
                    
                        self.list_relation:setString(str)
                        self.list_relation:setTextColor(textColor)
                        local posX = self.list_place:getAutoRenderSize().width/2 + self.relationX
                        local listW = self.list_relation:getContentSize().width / 2
                        self.list_relation:setPositionX(posX - listW)
                        self.list_place:setPositionX(self.relationX - listW)
                    end                    
                end              
            end,              
        }
    })
end

function UITroopNode:setLordName(data)
    
    local textColor = gdisplay.COLOR_WHITE
    local posY = 0
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
            posY = 78.5
        else
            textColor = self.COLOR_OWNCOLOR
            self.player_relation:setVisible(false)
            posY = 66.5
        end
        self.player_name:setTextColor(textColor)
    else
        posY = 66.5
        self.player_name:setString("-")
    end
    self.player_name:setPositionY(posY)
end


function UITroopNode:item_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UITroopNode

--endregion

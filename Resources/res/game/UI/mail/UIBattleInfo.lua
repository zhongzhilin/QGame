
--region UIBattleInfo.lua
--Author : yyt
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UISoldierNode = require("game.UI.mail.UISoldierNode")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIBattleInfo  = class("UIBattleInfo", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIBattleInfo:ctor()
    self:CreateUI()
end

function UIBattleInfo:CreateUI()
    local root = resMgr:createWidget("mail/mall_war_info")
    self:initUI(root)
end

function UIBattleInfo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mall_war_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node1 = self.root.Node1_export
    self.text1 = self.root.Node1_export.info.text1_mlan_3.text1_export
    self.text2 = self.root.Node1_export.info.text2_mlan_3.text2_export
    self.text3 = self.root.Node1_export.info.text3_mlan_3.text3_export
    self.text4 = self.root.Node1_export.info.text4_mlan_3.text4_export
    self.buffIcon = self.root.Node1_export.buffIcon_export
    self.heroIcon = self.root.Node1_export.hero.Panel_1.heroIcon_export
    self.noUnlockIcon = self.root.Node1_export.hero.Panel_1.noUnlockIcon_export
    self.equip_1 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_1, self.root.Node1_export.hero.equip_1)
    self.equip_2 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_2, self.root.Node1_export.hero.equip_2)
    self.equip_3 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_3, self.root.Node1_export.hero.equip_3)
    self.equip_4 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_4, self.root.Node1_export.hero.equip_4)
    self.equip_5 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_5, self.root.Node1_export.hero.equip_5)
    self.equip_6 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.equip_6, self.root.Node1_export.hero.equip_6)
    self.heroExp = self.root.Node1_export.heroExp_export
    self.troopLayout = self.root.Node1_export.troopLayout_export
    self.troopScrollView = self.root.Node1_export.troopScrollView_export
    self.textLayout = self.root.Node1_export.textLayout_export
    self.textContent = self.root.Node1_export.textContent_export
    self.heroLv = self.root.Node1_export.heroLv_export
    self.noTroopText = self.root.Node1_export.noTroopText_mlan_20_export
    self.FileNode_1 = UIHeroStarList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node1_export.FileNode_1)
    self.left = self.root.Node1_export.left_export
    self.right = self.root.Node1_export.right_export
    self.touch = self.root.Node1_export.touch_export
    self.Node2 = self.root.Node2_export
    self.nameBoss = self.root.Node2_export.nameBoss_export
    self.textBoss = self.root.Node2_export.textBoss_export
    self.iconBoss = self.root.Node2_export.iconBoss_export

--EXPORT_NODE_END
    self.battlePanel = global.panelMgr:getPanel("UIMailBattlePanel")
    self.troopTypeId = 0
    self:initScrollSoldier()

    --引导
    self.guide_war = self.Node1.guide_war

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBattleInfo:onEnter()
    
    self:registerTouchListener()
    self.troopScrollView:addEventListener(handler(self, self.moveScro))
end

function UIBattleInfo:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 
end

function UIBattleInfo:moveScro(sender, eventType)
    
    if self.isMove then
        --log.debug("---- move")
        self.troopScrollView:setSwallowTouches(false)
        self.troopScrollView:setTouchEnabled(false)
    else
        --log.debug("----not move")
        self.troopScrollView:setSwallowTouches(true)
        self.troopScrollView:setTouchEnabled(true)
    end
     
end

function UIBattleInfo:registerTouchListener()
    
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    local contentMoveX, contentMoveY = 0, 0
    local beganPos, curPos = 0, 0

    local  listener = cc.EventListenerTouchOneByOne:create()

    local function touchBegan(touch, event)
        contentMoveX = 0
        contentMoveY = 0

       beganPos = touch:getLocation()
       return true
    end
    local function touchMoved(touch, event)
       
       local diff = touch:getDelta()
       contentMoveX = contentMoveX + math.abs(diff.x)
       contentMoveY = contentMoveY + math.abs(diff.y)

        curPos = touch:getLocation()

        local angle = self:getAngleByPos(beganPos, curPos)
        if (angle>-40 and angle < 40) or (angle>140 and angle <= 180) or (angle < -140 and angle > -180) then
            self.isMove = false
            self.battlePanel.isBattleMove=false
        else
            self.isMove = true
            self.battlePanel.isBattleMove=true
        end

    end
    local function touchEnded(touch, event)
        self.troopScrollView:setTouchEnabled(true)
        self.troopScrollView:setSwallowTouches(false)
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

end

function UIBattleInfo:getAngleByPos(p1,p2)  
    local p = {}  
    p.x = p2.x - p1.x  
    p.y = p2.y - p1.y  
             
    local r = math.atan2(p.y,p.x)*180/math.pi  
    -- print("夹角[-180 - 180]:",r)  
    return r  
end  


function UIBattleInfo:setData(data, troopType)

    self.Node1:setVisible(false)
    self.Node2:setVisible(false)

    self.isWorldBoss = false
    local lfightType = self.battlePanel:getMailFightType()
    if lfightType == 9 and data.lTroopID == 0 then
        
        self.isWorldBoss = true
        self.Node2:setVisible(true)

        local battlePanel = global.panelMgr:getPanel("UIMailBattlePanel")
        local fightData = battlePanel.data.tgFightReport
        if fightData then
            local bossId = tonumber(fightData.szDefName)
            local bossConfig = global.luaCfg:get_worldboss_by(bossId)
            self.nameBoss:setString(bossConfig.name)
            global.panelMgr:setTextureFor(self.iconBoss, bossConfig.mailicon)
            uiMgr:setRichText(self, "textBoss", 50295, {hp=data.tgSoldiers[1].lKilled})
        end 

    else

        self.Node1:setVisible(true)
        self.noTroopText:setVisible(false)

        self.data = data
        self.troopTypeId = troopType
        self:initInfo(data)

        self.guide_war:setName("guide_war" .. self.troopTypeId)
        
        if data.tgSoldiers then
            table.sort(data.tgSoldiers, function(s1, s2) return s1.lID < s2.lID end)
        end
        -- self:initScrollSoldier(data.tgSoldiers)
        
        for i = 1,11 do

            local item = self.soldierItem[i]
            local soldierData = data.tgSoldiers
            if soldierData and soldierData[i] then
                item:setData(soldierData[i], self.troopTypeId)
            else
                if self.battlePanel:checkUnLock(5, self.troopTypeId) then
                    item:setData(nil)
                else
                    item:setData(nil, true)
                end
            end
        end

    end

end

function UIBattleInfo:initInfo(data) 

    local troopMsg = self.battlePanel:getTroopMsg(data.lTroopID, data.lUserID, self.troopTypeId)

    if troopMsg then

        local str1 = self:checkStr(troopMsg.szName)
        local str2 = self:checkStr(troopMsg.lAllyName)
        self.text1:setString(str1)
        self.text2:setString(str2)
    else
        self.text1:setString("-")
        self.text2:setString("-")
    end

    if data.lTroopID == 0 then
        self.text3:setString(luaCfg:get_local_string(10161))
    else
        self.text3:setString(self:checkStr(data.szTroopName))
    end

    local lfightType = self.battlePanel:getMailFightType()

    if self.troopTypeId == 1 then

        local state = data.lPurpose
        -- 起义
        if state == 2 then
            state = 10124
        elseif state == 1 then
            state = 10125
        elseif  state == 6 then
            state = 10126
        elseif  state == 7 then
            state = 10210
        elseif  state == 3 then
            state = 10684
        else
            print("--- type error")
            state = 10124
        end

        local troopParm = self.battlePanel:getTroopParm()
        if troopParm == 1 then
            state = 10127
        elseif troopParm == 2 then
            state = 10703
        end

        self.text4:setString(luaCfg:get_local_string(state))
    
    else
       
        if lfightType == 2  or lfightType == 3 or lfightType == 8 or lfightType == 18 then
            local typeId, troopType = 0, 0
            if data.lPurpose == 6 then      --反扑
                typeId = 10189
                troopType = 10191
            elseif data.lPurpose == 10 then --防御
                typeId = 10127
                troopType = 10190
            end
            if data.lTroopID == 0 then  
                self.text1:setString(self.battlePanel:getMailAllName())    
                self.text3:setString(luaCfg:get_local_string(troopType))  
                self.text4:setString(luaCfg:get_local_string(typeId))
            else
                self.text4:setString(luaCfg:get_local_string(10127))                 
            end

        elseif lfightType == 5  or lfightType == 7 then

            local defUseData = self.battlePanel:getMailTagUser() 
            if table.nums(defUseData) > 0 then
                self.text1:setString(self:getLeaderName(defUseData))
            else
                self.text1:setString(self.battlePanel:getMailAllName())
            end
            if data.lTroopID == 0 then 
                local defTroopType = lfightType == 7 and data.szTroopName or self.battlePanel:getDefName()
                self.text3:setString(self:checkStr(self:getMiracleTroopName(defTroopType)))
            end
            self.text4:setString(luaCfg:get_local_string(10127))
        else
            -- 侦查战报
            if self:isInvestBattle() then

                if data.lPurpose == 6 then
                    self.text4:setString(luaCfg:get_local_string(10095))
                elseif data.lPurpose == 10 then
                    self.text4:setString(luaCfg:get_local_string(10096))
                else
                    self.text4:setString(luaCfg:get_local_string(10127))
                end

            else
                self.text4:setString(luaCfg:get_local_string(10127))
            end
        end 
    end

    if not self.battlePanel:checkUnLock(4, self.troopTypeId) then
        self.text1:setString("?")
        self.text2:setString("?")
        self.text3:setString("?")
    end 
    if not self.battlePanel:checkUnLock(6, self.troopTypeId) then
        self.text4:setString("?")
    end

    -- 空部队处理
    if data.lTroopID and data.lTroopID == -1 then  
        self.text4:setString("-")
        self.noTroopText:setVisible(true)
    end

    -- 英雄属性显示
    local isShowHeroProperty = function (isShow)
        -- body
        self.FileNode_1:setVisible(isShow)
        self.left:setVisible(isShow)
        self.right:setVisible(isShow)
        self.heroLv:setVisible(isShow)
    end

    self.noUnlockIcon:setVisible(false)
    if data.lHeroID and data.lHeroID ~= 0 then 
        local heroData = global.heroData:getHeroPropertyById(data.lHeroID)
        if heroData then
            -- self.heroIcon:loadTexture(heroData.nameIcon, ccui.TextureResType.plistType)
            global.panelMgr:setTextureFor(self.heroIcon,heroData.nameIcon)
            self.FileNode_1:setData(data.lHeroID, data.lHeroClass or 0)
            -- self.hero_quality:setVisible(heroData.quality == 2)

            data.lHerolv = data.lHerolv or 0
            if data.lHerolv <= 0 and (not self:isInvestBattle()) then
                isShowHeroProperty(false)
                self.heroIcon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
                -- self.hero_quality:setVisible(false)
            else
                isShowHeroProperty(true)
                self.heroLv:setString(luaCfg:get_local_string(10643, data.lHerolv))
            end

            data.lExp = data.lExp or 0
            local isShowExp = data.lExp <= 0  -- or (self.troopTypeId ~= 1)
            if isShowExp then
                self.heroExp:setVisible(false)
            else
                self.heroExp:setVisible(true)            
                self.heroExp:setString(luaCfg:get_local_string(10642, data.lExp))
            end
            global.heroData:setHeroIconBg(data.lHeroID, self.left, self.right)

        end
    else 
        self.heroIcon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
        self.heroExp:setVisible(false)
        isShowHeroProperty(false)
        -- self.hero_quality:setVisible(false)
    end

    if not self.battlePanel:checkUnLock(8, self.troopTypeId) then

        self.noUnlockIcon:setVisible(true)
        self.heroIcon:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
        self.heroExp:setVisible(false)
        isShowHeroProperty(false)
        -- self.hero_quality:setVisible(false)
    end

    local moniData = data.lEquips or {}
    local equipData = global.equipData
    local bodyList = {}
    for _,eData in ipairs(moniData) do
        if eData.lGID then 
            equipData:bindConfData(eData)
            eData.lID = 0
            if eData.confData and eData.confData.type then
                bodyList[eData.confData.type] = eData
            end
        end
    end

    equipData:calculateSuitData(moniData)

    for i=1,6 do
        
        local equip = self["equip_" .. i]

        local eData = bodyList[i]

        if eData and eData.confData then
            equip:setData(eData.confData,nil,eData.lStronglv)
            equip:setCallback(function()
                --if not self.isMove then
                    global.panelMgr:openPanel("UIEquipPutDown"):setData(eData,true):setEquipInfo(false,0,true,nil)
                --end
            end)

            if eData.lStronglv == 0 then
                equip.root.lv:setVisible(false)
            else
                equip.root.lv:setVisible(true)
                equip.root.lv:setString(":"..eData.lStronglv)
            end

            
        else
            equip:setEmptyIndex(i)
            equip.root.lv:setVisible(false)
        end
        equip.icon:setSwallowTouches(false)
        equip.icon:setZoomScale(0)
        equip.icon:setTouchEnabled(false)
    end


    if not self.battlePanel:checkUnLock(9, self.troopTypeId) then
        for i=1,6 do
            local equip = self["equip_" .. i]
            equip:setEmptyIndex(i, true)
            equip.root.lv:setVisible(false)
            equip.icon:setSwallowTouches(false)
            equip.icon:setZoomScale(0)
            equip.icon:setTouchEnabled(false)
        end
    end


    -- 新手引导特殊战报处理
    if not self.battlePanel:getMailAtkUser() and self.troopTypeId == 1 then
        local moniData = luaCfg:get_wild_monster_by(3000013)
        self.text1:setString(moniData.name)
        self.text3:setString(luaCfg:get_local_string(10093))
        local tempData = global.heroData:getHeroPropertyById(10001)
        global.panelMgr:setTextureFor(self.heroIcon,tempData.nameIcon)
        self.FileNode_1:setData(10001, 5)
        self.FileNode_1:setVisible(true)
        self.left:setVisible(true)
        self.right:setVisible(true)
        self.left:loadTexture('ui_surface_icon/hero_Pokedex03.png',ccui.TextureResType.plistType)
        self.right:loadTexture('ui_surface_icon/hero_Pokedex03.png',ccui.TextureResType.plistType)
        self.heroLv:setVisible(true)
        self.heroLv:setString(luaCfg:get_local_string(10643, 10))

        local equipData = {}
        local suitData = luaCfg:get_equipment_suit_by(16).equipment
        for i,v in ipairs(suitData) do
            local equips = luaCfg:get_equipment_by(v)
            table.insert(equipData, equips)
        end
        for i=1,6 do
            local equip = self["equip_" .. i]
            equip:setData(equipData[i],nil,9)
            equip.root.lv:setVisible(true)
            equip.root.lv:setString(":"..10)
            equip.icon:setSwallowTouches(false)
            equip.icon:setZoomScale(0)
            equip.icon:setTouchEnabled(false)
        end

    end

    if not self.battlePanel:getMailAtkUser() and self.troopTypeId == 2 then
        local heroData = global.heroData:getHeroPropertyById(data.lHeroID or 0)
        if heroData then
            global.panelMgr:setTextureFor(self.heroIcon,heroData.nameIcon)
        end
    end


    local tempdata ={information={}, tips_type="UIBuffDes",} 
    tempdata.itemAdd = self:getBuffAddByFrom(7)
    tempdata.divineAdd = self:getBuffAddByFrom(5)
    local isExitBuff = tempdata.itemAdd[2] ~= 0 or tempdata.divineAdd[2] ~= 0
    self.buffIcon:setVisible(isExitBuff)
    if isExitBuff then
        -- tips
        if not self.m_TipsControl  then 
            self.m_TipsControl = UIItemTipsControl.new()
            local mailPanel = global.panelMgr:getPanel("UIMailBattlePanel")
            self.m_TipsControl:setdata(self.touch, tempdata, mailPanel.tips_node)
        else 
            self.m_TipsControl:updateData(tempdata)
        end
    else
        if self.m_TipsControl then 
            self.m_TipsControl:ClearEventListener()
            self.m_TipsControl  = nil 
        end
    end

end

function UIBattleInfo:getBuffAddByFrom(lFrom)

    local tagbuffEffectFight = self.data.tagbuffEffectFight or {}
    for k,v in pairs(tagbuffEffectFight) do
        if v.lFrom == lFrom then
            local temp = {}
            table.insert(temp, v.lBuffId)
            table.insert(temp, v.lBuffValue)
            return temp
        end
    end
    return {0, 0}
end

-- 是否是侦查战报
function UIBattleInfo:isInvestBattle()
    return self.battlePanel:getBattlePurpose() == 3
end

-- 通过userid 去查找领主名称
function UIBattleInfo:getLeaderName(defUseData)

    for _,v in pairs(defUseData) do
        if v.lUserID == self.data.lUserID then
            return v.szName
        end
    end
    return ""
end

-- 获取奇迹部队名称
function UIBattleInfo:getMiracleTroopName(lType)
    
    lType = tonumber(lType)

    local lfightType = self.battlePanel:getMailFightType()
    if lfightType == 5 then

        local campData = luaCfg:world_camp()
        for _,v in pairs(campData) do
            if v.type == lType then            
                return  luaCfg:get_local_string(v.troopName)
            end
        end
    else
        local miracleData = luaCfg:miracle_reward()
        for _,v in pairs(miracleData) do
            if v.type == lType then
                return v.troopName
            end
        end
    end
    return self.data.szTroopName
end

function UIBattleInfo:checkStr( strName )
    local str = ""
    if strName and strName ~= "" then
        str = strName
    else
        str = "-"
    end
    return str
end

-- function UIBattleInfo:getStrWidth(str)
--     self.textContent:setString(str)
--     local maxWidth = self.textContent:getContentSize().width
--     return maxWidth
-- end

-- function UIBattleInfo:setShortStr(str, width, i)

--     local maxWidth = self.textLayout:getContentSize().width
--     if width > maxWidth then
--         self["dian"..i]:setVisible(true)
--         self:setTextLength( self["text"..i], 50, str )
--     else
--         self["dian"..i]:setVisible(false)
--         self:setTextLength( self["text"..i], 50, str )
--     end
    
-- end

-- function UIBattleInfo:setTextLength( text, width, str )
    
--     text:setTextAreaSize(cc.size(width,  23))
--     text:setString("")
--     local label = text:getVirtualRenderer()
--     local desSize = label:getContentSize()
--     text:setContentSize(desSize)
-- end


function UIBattleInfo:initScrollSoldier() 

    self.troopScrollView:removeAllChildren()
    local sW = self.troopLayout:getContentSize().width 
    
    local soldierType = 11
    self.soldierItem = {}
    for i=1,soldierType do
        local item = UISoldierNode.new()
        item:setAnchorPoint(cc.p(0, 0))
        item:setPosition(cc.p(sW*(i-1), 0))
        self.soldierItem[i] = item        
        self.troopScrollView:addChild(item)
    end
    
    local contentSize = self.troopScrollView:getContentSize().width
    local containerSize = soldierType*sW+5
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.troopScrollView:setInnerContainerSize(cc.size(containerSize, self.troopScrollView:getContentSize().height))
    self.troopScrollView:jumpToTop()
end

--CALLBACKS_FUNCS_END

return UIBattleInfo

--endregion

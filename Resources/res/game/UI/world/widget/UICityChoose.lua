--region UIEnemyChoose.lua
--Author : untory
--Date   : 2016/09/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")
local UIWorldBtnCoords = require("game.UI.world.widget.UIWorldBtnCoords")
local UIWorldWildCoords = require("game.UI.world.widget.UIWorldWildCoords")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICityChoose  = class("UICityChoose", function() return gdisplay.newWidget() end )


local CALLBACKS = {

    [1] = "troopInfo",    
    [2] = "callBackTroop",
    [3] = "troopAccelerate",
    [4] = "troopAgent",
    [5] = "castleInfo",
    [6] = "gotoMainCity",
    [9] = "attackInfo",
    [11] = "attack",
    [12] = "villageInfo",
    [13] = "collect",
    [14] = "moveCity", 
    [8] = "fireCity",   
    [15] = "garrisonMgr",
    [16] = "revolt",
    [17] = "giveupOcc",
    [31] = "giveupOcc",
    [7] = "openTips",
    [19] = "showMiracleDoorInfo",
    [21] = "showMiracleDoorReward",
    [20] = "showMiracleDoorHistory",
    [18] = "showMagicAfterOwnCityChoose",
    [22] = "showMiracleDoor",
    [23] = "openStop",
    [24] = "stopOpenStop",
    [25] = "kindInfo",
    [27] = 'AttackWildRes',
    [30] = 'BattleWildRes',
    [26] = 'InfoWildRes',
    [29] = 'ItemWildRes',
    [28] = 'recallAllTroop',
    [32] = 'collectWildRes',
    [33] = 'leaugeInvite',
    [34] = "moveCity", 
    [35] = 'showMiracleDoorInfo1'
}

local SPECIAL_CALLBACKS = {
                        
    [101] = "showTown",
    [102] = "showMagic",
    [103] = "showMagicAfterOwn",    
    [104] = "showPassDoor",
    [105] = "showPassDoorRandom",
    [106] = "showKing",
    [999] = "showNoOpen",
}


setmetatable(CALLBACKS, {__index = function(table,key)
    
    return "default"
end})

function UICityChoose:ctor(obj)
  
    self:CreateUI(obj)
    
    -- if global.g_worldview.is3d then

    --     local rotation = self:getRotation3D()
    --     self:setRotation3D(cc.vec3(rotation.x+25,rotation.y,rotation.z))
    -- end
end

function UICityChoose.showTown(city)
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_wildcity")

    global.worldApi:getMonsterTownInfo(city:getId(),function(msg)
                
        msg.lType = city:getType()
        global.panelMgr:openPanel("UIWildTown"):setData(msg,city)
    end)    
end

function UICityChoose.showNoOpen(city)
    
    global.tipsMgr:showWarning("NotOpen")
end

function UICityChoose.showPassDoor( city )
    
    if global.userData:isOpenFullMap() then

        gevent:call(gsound.EV_ON_PLAYSOUND,"world_transfer_1")
        global.panelMgr:openPanel("UIPassDoorPanel"):setCity(city)
    else
        global.tipsMgr:showWarning('banPortal')
    end    
end

function UICityChoose:showKing( city )
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")
    global.panelMgr:openPanel("UIKingBattlePanel")  
end

function UICityChoose.showPassDoorRandom( city )
    
    if global.userData:isOpenFullMap() then
        
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_transfer_1")
        global.panelMgr:openPanel("UIPassDoorRandomPanel"):setCity(city)
    else
        global.tipsMgr:showWarning('banPortal')
    end 
end

function UICityChoose.showMagic( city )
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")
    
    --getMagicTownInfo
    global.worldApi:getMagicTownInfo(city:getId(),function(msg)
        if city and city.getType then
            msg.lType = city:getType()
        end
        global.panelMgr:openPanel("UIMagicTown"):setData(msg,city)
    end)
end

function UICityChoose.showMagicAfterOwn( city )
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")
    --getMagicTownInfo    
    global.worldApi:getMagicTownInfoAfterOwn(city:getId(),function(msg)
        
        if city and city.getType then --保护处理
            msg.lType = city:getType()
        end 

        global.panelMgr:openPanel("UIMagicOwnPanel"):setData(msg,city)
    end)
end

function UICityChoose:showMiracleDoor()

    -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")

    if self.city:isOccupire() then
        local panel = global.panelMgr:openPanel("UIMiracleDoorAfterOwnPanel")
        panel:setData(self.city.data,self.city)
        panel:setObj(self.city) 
    else
        local panel = global.panelMgr:openPanel("UIMiracleDoorPanel")
        panel:setData(self.city.data,self.city)
        panel:setObj(self.city) 
    end    

    self:close()
end



function UICityChoose:showMiracleDoorHistory()
    
    global.panelMgr:openPanel("UIMiracleDoorHistoryPanel"):setData(self.city:getId())
    -- global.panelMgr:openPanel("UIMiracleDoorRewardPanel"):setType(self.city:getType())
end

function UICityChoose:showMiracleDoorReward()
    
    global.panelMgr:openPanel("UIMiracleDoorRewardPanel"):setType(self.city:getType(),self.city)
end

function UICityChoose:showMiracleDoorInfo()
    
    global.panelMgr:openPanel("UIMiracleDoorInfoPanel"):setData(luaCfg:get_activity_by(4001),true)
end

function UICityChoose:showMiracleDoorInfo1()
    
    local cityID = self.city:getId()
    local temple_activity = luaCfg:temple_activity()
    local activityId = 51001
    for _,v in ipairs(temple_activity) do
        if v.to_temple == cityID then
            activityId = v.activity_id
        end
    end

    global.panelMgr:openPanel("UIMiracleDoorInfoPanel"):setData(luaCfg:get_activity_by(activityId),true)
end

function UICityChoose:showMagicAfterOwnCityChoose( city )
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"world_miracle")

    local city = self.city
    global.worldApi:getMagicTownInfoAfterOwn(city:getId(),function(msg)
                
        msg.lType = city:getType()
        global.panelMgr:openPanel("UIMagicOwnPanel"):setData(msg,city)
    end)
end

function UICityChoose.checkIsHavaBtn(city)

    print(">>>>>>>>>>function UICityChoose.checkIsHavaBtn(city)")
    
    local cityType = city:getType()
    local level = city:getLevel()

    local surface = luaCfg:world_surface()
    for _,i in pairs(surface) do
        if cityType == i.type and level == i.level then

            local allCount = #i.staticbtn
            for j,i in ipairs(i.staticbtn) do

                local btnInfo = luaCfg:get_world_btn_by(i)        
                local triggerId = btnInfo.triggerId
                if not (triggerId == "") then

                    if city[triggerId] and city[triggerId](city) then
                        --如果有这个判断，并且条件满足
                    else

                        allCount = allCount - 1
                    end
                end
            end

            if allCount == 1 then

                local btn = i.staticbtn[1]

                if btn == -1 then

                    return false
                elseif SPECIAL_CALLBACKS[btn] ~= nil then

                    global.g_worldview.worldPanel.chooseCityName = city:getName() 
                    global.g_worldview.worldPanel.chooseCityId = city:getId()
                    global.g_worldview.worldPanel.chooseCity = city
                    UICityChoose[SPECIAL_CALLBACKS[btn]](city)
                    return false
                else

                    return true
                end
            else

                return true
            end

            -- return not (#i.staticbtn == 1 and i.staticbtn[1] == -1)
        end
    end
end

function UICityChoose:CreateUI(obj)

    print(">>>>>>>>>>>function UICityChoose:CreateUI(obj)")

    self.isClosed = false
    local cityType = obj:getType()
    local level = obj:getLevel()

    local surface = luaCfg:world_surface()
    self.staticbtn = {}
    local surfaceData = nil

    for _,i in pairs(surface) do
        if cityType == i.type and level == i.level then

            self.staticbtn = clone(i.staticbtn)
            surfaceData = i
        end
    end

    self:checkStaticBtn(obj)

    self.csbName = string.format("world/world_ui_btn%d",#self.staticbtn)
    log.debug(csbName)
    local root = resMgr:createWidget(self.csbName)
    self:initUI(root,obj)
    self.root:setPositionY(surfaceData.Ydeviation)
end

function UICityChoose:checkStaticBtn(obj)
    
    local removeList = {}

    for j,i in ipairs(self.staticbtn) do

        local btnInfo = luaCfg:get_world_btn_by(i)        
        local triggerId = btnInfo.triggerId
        if not (triggerId == "") then

            if obj[triggerId] and obj[triggerId](obj) then
                --如果有这个判断，并且条件满足
        
            else
        
                removeList[j] = true
                -- table.insert(removeList,j)
                -- table.remove(self.staticbtn,j)
            end
        end
    end

    for i = #self.staticbtn, 1, -1 do
        if removeList[i] then
            table.remove(self.staticbtn, i)
        end
    end
end

function UICityChoose:initUI(root,obj)

    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, self.csbName)
    
    for j,i in ipairs(self.staticbtn) do

        local btnInfo = luaCfg:get_world_btn_by(i)

        local btn = self.root["btn"..j.."_export"]

        btn.btn1:setName("world_btn_" .. i)
        btn.btn1.name_export.Text_1:setString(btnInfo.text)
        btn.btn1.icon:setSpriteFrame(btnInfo.icon)

        uiMgr:addWidgetTouchHandler(btn.btn1, function(sender, eventType) 
            if not self.isClosed then
                self[CALLBACKS[i]](self,sender,eventType) --attack(sender, eventType) 
            end            
        end)
    end


    local nodeTimeLine = resMgr:createTimeline(self.csbName)
    nodeTimeLine:setLastFrameCallFunc(function()

    end)
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)
    self.nodeTimeLine = nodeTimeLine
end

function UICityChoose:setData(data)
    

end

function UICityChoose:openStop()
    self.mainCityLv = global.cityData:getTopLevelBuild(1).serverData.lGrade
    if self.mainCityLv < luaCfg:get_config_by(1).warnLv then
        
        global.tipsMgr:showWarning("UnlockAction",luaCfg:get_config_by(1).warnLv)
        return
    end

    if not global.userData:isEventGuideDone(luaCfg:get_guide_stage_by(9).Key) then
        gevent:call(global.gameEvent.EV_ON_GUIDE_WARIN)
    else
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData(10194, function()

            global.worldApi:setAlert(1, function(msg)

                -- self.city.stop:setVisible(true)
                if self.close then
                    self:close()
                end
            end)        
        end)
    end

end

function UICityChoose:kindInfo()
    
    global.panelMgr:openPanel('UIOfficalPanel'):setData()
end

function UICityChoose:BattleWildRes(sender,obj)
    
    local attackBoard = UIAttackBoard.new()
    attackBoard.m_isWild = true
    attackBoard:setCity(self.city)
    local pos = cc.p(self:convertToNodeSpace(sender:getParent():convertToWorldSpace(cc.p(sender:getPosition()))))
    attackBoard:setPosition(pos)
    self:addChild(attackBoard)
    
    self.attackBoard = attackBoard
end

function UICityChoose:InfoWildRes(sender,obj)
    
    -- dump(self.city.data,'.....check data')
    global.panelMgr:openPanel('UIWolrdWildNewPanel'):setData(self.city.data)
end

function UICityChoose:ItemWildRes()
    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 行军加速道具使用
    panel:setData(nil,luaCfg:get_citybuff_by(10),panel.TYPE_BUFF_ADD, nil)
end

function UICityChoose:AttackWildRes()

    local lv = self.city.designerData.level
    local resLevel = global.userData:getResLevel()
    local resLevelData = luaCfg:get_map_unlock_by(resLevel)

    if lv > resLevelData.MaxLv then
        local map_unlocks = luaCfg:map_unlock()
        for _,v in ipairs(map_unlocks) do
            if lv <= v.MaxLv then            
                global.tipsMgr:showWarning('499',v.KeyLv)
                return
            end
        end
    end

    local afterCheckOccupyCall = function()
        
        global.troopData:setAttackType(1)
        global.troopData:setTargetData(1)    
        global.panelMgr:openPanel("UITroopPanel")
    end

    global.worldApi:checkOccupy(self.city,function(msg)
   
        if msg.lStatus == 0 then

            afterCheckOccupyCall()
        else

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("MaxOccupy", afterCheckOccupyCall)
            panel:setCancelLabel(10948):setCancelCall(function()
                global.panelMgr:openPanel("UIPandectPanel"):initData(4)
            end)
        end
    end)
end

function UICityChoose:stopOpenStop()
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10195, function()
    
        global.worldApi:setAlert(0, function(msg)

            -- self.city.stop:setVisible(false)
            if self.close then
                self:close()
            end
        end)
    end)

end

function UICityChoose:moveCity()
    
    -- local id = global.panelMgr:getPanel("UIWorldPanel").mainID

    --模拟一次假的迁城
    local tempData = global.guideMgr:getTempData()
    if tempData and type(tempData) == 'table' then
        
        local cityData = global.guideMgr:getTempData()
        local res = {lCitys = {cityData.sData}}        
        global.g_worldview.areaDataMgr:cityNotify(res)       
        global.guideMgr:setTempData(nil)
        self:close()

        gevent:call(gsound.EV_ON_PLAYSOUND,"world_movecity")

        return
    end

    local itemData = global.normalItemData:getItemById(11701)

    -- 神兽免费迁城技能
    if global.petData:isCanUsePetSkill(7001) then

        local panel = global.panelMgr:openPanel("UIPromptPanel")        
        panel:setData("moveCitySkill02", function()
            if self.moveCityCall then
                self:moveCityCall(true)
            end
        end)
        return

    elseif itemData.count <= 0 then

        -- global.tipsMgr:showWarning("NoThisItem")
        global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId = 10853,target = 3})
        self:close()
        return
    end    

    if self.moveCityCall then
        self:moveCityCall()
    end
    
end

function UICityChoose:moveCityCall(isUsePetSkill)

    local checkMoveCityCall = function()
        if tolua.isnull(self) then return end
        self:moveCityCall(isUsePetSkill)
    end
    if global.userData:checkCD(27,"MovedToCity02",checkMoveCityCall) then

        return
    end

    if tolua.isnull(self.city) then return end

    -- local reslv = global.g_worldview.const:convertCityId2ResLevel(self.city:getId())
    -- local unlockData = luaCfg:get_map_unlock_by(reslv)
    -- local keyLv = unlockData.KeyLv
    -- local mainCityLevel = global.cityData:getMainCityLevel()

    -- if keyLv > mainCityLevel then
        -- global.tipsMgr:showWarning("flycity01",keyLv,unlockData.name)
        -- return
    -- end

    global.worldApi:checkMainCityProtect(function(isProtect,protectType)
        
        local openCall = function()
            
            if tolua.isnull(self.city) then return end
            
            local worldPanel = global.g_worldview.worldPanel
            global.worldApi:moveCity(self.city:getId(),function(msg)

                global.g_worldview.mapPanel:flushPanel()

                if self.close then 
                    self:close()
                end 

                if isUsePetSkill then 
                    global.petData:refershActiveSkill()
                end

            end)
        end

        local tmpCall = function()
            
            if isProtect then

                local time = 0
                if protectType == 1 then -- 新手保护

                    local panel = global.panelMgr:openPanel("UIPromptPanel")        
                    panel:setData("MovedToCity01", function()
                            
                            global.worldApi:removeProtection(openCall)
                        end)
                else

                    local panel = global.panelMgr:openPanel("UIPromptPanel")        
                    panel:setData("MovedToCity03", function()
                            
                            global.worldApi:removeProtection(openCall)
                        end,global.luaCfg:get_config_by(1).protectCD / 60)
                end                 
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")        
                panel:setData("MovedToCity01", openCall)
            end
        end        
    
        if global.troopData:isEveryTroopIsInsideCity() then

            tmpCall()
        else

            local panel = global.panelMgr:openPanel("UIPromptPanel")        
            panel:setData("CityMoveTroopsNo", function()
                    
                tmpCall()
            end)
        end

        -- checkCall()
    end) 

end

function UICityChoose:openTips(sender,obj)
    
    global.worldApi:queryTips(global.g_worldview.worldPanel.chooseCityId, 50, 0, function(msg)
       
        global.panelMgr:openPanel("UITipsPanel"):setData(msg)     
    end)    

    -- global.panelMgr:openPanel("UITipsPanel"):setData(msg) 
end

function UICityChoose:close(isInEnd)
    
    local mapPanel = global.g_worldview.mapPanel
    mapPanel.preChooseCity = nil
    self.isClosed = true
    if self.coords then
        self.coords:removeFromParent()
        self.coords = nil
    end    

    if isInEnd then

        self.city:beUnChoose()
        -- self.city.target:setVisible(false)
        self:removeFromParent()
    else
  
        if self.attackBoard and not tolua.isnull(self.attackBoard) then self.attackBoard:runAction(cc.RemoveSelf:create()) end

        if not tolua.isnull(self.city) then
           self.city:beUnChoose()
        end

        self.root:stopAllActions()

        local nodeTimeLine = resMgr:createTimeline(self.csbName)
        nodeTimeLine:setLastFrameCallFunc(function()

            self:removeFromParent()
        end)
        nodeTimeLine:play("animation1", false)
        self.root:runAction(nodeTimeLine)
    
        self.root.size_rect:setTouchEnabled(true)
    end
end

function UICityChoose:checkOutScreen(opeBtnNode)
    local screenPos = self:convertToWorldSpace(cc.p(0,0))
    
    local size = self.root.size_rect:getContentSize()
    local rect = cc.rect(screenPos.x-size.width*0.5,screenPos.y-size.height*0.5,size.width,size.height)

    local offset = {
        x = 0,
        y = 0,
    }

    local inchx = 0
    local inchy = 0
    if rect.x < inchx then
        offset.x = inchx-rect.x
    end

    local screen_height = gdisplay.height - 300

    if rect.x+rect.width > gdisplay.width-inchx then
        offset.x = gdisplay.width-(rect.x+rect.width)
    end
    if rect.y < inchy then
        offset.y = inchy-rect.y
    end
    if rect.y+rect.height > screen_height-inchy then
        offset.y = screen_height-(rect.y+rect.height)
    end
    
    local scrollview = global.panelMgr:getPanel("UIWorldPanel").m_scrollView
    local off = scrollview:getContentOffset()
    off.x = off.x + offset.x
    off.y = off.y + offset.y

    scrollview:setContentOffset(off,true)
end

function UICityChoose:noOpenAction()
    
    if self.nodeTimeLine then

        self.nodeTimeLine:gotoFrameAndPlay(20)
        self.nodeTimeLine:pause()
    end
end

function UICityChoose:default(sender, eventType)

    global.tipsMgr:showWarningText("使用了一个尚未处理的按钮")
end

function UICityChoose:giveupOcc(sender,eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    local cb = function()
    
        if tolua.isnull(self.city) then return end
        global.worldApi:giveupOcc(self.city:getId(),function()
            if self.close then 
                self:close()
            end 
        end)    
    end

    if self.city:isEmpty() or self.city:isTown() then
       
        panel:setData("GiveUpOppucy02",cb,self.city:getName())
    else
        panel:setData("GiveUpOppucy",cb)
    end
end

function UICityChoose:attackInfo()
    
    if not global.g_worldview.mapPanel:isCityInBattle(self.city:getId()) then

        global.tipsMgr:showWarning("Endbattle")
    else
        
        local cityData = self.city:getSurfaceData()
        local infoPanel = global.panelMgr:openPanel("UIPKInfoPanel") 
        infoPanel:setData(self.city,  cityData) 
    end

    
    self:close()
end

function UICityChoose:recallAllTroop()
    if tolua.isnull(self.city) then return end
    local cityID = self.city:getId()
    if global.troopData:getTroopInCity(cityID) > 0 then
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("troopsAll01", function()
            
            global.worldApi:recallAllTroop(cityID,function()
                -- self:close()
            end)
        end)   
    else
        global.tipsMgr:showWarning('troopsAll02') 
    end    
end

function UICityChoose:collectWildRes()
    
    global.troopData:setAttackType(1)
    global.troopData:setTargetData(4)    
    global.panelMgr:openPanel("UITroopPanel")
end

function UICityChoose:leaugeInvite()
    if not self.city:canInviteFriend() then 
        return global.tipsMgr:showWarning("noFreeInviteTimes")
    end
    local panel = global.panelMgr:openPanel("UIWorldInvitePanel")
    panel:setData()
    panel:setDstId(self.city:getId())
end

function UICityChoose:troopInfo(sender,eventType)
    
    if tolua.isnull(self.city) then return end
    local panel = global.panelMgr:openPanel("UITroopMsgPanel")
    panel:setData( self.city.data, 1,  self.city.data.lHeroStar or 1)       

    --dump( self.city.data )
end

function UICityChoose:gotoMainCity(sender, eventType)

    global.scMgr:gotoMainScene()
end

function UICityChoose:revolt(sender, eventType)
    
    global.troopData:setTargetData(-2)   
    local panel = global.panelMgr:openPanel("UITroopPanel")
    panel:setInputMode(1)
    -- panel:setData( self.city.data, 2 )       
end

function UICityChoose:setCity(city,isHideSound)
    
    self.city = city
    -- self.city.target:setVisible(true)
    self.city:beChoose(self,isHideSound)

    global.g_worldview.worldPanel.chooseCityName = self.city:getName() 
    global.g_worldview.worldPanel.chooseCityId = self.city:getId()

     gevent:call(global.gameEvent.EV_ON_UI_CHOOSE_CITY,self.city:getType())



    self.coords = nil

    if self.city.isWildRes and not self.city:isMiracle() then
        self.coords = UIWorldWildCoords.new()
        self.coords:setPositionY(-100)
        self:addChild(self.coords)
    else
        self.coords = UIWorldBtnCoords.new()
        self.coords:setPositionY(-100)
        self:addChild(self.coords)
    end    

    self.coords:setData(self.city)
    print("choose city id is ",self.city:getId()," x ",self.city:getPositionX()," y ",self.city:getPositionY())
    -- print(global.g_worldview.mapInfo:getLastCityId(self.city:getId())) 

    -- global.g_worldview.flogMgr:createVisiViewBound(self.city)
end
function UICityChoose:castleInfo()

    if tolua.isnull(self.city) then return end
    local cityData = self.city:getSurfaceData()
    local lFlag = true
    local lCityID = self.city:getId()

    global.worldApi:getCityDetail(lCityID, function(detailData)
        
        dump(detailData,">>>>>>>detailData")

        local function call(msg)   

            if self.city == nil or tolua.isnull(self.city) or self.city:getId() ~= lCityID then
                return
            end

            local infoPanel = global.panelMgr:openPanel("UICastleInfoPanel") 
            infoPanel:setData(self.city, cityData, msg)
            infoPanel:setDetailData(detailData)
            if self.close then 
                self:close()
            end 
        end
        global.worldApi:worldCityDef(call, lFlag, lCityID)
    end)

end

function UICityChoose:villageInfo()

    if tolua.isnull(self.city) then return end
    local cityData = self.city:getSurfaceData()
    local infoPanel = global.panelMgr:openPanel("UIVillageInfoPanel") 
    infoPanel:setData(self.city, cityData)

    if self.close then 
        self:close()
    end 
end

function UICityChoose:onExit()
    -- global.g_worldview.flogMgr:removeVisiViewBound(self.city)
end

function UICityChoose:callBackTroop(sender,eventType)
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("troopReturn", function()
        if tolua.isnull(self.city) then return end
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_action")
        global.worldApi:callBackTroop(self.city:getId(),0,function()
        end)
    end)    
end

function UICityChoose:garrisonMgr(sender,eventType)
    if tolua.isnull(self.city) then return end
    global.worldApi:villageTroop(self.city:getId(), function(msg)
        if tolua.isnull(self.city) then return end
        local garrPanel = global.panelMgr:openPanel("UIGarrisonPanel") 
        garrPanel:setData(self.city:getId(), msg.tgTroop) 
        if self.close then 
            self:close()
        end 
    end)
end

function UICityChoose:troopAgent(sender, eventType)
    
    global.troopData:setTargetData(-1)   

    global.panelMgr:openPanel("UITroopPanel")

    if self.close then  -- protect 
        self:close()
    end 
end

function UICityChoose:collect()

    if tolua.isnull(self.city) then return end
    local cityId = self.city:getId()
    if cityId and global.collectData:checkCollect(cityId) then

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
        if self.close then 
            self:close()
        end 
    else
        global.tipsMgr:showWarning("Collectionend")
    end
end

function UICityChoose:fireCity(sender,eventTYpe)
        
    if tolua.isnull(self.city) then return end

    local cityId = self.city:getId()
    if cityId == 0 then return end
    if(self.city:getLordData()) then 
        global.panelMgr:openPanel("UIWallNumPanel"):initData(cityId, self.city:getLordData().lUserID)
    else 
        global.worldApi:getCityData(cityId , function ( msg)
            local lUserID = msg.lCitys.tagCityUser.lUserID
            global.panelMgr:openPanel("UIWallNumPanel"):initData(cityId, lUserID)
        end)
    end 
end

function UICityChoose:troopAccelerate()
    
    if tolua.isnull(self.city) then return end
    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 行军加速道具使用
    panel:setData(nil, 0, panel.TYPE_WALK_SPEED, self.city:getId())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICityChoose:attack(sender, eventType)

        
-- 
    -- print(global.g_worldview.worldPanel.chooseCityName )

    local checkCall = function()
         
       if tolua.isnull(self.city) then return end

        local openCall = function()
            local attackBoard = UIAttackBoard.new()
            attackBoard:setCity(self.city)
            local pos = cc.p(self:convertToNodeSpace(sender:getParent():convertToWorldSpace(cc.p(sender:getPosition()))))
            attackBoard:setPosition(pos)
            self:addChild(attackBoard)
            
            self.attackBoard = attackBoard
        end
        
        local isSelfProect,endTime = global.g_worldview.worldPanel:isMainCityProtect()

        if self.city:isInProtect() then

            global.tipsMgr:showWarning("ProtectNot")
        elseif isSelfProect and not self.city:isEmpty() then
            if not endTime then return end --protect 
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

    global.worldApi:checkMainCityProtect(function(isProtect)
        
        checkCall()
    end) 
end
--CALLBACKS_FUNCS_END

return UICityChoose

--endregion

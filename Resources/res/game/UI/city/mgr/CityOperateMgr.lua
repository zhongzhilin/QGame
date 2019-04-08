--region CityOperateMgr.lua
--Author : wuwx

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData
local panelMgr = global.panelMgr

local CityOperateMgr  = class("CityOperateMgr", function() return gdisplay.newWidget() end )


local callbacks = {
    [1] = "detail",
    [2] = "lvup",
    [3] = "train",
    [4] = "harvest",
    [5] = "accelerate",
    [6] = "accelerate",
    [7] = "sourceSoldier",
    [8] = "warehouse",
    [9] = "hero",
    [11]= "science",
    [12]= "transfer",
    [13]= "cure",
    [14]= "train",
    [15]= "wallDura",
    [16]= "register",
    [18]= "salary",
    [19]= "dailyTask",
    [21]= "foreign",
    [22]= "divine",
    [24]= "wallSpace",
    [23]= "heroGarrison",
    [25]= "normalHeroPanel",
    [10]= "strongpanel",
    [26]= "deletepanel",
    [27]= "accelerate",
    [28]= "monthCard",
    [29]= "dailyactivity",
    [30]= "largeactivity",
    [31]= "openserveractivity",
    [32]= "onCityPlus",
    [33]= "equipForge",
    [34]= "firstRecharge",
    [35]= "skin",
    [36]= "friend",
    [37]= "store",
    [38]= "mysteriousshop",
    [39]= "diplomatic",
    [40]= "exploit",
    [41]= "changeshop",
    [42]= "speed",
    [43]= "turnrace",
}

function CityOperateMgr:ctor()
    self.cityView = global.g_cityView
    self.m_operateNode = nil
    self.btnT = {}
end

function CityOperateMgr:init()

end

function CityOperateMgr:onExit(touch, event)
end

function CityOperateMgr:getCitySurfaceId(i_type,i_state)
    i_type = global.cityData:getBuildingType(i_type)
    local id = (i_type*100).."_"..i_state
    return id
end

local buildingItem_data = {}
function CityOperateMgr:isUseLast(name, data) --是否 复用 上次 创建的 按钮

    return data and buildingItem_data ==data and   name and self.csbName and self.csbName == name and self.m_operateNode and (not tolua.isnull(self.m_operateNode))
end 

function CityOperateMgr:createOpeBtnWidget(i_type,i_state, closeCall , arg_data)
    -- local cityTouchMgr = self.cityView:getTouchMgr()
    -- local building = cityTouchMgr:getBuildingNodeBy(self.data.id)

    local id = self:getCitySurfaceId(i_type,i_state)
    local data = luaCfg:get_city_surface_by(id)
    log.trace("CityOperateMgr:createOpeBtnWidget(i_type=%s,i_state=%s),id=%s,data",i_type,i_state,id,vardump(data))

    if not data then 
        if closeCall then 
            closeCall(true)
            -- self.closeCall = nil 
        end
        return 
    end
    local btnT = clone(data.staticbtn)
    for idx,btnId in pairs(data.dynamicbtn) do
        local btnData = luaCfg:get_city_btn_by(btnId)
        if btnData.triggerId[1] and cityData:checkTrigger(btnData.triggerId[1]) then
            table.insert(btnT,btnId)
        end
    end
    local btnNum = #btnT

    assert(btnNum and btnNum >= 2 and btnNum <= 7,"输入参数不正确2<=btnNum<=5 ="..btnNum)
    local csbName = "city/ui_building_lvup_"..btnNum.."btn"

    if  self:isUseLast(csbName , arg_data) then 

        self.m_operateNode:stopAllActions()
    else 
        self:removeOpeBtnWidget(true)

        buildingItem_data = arg_data 

        self.m_operateNode = resMgr:createWidget(csbName)
        self.cityView:getScrollViewLayer("operate"):addChild(self.m_operateNode)
        uiMgr:configUITree(self.m_operateNode)
        uiMgr:configUILanguage(self.m_operateNode, csbName)
    end  

    self.closeCall = closeCall
    self.m_operateNode:setVisible(true)


    local timelineAction = resMgr:createTimeline(csbName)
    timelineAction:setLastFrameCallFunc(function()
        gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_ACTION_STEP)
    end)
    timelineAction:play("move1", false)
    self.m_operateNode:runAction(timelineAction)

    self.csbName = csbName
    
    -- self.m_operateNode:setVisible(false)
    table.sort(btnT,function(a,b) 
        local abtnData = luaCfg:get_city_btn_by(a)
        local bbtnData = luaCfg:get_city_btn_by(b)
        return abtnData.order < bbtnData.order
    end)

    self.btnT = {}
    for idx,id in pairs(btnT) do
        local btnData = luaCfg:get_city_btn_by(id)
        local btn = self.m_operateNode["btn_t"..idx].btn
        btn:setName("build_btn_" .. id)
        self.btnT[id] = btn
        btn.txt_node:setVisible(false)
        btn.name_export:setString(btnData.text)
        if btnData.textId ~= 0 then
            btn.txt_node.txt:setString(luaCfg:get_local_string(btnData.textId))
        else
            btn.txt_node.txt:setString("")
        end
        if btnData.dynamicIcon ~= "" then
            btn.icon:setSpriteFrame(string.format(btnData.dynamicIcon,data.type))
        else
            btn.icon:setSpriteFrame(btnData.icon)
        end
        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType)  
            self:removeOpeBtnWidget(true)
            if not self[callbacks[id]] then
                global.tipsMgr:showWarning("FuncNotFinish")
            else
                self[callbacks[id]](self)
            end
        end)
    end

    self.m_operateNode.title_bg:setVisible(false)
    return self.m_operateNode,csbName
end

function CityOperateMgr:removeOpeBtnWidget(noAction)
    -- print("#######CityOperateMgr:removeOpeBtnWidget(noAction=%s) trace =%s",noAction,vardump(debug.traceback()))
    
    if global.guideMgr:isPlaying() and global.guideMgr:getCurStep() == 90007 then

        if global.panelMgr:isPanelOpened("UIGuidePanel") then
            global.panelMgr:closePanel("UIGuidePanel")
            global.guideMgr:dealScript()
        end        
    end

    if self.m_operateNode then
        if self.data and self.data.id then
            local cityTouchMgr = self.cityView:getTouchMgr()
            local building = cityTouchMgr:getBuildingNodeBy(self.data.id)
            if not tolua.isnull(building) then
                building:setSelected(false)
            end
        end
        if self.closeCall then 
            self.closeCall(noAction)
            self.closeCall = nil 
        end
        if noAction then
            self.m_operateNode:removeFromParent()
            self.m_operateNode = nil
        else
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_close")

            local timelineAction = resMgr:createTimeline(self.csbName)
            timelineAction:setLastFrameCallFunc(function()
                -- self.m_operateNode:removeFromParent()
                -- self.m_operateNode = nil
                self.m_operateNode:setVisible(false )

            end)
            timelineAction:play("move2", false)
            self.m_operateNode:runAction(timelineAction)
        end
    end
end

function CityOperateMgr:checkOutScreen(opeBtnNode)
    local screenPos = opeBtnNode:convertToWorldSpace(cc.p(0,0))
    local size = opeBtnNode.panel_rect:getContentSize()
    local rect = cc.rect(screenPos.x-size.width*0.5,screenPos.y-size.height*0.5,size.width,size.height)

    local width = gdisplay.width
    local height = gdisplay.height-100

    local offset = {
        x = 0,
        y = 0,
    }
    local inchx = 0
    local inchy = 230
    if rect.x < inchx then
        offset.x = inchx-rect.x
    end
    if rect.x+rect.width > width-inchx then
        offset.x = width-(rect.x+rect.width)
    end
    if rect.y < inchy then
        offset.y = inchy-rect.y
    end
    if rect.y+rect.height > height then
        offset.y = height-(rect.y+rect.height)
    end
    self.cityView:getCamera():scrollOffset(offset,true)
end

function CityOperateMgr:setData(data)
    self.data = data
    if not self.m_operateNode and tolua.isnull(self.m_operateNode) then return end
    self.m_operateNode.title_bg.title:setString(self.data.buildsName)

    local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(self.data.buildingType))
    if buildingUIData and buildingUIData.btnui_posY ~= 0 then
        self.m_operateNode:setPosition(cc.p(self.data.posX,self.data.posY+buildingUIData.btnui_posY ))
    else
        self.m_operateNode:setPosition(cc.p(self.data.posX,self.data.posY))
    end

    self:checkOutScreen(self.m_operateNode)
end

--直接打开升级面板
function CityOperateMgr:openLvupPanel(data)
    self:removeOpeBtnWidget(true)
    self:setData(data)
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_build_transition_far")
    self:lvup(true)
end

function CityOperateMgr:openHeroGarrison(data)
    self:removeOpeBtnWidget(true)
    self:setData(data)
    self:heroGarrison()
end

--直接打开建造面板
function CityOperateMgr:openBuildPanel(data)

    if not data then return end
    self:setData(data)
    self.cityView:setNoCheckScreen(true)
    
    local id = self.data.id
    local buildingData = cityData:getBuildingById(id)
    local cityCamera = self.cityView:getCamera()
    local cityTouchMgr = self.cityView:getTouchMgr()

    local overCall = function()
        -- body
        --打开建造面板
        local buildPanel = panelMgr:openPanel("BuildPanel")
        local selectedBuilding = self.cityView:createBuildingById(id)
        if selectedBuilding.setSelected then -- protect 
            selectedBuilding:inScreen()
            selectedBuilding:setSelected(true)
        end 
        --隐藏建造列表
        self.cityView:hideBuildListPanel(false)
        buildPanel:setData(buildingData)
        buildPanel:setCloseCall(function() 
            if selectedBuilding.setSelected  then --protect 
                selectedBuilding:setSelected(false)
            end 
            local newbuildingData = cityData:getBuildingById(id)
            cityCamera:resetNormalScale(cc.p(newbuildingData.posX,newbuildingData.posY),true,function()
                -- body
                self.cityView:setNoCheckScreen(false)
                gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)
                gevent:call(global.gameEvent.EV_ON_CITYSCROLLSCALECHANGE)

            end)
        end)
    end
    local isAnimate = WDEFINE.SCROLL_SLOW_DT
    global.uiMgr:addSceneModel(WDEFINE.SCROLL_SLOW_DT)
    --镜头拉近
    if buildingData.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
        cityCamera:setBuildModel(cc.p(buildingData.posX,buildingData.posY),isAnimate,overCall)
    elseif buildingData.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.UNOPEN then
        cityCamera:setBuildModel(cc.p(buildingData.posX,buildingData.posY),isAnimate,overCall)
    end
    
end

function CityOperateMgr:getBtnBy(name)
    local btn = self.m_operateNode[name].btn
    if not btn then 
        log.error("@CityOperateMgr:name:cannot get btn name:%s,buidlingId:%s",name,self.data.id)
    end
    return btn
end

function CityOperateMgr:getBtnTxtNodeById(id)
    if not self.btnT then
        return nil
    end
    local btn = self.btnT[id]
    if not btn then 
        return nil
    end
    return btn.txt_node
end

-------------------btn call-----------------------------------
function CityOperateMgr:detail()

    local id = self.data.id
    local buildingData = cityData:getBuildingById(id)
    local cityCamera = self.cityView:getCamera()
    --镜头拉近
    cityCamera:setBuildModel(cc.p(buildingData.posX,buildingData.posY),true)
    
    local selectedBuilding = self.cityView:getTouchMgr():getBuildingNodeBy(id)
    selectedBuilding:setSelected(true)
    --打开升级面板
    local panel = panelMgr:openPanel("UIDetailFirstPanel")
    panel:setData(buildingData)
    panel:setCloseCall(function() 
        selectedBuilding:setSelected(false)
        local newbuildingData = cityData:getBuildingById(id)
        cityCamera:resetNormalScale(cc.p(newbuildingData.posX,newbuildingData.posY),true,function()
            -- body
        end)
    end)
end

function CityOperateMgr:deletepanel()
    
    -- global.tipsMgr:showWarning("FuncNotFinish")
    global.panelMgr:openPanel("UIDeletePanel")
end

function CityOperateMgr:strongpanel()
    
    global.panelMgr:openPanel("UIEquipStrongPanel")
end

function CityOperateMgr:hero()
    
    global.panelMgr:openPanel("UIHeroPanel"):setMode3()
end

function CityOperateMgr:normalHeroPanel()
    global.panelMgr:openPanel("UIHeroPanel"):setMode4()
    global.funcGame:cleanContionTag()
    gevent:call(global.gameEvent.EV_ON_HERO_FREE)
end

function CityOperateMgr:heroGarrison()

    local gdata = {}  
    for i,v in ipairs(luaCfg:garrison_effect()) do
        if v.building_id == self.data.id then
            gdata = v
        end
    end
    local targetId = gdata.unlock_level_1
    if not targetId then return end
    local isUnlock = global.funcGame:checkTarget(targetId)
    if not isUnlock then
        local triggerData = luaCfg:get_target_condition_by(targetId)
        local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
        global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
        return
    else
        local gPanel = panelMgr:openPanel("UICityGarrisonPanel")
        gPanel:setBuildId(self.data.id)
        gPanel:initData(true)
    end
    
end

function CityOperateMgr:lvup(isSlow)
    local id = self.data.id
    local buildingData = cityData:getBuildingById(id)
    local cityCamera = self.cityView:getCamera()

    --满级的时候无法打开
    if cityData:checkCanUpgrade(self.data) == nil then 
        global.tipsMgr:showWarning("MaxLv")
        return 
    end
    self.cityView:setNoCheckScreen(true)

    local overCall = function()
        --打开升级面板
        local buildPanel = panelMgr:openPanel("UpgradePanel")
        local selectedBuilding = self.cityView:getTouchMgr():getBuildingNodeBy(id)
        selectedBuilding:inScreen()
        selectedBuilding:setSelected(true)
        buildPanel:setData(buildingData)
        buildPanel:setCloseCall(function() 
            selectedBuilding:setSelected(false)
            local newbuildingData = cityData:getBuildingById(id)
            cityCamera:resetNormalScale(cc.p(newbuildingData.posX,newbuildingData.posY),true,function()
                -- body
                self.cityView:setNoCheckScreen(false)
                gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)
                gevent:call(global.gameEvent.EV_ON_CITYSCROLLSCALECHANGE)

            end)

        end)
        global.uiMgr:removeSceneModal(99999)
    end
    --镜头拉近
    local isAnimate = true
    if isSlow then
        isAnimate = false
    end

    overCall()

    cityCamera:setBuildModel(cc.p(buildingData.posX,buildingData.posY),isAnimate)
    global.uiMgr:addSceneModel(WDEFINE.SCROLL_SLOW_DT,99999)
    
end

function CityOperateMgr:train()
    local id = self.data.id
    local selectedBuilding = self.cityView:getTouchMgr():getBuildingNodeBy(id)
    selectedBuilding:setSelected(false)
    panelMgr:openPanel("TrainPanel"):setData(self.data)
end

function CityOperateMgr:harvest()
    local id = self.data.id
    global.g_cityView.touchMgr:getBuildingNodeBy(id):harvest()
end

function CityOperateMgr:accelerate()
    local cityTouchMgr = self.cityView:getTouchMgr()
    local building = cityTouchMgr:getBuildingNodeBy(self.data.id)
    if building.accelerate then building:accelerate() end
end

function CityOperateMgr:cure()
    local wallValuePanel = panelMgr:openPanel("UIHpPanel")
    wallValuePanel:setData(self.data)
end

function CityOperateMgr:wallDura()
    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    
    local cityId = global.userData:getWorldCityID()
    if cityId == 0 then return end
    panelMgr:openPanel("UIWallNumPanel"):initData(cityId)
end

function CityOperateMgr:warehouse()
    local id = self.data.id
    local resPanel = panelMgr:openPanel("UIResPanel")
    resPanel:setData()  
end

--打开城防空间
function CityOperateMgr:wallSpace()
    local id = self.data.id
    local panel = panelMgr:openPanel("UIWallSpacePanel")
    panel:setData(self.data)  
end

-- 大型活动
function CityOperateMgr:largeactivity()
    global.loginApi:clickPointReport(nil,2,nil,nil)
    if #global.ActivityData:getCurrentActivityData(global.ActivityData.activity_type.largeactivity) > 0 then 
        local panel =   global.panelMgr:openPanel("UIActivityPanel")
        panel:setData(global.ActivityData.activity_type.largeactivity)
    else 
        global.tipsMgr:showWarning("no_activity")
    end  
end 

-- 每日活动
function CityOperateMgr:dailyactivity()
    global.loginApi:clickPointReport(nil,1,nil,nil)
    if #global.ActivityData:getCurrentActivityData(global.ActivityData.activity_type.dailyactivity) > 0 then 
        local panel =   global.panelMgr:openPanel("UIActivityPanel")
        panel:setData(global.ActivityData.activity_type.dailyactivity)
    else 
        global.tipsMgr:showWarning("no_activity")
    end 

end 

--开服活动
function CityOperateMgr:openserveractivity()
    global.loginApi:clickPointReport(nil,3,nil,nil)
    if #global.ActivityData:getCurrentActivityData(global.ActivityData.activity_type.dailyactivity) > 0 then 
        local panel =   global.panelMgr:openPanel("UIActivityPanel")
        panel:setData(global.ActivityData.activity_type.openserveractivity)
    else 
        global.tipsMgr:showWarning("no_activity")
    end 
end 

-- 兵源
function CityOperateMgr:sourceSoldier()
    local id = self.data.id
    local buildingData = cityData:getBuildingById(id)
    panelMgr:openPanel("UISoldierSourcePanel"):setData(buildingData)  
end

-- 日常奖励
function CityOperateMgr:dailyTask()
    
    local opLv = luaCfg:get_config_by(1).dailyTaskLv
    if global.funcGame:checkBuildLv(1, opLv) then
        global.panelMgr:openPanel("UIDailyTaskPanel"):setData()
    end
end

-- 签到
function CityOperateMgr:register()
    
    global.panelMgr:openPanel("UIRegisterPanel"):setData(global.dailyTaskData:getTagSignInfo())
end
-- 外交联盟按钮
function CityOperateMgr:foreign()
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_union")
    if global.userData:checkJoinUnion() then
        --已有联盟信息界面
        local panel = global.panelMgr:openPanel("UIHadUnionPanel")
    else
        --选择加入联盟列表
        local panel = global.panelMgr:openPanel("UIUnionPanel"):setData()
    end
end

-- 工资
function CityOperateMgr:salary()
    
    local id = self.data.id
    local buildingData = cityData:getBuildingById(id)
    panelMgr:openPanel("UISalaryPanel"):setData(buildingData)
end

-- 科技
function CityOperateMgr:science()
    global.panelMgr:openPanel("UISciencePanel")
end

-- 占卜
function CityOperateMgr:divine()
    global.panelMgr:openPanel("UIDivinePanel")
end

function CityOperateMgr:mysteriousshop()

    local isbuding = nil 
    local  i_buildingType  = 19
    for _ ,v in pairs(global.cityData:getBuildings()) do 
       if v.buildingType == i_buildingType  and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
             isbuding = true 
        end    
    end 
    if  isbuding  then
        local id = luaCfg:get_buildings_pos_by(i_buildingType).triggerId[1]
        if global.cityData:checkTrigger(id) then
            global.panelMgr:openPanel("UIMysteriousPanel")
        else
            local triggerData = luaCfg:get_triggers_id_by(id)
            local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
            local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,luaCfg:get_buildings_pos_by(i_buildingType).buildsName)
            global.tipsMgr:showWarning(str)
        end
    else
         global.tipsMgr:showWarning(string.format(luaCfg:get_localization_by(10549).value, luaCfg:get_buildings_pos_by(i_buildingType).buildsName))
    end 

end 


function CityOperateMgr:speed()

    if self.data.id == 17 then --科技

        self:scienceUseDiamondSpeed()
    else 
        self:useDiamondSpeed()
    end 
end


function CityOperateMgr:scienceUseDiamondSpeed()

    local spent = 0

    local buildId =  self.data.id or 0

    local curQueue = global.techData:getQueue()

    if not curQueue then return end 

    local cityTouchMgr = self.cityView:getTouchMgr()
    local building = cityTouchMgr:getBuildingNodeBy(buildId)

    local i = curQueue[1].lBindID

    if curQueue and curQueue[1] then 

        local time = curQueue[1].rest

        spent = global.funcGame.getDiamondCount(time)
    end

    if global.propData:checkDiamondEnough(spent) then 
            
        global.cityApi:clearQueue(curQueue[1].lID , 2 ,function(msg)

            global.techData:referQueue(msg)
            if building then
                building["m_busyMsg"..i].lRestTime = msg.lRestTime or 0
                building["m_busyMsg"..i].lStartTime = msg.lSysTime or 0
                building["m_restTime"..i] = msg.lRestTime or 0
            end

        end, 0)

    else
        global.panelMgr:openPanel("UIRechargePanel")
    end  
    
end 


function CityOperateMgr:useDiamondSpeed() --训练直接使用魔晶加速训练
    
    local buildId =  self.data.id 
    local queueId =  nil 
    local spent  = nil

    local cityTouchMgr = self.cityView:getTouchMgr()
    local building = cityTouchMgr:getBuildingNodeBy(buildId)

    if building.getAccData then 

        queueId = building:getAccData().lID
        queue = building:getTrainByID(queueId)
        local currServerTime =global.dataMgr:getServerTime()
        local lTotalTime = queue.lEndTime - queue.lStartTime
        local lRestTime = queue.lEndTime - currServerTime
        spent = global.funcGame.getDiamondCount(lRestTime)

        if global.propData:checkDiamondEnough(spent) then 

            global.cityApi:clearQueue(queueId, 2 ,function(msg)

                if building and building.leftTimeAndTotalTime then 

                    building:leftTimeAndTotalTime(msg,lRestTime)
                end 

            end, buildId)

        else
            global.panelMgr:openPanel("UIRechargePanel")
        end  
    end 

end 


-- 月卡
function CityOperateMgr:monthCard()
    global.panelMgr:openPanel("UIMonthCardPanel"):setData()
end

-- 主ui增益效果
function CityOperateMgr:onCityPlus()
    global.panelMgr:openPanel("UICityBufferPanel")
end

-- 锻造
function CityOperateMgr:equipForge()
    global.panelMgr:openPanel("UIEquipForgePanel")
end

-- 首冲礼包
function CityOperateMgr:firstRecharge()
    global.panelMgr:openPanel("UIFirRechargePanel"):setData()
end

-- 好友系统
function CityOperateMgr:friend()
    global.panelMgr:openPanel("UIFriendPanel")
end

-- 商城
function CityOperateMgr:store()
    global.panelMgr:openPanel("UIStorePanel")
end


function CityOperateMgr:transfer()

    if  global.chatData:isJoinUnion() then 

        global.panelMgr:openPanel("UIUnionMemberPanel"):setData(nil , true)
    else 
        global.tipsMgr:showWarning("ChatUnionNo")
    end 
end 
-- 
function CityOperateMgr:skin()
    global.panelMgr:openPanel("UISelectSkinPanel")
end

function CityOperateMgr:diplomatic()
    global.panelMgr:openPanel("UIDiplomaticPanel")
end

function CityOperateMgr:exploit()

    if not global.userData:isOpenExploit() then
        local str = luaCfg:get_local_string(10479, global.luaCfg:get_config_by(1).exploitUnlock)
        return global.tipsMgr:showWarning(str)
    end
    global.panelMgr:openPanel("UIExploitPanel")
end

function CityOperateMgr:changeshop()
    global.panelMgr:openPanel("UIChangeShopPanel")
end

function CityOperateMgr:turnrace()
    local panel = global.panelMgr:openPanel("UISelectNew")
    panel:setData()
    panel:setCallBack(function()
        -- body
        global.funcGame:RestartGame()
    end)
end

return CityOperateMgr

--endregion

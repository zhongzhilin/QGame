--region UIAttackInfoItem.lua
--Author : untory
--Date   : 2016/09/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAttackInfoItem  = class("UIAttackInfoItem", function() return gdisplay.newWidget() end )

function UIAttackInfoItem:ctor()
  
  	self:CreateUI()  
end

function UIAttackInfoItem:CreateUI()
    local root = resMgr:createWidget("world/world_team_info")
    self:initUI(root)
end

function UIAttackInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_team_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.LoadingBar = self.root.Image_2.LoadingBar_export
    self.btn = self.root.Image_2.btn_export
    self.Text_3 = self.root.Image_2.btn_export.Text_3_mlan_4_export
    self.timeText = self.root.Image_2.timeText_export
    self.title = self.root.Image_2.title_export
    self.state_icon = self.root.state_icon_export
    self.gps_btn = self.root.gps_btn_export
    self.hero_face = self.root.hero_face_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:add_speed_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.gps_btn, function(sender, eventType) self:gps_call(sender, eventType) end)
--EXPORT_NODE_END

    self.gps_btn:setSwallowTouches(false)    
end

function UIAttackInfoItem:onEnter()

    log.debug("onEnter")

   self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime()
    end, 1)

    self:checkTime()
end

function UIAttackInfoItem:onExit()

    self:stopSchedule()
end

function UIAttackInfoItem:stopSchedule()

    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end    
end

function UIAttackInfoItem:checkTime(isNeedAction)
    
    -- 新类型是驻防，不需要有定时器
    if not self.startTime then
        return
    end

    isNeedAction = isNeedAction or 0.3

    local contentTime = global.dataMgr:getServerTime()
    local nextTime = self.overTime

    local cutTime = nextTime - contentTime
    local allTime = self.overTime - self.startTime

    local pen = (contentTime - self.startTime) / allTime * 100

    if isNeedAction == 0 then
        
        self.LoadingBar:setPercent(pen)
    else

        local isTrueNeedAction = isNeedAction
        if self.LoadingBar:getPercent() > pen then
            isTrueNeedAction = 0
        end
        
        self.LoadingBar:runAction(cc.ProgressFromTo:create(isTrueNeedAction,self.LoadingBar:getPercent(),(pen)))
    end

    if cutTime < 0 then
        return        
    end

    local hour = math.floor(cutTime / 3600) 
    cutTime = cutTime  % 3600
    local min = math.floor(cutTime / 60)
    cutTime = cutTime % 60
    local sec = math.floor(cutTime)

    self.timeText:setString(string.format("%02d:%02d:%02d", hour,min,sec))
end

-- 新版本的设定，从原始数据设置
function UIAttackInfoItem:setDataFromSourceData(data)
    
    dump(data,'..........data')    

    self.isNewMode = true
    -- self:stopSchedule()
    data.lHeroID =  data.lHeroID or {}
    local heroData = luaCfg:get_hero_property_by(data.lHeroID[1] or 0)
    
    if not heroData then
        self.hero_face:setVisible(false)
    else
        global.panelMgr:setTextureFor(self.hero_face,heroData.nameIcon)
        self.hero_face:setVisible(true)
    end    

    self.data = data    
    -- self.btn:setVisible(false)

    local titleId = 10130
    if data.lCollectSpeed then
        titleId = 10982
        self.overTime = data.lCollectStart + data.lCollectSurplus / (data.lCollectSpeed / 3600)  -- global.dataMgr:getServerTime() + data.lCollectSurplus / (data.lCollectSpeed / 3600)
        self.startTime = data.lCollectStart
        self.state_icon:setSpriteFrame('ui_surface_icon/caiji_icon.png')
        self:checkTime(0)
    else
        self.startTime = nil
        self.state_icon:setSpriteFrame('ui_surface_icon/world_team_type4.png')
        self.LoadingBar:setPercent(100)
    end

    self.title:setString(luaCfg:get_local_string(titleId,global.funcGame:translateDst(data.szTargetName,data.lDstType,data.lTarget)))

    self.timeText:setString('--:--:--')
    self.Text_3:setString(luaCfg:get_local_string(10136))
end

function UIAttackInfoItem:setData(data)

    if not data.uiInfo then
        return self:setDataFromSourceData(data)
    end
    self.isNewMode = false

    self.startTime = data.startTime
	self.overTime = data.overTime
    self.uiInfo = data.uiInfo
	self.data = data
    self.troopData = data.troopData

    self.title:setString(self.uiInfo.title_str)
    self.state_icon:setSpriteFrame(self.uiInfo.icon_path)
    self.btn:setVisible(self.uiInfo.is_show_speed)

    local heroData = luaCfg:get_hero_property_by(self.troopData.lHeroID)
    
    if not heroData then
        self.hero_face:setVisible(false)
    else
        global.panelMgr:setTextureFor(self.hero_face,heroData.nameIcon)
        self.hero_face:setVisible(true)
    end    

    self:checkTime(0)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAttackInfoItem:gps_call(sender, eventType)
    
    if self.isNewMode then
        global.g_worldview.worldPanel:chooseCityById(self.data.lTarget,self.data.lWildKind) 
        
        self:stopAllActions()
        self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.075,0.95),cc.ScaleTo:create(0.075,1)))
    else
        local state = self.troopData.lStatus
        if (state ~= 11) and (state ~= 12) then
            global.g_worldview.worldPanel:chooseSoldier(self.data.id,self.troopData.lUserID)
        else
            global.g_worldview.worldPanel:chooseCityById(self.uiInfo.cityId,self.uiInfo.lWildKind) 
        end
        
        self:stopAllActions()
        self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.075,0.95),cc.ScaleTo:create(0.075,1)))
    end    
end

function UIAttackInfoItem:add_speed_call(sender, eventType)

    if self.isNewMode then
        
        local troopLandId = global.worldApi:decodeLandId(self.data.lTarget)
        local mainCityLandId = global.worldApi:decodeLandId(global.userData:getWorldCityID())
        local errorcodeKey = 'TroopsBack'

        if troopLandId ~= mainCityLandId then
            errorcodeKey = 'TransmissionNo'
        end

        if self.data.lCollectSpeed then
            errorcodeKey = 'troopsAll03'
        end

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData(errorcodeKey,function () 
            
            global.worldApi:callBackTroop(self.data.lID,1,function()
                
            end)
        end,self.data.szName)
    else
        local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 部队加速道具使用
        panel:setData(nil, 0, panel.TYPE_WALK_SPEED, self.data.id)
    end    
end
--CALLBACKS_FUNCS_END

return UIAttackInfoItem

--endregion

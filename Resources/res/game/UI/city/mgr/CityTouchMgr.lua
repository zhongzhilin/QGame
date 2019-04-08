--region CityTouchMgr.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local CityTouchMgr  = class("CityTouchMgr", function() return gdisplay.newWidget() end )

local ALLOW_MOVE_ERROR = 7.0/160.0

function CityTouchMgr:ctor(view)
    self.cityView = view
    self.registerBuildings = {}
    self:init()
end

function CityTouchMgr:init()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self)

    local function refreshBuildingsState(event, id)
        if self.refreshBuildingsState then
            self:refreshBuildingsState(id)
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE, refreshBuildingsState)
    
    local function refreshBuildingsState()
        if self.refreshBuildingsState then
            self:refreshBuildingsState()
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, refreshBuildingsState)
end

function CityTouchMgr:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function CityTouchMgr:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local isShowFeedBack = true
local beganPos = cc.p(0,0)
local isMoved = false
local isBegenEvent = false

function CityTouchMgr:onTouchBegan(touch, event)
    isShowFeedBack = true
    isMoved = false
    beganPos = touch:getLocation()

    local isSwallow = false
    for i,i_building in ipairs(self.registerBuildings) do
        if i_building.onTouchBegan then
            isSwallow = isSwallow or i_building:onTouchBegan(touch, event)
        end
    end

    self.cityView:getSoldierMgr():onTouchBegan(touch, event)
    self.cityView:getBossMgr():onTouchBegan(touch, event)
    self.cityView:getPetMgr():onTouchBegan(touch, event)

    self.touchEventListener:setSwallowTouches(isSwallow)

    isBegenEvent = isSwallow

    return true
end

function CityTouchMgr:onTouchMoved(touch, event)
    

    isMoved = true
    

    if isBegenEvent then
        for i,i_building in ipairs(self.registerBuildings) do
            if i_building.onTouchMoved then
                i_building:onTouchMoved(touch, event)
            end
        end
    end    
end

function CityTouchMgr:onTouchEnded(touch, event)
    local invalidEnd = false
    self.cityView:hideBuildListPanel()
    --处理手指滑动误差

    if isBegenEvent then 
        invalidEnd = true
        return 
    end

    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        invalidEnd = true
        global.g_cityView:getOperateMgr():removeOpeBtnWidget()
        return
    end

    -- 点击士兵事件

    self.cityView:getSoldierMgr():onTouchEnded(touch, event)

    self.isTouchBuild = true
    self.cityView:getBossMgr():onTouchEnded(touch, event)
    self.cityView:getPetMgr():onTouchEnded(touch, event)
    if not self.isTouchBuild then
        return
    end 

    local noSelected = true
    local selectedBuilding = nil
    for i,i_building in ipairs(self.registerBuildings) do
        if i_building.onTouchEnded then
            i_building:onTouchEnded(touch, event)

            if i_building:isSelected() then
                selectedBuilding = i_building
                isShowFeedBack = false
                noSelected = false
            end
        end
    end
    if noSelected then
        global.g_cityView:getOperateMgr():removeOpeBtnWidget()
    end
    if isShowFeedBack then
        self:createClickFeedBack(touch:getLocation())
    end


    self.touchEventListener:setSwallowTouches(false)
end

function CityTouchMgr:onTouchCancel(touch, event)
    for i,i_building in ipairs(self.registerBuildings) do
        if i_building.onTouchCancel then
            i_building:onTouchCancel(touch, event)
        end
    end
end

function CityTouchMgr:createClickFeedBack(pos)
    if not self.clickEffectNode then
        self.clickEffectNode = resMgr:createWidget("effect/click_feedback")
        self.cityView:addChild(self.clickEffectNode)
    else
    end
    local timelineAction = resMgr:createTimeline("effect/click_feedback")
    timelineAction:setLastFrameCallFunc(function()
    end)
    timelineAction:play("click", false)
    self.clickEffectNode:runAction(timelineAction)
    self.clickEffectNode:setPosition(pos)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END
function CityTouchMgr:setNoTouchBuild()
    self.isTouchBuild = false
end

function CityTouchMgr:setSwallow(isSwallow)
    self.touchEventListener:setSwallowTouches(isSwallow)
end
        
function CityTouchMgr:registerTouch(building)
   for i,i_building in ipairs(self.registerBuildings) do
        if i_building == building then
            return
        end
    end
    table.insert(self.registerBuildings,building)
end

function CityTouchMgr:unregisterTouch(building)
    for i,i_building in ipairs(self.registerBuildings) do
        if i_building == building then
            table.remove(self.registerBuildings,i)
            return
        end
    end
end

function CityTouchMgr:unregisterAllTouch()
    self.registerBuildings = nil
    self.registerBuildings = {}
end

function CityTouchMgr:getBuildingNodeBy(id)
   for i,i_building in ipairs(self.registerBuildings) do
        -- log.debug("#######i_building:getId()=%s,buildingAddr=%s,id=%s,isEquale=%s",i_building:getId(),i_building,id,(i_building:getId() == id))
        if i_building:getId() == id then
            return i_building
        end
    end
end

function CityTouchMgr:removeBuildingNodeBy(id)
   for i,i_building in ipairs(self.registerBuildings) do
        if i_building:getId() == id then
            i_building:removeFromParent()
            table.remove(self.registerBuildings,i)
            return
        end
    end
end

function CityTouchMgr:getBuildingNodeByType(buildingType,topLevel)   --低于topLevel最高的
    local top = topLevel or 999999
    local maxLv = 0
    local selectedBuilding = nil
    for i,i_building in ipairs(self.registerBuildings) do
    if i_building:getData().buildingType == buildingType and i_building:getLv() > maxLv and i_building:getLv() < top then
            maxLv = i_building:getLv()
            selectedBuilding = i_building
        end
    end
    return selectedBuilding
end


function CityTouchMgr:getBuildingNodeByType2(buildingType)
    for i,i_building in ipairs(self.registerBuildings or {} ) do
        if i_building:getData().buildingType == buildingType  then
                selectedBuilding = i_building
            end
        end
    return selectedBuilding
end 


function CityTouchMgr:refreshBuildingsState(id)
    if tolua.isnull(global.g_cityView) then return end
    if not self.registerBuildings then return end
    for i,i_building in ipairs(self.registerBuildings) do
        if id then 
            if i_building:getId() == id then
                i_building:resetData()
                break
            end
        else
            i_building:resetData()
        end
    end

    local buildListPanel = global.g_cityView:getBuildListPanel()
    if not tolua.isnull(buildListPanel) then
        buildListPanel:reload()
    end
end

return CityTouchMgr

--endregion

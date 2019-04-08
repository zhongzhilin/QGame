--region UIWorldWildCoords.lua
--Author : Untory
--Date   : 2017/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldWildCoords  = class("UIWorldWildCoords", function() return gdisplay.newWidget() end )

function UIWorldWildCoords:ctor()
    self:CreateUI()
end

function UIWorldWildCoords:CreateUI()
    local root = resMgr:createWidget("world/world_btn_coords_res")
    self:initUI(root)
end

function UIWorldWildCoords:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_btn_coords_res")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.collection = self.root.collection_export
    self.icon = self.root.collection_export.icon_export
    self.xy = self.root.collection_export.xy_export
    self.star = self.root.collection_export.star_export
    self.res = self.root.collection_export.res_export

    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:check(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.star, function(sender, eventType) self:check(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWorldWildCoords:setData(city)
    
    self.city = city

    local pos = global.g_worldview.const:converPix2Location(cc.p(city:getPosition()))
    self.xy:setString(luaCfg:get_local_string(10945,pos.x,pos.y))

    self.data = city.data
    self.designerData = luaCfg:get_wild_res_by(self.data.lKind)
    self.icon:setSpriteFrame(luaCfg:get_item_by(self.designerData.type).itemIcon)

    if self.data.lCollectSpeed then
        self:startCheckTime()
    else
        self.res:setString(self.designerData.allres - self.data.lCollectCount)        
    end


    self:addEventListener(global.gameEvent.EV_ON_WILD_REFRESH,function(event,data)

        if not self.data then
            return
        end
        if data.lResID == self.data.lResID then
            self:stopSchedule()
            global.g_worldview.mapPanel:closeChoose(true)
        end 
    end)
end

function UIWorldWildCoords:stopSchedule()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UIWorldWildCoords:startCheckTime()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheStartTime = global.dataMgr:getServerTime()
    self.scheduleListenerId = gscheduler.scheduleGlobal(function(dt)
            
        self:checkTime(dt)
    end, 1 / 10) 

    self:checkTime(0)
end

function UIWorldWildCoords:onExit()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UIWorldWildCoords:checkTime(dt)
    
    local speed = self.data.lCollectSpeed / 3600
    self.scheStartTime = self.scheStartTime + dt
    local cutTime = self.scheStartTime - self.data.lCollectStart
    local alreadyGet = speed * cutTime + (self.data.lPlusRes or 0)

    local hp = math.ceil(self.designerData.allres - alreadyGet - self.data.lCollectCount)
    self.res:setString(hp)
    if hp < 0 then
        global.g_worldview.mapPanel:closeChoose(true)
        if self.scheduleListenerId then
            gscheduler.unscheduleGlobal(self.scheduleListenerId)
            self.scheduleListenerId = nil
        end
        return
    end
    -- self.ready:setString(math.ceil(alreadyGet))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN\

function UIWorldWildCoords:check(sender, eventType)

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
--CALLBACKS_FUNCS_END

return UIWorldWildCoords

--endregion

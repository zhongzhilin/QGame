--region UIPassDoorRandomPanel.lua
--Author : untory
--Date   : 2017/01/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local luaCfg = global.luaCfg
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPassDoorRandomPanel  = class("UIPassDoorRandomPanel", function() return gdisplay.newWidget() end )

function UIPassDoorRandomPanel:ctor()
    self:CreateUI()
end

function UIPassDoorRandomPanel:CreateUI()
    local root = resMgr:createWidget("world/mainland/fly_door_random")
    self:initUI(root)
end

function UIPassDoorRandomPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/fly_door_random")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_export
    self.info = self.root.Node_export.info_mlan_28_export
    self.collection = self.root.Node_export.collection_export
    self.reward = self.root.Node_export.reward_export
    self.timeinfo = self.root.Node_export.timeinfo_mlan_5_export
    self.time = self.root.Node_export.timeinfo_mlan_5_export.time_export
    local FileNode_1_TimeLine = resMgr:createTimeline("effect/Transfer_door2")
    FileNode_1_TimeLine:play("animation0", true)
    self.root.Node_export.FileNode_1:runAction(FileNode_1_TimeLine)

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.reward, function(sender, eventType) self:rewardHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIPassDoorRandomPanel:onEnter()
   
   local FileNode_1_TimeLine = resMgr:createTimeline("effect/Transfer_door2")
    FileNode_1_TimeLine:play("animation0", true)
    self.root.Node_export.FileNode_1:runAction(FileNode_1_TimeLine)
    -- local str = luaCfg:get_local_string(10300,luaCfg:get_map_region_by(global.g_worldview.areaDataMgr.areaId).name) 
    -- self.name:setString(str)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPassDoorRandomPanel:setCity( city )
    
    self.city = city
    self.endTime = self.city:getDoorEndTime()
    self.name:setString(city:getName())

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime() 
    end, 1)

    self:checkTime()
    -- self.targetId = self.city:getDoorTarget()
    -- self.target:setString(luaCfg:get_map_region_by(self.targetId).name)
end

function UIPassDoorRandomPanel:onExit()
    
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UIPassDoorRandomPanel:checkTime()
    

    local contentTime = global.dataMgr:getServerTime()
    local cutTime = self.endTime - contentTime

    print(contentTime)

    dump(self.city.data)

    if cutTime < 0 then
        
        global.panelMgr:closePanel("UIPassDoorRandomPanel")
        global.panelMgr:closePanel("UITroopPanel")
        global.panelMgr:closePanel("UIChooseLand")
        global.panelMgr:closePanel("UIPassTroopPanel")
 
        global.tipsMgr:showWarning("PortOver")

        return        
    end

    local hour = math.floor(cutTime / 3600) 
    cutTime = cutTime  % 3600
    local min = math.floor(cutTime / 60)
    cutTime = cutTime % 60
    local sec = math.floor(cutTime)

    self.time:setString(string.format("%02d:%02d:%02d", hour,min,sec))
end

function UIPassDoorRandomPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIPassDoorRandomPanel")
end

function UIPassDoorRandomPanel:collect_click(sender, eventType)
    
    global.troopData:setTargetData(4)    
    global.panelMgr:openPanel("UITroopPanel")   
end

function UIPassDoorRandomPanel:rewardHandler(sender, eventType)
    
    global.panelMgr:openPanel("UIChooseLand")
    -- global.panelMgr:openPanel("UIPassTroopPanel"):setLandIndex(self.targetId)
end
--CALLBACKS_FUNCS_END

return UIPassDoorRandomPanel

--endregion

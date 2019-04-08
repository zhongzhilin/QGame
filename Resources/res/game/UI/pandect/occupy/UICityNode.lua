--region UICityNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICityNode  = class("UICityNode", function() return gdisplay.newWidget() end )

function UICityNode:ctor()
    self:CreateUI()
end

function UICityNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_city_node")
    self:initUI(root)
end

function UICityNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_city_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.Node.iconBtn.icon_export
    self.city_name = self.root.Node.city_name_export
    self.posX = self.root.Node.posX_export
    self.posY = self.root.Node.posY_export
    self.food_speed = self.root.Node.food_speed_export
    self.wood_speed = self.root.Node.wood_speed_export
    self.coin_speed = self.root.Node.coin_speed_export
    self.stone_speed = self.root.Node.stone_speed_export
    self.go_target = self.root.Node.go_target_export

    uiMgr:addWidgetTouchHandler(self.root.Node.iconBtn, function(sender, eventType) self:gpsCity(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    
    self.root.Node.iconBtn:setSwallowTouches(false)
    self.go_target:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UICityNode:setData(data)
    
    self.data = data
    self.city_name:setString(data.szCityName)

    local surfaceData = luaCfg:get_world_surface_by(302) -- 敌对城堡
    global.panelMgr:setTextureFor(self.icon,surfaceData.worldmap)
   
    local addPer = luaCfg:get_config_by(1).occupyReward
    self.food_speed:setString(addPer.."%")
    self.wood_speed:setString(addPer.."%")
    self.coin_speed:setString(addPer.."%")
    self.stone_speed:setString(addPer.."%")

    data.lPosX = data.lPosX or 0
    data.lPosY = data.lPosY or 0
    local worldConst = require("game.UI.world.utils.WorldConst")
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(pos.x)
    self.posY:setString(pos.y)

end

function UICityNode:gpsCity(sender, eventType)
end

function UICityNode:gpsHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if sPanel.isPageMove then 
            return
        end
        global.guideMgr:setStepArg({id=tonumber(self.data.lCityID or 0), isWild=0})
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_PANDECT) 
    end
end
--CALLBACKS_FUNCS_END

return UICityNode

--endregion

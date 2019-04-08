--region UICityListNode.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICityListNode  = class("UICityListNode", function() return gdisplay.newWidget() end )

function UICityListNode:ctor()
    self:CreateUI()
end

function UICityListNode:CreateUI()
    local root = resMgr:createWidget("resource/res_city_list_node")
    self:initUI(root)
end

function UICityListNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_city_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.go_target = self.root.res_list_bg.go_target_export
    self.stone_speed = self.root.res_list_bg.stone_speed_export
    self.coin_speed = self.root.res_list_bg.coin_speed_export
    self.wood_speed = self.root.res_list_bg.wood_speed_export
    self.food_speed = self.root.res_list_bg.food_speed_export
    self.posY = self.root.res_list_bg.posY_export
    self.posX = self.root.res_list_bg.posX_export
    self.city_name = self.root.res_list_bg.city_name_export
    self.icon = self.root.res_list_bg.iconBtn.icon_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.res_list_bg.iconBtn, function(sender, eventType) self:gpsCity(sender, eventType) end, true)
--EXPORT_NODE_END
    self.go_target:setSwallowTouches(false)
    self.root.res_list_bg.iconBtn:setSwallowTouches(false)
    self.root.res_list_bg.iconBtn:setTouchEnabled(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICityListNode:setData(data)
    
    self.data = data
    self.city_name:setString(data.szCityName)

    local surfaceData = luaCfg:get_world_surface_by(302) -- 敌对城堡
    -- self.icon:setSpriteFrame(surfaceData.worldmap)
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

function UICityListNode:gpsCity(sender, eventType)
    
end

function UICityListNode:gpsHandler(sender, eventType)

    local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
    if eventType == ccui.TouchEventType.began then
        infoPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if infoPanel.isPageMove then 
            return
        end
        global.funcGame:gpsWorldPos(cc.p(self.data.lPosX, self.data.lPosY))
    end

end
--CALLBACKS_FUNCS_END

return UICityListNode

--endregion

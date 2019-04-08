--region UIVillageNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIVillageNode  = class("UIVillageNode", function() return gdisplay.newWidget() end )

function UIVillageNode:ctor()
    self:CreateUI()
end

function UIVillageNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_village_node")
    self:initUI(root)
end

function UIVillageNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_village_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.village_btn = self.root.Node_1.village_btn_export
    self.village_icon = self.root.Node_1.village_btn_export.village_icon_export
    self.village_name = self.root.Node_1.village_name_export
    self.posX = self.root.Node_1.posX_export
    self.posY = self.root.Node_1.posY_export
    self.go_target = self.root.Node_1.go_target_export

    uiMgr:addWidgetTouchHandler(self.village_btn, function(sender, eventType) self:gpsLocation(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END

    self.village_btn:setSwallowTouches(false)
    self.go_target:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIVillageNode:setData(data)

    self.data = data
    local getSurfaceData = function () 
        for _ ,v in pairs(global.luaCfg:world_surface()) do
            if data.lId == v.type then 
                return v
            end 
        end 
    end 
    local surfaceData = getSurfaceData()
    if not surfaceData then return end
    self.village_name:setString(surfaceData.name)
    global.panelMgr:setTextureFor(self.village_icon, surfaceData.worldmap)
    self.village_icon:setScale(0.6)
    self.village_icon:setPositionY(108)
    if data.lId ~= 0 then -- 联盟村庄
        self.village_icon:setScale(0.75)
        self.village_icon:setPositionY(118)
    end

    data.lPosX = data.lPosX or 0
    data.lPosY = data.lPosY or 0
    local worldConst = require("game.UI.world.utils.WorldConst")
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(pos.x)
    self.posY:setString(pos.y)

end

function UIVillageNode:gpsLocation(sender, eventType)
end

function UIVillageNode:gpsHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if sPanel.isPageMove then 
            return
        end
        
        global.guideMgr:setStepArg({id=tonumber(self.data.Params or 0), isWild=0})
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_PANDECT)                         
    end
end
--CALLBACKS_FUNCS_END

return UIVillageNode

--endregion

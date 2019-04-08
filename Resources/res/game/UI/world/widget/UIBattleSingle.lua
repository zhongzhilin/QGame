--region UIBattleSingle.lua
--Author : yyt
--Date   : 2016/11/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleSingle  = class("UIBattleSingle", function() return gdisplay.newWidget() end )

function UIBattleSingle:ctor()
    -- self:CreateUI()
end

function UIBattleSingle:CreateUI()
    local root = resMgr:createWidget("effect/bigworld_battle_sign")
    self:initUI(root)
end

function UIBattleSingle:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/bigworld_battle_sign")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Node_1_export

    uiMgr:addWidgetTouchHandler(self.root.Node_1_export.Button_1, function(sender, eventType) self:battle_click(sender, eventType) end)
--EXPORT_NODE_END
	
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBattleSingle:setData(data)

    self.city = global.g_worldview.mapPanel:getCityByIdForAll(data.lTarget,data.lWildKind)
    self.isBoss = false

    self.Node_1:setPositionY(0)
    if self.city.isOccupire and self.city:isOccupire() then
        self.Node_1:setPositionY(33)
    end

    if self.city.isWildObj and self.city:isBoss() then
        self.Node_1:setPositionY(self.city.name:getPositionY() - 50)
    end 
end

function UIBattleSingle:setBoss(boss)
    
    self.city = boss
    self.isBoss = true

    self.Node_1:setPositionY(self.city.name:getPositionY() - 45)
end

function UIBattleSingle:battle_click(sender, eventType)

    local openCall = function()
        if self.city then
           local cityData = self.city:getSurfaceData()
           local infoPanel = global.panelMgr:openPanel("UIPKInfoPanel") 
           infoPanel:setData(self.city,  cityData)
        end
    end

    if self.isBoss then
        global.worldApi:infoBattle(function(msg)
            openCall()
        end, self.city:getId())
    else
        openCall()
    end    
    
end
--CALLBACKS_FUNCS_END

return UIBattleSingle

--endregion

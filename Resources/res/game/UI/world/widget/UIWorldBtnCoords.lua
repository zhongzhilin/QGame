--region UIWorldBtnCoords.lua
--Author : Untory
--Date   : 2017/12/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldBtnCoords  = class("UIWorldBtnCoords", function() return gdisplay.newWidget() end )

function UIWorldBtnCoords:ctor()
    self:CreateUI()
end

function UIWorldBtnCoords:CreateUI()
    local root = resMgr:createWidget("world/world_btn_coords")
    self:initUI(root)
end

function UIWorldBtnCoords:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_btn_coords")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.collection = self.root.collection_export
    self.xy = self.root.collection_export.xy_export
    self.star = self.root.collection_export.star_export

    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:check(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.star, function(sender, eventType) self:check(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWorldBtnCoords:setData(city)
    
    self.city = city

    if self.city.isSoldier then
        self:setVisible(false)
    end

    local pos = global.g_worldview.const:converPix2Location(cc.p(city:getPosition()))
    self.xy:setString(luaCfg:get_local_string(10945,pos.x,pos.y))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldBtnCoords:check(sender, eventType)
    
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

return UIWorldBtnCoords

--endregion

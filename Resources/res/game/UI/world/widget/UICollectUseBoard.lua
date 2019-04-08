--region UICollectUseBoard.lua
--Author : yyt
--Date   : 2016/11/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICollectUseBoard  = class("UICollectUseBoard", function() return gdisplay.newWidget() end )

local _instance = nil

function UICollectUseBoard:ctor()

    self:CreateUI()

    self:retain()
end

function UICollectUseBoard:getInstance()
    
    if _instance == nil then _instance = UICollectUseBoard.new() end

    return _instance

end

function UICollectUseBoard:CreateUI()
    local root = resMgr:createWidget("world/mark_useBorad")
    self:initUI(root)
end

function UICollectUseBoard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mark_useBorad")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.useBordNode = self.root.useBordNode_export
    self.delete = self.root.useBordNode_export.delete_export
    self.edit = self.root.useBordNode_export.edit_export
    self.gps = self.root.useBordNode_export.gps_export
    self.share = self.root.useBordNode_export.share_export

    uiMgr:addWidgetTouchHandler(self.delete, function(sender, eventType) self:delete_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.edit, function(sender, eventType) self:edit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.gps, function(sender, eventType) self:gpsCity_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.share, function(sender, eventType) self:share_call(sender, eventType) end)
--EXPORT_NODE_END
    self.lastType = 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICollectUseBoard:onEnter()
    
    global.g_worldview.worldPanel.gpsCityData = {cityId=0, mapId=0}

end

function UICollectUseBoard:bindToItem(item)

    local data = item.data
    self.data = data
    self.lastType = self.data.lType
    
    if self.preItem then
        self:removeFromParent()
    end

    self.root:setOpacity(0)
    self.root:stopAllActions()
    self.root:runAction(cc.Sequence:create(cc.FadeIn:create(0.4)))

    self.preItem = item
    item:addChild(self)

    return self
end

function UICollectUseBoard:hideSelf(item)

    if item ~= self.preItem then return end
    if self.preItem then
        self:removeFromParent()
    end
    self.preItem = nil
end

function UICollectUseBoard:delete_click(sender, eventType)
    
    global.worldApi:setBookMark(self.data.lID, self.data.lCityID, 2, self.data.lType, self.data.lMapID, self.data.lPosX, self.data.lPosY ,  self.data.szName, function (msg)
        
        global.collectData:deleteCollect(self.data.lID)
        local panel = global.panelMgr:getPanel("UICollectListPanel")
        panel:setData(self.data.lType + 1)
    end)
end

function UICollectUseBoard:edit_click(sender, eventType)
    
    local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
    collectPanel:setData(-1, self.data, handler(self, self.editCall))
end

function UICollectUseBoard:editCall(lType, szName, exitCall)

    self.data.lType = lType
    self.data.szName = szName
    global.worldApi:setBookMark(self.data.lID, self.data.lCityID, 1, lType, self.data.lMapID, self.data.lPosX, self.data.lPosY , self.data.szName, function (msg)

        global.collectData:updateCollect(self.data)
        local panel = global.panelMgr:getPanel("UICollectListPanel")
        panel:setData( self.lastType + 1)--lType + 1)
        exitCall()
    end)
    
end

function UICollectUseBoard:gpsCity_click(sender, eventType)

    global.g_worldview.worldPanel.gpsCityData  = {cityId=self.data.lCityID, mapId=self.data.lMapID} 

    local listPanel = global.panelMgr:getPanel("UICollectListPanel")
    listPanel:exit_call()

    self:chooseObj(self.data.lCityID) 
    
end

function UICollectUseBoard:chooseObj( cityId )
    
    local surfaceData = luaCfg:get_world_surface_by(self.data.lMapID)
    local lWildKind = surfaceData.mold

    if lWildKind <= 0 or true then
        global.g_worldview.worldPanel:chooseCityById(cityId,lWildKind)
    else
        self:gpsWild()
    end

end

---- 资源野怪直接根据坐标定位
function UICollectUseBoard:gpsWild()
    
    local posXY = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)

    local pos = global.g_worldview.const:converLocation2Pix(cc.p(y, x))
    local isExitXY = global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-pos.x, -pos.y)) 
    if isExitXY then
        local worldPanel = global.panelMgr:getPanel("UIWorldPanel")
        if worldPanel then
            worldPanel.locationInfo:setPosLocation(cc.p(x, y))
        end
    end
end

function UICollectUseBoard:share_call(sender, eventType)

    local posXY = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)


    local surfaceData = luaCfg:get_world_surface_by(self.data.lMapID) 
    local lWildKind = surfaceData.mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.data.szName,posX = x,posY = y,cityId = self.data.lCityID,wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl)   
end
--CALLBACKS_FUNCS_END

return UICollectUseBoard

--endregion

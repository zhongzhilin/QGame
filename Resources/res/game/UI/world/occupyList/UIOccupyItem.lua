--region UIOccupyItem.lua
--Author : untory
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOccupyItem  = class("UIOccupyItem", function() return gdisplay.newWidget() end )

function UIOccupyItem:ctor()
  
    self:CreateUI()  
end

function UIOccupyItem:setData(data)
    
    self.data = data

    dump(data,"UIOccupyItem")

    local trueName = global.funcGame:translateDst(data.szName, data.lMapType, data.lCityID)
    
    print(trueName)

    local surfaceData = luaCfg:get_world_surface_by(data.lMapID)
    if surfaceData then
        --　野怪
        if surfaceData.type == 102 then
            -- self.icon:setSpriteFrame(surfaceData.uimap)
            global.panelMgr:setTextureFor(self.icon,surfaceData.uimap)
        else
            -- self.icon:setSpriteFrame(surfaceData.worldmap)            
            global.panelMgr:setTextureFor(self.icon,surfaceData.worldmap)
        end
        self.icon:setScale(surfaceData.iconSize)
    end

    self.cityName:setString(trueName)

    -- if data.szName and data.szName ~= "" then 
        
    -- else
    --     self.cityName:setString("")
    -- end
    local pos = global.g_worldview.const:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(math.round(pos.x))
    self.posY:setString(math.round(pos.y))
end

function UIOccupyItem:CreateUI()
    local root = resMgr:createWidget("world/occupy_info")
    self:initUI(root)
end

function UIOccupyItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/occupy_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ListNode = self.root.ListNode_export
    self.icon = self.root.ListNode_export.icon_export
    self.cityName = self.root.ListNode_export.cityName_export
    self.posX = self.root.ListNode_export.posX_export
    self.posY = self.root.ListNode_export.posY_export
    self.orderBtn = self.root.orderBtn_export

    uiMgr:addWidgetTouchHandler(self.orderBtn, function(sender, eventType) self:orderBack_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIOccupyItem:orderBack_click(sender, eventType)

    local  lWildKind = 0
    local surfaceData = luaCfg:get_world_surface_by(self.data.lMapID) 
    if surfaceData.type == 101 then
        lWildKind = 1
    elseif surfaceData.type == 102 then
        lWildKind = 2
    end

    global.panelMgr:closePanel("UIOccupyPanel")
    global.panelMgr:closePanel("UICastleInfoPanel")
    global.g_worldview.worldPanel:chooseCityById(self.data.lCityID,lWildKind)
end
--CALLBACKS_FUNCS_END

return UIOccupyItem

--endregion

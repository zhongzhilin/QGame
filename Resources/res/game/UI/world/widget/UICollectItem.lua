--region UICollectItem.lua
--Author : yyt
--Date   : 2016/11/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UICollectUseBoard = require("game.UI.world.widget.UICollectUseBoard")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICollectItem  = class("UICollectItem", function() return gdisplay.newWidget() end )

function UICollectItem:ctor()
    self:CreateUI()
end

function UICollectItem:CreateUI()
    local root = resMgr:createWidget("world/mark_type")
    self:initUI(root)
end

function UICollectItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mark_type")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ListNode = self.root.ListNode_export
    self.selectBg = self.root.ListNode_export.selectBg_export
    self.icon = self.root.ListNode_export.icon_export
    self.cityName = self.root.ListNode_export.cityName_export
    self.posX = self.root.ListNode_export.posX_export
    self.posY = self.root.ListNode_export.posY_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICollectItem:setData(data)

    self.data = data
    
    local surfaceData = luaCfg:get_world_surface_by(data.lMapID)
    if surfaceData then
        --　野怪
        if surfaceData.type == 102 then
            -- self.icon:setSpriteFrame(surfaceData.uimap)
            global.panelMgr:setTextureFor(self.icon,surfaceData.uimap)
        else
            global.panelMgr:setTextureFor(self.icon,surfaceData.worldmap)
            -- self.icon:setSpriteFrame(surfaceData.worldmap)
        end
        self.icon:setScale(surfaceData.iconSize)
    end

    if data.szName and data.szName ~= "" then 
        self.cityName:setString(data.szName)
    else
        self.cityName:setString("")
    end
    local pos = global.g_worldview.const:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(math.round(pos.x))
    self.posY:setString(math.round(pos.y))

end

function UICollectItem:showUse()
    
    self.selectBg:setVisible(true)
    self.root:setPositionY(global.collectData:getCellSize())

    UICollectUseBoard:getInstance():bindToItem(self)
end

function UICollectItem:hideUse()
    
    self.selectBg:setVisible(false)
    self.root:setPositionY(0)

    UICollectUseBoard:getInstance():hideSelf(self)
end

--CALLBACKS_FUNCS_END

return UICollectItem

--endregion

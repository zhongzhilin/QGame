--region UIWorldSearchItem.lua
--Author : Untory
--Date   : 2017/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local panelMgr = global.panelMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldSearchItem  = class("UIWorldSearchItem", function() return gdisplay.newWidget() end )

function UIWorldSearchItem:ctor()
    
    self:CreateUI()
end

function UIWorldSearchItem:CreateUI()
    local root = resMgr:createWidget("world/info/seek_list")
    self:initUI(root)
end

function UIWorldSearchItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/seek_list")
 
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tp = self.root.tp_export
    self.icon = self.root.icon_export
    self.name = self.root.name_export
    self.unlock = self.root.unlock_export

--EXPORT_NODE_END
end

function UIWorldSearchItem:setData(data)

    local chooseIndex = panelMgr:getPanel("UIWorldSearchPanel"):getChooseIndex()

    local world_surface = luaCfg:get_world_surface_by(data.image) 
    if world_surface.type == 102 then
        global.panelMgr:setTextureForAsync(self.icon, world_surface.uimap, true)        
    else
        global.panelMgr:setTextureForAsync(self.icon, world_surface.worldmap, true)
    end
    self.icon:setScale(data.Size / 100)
    
    self.name:setString(data.name)

    self.tp:setVisible(data.id == chooseIndex)

    local mainCityLevel = global.cityData:getMainCityLevel()
    if mainCityLevel < data.unlock then

        self.lockLevel = data.unlock
        global.colorUtils.turnGray(self.root,true)
        self.unlock:setVisible(true)
    else

        global.colorUtils.turnGray(self.root,false)
        self.unlock:setVisible(false)
    end
end

function UIWorldSearchItem:isLocked()
    
    return self.unlock:isVisible()
end

function UIWorldSearchItem:getUnLockLevel()
    
    return self.lockLevel
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWorldSearchItem

--endregion

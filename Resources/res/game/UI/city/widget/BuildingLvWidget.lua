--region BuildingLvWidget.lua
--Author : wuwx
--Date   : 2016/08/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildingLvWidget  = class("BuildingLvWidget", function() return gdisplay.newWidget() end )

function BuildingLvWidget:ctor()
end

function BuildingLvWidget:CreateUI()
    local root = resMgr:createWidget("city/build_level_ui")
    self:initUI(root)
end

function BuildingLvWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_level_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.level = self.root.level_export
    self.level_txt = self.root.level_export.level_txt_export
    self.canlvup = self.root.canlvup_export

--EXPORT_NODE_END
end

function BuildingLvWidget:setData(data)
    self.level_txt:setString(data.serverData.lGrade)
    self.canlvup:setVisible(global.cityData:checkCanUpgrade(data))

    local buildingUIData = luaCfg:get_buildings_ui_by(global.cityData:getBuildingType(data.buildingType))
    if buildingUIData and buildingUIData.levelui_posX then
        self:setPosition(cc.p(buildingUIData.levelui_posX,buildingUIData.levelui_posY))
    end
    if buildingUIData then
        self.level:setSpriteFrame(buildingUIData.lv_pic)
    end
end

function BuildingLvWidget:onEnter()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return BuildingLvWidget

--endregion

--region UICityDetailPanel.lua
--Author : yyt
--Date   : 2016/10/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICityDetailPanel  = class("UICityDetailPanel", function() return gdisplay.newWidget() end )

function UICityDetailPanel:ctor()
    self:CreateUI()
end

function UICityDetailPanel:CreateUI()
    local root = resMgr:createWidget("city/building_info_base")
    self:initUI(root)
end

function UICityDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/building_info_base")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.main_bg = self.root.main_bg_export
    self.title_node = self.root.title_node_export
    self.namelv = self.root.namelv_export
    self.des = self.root.des_export
    self.name = self.root.name_export
    self.ps_node = self.root.ps_node_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.currentLv = 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICityDetailPanel:adapt()
    for i=1, 6 do 
        if self.buildInfo.root["line"..i] then 
            local old = self.buildInfo.root["line"..i]:getContentSize()
            self.buildInfo.root["line"..i]:setContentSize(cc.size(old.width ,  gdisplay.height-(gdisplay.height-self.ps_node:getPositionY())-20))
        end 
    end 
end 


function UICityDetailPanel:setData( data )
    self.data = data
    self.currentLv = data.serverData.lGrade
 
    self.namelv:setString(data.buildsName.." "..string.format(luaCfg:get_local_string(10019), data.serverData.lGrade) )
    self.des:setString(data.description)

    self.name:setString(luaCfg:get_local_string(10623,data.buildsName))

    self:initDetailUI()

    self:adapt()
end

function UICityDetailPanel:initDetailUI() 
    self:clearBuilding()

    local buildType = global.cityData:getBuildingType(self.data.buildingType)
    local infoType = self:checkPara(buildType, self.data.level )
    local buildInfo = require("game.UI.city.detail.widget.BuildInfo" .. infoType).new(infoType)
    local infoData = self:getbuildInfo(buildType)
    buildInfo:setData(infoData)
    buildInfo:setTag(1001)
    self:addChild(buildInfo)
    self.buildInfo = buildInfo
end

function UICityDetailPanel:clearBuilding()
    
    self:removeChildByTag(1001, true)
end

function UICityDetailPanel:checkPara( buildType, lv )
    
    local paraNum = 0
    local buildInfoData = luaCfg:buildings_info()
    for k,v in pairs(buildInfoData) do
        if v.type == buildType and v.level == lv then

            for i=1,4 do
                if v["typePara"..i] and v["typePara"..i] ~= "" then
                    paraNum = paraNum + 1
                end
            end
        end 
    end
    return paraNum+2
end

function UICityDetailPanel:getbuildInfo( buildType )
    
    local infoTb = {}
    local buildInfoData = luaCfg:buildings_info()
    for k,v in pairs(buildInfoData) do
        if v.type == buildType  then
            table.insert(infoTb, v)
        end 
    end
    table.sort( infoTb, function(s1, s2) return s1.level < s2.level end )
    return infoTb
end

function UICityDetailPanel:exit_call(sender, eventType)

    panelMgr:closePanelForBtn("UICityDetailPanel")  
end

--CALLBACKS_FUNCS_END

function UICityDetailPanel:isCurrLv(i_lv)
    return self.currentLv == i_lv
end

return UICityDetailPanel

--endregion

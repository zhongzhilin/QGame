--region UIBuildListNode.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuildListNode  = class("UIBuildListNode", function() return gdisplay.newWidget() end )

function UIBuildListNode:ctor()
    self:CreateUI()
end

function UIBuildListNode:CreateUI()
    local root = resMgr:createWidget("resource/res_buildings_list_node")
    self:initUI(root)
end

function UIBuildListNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_buildings_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.unit = self.root.res_list_bg.unit_mlan_2_export
    self.buff_speed = self.root.res_list_bg.buff_speed_export
    self.base_speed = self.root.res_list_bg.base_speed_export
    self.buildings_des = self.root.res_list_bg.buildings_des_export
    self.buildIcon = self.root.res_list_bg.buildIcon_export
    self.lv_num = self.root.res_list_bg.lv_num_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBuildListNode:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_RES_BUILDLISTNODE, function (event, allEff)
        if not self.data then return end
        local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
        self:setResBuff(infoPanel:getInitResBuff(self.data.id) or 0, self.perProduce, self.data.id)
    end)
end

function UIBuildListNode:setData(data)
    
    self.data = data
    self.lv_num:setString(data.serverData.lGrade)

    local listdata = luaCfg:get_buildings_list_by(data.buildingType)
    -- self.buildIcon:setSpriteFrame(data.name)
    global.panelMgr:setTextureFor(self.buildIcon,data.name)
    self.buildIcon:setScale(listdata.scale/100)
    self.buildings_des:setString(data.description)

    local perProduce = global.resData:getPerProduce(data.serverData.lGrade, data.buildingType)
    self.perProduce = perProduce
    self.base_speed:setString( global.funcGame:_formatBigNumber(perProduce , 1 ))
    self.buff_speed:setVisible(false)
    self.unit:setPositionX(self.base_speed:getPositionX() + self.base_speed:getContentSize().width)

    local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
    self:setResBuff(infoPanel:getInitResBuff(data.id) or 0, perProduce, data.id)
end

function UIBuildListNode:setResBuff(allAdd, perProduce, id)

    local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
    infoPanel:setBuildResBuff(allAdd, id, true)
    local posX = self.base_speed:getPositionX() + self.base_speed:getContentSize().width
    if allAdd == 0 then
        self.buff_speed:setVisible(false)
    else    
        self.buff_speed:setVisible(true)
        self.buff_speed:setString("+"..global.funcGame:_formatBigNumber(allAdd , 1 ))
        self.buff_speed:setPositionX(posX)
        posX = posX + self.buff_speed:getContentSize().width
    end
    self.unit:setVisible(true)
    self.unit:setPositionX(posX)
    self.unit:setString(luaCfg:get_local_string(10076))
end

--CALLBACKS_FUNCS_END

return UIBuildListNode

--endregion

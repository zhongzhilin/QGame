--region UITroopCombinDetailPanel.lua
--Author : wuwx
--Date   : 2017/12/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITroopCombinDetailPanel  = class("UITroopCombinDetailPanel", function() return gdisplay.newWidget() end )

function UITroopCombinDetailPanel:ctor()
    self:CreateUI()
end

function UITroopCombinDetailPanel:CreateUI()
    local root = resMgr:createWidget("troop/troop_info_bg")
    self:initUI(root)
end

function UITroopCombinDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/troop_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.nameTitle = self.root.Node_export.Node_details.txt.nameTitle_mlan_5_export
    self.name = self.root.Node_export.Node_details.txt.nameTitle_mlan_5_export.name_export
    self.scale = self.root.Node_export.Node_details.txt.scale_mlan_5.scale_export
    self.capacity = self.root.Node_export.Node_details.txt.capacity_mlan_5.capacity_export
    self.speed = self.root.Node_export.Node_details.txt.speed_mlan_5.speed_export
    self.troops_type = self.root.Node_export.Node_details.txt.troops_type_mlan_5.troops_type_export
    self.heroAdd = self.root.Node_export.Node_details.txt.supply_City_mlan_5.heroAdd_export
    self.supply = self.root.Node_export.Node_details.txt.supply_mlan_5.supply_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UITroopCombinDetailPanel:setData(data)
    if data == nil then return end
    self.data = data
    self.troop_size = troop_size
    self.heroMsg = heroMsg

    local heroId = 0
    self.heroAdd:setString("-")
    self.scale:setString(data.troop_size)
    self.troops_type:setString(data.troop_type_str)
    -- self.resource:setString(data.troop_resource_str)
    self.heroAdd:setString(data.troop_power)
    self.speed:setString(data.troops_speed or "-")
    self.capacity:setString(data.troops_carry or "-")
    self.supply:setString(data.troops_supply or "-")
    self.name:setString(data.szName)

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.name:getParent(),self.name)
    global.tools:adjustNodePosForFather(self.scale:getParent(),self.scale)
    global.tools:adjustNodePosForFather(self.troops_type:getParent(),self.troops_type)
    global.tools:adjustNodePosForFather(self.speed:getParent(),self.speed)
    global.tools:adjustNodePosForFather(self.capacity:getParent(),self.capacity)
    global.tools:adjustNodePosForFather(self.supply:getParent(),self.supply)
    global.tools:adjustNodePosForFather(self.heroAdd:getParent(),self.heroAdd)
    -- global.tools:adjustNodePosForFather(self.resource:getParent(),self.resource)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITroopCombinDetailPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UITroopCombinDetailPanel") 
end
--CALLBACKS_FUNCS_END

return UITroopCombinDetailPanel

--endregion

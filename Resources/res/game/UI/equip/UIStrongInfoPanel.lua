--region UIStrongInfoPanel.lua
--Author : Administrator
--Date   : 2017/03/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
local UIEquipInfoProNode = require("game.UI.equip.widget.UIEquipInfoProNode")
--REQUIRE_CLASS_END

local UIStrongInfoPanel  = class("UIStrongInfoPanel", function() return gdisplay.newWidget() end )

function UIStrongInfoPanel:ctor()
    self:CreateUI()
end

function UIStrongInfoPanel:CreateUI()
    local root = resMgr:createWidget("equip/strengthen_info_node")
    self:initUI(root)
end

function UIStrongInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/strengthen_info_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.title = self.root.Node_export.bg_export.node1_export.title_export
    self.close_btn = self.root.Node_export.bg_export.node1_export.close_btn_export
    self.baseIcon = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon, self.root.Node_export.bg_export.node1_export.baseIcon)
    self.equip_name = self.root.Node_export.bg_export.node1_export.equip_name_export
    self.equip_des = self.root.Node_export.bg_export.node1_export.equip_des_export
    self.node2 = self.root.Node_export.bg_export.node2_export
    self.plus_icon_now = self.root.Node_export.bg_export.node2_export.plus_icon_now_export
    self.strengthen_lv1 = self.root.Node_export.bg_export.node2_export.strengthen_lv1_mlan_7_export
    self.strengthen_lv = self.root.Node_export.bg_export.node2_export.strengthen_lv_mlan_7_export
    self.strengthen_now_lv = self.root.Node_export.bg_export.node2_export.strengthen_now_lv_export
    self.plus_icon_next = self.root.Node_export.bg_export.node2_export.plus_icon_next_export
    self.strengthen_next_lv = self.root.Node_export.bg_export.node2_export.strengthen_next_lv_export
    self.icon = self.root.Node_export.bg_export.node2_export.icon_export
    self.icon1 = self.root.Node_export.bg_export.node2_export.icon1_export
    self.ownValue = self.root.Node_export.bg_export.node2_export.ownValue_export
    self.ownValue_next = self.root.Node_export.bg_export.node2_export.ownValue_next_export
    self.proNode = self.root.Node_export.bg_export.node2_export.proNode_export
    self.pro1 = UIEquipInfoProNode.new()
    uiMgr:configNestClass(self.pro1, self.root.Node_export.bg_export.node2_export.proNode_export.pro1)
    self.pro2 = UIEquipInfoProNode.new()
    uiMgr:configNestClass(self.pro2, self.root.Node_export.bg_export.node2_export.proNode_export.pro2)
    self.pro3 = UIEquipInfoProNode.new()
    uiMgr:configNestClass(self.pro3, self.root.Node_export.bg_export.node2_export.proNode_export.pro3)
    self.pro4 = UIEquipInfoProNode.new()
    uiMgr:configNestClass(self.pro4, self.root.Node_export.bg_export.node2_export.proNode_export.pro4)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END

    --调整界面时 + 号 可能在前面 等级 后面
    self.strengthen_now_lv:setPositionX(99999)
    self.strengthen_next_lv:setPositionX(99999)
end

function UIStrongInfoPanel:setData(data,nextLevel)

    local isSuccess = 1

    if nextLevel then
        if data.lStronglv > nextLevel then
            isSuccess = -1
            self.title:setString(luaCfg:get_local_string(10442))
        elseif data.lStronglv == nextLevel then
            isSuccess = 0
            self.title:setString(luaCfg:get_local_string(10442))
        else
            self.title:setString(luaCfg:get_local_string(10441))
        end
    else
        self.title:setString(luaCfg:get_local_string(10443))
    end    

    nextLevel = nextLevel or data.lStronglv + 1

    
    if isSuccess == 1 then
        self.ownValue_next:setTextColor(cc.c3b(87,213,63))
    elseif isSuccess == 0 then
        self.ownValue_next:setTextColor(cc.c3b(255,226,165))
    elseif isSuccess == -1 then
        self.ownValue_next:setTextColor(cc.c3b(180,29,11))
    end


    self.baseIcon:setData(data.confData)
    self.equip_name:setString(data.confData.name)
    self.equip_des:setString(data.confData.des)
    self.strengthen_now_lv:setString(data.lStronglv)
    self.strengthen_next_lv:setString(nextLevel)

    self.ownValue:setString(data.lCombat)
    self.ownValue_next:setString(global.equipData:colNextStrongCombat(data,nextLevel))


    --英文版对齐处理 张亮
    global.tools:adjustNodePos(self.strengthen_lv,self.plus_icon_now)
    global.tools:adjustNodePos(self.plus_icon_now,self.strengthen_now_lv)


    global.tools:adjustNodePos(self.strengthen_lv1,self.plus_icon_next)
    global.tools:adjustNodePos(self.plus_icon_next,self.strengthen_next_lv)

    for i = 1,4 do

        self["pro"..i]:setVisible(false)
    end

    local count = 0
    for i = 1,4 do

        local nextPro = global.equipData:colNextStrongPro(data, i,nextLevel)
        local curPro = data.tgAttr[i]
        if nextPro ~= 0 then

            count = count + 1
            self["pro"..count]:setData(luaCfg:get_local_string(WCONST.BASE_PROPERTY[i].LOCAL_STR),curPro,nextPro,isSuccess)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIStrongInfoPanel:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn("UIStrongInfoPanel")
end

function UIStrongInfoPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIStrongInfoPanel")
end
--CALLBACKS_FUNCS_END

return UIStrongInfoPanel

--endregion

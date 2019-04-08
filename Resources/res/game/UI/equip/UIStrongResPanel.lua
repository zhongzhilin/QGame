--region UIStrongResPanel.lua
--Author : Administrator
--Date   : 2017/03/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local TextScrollControl = require("game.UI.common.UITextScrollControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipInfoProNode = require("game.UI.equip.widget.UIEquipInfoProNode")
--REQUIRE_CLASS_END

local UIStrongResPanel  = class("UIStrongResPanel", function() return gdisplay.newWidget() end )

function UIStrongResPanel:ctor()
    self:CreateUI()
end

function UIStrongResPanel:CreateUI()
    local root = resMgr:createWidget("equip/strengthen_result_node")
    self:initUI(root)
end

function UIStrongResPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/strengthen_result_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.effect = self.root.Node_export.bg_export.effect_export
    self.node2 = self.root.Node_export.bg_export.node2_export
    self.strengthen_lv = self.root.Node_export.bg_export.node2_export.strengthen_lv_mlan_7_export
    self.strengthen_lv1 = self.root.Node_export.bg_export.node2_export.strengthen_lv1_mlan_7_export
    self.plus_icon_now = self.root.Node_export.bg_export.node2_export.plus_icon_now_export
    self.strengthen_now_lv = self.root.Node_export.bg_export.node2_export.strengthen_now_lv_export
    self.plus_icon_next = self.root.Node_export.bg_export.node2_export.plus_icon_next_export
    self.strengthen_next_lv = self.root.Node_export.bg_export.node2_export.strengthen_next_lv_export
    self.icon = self.root.Node_export.bg_export.node2_export.icon_export
    self.icon = self.root.Node_export.bg_export.node2_export.icon_export_0
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
--EXPORT_NODE_END
    --调整界面时 + 号 可能在前面 等级 后面
    self.strengthen_now_lv:setPositionX(99999)
    self.strengthen_next_lv:setPositionX(99999)
end


function UIStrongResPanel:setData(data,nextLevel)

    local isSuccess = 1

    if nextLevel then
        if data.lStronglv > nextLevel or data.lStronglv == nextLevel then

            if data.lStronglv > nextLevel then

                isSuccess = -1
            else

                isSuccess = 0
            end

            local effect_TimeLine = resMgr:createTimeline("effect/equip_str_y_n")
            effect_TimeLine:play("animation1", false)
            self.effect:runAction(effect_TimeLine)

            self.effect.power_y_2:setVisible(false)
            self.effect.power_n_3:setVisible(true)

        else
            
            local effect_TimeLine = resMgr:createTimeline("effect/equip_str_y_n")
            effect_TimeLine:play("animation0", false)
            self.effect:runAction(effect_TimeLine)


            self.effect.power_y_2:setVisible(true)
            self.effect.power_n_3:setVisible(false)
        end
    end    

    nextLevel = nextLevel or data.lStronglv + 1

    
    if isSuccess == 1 then
        self.ownValue_next:setTextColor(cc.c3b(87,213,63))
    elseif isSuccess == 0 then
        self.ownValue_next:setTextColor(cc.c3b(255,226,165))
    elseif isSuccess == -1 then
        self.ownValue_next:setTextColor(cc.c3b(180,29,11))
    end


    -- self.baseIcon:setData(data.confData)
    -- self.equip_name:setString(data.confData.name)
    -- self.equip_des:setString(data.confData.des)
    self.strengthen_now_lv:setString(data.lStronglv)
    self.strengthen_next_lv:setString(nextLevel)

    self.ownValue:setString(data.lCombat)

    self.ownValue_next:setString(data.lCombat)
    TextScrollControl.startScroll(self.ownValue_next,global.equipData:colNextStrongCombat(data,nextLevel),1)

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
            self["pro"..count]:setData(luaCfg:get_local_string(WCONST.BASE_PROPERTY[i].LOCAL_STR),curPro,nextPro,isSuccess,true)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIStrongResPanel:exitCall(sender, eventType)
    global.panelMgr:closePanelForBtn("UIStrongResPanel")
end
--CALLBACKS_FUNCS_END

return UIStrongResPanel

--endregion

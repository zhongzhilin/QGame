--region UICreateUnionPanel.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UICreateUnionPanel  = class("UICreateUnionPanel", function() return gdisplay.newWidget() end )

function UICreateUnionPanel:ctor()
    self:CreateUI()
end

function UICreateUnionPanel:CreateUI()
    local root = resMgr:createWidget("union/union_create")
    self:initUI(root)
end

function UICreateUnionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_create")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_mlan_15_export
    self.create = self.root.Node_export.Node_5.create_export
    self.charge_btn = self.root.Node_export.Node_5.charge_btn_export
    self.dia_icon = self.root.Node_export.Node_5.charge_btn_export.dia_icon_export
    self.dia_num = self.root.Node_export.Node_5.charge_btn_export.dia_num_export
    self.info1 = self.root.Node_export.Node_1.info1_mlan_20_export
    self.notice = self.root.Node_export.Node_1.notice_export
    self.notice = UIInputBox.new()
    uiMgr:configNestClass(self.notice, self.root.Node_export.Node_1.notice_export)
    self.input = self.root.Node_export.Node_1.input_export
    self.input = UIInputBox.new()
    uiMgr:configNestClass(self.input, self.root.Node_export.Node_1.input_export)
    self.info2 = self.root.Node_export.Node_1.info2_mlan_18_export
    self.attack_mode_cb1 = self.root.Node_export.Node_1.attack_mode_cb1_export
    self.attack_mode_cb2 = self.root.Node_export.Node_1.attack_mode_cb2_export
    self.tips = self.root.Node_export.Node_1.tips_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.create, function(sender, eventType) self:createHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.charge_btn, function(sender, eventType) self:cost_rechange(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb1, function(sender, eventType) self:call_cb1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb2, function(sender, eventType) self:call_cb2(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb1, function(sender, eventType) self:call_cb1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_mode_cb2, function(sender, eventType) self:call_cb2(sender, eventType) end)
    self.notice:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
end


local color ={
    default= cc.c3b( 255,192 , 0),
    red = gdisplay.COLOR_RED,
} 


function UICreateUnionPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()
       if self.data then 
        self:setData(self.data)
       end  
    end)
end 

function UICreateUnionPanel:setData(data)
    self.data = data

    self.lAutoApprove = self.attack_mode_cb1:isSelected()

    self.notice:setString("")
    self.input:setString("")
    self.attack_mode_cb1:setSelected(true)
    self.attack_mode_cb2:setSelected(false)

    local cost = global.luaCfg:get_config_by(1).UnionCreateCost
    local lv = global.luaCfg:get_config_by(1).UnionCreateLv

    self.charge_btn:setVisible(global.cityData:getMainCityLevel() < lv)
    self.tips:setVisible(global.cityData:getMainCityLevel() < lv)

    self.create:setVisible(not self.charge_btn:isVisible())

    self.canPay = tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) >= cost 

     if global.cityData:getMainCityLevel() < lv then 
         self.tips:setString(global.luaCfg:get_local_string(10951,lv))
         self.dia_num:setString(cost)
        if self.canPay then 
            self.dia_num:setColor(color.default)
        else 
            self.dia_num:setColor(color.red)
        end             
     end
    

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICreateUnionPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanelForBtn("UICreateUnionPanel")
end

function UICreateUnionPanel:createHandler(sender, eventType)
    local szName = self.input:getString()
    local szInfo = self.notice:getString()
    local lAutoApprove = self.lAutoApprove and 1 or 0
    global.unionApi:createUnion(szName, szInfo, lAutoApprove, function(msg)
        global.unionData:setInUnion(msg.tgAlly)
        global.panelMgr:closePanel("UIUnionSearchPanel")
        global.panelMgr:closePanel("UICreateUnionPanel")
        global.panelMgr:closePanel("UIUnionPanel")
        global.panelMgr:openPanel("UIHadUnionPanel")
    end)
end

function UICreateUnionPanel:call_cb1(sender, eventType)
    self.attack_mode_cb2:setSelected(false)
    self.attack_mode_cb1:setSelected(true)
    self.lAutoApprove = self.attack_mode_cb1:isSelected()
end

function UICreateUnionPanel:call_cb2(sender, eventType)
    self.attack_mode_cb2:setSelected(true)
    self.attack_mode_cb1:setSelected(false)
    self.lAutoApprove = self.attack_mode_cb1:isSelected()
end

function UICreateUnionPanel:cost_rechange(sender, eventType)
    if  self.canPay then 
        self:createHandler()
    else 
        global.tipsMgr:showWarning("ItemUseDiamond")
    end 
end
--CALLBACKS_FUNCS_END

return UICreateUnionPanel

--endregion

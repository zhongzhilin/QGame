--region UIPromptUpgradePanel.lua
--Author : wuwx
--Date   : 2017/12/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPromptUpgradePanel  = class("UIPromptUpgradePanel", function() return gdisplay.newWidget() end )

function UIPromptUpgradePanel:ctor()
    self:CreateUI()
end

function UIPromptUpgradePanel:CreateUI()
    local root = resMgr:createWidget("city/build_magic")
    self:initUI(root)
end

function UIPromptUpgradePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_magic")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.res1 = self.root.Node_export.res1_export
    self.res2 = self.root.Node_export.res2_export
    self.res3 = self.root.Node_export.res3_export
    self.res4 = self.root.Node_export.res4_export
    self.desc = self.root.Node_export.desc_export
    self.pay_icon = self.root.Node_export.dia_heal_btn.pay_icon_export
    self.num = self.root.Node_export.dia_heal_btn.num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_heal_btn, function(sender, eventType) self:onSure(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.all_slt_btn, function(sender, eventType) self:onCancel(sender, eventType) end)
--EXPORT_NODE_END
end

function UIPromptUpgradePanel:setData(param,callFunc)
    self.callback = callFunc

    self.modalEnabled = true

    for i=1,4 do
        self["res"..i]:setVisible(false)
    end
    local idx = 1
    for id,v in pairs(param.res) do
        self["res"..idx]:setVisible(true)
        self["res"..idx].num:setString(v)
        local itemData = global.luaCfg:get_item_by(id)
        self["res"..idx].desc:setString(itemData.itemName)
        global.tools:adjustNodePos(self["res"..idx].desc, self["res"..idx].num)
        idx = idx+1
    end
    uiMgr:setRichText(self,"desc",50263,{key1 = param.totalcost})

    self.num:setString(param.totalcost)

    self.m_enough = global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,param.totalcost)
    if not self.m_enough then
        self.num:setTextColor(gdisplay.COLOR_RED)
    else
        self.num:setTextColor(cc.c3b(255, 184, 34))
    end
end

function UIPromptUpgradePanel:setPanelExitCallFun(exitcall)
    self.PanelExitcall =   exitcall 
end  

function UIPromptUpgradePanel:setPanelonExitCallFun(call)
    self.PanelOnExitcall =   call 
end

function UIPromptUpgradePanel:onEnter()
    self.PanelOnExitcall = nil
    self.PanelExitcall = nil
    self.m_cancelCall = nil
    self.callback = nil
end

function UIPromptUpgradePanel:onExit()
end

function UIPromptUpgradePanel:setCancelCall(call)
    self.m_cancelCall = call
    return self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPromptUpgradePanel:onSure(sender, eventType)
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_confirm")
    global.panelMgr:closePanel("UIPromptUpgradePanel")
    if not self.m_enough then
        global.tipsMgr:showWarning("ItemUseDiamond")
        return 
    end
    if self.callback then self.callback() end
end

function UIPromptUpgradePanel:onCancel(sender, eventType)
    if self.PanelExitcall then 
         self.PanelExitcall()
    end 

    if self.m_cancelCall then 
        self.m_cancelCall() 
    end
    global.panelMgr:closePanelForBtn("UIPromptUpgradePanel")    
end

function UIPromptUpgradePanel:exit(sender, eventType)
    if self.PanelExitcall then 
         self.PanelExitcall()
    end 
    global.panelMgr:closePanel("UIPromptUpgradePanel")
end
--CALLBACKS_FUNCS_END

return UIPromptUpgradePanel

--endregion

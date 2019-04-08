--region UIDiamondBankItem.lua
--Author : yyt
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDiamondBankItem  = class("UIDiamondBankItem", function() return gdisplay.newWidget() end )

function UIDiamondBankItem:ctor()
    self:CreateUI()
end

function UIDiamondBankItem:CreateUI()
    local root = resMgr:createWidget("diamond_bank/bank_node")
    self:initUI(root)
end

function UIDiamondBankItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diamond_bank/bank_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Button_5.Node_export
    self.num = self.root.Button_5.Node_export.num_export
    self.numGray = self.root.Button_5.Node_export.numGray_export
    self.per = self.root.Button_5.Node_export.per_export
    self.day = self.root.Button_5.Node_export.day_export
    self.light = self.root.Button_5.Node_export.light_export
    self.icon = self.root.Button_5.Node_export.icon_export
    self.trigger = self.root.Button_5.trigger_export

    uiMgr:addWidgetTouchHandler(self.root.Button_5, function(sender, eventType) self:clickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.root.Button_5:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDiamondBankItem:setData(data)
    -- body
    self.data = data
    local curBankInfo = global.propData:getBankInfoById(data.type)
    if not curBankInfo then return end
    self.curBankInfo = curBankInfo

    self.num:setString(data.interest)
    self.day:setString(data.day)
    self.per:setPositionX(self.num:getPositionX()+self.num:getContentSize().width)
    global.panelMgr:setTextureFor(self.icon, data.icon)
    self.light:setScale(data.lightScale/100)
    self.trigger:setVisible(false)

    self.num:setVisible(true)
    self.numGray:setVisible(false)
    global.colorUtils.turnGray(self.Node, false)
    if data.target and data.target > 0 and curBankInfo.lState == -1 then
        global.colorUtils.turnGray(self.Node, true)
        self.trigger:setVisible(true)
        self.trigger:setString(global.luaCfg:get_target_condition_by(data.target).description)
        self.numGray:setVisible(true)
        self.num:setVisible(false)
    end

end

function UIDiamondBankItem:clickHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIDiamondBankPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        if self.data.target and self.data.target > 0 and self.curBankInfo.lState == -1 then
            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10910, target=4})
            return
        end 
        global.panelMgr:openPanel("UIDiamondSave"):setData(self.data)

    end

end
--CALLBACKS_FUNCS_END

return UIDiamondBankItem

--endregion

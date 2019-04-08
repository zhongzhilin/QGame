--region UIMonthCardInfoPanel.lua
--Author : anlitop
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonthCardInfoPanel  = class("UIMonthCardInfoPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIMonthCardItemCell = require("game.UI.monthCard.UIMonthCardItemCell")


function UIMonthCardInfoPanel:ctor()
    self:CreateUI()
end

function UIMonthCardInfoPanel:CreateUI()
    local root = resMgr:createWidget("month_card_ui/monthcardinfopanel")
    self:initUI(root)
end

function UIMonthCardInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "month_card_ui/monthcardinfopanel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.buyBtn = self.root.Node_export.bg.buyBtn_export
    self.price = self.root.Node_export.bg.buyBtn_export.price_export
    self.name = self.root.Node_export.bg.name_export
    self.tableviewaddnode = self.root.Node_export.bg.tableviewaddnode_export_0
    self.tableviewcontent = self.root.Node_export.tableviewcontent_export
    self.tableviewitemcontent = self.root.Node_export.tableviewitemcontent_export
    self.tableviewtop = self.root.Node_export.tableviewtop_export
    self.tableviewbottom = self.root.Node_export.tableviewbottom_export

    uiMgr:addWidgetTouchHandler(self.root.mode, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buyBtn, function(sender, eventType) self:onBuy(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
    :setSize(self.tableviewcontent:getContentSize())
    :setCellSize(self.tableviewitemcontent:getContentSize())
    :setCellTemplate(UIMonthCardItemCell)
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(1)
    self.tableviewaddnode:addChild(self.tableView)


    local  tips_node = cc.Node:create()
    self:addChild(tips_node,99)
    self.tips_node = tips_node

end

function UIMonthCardInfoPanel:setData(data)

    if not data then return end 

    self.data = data 
    
    local dropData = global.luaCfg:get_drop_by(self.data.dropid).dropItem  

    if not dropData then return end 

    for _ ,v in pairs(dropData) do 
        v.panel = self
    end 

    self.tableView:setData(dropData)

    self.price:setString(self.data.unit..self.data.cost)
    self.name:setString(self.data.name)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMonthCardInfoPanel:exitCall(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMonthCardInfoPanel") 
end

function UIMonthCardInfoPanel:onBuy(sender, eventType)

    local buyCall = function(call)
        global.sdkBridge:app_sdk_pay(self.data.id,function()
            if call then 
                call() 
            end 
            global.tipsMgr:showWarning(global.luaCfg:get_local_string(10462, self.data.name))
            if self.exitCall then 
                self:exitCall()
            end 
        end)
    end

    if  self.data.serverData and  self.data.serverData.lState >=0 then 

        local errcode = ""

        if self.data.receive_time > 7 then 

            errcode ="WEEK_CARD_RENEW_4"
        else 
            errcode ="WEEK_CARD_RENEW_1"
        end 

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData(errcode, function()
            buyCall()
        end)
    else 
        buyCall(function ()
            if self.data.serverData and self.data.serverData.lState == -1 then 
               global.rechargeData:refershMonthCard(self.data.id)
            end 
        end)
    end

end
--CALLBACKS_FUNCS_END

return UIMonthCardInfoPanel

--endregion

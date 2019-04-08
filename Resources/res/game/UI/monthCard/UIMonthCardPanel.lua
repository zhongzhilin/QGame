--region UIMonthCardPanel.lua
--Author : yyt
--Date   : 2017/03/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local rechargeData = global.rechargeData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIMonthCardPanel  = class("UIMonthCardPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIMonthCell = require("game.UI.monthCard.UIMonthCell")

function UIMonthCardPanel:ctor()
    self:CreateUI()
end

function UIMonthCardPanel:CreateUI()
    local root = resMgr:createWidget("month_card_ui/month_card_Scene")
    self:initUI(root)
end

function UIMonthCardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "month_card_ui/month_card_Scene")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.adpat = self.root.adpat_export
    self.table_node = self.root.table_node_export
    self.top = self.root.top_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.top_bg = self.root.top_bg_export
    self.FileNode_1 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.title_node = self.root.title_node_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIMonthCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self.adpat:setContentSize(cc.size(self.adpat:getContentSize().width, 960+gdisplay.height-1280))

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIMonthCardPanel:tableMove()
    self.isStartMove = true
end

function UIMonthCardPanel:onEnter()

    if _NO_RECHARGE then 
        global.panelMgr:closePanel("UIMonthCardPanel")
        return global.tipsMgr:showWarning("FuncNotFinish")
    end 

    self.top_bg:setVisible(true) 
    self.FileNode_1:setVisible(false)

    self.isStartMove = false
    global.loginApi:clickPointReport(nil,16,nil,nil)

    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE, function ()
        if self.setData then
            self:setData(true)
        end
    end)

    self:setData()

end
    
function UIMonthCardPanel:setData(isNotify)

    local data = {}
    local list = {87, 88, 25, 27,}
    for i,v in ipairs(list) do
        local giftConfig = luaCfg:get_gift_by(v)
        table.insert(data, giftConfig)
    end
    self.tableView:setData(data, isNotify)

end

function UIMonthCardPanel:changeMode()
    self.top_bg:setVisible(false) 
    self.FileNode_1:setVisible(true)
end

function UIMonthCardPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMonthCardPanel")  
end

--CALLBACKS_FUNCS_END

return UIMonthCardPanel

--endregion

--region UIBankRecodePanel.lua
--Author : yyt
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBankRecodePanel  = class("UIBankRecodePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIBankRecodeCell = require("game.UI.diamondBank.UIBankRecodeCell")

function UIBankRecodePanel:ctor()
    self:CreateUI()
end

function UIBankRecodePanel:CreateUI()
    local root = resMgr:createWidget("diamond_bank/diamong_bank_record")
    self:initUI(root)
end

function UIBankRecodePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diamond_bank/diamong_bank_record")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_16_export
    self.topNode = self.root.topNode_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.tbNode = self.root.tbNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIBankRecodeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBankRecodePanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_BANK_RECODE, function ()
        if self.setData then
            self:setData()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()  
        if self.setData then
            self:setData()
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()  
        if self.setData then
            self:setData()
        end   
    end)

    self:setData()
end
function UIBankRecodePanel:setData()

    global.itemApi:bankAction(function (msg)
        -- body
        msg.tagMoneySave = msg.tagMoneySave or {}
        if table.nums(msg.tagMoneySave) > 0 then
            table.sort(msg.tagMoneySave, function(s1, s2) return s1.lEndTime < s2.lEndTime end)
        end
        self.tableView:setData(msg.tagMoneySave)
    end, 1, 0, 0)
end

function UIBankRecodePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIBankRecodePanel")
end

--CALLBACKS_FUNCS_END

return UIBankRecodePanel

--endregion

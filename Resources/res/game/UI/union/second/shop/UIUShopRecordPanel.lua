--region UIUShopRecordPanel.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUShopRecordPanel  = class("UIUShopRecordPanel", function() return gdisplay.newWidget() end )

function UIUShopRecordPanel:ctor()
    self:CreateUI()
end

function UIUShopRecordPanel:CreateUI()
    local root = resMgr:createWidget("union/union_show_info_bj")
    self:initUI(root)
end

function UIUShopRecordPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_show_info_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.node_tableView = self.root.Node_export.node_tableView_export
    self.contentLayout = self.root.Node_export.contentLayout_export
    self.itemLayout = self.root.Node_export.itemLayout_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
--EXPORT_NODE_END
    local UITableView = require("game.UI.common.UITableView")
    local UIUShopRecordCell = require("game.UI.union.second.shop.UIUShopRecordCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUShopRecordCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUShopRecordPanel:onEnter()
    self.tableView:setData({})
    self:refresh()
end

function UIUShopRecordPanel:setData(data)
    self.tableView:setData(data)
end

function UIUShopRecordPanel:refresh()
    local function callback(msg)
        local allShop = luaCfg:union_shop()
        local res = {}
        for _,v in ipairs(msg.tgShopLog or {}) do
            if allShop[v.lID] then
                table.insert(res,v)
            end
        end

        self.data = res

        table.sort(self.data, function(a,b)
            -- body
            return a.lTime > b.lTime
        end )
        self:setData(self.data)
    end
    global.unionApi:getAllyBuyRecordList(callback)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUShopRecordPanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUShopRecordPanel")
end
--CALLBACKS_FUNCS_END

return UIUShopRecordPanel

--endregion

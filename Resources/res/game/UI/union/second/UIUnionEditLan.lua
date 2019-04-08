--region UIUnionEditLan.lua
--Author : wuwx
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionEditLan  = class("UIUnionEditLan", function() return gdisplay.newWidget() end )

function UIUnionEditLan:ctor()
    self:CreateUI()
end

function UIUnionEditLan:CreateUI()
    local root = resMgr:createWidget("union/union_language_bj")
    self:initUI(root)
end

function UIUnionEditLan:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_language_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.itemLayout = self.root.Node_export.itemLayout_export
    self.contentLayout = self.root.Node_export.contentLayout_export
    self.node_tableView = self.root.Node_export.node_tableView_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:onSave(sender, eventType) end)
--EXPORT_NODE_END
    local UITableView = require("game.UI.common.UITableView")
    local UIUnionEditLanCell = require("game.UI.union.list.UIUnionEditLanCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize())
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionEditLanCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end


function UIUnionEditLan:onEnter()
    self.data = clone(global.luaCfg:union_languages())
    self.m_lanId = global.unionData:getInUnionLanId()
    self:setData()
end

function UIUnionEditLan:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
end

function UIUnionEditLan:setData(noReset)
    for i,v in pairs(self.data) do
        if v.id == self.m_lanId then
            v.isSelected = true
        else
            v.isSelected = false
        end
    end
    if noReset then
        self.tableView:update(self.data)
    else
        self.tableView:setData(self.data)
    end
end

function UIUnionEditLan:getLanId()
    return self.m_lanId
end

function UIUnionEditLan:setLanId(id,noReset)
    self.m_lanId = id
    self:setData(noReset)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionEditLan:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUnionEditLan")
end

function UIUnionEditLan:onSave(sender, eventType)
    global.unionApi:setAllyUpdate({lLanguage=self.m_lanId,lUpdateID={6}}, function()
        global.tipsMgr:showWarning("UnionLanguage01")
        global.panelMgr:closePanel("UIUnionEditLan")
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionEditLan

--endregion

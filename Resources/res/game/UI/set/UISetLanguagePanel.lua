--region UISetLanguagePanel.lua
--Author : yyt
--Date   : 2017/03/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UISetLanguagePanel  = class("UISetLanguagePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UISetLanguageCell = require("game.UI.set.UISetLanguageCell")

function UISetLanguagePanel:ctor()
    self:CreateUI()
end

function UISetLanguagePanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_language")
    self:initUI(root)
end

function UISetLanguagePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_language")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.FileNode_1 = UISetTIme.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.table_node = self.root.table_node_export
    self.top = self.root.top_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UISetLanguageCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISetLanguagePanel:onEnter()
    
    self:setData()
end

function UISetLanguagePanel:setData()
    
    self.data = self:getLanguage()
    self.tableView:setData(self.data)
end

function UISetLanguagePanel:getLanguage()

    local curLanguage = global.languageData:getCurrentLanguage()
    
    local data = {}
    local language = global.luaCfg:languages()
    for _,v in pairs(language) do
        if v.open == 1 then
            if curLanguage == v.symbol then
                v.selectState = 1
            else
                v.selectState = 0
            end
            table.insert(data, v)
        end
    end
    table.sort(data, function(s1,s2) return s1.id < s2.id end)
    return data
end

function UISetLanguagePanel:refersh(id)
    
    for _,v in pairs(self.data) do
        if v.id == id then
            v.selectState = 1
        else
            v.selectState = 0
        end
    end
    self.tableView:setData(self.data, true)
end

function UISetLanguagePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UISetLanguagePanel")  
end

--CALLBACKS_FUNCS_END

return UISetLanguagePanel

--endregion

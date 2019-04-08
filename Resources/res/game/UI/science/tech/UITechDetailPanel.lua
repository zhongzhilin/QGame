--region UITechDetailPanel.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechDetailPanel  = class("UITechDetailPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UITechDetailCell = require("game.UI.science.tech.UITechDetailCell")

function UITechDetailPanel:ctor()
    self:CreateUI()
end

function UITechDetailPanel:CreateUI()
    local root = resMgr:createWidget("science/tech_detail_info_bg")
    self:initUI(root)
end

function UITechDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_detail_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.science_name = self.root.Node_export.science_name_export
    self.effect = self.root.Node_export.effect_export
    self.bottomNode = self.root.Node_export.bottomNode_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.table_node = self.root.Node_export.table_node_export
    self.topNode = self.root.Node_export.topNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UITechDetailCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITechDetailPanel:setData(techId)
    
    self.science_name:setString(luaCfg:get_science_by(techId).name)
    self.effect:setString(luaCfg:get_science_by(techId).des)

    local data = {}
    local lvData = luaCfg:science_lvup()
    for _,v in pairs(lvData) do
        if v.id == techId then
            table.insert(data, v)
        end
    end
    table.sort(data, function (s1, s2)  return s1.lv < s2.lv end)
    self.tableView:setData(data)
end

function UITechDetailPanel:exitCall(sender, eventType)
    
    global.panelMgr:closePanel("UITechDetailPanel")

end
--CALLBACKS_FUNCS_END

return UITechDetailPanel

--endregion

--region UITurntablePool.lua
--Author : yyt
--Date   : 2018/12/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntablePool  = class("UITurntablePool", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UITurntableHeroCell = require("game.UI.turnable.UITurntableHeroCell")

function UITurntablePool:ctor()
    self:CreateUI()
end

function UITurntablePool:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_random_item")
    self:initUI(root)
end

function UITurntablePool:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_random_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.tableView_size = self.root.Node_export.tableView_size_export
    self.cell = self.root.Node_export.tableView_size_export.cell_export
    self.tableviewnode = self.root.Node_export.tableviewnode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.tableView_size:getContentSize())
        :setCellSize(self.cell:getContentSize())
        :setCellTemplate(UITurntableHeroCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(5)

    self.tableviewnode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITurntablePool:setData(data)

    local temp = {}
    for k,v in pairs(global.luaCfg:turntable_hero_reward()) do
        if v.pos == data.pos then
            local item = clone(v)
            item.isPool = true
            table.insert(temp, item)
        end
    end
    table.sort(temp, function(s1, s2) return s1.id < s2.id end)
    self.tableView:setData(temp)

end

function UITurntablePool:exit_call(sender, eventType)
    global.panelMgr:closePanel("UITurntablePool")
end
--CALLBACKS_FUNCS_END

return UITurntablePool

--endregion

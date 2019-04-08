--region UIUnLockFunPanel.lua
--Author : yyt
--Date   : 2017/08/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIUnLockFunPanel  = class("UIUnLockFunPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIUnLockFunItemCell = require("game.UI.commonUI.UIUnLockFunItemCell")

function UIUnLockFunPanel:ctor()
    self:CreateUI()
end

function UIUnLockFunPanel:CreateUI()
    local root = resMgr:createWidget("common/city_lvup_tips_bg")
    self:initUI(root)
end

function UIUnLockFunPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/city_lvup_tips_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.des = self.root.Node_export.bg_export.des_export
    self.lv = self.root.Node_export.bg_export.lv_export
    self.close_noe = self.root.Node_export.bg_export.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.Node_export.bg_export.close_noe_export)
    self.topNode = self.root.Node_export.Node_11.topNode_export
    self.tbSize = self.root.Node_export.Node_11.tbSize_export
    self.cellSize = self.root.Node_export.Node_11.cellSize_export
    self.bottomNode = self.root.Node_export.Node_11.bottomNode_export
    self.tbNode = self.root.Node_export.Node_11.tbNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UIChatTableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIUnLockFunItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

    self.close_noe:setData(function () 
        global.panelMgr:closePanelForBtn("UIUnLockFunPanel")
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnLockFunPanel:setData(cityData, curCityLv, nextLvData)

    self.lv:setString(curCityLv)

    self.root:stopAllActions()
    if nextLvData then
        self.Node.Node_11.Node_Effect:setVisible(false)
        self.des:setString(global.luaCfg:get_local_string(10780))
    else
        self.root:stopAllActions()
        self.Node.Node_11.Node_Effect:setVisible(true)
        self.des:setString(global.luaCfg:get_local_string(10779))
        local nodeTimeLine = resMgr:createTimeline("common/city_lvup_tips_bg")
        nodeTimeLine:setTimeSpeed(0.5)
        nodeTimeLine:play("animation0", false)
        self.root:runAction(nodeTimeLine)
    end

    local data = {}
    local insertCall = function (lvData, nextLv)
        -- body
        for i=1,lvData.maxNum do
            local temp = {}
            temp.name = lvData["func"..i]
            temp.icon = lvData["icon"..i]
            temp.des  = lvData["func"..i.."Des"]
            temp.scale = lvData["scale"..i] 
            temp.posY  = lvData["posY"..i]
            temp.nextLv = nextLv 
            temp.curLv  = lvData.lv
            temp.maxNum = lvData.maxNum 
            temp.index = i
            if temp.name ~= "" then
                local cellData = {}
                cellData.cellW = self.cellSize:getContentSize().width
                cellData.cellH = self.cellSize:getContentSize().height
                cellData.titleH = 0
                if i == 1 then   
                    -- 特殊处理
                    if nextLv and lvData.lv == 2 then
                        cellData.cellH = cellData.cellH + 65
                        cellData.titleH = 30
                    else
                        if nextLv and lvData.maxNum == 0 then
                            cellData.titleH = 15
                        end
                        if nextLv and lvData.maxNum > 0 then
                            cellData.cellH = cellData.cellH + 35
                        else
                            cellData.cellH = cellData.cellH + 60
                        end
                    end
                end
                cellData.cdata = temp
                table.insert(data, cellData)
            end
        end
    end

    -- 当前等级之前的解锁内容
    if nextLvData then
        local cfgData = luaCfg:city_lvup()
        for i,v in ipairs(cfgData) do
            if i < curCityLv then
                insertCall(v, nil)
            end
        end
    end


    insertCall(cityData, nil)
    if nextLvData then
        insertCall(nextLvData, nextLvData.lv)
    end

    self.tableView:setData(data)
    self:gpsTitle(curCityLv)
end

function UIUnLockFunPanel:gpsTitle(curCityLv)
    -- body

    local curIndex = 0
    local tableData = self.tableView:getData()
    for index,v in ipairs(tableData) do
        if v.cdata.curLv == curCityLv then
            curIndex = #tableData-index+1
            self.tableView:jumpToCellYByIdx(curIndex, true)
            break
        end
    end

    if curCityLv < 3 then 
        return 
    end
    local itemTitlePosY = 0
    local allCell = self.tableView:getCells()
    for k,cell in pairs(allCell) do
        if cell.tv_target and cell.tv_target.item then
            local item = cell.tv_target.item
            local data = item.data
            if data.cdata.curLv == curCityLv and data.cdata.index == 1 then
                itemTitlePosY = item.curLvTitle:convertToWorldSpace(cc.p(0, 0)).y
            end
        end
    end

    local offsetY = self.topNode:convertToWorldSpace(cc.p(0, 0)).y - itemTitlePosY
    self.tableView:jumpToCellYByIdx(curIndex, true, offsetY)

end

function UIUnLockFunPanel:exit(sender, eventType)
    global.panelMgr:closePanel("UIUnLockFunPanel")
end
--CALLBACKS_FUNCS_END

return UIUnLockFunPanel

--endregion

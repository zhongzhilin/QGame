--region UICollectListPanel.lua
--Author : yyt
--Date   : 2016/11/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UITableView = require("game.UI.common.UITableView")
local TabControl = require("game.UI.common.UITabControl")
local UICollectItemCell = require("game.UI.world.widget.UICollectItemCell")
local UICollectTableView = require("game.UI.world.widget.UICollectTableView")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICollectListPanel  = class("UICollectListPanel", function() return gdisplay.newWidget() end )

function UICollectListPanel:ctor()
    self:CreateUI()
end

function UICollectListPanel:CreateUI()
    local root = resMgr:createWidget("world/mark_list")
    self:initUI(root)
end

function UICollectListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mark_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleNode = self.root.titleNode_export
    self.buttonList = self.root.buttonList_export
    self.tableSize = self.root.tableSize_export
    self.topNode = self.root.topNode_export
    self.itemSize = self.root.itemSize_export
    self.tableViewNode = self.root.tableViewNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.tabControl = TabControl.new(self.buttonList, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.tableView = UICollectTableView.new()
        :setSize(self.tableSize:getContentSize(),self.topNode)
        :setCellSize(self.itemSize:getContentSize())
        :setCellTemplate(UICollectItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tableViewNode:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICollectListPanel:setData(index, flag)

    if flag and flag == -1 then
        index = self:checkItem(index)
    end
	self.tabControl:setSelectedIdx(index)
    self:onTabButtonChanged(index)
end

function UICollectListPanel:checkItem( index )
    
    for i=1,3 do
        local data = global.collectData:getCollectByKind(i - 1)
        if data and (#data) > 0 then
            return i
        end
    end
    return index
end

function UICollectListPanel:checkIsOutOffset(contentOffset)
    
    local minOffset = self.tableView:minContainerOffset()    
    if contentOffset.y > 0 then contentOffset.y = 0 end
    if contentOffset.y < minOffset.y then contentOffset.y = minOffset.y end
    self.tableView:setContentOffset(contentOffset, false)
end

function UICollectListPanel:showUse(sort,isHide)
    -- body
    local cellSize = global.collectData:getCellSize()
    local preOff = self.tableView:getContentOffset()

    if isHide then        
        self.tableView:chooseItem(-1)
    else
        if self.tableView:getChooseSort() ~= -1 then
            preOff.y = preOff.y + cellSize
        end
        self.tableView:chooseItem(sort)
    end

    self.tableView:reloadData()

    if isHide then
        preOff.y = preOff.y + cellSize
        self.tableView:setContentOffset(preOff,false)
    else
        preOff.y = preOff.y - cellSize
        self.tableView:setContentOffset(preOff,false)
    end
    self:checkIsOutOffset(preOff)
end

function UICollectListPanel:onTabButtonChanged(index)

    self.tableView:chooseItem(-1)
    local data = global.collectData:getCollectByKind(index - 1)
    self.tableView:setData(data)
end

function UICollectListPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UICollectListPanel")
    self.tableView:chooseItem(-1)
end

--CALLBACKS_FUNCS_END

return UICollectListPanel

--endregion

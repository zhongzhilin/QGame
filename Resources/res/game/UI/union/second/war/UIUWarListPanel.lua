--region UIUWarListPanel.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarListPanel  = class("UIUWarListPanel", function() return gdisplay.newWidget() end )

function UIUWarListPanel:ctor()
    self:CreateUI()
end

function UIUWarListPanel:CreateUI()
    local root = resMgr:createWidget("union/union_battle_bj")
    self:initUI(root)
end

function UIUWarListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.node_tableView = self.root.node_tableView_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.no = self.root.no_mlan_36_export

    uiMgr:addWidgetTouchHandler(self.root.btn_bj.establish, function(sender, eventType) self:recordHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIUWarListCell = require("game.UI.union.second.war.UIUWarListCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUWarListCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    --保证纵向滑动时横向不动
    self.tableView:setDidScrollCall(function(tableView, idx)
        -- body
        if tableView.scrollAction then
            tableView:getParent():stopAction(tableView.scrollAction)
            tableView.scrollAction = nil
        end
        for _,v in pairs(self.list) do
            for __,vv in ipairs(v) do
                if not tolua.isnull(vv) then
                    vv:setTouchEnabled(false)
                end
            end
        end
        tableView.scrollAction = tableView:getParent():runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function() 
            for _,v in pairs(self.list) do
                for __,vv in ipairs(v) do
                    if not tolua.isnull(vv) then
                        vv:setTouchEnabled(true)
                    end
                end
            end
            tableView.scrollAction = nil
        end)))
    end)

end

function UIUWarListPanel:setScroll(can)
    self.tableView:setTouchEnabled(can)
end

function UIUWarListPanel:addTableViewList(id,t)
    self.list = self.list or {}
    self.list[id] = t
end


function UIUWarListPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end
function UIUWarListPanel:onEnter()
    self.m_eventListenerCustomList = {}
    self:setData()
    global.unionData:initWar()
end

function UIUWarListPanel:setData()
    self.list = {}
    self.tableView:setData({})

    self:addEventListener(global.gameEvent.EV_ON_UNION_WAR_REFRESH, function(event,isForce)
        if isForce then
            global.unionData:initWar(true)
        else
            self:refresh()
        end
    end)

    local function onResume()
        global.unionData:initWar(true)
    end
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, onResume)
end

function UIUWarListPanel:getTableViewData()
    local goData = {
        [1] = { file="UIUWarListItemA",h=260},--单人
        [2] = { file="UIUWarListItemH",h=355},--多人
    }

    local data = {}
    local wars = global.unionData:getWar()
    for i,v in ipairs(wars) do
        local itemData = v
        if v.lStatus == 1 then
            itemData.uiData = goData[2]
        else
            itemData.uiData = goData[1]
        end
        table.insert(data,itemData)
    end
    return data
end

function UIUWarListPanel:refresh()
    local data = self:getTableViewData()
    self.no:setVisible(#data<=0)
    self.tableView:setData(data)

    local logData = data
    if logData then
        local data = {}
        for i,v in pairs(logData) do
            if v.tgAtkUser then
                for ii,vv in pairs(v.tgAtkUser) do
                    if vv.szCustomIco and vv.szCustomIco ~= "" then
                        table.insert(data,vv.szCustomIco)
                    end
                end
            end
            if v.tgDefUser then
                for ii,vv in pairs(v.tgDefUser) do
                    if vv.szCustomIco and vv.szCustomIco ~= "" then
                        table.insert(data,vv.szCustomIco)
                    end
                end
            end
        end
        
        local storagePath = global.headData:downloadPngzips(data)
        table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
            -- body
            if self and not tolua.isnull(self.tableView) then
                self.tableView:setData(self.tableView:getData(),true)
            end
        end))
    end
end

function UIUWarListPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUWarListPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarListPanel:recordHandler(sender, eventType)
    global.panelMgr:openPanel("UIUWarRecordsPanel")
end
--CALLBACKS_FUNCS_END

return UIUWarListPanel

--endregion
